#!/bin/bash

MAX_JOBS=3
KEYWORD="_64G_8M_rw55"
FOLDERS=("91")
LOG_DIR="./logs"

mkdir -p "$LOG_DIR"
shopt -s nullglob

# --- 安全机制：脚本退出或被中断(Ctrl+C)时，杀掉所有子进程 ---
trap 'echo "Script interrupted. Killing background jobs..."; kill $(jobs -p) 2>/dev/null; exit' SIGINT SIGTERM EXIT

job_count=0

echo "Starting execution with MAX_JOBS=$MAX_JOBS..."

for folder in "${FOLDERS[@]}"; do
    for script in "$folder"/*"$KEYWORD"*.sh; do
        [[ -f "$script" ]] || continue
        
        name="${folder}_$(basename "$script" .sh)"
        echo "Launching $script ..."

        # 后台运行
        bash "$script" > "$LOG_DIR/$name.log" 2>&1 &
        
        # 增加计数器
        ((job_count++))

        # 如果达到最大并发数，等待任意一个任务结束
        if (( job_count >= MAX_JOBS )); then
            wait -n
            # 这里的逻辑是：wait -n 返回意味着至少有一个结束了
            # 所以释放一个槽位
            ((job_count--))
        fi
    done
done

# --- 优化：等待剩余的所有后台任务结束 ---
wait

# 解除 trap，避免正常退出时打印 "Killing background jobs..."
trap - SIGINT SIGTERM EXIT

echo "All selected scripts finished."
