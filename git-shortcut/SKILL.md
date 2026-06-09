---
name: git-shortcut
description: "Git 快捷操作。当用户输入'gt'时执行 git 提交，输入'gp'时先提交再 push。"
---

# Git 快捷操作

当用户输入 **gt** 时，执行 git 提交流程。
当用户输入 **gp** 时，先提交未提交的变更，再 push 推送到远程。

---

## gt — 提交

1. 并行运行 `git status` 和 `git diff`（含 staged 和 unstaged）和 `git log --oneline -5`
2. 分析所有变更，生成简洁的中文 commit message（1-2句，聚焦"为什么"而非"是什么"）
3. 暂存相关文件（优先 `git add` 指定文件，避免 `git add -A`）
4. 提交，commit message 末尾附加：
   ```
   Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
   ```
5. 提交后运行 `git status` 确认成功

注意：
- 不要提交可能含密钥的文件（.env、credentials 等）
- 如果没有可提交的变更，告知用户
- 使用 HEREDOC 传递 commit message

## gp — 提交并推送

1. 先执行上面 **gt** 的完整提交流程（如有未提交的变更则提交；若无变更则跳过提交）
2. 运行 `git status` 确认当前分支状态
3. 检查是否有未推送的 commit（`git log @{u}..HEAD --oneline`，如果没有 upstream 则提示）
4. 执行 `git push`（如果没有 upstream，使用 `git push -u origin <branch>`）
5. 报告推送结果
