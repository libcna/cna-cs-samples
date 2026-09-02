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

---

## CNA-REPORT-002 — destroying an "owned" technique or pass-collection view invalidates the effect's real one

| | |
|---|---|
| Found by | `CSSAMPLE-028` ColorReplacement, 2026-09-02 |
| Owner | `../cnanext` |
| Affects | **37 of the 78 eligible rows** — every sample that loads a `Model` |
| Blocks a sample? | **Yes.** `CSSAMPLE-028` is `⛔`. |
| Reproduction | `scripts/repro-cna-report-002.sh` |

### Observed

Any game that calls `ModelMesh.Draw()` succeeds on its first frame and throws on its second:

```text
CNA.CnaException: cna_game_run failed with native result Callback: Passes failed with native
result InvalidHandle: The EffectTechnique handle is invalid for this call.
```

### The contract it breaks

`modules/c-api/include/CNA/C/effects.h` documents both handles as **owned views**:

```text
:1419  @brief Gets the current technique as an owned stable view.
:1087  @param out_collection Receives an owned pass-collection view handle.
```

and provides `cna_effect_technique_destroy` (`:1012`) and `cna_effect_pass_collection_destroy`
(`:936`) to release them. An owned view is the caller's to destroy, and destroying it must not
disturb the effect it was taken from.

It does. CNA.NET's `ModelMesh.Draw` destroys both every frame — deliberately, because they are
minted per call and a 60 fps draw would otherwise queue hundreds of native handles a second for
finalization — and the second frame finds the effect's technique gone.

### Isolated to each handle independently

The binding's `ModelMesh.Draw` was edited three ways and the reproduction re-run against each. The
edits were reverted; this is measurement, not a change:

| what `ModelMesh.Draw` disposed | result |
|---|---|
| technique, pass collection and each pass (as shipped) | frame 1 OK, frame 2 `The EffectTechnique handle is invalid` |
| **only** the technique | frame 1 OK, frame 2 `The EffectTechnique handle is invalid` |
| **only** the pass collection and passes | frame 1 OK, frame 2 `The EffectPassCollection handle is invalid` |
| nothing | **6 of 6 frames OK** |

So the two destroys are independently poisonous, and each reports the loss of the handle kind it
destroyed. Neither is a double-free by the binding: one destroy of one view is enough.

### Not the managed binding

`ModelMesh.Draw` follows the documented ownership exactly, and a caller has no third option: either
it destroys an owned view, as the header says it may, or it leaks one per effect per frame. The
managed side cannot resolve this on its own, which is why this is a report rather than a fix.

### Either the behaviour or the header is wrong

Both readings are consistent with the evidence and CNA owns the choice:

1. The views really are owned, and `*_destroy` is releasing the underlying object rather than the
   view. Then the destroy path is the defect.
2. The views are borrowed and stable for the effect's lifetime, in which case nothing needs
   destroying and the header's "owned" is the defect. Under this reading CNA.NET should stop
   disposing, and there is no leak to worry about because there is nothing per-call to leak.

### How far this reaches

**37 of the 78 eligible rows** load a `Model`: `003`, `005`, `012`, `028`, `030`, `031`, `032`, `033`, `034`, `035`, `036`, `037`, `038`, `039`, `040`, `041`, `042`, `043`, `045`, `046`, `047`, `048`, `049`, `050`, `051`, `052`, `053`, `054`, `055`, `056`, `057`, `058`, `061`, `074`, `076`, `081`, `099`. That is most of Tier 2 and Tier 3, so
this is the campaign's highest-value fix.

The first count of this was **32, and it was wrong**. It came from grepping for `ModelMesh` and
`mesh.Draw()`, which misses every sample that calls `Model.Draw(world, view, projection)` instead
— and `Model.Draw` iterates the meshes and calls `ModelMesh.Draw` on each, so those samples hit the
defect identically. `CSSAMPLE-030` CameraShake is what exposed the gap: it ships `tank.xnb` and was
not on the list. The corrected query looks for `Content.Load<Model>` as well, which is the property
that actually matters, and added `030`, `043`, `045`, `052` and `081`.

### Measured on

| | |
|---|---|
| `../cnanext` | `next` `1caa45c84`, C ABI 0.21.0, `cmake-build-debug`, OPENGLES3, `CNA_EASYGL_COMPILED_EFFECTS=ON` |
| `../cna-cs` | `develop` `5bcfa70` |
| Renderer | EasyGL, OpenGL ES 3.2, Mesa 25.0.7, `LIBGL_ALWAYS_SOFTWARE=1` under Xvfb |

---

## CNA-REPORT-003 — the OPENGLES3 build with compiled effects segfaults during shutdown

| | |
|---|---|
| Found by | `CSSAMPLE-018` PerPixelCollision, 2026-09-02 |
| Owner | `../cnanext` |
| Affects | any game on a `cmake-build-debug`-configured library; the campaign works around it by using a different tree |
| Blocks a sample? | Not directly — but it removes the only OPENGLES3 tree that can load compiled effects |
| Reproduction | `scripts/capture-sample.sh RectangleCollision --window '.'` with `CNA_NATIVE_LIBRARY` pointed at that tree |

### Observed

The game runs, renders and responds. On the original's own Escape exit the process dies with
`SIGSEGV` (exit code 139, core dumped) instead of exiting 0. Nothing is printed before the crash;
the last log line is the ordinary asset loading.

Reproduced with two different samples — `CSSAMPLE-018` PerPixelCollision and `CSSAMPLE-019`
RectangleCollision. **Neither uses a compiled effect**; both load two textures and draw sprites. So
it is not the effect path at run time, it is the teardown.

### Not staleness

The first hypothesis was a stale tree. `cmake --build cmake-build-debug --target cna_c_api` rebuilt
111 targets and relinked the library on 2026-09-02 20:28. **The freshly built library crashes
identically.**

### What distinguishes the crashing build

Four `../cnanext` trees, each driven to the same Escape exit with the same sample:

| tree | renderer | compiled effects | devices | draco | static C API | exit |
|---|---|---|---|---|---|---:|
| `cmake-build-release-capi` | OPENGLES3 | OFF | OFF | ON | ON | 0 |
| `cmake-build-opengles3` | OPENGLES3 | OFF | ON | ON | OFF | 0 |
| `cmake-build-opengl33` | OPENGL33 | ON | OFF | ON | ON | 0 |
| **`cmake-build-debug`** | **OPENGLES3** | **ON** | OFF | **OFF** | ON | **139** |

Reading the matrix rather than guessing from it:

- **Compiled effects alone are not the cause** — `cmake-build-opengl33` has them ON and exits 0.
- **Devices, the static C API and the renderer alone are not the cause** — each value of each
  appears in a tree that exits 0.
- The **only option unique to the crashing tree is `CNA_ENABLE_DRACO=OFF`.** Every clean tree has
  it ON. That is a surprising suspect for a shutdown crash, which is exactly why it is worth
  stating.
- The other candidate the matrix cannot rule out is the **combination** of `OPENGLES3` with
  compiled effects, since the only other compiled-effects tree is a different renderer.

### What this repository did not do

Isolating the two candidates needs a tree that differs in exactly one option, which means
configuring a new CNA build. The openeggbert build rules close the list of build directories and
exist to prevent exactly that, and the campaign does not currently need a compiled-effects library
— the one sample that needs one, `CSSAMPLE-028`, is blocked on `CNA-REPORT-002` anyway. So the
narrowing stops here, honestly short of a single cause, and the rows that need no compiled effect
are measured on `cmake-build-release-capi`, which exits 0.

There is no backtrace: neither `gdb` nor `catchsegv` is installed on this host.

### Measured on

`../cnanext` `next` `1caa45c84` plus the working tree as it stood, C ABI 0.21.0, EasyGL on OpenGL
ES 3.2 (Mesa 25.0.7), `LIBGL_ALWAYS_SOFTWARE=1` under Xvfb.
