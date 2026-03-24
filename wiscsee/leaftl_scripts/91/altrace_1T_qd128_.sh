#!/bin/bash
set -e

# 检查参数
if [ -z "$1" ]; then
    echo "Usage: $0 <trace_file>"
    exit 1
fi

TRACE_FILE="$1"
TRACE_NAME=$(basename "$TRACE_FILE" .trace)

# 固定脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# PATH
export PATH="$PATH:$SCRIPT_DIR/../pypy2.7-v7.3.9-linux64/bin"

# 输出目录
OUT_DIR="$SCRIPT_DIR/../raw_results/memory_batch/altrace_1T"

# 执行
pypy "$SCRIPT_DIR/../run_ftl" \
    -sl 0 \
    -l 1000000000 \
    -t "$TRACE_FILE" \
    -c 8 \
    -mc 128000 \
    -f learnedftl \
    -wo 0 \
    -q 128 \
    -p 4096 \
    -o "$OUT_DIR/${TRACE_NAME}"\
    -cf "$SCRIPT_DIR/../config/1T.json" \
    >> "$OUT_DIR/${TRACE_NAME}_stdout.txt" 2>&1
