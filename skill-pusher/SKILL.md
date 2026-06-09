---
name: skill-pusher
description: "将本地技能同步到 GitHub 技能仓库。当用户说'同步技能'、'推送技能'、'推送到技能仓库'或新增/更新本地技能后需要上传时使用。把 ~/.claude/skills 下的全部本地技能整体同步到 git@github.com:wanglongbiao/longbiao-skills.git。"
---

# 技能同步 skill

把本地 `~/.claude/skills/` 下的全部技能（每个技能的整个目录）同步到远程仓库
`git@github.com:wanglongbiao/longbiao-skills.git`（分支 `main`）。

新增、更新、删除都会被正确同步——以本地为准，远程是本地的镜像。

## 同步脚本

直接运行下面这个脚本（Bash 工具，git-bash 环境）。它会自动 clone → 镜像 → 提交 → 推送。

```bash
bash ~/.claude/skills/skill-pusher/sync.sh
```

脚本无改动时不会产生提交，会输出"没有变更，无需推送"。

## 工作原理

1. clone 远程仓库到临时目录 `/tmp/longbiao-skills-sync`
2. 删除仓库里旧的技能目录（保留 `.git`、`README` 等）
3. 用 `~/.claude/skills/` 下的本地技能整体覆盖进去
4. `git add -A` → 若有变更则 commit + push

## 注意事项

- 同步范围是 `~/.claude/skills/` 下的目录——这些是用户手动创建的本地技能。
  插件提供的技能（如 deep-research、claude-hud 等）不在此目录，不会被同步。
- 远程地址用 SSH（`git@github.com:...`），已确认认证可用。
- 这是**单向镜像**：本地有什么，远程就是什么。本地删掉的技能，推送后远程也会删除。
- 如果只想推送单个技能，告诉脚本不方便，直接手动操作：
  `cd /tmp/longbiao-skills-sync && cp -r ~/.claude/skills/<name> . && git add <name> && git commit -m "..." && git push`
