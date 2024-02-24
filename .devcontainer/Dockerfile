FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    python3-pip python3-venv tmux powerline fonts-powerline console-setup python3-dev python3-setuptools python3-wheel \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
USER vscode
RUN pip3 install --user pre-commit checkov
