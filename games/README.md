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
| Mahjong (XNA client) | `github.com/Jomata/Mahjong` @ `bc81398` (MIT; tile art by Martin Persson), with its Logic library | built: its content project (161 `.xnb`: 153 tile images, its fonts in Courier New and Game Studio's Quartz MS and Segoe UI Mono) | (2026-10-02, CNA `6e273cd89`, CNA.NET `1326161`) its menu over the table; a click on Play Mahjong deals against three computer players: its hand with the recommended discards highlighted and the dora indicator. Its options live in its `App.config`, read through ConfigurationManager from its .NET package. Its menu hit-tests the mouse, which found CNA CBIND-147 and CBIND-148 |
| XNA 4.0 Racing Game Kit | `/rv/tmp/XNAGameStudio/Samples/XNA-4-Racing-Game-Kit-master` (exDream's RacingGame brought to XNA 4.0; identical to cna-samples SAMPLE-152 `xna4-original`) | its own `RacingGameContent.contentproj` built by XNA 4.0's pipeline on Windows: SAMPLE-152 `evidence/xna4-authentic-build/Debug/Content` (339 `.xnb`, XACT banks, tracks) | (2026-10-02, CNA `fb5cb3ba2`, CNA.NET `ff08b93`) loads for about 40 s, switches to full screen as its settings ask, and runs its attract mode: the camera flies the track through the city and the mountains with the car, shadows and its "Press START to continue" -- no render-loop error in its own log. Needed CNA.NET CSX-113 (`models\Cube` for `Models/Cube.xnb`), CSX-114 (its Windows Forms: `Form.FromHandle`, `MessageBox`; opt-in `<CnaWindowsFormsCompat>`) and CNA FX-142 (a ps_1_x colour input linked as centroid on GLSL ES). Then plays: Space (held 2-3 s -- a frame takes longer than a quick tap under llvmpipe, so a short press falls between two polls; the same in full screen and windowed) opens its main menu, and three more Space presses and the up arrow take it into a race on the Advanced track -- lap 1/3, 62 MPH in 2nd gear, its HUD and post-processing (`/rv/tmp/cs-samples/games-racing-race/`, windowed 1024x768 from a seeded `RacingGameSettings.xml`; full-screen menu `games-racing-fullscreen-menu/`). Start it from `bin/Release`: XNA's `AudioEngine` resolves its `Content\Audio` path against the working directory |
| Network Prediction | Microsoft's XNA 4.0 sample (cna-samples SAMPLE-100 `xna4-original`, no C++ port) | XNA 4.0's own build, SAMPLE-100 `xna4-build/Content` | (2026-10-02) signs in through CNA's Guide, creates a SystemLink session on A and drives its tank with the arrows; the HUD shows the simulated latency, packet loss, prediction and smoothing it toggles. Two processes on private displays: a second one finds the host's session on B and joins, and sees both tanks, the host's labelled with its gamertag; the options read as the host's, not its own (`/rv/tmp/cs-samples/systemlink-np/`) |
| Peer to Peer | Microsoft's XNA 4.0 sample (SAMPLE-103, no C++ port) | XNA 4.0's own build, SAMPLE-103 `xna4-build/bin/Content` | (2026-10-02) the same: sign-in, a SystemLink session, a tank that drives. Two processes: the host shows "host (host)" and "guest" side by side; when the host's process ends, the guest's shows XNA's "HostEndedSession" and its menu again (`/rv/tmp/cs-samples/systemlink-p2p/`) |
| Network Game State Management | Microsoft's XNA 4.0 sample (SAMPLE-075, no C++ port) | XNA 4.0's own build, SAMPLE-075 `xna4-build/windows-reach/Content` | (2026-10-02) main menu, then Single Player through its loading screen to the gameplay screen. Its menu strings are a `.resx`, now embedded as its build did (the games glue reads `EmbeddedResource`); its loading screen joins the thread that draws the loading animation, which froze until CNA CBIND-152 / CNA.NET CSX-118 |
| Memory Madness | the Windows Phone game of Microsoft's XNA 4.0 hands-on lab, exercise 2 (SAMPLE-097, no C++ port) | XNA 4.0's own Windows Phone build, SAMPLE-097 `xna4-build/Content-ex2-phone` | (2026-10-02) 480x800 title; a tap on START begins a round |
| Saving Embedded Images | Microsoft's XNA 4.0 Windows Phone sample (SAMPLE-106, no C++ port) | XNA 4.0's own build, SAMPLE-106 `win7-export/Content` | (2026-10-02) both images, one opened through `TitleContainer` (the games glue now copies the files its project copied beside it); a tap asks for a name in the Guide's keyboard prompt and saves the picture to `Pictures/Saved Pictures`, or shows its own "Unable to save image." without a picture folder (CNA.NET CSX-119) |
| Quadtree Terrain | `github.com/george7378/quadtree-terrain` @ `9feedb9` | the XNA build output its repository ships (`bin/x86/Debug/Content`, all 7 items, its terrain and water effects) | (2026-10-02) the terrain with distance fog and lakes that reflect the hills (its water effect renders a reflection target); C attaches the mouse, which steers through `Mouse.SetPosition`/`GetState` as its author's README says, and WASD flies -- as in the author's screenshots, from another viewpoint |
| FightingGame | `github.com/Gang-Gang/FinalProject` @ `e1bc541` (a student fighting game) | the XNA build output its repository ships | (2026-10-02) its two health bars, which drain from green through yellow and are gone after about 8 s, as its code does; nothing else is drawn yet in its source |
| Some 2D RPG | `github.com/MichaelAquilina/Some-2D-RPG` @ its checkout, with its own engine library (`games/Some2DRPG/Engine`) | built from its own content project by XNA's BuildContent (Windows/HiDef): 144 of 145 items; `SpeechFont` needs Lucida Console, a Windows font its repository does not ship | (2026-10-02) a Tiled map, the hero and his party with red hitbox overlays (its `.draw` files leave the HitBox layer visible, so XNA would draw them too; the 2018 screenshots in its repository predate them), the debug readout at 60 fps; arrows walk, F3 turns on its light shader (night, a light around the hero) |
| SKraft | `github.com/Kermit/SKraft` @ `2480755` (a student block-world game, 2012) | built from its own content project, with its own `SKraftPipeline` model processor, by XNA's BuildContent (Windows/Reach): all 27 items | (2026-10-02, after CNA CBIND-153 and CNA.NET CSX-121: its constructor calls `ApplyChanges` and reads `GraphicsDevice.Viewport`) its menu; Start draws its world as instanced cubes through its own shader (3,721 grass cubes in view), the mouse looks and W walks, its sun dims the sky and the grass on its timer, and Quit saves the nine sectors and exits 0. The world is read from `<working directory>\Maps\Test\TestXY.sec`, a Windows path, and its repository keeps it outside the game's project (`Models/Maps/Test`), so a fresh build has none on Windows either and the player falls through an empty sky; for the run the nine files were copied (not linked: the game rewrites them on exit) to the one name Linux reads, `w\Maps\Test\TestXY.sec` beside the working directory `w` (`/rv/tmp/cs-samples/skraft/`) |
| Forge sample | `github.com/jacobdufault/forge-sample` @ `6b18d3f` (the XNA 4.0 sample game of the Forge entity engine), with its `GameLogic` library (`games/ForgeSample/GameLogic`) and its prebuilt Forge, Lidgren, log4net and Json.NET 5 libraries | none: it draws with a 1x1 texture it makes | (2026-10-02, after CNA.NET CSX-122) its two paddles and the balls they collect, the engine at 15 updates a second over its own local Lidgren server. It loads `GameLogic.dll` with `Assembly.LoadFile` from its working directory, and `../../../../../Assets` -- Visual Studio's `bin\x86\Debug`, which is also its own directory -- so the run copies its output five levels below a copy of `Assets` (`/rv/tmp/cs-samples/forge/`); before CSX-122, .NET's second copy of `GameLogic` left its renderers unmatched and it drew nothing. log4net and Json.NET 5 need `System.Configuration.ConfigurationManager` and `System.Security.Permissions`, .NET Framework assemblies that are packages on .NET |

In a browser and on Android: `scripts/browser-sample.sh games/<Game>` (headless Chromium, WebGL2
through SwiftShader) and `scripts/android-sample.sh games/<Game>` (the x86_64 emulator) build each game
from the same project and content. The first 16 were measured on CNA `ffb82bc0d`: in a browser 14
reach their title or play -- HeliumBiker starts a thread, which single-threaded WebAssembly cannot,
and Playing in Traffic plays a video, which the browser build has no backend for -- and on Android 15
run (Playing in Traffic stops at the same honest refusal of its video). Resonance loads its levels on
a thread, so in a browser only its menu. The nine added since were measured on CNA `3c72165e6`
(2026-10-02): in a browser Missile Command, __Defense, Super Mario World, the Zelda clone, Bubble
Bound (after CNA CBIND-149/150: WebGL 2 has neither the multisample mask nor texture swizzles),
Spineless and Mahjong (after the generators carried its NuGet package) reach their title or menu;
Escape From Enceladus and the Racing Game Kit start threads (`new Thread(...).Start()`), which a
single-threaded bundle refuses with `PlatformNotSupportedException`, as it does HeliumBiker's. On
Android all nine run -- titles and menus, Enceladus's save slots, the Racing Game Kit's attract mode
-- so 24 of the 25 run on the emulator.

A game that starts threads runs in a browser as a multithreaded bundle:
`scripts/browser-sample.sh games/<Game> --threads` (CNA.NET CSX-115/116/117, CNA CBIND-151, CNA
`cde2251fa`, 2026-10-02; `/rv/tmp/cs-samples/browser-threads/<Game>/`). Escape From Enceladus reaches
its three save slots, read from IndexedDB; HeliumBiker its CONNECT screen, as on the desktop;
Resonance loads its level on its thread -- 32 physics threads on a 16-core host -- and plays the
arena; the Racing Game Kit runs its attract mode at about 0.65 fps under SwiftShader, because a
worker's WebGL calls are proxied to the page's thread, and at that rate its menus, which test a
press while drawing, never see one (XNA's fixed-step catch-up runs several updates per draw);
Missile Command, threaded too, starts a game on Space. So 24 of the 25 run in a browser as well,
all but Playing in Traffic's video (`/rv/tmp/cs-samples/{browser,android}/<Game>/`).
The five Microsoft samples added last reach their first screen in a browser and on the Android
emulator too (CNA `fb89c451a` archives, 2026-10-02). In a browser Memory Madness starts a round and
Saving Embedded Images opens its keyboard prompt, but its blocking `Guide.EndShowMessageBox` right
after `Begin` cannot wait in a single-threaded page (CNA refuses: no frame can run inside the
wait). Network Game State Management's Single Player stops on "Loading.." in a threaded bundle and
on Android: both run .NET on Mono, whose `Thread.Join` does not consult the
SynchronizationContext that CSX-118 relies on (CoreCLR's does), so the game thread never runs its
loading thread's drawing. The Level Starter Kit (cna-samples SAMPLE-128) is a Silverlight Windows
Phone app, not an XNA game.

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
sample rate XNA's own encoder wrote (CNA CBIND-146), and a window's desktop position and the
mouse beside it (CNA CBIND-147, CBIND-148).

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

- **Zelda Oracle** (`trigger-segfault/ZeldaOracle` @ `92be3a1`; its tip `85275f5` adds a
  `VarType.cs` that compiles nowhere): compiles unchanged (branch `zelda-oracle`, with CNA.NET's
  branch `zelda-oracle-forms` for the Windows Forms its form uses) and stops in `Initialize` at its
  `EventInput` text hook, which subclasses the window procedure through `user32`'s `SetWindowLong`
  with the delegate's address cast to `int` -- an x86 Windows process only.
- **AutonomousCar** (`AutonomousCar`): the same `EventInput` hook, from its game console created
  at startup, and its `C5.dll` and `Newtonsoft.Json.dll` hint paths point outside the repository.
- **Pokémon Azure** (`Pokemon Azure/PokeEngine`): references `lua51.dll` and `LuaInterface.dll`,
  which the repository does not ship, and starts Lua for every game, battle and cutscene.
- **Voxeliq** (`bonesoul/voxeliq` @ `249b1d0`, its XNA 4.0 client under
  `contrib/old-codebase`): its content project builds but for its three sprite fonts, which name
  Calibri, a Windows font neither its repository nor Game Studio ships; no built content is shipped.
- **Old School Adventure** (`Source/OldSchoolAdventure`): its projects are MonoGame's now
  (`net8.0-windows`, MonoGame.Framework.WindowsDX); only its types library is still XNA 4.0.

Not XNA 4.0, so not here: the BitSits games (`Squares-Vs-Triangles`, `Moolecule`, `RainingLetters`,
`Apple-e-Apple`, `Treasure-Island`) are XNA 3.1 projects with 3.1 content, and so are AngryTanks,
Flotilla (its 4.0 line is an FNA port, and its art is commercial) and XNA Street Fighter;
Infiniminer is XNA 3.0.

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
