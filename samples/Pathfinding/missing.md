# Pathfinding audit — CSSAMPLE-022

## Result

**The original C# runs unmodified and renders pixel-for-pixel identically to the C++ port** —
0 differing pixels of 384 000. It did not at first: it failed to load its maps, and the cause was a
real binding defect, fixed in `../cna-cs` with five tests.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Pathfinding_4_0` |
| Solution | `Pathfinding (Windows).sln` |
| Projects | `Pathfinding/Pathfinding/PathfindingWindows.csproj` **and** `MapData/PathfindingDataWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `Pathfinding.Program.Main` |
| Assembly names | `Pathfinding` and `MapData` |
| Content | 13 official pipeline XNBs, including `Map1.xnb`–`Map4.xnb` |

## Two assemblies, kept as two

`MapData` is upstream's runtime library and is built here as **its own assembly**, not folded into
the game. That is not tidiness: the map content was produced by upstream's pipeline project and
names its reader by assembly-qualified type name, so the assembly has to be called `MapData` for
the content to resolve. `CSSAMPLE-007` SpriteSheet has the identical shape.

Both projects set `EnableDefaultCompileItems=false` and list their own tree, because two upstream
source trees live side by side under one directory and the SDK's glob would otherwise compile each
into both.

Upstream's `MapData` directory also carries Phone and Xbox project files; they are checked in
unchanged and unused.

## Binding fix — content asset names now resolve case-insensitively

The first run failed at content load:

```text
cna_game_run failed with native result Callback: Could not open content asset 'map1'
```

`Map.cs:120` asks for `"map1"`; the file on disk is `Map1.xnb`. **That is correct XNA.** These games
were written against a case-insensitive filesystem, and on Windows and Xbox 360 the load succeeds.

CNA's native content manager already resolves this way — the C++ port of this sample loads the same
files under the same names on the same CNA build, which is what established that the managed side
was the odd one out rather than the sample being wrong.

`XnaContentPath.ToFilePath` built the path and handed it back unchecked, and every caller then did
an exact `File.Exists`. It now falls back to a case-insensitive match in the same directory. The
exact path is still tried first, so a correctly-cased game never reaches the scan; a missing asset
still returns the exact path, so the error names what the game asked for.

Fixed in `../cna-cs` `a6bbaaf`, pinned by `tests/CNA.Framework.Tests/XnaContentPathCaseTests.cs` —
five tests covering the case-insensitive hit, an exact match winning over a differently-cased
sibling, a subdirectory in the asset name (which also exercises XNA's backslash spelling), and the
two paths that must not throw. Suites after: 627 framework, 225 XnaCompat, 210 native integration.

**This one is likely to have been costing more than this sample**, since any XNA game may spell an
asset name differently from its file.

## Source deviations

**None.** `diff -r` against both upstream project directories is clean.

```text
ec154b1868605fbd763700c265491102c2ca12101a9d70a9583bc795c9b9e11d  MapData/Background.png
828b6e3d1ca335aa2878586720e2f7770f00622591cefa6632e12f7df0b72dc4  MapData/Content/Content.contentproj
5ab99f756d888f36d81a71b43a71839412189182e5f11f633cdc745253bd66ee  MapData/MapData.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  MapData/Properties/AppManifest.xml
533488288b77a26238b0e320b97eff6067304357ef019bff878a33405af3b7d7  MapData/Properties/AssemblyInfo.cs
0c2e2592d271aaf0936696010803e06dbbb5841cc6d84c7e8ba373b37cd56b8d  MapData/Properties/WMAppManifest.xml
5daadb043b828872c85ee2003a24ad6bcaa4e18b2b7411001ce1dd895ed04484  Pathfinding/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Pathfinding/Game.ico
82cc90cb312a9ab2d33f106ce500903f285a01c5f75bfee5d5b49042f46f24da  Pathfinding/GameThumbnail.png
54ea04bf59716e156889356dae00e7799d5a305c6a943410cd452fbf19bf60aa  Pathfinding.htm
a2f8d892a24c9c43ffcf9beabaea8268a2450542289d6520163068ed1e5edc5e  Pathfinding/Map.cs
a83644524a2f6076fabf3066fa55d99ad735b02f8401e24c3458aca7d68425e6  Pathfinding/PathFinder.cs
d0dd1f7f586fe990c4e06a266eb82f3fc1e8d84286a630d12afe0daab44f21a3  Pathfinding/PathfindingSample.cs
3f8f379a404552fe1b5d1216db46bfeb09e6a7180a02822e3a9e0e72a2d6a200  Pathfinding/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Pathfinding/Properties/AppManifest.xml
b6d222f37cb214fa1ae1620792bc72cae3d5091b25e8dcc4f443a5331e6c4f8c  Pathfinding/Properties/AssemblyInfo.cs
e2b8211844d0690282032f54b8f9e8be9c505ad2beffffb2226bf9bb12b8cab5  Pathfinding/Properties/WMAppManifest.xml
119d372be4ca22392c258263c4df566d169a0151e8fb785138414422199084ac  Pathfinding/Tank.cs
c47d867ad55f4f4dcf69fb9baf747e93c6df4c94c521a047c864c9b809d47a5f  Pathfinding/WaypointList.cs
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled `Pathfinding`.
5 602 distinct colours, and **0 differing pixels of 384 000** against the C++ port.

**Escape does not exit**, and that is the original's behaviour: `PathfindingSample.cs:323` exits only
on `GamePad.Buttons.Back`. The capture runs with `--no-exit-check`.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The pathfinding itself.** The sample walks a tank along a computed path on four maps; only the
  first frame of the first map was compared.
- **The Back exit.** No controller attached.

## Artifacts

`/rv/tmp/cs-samples/Pathfinding/evidence/` — `release/` and `cpp-reference.png`.
