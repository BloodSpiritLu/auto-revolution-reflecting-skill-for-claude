# Reflect Skill - 自我进化系统

## 目的

当用户输入 `/reflect` 时，分析当前对话中的用户反馈，提取有价值的规则和模式，按**置信度**和**作用域**分类，并持久化到相应的技能文件中。

## 触发方式

- 用户输入 `/reflect` 命令
- 或在对话结束前手动触发

## 工作流程

### 1. 扫描对话历史

回顾整个对话，识别以下类型的用户反馈：
- 明确的纠正："不要这样做"、"以后要..."
- 偏好声明："我喜欢..."、"我更倾向于..."
- 规则声明："所有的...都必须..."、"永远不要..."
- 满意/不满意的表达

### 2. 置信度分类

| 置信度 | 触发条件 | 处理方式 |
|--------|----------|----------|
| **高** | 用户明确声明的规则或禁止项 | 直接写入技能文件 |
| **中** | 本次会话中成功的实践模式 | 标记为"待确认"写入 |
| **低** | 可能的偏好趋势 | 标记为"待观察"写入 |

### 3. 作用域判断

| 作用域 | 判断标准 | 存储位置 | 示例 |
|--------|----------|----------|------|
| **全局** | 与具体技术栈/项目无关的通用规则 | `~/.claude/skills/` | "使用中文交流"、"commit 信息要清晰"、"代码要有注释" |
| **项目** | 涉及特定框架、路径、架构、业务逻辑 | `./.claude/skills/` | "使用 React"、"API 路径以 /api/v2 开头"、"组件放在 src/components/" |

**判断规则**：
- 提到具体框架/库名称 → 项目级
- 提到具体文件路径/目录结构 → 项目级
- 提到具体业务逻辑/功能 → 项目级
- 通用的代码风格/沟通习惯/安全规范 → 全局
- 不确定时 → 默认项目级（更安全，避免污染其他项目）

### 4. 确定目标技能文件

根据规则的领域，选择或创建对应的技能文件：

**全局技能文件** (`~/.claude/skills/`)：
- `general_preferences.md` - 通用偏好（沟通、习惯）
- `coding_standards.md` - 通用代码规范

**项目技能文件** (`./.claude/skills/`)：
- `project_standards.md` - 项目特定规范
- `tech_stack.md` - 技术栈相关

### 5. 生成更新建议

以清晰的格式展示将要更新的内容：

```
## 反射结果

### 全局规则 → ~/.claude/skills/

#### general_preferences.md
- [高置信度] 使用中文交流
- [中置信度/待确认] 偏好简洁的代码注释

### 项目规则 → ./.claude/skills/

#### project_standards.md
- [高置信度] 使用 pnpm 作为包管理器
- [中置信度/待确认] 组件放在 src/components/

#### tech_stack.md
- [高置信度] 前端使用 React + TypeScript

---
是否确认更新？
- [y] 全部确认
- [n] 全部取消
- [g] 只更新全局规则
- [p] 只更新项目规则
- [e] 逐条编辑
```

### 6. 等待用户确认

- 用户确认后，执行文件更新
- 用户拒绝后，询问是否需要调整
- 用户可以选择部分接受或逐条编辑

### 7. 执行更新并提交

确认后：
1. 更新对应的技能文件
2. 如果在 Git 仓库中，执行 `git add` 和 `git commit`
3. commit 信息格式：`reflect: [作用域] [简要描述]`
   - 例：`reflect: [global] 添加中文交流偏好`
   - 例：`reflect: [project] 添加 React 技术栈规则`

## 注意事项

- **避免过度学习**：不要把一次性的尝试当成永久规则
- **保持可逆**：所有更新都通过 Git 跟踪，可随时回滚
- **用户优先**：始终等待用户确认后再写入
- **合并重复**：如果新规则与现有规则重复或冲突，提示用户选择
- **默认项目级**：不确定作用域时，默认放项目级，避免污染全局

## 示例对话

```
用户：帮我用 React 写一个登录表单
Claude：[生成代码]
用户：记住，以后所有表单都要加 CSRF token，另外我喜欢用中文交流
Claude：好的，已添加 CSRF token。
用户：/reflect

Claude：## 反射结果

### 全局规则 → ~/.claude/skills/

#### general_preferences.md
- [高置信度] 使用中文交流

### 项目规则 → ./.claude/skills/

#### project_standards.md
- [高置信度] 所有表单必须包含 CSRF token

#### tech_stack.md
- [中置信度/待确认] 使用 React 框架

---
是否确认更新？[y/n/g/p/e]

用户：y
Claude：已更新技能文件并提交：
        - ~/.claude/skills/general_preferences.md
        - ./.claude/skills/project_standards.md
        - ./.claude/skills/tech_stack.md

        commits:
        - reflect: [global] 添加中文交流偏好
        - reflect: [project] 添加表单 CSRF 规则和 React 技术栈
```

## 查看和回滚

```
# 查看全局技能进化历史
cd ~/.claude/skills && git log --oneline

# 查看项目技能进化历史
cd ./.claude/skills && git log --oneline

# 回滚某次更新
git revert <commit-hash>
```
