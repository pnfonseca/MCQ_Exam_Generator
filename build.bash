docker build -t claude-code-env \
  --build-arg USER_UID=$(id -u) \
  --build-arg USER_GID=$(id -g) .