#!/bin/bash

EXPDIR="./experiments"
OUTDIR="./results"
mkdir -p "$OUTDIR"

# Команда запуска TLC
TLC_CMD="java -cp tla2tools.jar tlc2.TLC -deadlock -workers auto"

echo "Starting experiments at $(date)"
echo "--------------------------------------------------"

# Определяем список экспериментов в формате "MODEL:CONFIG"
# Для основной модели конфиги берутся из папки experiments
# Для других моделей конфиги могут лежать в корне или тоже в experiments — укажите полный путь.

EXPERIMENTS=(
    # Основная модель (CognitiveShadow_Model) со всеми конфигами из папки experiments
    "CognitiveShadow_Model:experiments/CognitiveShadow_Model.cfg"
    "CognitiveShadow_Model:experiments/deep_check.cfg"
    "CognitiveShadow_Model:experiments/full_check.cfg"
    "CognitiveShadow_Model:experiments/halt_resonance.cfg"
    "CognitiveShadow_Model:experiments/ltl_noodeadlock.cfg"
    "CognitiveShadow_Model:experiments/ltl_nostarvation.cfg"
    "CognitiveShadow_Model:experiments/metacognitive_collapse.cfg"
    "CognitiveShadow_Model:experiments/nominal.cfg"
    "CognitiveShadow_Model:experiments/quarantine_direct.cfg"
    "CognitiveShadow_Model:experiments/stress_loop.cfg"

    # Модели FORCED_REPORT (конфиги лежат в корне)
    "FORCED_REPORT_States:FORCED_REPORT_Model.cfg"
    "FORCED_REPORT_AdaptiveThreshold:FORCED_REPORT_AdaptiveThreshold.cfg"
    "FORCED_REPORT_WithAudit:FORCED_REPORT_WithAudit.cfg"

    # Модель Shadow Ethics с разными конфигами (лежат в корне)
    "ShadowEthicsInvariants:ShadowEthicsInvariants.cfg"
    "ShadowEthicsInvariants:ShadowEthicsInvariants_lowQ.cfg"
    "ShadowEthicsInvariants:ShadowEthicsInvariants_highPhi.cfg"
    "ShadowEthicsInvariants:ShadowEthicsInvariants_lowRho.cfg"
)

# Запускаем каждый эксперимент
for entry in "${EXPERIMENTS[@]}"; do
    IFS=':' read -r model config <<< "$entry"
    logfile="$OUTDIR/$(basename "$config" .cfg).log"
    echo "Running $model with $(basename "$config")"
    
    # Запуск TLC
    $TLC_CMD -config "$config" "$model" > "$logfile" 2>&1

    # Анализ результата
    if grep -q "Model checking completed. No error has been found." "$logfile"; then
        states=$(grep "states generated" "$logfile" | head -1 | awk '{print $1}')
        depth=$(grep "The depth of the complete state graph" "$logfile" | awk '{print $NF}')
        echo "  ✅ PASS ($states states, depth $depth)"
    else
        echo "  ❌ FAIL (check $logfile)"
        grep -E "Error:|Invariant.*violated" "$logfile" | head -5
    fi
    echo "--------------------------------------------------"
done

echo "All experiments completed at $(date)"