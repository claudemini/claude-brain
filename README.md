# Claude Brain

Keep a persistent Claude instance running that maintains context across multiple interactions.

## What is it?

Claude Brain uses tmux to create a long-running Claude session. Unlike normal CLI usage where each command starts fresh, the brain remembers your entire conversation.

## Quick Start

```bash
# Start the brain
./brain.sh start

# Send a command
./brain.sh send "What is the weather like today?"

# View live interaction
./brain.sh attach  # Press Ctrl+B, D to detach

# Check logs
./brain.sh logs

# Stop the brain
./brain.sh stop
```

## Installation

1. Make sure tmux is installed:
   ```bash
   brew install tmux  # macOS
   ```

2. Make the script executable:
   ```bash
   chmod +x brain.sh
   ```

## Commands

- `start` - Start a Claude brain
- `stop` - Stop the brain  
- `status` - Check if running
- `attach` - View live session (Ctrl+B, D to detach)
- `send <cmd>` - Send command to Claude
- `logs` - View today's log
- `help` - Show help

## Examples

```bash
# Basic conversation
./brain.sh start
./brain.sh send "Remember that my project uses Python 3.11"
./brain.sh send "What Python version does my project use?"

# Multiple brains
BRAIN_NAME="work" ./brain.sh start
BRAIN_NAME="work" ./brain.sh send "Help me debug this issue..."
```

## Features

- **Persistent memory** - Claude remembers everything from your conversation
- **Auto-logging** - All interactions saved to `logs/brain_YYYY-MM-DD.log`
- **Multiple instances** - Run different brains with `BRAIN_NAME` variable
- **Background operation** - Keeps running even when disconnected

## Direct tmux commands

```bash
# Start
tmux new-session -d -s claude_brain
tmux send-keys -t claude_brain:0 "claude --dangerously-skip-permissions" Enter

# Send command
tmux send-keys -t claude_brain:0 "Your message here" Enter

# Attach
tmux attach -t claude_brain

# Stop
tmux kill-session -t claude_brain
```