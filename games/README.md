# Real XNA 4.0 games on CNA.NET

The gallery rows prove Microsoft's samples. These are games: code written to ship, not to teach.
Each project here compiles a game's **unchanged** XNA 4.0 sources against CNA.NET exactly as its own
XNA project compiled them (same files, defines, profile), with **official XNA Content Pipeline
output**: either the content the game's repository ships, or content built from its own
`.contentproj` and pipeline extensions by XNA's `BuildContent` under Wine
(`scripts/build-xna-content.sh`). Nothing of a game is checked in here; `GameRoot` points at its
checkout.

| Game | Source | Content | Measured 2026-10-01 and -02 (CNA.NET `4fc7dfb`, music and the sidescroller `82cd310`; CNA `1c2923efd`) |
|---|---|---|---|
| [Speedy Blupi](SpeedyBlupi/README.md) | `openeggbert/mobile-eggbert-legacy` `speedy-blupi-xna4` @ `6d35cca` | its XNA build's `build/bin/Content` (280 `.xnb`) | title 255 px from XNA 4.0 under Wine (save-game numbers); plays, pauses |
| Rookie Drivers | `github.com/Gaming-Triad/rookie-drivers` @ `d9c099b` | shipped `bin/x86/Debug/Content` (23 `.xnb`) | title 0.24% from its own XNA-built `.exe` under Wine; race screen as XNA draws it; its music (5 songs) |
| TIE Fighter Forever | `github.com/prenex/tiefighter` @ `3c72d10` | built: 42 assets, 4 pipeline-extension projects → 62 `.xnb` | menu, battle with the game's own effect models, game-over screen |
| NePlus | `github.com/PhoenixWright/NePlus` @ `f9fb441` | built: its 3 content projects (59 `.xnb`, XACT) with its prebuilt Mercury and Tiled pipeline extensions | title with its Bloom effect; plays: Tiled map, Krypton light, Mercury rain, Farseer physics -- five prebuilt XNA 4.0 libraries (Farseer, DebugView, Mercury, TiledLib, EasyConfig) unchanged; the build gives `Content\Config.ini` a Unix name |
| HeliumBiker | `github.com/danielgomezrico/HeliumBiker-Game` @ `83880ab` | built: 30 assets and its XACT project | runs to its "CONNECT" screen and waits there, as on Windows without one: the published source drives the bike only from a Wii Remote (`DeviceFactory` returns `WiimoteDevice`; the keyboard device is commented out), and the Wiimote search fails quietly here as there |
| Zombie Smashers X | `github.com/glitchculture/ZombieSmashersXNA4` @ `ad8af7c` | its repository's XNA build output: 45 `.xnb` (5 effects), XACT banks, its `data` maps and characters | its menu, from its own effects and art; the game reads only an Xbox 360 gamepad, and none is attached here. Its own XNA `.exe` stops at an unhandled exception under Wine, so there is no XNA frame to compare |
| Moto Trial Racer | `github.com/microsoft/moto-trial-racer-wp` @ `9464556` | built: 59 assets incl. Game Studio's QUARTZ MS font (WindowsPhone/Reach) and its 3 level files; Box2D.XNA from its source | menu, level choice and a level 1 run against the clock on Box2D physics, by touch |
| Solitaire (XNASolitaire) | `github.com/microsoft/solitaire-wp` @ `f6acde9` | built: 56 textures (WindowsPhone/Reach) | deals a Klondike layout; a tap on the stock turns a card (the phone's touch from the mouse) |
| Megaman vs. Zombies (XNASidescroller) | `github.com/Mavinkea/XNASidescroller` @ `65b51d6` | shipped `bin/x86/Debug/Content` (12 `.xnb`) | title 8 px of 480 000 from its own XNA-built `.exe` under Wine; plays: the jungle, Megaman, the zombies, the HUD, its music |
| Resonance | `github.com/lordcodes/resonance-game` @ `b591114` | built: 282 assets with its own pipeline extension, XACT banks by XactBld3; its 4 songs are labelled stand-ins (`--song-standins`) | loads its level on its own thread, then plays: the arena, the Bad Vibes, the HUD; physics from the BEPUphysics binary it ships; the menu's music |

What these games needed from CNA.NET, each fixed where it lived: a Windows Phone title's full-screen
flag and Back button off a phone (CSX-094/095), Windows paths into XACT and `TitleContainer`
(CSX-096), a game's worker thread loading content (CSX-100/101, CNA C ABI 0.39.0), a library
compiled against XNA 4.0 (CSX-099), a vertex shader's point-size output on GLSL (CNA FX-140) and
`PhoneApplicationService.StartupMode` (CSX-103), and a song played from the converted file beside
its `.wma` (CSX-105).

XNA writes every song as Windows Media Audio, which neither CNA nor FNA decodes. As in an FNA port,
`scripts/convert-xna-songs.sh <content-dir>` writes an Ogg Vorbis copy beside each `.wma`; the
`.xnb` and the `.wma` stay as they are. Rookie Drivers, Resonance and the sidescroller are silent
without it (SDL's disk audio driver records zeros) and play their music with it. Zombie Smashers
plays its music through XACT, which needs nothing.

Tried and not running here, each for a reason outside XNA:

- **Rabbit Apocalypse** (`valryon/Rabbit-Apocalypse` @ `a12768a`): builds -- its engine and data
  projects, the prebuilt EasyStorage and OgmoXNA4 libraries, content with its prebuilt Ogmo
  pipeline and its own font -- and then its engine P/Invokes Windows' `winmm.dll` (`joyGetPos`) to
  scan joysticks before any XNA call. A Windows API, not XNA's. `games/RabbitApocalypse` is kept for
  a Windows run.
- **Flux** (`headdetect/Flux-XNA`): its sprite fonts name Fabada and Origin, which the repository
  does not ship; XNA's pipeline cannot build them, and another font would not be its content.
- **infinecraft** (`adamveld12/infinecraft`): its core references `TomShane.Neoforce.Controls.dll`,
  which the repository does not ship (only its XML documentation).
- **Grey Infection** (`VisualStudioEX3/Grey-Infection`): the repository holds its Xbox 360 project
  and one shader, not its art.
- **Diseased Toast** (`Sharparam/DiseasedToast`): its `Main` opens a console through `kernel32`
  (`AllocConsole`) and uses Windows Forms.
- **Mannux** (`andyfriesen/Mannux`): a `winmm.dll` timer and Windows Forms.
- **Minor Destruction** (`geel9/Minor-Destruction`): calls Windows Forms directly (`MessageBox`,
  cursors), which .NET does not have off Windows.
- **XNA Racing Game** (`Pepsi1x1/XNA-4-Racing-Game-Kit` @ `c05d519`): `BaseGame`'s constructor
  takes the game window as a Windows Forms `Form` (`Form.FromHandle(Window.Handle)`) to hide it
  until its settings are applied, and `Program` reports device errors through `MessageBox`.
- **The Great Paper Adventure** (`thibault-p/The-Great-Paper-Adventure`): its README says the art is
  not free and not included; the content project holds three fonts, level files and one 1x1 bitmap.
- **Expanze** (`alenkacz/Expanze`): its sources and art without a project or content project, so
  neither what it compiled nor what its pipeline built can be read off the repository.
- **Nu, Pogodi!** (`martinsuchan/WP.NuPogodi`): a Silverlight and XNA application -- XAML pages,
  `System.Windows` controls, MVVM Light -- like the gallery's Yacht.

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
scripts/convert-xna-songs.sh "/rv/tmp/xna-games/rookie-drivers/Rookie Drivers/Rookie Drivers/bin/x86/Debug/Content"
```

For resonance-game (`--project Resonance/Resonance/ResonanceContent/ResonanceContent.contentproj
--profile HiDef`, its `AnimationLibrary` (Windows copy), `ResonanceLibrary` and
`ContentPipelineExtension` projects as `--extension`, the two fonts in `Non code files/Fonts` as
`--font`, and `--song-standins`): XNA's SongProcessor encodes through the Windows Media Format
writer, which does not run under Wine, so its songs are ffmpeg WMA in XNA's Song container
(`scripts/song-standin.sh`), not official pipeline output. `<GameProject>` compiles exactly the
sources the game's own project lists; its directory holds ten more it did not.

`GameRoot` (and `GameContent` for the games with built content) override the checkout locations. The XNA 4.0
reference frames come from the games' own XNA-built executables run under Wine with the XNA 4.0
prefix (`~/.wine-cna-xna40`, WineD3D) on a private Xvfb larger than the game's window (Wine
shrinks a window that does not fit the screen and stretches its back buffer into it).
