#!/bin/bash

set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

TAGS=$(find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | grep '^[^\.]')
PARTIAL_0=$(cat ./Dockerfile-0)

function generate() {
	local template="$1"
	local target="$2"
	if [ -f "$target" ]; then
		cat "$template" |
			PARTIAL_0="$PARTIAL_0" \
			envsubst >"$target"
		echo "$target updated."
	else
		echo >&2 "File not found ($target)"
		exit 2
	fi
}

function generate_by_tag() {
	local tag="$1"
	local template="./Dockerfile-$tag.template"
	local target="./$tag/Dockerfile"
	generate "$template" "$target"
}

for tag in $TAGS; do
	generate_by_tag "$tag"
done
