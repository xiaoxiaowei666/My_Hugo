#!/bin/sh
# ============================================================
# 一键发布脚本
# public/ 目录是 xiaoxiaowei666.github.io 仓库的工作副本（git clone 而来）
# 用法:  ./publish.sh "提交信息"      指定提交信息
#        sh publish.sh               不传参数则自动生成带时间戳的信息
# ============================================================
set -e
cd "$(dirname "$0")"   # 无论从哪个目录运行，都以项目根目录为基准

# 清空旧的构建产物（保留 public/.git），保证线上与最新内容完全一致
# Hugo 不会自动删除"已删除文章"留下的旧页面，必须每次先清空再构建
find public -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

echo ">> Building site with Hugo..."
hugo

cd public
git add .

# 空仓库克隆时没有分支，统一命名为 main
git branch -M main

if [ -n "$1" ]; then
    MSG="$1"
else
    MSG="chore: Publish site updates at $(date +'%Y-%m-%d %H:%M:%S')"
fi

if git diff --cached --quiet; then
    echo ">> Nothing new to commit, skipping commit."
else
    git commit -m "$MSG"
fi

echo ">> Pushing to xiaoxiaowei666.github.io..."
git push origin main

cd ..

# 3. 同步源码仓库（My_Hugo），避免源码改动丢失
git add -A
git branch -M main
if git diff --cached --quiet; then
    echo ">> 源码无新改动，跳过提交。"
else
    git commit -m "$MSG"
    git push origin main
    echo ">> 源码已同步到 My_Hugo ✓"
fi

echo ">> Done! 稍等 1~2 分钟即可访问 https://xiaoxiaowei666.github.io"
