# TexturesAndColors audit — CSSAMPLE-003 ✅

## Result

**The original C# runs unmodified; the difference from the C++ port is the older CNA in the port's binary.** The Windows project's sources, verbatim, build in Debug and Release with no warnings. The first frame differs by 2.77% (10 621 px): about 6 500 px of shading inside the textured cube, and the horizon band of the reference grid (y 160–191). An apitrace of both runs shows the grid draw byte-identical — same vertex data, same world-view-projection matrix, same `glDrawArrays` — except for the stock shader: the retained C++ binary was linked before CNA SOFTWARE-336 converted Direct3D clip depth to OpenGL's. Projecting the traced matrix by hand puts the far ends of the grid lines x = 7…16 at (568.7, 164.1), (592.8, 164.1)… running down-right, which is where this frame draws them and the C++ frame does not. Four rows above that far edge (y 160–163, x ≥ 569) are also filled here although no grid geometry projects there; they come from the same lines, whose unclipped ends lie ~30 000 px off screen, and are recorded rather than chased.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/TexturesAndColorsSample_4_0` |
| Project | `TexturesAndColors/TexturesAndColorsWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `TexturesAndColorsSample.TexturesAndColors` |
| Assembly name | `TexturesAndColorsSample` |
| Content | the five primitive models, `Clouds.xnb`, the `TexturesAndColors` effect and `DebugText.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  TexturesAndColors/Game.ico
d438ddde84afa9854218007cd236b277e63d675e86924b4d3e70ea2b675b60cd  TexturesAndColors.htm
2a6f9839341d82daf9e30230c46891e95671c7f1268ff1326afdfb0d02ecf450  TexturesAndColors/Properties/AssemblyInfo.cs
ad65c6015d9bb41c564643f6b58a7823a675e619accc345a6bbf03663a52aa13  TexturesAndColors/SampleCamera.cs
4151a8cdc970610f6c4bc97cd66da8079fc3e0e5ac0524701081a28a722a6159  TexturesAndColors/SampleGrid.cs
dc41770c188f2649fddeba30cb6754440663818d2abe2c2469b135abe5d84c6e  TexturesAndColors/TexturesAndColors.cs
765836aabe9507511dfbe7f4a723e8a726d64f8bf670e8b7cfc31f8544611473  TexturesAndColors/TexturesAndColors.png
8c9adc941cdd92d58b31852f1c1ba38c6db0275bd549230e02efbb395c2fe045  TexturesAndColors/TexturesAndColorsWindows.csproj
1ca11f4260d274043965d38fd741a79d88909ed6c955f6a84e34477e63ad9f3b  TexturesAndColors/TexturesAndColorsXBox.csproj
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way, and an apitrace of each run compared call by call at the grid draw. Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/TexturesAndColors/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
