# ==============================================================================
# Cognitive Shadow – Production Runtime (без Coq/TLA+)
# Основа: Ubuntu 22.04 LTS
# Включает: Python 3.11, Node.js 18, OpenJDK 17, Circom, Snarkjs
# ==============================================================================
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHON_VERSION=3.11 \
    NODE_VERSION=18 \
    JAVA_VERSION=17

# --- System dependencies ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git curl wget ca-certificates gnupg lsb-release \
    python${PYTHON_VERSION} python${PYTHON_VERSION}-dev python3-pip \
    openjdk-${JAVA_VERSION}-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# --- Python & ZK Toolchain ---
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# Установка Python-пакетов из pyproject.toml (основные зависимости)
COPY pyproject.toml /tmp/pyproject.toml
RUN pip3 install --no-cache-dir \
    numpy>=1.24.0 \
    pandas>=2.0.0 \
    scikit-learn>=1.3.0 \
    scipy>=1.10.0 \
    pytest>=7.4.0 \
    pytest-cov>=4.1.0 \
    hypothesis>=6.80.0 \
    prometheus-client>=0.17.0 \
    pydantic>=2.0.0 \
    typing-extensions>=4.7.0 \
    matplotlib>=3.7.0 \
    seaborn>=0.12.0

# Node.js, Circom, Snarkjs
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g circom snarkjs \
    && node --version

# --- Workspace (не копируем исходники – используем volumes в compose) ---
WORKDIR /app
COPY . /app

# --- Entrypoint (по умолчанию – make all, но можно переопределить) ---
ENTRYPOINT ["make"]
CMD ["all"]