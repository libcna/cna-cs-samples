# SnowShovel audit — CSSAMPLE-083

## Result

**The original C# runs unmodified.** No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SnowShovelSample_4_0` |
| Project | `SnowShovel/SnowShovel/SnowShovelWindows.csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `SnowShovel.Program` |
| Assembly name | `SnowShovel` |
| Content | `plink.xnb`, `ScoreFont.xnb`, `shovel.xnb`, `snowflakes.xnb`, `TitleFont.xnb` |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, built 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
aa923ca09c4bd77fd7dbdaaae8dba29ff001414cd3c1550595a6b393040f5ceb  SnowShovel/app.config
77b7f6e36cd95ca202c0dfd0c5d5622d1d0101e62cc41082886543f4b96b22d9  SnowShovel/Game.cs
419cd03d942f38a6421f7e895abd9a5afd14ff7c5d2c29b2d492b40fb6606446  SnowShovel/Game.ico
dc4b0027824b1e3899f78bfb6621d2e38dc44ac94967f412244402a959523ad4  SnowShovel/GameThumbnail.png
073e325f9b0d3fde69a7d9dba53263d898924bd494742e56eb9faa3b2e83509b  SnowShovel.htm
f19792966b4ca00e08dd3a6578e0bbf132bc3daefb201f88df05109260226760  SnowShovel/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SnowShovel/Properties/AppManifest.xml
dc63b9c53eb7af7d5132516e181d4386b1e9f0efcd2a267bb8ca588ad96b5d2d  SnowShovel/Properties/AssemblyInfo.cs
ab9b892a70d539da0a3ef8c56875eb8204d29a8e2e041013b3fe46d885200010  SnowShovel/Properties/WindowsPhoneManifest.xml
cbb4d06fe844de85ca89a61e9cfda758ba73ef8e85626b8429289b9f51628f18  SnowShovel/SnowShovelWindows.csproj
cc733ee01a7dd06c7dc7fdd122cd8dba34acfa16de5f0df35504f87c02b9cc9d  SnowShovel/SnowShovelWindowsPhone.csproj
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in a **480x800 portrait** window titled
`SnowShovel`, exiting 0 on Escape.

Against the C++ port: 3 044 distinct colours here, and **35 010 differing pixels of 384 000**. Both
frames show the same scene — the "Snow Shovel" title, the score and elapsed-time readouts, the
"Shovel snow before time runs out! / Tap screen to start" prompt, the red shovel and falling
snowflakes.

The difference is the snowflakes, and it is expected: `Game.cs` seeds a `Random` and spawns flakes
from it, so their positions differ between runs exactly as `CSSAMPLE-001`'s stars and
`CSSAMPLE-019`'s blocks do. The static furniture — title, prompt, shovel, readouts — is in the same
place in both.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **Gameplay.** The sample starts on a tap and is scored; driving it needs touch input the capture
  script does not have, so only the attract screen was compared.
- **`plink.xnb`.** The sample's sound effect loads with the rest of the content; it was not heard.

## Artifacts

`/rv/tmp/cs-samples/SnowShovel/evidence/` — `release/` and `cpp-reference.png`.
