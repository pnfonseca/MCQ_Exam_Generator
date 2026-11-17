FROM ubuntu:26.04

# Build-time only; doesn't leak into the running container
ARG DEBIAN_FRONTEND=noninteractive

# Union of both package sets; clean the apt cache to keep the image small
RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        ca-certificates \
        nodejs \
        npm \
        less \
        nano \
        vim \
        build-essential \
        poppler-utils \
        pandoc \
        locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Full UTF-8 locale (C.UTF-8 only marks ASCII as printable, so accented
# PT-PT filenames/content get octal-escaped by ls and friends)
ARG LOCALE=pt_PT.UTF-8
RUN locale-gen ${LOCALE} && update-locale LANG=${LOCALE}
ENV LANG=${LOCALE} \
    LC_ALL=${LOCALE}

# Match the 'ubuntu' user to the host UID/GID so files in mounted folders
# are owned by the host user
ARG USER_UID=1000
ARG USER_GID=1000
RUN if [ "$USER_GID" != "1000" ]; then groupmod --gid "$USER_GID" ubuntu; fi && \
    if [ "$USER_UID" != "1000" ]; then usermod --uid "$USER_UID" ubuntu; fi && \
    mkdir -p /workspace /Sources && \
    chown -R "$USER_UID:$USER_GID" /home/ubuntu /workspace

USER ubuntu
ENV HOME=/home/ubuntu
WORKDIR /home/ubuntu

# Install Claude Code (change CLAUDE_CACHEBUST to force a fresh install)
ARG CLAUDE_CACHEBUST=0
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="${HOME}/.local/bin:${PATH}"

# Fail the build if the install didn't work
RUN claude --version

WORKDIR /workspace
CMD ["/bin/bash"]
