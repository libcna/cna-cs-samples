# MicrophoneEcho audit — CSSAMPLE-098

## Result

**The original C# runs unmodified.** It renders **pixel-for-pixel identically to the C++ port**: 0 differing pixels of 384 000. No `../cna-cs` change was needed.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/MicrophoneEchoSample_4_0` |
| Project | `MicrophoneEchoSample/MicrophoneEchoSampleWindows.csproj` |
| Configuration | `Release|x86` and `Debug|x86`, Windows, Reach |
| Entry point | `MicrophoneEchoSample.Program` |
| Assembly name | `MicrophoneEchoSample` |
| Content | `MyFont.xnb` |
| Native library | `cmake-build-release-capi`, Release OPENGLES3, built 2026-09-02 |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
703f3467c27dcc7b472230cd7d67ceca001d5e483ed55460494978da20c2de69  MicrophoneEcho.htm
58d4568241f6e8fabcd0af462b3f2e097be4635a9021ee4df3d59b067848229f  MicrophoneEchoSample/Background.png
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  MicrophoneEchoSample/Game.ico
7bbffd2f0266767a63e0e2016f371fba5e5360d9ddd34e5fa30e0428ab731d92  MicrophoneEchoSample/GameThumbnail.png
1b1b8bba7b24dd4b27706ba09f6801fddc5d5fe17cfc187beea431d2f6db01c2  MicrophoneEchoSample/MicrophoneEchoSampleGame.cs
564760dbfa8655fa9a90893c9b4bb9f51ccddf2eb7a6c29d04cddae05d678c00  MicrophoneEchoSample/MicrophoneEchoSamplePhone.csproj
824d6f9a11f35107fa39d3c0f0172edac3f8bcc07c0d90beb14a145b41de5cc4  MicrophoneEchoSample/MicrophoneEchoSampleWindows.csproj
0da7cacccb091ffd6ad656311e5ae54218fc22fae8549d8cc4a43a3529c399a1  MicrophoneEchoSample/MicrophoneEchoSampleXbox.csproj
3b7f5b9f311703cc3edb031e36331fcd40de35b2c4f9438147ee0a1110c9841f  MicrophoneEchoSample/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  MicrophoneEchoSample/Properties/AppManifest.xml
4e48b7cac1020052092d1da273100aca8554ae854ece3c1c18fb6fde823c7886  MicrophoneEchoSample/Properties/AssemblyInfo.cs
5dd32fe3f1b8a7d6cd6649b88e2ad228b22be4c1c6f37ff28364e185aad0db78  MicrophoneEchoSample/Properties/WMAppManifest.xml
```

## Native verification and comparison

Debug and Release both build 0/0 and run on `OPENGLES3` in an 800x480 window titled
`MicrophoneEchoSample`, exiting 0 on Escape. Against the C++ port: **0 differing pixels of
384 000**, four distinct colours in both.

## Not verified

- **No browser result.** No .NET route to CNA's WEBGL2 backend exists.
- **The microphone itself.** The sample records and echoes audio, and no capture device is
  attached to this host. What is established is that the sample starts, renders its instruction
  screen and shuts down cleanly; whether `Microphone.Start` captures is untested here.
- **Gamepad.** No controller attached; Escape was exercised.

## Artifacts

`/rv/tmp/cs-samples/MicrophoneEcho/evidence/` — `release/` and `cpp-reference.png`.
