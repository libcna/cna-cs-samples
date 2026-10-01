# InverseKinematics audit — CSSAMPLE-057 ✅

## Result

**The original C# runs unmodified; the cylinder chain reaches for the cat as in the C++ port and the original.** The Windows project's sources, verbatim, build in Debug and Release with no warnings. The first frame differs from the C++ port by 2.36% (9 667 px), which is the avatar: the sample draws `AvatarRenderer(AvatarDescription.CreateRandom())` and drives its left arm with the same IK. On Windows, XNA's renderer never becomes `Ready` and the original draws no avatar (the C++ campaign's `ik-xna-*` frames), and the retained C++ binary predates CNA's avatars and shows the same. Current CNA renders Xbox-style avatars, so the avatar appears here; CNA composes the sample's bone transforms as XNA's contract defines (`bone × bind pose × parent`, the composition the sample's own IK assumes). The avatar's pose has no reference on this machine (no Xbox 360 capture exists) and is not claimed to match one. The run starts GamerServices with a private home and no session bus, so it touched no real profile.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/InverseKinematics_4_0` |
| Project | `InverseKinematics/InverseKinematics/InverseKinematicsWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, HiDef |
| Entry point | `InverseKinematicsSample.Program` |
| Assembly name | `InverseKinematics` |
| Content | `cylinder.xnb`, `cat.xnb` and `font.xnb` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
f855878266d6c56b581dec7eabe431e399b827c2f755893091535579eb05add6  InverseKinematics/Cat.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  InverseKinematics/Game.ico
5305b031c6b9f1dbedcada02e8db0eba82997ebd9a129639f1b468d9a5292319  InverseKinematics/GameThumbnail.png
6bb25e13bf7f4db29bf668c649902102bc9ea6fae6871214793897817750cbad  InverseKinematics/IKSample.cs
500618eafc94d5edbbd57170895e61e6ddd67d9700df7633ddfaacabf3987e44  InverseKinematics/InverseKinematicsWindows.csproj
bc22166da1dacd21feebb656103695e7e62250bb55440c8d47d47577cece70ba  InverseKinematics/InverseKinematicsXbox.csproj
48ec5b7aafeae4a29826943893dc0fd413744de34171c777b3bc52064c646bdb  InverseKinematics/Properties/AssemblyInfo.cs
```

## What was verified

The first frame at 2% fuzz against the C++ port's frame captured the same way, with the differing pixels located (the avatar's silhouette and the moving chain). Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/InverseKinematics/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
