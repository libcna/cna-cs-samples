# CNA defects found by this repository

`rules.md` forbids repairing `../cnanext` or `../sharp-runtimenext` from here: a sample that hits a
defect below the C ABI records it and moves on. This file is where those records live, in full.
[`plan.md`](plan.md) carries a one-line index of the same rows.

A defect belongs here only when it is **below** `../cna-cs`. A defect in the binding is fixed in
`../cna-cs` in the same session and written up in the sample's `missing.md` instead — see
`CSSAMPLE-001`'s `Clear(Color)` entry for that shape.

Each row is written so that someone working in `../cnanext` can act on it without re-deriving it:
what was observed, how to reproduce it, what is established, and — separately — what is *not*.

---

## CNA-REPORT-001 — the XNA game window is resizable, and a resized window leaves the image at the bottom-left

| | |
|---|---|
| Found by | `CSSAMPLE-001` PrimitivesSample, 2026-09-02 |
| Reported by | the owner, running the sample on the desktop |
| Owner | `../cnanext` |
| Affects | every CNA game, C++ and managed alike |
| Blocks a sample? | No. `CSSAMPLE-001` stays `✅`. |
| Reproduction | `scripts/repro-cna-report-001.sh` |

### Observed

Maximizing the sample's window does not scale its content. The 853x480 picture stays at its
original size in the **bottom-left** corner of the enlarged client area.

### Reproduced

Forcing the window to 1200x900 with `xdotool windowsize` on a private X display:

| | before | after |
|---|---|---|
| window | 853x480 | 1200x900 |
| content bounding box | x 3..852, y 0..478 | x 3..852, y **420..898** |
| non-black pixels | 1173 | 1172 |

y 420..898 is the bottom 480 rows of a 900-row client area. Bottom-left is the OpenGL framebuffer
origin, which is where an unadjusted `glViewport` or blit puts a smaller image inside a larger
default framebuffer.

### The original cannot reach this state

XNA's `GameWindow.AllowUserResizing` defaults to `false`, and PrimitivesSample never sets it, so the
real sample's window has no working maximize box. The owner confirmed this independently before the
question was asked.

Authority (`/rv/data/library/github.com/FNA-XNA/FNA`):

- `src/FNAPlatform/FNAWindow.cs:32` — `[DefaultValue(false)] public override bool AllowUserResizing`
- `src/FNAPlatform/SDL2_FNAPlatform.cs:416` — `CreateWindow` builds its flags from
  `SDL_WINDOW_HIDDEN | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS` plus whatever
  `FNA3D_PrepareWindowAttributes()` adds. `SDL_WINDOW_RESIZABLE` is not among them; it is set later,
  only when a game assigns `AllowUserResizing = true`.

So the misplacement is a *consequence* of a window that should not have been resizable.

### Where it comes from

`modules/graphics/src/Xna/GraphicsDevice.cpp:2893` builds the game window's `WindowDescription` and
sets `title`, `width`, `height`, `highDpi`, `renderIntent` and the OpenGL framebuffer bits. It never
sets `resizable`, so the field keeps its declared default:

```cpp
// modules/platform/include/CNA/Platform/WindowDescription.hpp:86
bool resizable = true;
```

That default is reasonable for a general platform layer and wrong for the XNA-shaped `Game` built on
top of it, which must start non-resizable and become resizable only when the game asks.

### Not the managed binding

Stated because the sample that found this is a C# one, and the obvious suspicion is the wrong one:

- `CNA.Framework.Graphics.GraphicsDevice.Present()` is a bare call to `cna_graphics_device_present`.
  No managed code participates in placing pixels.
- `CNA.Framework.GameWindow.ClientSizeChanged` is an event forwarder. The binding never resets the
  backbuffer on resize — and that is XNA-correct, because XNA's `GraphicsDeviceManager` resizes the
  backbuffer only when `AllowUserResizing` is true, which here it is not.

### A second symptom, probably the same root

After the forced resize the *game-visible* viewport is wrong too, not just the presentation.
PrimitivesSample draws its sun at `Viewport.Width / 2` and its right ship at `Viewport.Width - 100`.
Measured back from where they landed, the game saw a width of about **640** in a 1200-wide window —
neither the 853 it asked for nor the 1200 it got.

### What is NOT established

The C++ port of the same sample appeared to stretch to fill the same forced resize while the managed
build did not. **That is not offered as evidence and must not be quoted as such.** The port's binary
is from 2026-08-25 and is statically linked against the CNA tree of that date; the managed run used
the Release C ABI library built on 2026-09-01. A week of CNA changes separates them.

Settling whether the presentation genuinely differs between the two needs
`../cna-samples/samples/PrimitivesSample` rebuilt against the current `../cnanext` and put through
`scripts/repro-cna-report-001.sh`, which takes any executable and window name for exactly that
reason.

### Measured on

| | |
|---|---|
| `../cnanext` | `next` `1caa45c84`, C ABI 0.21.0, `cmake-build-release-capi`, `CNA_GRAPHICS_RENDERER=OPENGLES3` |
| `../cna-cs` | `develop` `67ac872` |
| Renderer | EasyGL, OpenGL ES 3.2, Mesa 25.0.7, `LIBGL_ALWAYS_SOFTWARE=1` under Xvfb |
| Also seen on | the owner's real desktop session, windowed and maximized |
