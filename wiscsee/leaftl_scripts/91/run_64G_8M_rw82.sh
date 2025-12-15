#!/bin/bash
set -e

# 固定脚本所在目录（关键）
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# PATH
export PATH="$PATH:$SCRIPT_DIR/../pypy2.7-v7.3.9-linux64/bin"

# 输出目录
OUT_DIR="$SCRIPT_DIR/../raw_results/memory_batch/91"

# 确保输出目录存在 (可选)
# mkdir -p "$OUT_DIR"

# 执行
pypy "$SCRIPT_DIR/../run_ftl" \
    -sl 0 \
    -l 1000000000 \
    -t "$SCRIPT_DIR/../leaftl_traces/64G/rw82_57600M_zoned91_192G_200ns_shuffle_precond.trace" \
    -c 8 \
    -mc 8192 \
    -f learnedftl \
    -wo 0 \
    -q 1 \
    -p 4096 \
    -o "$OUT_DIR/test_64G_8M" \
    -cf "$SCRIPT_DIR/../config/64G.json" \
    >> "$OUT_DIR/test_64G_8M_stdout_write_rw82.txt" 2>&1
