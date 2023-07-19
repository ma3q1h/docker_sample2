#!/bin/bash
set -eu
cat <<EOT > .env
COMPOSE_PROJECT_NAME="composename"
TAG=v1.0
USER=`whoami`
UID=`id -u`
GID=`id -g`
USER_PASSWD="user"
ROOT_PASSWD="root"
PYTHON_VERSION="3.9.17"
SSH_PORT="22"
Jupyter_PORT="8888"
HOST_PORT="23"
CONTAINER_PORT="22"
EOT

# do "docker compose config" and check