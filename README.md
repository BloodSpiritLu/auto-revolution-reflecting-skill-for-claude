# Claude Code Self-Evolving Skills

让你的 Claude Code 记住你的偏好，越用越懂你。

## 这是什么？

一个基于 Claude Code Skills 系统的**自我进化框架**。通过 `/reflect` 命令，Claude 会：

1. 分析当前对话中你的反馈和偏好
2. 按置信度分类（高/中/低）
3. 判断作用域（全局/项目级）
4. 持久化到技能文件中
5. 自动同步到 GitHub（多设备共享）

下次对话时，Claude 会自动读取这些偏好，无需重复说明。

## 为什么需要这个？

**问题**：每次新会话都要重新告诉 Claude 你的偏好
- "我要用中文"
- "用 pnpm 不要 npm"
- "这个项目用 React"
- "不要加那么多注释"

**解决方案**：让 Claude 自己学习并记住

```
你：写个组件
Claude：好的，我用 TypeScript + React 写...（因为它记得你的项目用这个）

你：/reflect
Claude：我注意到你这次会话纠正了我几个地方，要记住吗？
```

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/YOUR_USERNAME/claude-skills-template.git ~/.claude/skills
```

### 2. 运行初始化脚本

```bash
bash ~/.claude/skills/setup.sh
```

这会配置 SessionStart hook，让每次启动 Claude Code 时自动同步。

### 3. 开始使用

在任何对话结束时运行 `/reflect`，Claude 会提取并保存学到的规则。

## 核心概念

### 置信度分类

| 置信度 | 触发条件 | 示例 |
|--------|----------|------|
| **高** | 用户明确声明 | "永远用中文回复" |
| **中** | 本次会话成功的模式 | 用户对某个做法表示满意 |
| **低** | 可能的趋势 | 多次选择某种方式 |

### 作用域判断

| 作用域 | 判断标准 | 存储位置 |
|--------|----------|----------|
| **全局** | 通用习惯（语言、风格） | `~/.claude/skills/` |
| **项目** | 特定框架、路径、业务 | `./.claude/skills/` |

### 技能文件结构

```
~/.claude/skills/                  # 全局技能
├── reflect/SKILL.md              # /reflect 命令
├── general_preferences/SKILL.md  # 通用偏好
└── coding_standards/SKILL.md     # 代码规范

./project/.claude/skills/          # 项目级技能
├── project_standards/SKILL.md    # 项目规范
└── tech_stack/SKILL.md           # 技术栈
```

## 多设备同步

系统通过 Git 实现多设备同步：

1. **会话开始**：自动 `git pull` 获取最新规则
2. **`/reflect` 后**：自动 `git commit && push` 保存新规则
3. **其他设备**：下次会话自动同步

### 配置你自己的仓库

1. Fork 这个仓库或创建新仓库
2. 修改 remote 地址：
   ```bash
   cd ~/.claude/skills
   git remote set-url origin git@github.com:YOUR_USERNAME/YOUR_REPO.git
   ```

## 示例

### /reflect 输出示例

```
## 反射结果

### 全局规则 → ~/.claude/skills/

#### general_preferences
- [高置信度] 使用中文交流
- [中置信度/待确认] 偏好简洁的代码，避免过度注释

### 项目规则 → ./.claude/skills/

#### tech_stack
- [高置信度] 使用 React 18 + TypeScript
- [中置信度/待确认] 状态管理使用 Zustand

---
是否确认更新？
- [y] 全部确认
- [n] 全部取消
- [e] 逐条编辑
```

## 自定义

### 添加新的技能类别

在 `skills/` 下创建新目录和 `SKILL.md`：

```markdown
---
name: my_custom_skill
description: 我的自定义技能
user-invocable: false
disable-model-invocation: false
---

# 我的自定义技能

## 规则

- [高置信度] ...
```

### 修改 reflect 行为

编辑 `skills/reflect/SKILL.md` 来调整：
- 置信度分类标准
- 输出格式
- 确认流程

## 文件说明

| 文件 | 说明 |
|------|------|
| `setup.sh` | 新设备初始化脚本 |
| `settings-hooks.json` | Hook 配置参考 |
| `skills/reflect/SKILL.md` | 核心 /reflect 命令 |
| `skills/general_preferences/SKILL.md` | 通用偏好模板 |
| `skills/coding_standards/SKILL.md` | 代码规范模板 |
| `skills/project_standards/SKILL.md` | 项目规范模板 |
| `skills/tech_stack/SKILL.md` | 技术栈模板 |

## 常见问题

### Q: 全局和项目级冲突怎么办？

项目级规则优先。如果同一规则在全局是 A，在项目级是 B，会使用 B。

### Q: 怎么删除错误的规则？

直接编辑对应的 SKILL.md 文件，删除不需要的行。

### Q: Windows 支持吗？

支持。`~/.claude/skills` 在 Windows 上对应 `%USERPROFILE%\.claude\skills`。

## License

MIT

---

> 让 AI 记住你，而不是你记住 AI 要什么。
