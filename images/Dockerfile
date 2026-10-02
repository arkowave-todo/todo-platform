FROM public.ecr.aws/docker/library/node:22-bookworm-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git iproute2 jq python3 python-is-python3 \
 && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code@2.1.286

RUN mkdir -p /etc/claude-code \
 && printf '%s\n' '{"env":{"DISABLE_AUTOUPDATER":"1","CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC":"1"}}' > /etc/claude-code/managed-settings.json

RUN userdel -r node \
 && groupadd -g 1000 sandbox \
 && useradd -m -d /sandbox -u 1000 -g 1000 -s /bin/bash sandbox

USER sandbox
WORKDIR /sandbox
