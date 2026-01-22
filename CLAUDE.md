# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 语言设置

**请使用中文与用户交流。**

## 项目概述

本项目是一个 **Claude Code Skills 开发项目**，用于构建自我进化技能系统。核心功能是通过 `/reflect` 命令，让 Claude 能够将学到的用户偏好和纠正持久化到技能文件中。

## 核心 Skill

- **reflect** - 反射技能，分析对话历史并提取规则
- **general_preferences** - 全局通用偏好
- **coding_standards** - 全局代码规范
- **project_standards** - 项目特定规范
- **tech_stack** - 项目技术栈

## 目录结构

```
skills/                    # Skills 开发目录（Git 跟踪）
├── reflect/SKILL.md      # /reflect 命令
├── general_preferences/  # 全局偏好模板
├── coding_standards/     # 全局代码规范模板
├── project_standards/    # 项目规范模板
└── tech_stack/           # 技术栈模板
docs/                     # 开发文档
INSTALL.md                # 安装说明
```

## 部署

详见 `INSTALL.md`。全局 Skills 复制到 `~/.claude/skills/`，项目级 Skills 复制到项目的 `.claude/skills/`。

## 实现计划

详见 `.claude/plan.md`
