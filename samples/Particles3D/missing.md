# Particles3D audit — CSSAMPLE-043 ✅

## Result

**The original C# runs unmodified and draws what the C++ port draws.** The Windows project's sources, verbatim, build in Debug and Release with no warnings. Both start on the explosions effect over the checkered ground, with projectiles, fire and smoke trails drawn through the sample's compiled particle effect. Its particle systems seed `new Random()` from the clock, so no two runs — of this build, the C++ port or XNA — draw the same particles; the pixel figure measures that, not a defect. The first frame differs by 62.05%.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Particles3DSample_4_0` |
| Project | `Particle3DSample/Particle3DSampleWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `Particle3DSample.Program` |
| Assembly name | `Particle3DSample` |
| Content | the particle effect, the explosion, fire and smoke textures, the checkered ground and the font — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
d628b76bad675a4ea66b33d1888959c33a5930fe4734cd973bb2aed30831edb0  Particle3D.htm
fd70dab3802b5eea2a9c2bf4b8903093a915ef91db05e6bec60d332c0e0b8bb8  Particle3DSample/Game.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Particle3DSample/Game.ico
603e1f47227efbdc0144ec44de3b3c1615cf1226ebad6231b8c122fbaefad5f6  Particle3DSample/Particle3DSample.png
2a5657403a1672295f7050ca4286d7d77e201b164e335b3839e8d523e56ac8eb  Particle3DSample/Particle3DSampleWindows.csproj
af2cfaacf74004ac906e766b2eb83a676d5fad381ccd92cd428e61f1350c1243  Particle3DSample/Particle3DSampleXBox.csproj
cd12106af1edaff6c9692bd880806dac3d62b97f7cd281dbe42ebca3123f4484  Particle3DSample/ParticleEmitter.cs
82465515d55ff4c28890f3788027e94d7d0e0b06f44b508dcff8d2e7d5d910d4  Particle3DSample/ParticleSettings.cs
cd086606e86baddca4db80508ee3d3cc92d5d10d74257ef45962ff0ffc68b64a  Particle3DSample/ParticleSystem.cs
a1dd9aa7eacf41f1b76ecfcd24d34c3834038c35d5d765cd4336ae23907f747a  Particle3DSample/ParticleSystems/ExplosionParticleSystem.cs
4b8728f805a8bb78199dca6ed8e668bdda0363da6bbb8638fbf5be37f7efa4cf  Particle3DSample/ParticleSystems/ExplosionSmokeParticleSystem.cs
2cc1bb7eb9a3605209978355d58146a832fc6b6587deeff09f3b0511ff29bd0d  Particle3DSample/ParticleSystems/FireParticleSystem.cs
1c0cd2f64b9090fa64233fec2066f2883b99ddc610cddea626de59db9e6594b6  Particle3DSample/ParticleSystems/ProjectileTrailParticleSystem.cs
a842bf675dac7d3c20d352027f3e0fdfb9c67ba1fdab1c78b2ef473dd7d12257  Particle3DSample/ParticleSystems/SmokePlumeParticleSystem.cs
2b97d17cf2f66bf61105afa0cbb62f350ec6b840fb6cedee8c7a2097fcbdd466  Particle3DSample/ParticleVertex.cs
02dd7dac0cec484f4a8dfeed8793d9e59de458ee176c1e0d9fa101a83b5c2743  Particle3DSample/Projectile.cs
84b3e680a52da584f3be29edfea929b9fb205ad2ec6dd5867dee62b60f60e54e  Particle3DSample/Properties/AssemblyInfo.cs
```

## What was verified

The first frame against the C++ port's frame captured the same way, compared by eye. Runs against CNA.NET `590d007`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-58/Particles3D/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
