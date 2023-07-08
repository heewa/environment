#!/bin/bash

BOX="$1"
SOCKET_DIR="$HOME/.local/state/tmux"
SOCKET="$SOCKET_DIR/$BOX"

if [[ -z "$BOX" ]]; then
    echo 'No distrobox specified' >&2
    exit 1
fi

mkdir -p "$SOCKET_DIR" || exit 1

# Start a tmux server (with a unique socket) inside the container, so
# everything it creates is also in that container.
distrobox enter "$BOX" -- tmux -S "$SOCKET" new-session -A -s "$BOX" \; detach-client || exit 1

# But, attach to it with a client from outside the container.
if [[ $(tmux -S "$SOCKET" lsc -t "$BOX") ]]; then
    exec tmux -S "$SOCKET" new-session
else
    exec tmux -S "$SOCKET" new-session -A -s "$BOX"
fi
