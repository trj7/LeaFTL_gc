#!/bin/bash

# 获取当前脚本的文件名，防止处理自己
SELF_NAME=$(basename "$0")

echo "=== 开始批量处理 ==="

# 遍历当前目录下所有 .sh 文件
for file in *.sh; do
    # 1. 跳过自己
    if [[ "$file" == "$SELF_NAME" ]]; then
        continue
    fi

    # 2. 检查是否已经是新格式（防止重复执行破坏文件）
    if grep -q "SCRIPT_DIR=" "$file"; then
        echo "[跳过] $file (似乎已经是新格式)"
        continue
    fi

    # 3. 检查是否包含关键命令（防止修改无关脚本）
    if ! grep -q "run_ftl" "$file"; then
        echo "[跳过] $file (未找到 run_ftl 关键字)"
        continue
    fi

    echo "[处理中] $file ..."

    # --- 步骤 A: 提取参数 ---
    # 使用 grep 和 awk 提取参数值
    TRACE=$(grep -oE "\-t\s+\S+" "$file" | awk '{print $2}')
    CONFIG=$(grep -oE "\-cf\s+\S+" "$file" | awk '{print $2}')
    OUTPUT_FULL=$(grep -oE "\-o\s+\S+" "$file" | awk '{print $2}')
    LOG_FILE=$(grep -oE ">>\s+\S+" "$file" | awk '{print $2}')
    
    # 提取数值参数
    VAL_SL=$(grep -oE "\-sl\s+\S+" "$file" | awk '{print $2}')
    VAL_L=$(grep -oE "\-l\s+\S+" "$file" | awk '{print $2}')
    VAL_C=$(grep -oE "\-c\s+\S+" "$file" | awk '{print $2}')
    VAL_MC=$(grep -oE "\-mc\s+\S+" "$file" | awk '{print $2}')
    VAL_F=$(grep -oE "\-f\s+\S+" "$file" | awk '{print $2}')
    VAL_WO=$(grep -oE "\-wo\s+\S+" "$file" | awk '{print $2}')
    VAL_Q=$(grep -oE "\-q\s+\S+" "$file" | awk '{print $2}')
    VAL_P=$(grep -oE "\-p\s+\S+" "$file" | awk '{print $2}')

    # 如果关键参数提取失败，跳过该文件，避免清空
    if [[ -z "$TRACE" || -z "$OUTPUT_FULL" ]]; then
        echo "  [错误] 无法解析关键参数，跳过此文件。"
        continue
    fi

    # --- 步骤 B: 路径计算 ---
    # 分离输出路径的目录和文件名
    OUT_DIR_REL=$(dirname "$OUTPUT_FULL")
    OUT_FILENAME=$(basename "$OUTPUT_FULL")
    LOG_FILENAME=$(basename "$LOG_FILE")


    # --- 步骤 D: 覆盖原文件 ---
    cat > "$file" <<EOF
#!/bin/bash
set -e

# 固定脚本所在目录（关键）
SCRIPT_DIR=\$(cd "\$(dirname "\$0")" && pwd)

# PATH
export PATH="\$PATH:\$SCRIPT_DIR/../pypy2.7-v7.3.9-linux64/bin"

# 输出目录
OUT_DIR="\$SCRIPT_DIR/$OUT_DIR_REL"

# 确保输出目录存在 (可选)
# mkdir -p "\$OUT_DIR"

# 执行
pypy "\$SCRIPT_DIR/../run_ftl" \\
    -sl $VAL_SL \\
    -l $VAL_L \\
    -t "\$SCRIPT_DIR/$TRACE" \\
    -c $VAL_C \\
    -mc $VAL_MC \\
    -f $VAL_F \\
    -wo $VAL_WO \\
    -q $VAL_Q \\
    -p $VAL_P \\
    -o "\$OUT_DIR/$OUT_FILENAME" \\
    -cf "\$SCRIPT_DIR/$CONFIG" \\
    >> "\$OUT_DIR/$LOG_FILENAME" 2>&1
EOF

    echo "  -> 文件已更新"

done

echo "=== 全部完成 ==="