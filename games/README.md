# Real XNA 4.0 games on CNA.NET

The gallery rows prove Microsoft's samples. These are games: code written to ship, not to teach.
Each project here compiles a game's **unchanged** XNA 4.0 sources against CNA.NET exactly as its own
XNA project compiled them (same files, defines, profile), with **official XNA Content Pipeline
output**: either the content the game's repository ships, or content built from its own
`.contentproj` and pipeline extensions by XNA's `BuildContent` under Wine
(`scripts/build-xna-content.sh`). Nothing of a game is checked in here; `GameRoot` points at its
checkout.

| Game | Source | Content | Measured 2026-10-01 (CNA.NET `4fc7dfb`, CNA `1c2923efd`) |
|---|---|---|---|
| [Speedy Blupi](SpeedyBlupi/README.md) | `openeggbert/mobile-eggbert-legacy` `speedy-blupi-xna4` @ `6d35cca` | its XNA build's `build/bin/Content` (280 `.xnb`) | title 255 px from XNA 4.0 under Wine (save-game numbers); plays, pauses |
| Rookie Drivers | `github.com/Gaming-Triad/rookie-drivers` @ `d9c099b` | shipped `bin/x86/Debug/Content` (23 `.xnb`) | title 0.24% from its own XNA-built `.exe` under Wine; race screen as XNA draws it |
| TIE Fighter Forever | `github.com/prenex/tiefighter` @ `3c72d10` | built: 42 assets, 4 pipeline-extension projects → 62 `.xnb` | menu, battle with the game's own effect models, game-over screen |
| Solitaire (XNASolitaire) | `github.com/microsoft/solitaire-wp` @ `f6acde9` | built: 56 textures (WindowsPhone/Reach) | deals a Klondike layout; a tap on the stock turns a card (the phone's touch from the mouse) |
| Resonance | `github.com/lordcodes/resonance-game` @ `b591114` | built: 282 assets with its own pipeline extension, XACT banks by XactBld3; its 4 songs are labelled stand-ins (`--song-standins`) | loads its level on its own thread, then plays: the arena, the Bad Vibes, the HUD; physics from the BEPUphysics binary it ships |

What these games needed from CNA.NET, each fixed where it lived: a Windows Phone title's full-screen
flag and Back button off a phone (CSX-094/095), Windows paths into XACT and `TitleContainer`
(CSX-096), a game's worker thread loading content (CSX-100/101, CNA C ABI 0.39.0), a library
compiled against XNA 4.0 (CSX-099), a vertex shader's point-size output on GLSL (CNA FX-140) and
`PhoneApplicationService.StartupMode` (CSX-103).

Not XNA 4.0, so not here: the BitSits games (`Squares-Vs-Triangles`, `Moolecule`, `RainingLetters`,
`Apple-e-Apple`, `Treasure-Island`) are XNA 3.1 projects with 3.1 content.

## Reproducing

```bash
mkdir -p /rv/tmp/xna-games && cd /rv/tmp/xna-games
git clone https://github.com/Gaming-Triad/rookie-drivers.git && git -C rookie-drivers checkout d9c099b
git clone https://github.com/prenex/tiefighter.git && git -C tiefighter checkout 3c72d10
cd tiefighter && ../../../data/development/github.com/libcna/cna-cs-samples/scripts/build-xna-content.sh \
    --project "TIE Fighter Forever/Content/TIE Fighter ForeverContent.contentproj" \
    --out /rv/tmp/xna-games-content/tiefighter/Content --profile Reach \
    --extension TypeReaders/CollisionPipelineRuntimeHelper.csproj \
    --extension CollosionLoader/CollisionPipeline.csproj \
    --extension StarFighterEffect1Pipeline/StarFighterEffect1Pipeline.csproj \
    --extension MotherShipEffect1Pipeline/MothershipEffect1Pipeline.csproj
cd /rv/data/development/github.com/libcna/cna-cs-samples
dotnet build games/TieFighter/TieFighter.csproj -c Release    # likewise the others
```

For resonance-game (`--project Resonance/Resonance/ResonanceContent/ResonanceContent.contentproj
--profile HiDef`, its `AnimationLibrary` (Windows copy), `ResonanceLibrary` and
`ContentPipelineExtension` projects as `--extension`, the two fonts in `Non code files/Fonts` as
`--font`, and `--song-standins`): XNA's SongProcessor encodes through the Windows Media Format
writer, which does not run under Wine, so its songs are ffmpeg WMA in XNA's Song container
(`scripts/song-standin.sh`), not official pipeline output. `<GameProject>` compiles exactly the
sources the game's own project lists; its directory holds ten more it did not.

`GameRoot` (and `GameContent` for TIE Fighter, Resonance and Solitaire) override the checkout locations. The XNA 4.0
reference frames come from the games' own XNA-built executables run under Wine with the XNA 4.0
prefix (`~/.wine-cna-xna40`, WineD3D) on a private 800x480 Xvfb.
