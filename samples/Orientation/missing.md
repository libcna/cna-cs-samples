# Orientation audit — CSSAMPLE-102

## Result

**The original C# runs unmodified**, and it is the C++ port that differs — measurably, and for a
reason this row identified rather than guessed. No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Orientation_4_0` |
| Solution | `OrientationSample (Phone).sln` — the only one upstream ships |
| Project | `OrientationSample/OrientationSample/OrientationSample (Phone).csproj` |
| Upstream `DefineConstants` | `TRACE;WINDOWS_PHONE` |
| **This build's `DefineConstants`** | **`WINDOWS`**, on the `CSSAMPLE-079` basis below |
| Entry point | `OrientationSample.Program.Main` in `Program.cs` |
| Assembly name | `LayoutSample` — upstream's own, and not the name of the game that runs |
| Content | `directions.xnb`, `Font.xnb` |

`AssemblyName` is `LayoutSample` while `Program.Main` constructs `OrientationSample`. That
mismatch is upstream's and is preserved rather than tidied.

## Deviation: `WINDOWS` instead of `WINDOWS_PHONE`

The same project-file-only deviation `CSSAMPLE-079` established, and it qualifies on the same two
checks: the class `Main` constructs (`OrientationSample`, `OrientationSample.cs:23`) **exists**, and
the `#if WINDOWS || XBOX` around `Program` is the **only** preprocessor directive in the sample. No
`.cs` file is touched.

`LayoutSample.cs` is compiled here by the SDK's default glob although upstream's project does not
list it. It contains a second `Game` class that nothing constructs, so it does not run;
`../cna-samples`' own `SAMPLE-102` audit reached the same conclusion and excluded it as source
rather than treating it as a second product.

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
916e5f88643c2c3539da1454eb7a4940e3ba8feefabdfd6ad00c0c014d984f3b  OrientationSample/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  OrientationSample/Game.ico
f11055011e0d492e64722d9f8c370cd5e17c3de5f3c1f2a39f597f6719e69b7f  OrientationSample/GameThumbnail.png
80505e4c54bda19c00d36d75553dcddf133c12fdafafcf96736abd8c5f793153  OrientationSample.htm
24ef686369cbf16abc34006913d6a2a3ac781bb2f8f640f9b52851144be71d9b  OrientationSample/LayoutSample.cs
c3a6f4ac239c24da577b48d03e1a8e4f90d0a3cc97f9b5286dd1c24b5a642cb1  OrientationSample/OrientationSample.cs
728508d9f3a9766a0ab6ef670aea4d6f3a9dd5a18feef1484b7229f31287bd4d  OrientationSample/OrientationSample (Phone).csproj
0c6d17a650729dea0cc33040c0aa520560c9724e8cb4c9971424ce91748df677  OrientationSample/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  OrientationSample/Properties/AppManifest.xml
cb7855d9783cdbdc8f3a778705edbd8f436bf185f4cba92ad5a98466dbd3b4bb  OrientationSample/Properties/AssemblyInfo.cs
1846617c1231d50c422832f2a7870efe5b419497c22423b970e5c8dbe2d15580  OrientationSample/Properties/WMAppManifest.xml
```

## The comparison, and what it found in the other engine

Both engines draw the directions sprite centred. Measured:

| | window | white box | size | pixels |
|---|---|---|---|---:|
| C# on CNA.NET | 800x480 | x 280..519, y 120..359 | 240x240 | 55 780 |
| C++ port | 800x480 | x 230..469, y 70..309 | 240x240 | 55 780 |

**Identical size and identical pixel count, different position** — 106 504 differing pixels purely
from the offset.

The sample centres the sprite itself: `Viewport.Width / 2 - directions.Width / 2`
(`OrientationSample.cs:200`). For an 800x480 viewport that is x=280, which is where **this build
puts it**. The C++ port's x=230 implies a viewport of 700x380 in an 800x480 window.

The cause is the window's position on screen. Re-capturing the C++ port with its window moved to
**(0,0)** instead of (50,50) puts the box at centre (399,239) — correct. At (50,50) it is at
(349,189), short by exactly the window offset:

| C++ port window position | box centre | implied viewport |
|---|---|---|
| (0,0) | (399,239) | 800x480 |
| (50,50) | (349,189) | 700x380 |

So the port's game-visible viewport tracks the window's screen position. **This build does not do
that** — its capture is taken with the window at (100,100) and the box is at (399,239).

This is the same family as `CNA-REPORT-001`, where a resized window also gave the game a viewport
that was not the window's. It is **not filed as a new report**, because the port's binary predates
the C ABI library used here and the honest conclusion is that the managed build is correct today,
not that CNA is broken today. Anyone revisiting `CNA-REPORT-001` should rebuild this port first and
re-run the position test above; it is a sharper probe than the resize one.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **Orientation changes.** The sample is about portrait/landscape transitions, which need a device
  or a driven orientation change; only the default frame was captured.
- **Exit.** Escape does not exit, as with `CSSAMPLE-079`: this is a phone sample with no keyboard
  exit path.

## Artifacts

```text
/rv/tmp/cs-samples/Orientation/evidence/
├── release/            this build's capture, window at (100,100)
├── cpp-reference.png   the C++ port, window at (50,50)
└── cpp-at-origin/      the C++ port, window at (0,0) -- the position test
```
