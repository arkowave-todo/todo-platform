#!/usr/bin/env bash
# Usage: apply-repo-rules.sh <repo> <required-approvals>
set -euo pipefail
export GH_PAGER=cat

ORG=arkowave-todo
REPO=$1
APPROVALS=$2

if gh api "repos/$ORG/$REPO/rulesets" --jq '.[].name' | grep -qx main-protection; then
  echo "$REPO: ruleset already exists, skipping"
else
  gh api "repos/$ORG/$REPO/rulesets" --method POST --input - >/dev/null <<EOF
{
  "name": "main-protection",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [],
  "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    { "type": "pull_request", "parameters": {
        "required_approving_review_count": $APPROVALS,
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false } }
  ]
}
EOF
  echo "$REPO: ruleset created"
fi

gh api "repos/$ORG/$REPO" --method PATCH --input - >/dev/null <<EOF
{ "security_and_analysis": {
    "secret_scanning": { "status": "enabled" },
    "secret_scanning_push_protection": { "status": "enabled" } } }
EOF
echo "$REPO: security settings applied"
echo "$REPO: done"
