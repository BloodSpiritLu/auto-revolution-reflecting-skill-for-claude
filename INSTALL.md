# 安装说明

## 部署 Skills

### 全局安装（推荐）

将以下 Skills 复制到全局目录，所有项目都可使用：

```bash
# Windows (PowerShell)
Copy-Item -Recurse skills/reflect ~/.claude/skills/
Copy-Item -Recurse skills/general_preferences ~/.claude/skills/
Copy-Item -Recurse skills/coding_standards ~/.claude/skills/

# Linux/Mac
cp -r skills/reflect ~/.claude/skills/
cp -r skills/general_preferences ~/.claude/skills/
cp -r skills/coding_standards ~/.claude/skills/
```

### 项目级安装

将项目相关的 Skills 复制到项目目录：

```bash
# 在你的项目根目录执行
mkdir -p .claude/skills
cp -r <本项目路径>/skills/project_standards .claude/skills/
cp -r <本项目路径>/skills/tech_stack .claude/skills/
```

## 目录结构说明

安装后的目录结构：

```
~/.claude/
└── skills/
    ├── reflect/              # /reflect 命令（全局）
    │   └── SKILL.md
    ├── general_preferences/  # 通用偏好（全局，自动加载）
    │   └── SKILL.md
    └── coding_standards/     # 通用代码规范（全局，自动加载）
        └── SKILL.md

<你的项目>/
└── .claude/
    └── skills/
        ├── project_standards/  # 项目规范（项目级，自动加载）
        │   └── SKILL.md
        └── tech_stack/         # 技术栈（项目级，自动加载）
            └── SKILL.md
```

## 使用方法

1. **手动反射**：在对话中输入 `/reflect`，Claude 会分析对话并提取规则
2. **自动加载**：领域技能文件会被 Claude 自动读取作为上下文

## 可选：配置 Stop Hook

如果希望在每次会话结束时自动触发反射，可以在 `~/.claude/settings.json` 中添加：

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "会话即将结束。请检查对话中是否有值得记录的用户偏好或规则。如果有，提示用户是否要执行 /reflect。回复 JSON: {\"ok\": true}",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## 验证安装

安装完成后，在 Claude Code 中输入 `/reflect`，如果能识别命令则安装成功。
