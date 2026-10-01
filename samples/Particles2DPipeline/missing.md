# Particles2DPipeline audit — CSSAMPLE-044 ✅

## Result

**The original C# runs unmodified and draws what the C++ port draws.** The game and its `ParticleSettings` library, both verbatim, build in Debug and Release with no warnings. The settings are the library's own types, read by XNA's reflective reader. Both start on the explosions effect with the same HUD and the same free-particle counts but one. Its particle systems seed `new Random()` from the clock, so no two runs — of this build, the C++ port or XNA — draw the same particles; the pixel figure measures that, not a defect. The first frame differs by 54.86%.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/Particles2DPipeline_4_0` |
| Project | `Particles2DPipelineSample/Particles2DPipelineSample/Particles2DPipelineSample (Windows).csproj` with `ParticleSettings/ParticleSettings (Windows).csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `Particles2DPipelineSample.Program` |
| Assembly name | `Particles2DPipelineSample` |
| Content | the four particle-system settings and the emitter settings (XML the pipeline compiled into the `ParticleSettings` library's types), the textures and the font — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directories (the game's and `ParticleSettings/`) is clean.

```text
2ab32d2f5531ea25aaf78c6f7542fa8d104ec24153ca6e7103466a3935e9ec64  ParticleSettings/ParticleSettings (Phone).csproj
9ccabba40e5788668d893f2c2834ab55aeacd58661eff3784380b60d22b7177a  ParticleSettings/ParticleSettings (Windows).csproj
39b96a60ab12f4653155c1290ae7920753d57dcf16fae911aa8f9a0808477676  ParticleSettings/ParticleSettings (Xbox).csproj
da8211b526bfcd643abef71f2e665e9eb637f8f2d2e419979239d242110b006d  ParticleSettings/ParticleSystemSettings.cs
4c443a5f9a470ade74e038ddadcf9c1c1d01d66bef47391efa389bbc3de433fa  ParticleSettings/Properties/AssemblyInfo.cs
e44526c1c127b8d546ad1f4682ce955fa8fcd70f24bf81ac3b131c9f202fae3e  Particles2DPipelineSample/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  Particles2DPipelineSample/Game.ico
38a03abb96ba518db74308e25f8da0cb928f614830d90e443e30eea8e8b793c9  Particles2DPipelineSample/GameThumbnail.png
bf9bc575ffb22e0fd9e4012840607066415baf1f1698fe5df5065656cbef41dc  Particles2DPipelineSample/Particle.cs
12ad7aa59faebea82c328f9c309f68cb80eb82e407a73a1c0eb3e7d44300dbea  Particles2DPipelineSample/ParticleEmitter.cs
a1b76139f01c62f759b24e5989465a6d1c93c4f4d617eff21a759907f5c0c9dc  Particles2DPipelineSample/ParticleHelpers.cs
e30e95a7c5e26467acbc3806085706e3e5954631804813e99fe8e9b1e9e941dd  Particles2DPipelineSample/Particles2DPipelineSample (Phone).csproj
ba93a304246ea57629bed585a0ccda3cccb919b12c40ae79f6c776f7a79ef57d  Particles2DPipelineSample/Particles2DPipelineSample (Windows).csproj
5e78cb69254ec9a7daba6783eca0db594296355c1f610b6febac592146ee68ac  Particles2DPipelineSample/Particles2DPipelineSample (Xbox).csproj
26ff466550b8a131b229f76f99f83aad5d791b8e687df943b043b58388b41b12  Particles2DPipelineSample/ParticleSampleGame.cs
3e0909a08f331e3a48f023604f6e10a01de8a082f00586c5ae0114d199269490  Particles2DPipelineSample/ParticleSystem.cs
7dbdf67bd517b011ac78e131b9dfd8435104fcbb3e03b221ba8cbaf3fde51810  Particles2DPipelineSample/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  Particles2DPipelineSample/Properties/AppManifest.xml
9ab79d29edc872b0c34215cf22aab3641eed9c2410be21ee0882e129d3dfe5e1  Particles2DPipelineSample/Properties/AssemblyInfo.cs
d8cf87707a7045af06651627618a1c7476b986f6293cd589805c0f7f90f13bcc  Particles2DPipelineSample/Properties/WMAppManifest.xml
c71bf89fac9f6a1fd03edbdee4b4e1b054318ef90794a19b453bfee3ad423fe7  ParticlesPipelineSample.htm
```

## What was verified

The first frame against the C++ port's frame captured the same way, compared by eye. Runs against CNA.NET `590d007`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-58/Particles2DPipeline/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
