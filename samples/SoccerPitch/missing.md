# SoccerPitch audit — CSSAMPLE-073 ✅

## Result

**Runs, as the phone game it is, matching the C++ port.** Upstream ships only the phone project (its assembly is named `GrassRender1`, kept); its sources are checked in verbatim and build in Debug and Release. The first frame differs from the C++ port by 52.25%: the camera circles the pitch and the frame-rate counter differs; pitch, stripes, centre circle, ball and its shadow, and the `Alpha-Blend` mode are the same.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SoccerPitchSample_4_0` |
| Project | `SoccerPitch/SoccerPitch/SoccerPitch.csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `SoccerPitch.SoccerPitchGame` |
| Assembly name | `GrassRender1` |
| Content | the grass base, detail and stripe textures, the ball model and the font — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
5a2a4bcf04fc8b38b3c5d0f3265d8c4ef97bff7294d312c0d01c78c505898dce  SoccerPitch/App.config
73948fa0895c46dd3f9714e6634dcd11def59a2100558b699ec13fccb7a0dc65  SoccerPitch/Background.png
faeab6b696e7d3efab724df22bbf4836c93528ca6d81706cf5bb6ba8b13156c6  SoccerPitch/CustomVertexFormats.cs
2932e92d9afb1604472babfd04da3d74d73611aa6727e334722e9becc4c6bd8c  SoccerPitch/FrameRateCounter.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SoccerPitch/Game.ico
f5c52437615d6a130b72165116c30634a6e8d544aa11da412d1fa175af3d81a8  SoccerPitch/GameThumbnail.png
3ecd9efcaabe887142bbac5ee1ea25c2a29affebe20225f1973211d6e9217189  SoccerPitchOverview.htm
0cf6cfec265dde09ff300df3267bd512a2295aaeae5c0a63ea21446c8086a5a3  SoccerPitch/PlanePrimitive.cs
7d3f12abbe936eaa680f9e750ddd67caf43ca23ac096d05272871f989baade93  SoccerPitch/PlanePrimitiveDualTextured.cs
c3bf43ab2221e2ef554be7634fe4cf0c6df5c082ed08d300128c2644e88ce5f8  SoccerPitch/PlanePrimitiveTextured.cs
f5caa0b032f87c3a469ab1be3498d8d252a908f79d072ca1f1251ac2d0454f3a  SoccerPitch/ProceduralPrimitive.cs
0a9ef8c12b5e176bf12f6772dba39125d5b6995161eb975513790ac0614b1dc4  SoccerPitch/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SoccerPitch/Properties/AppManifest.xml
98ea126f26e4fa8e1031b643fc6866cb5e08f248b81297e6a60b10b7cfb1e4be  SoccerPitch/Properties/AssemblyInfo.cs
a03c7fce44009f7410d2835776143ec52b7dbe65d25d9e4fb99fc15585edd4f5  SoccerPitch/Properties/WindowsPhoneManifest.xml
2560abfe5cb917dfb4071c42813210cd9292ae964e2646d89dd8b92bbe4cd352  SoccerPitch/SoccerPitch.csproj
bc52e6e0ca7ea29618e483c01b12380a2aa3df75f4242b40a5d9bd05897ecc95  SoccerPitch/SoccerPitchGame.cs
a944a1e93bc36847681ad5322d1af2b298bd945361804c8f6787f76af4d8edbe  SoccerPitch/SpherePrimitiveTextured.cs
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way, and the two frames compared by eye. Runs against CNA.NET `590d007`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-58/SoccerPitch/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
