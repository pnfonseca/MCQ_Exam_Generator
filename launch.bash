#!/bin/bash

# Important: Before running, adjust the reference-docs location!
docker run -it --rm --name claude-code \
  --user $(id -u):$(id -g) \
  -v "$(pwd)/workspace:/workspace" \
  -v "$HOME/reference-docs:/Sources:ro" \
  claude-code-env