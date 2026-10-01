# PerformanceMeasuring audit — CSSAMPLE-081 ✅

## Result

**The original C# runs unmodified and draws what the C++ port draws.** The Windows project's sources, verbatim, build in Debug and Release with no warnings; it exits 0 on Escape. Both show 50 colliding spheres, the FPS counter and the timing ruler; the spheres start at random positions and the timings are measurements, so the first frame differs by 13.48%.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/PerformanceMeasuringSample_4_0` |
| Project | `PerformanceMeasuring/PerformanceMeasuring/PerformanceMeasuring (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `PerformanceMeasuring.Program` |
| Assembly name | `PerformanceMeasuring` |
| Content | the ground model, its checker texture and the font (the spheres are generated) — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
e2d34306cda9503c7be0190eec366924270bc6c51bbaa77cb8a895f6717a7ab5  PerformanceMeasuring/Background.png
21ca32e9d055bb94d65d296386f18f1dd8387d74f0b43f6e3321093bda22a78a  PerformanceMeasuring/GameDebugTools/DebugCommandUI.cs
32472ce1c91cf36c2afd7c88919b18aa0a1e9586993487764ea49bacb8192860  PerformanceMeasuring/GameDebugTools/DebugManager.cs
e153ed262e69f25e7512862244dd32d2ecd1bc805fbb70674ffa48ae5d35149f  PerformanceMeasuring/GameDebugTools/DebugSystem.cs
eaa6bf6751af07225dce6f3028a2f2c185c3899df23b12fc23f40a69ac913889  PerformanceMeasuring/GameDebugTools/FpsCounter.cs
7654b01b8b2812df08d44cc220157c150e83ac2138f38308d1e98a47ec8d9c84  PerformanceMeasuring/GameDebugTools/IDebugCommandHost.cs
bf72d17b78c92d141d5f491b1bff4cbd76a023ff80c401aba5986735dbc80744  PerformanceMeasuring/GameDebugTools/KeyboardUtils.cs
255508c999955a597b0fff1ad063dba9327a43f97c8e826b093c8be0d18cd413  PerformanceMeasuring/GameDebugTools/Layout.cs
afdae7e16f995eb4b2893d02aba2278763c7e69134184733a41f590a8174b9e0  PerformanceMeasuring/GameDebugTools/RemoteDebugCommand.cs
2cad862b039e18cc604c61868964b54bd155d22d558ec4e6f8a0a24f1999ed9a  PerformanceMeasuring/GameDebugTools/StringBuilderExtensions.cs
7dd395c57bd8c98883bf70a51e2b56cc5e111c56a9223b98c86d5d68257ccb37  PerformanceMeasuring/GameDebugTools/TimeRuler.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  PerformanceMeasuring/Game.ico
f6ddc97341930ab90ffed680a9c5d7e4c0619927668466ed2da71ae3f3cdd7ae  PerformanceMeasuring/GameThumbnail.png
c9f4356156cc3b31fc0a0283f20465bade2bb6f8d71434eee0cc601ec8782692  PerformanceMeasuring.htm
c0570a46c0bbdf6b7825dd7f84ee6c5a4c6f3ce50e4d543a66df10f35071c889  PerformanceMeasuring/PerformanceMeasuringGame.cs
3e2b683b504f6fbf7d3a79c0cebafa5def624ff16a04ffe536679017ff51862b  PerformanceMeasuring/PerformanceMeasuring (Phone).csproj
13f678ffad800280904754fe315591d4c057eff51cb75171e7aceaded95a90d3  PerformanceMeasuring/PerformanceMeasuring (Windows).csproj
1f08b5fb5b5974cadfc69a76f470e90abf2ccdcba26d38614d93ec0b8bcf64e9  PerformanceMeasuring/PerformanceMeasuring (Xbox).csproj
6e66ce93c593d094cb201c6c697543ceef17de048b27366e33f8c29400fb7aa8  PerformanceMeasuring/Primitives/GeometricPrimitive.cs
ac56f518d1ec625c1ca489765eb7206388c1e45ce691fbd3f77f7cb8548e70f9  PerformanceMeasuring/Primitives/SpherePrimitive.cs
891a3f5c17c9d3b84efafd403dad7b144ee367c56fc594287c7928321c20f846  PerformanceMeasuring/Primitives/VertexPositionNormal.cs
f00d888753b0b4313fba67ae849e01f7f1454439592e326f70196e41a1c6b93c  PerformanceMeasuring/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  PerformanceMeasuring/Properties/AppManifest.xml
93c8928c518937b4ccab8885f1e3508fc0a39c57a82a15dbff19e27eaacf0531  PerformanceMeasuring/Properties/AssemblyInfo.cs
d8d7ec17fe664de4e6c92810803d75c17858351058402d22414848b310fef5f6  PerformanceMeasuring/Properties/WMAppManifest.xml
9968f5c9d52f140e674551f3deee75c159c9905d534babdb0bf98474eb606f17  PerformanceMeasuring/Sphere.cs
```

## What was verified

The first frame against the C++ port's frame captured the same way, compared by eye. Runs against CNA.NET `eb2f2ee`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-59/PerformanceMeasuring/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
