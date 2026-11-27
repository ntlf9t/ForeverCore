# Trixx34/Trinity-Forever-Modules 11edf2c7f9: Collision: a dynamic tree build that throws no longer aborts the world server

Trixx34, 2026-10-20, commit 11edf2c7f9 on `Trixx34/Trinity-Forever-Modules` `main` (GPL-2.0, same as this fork).
Reviewed 2026-11-16 against `everlake` 0d9a4b9145.

**Claim.** `BIH::build` throws `std::logic_error("invalid node overlap")` for an object whose bounds it cannot place. The dynamic
collision tree (game object models, one per grid cell) is rebuilt in `BIHWrap::balance()` on the map update thread, where nothing
catches it, so the world server aborted ("five crashes in a day on the test server"). The commit catches the throw, drops objects
whose bounds are not finite or have low above high, builds again, and leaves the tree empty if that fails too. It also frees
`BIH::build`'s bounds buffer when the build throws.

**Check.**
- The throw is real and still reachable on `everlake`: `BoundingIntervalHierarchy.cpp` throws "invalid node overlap" and
  "negative node extents", and `BIHWrap::balance()` called `m_tree.build` with no try. A fuzzer over random boxes with a few
  NaN/infinite/inverted coordinates found a 5-box set that throws (now in the test).
- The same fuzzer found the more common failure the commit does not cover: with an infinite bound `BIH::build` **never returns**
  (the split point stays infinite). Most fuzzed sets with an infinite coordinate hang rather than throw; a 4-box set is in the test.
  A catch cannot help there; on the server that is a frozen map thread.
- A default `G3D::AABox` is NaN (empty), and G3D only debug-asserts on bad bounds, so such boxes reach the tree in release builds.
  Infinite x or y would already misbehave in `RegularGrid2D::insert` (cell index), so in practice the bad bound that reaches the
  BIH is mostly z or NaN.
- The cause of the bad bounds on their server is not known; the commit logs them, which we keep.

**Our change on top** (965f20f71a). `balance()` drops objects with unusable bounds **before** every build (logged with their
bounds), so the build sees neither NaN, infinite nor inverted boxes; the catch stays as a backstop that leaves the tree empty and
logs the first 8 objects. A dropped object is back in the tree once it is removed and inserted with usable bounds (tested).

**Test.** `tests/common/BoundingIntervalHierarchyWrapper.cpp` (`[BIHWrap]`, 3 cases), run locally with Catch2 3.5.2 against
three trees:

| Case | `everlake` | 11edf2c7f9 only | with our change |
|---|---|---|---|
| usable bounds build and are found | pass | pass | pass |
| the 5-box set that throws | **fail** (throws) | pass | pass |
| the 4-box set with infinite z | **does not finish** | **does not finish** | pass |

**Not taken.** Nothing else from the commit is left out.
