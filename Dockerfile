FROM ubuntu:26.04

ARG DEBIAN_FRONTEND=noninteractive

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
        poppler-utils \
        build-essential \
        pandoc \
        locales

# Full UTF-8 locale (not just C.UTF-8 -- glibc's C.UTF-8 decodes UTF-8
# correctly but its ctype tables only mark plain ASCII as printable, so
# accented PT-PT filenames/content still get octal-escaped by ls, etc.)
RUN locale-gen pt_PT.UTF-8 && \
    update-locale LANG=pt_PT.UTF-8
ENV LANG=pt_PT.UTF-8
ENV LC_ALL=pt_PT.UTF-8

ARG USER_UID=1000
ARG USER_GID=1000

# Adjust the pre-existing 'ubuntu' user/group to match host UID/GID if needed
RUN if [ "$USER_GID" != "1000" ]; then groupmod --gid $USER_GID ubuntu; fi && \
    if [ "$USER_UID" != "1000" ]; then usermod --uid $USER_UID ubuntu; fi && \
    chown -R $USER_UID:$USER_GID /home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu



# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH="/home/ubuntu/.local/bin:${PATH}"

WORKDIR /workspace

CMD ["/bin/bash"]
