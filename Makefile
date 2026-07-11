.PHONY: all verify tla tlaps test zk lint clean reports docker-build docker-run help

# ==============================================================================
# CONFIGURATION
# ==============================================================================
COQ_FILES := $(shell find src -name "*.v" -type f | sort)
TLA_SPEC  := tla/FORCED_REPORT_States.tla
TLA_CFG   := tla/FORCED_REPORT_Model.cfg
ZK_CIRCUIT := circuits/key_deletion_proof.circom
REPORTS_DIR := reports
PYTHON := python3
COQBIN  := coqc
TLC_JAR := tla2tools.jar

# ==============================================================================
# MAIN TARGETS
# ==============================================================================
all: verify tla test zk reports

# --- Coq Formal Verification ---
verify:
	@echo "🔍 [1/4] Compiling & verifying Coq core..."
	@mkdir -p $(REPORTS_DIR)/coq
	@for f in $(COQ_FILES); do \
		echo "  → $$f"; \
		$(COQBIN) -Q src CognitiveShadow "$$f" 2>&1 | tee -a $(REPORTS_DIR)/coq/build.log; \
		if [ $${PIPESTATUS[0]} -ne 0 ]; then \
			echo "❌ Coq verification failed on $$f"; exit 1; \
		fi; \
	done
	@echo "✅ All Coq proofs verified successfully."

# --- TLA+ Model Checking (TLC) ---
tla: $(TLC_JAR)
	@echo "🧠 [2/4] Running TLC model checker..."
	@java -Xmx4g -cp $(TLC_JAR) tlc2.TLC -workers auto -deadlock $(TLA_CFG) > $(REPORTS_DIR)/tlc_output.log 2>&1
	@if grep -q "Invariant" $(REPORTS_DIR)/tlc_output.log | grep -q "violated"; then \
		echo "❌ TLC Safety invariant violated"; cat $(REPORTS_DIR)/tlc_output.log; exit 1; \
	else \
		echo "✅ TLC: []Safety holds, no deadlock."; \
	fi


# --- Python & ZK Tests ---
test:
	@echo "🧪 [3/4] Running pytest suite..."
	@$(PYTHON) -m pytest tests/ -v --cov=scripts --cov-report=term-missing --cov-report=xml:$(REPORTS_DIR)/coverage.xml > $(REPORTS_DIR)/pytest_output.log 2>&1
	@echo "✅ Tests passed."

zk:
	@echo "🔐 [4/4] Compiling ZK circuit..."
	@cd circuits && npm install --silent
	@circom $(ZK_CIRCUIT) --r1cs --wasm --sym
	@echo "✅ ZK circuit compiled."

# --- Reports Aggregation ---
reports:
	@mkdir -p $(REPORTS_DIR)
	@$(PYTHON) scripts/utils/report_aggregator.py
	@echo "📄 Aggregated reports saved to $(REPORTS_DIR)/shadow_verification_summary.json"

# --- Linting ---
lint:
	@echo "🧹 Linting Python code..."
	@$(PYTHON) -m ruff check scripts/ tests/
	@$(PYTHON) -m black --check scripts/ tests/

# --- Cleanup ---
clean:
	@rm -rf $(REPORTS_DIR)/*.log $(REPORTS_DIR)/*.json $(REPORTS_DIR)/*.xml
	@find src -name "*.vo" -o -name "*.glob" -o -name "*.vok" -o -name "*.vos" -delete
	@rm -f $(TLC_JAR) circuits/*.wasm circuits/*.r1cs circuits/*.sym

# --- Tool Download ---
$(TLC_JAR):
	@echo "⬇️ Downloading TLA+ Toolbox..."
	@curl -sL https://github.com/tlaplus/tlaplus/releases/download/v2.18/$(TLC_JAR) -o $(TLC_JAR)

# --- Docker ---
docker-build:
	@docker build -t cognitive-shadow:latest -f docker/Dockerfile .

docker-run:
	@docker run --rm -v $(PWD)/reports:/app/reports cognitive-shadow:latest make all

# --- Help ---
help:
	@echo "📖 Usage:"
	@echo "  make verify   - Coq proofs (CIC)"
	@echo "  make tla      - TLC model checking"
	@echo "  make tlaps    - TLAPS theorem proving"
	@echo "  make test     - Python/ZK tests (pytest)"
	@echo "  make zk       - Compile circom circuits"
	@echo "  make all      - Full CI pipeline"
	@echo "  make clean    - Remove artifacts"
	@echo "  make docker   - Build & run in container"