#!/bin/bash
# dev-session.sh - Automated development environment setup

SESSION="dev"

# Check if session already exists
tmux has-session -t $SESSION 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Session '$SESSION' already exists. Attaching..."
    tmux attach -t $SESSION
    exit 0
fi

# Create a new detached session with the first window named "editor"
tmux new-session -d -s $SESSION -n emacs-window

# Open the editor in the first window
tmux send-keys -t $SESSION:emacs-window "$HOME/.emacs.d/start-emacs-worker.sh" Enter

# Create a second window for general terminal use
tmux new-window -t $SESSION -n terminal

# Select the editor window as the active window
tmux select-window -t $SESSION:emacs-window

# Attach to the session
tmux attach -t $SESSION