#!/bin/bash

echo "🚀 开始基于文件名的精准修改..."

# 定义一个函数来处理替换逻辑
# 参数1: 文件名匹配模式 (例如 *4G*.sh)
# 参数2: 旧字符串 (例如 zoned64_12G)
# 参数3: 新字符串 (例如 zoned64_8G)
process_files() {
    pattern="$1"
    old_str="$2"
    new_str="$3"

    # 查找符合模式的文件
    # 2>/dev/null 用于屏蔽当找不到文件时的报错信息
    files=$(ls $pattern 2>/dev/null)

    if [ -n "$files" ]; then
        echo "📂 正在处理包含 '$pattern' 的文件..."
        for file in $files; do
            # 检查文件中是否真的包含旧字符串（避免无效修改）
            if grep -q "$old_str" "$file"; then
                sed -i "s/$old_str/$new_str/g" "$file"
                echo "  ✅ 已修改: $file ($old_str -> $new_str)"
            else
                echo "  ⚪ 跳过: $file (未找到 $old_str)"
            fi
        done
    else
        echo "⚠️  未找到匹配 '$pattern' 的文件，跳过该组。"
    fi
}

# ---------------------------------------------------------
# 1. 处理 4G SSD (3倍=12G -> 2倍=8G)
# 注意：*4G* 可能会匹配到 *64G*，但因为我们只替换 zoned64_12G，
# 而 64G 文件里通常只有 zoned64_192G，所以是安全的。
process_files "*_4G_*.sh" "zoned64_12G" "zoned64_8G"

# 2. 处理 16G SSD (3倍=48G -> 2倍=32G)
process_files "*_16G_*.sh" "zoned64_48G" "zoned64_32G"

# 3. 处理 64G SSD (3倍=192G -> 2倍=128G)
process_files "*_64G_*.sh" "zoned64_192G" "zoned64_128G"

# 4. 处理 256G SSD (3倍=768G -> 2倍=512G)
process_files "*_256G_*.sh" "zoned64_768G" "zoned64_512G"

echo "---------------------------------------------------------"
echo "🎉 所有匹配文件处理完毕。"