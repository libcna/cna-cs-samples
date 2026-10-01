# SimpleAnimation audit — CSSAMPLE-050 ✅

## Result

**The original C# runs unmodified.** The Windows project's sources, verbatim, build in Debug and
Release with no warnings, load the tank `Model` and its two textures, animate it, and exit 0 on
Escape. Against the C++ port the frame differs by 4.45% (17 078 px at 2% fuzz): the same tank,
captured at another moment of its time-driven wheel, steer, turret, cannon and hatch animation.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SimpleAnimation_4_0` |
| Project | `SimpleAnimation/SimpleAnimationWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `SimpleAnimation.Program` |
| Assembly name | `SimpleAnimation` |
| Content | `tank.xnb` and its two textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
637dbf910ef1b8fd089a72d4c326935d924b877f777c025c225766449a412dc5  SimpleAnimation/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SimpleAnimation/Game.ico
1cb4bd8181fe001fa4a3be9b06e8a0d8e43fb9a76259c7f79eb44a2be4514282  SimpleAnimation.htm
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SimpleAnimation/Properties/AppManifest.xml
9fb7db437f14d2f66c66163e46c5a509657dabeb0c03661669dd014964ee0a15  SimpleAnimation/Properties/AssemblyInfo.cs
0e72466ef91f67d9ce45e57b45585f9d6d31ae46beba63b3000cb193266663c5  SimpleAnimation/Properties/WMAppManifest.xml
2bd8414ae891301f76cc900be8b57b6e119782b0de97ffa5c12d111fc8f77495  SimpleAnimation/SimpleAnimation.cs
ed2b9bd9c40d4d4ce786994de55fda57b455a741b9c6552ee04f0fb0fb471152  SimpleAnimation/SimpleAnimationPhone.csproj
12fc8531a6e1fd81eb5984cb63266b88562331f515bfd253ec4661b4838e18a3  SimpleAnimation/SimpleAnimationSample.png
f308cb3c0647edfca8e512d315461da9b81741844869e1eae3556a7fcccc9956  SimpleAnimation/SimpleAnimationWindows.csproj
fc38c6fd09e0ecb399c36661caad8beb318320e3bbeea0e63d6fe6c9c5d052fc  SimpleAnimation/SimpleAnimationXbox.csproj
f2cb3715cf92d2c09f3389446daca191dc59083026500074bd0ee30cf3fd6c16  SimpleAnimation/Tank.cs
```

## What was verified

Sources verbatim, content identical; Debug and Release 0 warnings; runs against CNA.NET
`8fcd961`, CNA `80572aa00` (`build-probe`, Release OPENGLES3, compiled
effects) on a private Xvfb in an 800x480 window titled `Simple Animation`; Escape exits 0.

## Artifacts

`/rv/tmp/cs-samples/cssample-050/SimpleAnimation/` (C# capture and logs) and `.../cpp/` (the C++ port).
