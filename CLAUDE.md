# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 语言设置

**请使用中文与用户交流。**

## 项目概述

本项目旨在为 Claude Code 构建一个**自我进化技能系统** —— 一个反馈闭环，让 Claude 能够将学到的用户偏好和纠正持久化到 Markdown 技能文件中，成为未来系统提示词的一部分。

## 核心概念

系统在对话中捕获用户的纠正，按置信度分类，并持久化到技能文件：

- **高置信度**：用户明确声明的规则/禁止项
- **中置信度**：本次会话中成功的模式
- **低置信度**：值得持续观察的趋势

## 需要实现的关键组件

1. **反射技能** (`reflect.md`) - 一个元技能，分析对话历史、提取经验、更新其他技能文件
2. **领域技能文件** - 按类别划分的文件（如 `coding_standards.md`），积累学到的规则
3. **Git 集成** - 对技能文件进行版本控制，追踪 AI 的进化历程并支持回滚
4. **Hooks（可选）** - 通过 Claude Code 的 `stop` 钩子实现自动化反射

## 架构说明

- 技能以纯 Markdown 文件形式存储在 `skills/` 目录中
- 无需向量数据库 —— 纯文本持久化
- 技能文件作为 Claude 系统提示词的一部分被读取
- Git 提供可审计性和回滚能力

## 实现计划

详细的实现计划请查看：`.claude/plan.md`
