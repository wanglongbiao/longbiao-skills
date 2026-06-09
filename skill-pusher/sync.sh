#!/usr/bin/env bash
# 把本地 ~/.claude/skills 下的全部技能整体镜像到远程仓库。
# 单向同步：以本地为准，本地删掉的技能远程也会删除。
set -euo pipefail

REPO_SSH="git@github.com:wanglongbiao/longbiao-skills.git"
SKILLS_DIR="$HOME/.claude/skills"
WORK_DIR="/tmp/longbiao-skills-sync"

# 1. 准备一份干净的仓库克隆
rm -rf "$WORK_DIR"
git clone --depth 1 "$REPO_SSH" "$WORK_DIR"

cd "$WORK_DIR"

# 2. 删除仓库里旧的技能目录（保留 .git 和根目录下的非技能文件如 README/LICENSE）
#    技能 = 目录里含有 SKILL.md。只清这类目录，避免误删 README 等。
for d in */; do
  [ "$d" = ".git/" ] && continue
  if [ -f "${d}SKILL.md" ]; then
    rm -rf "$d"
  fi
done

# 3. 用本地技能整体覆盖进来（含每个技能目录下的所有文件）
for skill in "$SKILLS_DIR"/*/; do
  name=$(basename "$skill")
  cp -r "$skill" "./$name"
done

# 4. 有变更才提交推送
git add -A
if git diff --cached --quiet; then
  echo "没有变更，无需推送"
  exit 0
fi

count=$(ls -d "$SKILLS_DIR"/*/ | wc -l | tr -d ' ')
git commit -m "Sync ${count} local skills"
git push origin main
echo "已同步 ${count} 个技能到 ${REPO_SSH}"
