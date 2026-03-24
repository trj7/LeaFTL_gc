#!/bin/bash
set -e
trap 'echo "Stopping..."; kill $(jobs -p) 2>/dev/null' SIGINT
MAX_JOBS=2

# trace目录
TRACE_DIR="./leaftl_traces/aliyuntest_40"

# 你的启动脚本
RUN_SCRIPT="./91/altrace_40.sh"

# 找到所有trace
TRACE_FILES=("$TRACE_DIR"/new_*.trace)

echo "Found ${#TRACE_FILES[@]} trace files."

run_job() {
    trace=$1
    echo "Starting: $trace"
    "$RUN_SCRIPT" "$trace"
}

for trace in "${TRACE_FILES[@]}"; do

    # 控制并发数
    while [ "$(jobs -rp | wc -l)" -ge "$MAX_JOBS" ]; do
        sleep 1
    done

    run_job "$trace" &

done

wait

echo "All jobs finished."