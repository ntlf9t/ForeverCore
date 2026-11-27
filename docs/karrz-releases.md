# Karrz: git and releases

Karrz1 publishes WoW Forever Bots in two places, and they are not the same code:

| source | what it is | what only it has |
|---|---|---|
| **Karrz git**: [Karrz1/TrinityCore](https://github.com/Karrz1/TrinityCore) `forever` (core) and `forever-bots` (core + bots, `forever` merged in) | real commit history on advocaite `forever` `f63ffc12b3` | the commits made after the latest release |
| **Karrz releases**: [Karrz1/Karrz-playerbots-wow-forever](https://github.com/Karrz1/Karrz-playerbots-wow-forever) release asset `wow-forever-source-<version>.zip` (git `main` there stopped on 2026-10-21) | one source snapshot per release, near-daily | features kept out of git: for 0.1.35, bot hiring (`src/modules/PlayerbotV2/Fleet/Hire*`, `sql/playerbot_v2/0037_hired_bots.sql`) and the Ring of Law + Mak'gora arena hotfixes; for 0.1.36 nearly the whole release (his git got one commit between 0.1.35's follow-ups and 0.1.36) |

We track both:

1. **Karrz git comes into `everlake` by git merge.** Starting with 0.1.35, `everlake` merges a Karrz `forever-bots`
   commit as a real merge parent (0.1.35: `9fe2e33df0`, the last commit before the release; that merge is in progress
   on 2026-11-12), so each later Karrz update is again a merge of the newer commits, reviewed like any upstream pull
   request (`docs/upstream-prs.md`).
2. **Every release is imported** as one commit on branch **`karrz-releases`** (below), so the zips can be read and
   diffed like git.
3. **Release-only work is ported by hand**: what a release has that Karrz git does not comes into `everlake` in its
   own reviewed pull request, logged in `docs/upstream-prs/karrz-*.md`.

The daily **Upstream check** (`.github/workflows/everlake-upstream-check.yml`, one issue kept up to date) shows what
is left on each side:

- **(d) Karrz releases**: releases with no `karrz-v<version>` tag on `karrz-releases` yet, with date and the start of
  their notes. Import them as below.
- **(e) Release-only files**: the newest imported release against the last Karrz `forever-bots` commit before it
  was published (whitespace and line endings ignored; `sql/old`, `.github`, `repack/`, `scripts/`, `tools/` left
  out). Files "only in zip" or "differ" are the release-only work to port in step 3; "only in git" are files the zip
  drops.
- **(f) Karrz git**: `forever` / `forever-bots` commits that are not ancestors of `everlake`, newest first, marked
  when the same patch or the same subject is already in `everlake` (work that came in by hand or through advocaite
  before the merges) and when advocaite's branches have them too (then (c) lists them as well). It comes last
  because it is the long one: the issue body is cut at 60,000 characters, the run summary has everything.

## The branch

- Root: advocaite `forever` `f63ffc12b3` (2026-10-09), the commit every release names in its `UPSTREAM_PIN`.
  Every release so far (v0.1.12 to v0.1.35) keeps that pin, so the branch is one straight line.
- One commit per release, oldest first, author Karrz1, dated when the release was published. The commit message
  holds the release notes as Karrz1 published them and the zip's sha256 (checked against the release's
  `SHA256SUMS.txt`). A release whose source did not change (only binaries did) is an empty commit, to keep its notes.
- Tag per release: `karrz-v<version>`.
- The zips do not contain `sql/old/` (and some `.github/` files); the import keeps the base copies, so a commit shows
  only real changes. Everything else in the zip is committed, including the `sql/custom/` data that TrinityCore's
  `.gitignore` would skip.
- Line endings: Karrz's zips are CRLF. `.gitattributes` (`* text=auto`) stores them as LF, except 10 files that
  upstream already stores with CRLF, which keep their upstream bytes.

Useful reads:

```bash
git log --reverse karrz-releases                                  # release notes, release by release
git diff karrz-v0.1.32.1 karrz-v0.1.33 -- src/modules/PlayerbotV2 # what one release changed in the bots
git diff f63ffc12b3 karrz-v0.1.33 -- sql/custom/world             # all of Karrz's world data
```

`karrz-releases` is never merged into `everlake`: its commits are snapshots, not Karrz's history. Karrz git is what
gets merged (step 1 above); from `karrz-releases` only the release-only work comes in, in reviewed batches by area
(bots, core, scripts, world data, hotfixes), each logged like the upstream pull requests in `docs/upstream-prs.md`.

## Importing a new release

```bash
# zips go in their own folder, outside any checkout; nothing in them is run
v=0.1.34
gh release download v$v -R Karrz1/Karrz-playerbots-wow-forever -D <zips>/$v \
  -p "wow-forever-source-$v.zip" -p SHA256SUMS.txt
git -C <karrz-releases worktree> switch karrz-releases
bash contrib/karrz-import/import.sh <zips> <scratch> <karrz-releases worktree> $v
bash contrib/karrz-import/verify.sh <zips> <scratch> <karrz-releases worktree> $v   # expect "OK"
git -C <karrz-releases worktree> push origin karrz-releases karrz-v$v
```

`import.sh` stops on a checksum mismatch. If a new release moves `UPSTREAM_PIN`, the commit message shows the new
pin; record the move here before porting from that release.

## Imported

2026-11-08/09: v0.1.12 to v0.1.33 (34 releases), each checked against its zip with `verify.sh`.
2026-11-10: v0.1.34 (pin unchanged, `f63ffc12b3`), checked with `verify.sh`.
2026-11-12: v0.1.35 (pin unchanged, `f63ffc12b3`), tag `karrz-v0.1.35` = `6dae366c19`.
2026-11-13: v0.1.36 (pin unchanged, `f63ffc12b3`), tag `karrz-v0.1.36` = `441114b453`, checked with `verify.sh`.
2026-11-14 and 2026-11-16: v0.1.36.1, v0.1.37, v0.1.37.1, v0.1.37.2, v0.1.37.3 (pin unchanged, `f63ffc12b3`), checked with `verify.sh`.

From v0.1.37.5 on, the releases have no `wow-forever-source-<version>.zip` (v0.1.37.4 is the last one with it), so
`import.sh` cannot import them. The release repo's `v0.1.39.1` tag points at the same commit as `v0.1.39` and does not
hold the 0.1.39.1 SQL. Karrz git is complete instead: Karrz1/TrinityCore is now
[Karrz1/ForeverCore](https://github.com/Karrz1/ForeverCore) (same repo, renamed), and its `forever-bots` holds each
release (0.1.38 `8e679df0e1`, merged in #105; 0.1.39 `b441bf74e0`; 0.1.39.1 `7509ecbfcc`). Port from there.
