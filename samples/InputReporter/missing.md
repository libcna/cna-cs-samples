# InputReporter audit — CSSAMPLE-009

## Result

**The original C# runs unmodified and renders pixel-for-pixel identically to the C++ port** —
0 differing pixels of 409 440, 6 527 distinct colours in both. No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/InputReporter_4_0` |
| Solution | `InputReporter (Windows).sln` |
| Project | `InputReporter/InputReporterWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `InputReporter.InputReporterGame.Main` — in the **game class itself**, not a `Program` class |
| Assembly name | `InputReporter` |
| Content | 15 official pipeline XNBs under `Fonts/` and `Textures/` |

`Main` is a static method on `partial class InputReporterGame`. Fourth distinct location in nine
rows; there is no substitute for reading where it actually is.

## The `.resx` manifest-name rule, and where it had to live

The sample embeds `InputReporterResources.resx` and threw at startup:

```text
Could not find the resource "InputReporter.InputReporterResources.resources" among the resources
"InputReporter.InputReporter.InputReporterResources.resources" embedded in the assembly "InputReporter"
```

Upstream's `.resx` sits at its project root, so XNA embedded it as
`<RootNamespace>.<Filename>.resources`. Checked in one directory down, the SDK inserts the extra
path segment. `CSSAMPLE-078` LocalizationSample hit the identical thing, which is why the fix is now
a shared rule rather than a per-sample entry:

```xml
<EmbeddedResource Update="**/*.resx">
  <LogicalName>$(RootNamespace).%(Filename).resources</LogicalName>
</EmbeddedResource>
```

**It lives in `samples/Directory.Build.targets`, not `Directory.Build.props`**, and that is not a
style choice. Props is imported *before* the SDK's default item globs run, so an `Update` there has
no items to update and is silently a no-op — the rule looked correct, changed nothing, and both
samples failed exactly as before. Targets is imported after the project body.

`%(Filename)` keeps a culture suffix, so `Strings.da.resx` still becomes
`<RootNamespace>.Strings.da.resources` and the SDK still builds the satellite; `CSSAMPLE-078`'s
four satellite assemblies were re-verified after the move.

No `.cs` file is touched by any of this. It is a consequence of this repository's layout.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean apart from its own `Content/`
pipeline inputs, which `rules.md` excludes.

```text
0979677a847e463d625ed5aca07f78eab7359d1e85c4299212325dd421c7337a  InputReporter/ChargeSwitch.cs
d5ee16d41dba9b2f9fe96b4ed89680b2b10eeda4a6fcf8c5867a8944c7a4c5e0  InputReporter/ChargeSwitchDeadZone.cs
e624631174c963b2b807149e00eb830132277a885995183bd7b317b4d98d7a98  InputReporter/ChargeSwitchExit.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  InputReporter/Game.ico
9354a54f7018b58c3e1324ac5a39c81fb7d9085c774511802b7a45ece7b2cf9b  InputReporter.htm
55d481044da087643d4f90250fcce6ce9a64d20316c82b9e77119bafb9a25ec5  InputReporter/InputReporterGame.cs
88c03fd8b1f96a1fb3b8316c387b244fdd114f9516fbd837e63de175e955b2b8  InputReporter/InputReporter.png
7293d1a21bfa0d129e653da9dd9747045d45f5cc5718ab56cd119aed6df0bf1e  InputReporter/InputReporterResources.Designer.cs
fa2c9f10d8d01efa653a88655d843194a67869c242c09b31a5122f5c646ab2c9  InputReporter/InputReporterResources.resx
3044c778ca8decc5d75c9f9927477e85331b50720be65ebf7a5c3761465a73cc  InputReporter/InputReporterWindows.csproj
ff88a95d675c5046aaa2b3cc6c3789d45cda4857d891f0e153350b892c9fb685  InputReporter/InputReporterXBox.csproj
0c3d85a14fcd4f909d95caa9cced9336f133f3e4c88a6a2e8939f5b06a81c724  InputReporter/Properties/AssemblyInfo.cs
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 853x480 window titled `Input
Reporter`, exiting 0 on Escape. Against the C++ port through the same route: **0 differing pixels
of 409 440**.

That is a strong result for this sample specifically: it draws six different `SpriteFont`s and nine
controller textures, and every glyph and sprite lands on the same pixel in both engines.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The report itself.** The sample exists to display live gamepad state, and no controller is
  attached — the captured frame is the no-controller screen. What the connected-controller layout
  looks like is untested here.

## Artifacts

`/rv/tmp/cs-samples/InputReporter/evidence/` — `release/` and `cpp-reference.png`.
