# Claude Code Self-Evolving Skills

[中文版](README_CN.md)

Make Claude Code remember your preferences. The more you use it, the better it understands you.

## What is this?

A **self-evolving framework** built on Claude Code's Skills system. With the `/reflect` command, Claude will:

1. Analyze your feedback and preferences from the current conversation
2. Classify by confidence level (high/medium/low)
3. Determine scope (global/project-level)
4. Persist to skill files
5. Auto-sync to GitHub (multi-device sharing)

Next conversation, Claude automatically reads these preferences—no need to repeat yourself.

## Why do I need this?

**The Problem**: Every new session, you have to tell Claude your preferences again
- "Use Chinese please"
- "Use pnpm not npm"
- "This project uses React"
- "Don't add so many comments"

**The Solution**: Let Claude learn and remember on its own

```
You: Write a component
Claude: Sure, I'll use TypeScript + React... (because it remembers your project uses this)

You: /reflect
Claude: I noticed you corrected me a few times this session. Want me to remember these?
```

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/claude-skills-template.git ~/.claude/skills
```

### 2. Run the setup script

```bash
bash ~/.claude/skills/setup.sh
```

This configures a SessionStart hook to auto-sync every time you start Claude Code.

### 3. Start using it

Run `/reflect` at the end of any conversation. Claude will extract and save the rules it learned.

## Core Concepts

### Confidence Classification

| Confidence | Trigger | Example |
|------------|---------|---------|
| **High** | User explicitly stated | "Always reply in English" |
| **Medium** | Successful pattern this session | User expressed satisfaction with an approach |
| **Low** | Possible trend | Chose a certain method multiple times |

### Scope Determination

| Scope | Criteria | Storage Location |
|-------|----------|------------------|
| **Global** | General habits (language, style) | `~/.claude/skills/` |
| **Project** | Specific framework, paths, business logic | `./.claude/skills/` |

### Skill File Structure

```
~/.claude/skills/                  # Global skills
├── reflect/SKILL.md              # /reflect command
├── general_preferences/SKILL.md  # General preferences
└── coding_standards/SKILL.md     # Coding standards

./project/.claude/skills/          # Project-level skills
├── project_standards/SKILL.md    # Project standards
└── tech_stack/SKILL.md           # Tech stack
```

## Multi-Device Sync

The system uses Git for multi-device synchronization:

1. **Session start**: Auto `git pull` to get latest rules
2. **After `/reflect`**: Auto `git commit && push` to save new rules
3. **Other devices**: Auto-sync on next session

### Configure your own repository

1. Fork this repo or create a new one
2. Update the remote URL:
   ```bash
   cd ~/.claude/skills
   git remote set-url origin git@github.com:YOUR_USERNAME/YOUR_REPO.git
   ```

## Example

### /reflect output example

```
## Reflection Results

### Global Rules → ~/.claude/skills/

#### general_preferences
- [High confidence] Communicate in English
- [Medium confidence/To confirm] Prefer concise code, avoid over-commenting

### Project Rules → ./.claude/skills/

#### tech_stack
- [High confidence] Use React 18 + TypeScript
- [Medium confidence/To confirm] State management with Zustand

---
Confirm updates?
- [y] Confirm all
- [n] Cancel all
- [e] Edit individually
```

## Customization

### Add new skill categories

Create a new directory and `SKILL.md` under `skills/`:

```markdown
---
name: my_custom_skill
description: My custom skill
user-invocable: false
disable-model-invocation: false
---

# My Custom Skill

## Rules

- [High confidence] ...
```

### Modify reflect behavior

Edit `skills/reflect/SKILL.md` to adjust:
- Confidence classification criteria
- Output format
- Confirmation flow

## Files

| File | Description |
|------|-------------|
| `setup.sh` | New device initialization script |
| `settings-hooks.json` | Hook configuration reference |
| `skills/reflect/SKILL.md` | Core /reflect command |
| `skills/general_preferences/SKILL.md` | General preferences template |
| `skills/coding_standards/SKILL.md` | Coding standards template |
| `skills/project_standards/SKILL.md` | Project standards template |
| `skills/tech_stack/SKILL.md` | Tech stack template |

## FAQ

### Q: What if global and project-level rules conflict?

Project-level rules take priority. If the same rule is A globally but B at project level, B is used.

### Q: How do I delete incorrect rules?

Directly edit the corresponding SKILL.md file and delete the unwanted lines.

### Q: Windows support?

Yes. `~/.claude/skills` on Windows corresponds to `%USERPROFILE%\.claude\skills`.

## Roadmap

### Current
- **Conflict = Update**: When a new rule conflicts with an old one, the old rule is updated directly (simplest approach)

### Planned (Not Yet Implemented)

| Feature | Description | Complexity |
|---------|-------------|------------|
| **Periodic Review** | Add `/review` command to manually trigger rule review | Low |
| **Confidence Decay** | High→Medium→Low→Delete, rules not validated over time auto-downgrade | Medium |
| **Time Decay** | Track creation time, prompt cleanup for rules older than N months | Medium |
| **Capacity Limit** | Limit N rules per category, prompt deletion when exceeded | Low |
| **Usage Tracking** | Track how often rules are "triggered", clean up low-frequency rules | High |

### Trigger Options (Future)
- Time-driven: Remind every N days/weeks
- Event-driven: Trigger after N reflects
- Manual: User calls `/review`

## License

MIT

---

> Let AI remember you, instead of you remembering what AI needs.
