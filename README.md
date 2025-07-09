# Claude Brain

A simple tool to create a persistent Claude instance using tmux that maintains context across multiple interactions.

## What is Claude Brain?

Claude Brain creates a long-running Claude Code session that remembers everything from your conversation. Unlike normal Claude CLI usage where each command starts fresh, the brain maintains full context - it's like having a continuous conversation with Claude that can span hours or days.

## Quick Start

```bash
# Start the brain
./brain.sh start

# Send a command
./brain.sh send "What is the weather like today?"

# View live interaction
./brain.sh attach  # Press Ctrl+B, D to detach

# View logs
./brain.sh logs

# Stop the brain
./brain.sh stop
```

## Installation

1. Clone this repository:
   ```bash
   cd /Users/claudemini/Claude/Code
   git clone <repository-url> claude-brain
   cd claude-brain
   ```

2. Ensure you have tmux installed:
   ```bash
   # macOS
   brew install tmux
   
   # Ubuntu/Debian
   sudo apt-get install tmux
   ```

3. Make the script executable:
   ```bash
   chmod +x brain.sh
   ```

## Commands

- `start` - Start a new Claude brain session
- `stop` - Stop the Claude brain session  
- `status` - Show if the brain is running
- `attach` - Attach to see the live Claude session (Ctrl+B, D to detach)
- `send <cmd>` - Send a command to Claude
- `logs` - View today's brain activity log (Ctrl+C to exit)
- `help` - Show help message

## Features

### Persistent Context
The brain remembers your entire conversation history. You can ask follow-up questions hours later and Claude will remember what you discussed.

### Automatic Logging
All interactions are automatically logged to `logs/brain_YYYY-MM-DD.log` using tmux's pipe-pane feature. This captures the complete terminal output, giving you a full history of your conversations with Claude.

### Multiple Brains
Run different brains for different purposes by setting the `BRAIN_NAME` environment variable.

## Examples

### Basic Usage
```bash
# Start a brain and have a conversation
./brain.sh start
./brain.sh send "Remember that my favorite color is blue"
./brain.sh send "What is my favorite color?"
# Claude will respond: "Your favorite color is blue"
```

### Multiple Brains for Different Tasks
```bash
# Research brain
BRAIN_NAME="research" ./brain.sh start
BRAIN_NAME="research" ./brain.sh send "Help me research quantum computing"
BRAIN_NAME="research" ./brain.sh send "What are the main challenges?"

# Coding brain (in another terminal)
BRAIN_NAME="coding" ./brain.sh start  
BRAIN_NAME="coding" ./brain.sh send "Help me write a Python web scraper"
BRAIN_NAME="coding" ./brain.sh send "Add error handling to the code"
```

### Long-Running Analysis
```bash
./brain.sh start
./brain.sh send "Analyze the code in /Users/claudemini/Claude/Code/myproject"
# ... hours later ...
./brain.sh send "What were the main issues you found?"
./brain.sh send "Can you generate a fix for the security issue?"
```

## Use Cases

1. **Development Assistant**: Keep a coding brain running while you work, asking questions and getting help without losing context

2. **Research Sessions**: Maintain context across long research sessions, building up knowledge over time

3. **System Monitoring**: Have Claude analyze logs and system state while maintaining awareness of previous issues

4. **Learning Partner**: Study a topic over multiple sessions with Claude remembering your progress

## Tips

- The brain maintains ALL context from your conversation - be mindful of sensitive information
- You can have multiple brains running simultaneously with different names
- Use `attach` to see Claude's responses in real-time, or check logs later
- The brain keeps running even if you disconnect - your conversation persists
- Logs are organized by date, making it easy to review past sessions

## Architecture

```
claude-brain/
├── brain.sh                 # Main control script
├── logs/                    # Daily log files (created automatically)
│   └── brain_YYYY-MM-DD.log
└── README.md               # This file
```

## Troubleshooting

**Brain won't start:**
- Check if tmux is installed: `which tmux`
- Ensure no existing session: `tmux list-sessions`
- Check if Claude Code is installed: `which claude`

**Commands not being received:**
- Verify brain is running: `./brain.sh status`
- Attach to see what's happening: `./brain.sh attach`

**No logs appearing:**
- Logs only appear after interactions with Claude
- Check the logs directory exists: `ls -la logs/`
- Try stopping and restarting the brain

## Manual tmux Commands

If you prefer using tmux directly:

```bash
# Start (from the claude-brain directory to pick up settings)
tmux new-session -d -s claude_brain
tmux send-keys -t claude_brain:0 "cd /Users/claudemini/Claude/Code/claude-brain && claude --dangerously-skip-permissions" Enter

# Send command
tmux send-keys -t claude_brain:0 "Your message here" Enter

# Attach
tmux attach -t claude_brain

# Stop
tmux kill-session -t claude_brain
```