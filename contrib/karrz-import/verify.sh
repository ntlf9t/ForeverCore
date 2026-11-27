#!/usr/bin/env bash
# For each version: build the git tree of the release zip in a throwaway index and compare it
# with tag karrz-v<ver>, ignoring sql/old and .github (not packaged in later zips).
# usage: verify-karrz.sh <zips-dir> <extract-dir> <repo> <version>...
set -uo pipefail
ZIPS=$1 X=$2 REPO=$3; shift 3
for v in "$@"; do
  rm -rf "$X/v-$v"; mkdir -p "$X/v-$v"
  unzip -q "$ZIPS/$v/wow-forever-source-$v.zip" -d "$X/v-$v" || [ $? -eq 1 ] || { echo "$v UNZIP FAIL"; continue; }
  src=$(find "$X/v-$v" -mindepth 1 -maxdepth 1 -type d | head -1)
  idx="$X/v-$v.index"; rm -f "$idx"
  tree=$(cd "$REPO" && GIT_INDEX_FILE="$idx" git --work-tree="$src" -c core.fileMode=false add -A --force 2>/dev/null \
         && GIT_INDEX_FILE="$idx" git write-tree)
  # Files upstream stores with CRLF keep CRLF in the commit (git does not renormalise them);
  # a fresh index stores them as LF. Count a file as different only if it differs with CRs removed.
  bad=0 crlf=0
  while read -r f; do
    if cmp -s <(cd "$REPO" && git show "$tree:$f" 2>/dev/null | tr -d '\r') <(cd "$REPO" && git show "karrz-v$v:$f" 2>/dev/null | tr -d '\r'); then
      crlf=$((crlf+1)); else bad=$((bad+1)); echo "  DIFF $f"; fi
  done < <(cd "$REPO" && git diff --name-only "$tree" "karrz-v$v" -- . ':!sql/old' ':!.github')
  [ "$bad" = 0 ] && echo "$v OK ($crlf files kept upstream CRLF)" || echo "$v DIFF $bad files"
  rm -rf "$X/v-$v" "$idx"
done
