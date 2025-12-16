#!/bin/bash
set -e

# 固定脚本所在目录（关键）
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# PATH
export PATH="$PATH:$SCRIPT_DIR/../pypy2.7-v7.3.9-linux64/bin"

# 输出目录
OUT_DIR="$SCRIPT_DIR/../raw_results/memory_batch/82"

# 确保输出目录存在 (可选)
# mkdir -p "$OUT_DIR"

# 执行
pypy "$SCRIPT_DIR/../run_ftl" \
    -sl 0 \
    -l 1000000000 \
    -t "$SCRIPT_DIR/../leaftl_traces/16G/read_14400M_zoned82_32G_200ns_shuffle_precond.trace" \
    -c 8 \
    -mc 2048 \
    -f learnedftl \
    -wo 0 \
    -q 1 \
    -p 4096 \
    -o "$OUT_DIR/test_16G_2M" \
    -cf "$SCRIPT_DIR/../config/16G.json" \
    >> "$OUT_DIR/test_16G_2M_stdout_read.txt" 2>&1
