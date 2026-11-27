#!/usr/bin/env bash
# Import Karrz1/Karrz-playerbots-wow-forever release source zips as one commit each
# on the current branch of the worktree WT. Zips are data only: unpacked and copied, never run.
# usage: import-karrz.sh <zips-dir> <extract-dir> <worktree> <version>...
set -euo pipefail
ZIPS=$1 X=$2 WT=$3; shift 3
REPO=Karrz1/Karrz-playerbots-wow-forever
AUTHOR="Karrz1 <127596890+Karrz1@users.noreply.github.com>"

for v in "$@"; do
  z="$ZIPS/$v/wow-forever-source-$v.zip"
  sum=$(shasum -a 256 "$z" | cut -d' ' -f1)
  grep -q "$sum" "$ZIPS/$v/SHA256SUMS.txt" || { echo "CHECKSUM MISMATCH $v"; exit 1; }
  date=$(gh release view "v$v" -R $REPO --json publishedAt -q .publishedAt)
  notes=$(gh release view "v$v" -R $REPO --json body -q .body | tr -d '\r')

  rm -rf "$X/$v"; mkdir -p "$X/$v"
  # exit 1 = warnings only (some zips were made on Windows with backslash paths; unzip converts them)
  unzip -q "$z" -d "$X/$v" || [ $? -eq 1 ]
  src="$X/$v/wow-forever-source-$v"
  [ -d "$src" ] || src=$(find "$X/$v" -mindepth 1 -maxdepth 1 -type d | head -1)
  pin=$(awk '/^commit:/{print $2}' "$src/UPSTREAM_PIN" 2>/dev/null || echo none)

  # Mirror the zip into the worktree. sql/old and .github are not packaged in the zips,
  # so keep the base copies instead of recording them as deleted.
  rsync -a --delete --filter='P /.git' --filter='P /sql/old/' --filter='P /.github/' "$src/" "$WT/"

  cd "$WT"
  # --force: TrinityCore's .gitignore ignores sql/custom/*, where Karrz keeps his SQL data
  git -c core.fileMode=false add -A --force
  # A release whose source matches the previous one still gets a (empty) commit, to keep its notes.
  git diff --cached --quiet && echo "$v: source same as previous release"
  GIT_AUTHOR_DATE="$date" git -c core.fileMode=false commit -q --allow-empty --author="$AUTHOR" -F - <<EOF
Karrz release v$v (source zip)

Imported unchanged from https://github.com/$REPO/releases/tag/v$v
asset wow-forever-source-$v.zip, sha256 $sum
UPSTREAM_PIN: advocaite/TrinityCore forever $pin
Line endings normalised to LF by .gitattributes; sql/old and .github are not in the zip and are kept from the base.

Release notes (as published by Karrz1):

$notes
EOF
  git tag -f "karrz-v$v" >/dev/null
  echo "$v pin=${pin:0:10} $(git show --shortstat --format= HEAD | sed 's/^ //')"
  cd - >/dev/null
  rm -rf "$X/$v"
done
