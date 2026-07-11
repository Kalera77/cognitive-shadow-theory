#!/bin/bash
EXPDIR="./experiments"
OUTDIR="./results"
mkdir -p "$OUTDIR"
echo "Starting experiments at $(date)"
for cfg in "$EXPDIR"/*.cfg; do
    [ -e "$cfg" ] || continue
    name=$(basename "$cfg" .cfg)
    logfile="$OUTDIR/${name}.log"
    echo "--------------------------------------------------"
    echo "Running experiment: $name"
    java -cp tla2tools.jar tlc2.TLC -deadlock -workers auto -config "$cfg" CognitiveShadow_Model > "$logfile" 2>&1
    if grep -q "Model checking completed. No error has been found." "$logfile"; then
        states=$(grep "states generated" "$logfile" | head -1 | awk '{print $1}')
        depth=$(grep "The depth of the complete state graph" "$logfile" | awk '{print $NF}')
        echo "  PASS ($states states, depth $depth)"
    else
        echo "  FAIL (check $logfile)"
        grep -E "Error:|Invariant.*violated" "$logfile" | head -5
    fi
done
echo "All experiments completed."