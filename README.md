# PandaNote (pn) - Daily Task Management for nb

A "twos-like" [nb](https://github.com/xwmx/nb) plugin for daily task management with automatic migration of incomplete tasks between days.

## Features

- **Daily Notes**: Automatically creates daily notes in `YYYYMMDD.md` format
- **Quick Task Capture**: Add tasks instantly to today's note
- **Smart Task Migration**: Automatically detects and prompts to migrate incomplete tasks from previous days
- **Non-blocking Warnings**: Get reminded about yesterday's tasks without interrupting your flow
- **Simple Commands**: Intuitive interface that extends nb's functionality

## Installation

### Prerequisites

You must have [nb](https://github.com/xwmx/nb) installed:

```bash
# macOS with Homebrew
brew install nb

# Or install with basher
basher install xwmx/nb

# Or download directly
curl -L https://raw.github.com/xwmx/nb/master/nb -o ~/bin/nb && chmod +x ~/bin/nb
```

### Install PandaNote Plugin

```bash
# Install the plugin
nb plugins install https://raw.githubusercontent.com/yourusername/panda-note/main/pn.nb-plugin

# Verify installation
nb pn help
```

### Optional: Add Convenient Aliases

Add these to your `~/.bashrc` or `~/.zshrc`:

```bash
alias pn="nb pn"
alias pna="nb pn add"
alias pnm="nb pn migrate"
alias pnt="nb pn today"
```

Then reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc
```

## Usage

### Basic Commands

```bash
# Add a task to today's note
nb pn add "Call dentist"
nb pn add "Review pull request"

# Open today's note in your editor
nb pn today

# List recent daily notes
nb pn list

# Migrate incomplete tasks from yesterday
nb pn migrate

# Migrate tasks from a specific file
nb pn migrate project-notes.md
```

### With Aliases

If you've set up the aliases:

```bash
# Add tasks quickly
pna "Buy groceries"
pna "Finish report"

# Open today's note
pnt

# Migrate tasks
pnm
```

## Workflow Example

### Day 1 (Monday)
```bash
$ pna "Write weekly report"
✓ Added to 20250908.md

$ pna "Call client"
✓ Added to 20250908.md

$ pna "Review code"
✓ Added to 20250908.md
```

### Day 2 (Tuesday)
```bash
$ pna "Team standup"
⚠️  Yesterday has 2 incomplete tasks. Run 'nb pn migrate' to move them.
✓ Added to 20250909.md

$ pnm
Found 2 incomplete tasks in 20250908.md:
  - [ ] Call client
  - [ ] Review code

Migrate to today? (y/n): y
✓ Migrated 2 tasks to 20250909.md
```

## File Structure

PandaNote creates daily notes in your current nb notebook:

```
notebook/
├── 20250907.md   # Sunday's notes
├── 20250908.md   # Monday's notes
├── 20250909.md   # Tuesday's notes
└── ...
```

Each daily note follows this format:

```markdown
# Daily 2025-09-09

- [ ] Team standup
- [ ] Call client
- [ ] Review code
- [x] Write weekly report
```

## Task Format

PandaNote uses standard markdown checkboxes:

- `- [ ]` Incomplete task (will be migrated)
- `- [x]` Completed task (stays in original day)

## Configuration

PandaNote stores minimal state in nb's settings:

```bash
# View current settings
nb settings list | grep pn

# Manually reset warning state (if needed)
nb set pn.last_warning_date ""
```

## Tips

1. **Daily Review**: Start each day with `pn today` to review and plan
2. **Quick Capture**: Use `pna` alias for lightning-fast task entry
3. **Weekly Cleanup**: Periodically review old daily notes with `pn list`
4. **Combine with nb**: Use nb's search to find tasks across all notes:
   ```bash
   nb search "- [ ]"  # Find all incomplete tasks
   nb search "#urgent" # Find tagged items
   ```

## Integration with nb

PandaNote is a pure nb plugin, so all nb features work seamlessly:

```bash
# Search across daily notes
nb search "meeting" 202509*.md

# Browse daily notes in web interface
nb browse

# Sync with Git
nb sync

# Export a daily note
nb export 20250909.md --to pdf
```

## Troubleshooting

### Plugin not found
```bash
# Verify nb is installed
nb --version

# Reinstall plugin
nb plugins uninstall pn
nb plugins install https://raw.githubusercontent.com/yourusername/panda-note/main/pn.nb-plugin
```

### Tasks not migrating
- Ensure tasks use the exact format: `- [ ] task text`
- Check that yesterday's file exists: `nb list | grep $(date -d yesterday +%Y%m%d)`

### Wrong date format
PandaNote automatically handles both macOS and Linux date commands. If you see issues, verify your system date:
```bash
date +%Y%m%d  # Should output: 20250909
```

## Contributing

Contributions are welcome! Feel free to:
- Report issues
- Suggest features
- Submit pull requests

## License

MIT

## Credits

Built for [nb](https://github.com/xwmx/nb) by [Your Name]

Inspired by [Twos](https://www.twosapp.com/) and the Bullet Journal method.