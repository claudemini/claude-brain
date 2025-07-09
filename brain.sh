#!/bin/bash

# Claude Brain - Simple persistent Claude instance manager

set -e

BRAIN_NAME="${BRAIN_NAME:-claude_brain}"
BRAIN_DIR="$(dirname "$0")"
LOG_DIR="${BRAIN_DIR}/logs"

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

start_brain() {
    if tmux has-session -t "$BRAIN_NAME" 2>/dev/null; then
        warning "Brain '$BRAIN_NAME' is already running"
        return 1
    fi
    
    log "Starting Claude brain '$BRAIN_NAME'..."
    
    # Start tmux session in detached mode
    tmux new-session -d -s "$BRAIN_NAME"
    
    # Start logging the session
    tmux pipe-pane -t "$BRAIN_NAME:0" -o "cat >> '$LOG_DIR/brain_$(date +%Y-%m-%d).log'"
    
    # Start Claude in the brain directory
    tmux send-keys -t "$BRAIN_NAME:0" "cd '$BRAIN_DIR' && claude --dangerously-skip-permissions"
    tmux send-keys -t "$BRAIN_NAME:0" Enter
    
    # Give Claude time to start
    sleep 2
    
    log "Brain '$BRAIN_NAME' started successfully"
}

stop_brain() {
    if ! tmux has-session -t "$BRAIN_NAME" 2>/dev/null; then
        warning "Brain '$BRAIN_NAME' is not running"
        return 1
    fi
    
    log "Stopping Claude brain '$BRAIN_NAME'..."
    
    # Send exit command to Claude
    tmux send-keys -t "$BRAIN_NAME:0" "/exit"
    tmux send-keys -t "$BRAIN_NAME:0" Enter
    sleep 1
    
    # Kill the tmux session
    tmux kill-session -t "$BRAIN_NAME"
    
    log "Brain '$BRAIN_NAME' stopped"
}

status_brain() {
    if tmux has-session -t "$BRAIN_NAME" 2>/dev/null; then
        log "Brain '$BRAIN_NAME' is ${GREEN}RUNNING${NC}"
        
        # Show session info
        echo -e "\nSession Info:"
        tmux list-sessions | grep "^$BRAIN_NAME:"
    else
        log "Brain '$BRAIN_NAME' is ${RED}NOT RUNNING${NC}"
        return 1
    fi
}

attach_brain() {
    if ! tmux has-session -t "$BRAIN_NAME" 2>/dev/null; then
        error "Brain '$BRAIN_NAME' is not running. Start it first with: $0 start"
        return 1
    fi
    
    log "Attaching to brain '$BRAIN_NAME'. Press Ctrl+B then D to detach."
    tmux attach -t "$BRAIN_NAME"
}

send_command() {
    if ! tmux has-session -t "$BRAIN_NAME" 2>/dev/null; then
        error "Brain '$BRAIN_NAME' is not running. Start it first with: $0 start"
        return 1
    fi
    
    local command="$1"
    if [ -z "$command" ]; then
        error "No command provided"
        return 1
    fi
    
    log "Sending command to brain: $command"
    tmux send-keys -t "$BRAIN_NAME:0" "$command"
    tmux send-keys -t "$BRAIN_NAME:0" Enter
}

show_logs() {
    local today=$(date +%Y-%m-%d)
    local log_file="$LOG_DIR/brain_${today}.log"
    
    if [ -f "$log_file" ]; then
        log "Showing today's log: $log_file"
        tail -f "$log_file"
    else
        warning "No log file found for today. Logs will appear once you start interacting with the brain."
    fi
}

usage() {
    cat << EOF
Claude Brain - Simple persistent Claude instance manager

Usage: $0 [command] [options]

Commands:
    start           Start a new Claude brain session
    stop            Stop the Claude brain session
    status          Show brain status
    attach          Attach to the brain session (Ctrl+B, D to detach)
    send <cmd>      Send a command to the brain
    logs            Show today's brain activity log (Ctrl+C to exit)
    help            Show this help message

Environment Variables:
    BRAIN_NAME      Name of the brain session (default: claude_brain)

Examples:
    # Start a brain
    $0 start
    
    # Send a command
    $0 send "What is the weather today?"
    
    # Attach to see live interaction
    $0 attach
    
    # Check status
    $0 status
    
    # Stop the brain
    $0 stop

EOF
}

# Main command processing
case "${1:-help}" in
    start)
        start_brain
        ;;
    stop)
        stop_brain
        ;;
    status)
        status_brain
        ;;
    attach)
        attach_brain
        ;;
    send)
        shift
        send_command "$*"
        ;;
    logs)
        show_logs
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        error "Unknown command: $1"
        usage
        exit 1
        ;;
esac