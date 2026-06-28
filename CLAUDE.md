# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Matrix "digital rain" animation built on the [LÖVE2D](https://love2d.org/) (Love2D) game engine in Lua. No build step, no dependencies beyond the LÖVE runtime.

## Commands

- Run: `love .` (from the project root)
- Package a distributable: `zip -r matrix.love *` then open the resulting `matrix.love` with LÖVE. `matrix.love` is git-ignored.

There is no test suite, linter, or package manager. Iteration is: edit a `.lua` file, re-run `love .`.

## Architecture

The program is driven entirely by LÖVE's three lifecycle callbacks, all in [main.lua](main.lua):

- `love.load()` — builds `screens`, a 2D grid of animation objects sized to the viewport (`screen_width / char_width` columns × `screen_height / char_height` rows; chars are 10×12 px). Each **column** gets one shared random vertical offset (`rand`, forced to differ from the previous column) so the rain streams are staggered. Each cell is then `init()`-ed with a per-cell time value derived from its row + the column offset, which pre-rolls that digit's animation to the right phase.
- `love.update(dt)` — calls `.get(running_time, dt)` on every cell each frame to advance its state.
- `love.draw()` — iterates the grid, sets each cell's color and prints its digit at `(i*char_width, j*char_height)`. When `DEBUG` is on it overlays FPS / runtime / frame count in the bottom-right.

[anim.lua](anim.lua) is the per-digit "class". It is a **closure-based factory**, not a Lua metatable class: `anim()` returns a fresh table whose methods (`get`, `get_color`, `get_digit`, `init`) close over a private `self`. State lives in `self.x = { char, r, g, b, alpha }`. The animation lifecycle per cell:
1. When `alpha <= 0`, the cell respawns: picks a new random char and paints it the **secondary** (white) color at full alpha — this is the bright leading edge of a stream.
2. Next frame it flips from secondary to **primary** (green) and begins fading (`alpha -= dt`).
3. Subsequent frames keep subtracting `dt` from alpha until it reaches 0, then the cycle repeats.

`init(d)` fast-forwards a newly created cell by replaying `get()` `d/delay` times, so the grid doesn't start uniformly — this is what creates the established-rain look on the first frame.

## Conventions and gotchas

- **Loops are 0-indexed.** Despite Lua's 1-based norm, the grid loops run `for i = 0, ...`, so `screens[0]` exists and is used. Keep this consistent when touching grid code.
- **[env.lua](env.lua) is the single tuning knob.** It returns one config table: `delay` (frame/animation step, ~0.037s), `primary_color` (green) / `secondary_color` (white), `DEBUG`, and the `chars` set (currently hex digits `0-9 a-f`). Change behavior here, not by scattering constants. Note `char_width`/`char_height` are still hardcoded in `main.lua`, not in env.
- **Colors use a 0–255 scale with 0–1 alpha.** LÖVE 11.0 expects 0–1, so the `255` values are out-of-range and clamp; preserve the existing convention rather than "fixing" it piecemeal unless converting the whole project.
- **[conf.lua](conf.lua) disables most LÖVE modules** (audio, image, keyboard, mouse, physics, etc.) for performance, and forces `fullscreen = true` (the 800×600 window size is the fallback). A feature that needs a disabled subsystem — e.g. the README's "keystroke to exit" TODO needs `t.modules.keyboard = true` — must enable its module here first.
- **[print.lua](print.lua) is a standalone debug helper** (`print_r`-style table dumper). Nothing requires it currently; it's a tool for inspecting tables during development.

Open work items are tracked in the README's TODO list (FPS-based delay, 60 FPS cap, longer-lived white leading digit, Unicode chars, exit keybind).
