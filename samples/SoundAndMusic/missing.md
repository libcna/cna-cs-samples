# SoundAndMusic audit — CSSAMPLE-060 ✅

## Result

**Runs, as the phone game it is, pixel-identical to the C++ port** — 0 differing pixels of 384 000 against the C++ campaign's start frame (`SAMPLE-060` evidence). Upstream ships only the phone project; its sources are checked in verbatim and build in Debug and Release. The song is loaded from its `.wma` beside the XNB, which is why the scaffold now copies the media the pipeline puts next to compiled content. The retained C++ phone binary asks for full screen, which a bare Xvfb cannot grant (SDL: "no window becoming fullscreen"), so its requalify capture is black; the comparison is against the C++ campaign's own start frame instead. Audio output is not part of this evidence.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SoundAndMusic_4_0` |
| Project | `SoundAndMusicSample/SoundAndMusicSample/SoundAndMusicSample (Phone).csproj` |
| Configuration | `Release` and `Debug`, Windows Phone (`TRACE;WINDOWS_PHONE`, the only upstream configuration), Reach, through the phone host (`CnaPhoneGame`, `CNA.PhoneCompat`) |
| Entry point | `SoundAndMusicSample.SoundAndMusicSampleGame` |
| Assembly name | `SoundAndMusicSample` |
| Content | fonts, images, the sound effects and the `Music` song with its `Music.wma` — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
e6a30deb1db2274e923f2969be0df4efe95d54ba4ce216f52b7b787f583c6f89  SoundAndMusicSample/Background.png
b709cae54d9b467982facea1c587a596cf61d80e18dddc36a5106cbbed4a41d5  SoundAndMusicSample/Button.cs
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  SoundAndMusicSample/Game.ico
2d7551347f74917860b9bbd0a52ce9368d09f4afc6c3194c94289ad9ae7eb78d  SoundAndMusicSample/GameThumbnail.png
ea6da9570f5a7e933ea4d483e77010f98894e6289df0e3d2aacc55b73112bcc0  SoundAndMusicSample.htm
6eca7b9c76ef71e3c6291dbdf3d33899ee6f347068194419e1e1da9e88d336c8  SoundAndMusicSample/Program.cs
f611dfc7e1e616ffaf7e949b4462db5211ea5edb14cba1b4819919e25c8a249d  SoundAndMusicSample/Properties/AppManifest.xml
03c6d462256a8afbeb4d4433aa773313329adf49f43b6486f728603311c89cad  SoundAndMusicSample/Properties/AssemblyInfo.cs
0b57b6b903f2cd7787e58971aee9d54d0cc16b7ad6d121efbff3d350af7282cb  SoundAndMusicSample/Properties/WMAppManifest.xml
68a2fcc59450fdc601010c0ac17ca03f9351ddbfd3e9b163d8467d6551e7da98  SoundAndMusicSample/SoundAndMusicSample.csproj.Debug.cachefile
1a25c6cf79791866de144c458b54f8d79020d3bfc0b224a40a37823a243b3902  SoundAndMusicSample/SoundAndMusicSampleGame.cs
f357a6eb81945e56e69bfb8e9037d6e4bbdd8016e7c8edcb9c8e6eb73aedf6f4  SoundAndMusicSample/SoundAndMusicSample (Phone).csproj
c5dc10a2b012de7093919949a43dbda3044cada6b678a490df781e08a52f7081  SoundAndMusicSample/UIHelper.cs
```

## What was verified

The first frame at 2% fuzz against `cna-native-opengles3-mouse-touch-qualified/01-ready.png` under `/rv/tmp/samples/SAMPLE-060-SoundAndMusic_4_0/evidence/`. Runs against CNA.NET `63e36fa`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-57/SoundAndMusic/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
