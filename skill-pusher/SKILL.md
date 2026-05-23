---
name: skill-pusher
description: "将本地技能推送到 GitHub 技能仓库。当用户说'推送技能'或'推送到技能仓库'时使用。需要指定技能名称和内容，或者用户提供已创建好的技能路径。"
---

# 技能推送 skill

将本地创建的技能推送到 https://github.com/wanglongbiao/longbiao-skills

## 推送流程

### 方式一：指定技能名称和SKILL.md路径
```bash
# 克隆仓库（如果需要）
git clone https://github.com/wanglongbiai/longbiao-skills --depth 1

# 或如果已经克隆
cd longbiao-skills

# 创建技能目录（技能名作为目录名）
mkdir -p <skill-name>

# 复制 SKILL.md
cp /path/to/SKILL.md <skill-name>/

# 提交推送
git add <skill-name>/
git commit -m "Add <skill-name> skill"
git push origin main
```

### 方式二：用户提供已有技能路径
直接复制整个目录到 longbiao-skills 目录下

## 注意事项

- 技能名称使用 kebab-case（小写+连字符）
- 只推送 SKILL.md 文件，不推送其他文件
- 先确认 longbiao-skills 目录在正确位置
- 如果仓库已有该技能，会被覆盖

## 示例

用户说"推送 my-new-skill，文件在 C:\Users\xxx\my-new-skill\SKILL.md"
→ 执行：克隆仓库 → 创建目录 → 复制文件 → 提交推送