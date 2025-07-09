# Idea, use a Claude Code instance as a "brain" that can stay alive indeffinately and get piped different commands, acting as a supervisor agent

## Start the brain (from terminal window 1)

* `tmux new-session -d -s claude_brain`

## Attach to the brain, just to wtach it work and think (from terminal window 2)

* `tmux attach -t claude_brain`

## Send commands to the brain (from terminal window 1)

* `tmux send-keys -t claude_brain:0 "claude --dangerously-skip-permissions"`
* `tmux send-keys -t claude_brain:0 Enter`
* `tmux send-keys -t claude_brain:0 "/status"`
* `tmux send-keys -t claude_brain:0 Enter`
* `tmux send-keys -t claude_brain:0 Enter`
* `tmux send-keys -t claude_brain:0 "Whats the capital of France? Then write me a script to check for prime numbers."`
* `tmux send-keys -t claude_brain:0 Enter`
* * `tmux send-keys -t claude_brain:0 "Is 457892 a prime number?"`
* `tmux send-keys -t claude_brain:0 Enter`

## Kill the brain (from terminal window 1)

* `tmux kill-server`

## List the sessions (from terminal window 1)

* `tmux list-sessions`

# Hooks

## You can probably use hooks here to log comamnds etc

[Hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)
