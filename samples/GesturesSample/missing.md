# GesturesSample audit — CSSAMPLE-079

## Result

**The original C# runs unmodified and renders pixel-for-pixel identically to the C++ port** —
0 differing pixels of 384 000. No `../cna-cs` change was needed.

This is the first phone-only row to reach `✅`, and it did so **without touching a source file**.
That narrows `DEC-001`'s second question considerably; see below.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/GesturesSample_4_0` |
| Solution | `TouchGestureSample.sln` — the only one upstream ships |
| Project | `TouchGestureSample/TouchGestureSample/TouchGestureSample.csproj` |
| Upstream configuration | `XnaPlatform=Windows Phone`, `XnaProfile=Reach`, `OutputType=Library`, packaged as `TouchGestureSample.xap` |
| Upstream `DefineConstants` | `TRACE;WINDOWS_PHONE` |
| **This build's `DefineConstants`** | **`WINDOWS`** (plus the SDK's `TRACE`, and `DEBUG` in Debug) |
| Entry point | `TouchGestureSample.Program.Main` in `Program.cs` |
| Assembly name | `TouchGestureSample` |
| Content | `cat.xnb`, `Font.xnb` |

## Deviation: `WINDOWS` instead of `WINDOWS_PHONE`

This is the row's one deviation, it lives entirely in the project file, and **no `.cs` file is
touched**. `diff -r` against the upstream project directory is clean.

Phone-only samples have no entry point of their own: the XAP host supplied it, so upstream's
`Program.Main` is wrapped in `#if WINDOWS || XBOX` and is not compiled under the shipped constants.
`CSSAMPLE-016` Bounce raised this as the second half of `DEC-001`, because there the guarded `Main`
constructs a `Game1` class that **does not exist** in the sample, so defining `WINDOWS` does not
even compile.

**Here it does.** Two facts make the choice safe rather than expedient, and both were checked
rather than assumed:

1. The `Game1` that `Main` constructs **exists** — `Game1.cs:21`.
2. The `#if WINDOWS || XBOX` around `Program` is the **only preprocessor directive in the entire
   sample**, across every file. There is no `#if WINDOWS_PHONE` code branch to lose.

So the constant decides exactly one thing: whether the entry point upstream itself wrote for desktop
gets compiled. Nothing else in the sample sees it.

**This matters beyond this row.** `DEC-001`'s entry-point question is not one decision but two: for
samples shaped like this one, the project file answers it with no invented code; only samples shaped
like Bounce, whose guarded `Main` names a class that is not there, need an owner ruling. Check which
shape a phone-only sample has before escalating it.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
b17d3689ba5dc88181027f0ab93f1866ba585a55fccfee9961e5328fda3ef09c  TouchGestureSample/Background.png
23cdcb462a5d3cbdddf7a1a344a97390043c3a6b7a6fa651418e21957c92108a  TouchGestureSample/Game1.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  TouchGestureSample/Game.ico
8e5a430e6a96a2e381929494b84aa025cfbd36aab5fe8ee80a8d83d7f9b0fc96  TouchGestureSample/GameThumbnail.png
e9d05b63fd1b864b029962bfb80a6e1b4da70b0fe9d7c147b2c1a8890a8ca35d  TouchGestureSample.htm
2f5438251736384f781ec8a1b75d7a3a3725094a16c4e174d861f65a971a2f78  TouchGestureSample/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  TouchGestureSample/Properties/AppManifest.xml
e8b645d05a6564543faf1cd7261782227c8c6aeae07c69ac19319087e2fd7e87  TouchGestureSample/Properties/AssemblyInfo.cs
3ef9b30b43bf28e26cbd2d2033bfbcb2921d93e7ef6af8dd8261a8e89b2d7a00  TouchGestureSample/Properties/WMAppManifest.xml
7f791c835e3064907c3b49b80fe68ff41d9ccf557f4c67cb829e515b7f3ac588  TouchGestureSample/Sprite.cs
f34b9fa18127207dc1a11736dde9e967da75cca8d56b9c6d9b2a3e684b90173b  TouchGestureSample/TouchGestureSample.csproj
```

## Native verification

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled
`TouchGestureSample`. The frame lists the sample's six gestures:

```text
Hold (in empty space) - Create sprite      Drag - Move sprite
Hold (on sprite) - Remove sprite           Flick - Throws sprite
Tap - Change sprite color                  Pinch - Scale sprite
```

**Escape does not exit, and that is the original's behaviour, not a defect.** `Game1.cs:81` exits
only on `GamePad.GetState(PlayerIndex.One).Buttons.Back` — the phone's hardware Back button. The
sample has no keyboard exit path to test, so the capture was run with `--no-exit-check`.

## Comparison with the C++ port

**0 differing pixels of 384 000**, four distinct colours in both. The static-scene control
(settle 5 s vs 9 s) is also 0: with no touch input there are no sprites and the instruction screen
does not animate, so the match is frame-independent.

### A measurement bug this row exposed

The first comparison reported **124 187 differing pixels**, and it was entirely wrong. The capture
picked the window with `xdotool search --name '.' | tail -1`, and SDL creates an unnamed 1x1 helper
window beside the real one; the crop was taken from the wrong geometry and produced a shifted,
garbage image.

`scripts/capture-sample.sh` now selects a **named** window larger than 8x8 pixels instead. Recorded
because a difference invented by the harness is worse than no measurement: it would have been
written up as a finding.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **Every gesture.** Hold, Tap, DoubleTap, FreeDrag, Flick and Pinch are what the sample is for, and
  driving them needs synthetic touch input the capture script does not have. `TouchPanel.EnabledGestures`
  is set without throwing, so the gesture API is reachable; whether the gestures are *recognised* is
  untested.
- **The Back exit.** No controller attached.

## Artifacts

```text
/rv/tmp/cs-samples/CSSAMPLE-079-GesturesSample/evidence/
├── release/          window capture, run log, window geometry, sha256
├── settle9/          the static-scene control
└── cpp-reference.png the C++ port through the same route
```
