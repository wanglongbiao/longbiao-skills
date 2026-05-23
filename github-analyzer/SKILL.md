---
name: github-analyzer
description: "Analyzes GitHub repositories. Triggers when user provides any GitHub.com URL to provide project overview, architecture, features, and technical analysis. Use this skill automatically when user sends a GitHub link."
---

# GitHub 项目分析 skill

当用户发送 GitHub 项目链接时，自动执行以下分析：

## 分析流程

### 1. 克隆仓库
```bash
git clone <url> --depth 1
```

### 2. 必读文件（按优先级）
1. `README.md` — 项目概述、功能
2. `CLAUDE.md` — 官方项目指导
3. `pyproject.toml` / `requirements.txt` — 依赖
4. `docker-compose.yaml` / `Dockerfile` — 部署
5. 入口文件 — 启动流程

### 3. 输出结构

提供完整的分析报告，包含：

**项目概述**
- 项目名称和定位
- 解决什么问题
- 目标用户

**核心功能矩阵**（表格）

**架构设计**
- 核心模块及职责
- 数据流向

**技术栈**
- 语言/框架
- 数据库/缓存
- 第三方服务

**关键代码路径**
- 入口点
- 配置项说明

## 注意事项

- 只分析公开仓库
- 不修改任何文件
- 基于实际代码输出
- 使用中文回答