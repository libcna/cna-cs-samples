# CNA.NET Samples — engineering history

Newest first. Each entry says what actually happened, what was measured, and what the next session
inherits.

---

## 2026-10-01 — every row on the Android emulator (CSX-071)

`scripts/android-requalify.sh --desktop <requalify output>` runs each manifest row through
`scripts/android-sample.sh` (a generated `net11.0-android` app around the row's unchanged sources and
Content, `../cna-cs/eng/android`), taps Back, and measures the game's frame against the desktop
capture. All 34 rows pass: built, ran without a managed exception or a native crash, drew, and ended
on one Back tap. Table: `/rv/tmp/cs-samples/android-requal-20261001/android-requalification.md`.

The emulator is started read-only and wiped (`-wipe-data`: the AVD's own userdata leaves less free
space than Android's install threshold), every app is uninstalled after its row, and immersive mode
is pre-confirmed -- its one-time explanation otherwise takes the Back key from a full-screen phone
game. `CNA_ANDROID_GPU` picks the emulator's GPU mode (`swiftshader_indirect` by default).

## 2026-10-01 — gallery rows resumed (CSX-053..)

New rows, each from verbatim upstream sources with official XNBs from `../cna-samples`, built Debug
and Release and captured with `scripts/requalify.sh` against CNA.NET and CNA `build-probe`
(OPENGLES3, compiled effects). Details in each row's `missing.md`.

| Row | Sample | Result |
|---|---|---|
| CSSAMPLE-084 | AccelerometerSample | ✅ phone host + CNA.PhoneCompat; first frame 0 px from the original XNA emulator frame; Right arrow moves the asteroid |
| CSSAMPLE-050 | SimpleAnimation | ✅ verbatim; tank `Model` animates; 4.45% from the C++ port, animation phase |
| CSSAMPLE-076 | SplitScreen | ✅ verbatim, HiDef; two viewports of the tank; 4.84% from the C++ port, animation phase |
| CSSAMPLE-042 | ShatterEffect | ✅ verbatim; custom compiled effect; 13 px from the C++ port, 46 px after holding Up on both |
| CSSAMPLE-052 | CustomModelClass | ✅ verbatim; the game's own `CustomModel` through XNA's `ReflectiveReader`; 6.39% from the C++ port, rotation phase |
| CSSAMPLE-033 | NonPhotoRealistic | ✅ verbatim; cartoon and post-process effects; 8.73% (rotation), Pencil after A on both |
| CSSAMPLE-038 | ShadowMapping | ✅ verbatim, HiDef; shadow render target; 1 px from the C++ port; Left turns the camera |
| CSSAMPLE-012 | GeneratedGeometry | ✅ verbatim; generated terrain and sky; 43.93%, the circling camera |
| CSSAMPLE-030 | CameraShake | ✅ verbatim, HiDef; 0.27% from the C++ port |
| CSSAMPLE-041 | LensFlare | ✅ verbatim, HiDef; occlusion queries; 104 px from the C++ port |
| CSSAMPLE-053 | CustomModelEffect | ✅ verbatim; environment-mapping effect on the model; 11.45%, rotation |
| CSSAMPLE-034 | NormalMappingEffect | ✅ verbatim; compiled normal-mapping effect; 0.54% from the C++ port |
| CSSAMPLE-031 | BloomSample | ✅ verbatim; three-pass bloom; 22.70% (rotation), bloom off after B on both |
| CSSAMPLE-039 | BillboardSample | ✅ verbatim, HiDef; billboard effect; 4.72%, sway |
| CSSAMPLE-040 | InstancedModel | ✅ verbatim, HiDef; 1 000 hardware-instanced cats; 13.95%; ~60 vs ~350 fps, llvmpipe-bound, older C++ build |
| CSSAMPLE-099 | ModelImporterSample | ✅ verbatim; .obj-imported tank; 11.80%, rotation |
| CSSAMPLE-058 | ChaseCamera | ✅ verbatim; 0.22% from the C++ port |
| CSSAMPLE-049 | HeightmapCollision | ✅ verbatim, HiDef; terrain `Model` tagged with the game's own type (CSX-089); 0 px |
| CSSAMPLE-032 | DistortionSample | ✅ verbatim; components drawn at `base.Draw` (CSX-090), `Color.Transparent` transparent black (CSX-091); 0 px |
| CSSAMPLE-046 | Graphics3D | ✅ phone host; `Buttons/Button.cs` left out as upstream's project did; 35 px from the original XNA frame, 1 px from the C++ start frame |
| CSSAMPLE-060 | SoundAndMusic | ✅ phone host; song from its `.wma`; 0 px from the C++ start frame |
| CSSAMPLE-054 | SkinningSample | ✅ verbatim with its `SkinnedModel` library; `SkinnedEffectReader` (CSX-092); 8.15%, walk phase |
| CSSAMPLE-037 | RimLighting | ✅ phone host; 0.40% from the original XNA frame, 0.88% from the C++ start frame |
| CSSAMPLE-003 | TexturesAndColors | ✅ verbatim; 2.77%: the retained C++ binary predates CNA SOFTWARE-336 (apitrace: identical grid draw but for the stock shader) |
| CSSAMPLE-047 | PickingSample | ✅ verbatim, HiDef; `GeometricPrimitive.cs` left out as upstream's projects did; 15.51%, camera orbit |
| CSSAMPLE-036 | VertexLighting | ✅ verbatim; 1.08%, all in the grid's horizon band (as CSSAMPLE-003) |
| CSSAMPLE-035 | PerPixelLighting | ✅ verbatim; 1.08%, all in the grid's horizon band (as CSSAMPLE-003) |
| CSSAMPLE-057 | InverseKinematics | ✅ verbatim, HiDef; 2.36% is CNA's avatar, which XNA on Windows and the older C++ binary do not draw |
| CSSAMPLE-074 | TankOnHeightmap | ✅ verbatim, HiDef; 0 px |
| CSSAMPLE-002 | Primitives3D | ✅ again: the official `hudFont.xnb` (XNA 4.0 `BuildContent`, `../cna-samples` 2026-09-06) replaces the synthesized font; HUD 0 px from the C++ port. Swapping a content file leaves the old one in `bin/`, where an exact-case match wins |
| CSSAMPLE-048 | TrianglePicking | ✅ verbatim; model tags of XNA's types (CSX-093); 1 px |
| CSSAMPLE-073 | SoccerPitch | ✅ phone host, upstream's `GrassRender1` assembly; 52.25%, the circling camera and the fps counter |
| CSSAMPLE-043 | Particles3D | ✅ verbatim; clock-seeded particles, so frames differ by construction (62.05%) |
| CSSAMPLE-044 | Particles2DPipeline | ✅ verbatim with its `ParticleSettings` library; clock-seeded particles (54.86%) |
| CSSAMPLE-045 | XmlParticles | ✅ verbatim with its `ParticleSettings` library; clock-seeded particles (77.50%) |
| CSSAMPLE-051 | CustomModelAnimation | ✅ verbatim with its runtime library; 4 px with A and B held on both builds |
| CSSAMPLE-055 | SkinnedModelExtensions | ✅ verbatim with its `SkinnedModel` library; bat in hand; 9.17%, walk phase |
| CSSAMPLE-056 | CPUSkinning | ✅ verbatim with its data-types library; 9.16%, walk phase |
| CSSAMPLE-005 | ReachGraphicsDemo | ✅ verbatim with its `DataTypes` library; all six stock-effect screens opened on both builds (dual-texture 0.49%, alpha-test 0.11%, the rest motion) |
| CSSAMPLE-013 | Platformer | ✅ verbatim, HiDef; levels through `TitleContainer`; 0.97%, and 1.11% with Right held on both builds |
| CSSAMPLE-017 | CollisionSample | ✅ verbatim; 0.65% (requalify now picks the port's game, not its test runner) |
| CSSAMPLE-072 | GameStateManagement | ✅ verbatim; 0.95%; Escape opens the exit box, Enter exits 0 |
| CSSAMPLE-081 | PerformanceMeasuring | ✅ verbatim; random spheres and live timings (13.48%) |
| CSSAMPLE-082 | UISample | ✅ phone host; 0 px from the C++ main-menu frame; Escape is the phone's Back (CSX-095) |
| CSSAMPLE-077 | DynamicMenu | ✅ phone host with its menu library, no longer 🛑; 0 px from both the C++ and the original XNA page-1 frames |
| CSSAMPLE-061 | MarbleMaze | ✅ phone host, the kit's final stage; 0 px from the C++ menu frame |
| CSSAMPLE-063 | HoneycombRush | ✅ phone host, the kit's final stage; 0 px from the C++ menu frame |
| CSSAMPLE-067 | CatapultWars | ✅ phone host, the kit's final stage; 0 px from the C++ menu frame |
| CSSAMPLE-069 | CardsStarterKit | ✅ verbatim with its `CardsFramework`, HiDef; 0 px on the title and on the table after Play; leaves through its Exit entry |
| CSSAMPLE-014 | Spacewar | ✅ verbatim, project at the upstream root; `settings.xml` copied as upstream; 0 px; Left Shift is its Back |
| CSSAMPLE-091 | ClientServerSample | ✅ verbatim; opens on CNA's Guide sign-in as the sample asks; 0 px on the session menu after signing in |
| CSSAMPLE-066 | ShipGame | ✅ verbatim with `BoxCollider`; Windows-cased audio path (CSX-096); animated title; quits from its menu |
| CSSAMPLE-062 | NetRumble | ✅ verbatim; a `Content\audio\wav` link in the output answers its BCL directory scan; 1.04% |
| CSSAMPLE-070 | RolePlayingGame | ✅ verbatim with its data library, 1 004 assets; backslash audio path (CSX-096); 0 px |
| CSSAMPLE-065 | NinjAcademy | ✅ phone host with its common-types library; `PhoneApplicationService` (CSX-097); 0 px from the C++ menu frame |
| CSSAMPLE-071 | Yacht | 🛑 the client's generated WCF proxy is Silverlight's (configuration-name constructors, `ServiceReferences.ClientConfig`); two options in `samples/Yacht/missing.md` |

The phone rows are measured against the C++ campaign's own start frames: the retained C++ phone
binaries ask for full screen, which a bare Xvfb cannot grant, and capture black. The C# side no
longer asks (CNA.NET CSX-094: a phone title's full screen is its status bar), and Escape is its
Back button off a phone (CSX-095), so every phone row now exits 0 on Escape and `requalify.sh`
checks that for any phone row reading `Buttons.Back`.

Tooling on the way: `add-sample.sh` also copies what the content pipeline puts beside compiled
assets (a song's `.wma`, a video's `.wmv`, XACT's banks) and the raw files a content project copies
as they are (only those byte-identical to an upstream file); `capture-sample.sh` runs every sample
with a private home and no session bus, so a sample that starts GamerServices no longer reads or
writes the developer's own CNA profiles, credentials or Secret Service; `check-verbatim.sh` ignores an upstream snapshot's `bin/`/`obj/` build output;
`build-native-cna.sh` no longer picks a cross-compiled tree (`cmake-build-android-*` is the newest
Release OPENGLES3 tree with compiled effects, and the host cannot load it); `capture-sample.sh
--xdotool` drives input before the capture, and `requalify.sh --xdotool` gives the C# run and the C++
port the same input.

## 2026-10-01 — samples in a browser

`scripts/browser-sample.sh <Sample>` builds a sample for the browser and runs it in headless
Chromium. The sample's project is not touched: its evaluated identity and Compile items are read
from MSBuild and a .NET 11 WebAssembly project is generated under `build-consumer/browser/<Sample>/`,
linking the CNA archive `../cna-cs/scripts/Build-BrowserNative.sh` stages and the net8.0 CNA.NET
assemblies; Content is linked into its `wwwroot` and so into the browser's file system.
`CNA_ACTIONS` scripts input (see `../cna-cs/scripts/Run-BrowserPage.mjs`).

AimingSample was first: 0 pixels from its C++ port, input, exit and reload all driven.
`scripts/browser-requalify.sh --desktop <requalify output>` then ran every row (CNA.NET `274be55`..,
CNA `1e7c4d323`, .NET 11 RC1, headless Chromium with SwiftShader WebGL2, 6 s), measured against the
row's desktop C# capture:

| Sample | Browser run | vs desktop C# | Canvas | Page errors |
|---|---|---|---|---|
| AimingSample | pass | 0.00% (0 px) | 853x480 | 0 |
| Audio3D | pass | 5.01% (19238 px) | 800x480 | 0 |
| Bounce | pass | 6.93% (26622 px) | 800x480 | 0 |
| ChaseAndEvade | pass | 1.05% (4312 px) | 853x480 | 0 |
| ColorReplacement | pass | 9.85% (37839 px) | 800x480 | 0 |
| ContentManifestExtensions | pass | 0.00% (0 px) | 800x480 | 0 |
| FlockingSample | pass | 2.82% (10813 px) | 800x480 | 0 |
| FuzzyLogic | pass | 5.13% (19689 px) | 800x480 | 0 |
| GesturesSample | pass | 0.00% (0 px) | 800x480 | 0 |
| InputReporter | pass | 0.00% (0 px) | 853x480 | 0 |
| InputSequence | pass | 0.00% (0 px) | 800x480 | 0 |
| LocalizationSample | pass | 0.00% (0 px) | 800x480 | 0 |
| MicrophoneEcho | pass | 0.70% (2677 px) | 800x480 | 0 |
| Orientation | pass | 0.00% (0 px) | 800x480 | 0 |
| ParticleSample | pass | 84.60% (324866 px) | 800x480 | 0 |
| PathDrawing | pass | 0.00% (0 px) | 800x480 | 0 |
| Pathfinding | pass | 0.00% (0 px) | 800x480 | 0 |
| PerPixelCollision | pass | 1.00% (3838 px) | 800x480 | 0 |
| Primitives3D | pass | 14.87% (57116 px) | 800x480 | 0 |
| PrimitivesSample | pass | 0.39% (1594 px) | 853x480 | 0 |
| RectangleCollision | pass | 0.89% (3414 px) | 800x480 | 0 |
| SafeArea | pass | 0.00% (0 px) | 1280x720 | 0 |
| ShapeRendering | pass | 2.61% (10013 px) | 800x480 | 0 |
| SnowShovel | pass | 7.38% (28340 px) | 480x800 | 0 |
| SpriteEffects | pass | 4.44% (17065 px) | 800x480 | 0 |
| SpriteSheet | pass | 7.02% (28728 px) | 853x480 | 0 |
| TouchThumbsticks | pass | 0.21% (798 px) | 800x480 | 0 |
| TransformedCollision | pass | 7.52% (28864 px) | 800x480 | 0 |
| TransformedCollisionTest | pass | 0.00% (0 px) | 800x480 | 0 |
| WaypointSample | pass | 0.00% (0 px) | 853x480 | 0 |

Found on the way and fixed: publishing trims, and content readers are created by reflection, so the
CNA.NET assemblies and the game's are rooted (ContentManifestExtensions); library projects beside a
sample are referenced as their own builds (Pathfinding, SpriteSheet); and ShapeRendering, whose
drawing is `[Conditional("DEBUG")]`, had been captured in Release and drawn nothing since the
migration -- a row now names its configuration with `CnaSampleConfiguration`, which both capture
scripts honour.

---

## 2026-10-01 — every checked-in row requalified against the migrated binding (CSX-050)

`scripts/requalify.sh` builds each row in Debug and Release, captures it on a private Xvfb, takes
its exit path, captures the row's C++ port the same way and measures the difference. Run against
CNA.NET `496858b` and CNA `e9dd5d879`; the five rows the phone hosts changed were re-run after
them (`requal-20261001-phonehost`). All 30 rows build, run and capture; every one with an Escape
path exits 0.

| Sample | Build | Run + capture | Exit | vs C++ port | Window |
|---|---|---|---|---|---|
| AimingSample | pass | pass | Escape, code 0 | 0.00% (0 px) | AimingSample 853x480 |
| Audio3D | pass | pass | Escape, code 0 | 0.00% (0 px) | Audio 3D 800x480 |
| Bounce | pass | pass | Escape, code 0 | 44.59% (171207 px) | Bounce 800x480 |
| ChaseAndEvade | pass | pass | Escape, code 0 | 0.90% (3692 px) | ChaseAndEvade 853x480 |
| ColorReplacement | pass | pass | Escape, code 0 | 3.04% (11663 px) | Color Replacement 800x480 |
| ContentManifestExtensions | pass | pass | Escape, code 0 | 0.00% (0 px) | SampleGame 800x480 |
| FlockingSample | pass | pass | Escape, code 0 | 2.67% (10237 px) | Flocking 800x480 |
| FuzzyLogic | pass | pass | Escape, code 0 | 5.02% (19270 px) | FuzzyLogic 800x480 |
| GesturesSample | pass | pass | no key in source | 32.34% (124187 px) | TouchGestureSample 800x480 |
| InputReporter | pass | pass | Escape, code 0 | 0.00% (0 px) | Input Reporter 853x480 |
| InputSequence | pass | pass | Escape, code 0 | 0.00% (0 px) | Input Sequence 800x480 |
| LocalizationSample | pass | pass | Escape, code 0 | 0.00% (0 px) | Localization Sample 800x480 |
| MicrophoneEcho | pass | pass | Escape, code 0 | 0.00% (0 px) | MicrophoneEchoSample 800x480 |
| Orientation | pass | pass | no key in source | 50.92% (195519 px) | OrientationSample 800x480 |
| ParticleSample | pass | pass | Escape, code 0 | 81.59% (313314 px) | ParticleSample 800x480 |
| PathDrawing | pass | pass | no key in source | 98.01% (376373 px) | PathDrawing 800x480 |
| Pathfinding | pass | pass | no key in source | 0.00% (0 px) | Pathfinding 800x480 |
| PerPixelCollision | pass | pass | Escape, code 0 | 0.89% (3420 px) | Per Pixel Collision 800x480 |
| Primitives3D | pass | pass | Escape, code 0 | 14.80% (56845 px) | Primitives3D 800x480 |
| PrimitivesSample | pass | pass | Escape, code 0 | 0.39% (1605 px) | Primitives 853x480 |
| RectangleCollision | pass | pass | Escape, code 0 | 0.63% (2422 px) | Rectangle Collision 800x480 |
| SafeArea | pass | pass | Escape, code 0 | 0.00% (0 px) | Safe Area Sample 1280x720 |
| ShapeRendering | pass | pass | Escape, code 0 | 1.55% (5936 px) | ShapeRenderingSample 800x480 |
| SnowShovel | pass | pass | Escape, code 0 | 5.84% (22418 px) | SnowShovel 480x800 |
| SpriteEffects | pass | pass | Escape, code 0 | 7.35% (28232 px) | Sprite Effects 800x480 |
| SpriteSheet | pass | pass | Escape, code 0 | 6.76% (27685 px) | SpriteSheetSample 853x480 |
| TouchThumbsticks | pass | pass | no key in source | 0.32% (1223 px) | TouchThumbSticks 800x480 |
| TransformedCollision | pass | pass | Escape, code 0 | 5.37% (20624 px) | Transformed Collision 800x480 |
| TransformedCollisionTest | pass | pass | Escape, code 0 | 0.00% (0 px) | Transformed Collision Test 800x480 |
| WaypointSample | pass | pass | Escape, code 0 | 0.00% (0 px) | Waypoints 853x480 |

Reading the pixel column: 0% rows are exact. Animated rows differ by phase (SpriteEffects,
ColorReplacement, Primitives3D, SpriteSheet, SnowShovel, TransformedCollision, FuzzyLogic,
Flocking) and seeded ones by randomness (ParticleSample, Bounce, RectangleCollision). The large
GesturesSample, Orientation, Bounce and PathDrawing numbers are the C++ captures: every retained
C++ phone port draws offset by the 100-pixel window position the capture script moves windows to,
and the C# runs on current CNA do not. With the offset removed GesturesSample, Orientation and
PathDrawing differ by 0 pixels.

What the pass found and fixed:

- **ColorReplacement's tyres** — `../cna-cs` CSX-083 (`b48db04`): the device's managed state
  cache did not see native `SpriteBatch.End` apply `AlphaBlend`, so the sample's
  `BlendState = Opaque` was skipped and alpha-0 texels blended away.
- **Pathfinding hung at teardown** — `../cna-cs` CSX-084 (`496858b`): SIGTERM let the runtime call
  `exit()` beside a game thread inside GL/X. `capture-sample.sh` now also waits for the sample
  before stopping Xvfb.
- **Bounce and PathDrawing run** through the generated phone host (`rules.md` rung 4).
  `Directory.Build.props` used to set `DefineConstants` before a project body could override
  `CnaSampleDefineConstants`, so Bounce's override never took effect; the targets file does it now.
- **InputSequence runs** now that CNA.NET has the Net namespace; `DEC-002` no longer blocks it.
- Each project declares its original `<XnaProfile>` (10 are HiDef) and `<XnaPlatform>` where it is
  the phone; CNA.XnaCompat's targets embed XNA's `RuntimeProfile` resource from them (CSX-081).

Next: the gallery rows. `CSSAMPLE-077` DynamicMenu takes the phone-host route; `CSSAMPLE-002`
stays `🛠` for its font provenance. No row drives input yet — every `missing.md` lists that as not
verified, and an interaction harness in `capture-sample.sh` would let rows exercise their controls.

## Active handoff — 2026-09-02 (third entry)

### Work on next

Tier 2 continues at `CSSAMPLE-028` ColorReplacement. Done so far: `CSSAMPLE-001`, `008`, `002`,
`019` are `✅`; `CSSAMPLE-016` is `🛑` awaiting `DEC-001`.

### CSSAMPLE-019 RectangleCollision — ✅, and it found the biggest defect yet

The sample crashed on its first run with `cna_game_run failed with native result Callback: Object
reference not set to an instance of an object` — and the cause was worth the trouble of finding.

`Microsoft.Xna.Framework.Game.Initialize` was **empty**. Content arrived only through the separate
native `load_content` callback, which the C ABI delivers *after* `initialize`. XNA's `Initialize`
ends by calling `LoadContent`, so a game may use its textures immediately after `base.Initialize()`
— and that is how the XNA sample collection is written throughout. Every such game read a null.

Fixed in `../cna-cs` `5bcfa70`: the facade's `Initialize` calls `LoadContent` through a once-guard,
and the native callback goes through the same guard. A game that skips `base.Initialize()` still
loads exactly once, as before. Two tests pin the order and the count; confirmed red with the fix
reverted.

**Expect this class of defect to dominate the campaign.** Both binding defects so far — this and
`Clear(Color)` — are lifecycle or contract details that no metadata gate can see: the signatures
were right and the behaviour was not. The 257/257 type match says nothing about them.

### The diagnostic that was missing

The failure surfaced as an exception message and nothing else — no stack, no indication of which
callback or which line. `ReportCallbackFailure` writes only `ex.Message` into the native error
buffer. Locating this meant reading the sample's `Initialize` and reasoning about XNA's contract; a
stack trace would have made it immediate. Worth raising in `../cna-cs` as its own item.

### A namespace trap in the test project

`tests/CNA.Integration.Tests` sits in `namespace CNA.Integration.Tests`, so a bare `Game` binds to
`CNA.Game` through the enclosing namespace **before** any `using Microsoft.Xna.Framework;` is
considered. A facade test must write `Microsoft.Xna.Framework.Game` in full. The existing tests
already do this for `global::CNA.Integration.Tests.OwnGameCollection`; the same applies to every
facade type.

### CSSAMPLE-016 Bounce — 🛑, and it raised DEC-001

The first phone-only row. Upstream ships only `Bounce (Phone).sln`, an `OutputType=Library`
packaged as a XAP, and it does not compile: `Accelerometer.cs:109` calls
`Microsoft.Devices.Environment.DeviceType` **outside** every `#if WINDOWS_PHONE` guard, so the
Windows Phone 7 SDK type is required whatever the constant is set to. That is not XNA 4.0, so
`rules.md`'s "fix it in `../cna-cs`" ladder does not authorise filling it.

The build was attempted rather than reasoned about: exactly two errors, both that one line.

Measured before raising it, so the owner has a number rather than an anecdote: of 78 eligible rows,
9 mention `Microsoft.Devices` but only **6** reach it with `WINDOWS_PHONE` undefined. A small script
that walks `#if`/`#else`/`#endif` nesting is what separated the two, and it is worth rewriting for
the next question of this shape — "does this sample mention X" is nearly always the wrong question.

A second ruling is queued with it: phone-only samples have no entry point at all, because the XAP
host supplied it and the shipped `Program.Main` is `#if WINDOWS || XBOX` guarded and constructs a
`Game1` class that does not exist.

### CSSAMPLE-002 Primitives3D — ✅, and it corrected a rule

Unmodified C#, `diff -r` clean, both configurations 0/0, 800x480, exit 0 on Escape.

**The content rule was wrong and has been amended.** It said to copy content from
`../cna-samples/samples/<Port>/Content/`. This port ships no `.xnb`: its font is `hudfont.cnj` plus
a PNG atlas, regenerated by the campaign's own tool because CNA's canonical `.cnj` and XNA's
`AlphaBlend` disagreed about premultiplication. Copying that would have been wrong twice — the
original calls `Content.Load<SpriteFont>("hudfont")`, which is an `.xnb` contract, and a CNA-native
substitute is the runtime substitution the zero-workaround rule forbids.

The right source is the official pipeline output the campaign retained in its artifact root,
`xna4-original/**/bin/**/Content/hudfont.xnb`. **It loads and renders through CNA.NET without
trouble**, and its text is pixel-identical to the port's converted font: 0 differing pixels of
42 300 across the HUD region. Whether the premultiplication problem does not affect the `.xnb`
reader path or has since been fixed in CNA, this row does not establish and does not need to.

`rules.md` now says to check what a port actually ships before copying it.

### A project-file trap worth remembering

`Main` lives in a separate `static class Program` at the bottom of `Primitives3DGame.cs`. Pointing
`StartupObject` at the game class fails with `CS1558`. Read where `Main` actually is; three samples
in, it has been in the game class, in a `Program.cs`, and in a `Program` class inside the game's
file.

### Frame-offset control, now routine

`CSSAMPLE-002`'s whole-frame diff against the C++ port is 55 564 pixels, and its bounding box is
exactly the rotating cube — nothing outside it differs. Confining the residue by bounding box is a
cheaper version of `CSSAMPLE-008`'s repeat-run control and says the same thing.

### CSSAMPLE-008 ShapeRendering — ✅

Unmodified original C#, `diff -r` clean, 0 warnings and 0 errors in both configurations, 800x480 on
`OPENGLES3`, exit 0 on Escape. **No change was needed in `../cna-cs` or anywhere else.**

This row is the clearest demonstration so far of what this repository measures that the C++
campaign cannot. Every public method of `DebugShapeRenderer` carries `[Conditional("DEBUG")]`, so
Release elides the call sites and the sample draws only its clear — measured, 1 distinct colour in
Release against 6 in Debug. C++ has no call-site-eliding attribute, so
`../cna-samples/samples/ShapeRendering` had to define its own `SHAPE_RENDERING_SAMPLE_DEBUG` and
hand-guard the original call sites, and could not even name it `DEBUG` because that collides with
CNA's `LogLevel::DEBUG`. Here the original source says it and the project file says nothing.

### A near-miss worth copying

The first comparison said **0 differing pixels of 384 000** between the C# run and the C++ port. It
was true, and it was nearly a false claim: the sample's camera orbits from
`gameTime.TotalGameTime.TotalSeconds`, so a capture is only comparable if both runs are caught on
the same frame, and nothing in the harness guarantees that.

The control that turned it into evidence: a **second** C# run at the same settle differs from the
first by 5 076 pixels — and from the C++ port by exactly 5 076 as well. Two runs of the same build
differing by the same amount as a cross-engine pair is what a frame offset looks like, not what an
engine difference looks like. So the sound claim is "identical when both land on the same game-time
frame", not "pixel-identical".

**Repeat any pixel comparison against the same build before attributing the residue to the other
engine.** A third capture at a longer settle (10 935 differing pixels) established that the scene
animates at all, which is the first thing to check.

### Recorded for a later row

`XnaProfile=HiDef` in the original project has no .NET 8 equivalent, and ShapeRendering never sets
`GraphicsDeviceManager.GraphicsProfile` in code, so this build does not request HiDef. It does not
need it — `LineList` through `BasicEffect` is Reach — but the first row that genuinely needs HiDef
will have to establish how the profile gets selected. Do not rediscover this.

### Engine throughput, measured because the owner asked

Same source, three engines, timestep and vsync off, Release, 300 frames after 30 warm-up, all on
the identical llvmpipe software rasterizer under Xvfb, so the delta is CPU-side rather than GPU:

| workload | CNA.NET | MonoGame | Kni |
|---|---:|---:|---:|
| empty loop (clear only) | 2 358 fps | 2 646 | 2 960 |
| 2 000 triangles, `DrawUserPrimitives` | 549 | 999 | 1 002 |
| 2 000 sprites, `SpriteBatch` | 255 | 478 | 480 |

CNA.NET is about **half the speed of MonoGame and Kni on the draw paths** and modestly behind on an
empty loop. The obvious suspect is the layer the others do not have — managed to P/Invoke to C ABI
to C++, crossed per draw call — but that is a hypothesis, not a profile. On real hardware GL CNA
reached 1 482 fps on the triangle workload against 549 on llvmpipe, so it is not rasterizer-bound;
MonoGame and Kni hang on this desktop session, so there is no hardware comparison. XNA 4.0 itself
cannot be measured on Linux at all, and FNA's native runtime is unavailable here.

The benchmark lives in `../cna-cs/build-probe/engine-bench/`, which is **gitignored and
disposable**. If this is worth keeping it needs a home in `../cna-cs`.

## Handoff — 2026-09-02 (second entry)

### Work on next

**Nothing, until the owner says so.** `CSSAMPLE-001` PrimitivesSample is complete and is the one
sample the owner authorised. `CSSAMPLE-008` ShapeRendering is next in Tier 1 when permission comes.

### Heads this session measured against

Recorded as history, not as a claim about today: `../cnanext` and `../cna-samples` are worked on by
other sessions and move independently. Re-read them at the start of a session rather than trusting
this table, and in particular re-check the C ABI generation against `../cna-cs`'s admission matrix
before treating a native load failure as a bug.

| Repository | Branch | Head when measured | Changed by this session? |
|---|---|---|---|
| `cna-cs-samples` | `develop` | this commit | yes |
| `../cna-cs` | `develop` | `67ac872` | yes — the `CSSAMPLE-001` `Clear(Color)` fix |
| `../cnanext` | `next` | `1caa45c84`, C ABI 0.21.0 | no, as the rules require |
| `../sharp-runtimenext` | `next` | `9cc96cd5` | no |
| `../cna-samples` | `develop` | `425d772` | no |

`../cnanext` had already advanced to `0eb5fc151` by the time this session pushed, through work that
is not ours. Nothing here was rebuilt against it.

### CSSAMPLE-001 PrimitivesSample — ✅

The original C# runs **unmodified**: `diff -r` against
`/rv/tmp/XNAGameStudio/Samples/PrimitivesSample_4_0/Primitives` reports no difference, both
configurations build with 0 warnings and 0 errors, and the sample renders its stars, ships and sun
at 853x480 on `OPENGLES3` and exits 0 on Escape.

Compared with the C++ port through the identical capture route, the two agree exactly on everything
deterministic — 273 pure-white pixels, 91 `Color.Gray` pixels, grey range 56..255, and the same
three white x-clusters at 90–110 (left ship), 397–456 (sun) and 743–763 (right ship). Only the total
differs (1,174 vs 1,191), because `CreateStars` seeds `new Random()` from the clock and the star
field is different every launch by design.

### The defect it found, and how it was found

The first run drew **nothing**. That is worth recording in full, because the method generalises:

1. The window was 853x480 and Escape exited cleanly, so the sample was alive and its own code was
   running.
2. The C++ port of the same sample, captured the same way on the same CNA build, drew 1,191 pixels.
   That put the defect above CNA and below the sample.
3. `../cna-cs-template` — a managed CNA.NET app — captured 963 distinct colours, so managed
   presentation and the X capture route were both fine.
4. A probe drove the sample's **own unmodified `PrimitiveBatch.cs`** and read the result back
   instead of screenshotting it. Into a `RenderTarget2D`: 20,219 pixels. Into the backbuffer: 0.
5. Four variants of the clear separated colour from depth, and named it exactly:
   `GraphicsDevice.Clear(Color)` selected `ClearOptions.Target` alone.

XNA and FNA both define the one-argument overload as `Target | DepthBuffer | Stencil` with
`Viewport.MaxDepth`; CNA's C++ layer already agreed (Task 928). The divergence was managed-side
only, which is exactly why the C++ port was unaffected. Fixed in `../cna-cs`, pinned by
`tests/CNA.Integration.Tests/ClearColorDepthTests.cs` — confirmed red with the fix reverted
(0 of 64 lit), green with it (64 of 64), and its target-only case stays dark so a pass is not
vacuous. `../cna-cs` suites after the fix: 622 framework, 225 XnaCompat, 208 native integration,
all passing.

### Techniques worth reusing

- **Read pixels back, do not screenshot, when locating a defect.** A `RenderTarget2D` plus
  `GetData`, or `GetBackBufferData`, answers "did it draw" without the window, the compositor or
  the capture route in the way. The probe area is `../cna-cs/build-probe/` — shared, gitignored,
  never per-ticket.
- **The C++ port is the discriminator.** Any sample here has a working port beside it; running both
  through the same capture route is what turns "it looks wrong" into "the defect is in the
  binding".
- **`SDL_VIDEODRIVER=x11` with `WAYLAND_DISPLAY` unset, and `Xvfb +extension GLX`.** Without the
  first, SDL opens the window on the developer's real Wayland session and the private display stays
  empty — the run looks fine and the capture is black. Without the second, GL never reaches the
  drawable. `scripts/capture-sample.sh` encodes both.
- **Crop the root window to the sample window's geometry.** `import -window <id>` on a GL window
  reads back black.

### Reported to CNA, not repaired

`CNA-REPORT-001`, recorded in full in the new [`cna-bugs.md`](cna-bugs.md) and indexed from
`plan.md`: the owner maximized the sample's window
and the 853x480 image stayed at the bottom-left. Established by measurement, not inspection — the
window forced to 1200x900 puts the content at x 3..852, y 420..898, which is the OpenGL
framebuffer origin.

The original cannot reach that state: XNA's `AllowUserResizing` defaults to false and the sample
never sets it, so the real window has no working maximize box. CNA's XNA `GraphicsDevice` builds
its `WindowDescription` without setting `resizable` and takes the platform default of `true`, so
every CNA game gets a resizable window. The binding places no pixels — `Present()` is a bare ABI
call, `ClientSizeChanged` only forwards an event — so this is not `../cna-cs`'s to fix and, per
`rules.md`, not this repository's either.

Worth knowing for whoever picks it up: the game-visible `Viewport.Width` after that resize was
about 640 in a 1200-wide window, and the C++ port's apparent difference in the same test is **not**
usable as evidence — its binary is from 2026-08-25 and statically linked against the CNA tree of
that date, a week behind the library used here. `scripts/repro-cna-report-001.sh` takes an
arbitrary executable and window name precisely so a rebuilt port can settle that.

`cna-bugs.md` is new and is where every below-the-ABI finding goes from now on: `rules.md` says
report and move on, and a finding scattered across three documents is a finding that gets lost.
Each record must separate what is established from what is not.

### Open items

- `CSINFRA-003`, `004` and `005` — the content-provenance, verbatim-source and eligibility checkers
  — remain unwritten. `CSSAMPLE-001` verified both properties by hand; a sample with content will
  need the first one for real.
- `../cna-cs/tests/CNA.Integration.Tests/RenderTargetClearTests.cs` documents itself as expected-RED
  against an upstream CNA defect. It passes now. Someone should close that blocker row with
  evidence rather than leave the comment claiming otherwise; it is `../cna-cs`'s to close, not this
  repository's.

---

## Handoff — 2026-09-02 (first entry: repository established)

### Work on next at the time

`CSSAMPLE-001` PrimitivesSample, the first row of Tier 1. **The owner has authorised exactly one
sample.**

### Synchronized heads

| Repository | Branch | Head |
|---|---|---|
| `cna-cs-samples` | `develop` | this commit |
| `../cna-cs` | `develop` | `859ecd5` |
| `../cnanext` | `next` | `1caa45c84` (read-only from here) |
| `../sharp-runtimenext` | `next` | `9cc96cd5` (read-only from here) |
| `../cna-samples` | `develop` | `425d772` (eligibility authority) |

### What this session established

The repository, its policy and its build infrastructure, plus a measured toolchain baseline taken
**before** any sample was attempted — so that the first failure has something to be compared
against.

- `../cna-samples/plan.md` has 80 `✅` rows out of 153. Two of them (`SAMPLE-004` StockEffects,
  `SAMPLE-015` TicTacToe) are owner-accepted non-port decisions with no C++ port behind them, so
  **78 rows and 85 runnable products** are eligible here. The derivation is in `plan.md`.
- The dependency chain lines up: `../cnanext`'s `abi.h` declares C ABI **0.21.0**, and CNA.NET's
  admission matrix on `develop` accepts exactly 0.21.0. That agreement is not permanent — CNA.NET
  retires a generation whenever it moves — so re-check it at the top of any session where a native
  load fails.
- `../cnanext/cmake-build-release-capi` already held a current Release `OPENGLES3` build of
  `libcna_c_api.so`. It was reused rather than rebuilt, per the openeggbert build rules.
- End-to-end proof that the stack runs before any sample depends on it: `../cna-cs-template`
  built Release against that library and completed its 60-frame smoke test under `xvfb-run` with
  exit 0, on EasyGL / OpenGL ES 3.2 (Mesa 25.0.7).

### Decisions worth knowing

- **The C# is the deliverable, so the project file absorbs the change.** `samples/Directory.Build.props`
  carries `net8.0`, `WinExe`, `ImplicitUsings=disable`, `Nullable=disable`,
  `GenerateAssemblyInfo=false` and `DefineConstants=WINDOWS`. Each of those replaces something the
  original Visual Studio 2010 project said, or switches off a modern default the 2010 code
  predates. A sample `.csproj` should then carry only its identity — name, namespace, entry point.
- **`GenerateAssemblyInfo=false` is not cosmetic.** Every sample ships
  `Properties/AssemblyInfo.cs`; the SDK's generated attributes would collide with it, and deleting
  the upstream file to avoid that would be a source deviation.
- **`AssemblyName` keeps the *original* project's name**, which is often not the sample directory's
  name (`PrimitivesSample/` builds `Primitives`). The `.csproj` file is named after the directory
  so the solution stays unambiguous; `scripts/run-sample.sh` therefore finds the executable by
  searching `bin/<cfg>/` rather than by guessing its name.
- **Deterministic runs are a launcher concern.** `cna-samples` could add a frame counter to a port;
  adding one here would be a fidelity deviation, because the original sample had none.

### Reported to CNA, not repaired

`CNA-REPORT-001`, recorded in full in the new [`cna-bugs.md`](cna-bugs.md) and indexed from
`plan.md`: the owner maximized the sample's window
and the 853x480 image stayed at the bottom-left. Established by measurement, not inspection — the
window forced to 1200x900 puts the content at x 3..852, y 420..898, which is the OpenGL
framebuffer origin.

The original cannot reach that state: XNA's `AllowUserResizing` defaults to false and the sample
never sets it, so the real window has no working maximize box. CNA's XNA `GraphicsDevice` builds
its `WindowDescription` without setting `resizable` and takes the platform default of `true`, so
every CNA game gets a resizable window. The binding places no pixels — `Present()` is a bare ABI
call, `ClientSizeChanged` only forwards an event — so this is not `../cna-cs`'s to fix and, per
`rules.md`, not this repository's either.

Worth knowing for whoever picks it up: the game-visible `Viewport.Width` after that resize was
about 640 in a 1200-wide window, and the C++ port's apparent difference in the same test is **not**
usable as evidence — its binary is from 2026-08-25 and statically linked against the CNA tree of
that date, a week behind the library used here. `scripts/repro-cna-report-001.sh` takes an
arbitrary executable and window name precisely so a rebuilt port can settle that.

`cna-bugs.md` is new and is where every below-the-ABI finding goes from now on: `rules.md` says
report and move on, and a finding scattered across three documents is a finding that gets lost.
Each record must separate what is established from what is not.

### Open items

- `CSINFRA-003`, `004` and `005` — the content-provenance, verbatim-source and eligibility
  checkers — are specified in `plan.md` but not written. Until then, both properties are verified
  by hand per sample and recorded in that sample's `missing.md`.
- No browser gate exists here and none is planned; `../cna-samples` remains the only repository
  making a WEBGL2 claim.
