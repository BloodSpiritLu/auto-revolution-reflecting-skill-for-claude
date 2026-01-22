#!/bin/bash
# Claude Code Self-Evolving Skills - 初始化脚本
#
# 使用方法：
#   git clone <your-repo> ~/.claude/skills
#   bash ~/.claude/skills/setup.sh

set -e

SKILLS_DIR="$HOME/.claude/skills"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "=== Claude Skills 初始化 ==="
echo ""

# 检查 skills 目录
if [ ! -d "$SKILLS_DIR" ]; then
    echo "错误：Skills 目录不存在"
    echo "请先克隆仓库到 ~/.claude/skills"
    exit 1
fi

# 确保 .claude 目录存在
mkdir -p ~/.claude

# 如果 settings.json 不存在，创建它
if [ ! -f "$SETTINGS_FILE" ]; then
    echo '{}' > "$SETTINGS_FILE"
    echo "创建了 $SETTINGS_FILE"
fi

# 检查是否已有 SessionStart hook
if grep -q '"SessionStart"' "$SETTINGS_FILE" 2>/dev/null; then
    echo "SessionStart hook 已存在，跳过配置"
else
    # 尝试使用 node 来合并 JSON
    if command -v node &> /dev/null; then
        node -e "
        const fs = require('fs');
        const settings = JSON.parse(fs.readFileSync('$SETTINGS_FILE', 'utf8'));
        settings.hooks = settings.hooks || {};
        settings.hooks.SessionStart = [{
            hooks: [{
                type: 'command',
                command: 'cd ~/.claude/skills && git pull --rebase origin main 2>/dev/null || true',
                timeout: 10000
            }]
        }];
        fs.writeFileSync('$SETTINGS_FILE', JSON.stringify(settings, null, 2));
        "
        echo "SessionStart hook 配置完成"
    # 尝试使用 python
    elif command -v python3 &> /dev/null; then
        python3 -c "
import json
with open('$SETTINGS_FILE', 'r') as f:
    settings = json.load(f)
settings.setdefault('hooks', {})
settings['hooks']['SessionStart'] = [{
    'hooks': [{
        'type': 'command',
        'command': 'cd ~/.claude/skills && git pull --rebase origin main 2>/dev/null || true',
        'timeout': 10000
    }]
}]
with open('$SETTINGS_FILE', 'w') as f:
    json.dump(settings, f, indent=2)
"
        echo "SessionStart hook 配置完成"
    elif command -v python &> /dev/null; then
        python -c "
import json
with open('$SETTINGS_FILE', 'r') as f:
    settings = json.load(f)
settings.setdefault('hooks', {})
settings['hooks']['SessionStart'] = [{
    'hooks': [{
        'type': 'command',
        'command': 'cd ~/.claude/skills && git pull --rebase origin main 2>/dev/null || true',
        'timeout': 10000
    }]
}]
with open('$SETTINGS_FILE', 'w') as f:
    json.dump(settings, f, indent=2)
"
        echo "SessionStart hook 配置完成"
    else
        echo ""
        echo "未找到 node 或 python，请手动配置："
        echo ""
        echo "将以下内容合并到 ~/.claude/settings.json："
        echo ""
        cat "$SKILLS_DIR/settings-hooks.json"
        echo ""
    fi
fi

# 检查 Git remote
echo ""
cd "$SKILLS_DIR"
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

if [ -z "$REMOTE_URL" ]; then
    echo "提示：尚未配置 Git remote"
    echo "如果你想要多设备同步，请运行："
    echo "  cd ~/.claude/skills"
    echo "  git remote add origin <your-repo-url>"
else
    echo "Git remote: $REMOTE_URL"
fi

echo ""
echo "=== 初始化完成 ==="
echo ""
echo "Skills 位置: $SKILLS_DIR"
echo "配置文件: $SETTINGS_FILE"
echo ""
echo "使用方法："
echo "  - 在对话结束时运行 /reflect 来保存学到的规则"
echo "  - 下次启动 Claude Code 会自动同步最新规则"
echo ""
