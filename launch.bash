#!/bin/bash
# Usage: ./launch.bash [work_dir] [sources_dir]
# Defaults: ./workspace -> /workspace (read-write)
#           ./Sources   -> /Sources   (read-only)
# Relative paths (and symlinks) are resolved from the current directory.

WORK="$(realpath -m "${1:-./workspace}")"
SOURCES="$(realpath -m "${2:-./Sources}")"

# Create them as the current user (otherwise Docker creates them as root)
mkdir -p "$WORK" "$SOURCES"

docker run -it --rm --name claude-code \
  --user "$(id -u):$(id -g)" \
  -v "$WORK":/workspace \
  -v "$SOURCES":/Sources:ro \
  -v claude-home:/home/ubuntu/.claude \
  claude-code-env
