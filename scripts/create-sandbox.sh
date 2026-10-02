#!/usr/bin/env bash
# Usage: create-sandbox.sh <sandbox-name> <repo> <policy-file> [provider]
set -euo pipefail

NAME=$1
REPO=$2
POLICY=$3
PROVIDER=${4:-}
ORG=arkowave-todo
IMAGE=localhost/todo-sandbox-base:0.3

args=(--name "$NAME" --from "$IMAGE" --policy "$POLICY" --no-auto-providers --detach)
if [ -n "$PROVIDER" ]; then
  args+=(--provider "$PROVIDER")
fi

openshell sandbox create "${args[@]}" -- sleep infinity

openshell sandbox exec -n "$NAME" --no-tty -- bash -s <<EOF
set -e
git clone https://github.com/$ORG/$REPO.git ~/$REPO
cd ~/$REPO
git config --local credential.helper '!f() { echo username=x-access-token; echo password=\$GITHUB_TOKEN; }; f'
git config user.name arkowave-agent
git config user.email agent@arkowave.com
git status --short --branch
EOF

echo "$NAME: ready. Open a shell with: openshell sandbox exec -n $NAME --tty -- /bin/bash -l"
