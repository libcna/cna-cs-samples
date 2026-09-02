# LocalizationSample audit — CSSAMPLE-078

## Result

**The original C# runs unmodified and renders pixel-for-pixel identically to the C++ port** —
0 differing pixels of 384 000. No `../cna-cs` change was needed, and the .NET SDK built the four
satellite assemblies from upstream's own `.resx` files with no help.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/LocalizationSample_4_0` |
| Solution | `Localization (Windows).sln` |
| Project | `Localization/LocalizationWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `Localization.Program.Main`, a static `Program` class in `LocalizationGame.cs` |
| Assembly name | `Localization` |
| Content | `Font.xnb` and seven `Flag*.xnb` (neutral, `da`, `en-GB`, `en-US`, `fr`, `ja`, `ko`) |

Upstream's second project, `LocalizationPipeline`, is a Content Pipeline extension: design-time
only, not part of the running game, and not built here. Same boundary as `CSSAMPLE-092`.

## The one project-file addition, and why it is not a source deviation

The game threw at startup:

```text
Could not find the resource "Localization.Strings.resources" among the resources
"Localization.Localization.Strings.resources" embedded in the assembly "Localization"
```

Upstream's `.resx` files sit at the **root** of its project, so XNA embedded them as
`Localization.Strings.resources`. Here the upstream tree is checked in as a subdirectory, and the
.NET SDK derives a resource's manifest name from `RootNamespace` plus its path — which adds a
second `Localization.`. `Strings.Designer.cs` asks for the name upstream produced.

Five `<EmbeddedResource Update="..." LogicalName="..."/>` entries restore it. This is a consequence
of the repository's own layout, not a difference in the sample, and it is fixed where such things
belong: no file moved, no line of C# changed, `diff -r` still clean.

**The satellites themselves needed nothing.** `bin/Release/{da,fr,ja,ko}/Localization.resources.dll`
are produced by the SDK from the upstream `.resx` files directly.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Localization/Game.ico
7de2eb5b8f95912f4ab26f252fb83da2bfa5122bdf6b0d5a8c922e86282d757b  Localization.htm
b55916d91915fcd68054d4920abf16ab7ee1aeee7c6a2185f9578def4f5a808b  Localization/LocalizationGame.cs
00de96304a7e3da8eedc6ac91e6d8d3c35fcd6f038078ddaa1520c58f17a7d80  Localization/Localization.png
f216faaa9c51c40f171a0169ab87487bc66a45cf3f5531d6b5ee1b5853829e63  Localization/LocalizationWindows.csproj
b5936657edcd1e7632ede8304c43790b84f33fe0dc4502f2f631f5bd2b00679b  Localization/LocalizationXbox.csproj
376da6847729c910b070e3179940b30ec3e531f581b762958e3206aa01459401  Localization/Properties/AssemblyInfo.cs
148e98210096f7179c183196eaff90a39b90e1922a4fc1df3178a11c39d88141  Localization/Strings.da.resx
0191ff94abfb9b118700c65b510be5e188eb9ee7ad272367e58d70f840d42bed  Localization/Strings.Designer.cs
bae12b858685a387e447556b88be0c55d9d49565439237259bf078dbb7e19eda  Localization/Strings.fr.resx
49b688a095f61fa42ebda8d63f50097d9392291a58359cfca09a2a48774e739f  Localization/Strings.ja.resx
508eb1938f4e7aeb933eb6c1a8115aec5cb9b330b38a5c64b3605395abf6f554  Localization/Strings.ko.resx
59b5423a672d6c5fe4b55ff96f29b423dbdc81e2d18c00c431bfa6ce65a17b58  Localization/Strings.resx
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled
`Localization Sample`, exiting 0 on Escape. Against the C++ port: **0 differing pixels of 384 000**,
553 distinct colours in both.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The other cultures.** The sample picks its strings and flag from the current culture, and the
  run used the host's. The `da`, `fr`, `ja` and `ko` satellites build and deploy; that each renders
  its own strings and flag is untested, and would need the process started under a forced culture.
- **Gamepad.** No controller attached; Escape was exercised.

## Artifacts

`/rv/tmp/cs-samples/LocalizationSample/evidence/` — `release/` and `cpp-reference.png`.
