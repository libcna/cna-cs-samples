# XmlParticles audit — CSSAMPLE-045 ✅

## Result

**The original C# runs unmodified and draws what the C++ port draws.** The game and its `ParticleSettings` library, both verbatim, build in Debug and Release with no warnings. The settings are the library's own type, read by XNA's reflective reader; both start on the explosions effect over the checkered ground. Its particle systems seed `new Random()` from the clock, so no two runs — of this build, the C++ port or XNA — draw the same particles; the pixel figure measures that, not a defect. The first frame differs by 77.50%.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/XmlParticles_4_0` |
| Project | `XmlParticles/Particle3DSample/Particle3DSampleWindows.csproj` with `XmlParticles/ParticleSettings/ParticleSettingsWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `Particle3DSample.Program` |
| Assembly name | `Particle3DSample` |
| Content | the five particle-system settings (XML the pipeline compiled into the `ParticleSettings` library's type), the particle effect, the textures, the checkered ground and the font — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `ParticleSettings/`) is clean.

```text
c5126e5c1837c60581044eb9184d4f8c2f7b0059cdd46e5deae36bd44a331a0f  ParticleSettings/ParticleSettings.cs
02ad6da986d4dd5a0d770794a999e2f5c7026b10463dc810b54a4b42415bc735  ParticleSettings/ParticleSettingsWindows.csproj
df07a8247bc7f2b0220631a5c894a98f30f437dd5f5fcb8544bdc6f50e338bc8  ParticleSettings/ParticleSettingsXbox.csproj
16f8e4d9203742e70c4b94e2e83c34fcde92a4d95ec6222fbe34597ee30dec1a  ParticleSettings/Properties/AssemblyInfo.cs
c7808cba2663b51a1d3af075f41d00e5846a54656662fdae5347409f26a74ca3  Particle3DSample/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Particle3DSample/Game.ico
603e1f47227efbdc0144ec44de3b3c1615cf1226ebad6231b8c122fbaefad5f6  Particle3DSample/Particle3DSample.png
32d2cd321b7c5a4ec172e2aa75863350ceb67e2f583422761a85c2caedf7e5d4  Particle3DSample/Particle3DSampleWindows.csproj
d86bc81f202e92d305f37a01a31892b35abd3b25693ef66df5e6ba9a93a69288  Particle3DSample/Particle3DSampleXBox.csproj
cd12106af1edaff6c9692bd880806dac3d62b97f7cd281dbe42ebca3123f4484  Particle3DSample/ParticleEmitter.cs
6d82a6facd3fa43755fd23fe1f11948bf6ccff7395843055cbe54eddf3a54455  Particle3DSample/ParticleSystem.cs
2b97d17cf2f66bf61105afa0cbb62f350ec6b840fb6cedee8c7a2097fcbdd466  Particle3DSample/ParticleVertex.cs
02dd7dac0cec484f4a8dfeed8793d9e59de458ee176c1e0d9fa101a83b5c2743  Particle3DSample/Projectile.cs
0a2462514c58d777e58928fd49cc0fbe166d9b629904c81d27a514eda3e7b638  Particle3DSample/Properties/AssemblyInfo.cs
1781420a57109cc41393a3870813199fd4579d117d655ad12d924bfe2757bedf  XmlParticles.htm
```

## What was verified

The first frame against the C++ port's frame captured the same way, compared by eye. Runs against CNA.NET `590d007`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-58/XmlParticles/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
