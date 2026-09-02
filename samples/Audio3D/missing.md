# Audio3D audit — CSSAMPLE-059

## Result

**The original C# runs unmodified and renders pixel-for-pixel identically to the C++ port** — 0 differing pixels of 384 000. No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Audio3DSample_4_0` |
| Project | `Audio3D/Audio3DWindows.csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `Audio3D.Program, a static Program class at the bottom of Game.cs` |
| Assembly name | `Audio3D` |
| Content | 7 official pipeline XNBs: three cat sounds, a dog sound, two textures and a checker |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
5a6374e1694b2b82e2d1616e769c3594413136823fd968995d5072086887108f  Audio3D/3DAudioSample.PNG
029c4ecda083d1defda3863dbf8993fe28ade4fd3ac171c2b62efeca4fd9db7c  Audio3D/AudioManager.cs
8ae929e2bfe438bf90c0e82ff429cbd3d91c0eec110edb0180b9ae450fab5326  Audio3D/Cat.cs
e4d1ebe08df32c122b17fb4e910b988d52a0b8aa4575da6c90ed67d167d55150  Audio3D/Dog.cs
58ca6b50d200a8b7f17ea18bff5ce8ebb9f2fa6fc7c18cfd29adaceca4094285  Audio3D/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Audio3D/Game.ico
1d84241a9009fdbb0d2f922a77d0bea7cc732d2e81225817d2e2503c52b1be98  Audio3D.htm
3449d5619a23d58e0ce351a0cff78312315e04f8f67a75a4276fd3193b1647ba  Audio3D/IAudioEmitter.cs
22e91872fc7aee07493db83977a37dea2e87a99f4f1355bfd65993b38456fbfb  Audio3D/Properties/AssemblyInfo.cs
a4d14b65da8e7f281f1efed79e7b45241f5bdf8f88a17a49f368a2ce3547cd0e  Audio3D/QuadDrawer.cs
5cdf59852a962465bbc484b45e2a48e7b97e93b4cea0df123cb575af0734f815  Audio3D/SpriteEntity.cs
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled `Audio 3D`,
exiting 0 on Escape. 4 462 distinct colours, and **0 differing pixels of 384 000** against the C++
port.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The 3D audio itself**, which is the sample's entire subject. The four sound assets load without
  throwing, but nothing here listens: positional attenuation, Doppler and the emitter/listener
  update are untested. A row whose point is audio needs an audio gate this campaign does not have.

## Artifacts

`/rv/tmp/cs-samples/Audio3D/evidence/` — `release/` and `cpp-reference.png`.
