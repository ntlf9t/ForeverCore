#!/usr/bin/env bash
# Everlake daily upstream check: lists what upstream has that `everlake` has not sorted yet. Read-only: it fetches,
# compares and prints Markdown on stdout; it never merges, pushes or changes a branch.
#
#   (a) advocaite/TrinityCore pull requests open on `forever` / `forever-bots` with no review log
#       (docs/upstream-prs/advocaite-<n>.md), and whether each still merges into `everlake` without conflicts;
#   (b) TrinityCore `master` commits since `everlake`'s branch point that are not in `everlake` (matched by
#       `git patch-id`, so a commit picked under another hash counts as in) and have no review log
#       (docs/upstream-prs/trinitycore-<first 10 characters>.md);
#   (c) commits on advocaite `forever` / `forever-bots` that are not in `everlake`: merged pull requests (with or
#       without a review log) and direct pushes (not matched by patch id);
#   (d) Karrz releases: Karrz1/Karrz-playerbots-wow-forever releases that have no `karrz-v<version>` tag on our
#       `karrz-releases` branch yet (docs/karrz-releases.md), with their date and the start of their notes;
#   (e) release-only files: the newest imported release (`karrz-v<version>`) against the last Karrz `forever-bots`
#       commit made before that release was published, ignoring whitespace and line endings: the files that exist or
#       differ only in the release zip (work Karrz keeps out of git) and the files only in git;
#   (f) Karrz git: commits on Karrz1/TrinityCore `forever` / `forever-bots` that are not ancestors of `everlake`,
#       newest first, each marked when the same patch (`git patch-id`) or the same subject is already in `everlake`.
#
# Usage: everlake-upstream-check.sh [everlake ref]   (default: the current HEAD)
# Needs: a clone with full history of `everlake`, network access to github.com, `gh` (logged in, or GH_TOKEN) for the
# pull request and release lists, git 2.38 or later (merge-tree --write-tree).
set -euo pipefail

EVERLAKE=$(git rev-parse --verify "${1:-HEAD}^{commit}")
TC_URL=https://github.com/TrinityCore/TrinityCore.git
ADV_URL=https://github.com/advocaite/TrinityCore.git
ADV_REPO=advocaite/TrinityCore
KARRZ_URL=https://github.com/Karrz1/TrinityCore.git
KARRZ_REPO=Karrz1/TrinityCore
KARRZ_RELEASES_REPO=Karrz1/Karrz-playerbots-wow-forever
OUR_URL=https://github.com/buildthehomelab/wow-trinitycore-everlake.git
LOGS=docs/upstream-prs
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fetch() { git fetch --quiet --no-tags "$@"; }

fetch "$TC_URL" "+refs/heads/master:refs/upstream-check/tc-master"
fetch "$ADV_URL" "+refs/heads/forever:refs/upstream-check/forever" "+refs/heads/forever-bots:refs/upstream-check/forever-bots"
fetch "$KARRZ_URL" "+refs/heads/forever:refs/upstream-check/karrz-forever" \
    "+refs/heads/forever-bots:refs/upstream-check/karrz-forever-bots"
fetch "$OUR_URL" "+refs/heads/karrz-releases:refs/upstream-check/karrz-releases" \
    "+refs/tags/karrz-v*:refs/upstream-check/karrz-tags/karrz-v*"
TC=refs/upstream-check/tc-master

# review logs present on everlake
git ls-tree --name-only "$EVERLAKE" "$LOGS/" | sed 's#.*/##' > "$WORK/logs"
has_log() { grep -qxF "$1" "$WORK/logs"; }

# patch ids of everything everlake has since it branched from TrinityCore master
BASE=$(git merge-base "$EVERLAKE" "$TC")
git log -p --no-merges "$BASE..$EVERLAKE" | git patch-id --stable | cut -d' ' -f1 | sort -u > "$WORK/everlake.pid"
in_everlake() { grep -qxF "$1" "$WORK/everlake.pid"; }
patch_id() { git show -p --no-merges "$1" | git patch-id --stable | cut -d' ' -f1; }

short() { git rev-parse --short=10 "$1"; }
subject() { git log -1 --format=%s "$1" | sed 's/|/\\|/g'; }

echo "# Upstream check"
echo
echo "\`everlake\` at $(short "$EVERLAKE"), $(date -u '+%Y-%m-%d %H:%M UTC'). Nothing here is merged automatically:"
echo "each item gets a review (docs/upstream-prs.md) and comes in by its own pull request."
echo

# (a) open pull requests without a review log
gh pr list -R "$ADV_REPO" --state open --limit 1000 \
    --json number,title,baseRefName,author,createdAt \
    --jq '.[] | select(.baseRefName == "forever" or .baseRefName == "forever-bots")
          | [.number, .baseRefName, .author.login, .createdAt[0:10], .title] | @tsv' \
    | sort -n > "$WORK/prs.tsv"
total_prs=$(wc -l < "$WORK/prs.tsv" | tr -d ' ')
: > "$WORK/prs_new.tsv"
while IFS=$'\t' read -r number base author created title; do
    has_log "advocaite-$number.md" || printf '%s\t%s\t%s\t%s\t%s\n' "$number" "$base" "$author" "$created" "$title" >> "$WORK/prs_new.tsv"
done < "$WORK/prs.tsv"
new_prs=$(wc -l < "$WORK/prs_new.tsv" | tr -d ' ')

echo "## (a) advocaite pull requests not reviewed yet: $new_prs of $total_prs open"
echo
if [ "$new_prs" -gt 0 ]; then
    refspecs=()
    while IFS=$'\t' read -r number _; do refspecs+=("+refs/pull/$number/head:refs/upstream-check/pr/$number"); done < "$WORK/prs_new.tsv"
    fetch "$ADV_URL" "${refspecs[@]}"
    echo "| PR | base | author | opened | merges into \`everlake\` | title |"
    echo "|---|---|---|---|---|---|"
    while IFS=$'\t' read -r number base author created title; do
        # exit 0: clean, 1: conflicts (not --quiet: with git 2.53 it exits 0 for a merge that conflicts)
        rc=0
        git merge-tree --write-tree --name-only "$EVERLAKE" "refs/upstream-check/pr/$number" > /dev/null 2>&1 || rc=$?
        case $rc in
            0) merges=clean ;;
            1) merges="**conflicts**" ;;
            *) merges="not checked (merge-tree error $rc)" ;;
        esac
        echo "| [#$number](https://github.com/$ADV_REPO/pull/$number) | $base | $author | $created | $merges | ${title//|/\\|} |"
    done < "$WORK/prs_new.tsv"
    echo
fi

# (b) TrinityCore master commits not in everlake and not logged
: > "$WORK/tc_new"
in_count=0; logged_count=0
while read -r commit; do
    if has_log "trinitycore-$(short "$commit").md"; then
        logged_count=$((logged_count + 1))
    elif in_everlake "$(patch_id "$commit")"; then
        in_count=$((in_count + 1))
    else
        echo "$commit" >> "$WORK/tc_new"
    fi
done < <(git rev-list --reverse --no-merges "$BASE..$TC")
tc_total=$((in_count + logged_count + $(wc -l < "$WORK/tc_new" | tr -d ' ')))

echo "## (b) TrinityCore \`master\` commits not sorted yet: $(wc -l < "$WORK/tc_new" | tr -d ' ') of $tc_total since $(short "$BASE")"
echo
echo "$logged_count have a review log, $in_count more are in \`everlake\` under another hash (same patch id) without one."
echo
if [ -s "$WORK/tc_new" ]; then
    echo "| commit | date | author | subject |"
    echo "|---|---|---|---|"
    while read -r commit; do
        echo "| [$(short "$commit")](https://github.com/TrinityCore/TrinityCore/commit/$commit) | $(git log -1 --format=%as "$commit") | $(git log -1 --format=%an "$commit") | $(subject "$commit") |"
    done < "$WORK/tc_new"
    echo
fi

# (c) advocaite branch commits not in everlake
echo "## (c) advocaite \`forever\` / \`forever-bots\` commits not in \`everlake\`"
echo
: > "$WORK/seen"
rows=0
for branch in forever forever-bots; do
    while read -r commit; do
        grep -qxF "$commit" "$WORK/seen" && continue
        echo "$commit" >> "$WORK/seen"
        parents=$(git rev-list --parents -n 1 "$commit" | wc -w)
        subj=$(subject "$commit")
        if [ "$parents" -gt 2 ]; then
            number=$(sed -n 's/^Merge pull request #\([0-9]*\) .*/\1/p' <<< "$subj")
            if [ -n "$number" ]; then
                has_log "advocaite-$number.md" && kind="merged PR #$number (reviewed)" || kind="merged PR #$number (**no review log**)"
            else
                kind="merge"
            fi
        else
            in_everlake "$(patch_id "$commit")" && continue
            kind="**direct push**"
        fi
        if [ "$rows" -eq 0 ]; then
            echo "| commit | branch | date | author | kind | subject |"
            echo "|---|---|---|---|---|---|"
        fi
        rows=$((rows + 1))
        echo "| [$(short "$commit")](https://github.com/$ADV_REPO/commit/$commit) | $branch | $(git log -1 --format=%as "$commit") | $(git log -1 --format=%an "$commit") | $kind | $subj |"
    done < <(git rev-list --reverse --first-parent "$EVERLAKE..refs/upstream-check/$branch")
done
[ "$rows" -eq 0 ] && echo "None: \`everlake\` has everything on both branches."
echo

# Karrz (docs/karrz-releases.md). The two short parts come first and the long commit list last, so that the issue
# body, which is cut at 60,000 characters, keeps the release parts.

# (d) Karrz releases not imported yet
imported=$(git for-each-ref --sort=-version:refname --merged refs/upstream-check/karrz-releases \
    --format='%(refname:lstrip=3)' refs/upstream-check/karrz-tags/)
latest_imported=$(head -n 1 <<< "$imported")
releases_ok=true
gh api "repos/$KARRZ_RELEASES_REPO/releases?per_page=30" \
    --jq '.[] | select(.draft | not) | [.tag_name, .published_at, .prerelease] | @tsv' > "$WORK/releases.tsv" \
    || releases_ok=false
: > "$WORK/releases_new.tsv"
if $releases_ok; then
    while IFS=$'\t' read -r tag published pre; do
        grep -qxF "karrz-$tag" <<< "$imported" || printf '%s\t%s\t%s\n' "$tag" "$published" "$pre" >> "$WORK/releases_new.tsv"
    done < "$WORK/releases.tsv"
    newest_release=$(head -n 1 "$WORK/releases.tsv" | cut -f1)
    echo "## (d) Karrz releases not imported yet: $(wc -l < "$WORK/releases_new.tsv" | tr -d ' ')"
    echo
    echo "Newest release: ${newest_release:-none} ([releases](https://github.com/$KARRZ_RELEASES_REPO/releases))." \
        "Newest import on \`karrz-releases\`: ${latest_imported:-none}. How to import: docs/karrz-releases.md."
else
    echo "## (d) Karrz releases: not checked"
    echo
    echo "The release list of $KARRZ_RELEASES_REPO could not be read this run." \
        "Newest import on \`karrz-releases\`: ${latest_imported:-none}."
fi
echo
while IFS=$'\t' read -r tag published pre; do
    [ "$pre" = true ] && kind=" (pre-release)" || kind=""
    echo "**Release $tag not imported yet**$kind, published $(sed 's/T/ /; s/Z$//' <<< "$published") UTC:"
    echo
    # awk reads all of its input, so nothing before it gets SIGPIPE (pipefail would end the script)
    { gh api "repos/$KARRZ_RELEASES_REPO/releases/tags/$tag" --jq '.body // ""' || echo "(notes could not be read)"; } \
        | tr -d '\r' | awk 'NF && n++ < 8 { print "> " $0 }'
    echo
done < "$WORK/releases_new.tsv"

# (e) files that exist or differ only in the newest imported release zip
echo "## (e) Release-only files in ${latest_imported:-the newest imported release}"
echo
if [ -n "$latest_imported" ]; then
    rel=refs/upstream-check/karrz-tags/$latest_imported
    published=$(git log -1 --format=%aI "$rel")   # the import dates each commit when the release was published
    nearest=$(git rev-list -1 --first-parent --before="$published" "refs/upstream-check/karrz-forever-bots")
    excludes=(-- . ':!sql/old' ':!.github' ':!repack' ':!scripts' ':!tools')
    git diff -w --ignore-cr-at-eol --no-renames --name-status "$nearest" "$rel" "${excludes[@]}" > "$WORK/rel.status"
    git diff -w --ignore-cr-at-eol --no-renames --numstat "$nearest" "$rel" "${excludes[@]}" > "$WORK/rel.numstat"
    # status (A, D, or M for any other change) + line counts, without files whose only change is whitespace or line
    # endings
    awk -F'\t' 'NR == FNR { s = substr($1, 1, 1); status[$2] = (s == "A" || s == "D") ? s : "M"; next }
                !(status[$3] == "M" && $1 == "0" && $2 == "0") { print status[$3] "\t" $1 "\t" $2 "\t" $3 }' \
        "$WORK/rel.status" "$WORK/rel.numstat" > "$WORK/rel.tsv"
    only_zip=$(awk -F'\t' '$1 == "A"' "$WORK/rel.tsv" | wc -l | tr -d ' ')
    differ=$(awk -F'\t' '$1 == "M"' "$WORK/rel.tsv" | wc -l | tr -d ' ')
    only_git=$(awk -F'\t' '$1 == "D"' "$WORK/rel.tsv" | wc -l | tr -d ' ')
    echo "$latest_imported (published ${published%%+*}) against the last Karrz \`forever-bots\` commit before it,"
    echo "[$(short "$nearest")](https://github.com/$KARRZ_REPO/commit/$nearest) ($(git log -1 --format=%cI "$nearest"), $(subject "$nearest"))."
    echo "Whitespace and line endings ignored; \`sql/old\`, \`.github\`, \`repack/\`, \`scripts/\`, \`tools/\` left out."
    echo "**$only_zip only in the zip, $differ differ, $only_git only in git.** By folder:"
    echo
    echo "| folder | only in zip | differ | only in git |"
    echo "|---|---|---|---|"
    awk -F'\t' '{ n = split($4, p, "/"); d = (n > 2 ? p[1] "/" p[2] : (n > 1 ? p[1] : "(top)"))
                  if (d ~ /^(src\/(modules|server)|sql\/custom)$/ && n > 3) d = d "/" p[3]
                  gsub(/\|/, "\\|", d); k[d]; c[d, $1]++ }
                END { for (d in k) printf "| %s | %d | %d | %d |\n", d, c[d, "A"], c[d, "M"], c[d, "D"] }' \
        "$WORK/rel.tsv" | sort
    echo
    echo "<details><summary>All $((only_zip + differ + only_git)) files</summary>"
    echo
    echo "| file | where | lines |"
    echo "|---|---|---|"
    awk -F'\t' '{ w = ($1 == "A" ? "only in zip" : ($1 == "D" ? "only in git" : "differs"))
                  f = $4; gsub(/\|/, "\\|", f)
                  l = ($2 == "-" ? "binary" : "+" $2 " -" $3)
                  printf "| `%s` | %s | %s |\n", f, w, l }' "$WORK/rel.tsv"
    echo
    echo "</details>"
else
    echo "No \`karrz-v*\` tag on \`karrz-releases\` yet."
fi
echo

# (f) Karrz git commits not in everlake. Ancestry first: once a Karrz commit is merged into everlake (as a merge
# parent), it and everything before it drop out. For the rest, mark the ones whose patch or subject is already in
# everlake (ported by hand, cherry-picked, or taken through an advocaite pull request), and the ones advocaite's
# branches also have (those show in (c) too).
KARRZ_MAX_ROWS=100
KF=refs/upstream-check/karrz-forever
KB=refs/upstream-check/karrz-forever-bots
git rev-list --no-merges "$KF" "^$EVERLAKE" > "$WORK/karrz_forever"
git rev-list --no-merges refs/upstream-check/forever refs/upstream-check/forever-bots "^$EVERLAKE" > "$WORK/adv_new"
git rev-list --no-merges --date-order "$KB" "$KF" "^$EVERLAKE" > "$WORK/karrz_new"
karrz_total=$(wc -l < "$WORK/karrz_new" | tr -d ' ')
git log --format=%s "$BASE..$EVERLAKE" | sort -u > "$WORK/everlake.subjects"
# one pass: "<patch id> <commit>" for every listed commit (a commit with no diff has no patch id)
: > "$WORK/karrz.pid"
if [ "$karrz_total" -gt 0 ]; then
    git log -p --no-walk=unsorted --stdin < "$WORK/karrz_new" | git patch-id --stable > "$WORK/karrz.pid"
fi
same_patch=0; same_subject=0; on_adv=0
: > "$WORK/karrz_rows.tsv"
while read -r commit; do
    pid=$(awk -v c="$commit" '$2 == c { print $1; exit }' "$WORK/karrz.pid")
    subj=$(git log -1 --format=%s "$commit")
    if [ -n "$pid" ] && in_everlake "$pid"; then
        mark="same patch"; same_patch=$((same_patch + 1))
    elif grep -qxF -- "$subj" "$WORK/everlake.subjects"; then
        mark="same subject"; same_subject=$((same_subject + 1))
    else
        mark="-"   # never empty: read with IFS=tab would merge two tabs and shift the columns
    fi
    if grep -qxF "$commit" "$WORK/adv_new"; then adv=yes; on_adv=$((on_adv + 1)); else adv="-"; fi
    grep -qxF "$commit" "$WORK/karrz_forever" && branch=forever || branch=forever-bots
    printf '%s\t%s\t%s\t%s\t%s\n' "$commit" "$branch" "$mark" "$adv" "$subj" >> "$WORK/karrz_rows.tsv"
done < "$WORK/karrz_new"
karrz_mb=$(git merge-base "$EVERLAKE" "$KB" || true)

echo "## (f) Karrz git: \`forever\` / \`forever-bots\` commits not in \`everlake\`: $karrz_total"
echo
if [ -n "$karrz_mb" ]; then
    echo "Newest commit \`everlake\` shares with Karrz \`forever-bots\`:" \
        "[$(short "$karrz_mb")](https://github.com/$KARRZ_REPO/commit/$karrz_mb), $(git log -1 --format=%as "$karrz_mb"), $(subject "$karrz_mb")."
    echo
fi
if [ "$karrz_total" -gt 0 ]; then
    echo "Merges left out. $same_patch have the same patch in \`everlake\` and $same_subject more the same subject;" \
        "the other $((karrz_total - same_patch - same_subject)) are not in \`everlake\` in any form we can match." \
        "$on_adv are on advocaite \`forever\` / \`forever-bots\` too, so (c) lists them as well."
    echo
    echo "| commit | branch | date | author | already in \`everlake\` | on advocaite | subject |"
    echo "|---|---|---|---|---|---|---|"
    head -n "$KARRZ_MAX_ROWS" "$WORK/karrz_rows.tsv" | while IFS=$'\t' read -r commit branch mark adv subj; do
        [ "$mark" = "-" ] && mark=""
        [ "$adv" = "-" ] && adv=""
        echo "| [$(short "$commit")](https://github.com/$KARRZ_REPO/commit/$(short "$commit")) | $branch | $(git log -1 --format=%as "$commit") | $(git log -1 --format=%an "$commit") | $mark | $adv | ${subj//|/\\|} |"
    done
    if [ "$karrz_total" -gt "$KARRZ_MAX_ROWS" ]; then
        echo
        echo "And $((karrz_total - KARRZ_MAX_ROWS)) older ones: \`git log --no-merges karrz/forever-bots ^everlake\`."
    fi
else
    echo "None: \`everlake\` has everything on both branches."
fi
echo
