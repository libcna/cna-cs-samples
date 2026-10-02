# Real XNA 4.0 games on CNA.NET

The gallery rows prove Microsoft's samples. These are games: code written to ship, not to teach.
Each project here compiles a game's **unchanged** XNA 4.0 sources against CNA.NET exactly as its own
XNA project compiled them (same files, defines, profile), with **official XNA Content Pipeline
output**: either the content the game's repository ships, or content built from its own
`.contentproj` and pipeline extensions by XNA's `BuildContent` under Wine
(`scripts/build-xna-content.sh`). Nothing of a game is checked in here; `GameRoot` points at its
checkout.

| Game | Source | Content | Measured 2026-10-01 and -02 (CNA.NET `4fc7dfb`; music and the games added 2026-10-02 on CNA.NET `880b6bc`, CNA `fad9fabe0`; the rest CNA `1c2923efd`) |
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
| Virulent (work in progress) | `github.com/vwr0527/Virulent-game` @ `b89be89` | shipped `bin/x86/Debug/Content` (20 `.xnb`) | its intro, title menu and start page; Enter loads the tutorial level: the player and the platforms with the build's own collision outlines. Its own XNA `.exe` stops at startup under Wine, so there is no XNA frame to compare |
| Kosmic Warz | `github.com/ActiveNick/KosmicWarz-WP` @ `e892775` | built: 44 files from its content project with its own pipeline extension (WindowsPhone/Reach); its song a labelled stand-in, converted | menu, then a level by touch: the 3D fleet, the ship, the DPSF starfield and explosions, the HUD; DPSF from its author's own prebuilt `DPSFPhone.dll` (`deadlydog/DPSF-XNA` @ `0b80a2f`, MIT) unchanged |
| Dominó Tropical | `github.com/itsshortforleo/DominoTropicalXNA` @ `ac426b7` | shipped `bin/x86/Debug/Content` (129 `.xnb`, XACT) | title 0.32% (10% fuzz) from its own XNA-built `.exe` under Wine, all in one tile whose alpha pulses while the pointer is over the window; a click on New Game deals: the double six, four hands, the score |
| A Princess' Request (Ludum Dare 30) | `github.com/cedwards145/princess-request` @ `fdcf9a6` | built: 35 assets from its content project | title, then its first map: the player, the lit silhouette level, its "WASD to move" hint; no XNA build in the repository to compare with |
| My Big Head Is Weighing Me Down | `github.com/debreuil/MyBigHeadIsWeighingMeDownGame` @ `eb974cd` | built: its content project with Swf2XNA's pipeline extension (`debreuil/Swf2XNA` @ `da62298`, from source): the Flash-authored level, its font | its level: Flash-drawn art, Box2D physics on crates and heads, the particle trail; Swf2XNA's runtime from source (`../Swf2Xna`) |
| Playing in Traffic | `github.com/debreuil/PlayingInTrafficGame` @ `3ca43c1` | built likewise, XACT banks; its four videos labelled stand-ins (`--video-standins`: the game's own `.wmv`, XNA's Video layout) | its splash video, decoded and drawn by SpriteBatch under its Flash overlay, then its main menu; it reads only an Xbox 360 gamepad (no input manager without one, as on Windows) |
| Resonance | `github.com/lordcodes/resonance-game` @ `b591114` | built: 282 assets with its own pipeline extension, XACT banks by XactBld3; its 4 songs are labelled stand-ins (`--song-standins`) | loads its level on its own thread, then plays: the arena, the Bad Vibes, the HUD; physics from the BEPUphysics binary it ships; the menu's music |
| Escape From Enceladus | `github.com/zachmu/escape-from-enceladus` @ `337b3bb`, with the Farseer Physics 3.3.1 and DebugView it redistributes and its Json.NET 4.5 binary | built: its content project (558 `.xnb`, 3 effects, XACT with a streaming song bank, its November font) and DebugView's; its four music tracks are not in its repository, so the song bank holds labelled 5 s silent stand-ins | (2026-10-02, CNA `46231e857`, CNA.NET `b4bedce`) title with its three save slots read at once; Space (its keyboard scheme), Enter: its first room plays, the player runs right |
| __Defense | `github.com/gamealgorithms/defense` @ `3b456a6` (the tower-defense sample of Sanjay Madhav's *Game Programming Algorithms and Techniques*) | built: its XNA project's `XNAContent.contentproj` (54 `.xnb`, 3 bloom effects, Game Studio's Quartz MS and Segoe UI Mono fonts) -- the `Content/` it ships beside it belongs to its MonoGame project | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) full screen at the desktop's mode, as it asks: its menu, then START!!: the hex field with its bloom, the base and wave 1 under way |
| Missile Command | `github.com/the-saif-ahmad/MissileCommand` @ `c6a4ff7` (a remake of Atari's) | built: its content project (28 `.xnb`: 20 textures, 7 sounds, Game Studio's Quartz MS font) | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) full screen: its title, then Space: the terrain, six cities and three silos under the mouse's crosshair; nothing needed changing |
| Super Mario World (Sprint 4) | `github.com/buttsj/c-sharp-mario` @ `f2fee21` (a student team's demo) | built: its content project (181 `.xnb`); its eight MP3 songs labelled stand-ins (`--song-standins`, then `convert-xna-songs.sh`), five documentation images its repository lacks listed, not built | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) title menu; Space: level 1 -- Mario runs right, HUD with lives, time and coins; nothing needed changing |
| The Legend of Zelda (clone attempt) | `github.com/edgiardina/Zelda` @ `d2dd348` | built: the content project its game project references, `Zelda.Content` (26 `.xnb`), into the `Zelda.Content` root it loads from | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) title, its fade into the save menu, then Up (to Register) and Enter: its first screen -- the life bar, water and an enemy; nothing needed changing. Not compared with XNA: the repository ships no XNA build |
| Bubble Bound | `github.com/zfedoran/bubblebound` @ `8171890`, with the SkinnedModel library it carries | built: its content project (47 `.xnb`: 7 FBX models, 8 effects) with its SkinnedModel runtime and its skinned- and instanced-model pipeline extensions, and its level XML | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) title over its dimmed 3D scene; Enter: the bubble drifts through the lit undersea landscape among particles, as its own screenshot looks; nothing needed changing |
| Spineless (Global Game Jam 2013) | `github.com/gnomicstudios/GGJ13` @ `ae0934b`, with its Gnomic engine and animation libraries and the Farseer Physics it carries | built: its content project (20 `.xnb`: 10 sounds, 2 fonts, 8 clip animations) with Farseer, Gnomic.Anim and Gnomic as pipeline extensions in that order, its 13 sprite sheets copied as its project copies them | (2026-10-02, CNA `51d9c84cc`, CNA.NET `1326161`) the siege tower with the princess and the heart meter; Right: the landscape scrolls, the enemies march on the tower and its knight steps out, the heart rises to 10%. Its sounds are XNA's own ADPCM, three at rates above 48000 Hz (up to 48084), which needed CNA CBIND-146; CodeDom, which its engine names and never calls, comes from its .NET package |

In a browser and on Android (2026-10-02, CNA `ffb82bc0d`): `scripts/browser-sample.sh games/<Game>`
(headless Chromium) and `scripts/android-sample.sh games/<Game>` (the x86_64 emulator) build each game
from the same project and content. In a browser 14 of the 16 reach their title or play; HeliumBiker
starts a thread, which single-threaded WebAssembly cannot, and Playing in Traffic plays a video, which
the browser build has no backend for. On Android 15 of the 16 run; Playing in Traffic stops at the same
honest refusal of its video. Resonance loads its levels on a thread, so in a browser only its menu.

What these games needed from CNA.NET, each fixed where it lived: a Windows Phone title's full-screen
flag and Back button off a phone (CSX-094/095), Windows paths into XACT and `TitleContainer`
(CSX-096), a game's worker thread loading content (CSX-100/101, CNA C ABI 0.39.0), a library
compiled against XNA 4.0 (CSX-099), a vertex shader's point-size output on GLSL (CNA FX-140) and
`PhoneApplicationService.StartupMode` (CSX-103), a song played from the converted file beside
its `.wma` (CSX-105), `ActivatedEventArgs.IsApplicationInstancePreserved` (CSX-106), sprites
placed in 3D by a stock effect in `SpriteBatch.Begin` (CNA Task 1120), a video frame a
SpriteBatch accepts (CNA CBIND-142), a Shader Model 3 effect as Microsoft's compiler writes it
(CNA FX-141), one storage device shared by several worker threads (CSX-109), `List<T>.ForEach`
as .NET Framework 4.0 ran it (CSX-110), the graphics adapters in a game's constructor (CNA
CBIND-145, CSX-111), a not-yet-created device read as null (CSX-112) and a sound at the
sample rate XNA's own encoder wrote (CNA CBIND-146).

XNA writes every song as Windows Media Audio, which neither CNA nor FNA decodes. As in an FNA port,
`scripts/convert-xna-songs.sh <content-dir>` writes an Ogg Vorbis copy beside each `.wma`; the
`.xnb` and the `.wma` stay as they are. Rookie Drivers, Resonance and the sidescroller are silent
without it (SDL's disk audio driver records zeros) and play their music with it. Zombie Smashers
plays its music through XACT, which needs nothing.

Tried and not running here, each for a reason outside XNA:

- **StarWarrior** (`thelinuxlich/starwarrior_CSharp` @ `61d6880`, the Artemis example game): its sources
  use a generic `EntityProcessingSystem<T>` that neither the `artemis.dll` its repository ships nor
  the Artemis repository's own source (`thelinuxlich/artemis_CSharp` @ `db1e4e0`) has.

- **Space Conquest** (`cschar/spaceconquest` @ `8206744`): builds -- its 65 assets once the two
  case-variant content directories its repository splits are merged as Windows sees them, and with
  BinaryFormatter allowed -- and then its `Game1` reads `Content/Models/ModelConfig.txt`, a file its
  repository does not contain.
- **Divine Right** (`Haedrian/Divine-Right` @ `f8bb434`): its pathfinding P/Invokes Windows'
  `Kernel32` (`RtlZeroMemory`, `QueryPerformanceCounter`), and its Parchment font is not in its
  repository.

- **Second Realipony** (`erikmooney/SecondRealipony` @ `77b15c0`, a demo): its sprite fonts name
  Bookman Old Style and Calibri, commercial fonts that neither its repository nor Game Studio ships.
- **Eva Frontier** (`Righteous-Noodle/Eva-Frontier` @ `35def75`, Imagine Cup 2011): one of its XNA 4.0
  copy's sprite fonts needs Vrinda, which neither its repository nor Game Studio ships.
- **Samurai** (`Code52/Samurai` @ `12bc84d`): a Windows Phone client of an online strategy game whose
  server (`samuraitest.apphb.com`, AppHarbor) is gone; its NuGet packages are not in the repository.

- **Snails** (`xesf/SnailsXNA` @ `433338a`, Two Brains Games' Steam release, with its built content):
  its published source builds on no platform. Its Windows projects compile a Windows Forms stage
  editor and WCF service references into the engine; its FNA project, which compiles against
  CNA.NET otherwise, lists `RemoteAPICallScreen.cs`, which calls `BrainGame.RemoteServicesManager`
  that the published `BrainGame.cs` comments out -- FNA would fail the same way.

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
- **Sleepwalker** (`debreuil/SleepwalkerGame`): its sprite font names Inkpen2 Chords, a commercial font
  the repository does not ship.
- **DwarfCorp** (`Blecki/dwarfcorp`): its XNA build reads typed text through a Windows Forms
  message filter and `user32`'s `TranslateMessage`; the repository's other builds are FNA's and
  MonoGame's, not XNA's.
- **EvoNet** (`pampersrocker/EvoNet`): a Windows Forms application hosting XNA in a control.
- **Astro Flare Rampage** (`JoeMarsh/Astro-Flare-Rampage`): a Silverlight and XNA application.
- **Drumkit XNA** (`microsoft/drumkit-wp`): its sprite font names Segoe WP, which the Windows Phone
  SDK installed and which is not available here.
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

Kosmic Warz's DPSF binary comes from its author's repository, sparsely (the whole is 732 MB):
`git clone --filter=blob:none --no-checkout https://github.com/deadlydog/DPSF-XNA.git` then
`git sparse-checkout set --no-cone "/XNA 4.0/Installer/Installer Files/DPSFPhone.*" /LICENSE` and
`git checkout`. Its content: `--project SpaceInvadersWP7Content/SpaceInvadersWP7Content.contentproj
--profile Reach --platform WindowsPhone --extension "ParticleSettings/ParticleSettings (Windows).csproj"
--extension SpaceInvadersWP7Pipeline/SpaceInvadersWP7Pipeline.csproj --song-standins`, then
`scripts/convert-xna-songs.sh` on the output.

Escape From Enceladus's four music tracks are referenced by its XACT project and absent from its
repository: `ffmpeg -f lavfi -i anullsrc=r=44100:cl=stereo -t 5 -c:a pcm_s16le` writes each of
`spur`, `exploration`, `sanfran`, `disaster` `.wav` beside `Music/game.xap` first (labelled in their
metadata). Then `--project "EscapeFromEnceladus/EscapeFromEnceladusContent/EscapeFromEnceladus
Content.contentproj" --profile HiDef --font Fonts/november_regular/novem___.ttf`, and DebugView's
`Farseer Physics Engine 3.3.1 Samples XNA/DebugView XNA/Content/DebugView XNA Content.contentproj`
(`--profile Reach`) into the same output: DebugView loads its `font` from the game's content root.

The two Swf2XNA games need `debreuil/Swf2XNA` cloned as `/rv/tmp/xna-games/SWF2XNA` (their
projects name it `..\..\SWF2XNA`), and its pipeline as six extensions in dependency order:
`Vex/Vex.csproj`, `SwfReader/SwfFormat.csproj`, `GdiRenderer/GdiRenderer.csproj`,
`VexPipelineReader/VexPipelineReader.csproj`, `VexTo2DPhysics/VexTo2DPhysics.csproj`,
`VexPipeline/VexPipeline.csproj` (`--profile HiDef`; Playing in Traffic adds `--video-standins`).

`GameRoot` (and `GameContent` for the games with built content) override the checkout locations. The XNA 4.0
reference frames come from the games' own XNA-built executables run under Wine with the XNA 4.0
prefix (`~/.wine-cna-xna40`, WineD3D) on a private Xvfb larger than the game's window (Wine
shrinks a window that does not fit the screen and stretches its back buffer into it).
