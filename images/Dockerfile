FROM public.ecr.aws/docker/library/node:22-bookworm-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git iproute2 \
 && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

RUN userdel -r node \
 && groupadd -g 1000 sandbox \
 && useradd -m -d /sandbox -u 1000 -g 1000 -s /bin/bash sandbox

USER sandbox
WORKDIR /sandbox
