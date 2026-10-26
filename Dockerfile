# See https://aka.ms/vscode-remote/devcontainer for more information.
# This Dockerfile is used to build a custom devcontainer image for VS Code.

FROM ubuntu:24.04

# Avoid interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and TeX Live
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        texlive-full \
        build-essential \
        curl \
        git \
        ca-certificates \
        locales \
        sudo \
        less \
        vim \
        && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu

ARG USERNAME=devcontainer
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Only create group/user if they do not already exist
RUN if ! getent group $USER_GID >/dev/null; then groupadd --gid $USER_GID $USERNAME; fi \
    && if ! id -u $USERNAME >/dev/null 2>&1; then useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; fi \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspace
