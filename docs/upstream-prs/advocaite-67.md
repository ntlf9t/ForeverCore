# advocaite/TrinityCore#67: Better prefix and command typing in the CLI

PixelCattt, 2026-10-17, commit 01736d2584. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Log lines no longer land in the middle of a half-typed console command, and the `TC> ` prompt moves below each
log line.

**Change.** A new `CliManager` in common: every console log line (`AppenderConsole::_write`) and the vmap read errors in
`ModelInstance.cpp` print inside an `OutputGuard`, which takes a global recursive mutex, asks the prompt owner to erase
the prompt, prints, flushes stdout and stderr, and redraws the prompt. `CliRunnable.cpp` is rewritten (+957 lines): on
Linux GNU readline's callback interface in a `select` loop, on Windows a home-made line editor with VT100 sequences.

**Check.**
- Cosmetic only: no bug on our side, the console works today.
- Everlake runs the worldserver in docker with `tty: true` and `stdin_open: true`, and `scripts/console.py` drives the
  console through `docker attach`. With this change every console log line also writes readline's erase and redraw
  sequences, so `docker compose logs` and what `console.py` reads get a `TC> ` redraw after every line.
- Every console log line now takes a process-wide mutex and flushes stdout and stderr twice. The bot module logs a lot to
  the console; this is a cost on the world thread for no gain on a headless server.
- End of input changes: readline's callback reads stdin with `read()`, so `feof(stdin)` is never set and EOF on a pipe no
  longer stops the server (it did before). Not a problem for us (we keep a pty), but a behaviour change.
- The Windows editor is untested (the author says so).
- No test possible without a terminal.

**Test.** None.

**Verdict:** hold. Large, cosmetic, adds work to every console log line and noise to the docker log. Worth another look
only if someone types at the attached console often enough for mixed lines to matter.
