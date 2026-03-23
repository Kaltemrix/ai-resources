#!/usr/bin/env bash
# new_blueprint.sh
#
# Initializes a blueprint.json for a project by copying the canonical
# blueprint-example.json template into the project's .planning/ directory.
#
# Usage:
#   new_blueprint.sh [working_dir]
#
# Arguments:
#   working_dir  Optional. Absolute path to the project root where .planning/
#                will be created. Defaults to the current working directory.
#
# Output:
#   Creates <working_dir>/.planning/blueprint.json from the skill's
#   assets/blueprint-example.json. The .planning/ directory is created if it
#   does not already exist.
#
# Exit codes:
#   0  Blueprint created successfully.
#   1  Asset file not found, or copy failed (inherited from cp/mkdir).

set -euo pipefail

# Resolve the skill root relative to this script so the asset path is fixed
# regardless of where the script is invoked from.
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSET="$SKILL_DIR/assets/blueprint-example.json"

# Allow callers to specify a target working directory; fall back to $PWD.
WORKING_DIR="${1:-$PWD}"
TARGET_DIR="$WORKING_DIR/.planning"

mkdir -p "$TARGET_DIR"
cp "$ASSET" "$TARGET_DIR/blueprint.json"
echo "Blueprint initialized at $TARGET_DIR/blueprint.json"
