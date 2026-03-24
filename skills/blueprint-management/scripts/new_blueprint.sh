#!/usr/bin/env bash
# new_blueprint.sh
#
# Initializes a blueprint.json for a project by copying the canonical
# blueprint-example.json template into the project's .planning/ directory.
#
# Usage:
#   new_blueprint.sh [working_dir] [skill_dir]
#
# Arguments:
#   working_dir  Optional. Absolute path to the project root where .planning/
#                will be created. Defaults to the current working directory.
#                Must not contain path traversal sequences (e.g. ..).
#   skill_dir    Optional. Absolute path to the skill's root directory
#                (the folder containing assets/). Defaults to the directory
#                one level above this script. Pass ${CLAUDE_SKILL_DIR} from
#                SKILL.md so the correct path is resolved by Claude Code.
#
# Output:
#   Creates <working_dir>/.planning/blueprint.json from the skill's
#   assets/blueprint-example.json. The .planning/ directory is created if it
#   does not already exist.
#
# Exit codes:
#   0  Blueprint created successfully.
#   1  Invalid or unsafe path argument, or copy failed (inherited from cp/mkdir).

set -euo pipefail

# Use the provided skill dir, or fall back to resolving relative to this script.
SKILL_DIR="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd)}"
ASSET="$SKILL_DIR/assets/blueprint-example.json"

# Allow callers to specify a target working directory; fall back to $PWD.
WORKING_DIR="${1:-$PWD}"

# Reject any path that contains traversal sequences.
if [[ "$WORKING_DIR" == *".."* ]]; then
    echo "Error: working_dir must not contain path traversal sequences (..)" >&2
    exit 1
fi

if [[ "$SKILL_DIR" == *".."* ]]; then
    echo "Error: skill_dir must not contain path traversal sequences (..)" >&2
    exit 1
fi

TARGET_DIR="$WORKING_DIR/.planning"

mkdir -p "$TARGET_DIR"
cp "$ASSET" "$TARGET_DIR/blueprint.json"
echo "Blueprint initialized at $TARGET_DIR/blueprint.json"

