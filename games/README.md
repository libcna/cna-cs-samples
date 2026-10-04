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
| Resonance | `github.com/lordcodes/resonance-game` @ `b591114` | built: 282 assets with its own pipeline extension, XACT banks by XactBld3; its 4 songs are labelled stand-ins (`--song-standins`) | loads its level on its own thread, then plays: the arena, the Bad Vibes, the HUD; physics from the BEPUphysics binary it ships (its x86 build, as its Windows project references it, since CNA.NET CSX-134 realigns its 32-bit layout); the menu's music |
| Escape From Enceladus | `github.com/zachmu/escape-from-enceladus` @ `337b3bb`, with the Farseer Physics 3.3.1 and DebugView it redistributes and its Json.NET 4.5 binary | built: its content project (558 `.xnb`, 3 effects, XACT with a streaming song bank, its November font) and DebugView's; its four music tracks are not in its repository, so the song bank holds labelled 5 s silent stand-ins | (2026-10-02, CNA `46231e857`, CNA.NET `b4bedce`) title with its three save slots read at once; Space (its keyboard scheme), Enter: its first room plays, the player runs right |
| __Defense | `github.com/gamealgorithms/defense` @ `3b456a6` (the tower-defense sample of Sanjay Madhav's *Game Programming Algorithms and Techniques*) | built: its XNA project's `XNAContent.contentproj` (54 `.xnb`, 3 bloom effects, Game Studio's Quartz MS and Segoe UI Mono fonts) -- the `Content/` it ships beside it belongs to its MonoGame project | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) full screen at the desktop's mode, as it asks: its menu, then START!!: the hex field with its bloom, the base and wave 1 under way |
| Missile Command | `github.com/the-saif-ahmad/MissileCommand` @ `c6a4ff7` (a remake of Atari's) | built: its content project (28 `.xnb`: 20 textures, 7 sounds, Game Studio's Quartz MS font) | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) full screen: its title, then Space: the terrain, six cities and three silos under the mouse's crosshair; nothing needed changing |
| Super Mario World (Sprint 4) | `github.com/buttsj/c-sharp-mario` @ `f2fee21` (a student team's demo) | built: its content project (181 `.xnb`); its eight MP3 songs labelled stand-ins (`--song-standins`, then `convert-xna-songs.sh`), five documentation images its repository lacks listed, not built | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) title menu; Space: level 1 -- Mario runs right, HUD with lives, time and coins; nothing needed changing |
| The Legend of Zelda (clone attempt) | `github.com/edgiardina/Zelda` @ `d2dd348` | built: the content project its game project references, `Zelda.Content` (26 `.xnb`), into the `Zelda.Content` root it loads from | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) title, its fade into the save menu, then Up (to Register) and Enter: its first screen -- the life bar, water and an enemy; nothing needed changing. Not compared with XNA: the repository ships no XNA build |
| Bubble Bound | `github.com/zfedoran/bubblebound` @ `8171890`, with the SkinnedModel library it carries | built: its content project (47 `.xnb`: 7 FBX models, 8 effects) with its SkinnedModel runtime and its skinned- and instanced-model pipeline extensions, and its level XML | (2026-10-02, CNA `22b30b30e`, CNA.NET `1326161`) title over its dimmed 3D scene; Enter: the bubble drifts through the lit undersea landscape among particles, as its own screenshot looks; nothing needed changing |
| Spineless (Global Game Jam 2013) | `github.com/gnomicstudios/GGJ13` @ `ae0934b`, with its Gnomic engine and animation libraries and the Farseer Physics it carries | built: its content project (20 `.xnb`: 10 sounds, 2 fonts, 8 clip animations) with Farseer, Gnomic.Anim and Gnomic as pipeline extensions in that order, its 13 sprite sheets copied as its project copies them | (2026-10-02, CNA `51d9c84cc`, CNA.NET `1326161`) the siege tower with the princess and the heart meter; Right: the landscape scrolls, the enemies march on the tower and its knight steps out, the heart rises to 10%. Its sounds are XNA's own ADPCM, three at rates above 48000 Hz (up to 48084), which needed CNA CBIND-146; CodeDom, which its engine names and never calls, comes from its .NET package |
| Mahjong (XNA client) | `github.com/Jomata/Mahjong` @ `bc81398` (MIT; tile art by Martin Persson), with its Logic library | built: its content project (161 `.xnb`: 153 tile images, its fonts in Courier New and Game Studio's Quartz MS and Segoe UI Mono) | (2026-10-02, CNA `6e273cd89`, CNA.NET `1326161`) its menu over the table; a click on Play Mahjong deals against three computer players: its hand with the recommended discards highlighted and the dora indicator. Its options live in its `App.config`, read through ConfigurationManager from its .NET package. Its menu hit-tests the mouse, which found CNA CBIND-147 and CBIND-148 |
| XNA 4.0 Racing Game Kit | `/rv/tmp/XNAGameStudio/Samples/XNA-4-Racing-Game-Kit-master` (exDream's RacingGame brought to XNA 4.0; identical to cna-samples SAMPLE-152 `xna4-original`) | its own `RacingGameContent.contentproj` built by XNA 4.0's pipeline on Windows: SAMPLE-152 `evidence/xna4-authentic-build/Debug/Content` (339 `.xnb`, XACT banks, tracks) | (2026-10-02, CNA `fb5cb3ba2`, CNA.NET `ff08b93`) loads for about 40 s, switches to full screen as its settings ask, and runs its attract mode: the camera flies the track through the city and the mountains with the car, shadows and its "Press START to continue" -- no render-loop error in its own log. Needed CNA.NET CSX-113 (`models\Cube` for `Models/Cube.xnb`), CSX-114 (its Windows Forms: `Form.FromHandle`, `MessageBox`; opt-in `<CnaWindowsFormsCompat>`) and CNA FX-142 (a ps_1_x colour input linked as centroid on GLSL ES). Then plays: Space (held 2-3 s -- a frame takes longer than a quick tap under llvmpipe, so a short press falls between two polls; the same in full screen and windowed) opens its main menu, and three more Space presses and the up arrow take it into a race on the Advanced track -- lap 1/3, 62 MPH in 2nd gear, its HUD and post-processing (`/rv/tmp/cs-samples/games-racing-race/`, windowed 1024x768 from a seeded `RacingGameSettings.xml`; full-screen menu `games-racing-fullscreen-menu/`). Start it from `bin/Release`: XNA's `AudioEngine` resolves its `Content\Audio` path against the working directory. (2026-10-04, CSX-149, CNA `16dce8d5a`, CNA.NET `55ecb16`) a fresh zero-warning build again ran unchanged through attract, menus and an Advanced-track race at 1024x768; the retained C++ port over CNA OPENGL33 ran the same six stages with the same content and rendering structure. The authentic XNA executable cannot supply a Wine frame: after its authentic `XnaLiveProxy.exe` is present, the defunct Games for Windows - LIVE service still fails initialization, as Microsoft's RolePlayingGame independently records. No source was patched and no general CNA defect was found; evidence is in `/rv/tmp/cs-samples/final-racing-differential-20261004/` |
| Network Prediction | Microsoft's XNA 4.0 sample (cna-samples SAMPLE-100 `xna4-original`, no C++ port) | XNA 4.0's own build, SAMPLE-100 `xna4-build/Content` | (2026-10-02) signs in through CNA's Guide, creates a SystemLink session on A and drives its tank with the arrows; the HUD shows the simulated latency, packet loss, prediction and smoothing it toggles. Two processes on private displays: a second one finds the host's session on B and joins, and sees both tanks, the host's labelled with its gamertag; the options read as the host's, not its own (`/rv/tmp/cs-samples/systemlink-np/`) |
| Peer to Peer | Microsoft's XNA 4.0 sample (SAMPLE-103, no C++ port) | XNA 4.0's own build, SAMPLE-103 `xna4-build/bin/Content` | (2026-10-02) the same: sign-in, a SystemLink session, a tank that drives. Two processes: the host shows "host (host)" and "guest" side by side; when the host's process ends, the guest's shows XNA's "HostEndedSession" and its menu again (`/rv/tmp/cs-samples/systemlink-p2p/`) |
| Network Game State Management | Microsoft's XNA 4.0 sample (SAMPLE-075, no C++ port) | XNA 4.0's own build, SAMPLE-075 `xna4-build/windows-reach/Content` | (2026-10-02) main menu, then Single Player through its loading screen to the gameplay screen. Its menu strings are a `.resx`, now embedded as its build did (the games glue reads `EmbeddedResource`); its loading screen joins the thread that draws the loading animation, which froze until CNA CBIND-152 / CNA.NET CSX-118 |
| Memory Madness | the Windows Phone game of Microsoft's XNA 4.0 hands-on lab, exercise 2 (SAMPLE-097, no C++ port) | XNA 4.0's own Windows Phone build, SAMPLE-097 `xna4-build/Content-ex2-phone` | (2026-10-03, played by the owner) 480x800 title; START shows its instructions and then a round: the sections light up and are repeated by tap. Its gameplay screen reads its levels through the BCL, `XDocument.Load(@"Content\Gameplay\LevelDefinitions.xml")`, which only Windows splits at the backslashes, so its glue links that name (`CnaWindowsPath`). The 2026-10-02 record of a round was the instructions screen: the round itself failed to load until then |
| Saving Embedded Images | Microsoft's XNA 4.0 Windows Phone sample (SAMPLE-106, no C++ port) | XNA 4.0's own build, SAMPLE-106 `win7-export/Content` | (2026-10-02) both images, one opened through `TitleContainer` (the games glue now copies the files its project copied beside it); a tap asks for a name in the Guide's keyboard prompt and saves the picture to `Pictures/Saved Pictures`, or shows its own "Unable to save image." without a picture folder (CNA.NET CSX-119) |
| Quadtree Terrain | `github.com/george7378/quadtree-terrain` @ `9feedb9` | the XNA build output its repository ships (`bin/x86/Debug/Content`, all 7 items, its terrain and water effects) | (2026-10-02) the terrain with distance fog and lakes that reflect the hills (its water effect renders a reflection target); C attaches the mouse, which steers through `Mouse.SetPosition`/`GetState` as its author's README says, and WASD flies -- as in the author's screenshots, from another viewpoint |
| FightingGame | `github.com/Gang-Gang/FinalProject` @ `e1bc541` (a student fighting game) | the XNA build output its repository ships | (2026-10-02) its two health bars, which drain from green through yellow and are gone after about 8 s, as its code does; nothing else is drawn yet in its source |
| Some 2D RPG | `github.com/MichaelAquilina/Some-2D-RPG` @ its checkout, with its own engine library (`games/Some2DRPG/Engine`) | built from its own content project by XNA's BuildContent (Windows/HiDef): 144 of 145 items; `SpeechFont` needs Lucida Console, a Windows font its repository does not ship | (2026-10-02) a Tiled map, the hero and his party with red hitbox overlays (its `.draw` files leave the HitBox layer visible, so XNA would draw them too; the 2018 screenshots in its repository predate them), the debug readout at 60 fps; arrows walk, F3 turns on its light shader (night, a light around the hero) |
| SKraft | `github.com/Kermit/SKraft` @ `2480755` (a student block-world game, 2012) | built from its own content project, with its own `SKraftPipeline` model processor, by XNA's BuildContent (Windows/Reach): all 27 items | (2026-10-02, after CNA CBIND-153 and CNA.NET CSX-121: its constructor calls `ApplyChanges` and reads `GraphicsDevice.Viewport`) its menu; Start draws its world as instanced cubes through its own shader (3,721 grass cubes in view), the mouse looks and W walks, its sun dims the sky and the grass on its timer, and Quit saves the nine sectors and exits 0. The world is read from `<working directory>\Maps\Test\TestXY.sec`, a Windows path, and its repository keeps it outside the game's project (`Models/Maps/Test`), so a fresh build has none on Windows either and the player falls through an empty sky; for the run the nine files were copied (not linked: the game rewrites them on exit) to the one name Linux reads, `w\Maps\Test\TestXY.sec` beside the working directory `w` (`/rv/tmp/cs-samples/skraft/`) |
| Forge sample | `github.com/jacobdufault/forge-sample` @ `6b18d3f` (the XNA 4.0 sample game of the Forge entity engine), with its `GameLogic` library (`games/ForgeSample/GameLogic`) and its prebuilt Forge, Lidgren, log4net and Json.NET 5 libraries | none: it draws with a 1x1 texture it makes | (2026-10-02, after CNA.NET CSX-122) its two paddles and the balls they collect, the engine at 15 updates a second over its own local Lidgren server. It loads `GameLogic.dll` with `Assembly.LoadFile` from its working directory, and `../../../../../Assets` -- Visual Studio's `bin\x86\Debug`, which is also its own directory -- so the run copies its output five levels below a copy of `Assets` (`/rv/tmp/cs-samples/forge/`); before CSX-122, .NET's second copy of `GameLogic` left its renderers unmatched and it drew nothing. log4net and Json.NET 5 need `System.Configuration.ConfigurationManager` and `System.Security.Permissions`, .NET Framework assemblies that are packages on .NET |
| Sonic 3 | `github.com/JonathanDechelle/Sonic3` @ `80add97`, its 2014 state with its `MyGameLibrairy` library (`games/Sonic3/MyGameLibrairy`); the 2017 commits after it refactor its menus and stop short of a level (the tip's main menu never starts one) | built from its own content project by XNA's BuildContent (Windows/HiDef): 149 items, its seven MP3 songs as labelled stand-ins | (2026-10-02) the SEGA splash, the title, and Enter twice into Angel Island Act 1: Sonic runs (arrows), spin-jumps (Space) and collects rings, with its parallax and HUD. No defect found; CNA logs one heuristic warning that a sound's PCM looks compressed, though every sound XNA built is PCM16 |
| HauntedHouse | `github.com/callumlawson/Projects` @ `2433240`, its HauntedHouse prototype with the Farseer Physics 3.3.1, Krypton and TiledLib copies it ships (`games/HauntedHouse/{Farseer,Krypton,TiledLib}`) and its prebuilt `C3.XNA.Primitives2D.dll` (CSX-099) | the XNA build output its repository ships (`HauntedHouse/bin/x86/Debug/Content`: its Tiled level, sprites, font and the `KryptonEffect` built from Krypton's content project) | (2026-10-02) a dark house lit by Krypton's 2D lights -- chandelier cones and the player's flashlight casting shadows from the furniture -- on its Tiled map; arrows walk the player off the stairs and the camera follows. TiledLib compiles its importer's content types into the game, so Game Studio's `Microsoft.Xna.Framework.Content.Pipeline.dll` is a compile-time reference only, as on the developer's machine (XNA's runtime never had it); its importer's `System.Drawing` is .NET's package, never called |
| Disentanglement | `github.com/dsplaisted/Disentanglement` @ `b58fb71`, its XNA 4.0 Windows visualizer with its portable solver library (`games/Disentanglement/PuzzleSolver`) | none: it draws with BasicEffect; the content project it references is not in its repository and nothing loads from it | (2026-10-02, after CNA.NET CSX-123: it reads `Keyboard.GetState()` in a field initializer, before any game exists) the solver works its embedded Gordian-knot puzzle ("Moves: 2") and the pieces turn in 3D under the arrows. Its puzzle is an embedded text resource, `PuzzleSolver.GordionCube.txt`, which the glue now embeds under that name |
| NeonVectorShooter | `github.com/thiagoromam/game-development` @ `1815080`, its NeonVectorShooter (the Shape Blaster tutorial game) | built from its own content project by XNA's BuildContent (Windows/Reach): 32 items, its bloom effects included; its MP3 music as a labelled stand-in | (2026-10-03) a twin-stick shooter in glowing vectors: WASD flies, the mouse aims and fires, enemies burst into bloom-lit particles, lives and score on the HUD. No defect found |
| Blackjack | `github.com/stpettersens/21` @ `72045c5`, its XNA 4.0 BlackjackXNA | the XNA build output its repository ships (`bin/x86/Debug/Content`, all 60 items: its sprite fonts name Verdana, which only that build could make) | (2026-10-03, after CNA CBIND-154 and CNA.NET CSX-124) the dealer shuffles on a thread of its own, which plays the shuffle sound while the game thread spins on it, then deals; H hits, S stands, and a bust ends in "DEALER WINS". Before CBIND-154 that sound was queued for the spinning game thread and the game never drew a frame |
| PhreeCell | Charles Petzold's FreeCell from *Programming Windows Phone 7* (chapter 23), in `github.com/coderserdar/WindowsPhoneSamples` @ its checkout; a Windows Phone title hosted through `CnaPhoneGame` | built from its own content project by XNA's BuildContent (WindowsPhone/Reach): its card sheet and Pericles font | (2026-10-03, after CNA CBIND-155 and CNA.NET CSX-125) it deals and sizes its table in `OnActivated` from the viewport, which CNA refused there until then (and the binding swallowed the failure, so it ran and drew nothing); now it deals the eight piles, and a mouse drag moves a card into a free cell, as a finger did |
| asvo | `github.com/denniskb/asvo` @ `cdef2db`, its XNA 4.0 prototype (`prototype/asvo`, an animated sparse-voxel-octree renderer from a bachelor's thesis) with the XNAnimation library it ships (`games/Asvo/XNAnimation`) | built from its own content project with its XNAnimation pipeline by XNA's BuildContent (Windows/HiDef): its shader and the 19 MB skinned FBX of Imrod walking | (2026-10-03) the walking giant voxelized and drawn in software on its six worker threads, then shown through its shader. No defect found. Its pipeline needed two things of `scripts/build-xna-content.sh`: extensions signed with their project's key (XNAnimation grants its internals to a signed XNAnimationPipeline) and their `.resx` embedded |
| XNA Shader Programming | `github.com/petriw/XNA-Shader-Programming` @ `993937a`: its seven XNA 4.0 tutorials (`games/XnaShaderProgramming/*`; Tutorials 1-24 are XNA 3.0) | each built from its own content project by XNA's BuildContent (Reach, or HiDef for the two noise tutorials), its compressed `.X` models included | (2026-10-03) ambient, diffuse and specular lighting on its model, the deformed sphere, the ocean shader around a palm-tree island, Perlin noise generated on the GPU (vs/ps 3.0) and the bump-mapped noise creature, each as its tutorial describes; Tutorial 25 asks for full screen, which a private X server declines, and runs in a window. No defect found |
| 2D Graphics Programming for Games | `github.com/alaskajohn/2dGPfG` @ `f7c6a6b`: the book's fourteen XNA 4.0 samples (`games/2dGPfG/*`) | built once from its shared content project by XNA's BuildContent (Windows/Reach) | (2026-10-03) sprites, sinusoidal motion, the quilt pattern, run cycles and easing, a zooming camera over tiles, foreground and eye-level parallax, keyboard-triggered particle effects, a colour gradient, and pixel modification on the CPU and as a GPU blur, each as its chapter describes. No defect found (SimpleTiles's dark map is XNA's own premultiplied content: the PNG's transparent red pixels read back as transparent black, plains) |
| Project Mercury | `github.com/Andrea/MercuryParticleEngine` @ `3233594`, its XNA 4.0 branch's test bench (`Branches/4.0`) with the engine it ships (`games/MercuryTestBench/ProjectMercury`, compiled `WINDOWS;UNSAFE` as its Windows project is) | built from its own content project with Mercury's pipeline extension by XNA's BuildContent (Windows/HiDef): its font, star texture and `Demo1`, a particle effect XNA's reflective writer serialized | (2026-10-03, after CNA.NET CSX-126..128) Demo1's three proxy effects orbit, billboarded three ways, read from that reflective `.xnb`. It needed three repairs of .NET against .NET Framework: its own `ProjectMercury.Range` lost to `System.Range` (CSX-126), its frame rate on a frame of no elapsed time printed `∞`, a character its font lacks (CSX-128), and that failure surfaced at `End` instead of the `DrawString` that caused it (CSX-127). PageDown's Demo2 releases 60 particles per update into a renderer sized for 2500 and ends with `elementCount` exceeding its own 10000-vertex array, as XNA's `SetData` check would end it (`ValidateCopyParameters`); the content script now passes an extension's `DefineConstants` (Mercury's pipeline code is `#if WINDOWS`) |
| Xen starter kits | `github.com/raphaelmun/Xen` @ `779157b`, its Platformer and twin-stick shooter starter kits on the Xen2D, XenAspects and XenGameBase libraries it ships (`games/Xen/*`) | each built from its own content project by XNA's BuildContent (Platformer Windows/HiDef, shooter Windows/Reach); the Platformer's sounds and song are `.wma` files byte-identical to Microsoft's Platformer starter kit's, so they are that kit's retained XNA build output (`--official`, the song's `.ogg` from `convert-xna-songs.sh`). XenGameBase's own font is the `Arial.xnb` its repository ships, embedded through its `.resx` | (2026-10-03, after CNA.NET CSX-129) the game base loads that font through a `ResourceContentManager`, which CNA.NET bypassed for built-in types until then. The Platformer's adventurer runs on D, jumps on Space and takes a gem; the shooter thrusts on W and fires its laser from a right-click origin toward a left click |
| Asteria demos | `github.com/Bryan-Legend/asteria` @ `11334ae`: its lighting prototype (`AsteriaLighting`) and its blend-effect demo (`Assets/BlendEffectDemo`), from the shared source of the Steam game (`games/Asteria/*`) | each built from its own content project by XNA's BuildContent (Windows/HiDef): their `.fx` effects and textures | (2026-10-03, after CNA.NET CSX-130) the lighting prototype's shadowed spot light, moved by WASD, matches an XNA build of it under Wine to 2 of 300,000 pixels around the light. The blend demo draws its three mouse-following clouds through its effect, one in the night texture, one in the day texture and one pulsing between, as the XNA build does; CNA.NET drew all three with the last cloud's parameters until its Immediate batch drew each sprite when given (CSX-130). The reference builds: the game's own sources compiled by .NET Framework's `csc` under Wine against Game Studio's assemblies, with the HiDef profile resource XNA's build embeds |
| FluidPort | `github.com/klutch/Box2DFluid` @ `9c73cbb`, `FluidPort`: an XNA 4.0 port of a Box2D fluid simulation on Farseer Physics 3.3.1 | built from its own content project by XNA's BuildContent (Windows/Reach): its two fonts | (2026-10-03) a held mouse button pours particles that slosh around its Farseer tank. No defect found. Its `FarseerPhysicsXNA.dll` reference points outside its repository, at a build of Farseer Physics Engine 3.3.1's XNA samples; the same library is built here from the Farseer 3.3.1 XNA source HauntedHouse's repository ships |
| XPF samples | `github.com/redbadger/XPF` @ `a5bb898`: Red Badger's XPF, a WPF-style layout and binding framework for XNA, built from its source for Windows and for Windows Phone (`games/Xpf/RedBadger.Xpf*`, with the Rx assemblies its `packages` folder ships; the phone build takes their .NET 4 flavour), its Windows sample S01 and its phone samples S02 (orientation), S03 (application bar) and S05 (data binding), the phone ones hosted through `CnaPhoneGame` | built from their own content projects by XNA's BuildContent (S01 Windows/HiDef, the others WindowsPhone/Reach) | (2026-10-03) S01's 400x420 grid of score bar, play area and lives bar; S02 the same in landscape; S03 its page title over an application bar; in S05 a tap turns its card face up through a binding and Reset turns it back. No defect found. S04's scoreboard needs Gill Sans Ultra Bold |
| Alone | `github.com/zachrburke/ludum-dare22` @ `0fa9587`, `ld_alone`, a Ludum Dare 22 entry | the XNA build output its repository ships (`bin/x86/Debug/Content`), and the `levels2` maps it reads from its working directory, from the same output (its project lists them as Content without copying them) | (2026-10-03) its 512x512 desert map; the adventurer walks on WASD. No defect found |
| Zombie Run | `github.com/scottrehlander/ZombieRunXNA` @ `27186a5`, `FrunWithXNA2`: its Windows copy of the phone project, the one with rockets and flying seekers | the XNA build output its repository ships (`bin/x86/Debug/Content`) | (2026-10-03) its menu, then Return starts the level with its timer and zombie count. No defect found. Its project names `NPCManager.cs` for the file `NpcManager.cs`, which Windows' file system did not mind; the glue resolves names case-insensitively |
| Shootin | `github.com/mtio/GoingToTheStars` @ `1a1d526`, `Shootin`, a gravity shooter | the XNA build output its repository ships (`bin/x86/Debug/Content`) | (2026-10-03) its starfield and ship; the arrow keys start it and its fuel count runs. No defect found |
| Square Chase | `github.com/nethojs29/SquareChase` @ `0493795`, the Square Chase game of XNA's tutorials | the XNA build output its repository ships | (2026-10-03) the square jumps about its grey field as it is clicked. No defect found |
| Reflexio | `github.com/ajl275/Reflexio` @ `4b57ec0`, a puzzle platformer of reflections, on the Farseer Physics 3.3.1 copy it ships beside its game (`games/Reflexio/*`; its project names that copy one directory too high) | built from its own content project by XNA's BuildContent (Windows/HiDef), Comic Sans MS and Courier New from the core fonts | (2026-10-03) its menu, then Start opens the first level and the koala walks. Its repository does not ship the `Properties/AssemblyInfo.cs` its project lists (assembly attributes only), so it is compiled without it; it reads its levels through `XmlReader` at Windows paths (`"Content\\Levels\\" + name`), linked beside the game for each level file (`CnaWindowsPath`). The level's hint box is empty because its own `DrawString` is commented out. No defect found |
| Risk of Pain | `github.com/nanexcool/RiskOfPain` @ `836a43a`, a small prototype | built from its own content project by XNA's BuildContent (Windows/Reach) | (2026-10-03) its checkered arena with its two squares. No defect found |
| AlexMeuer's 3D course projects | `github.com/AlexMeuer/3D-Graphics-and-Audio` @ `d51abbe`: City Shooter (`FPS_Assessment`), the 3D solar system and the flying ship (`games/AlexMeuer3D/*`) | each built from its own content project by XNA's BuildContent (Windows/Reach): FBX models and their textures | (2026-10-03, after CNA.NET CSX-133) City Shooter's city of textured buildings with its tank, the planets in orbit, the ship over its starfield. City Shooter loads `building1`, `building2`, ... until the missing one throws `ContentLoadException`, which CNA.NET threw as `CnaException` for a texture until then |
| Thieves Like Us | `github.com/mdlawson/ThievesLikeUs` @ `e74dc34`, a prototype on the Farseer and Krypton copies it ships under `Vendor/` (`games/ThievesLikeUs/*`; its references name their builds under `Vendor/*/bin`, which it does not ship) | built from its own content project by XNA's BuildContent (Windows/Reach) with its TiledLib and ThievesLikeUsPipeline extensions: its Tiled map | (2026-10-03) its map's collision outline; identical, 0 of 384,000 pixels, to an XNA build of the same sources under Wine. Its input is the gamepad's only. No defect found |
| Flight Sim | `github.com/wontonst/flightsim` @ `a781a40`, a USC ITP 380 flight game, on the Henge3D physics and Microsoft's Particle 3D sample it ships (`games/FlightSim/*`) | built from its three content projects by XNA's BuildContent (Windows/HiDef) with its Henge3D pipeline and OBJ importer extensions (its prebuilt `Content/` served its Mono and Mac builds) | (2026-10-03) its menu over its jets, START and TUTORIAL by mouse, then the jet on its runway over the ocean with its HUD and radar, taking off on thrust. No defect found. Its process outlives its window: Henge3D starts one foreground worker thread per processor and the game never disposes them, which keeps any .NET process alive after `Main` returns -- XNA's on Windows as well |
| FunGame | `github.com/rpallarino3/Test2DGame` @ `13620e3`, `FunGame`, a top-down RPG prototype | the XNA build output its repository ships (196 assets) | (2026-10-03) its start screen saves a fixed starting game through XNA's `StorageDevice` on Delete and loads it on Home; the player then walks its first zone. No defect found |
| Super Luigi | `github.com/JohnP42/super-luigi` @ `6c851c4`, a Super Mario World-style platformer | the XNA build output its repository ships (`bin/x86/Debug/Content`, its three songs' `.wma` included), with an Ogg Vorbis copy beside each `.wma` | (2026-10-03) Luigi runs and jumps on the arrow keys and Space, and a Goomba takes his hearts. No defect found |
| Heroes of Rock | `github.com/scotttorgeson/HeroesOfRock` @ `2191748`, a rock-band brawler on the BEPUphysics, BEPUphysicsDrawer, EasyStorage and GameLib sources it ships (`games/HeroesOfRock/*`) | built from its own content project by XNA's BuildContent (Windows/HiDef) with its GameLib and Pipeline extensions and the two fonts it ships installed; its 66 sound effects are `.mp3` files XNA's Mp3Importer reads through Windows Media Format, so they are labelled stand-ins (`--sound-standins`, ffmpeg-decoded PCM in SoundEffectProcessor's layout) | (2026-10-03, after CNA.NET CSX-134) its title and main menu; its physics space builds (BEPUphysics' 32-bit layout realigned). Play then stops in its debug overlay's constructor: it reads Windows performance counters, which .NET implements only on Windows (`System.Diagnostics.PerformanceCounter`, `PlatformNotSupportedException`) |
| Pyramid Panic | `github.com/Kennyomg/PyramidPanic` @ `522cdf2`, a maze game after the Commodore 64 original | built from its own content project by XNA's BuildContent (Windows/HiDef) | (2026-10-03) its title menu, then Return starts the first maze with its explorer, scarabs and treasures. No defect found |
| Submarine Destroyer | `github.com/pwasilewski-pl/submariner-xna` @ `7bbab42`, a university game from 2012 | built from its own content project by XNA's BuildContent (Windows/HiDef) | (2026-10-03) its title, then a key starts the destroyer over its submarines. No defect found |
| Super Smash Polls | `github.com/WilliamKluge/SuperSmashPolls` @ `a010eab`, a fighting game on the 2016 US election, with the Farseer Physics 3.5 and DebugView it ships (`games/SuperSmashPolls/*`) | built from its own content project by XNA's BuildContent (Windows/Reach), with the 8-BIT WONDER font its repository ships installed | (2026-10-03, after CNA.NET CSX-131) its title menu in its pixel font; its input is the Xbox 360 gamepad's only, so it waits there, as on Windows without one. It did not compile before: an unused `using System.Runtime.Remoting.Messaging;` names a namespace .NET has no types in |
| Kittens & Kobolds | `github.com/LostCodeStudios/GGJ14` @ `1eeba21`, a Global Game Jam 2014 game on the GameLibrary its repository ships (`games/GGJ14/*`; the library's script runtime takes .NET's CodeDom package) | built from its own content project by XNA's BuildContent (Windows/Reach); its MP3 song, which XNA's importer reads through Windows Media Format, is a labelled stand-in | (2026-10-03) its menu over its forest, then Play starts the level with its WASD tutorial. No defect found |
| Windows Phone 7 Game Development | `github.com/Apress/win-phone-7-game-dev` @ `ab8fcf2`, Adam Dawes' book (Apress, 2010): nineteen of its XNA samples from chapters 3 to 10 (`games/Wp7GameDev/*`), hosted through `CnaPhoneGame`, each on its chapter's GameFramework | each built from its own content project by XNA's BuildContent (WindowsPhone/Reach); EnvironmentMap's cube map with the chapter's own CustomModelEffectPipeline extension | (2026-10-03, after CNA.NET CSX-132) the three stages of Cosmic Rocks, gestures, sound-effect instances, orientation, lighting, isometric cubes, chase camera, dual texture, environment map, fire and smoke, fog, sky box and the vapor-trail plane, the balloons game with its tombstoning, and the high-score table. Chapters 9 and 10 keep their settings in Windows Phone's `IsolatedStorageSettings`, which CNA.PhoneCompat gained for them. The Accelerometer sample starts the sensor without catching its failure, and the desktop has no accelerometer: CNA reports none, and `Start` throws `AccelerometerFailedException`, as the phone's did when the sensor could not start |
| Mario3 | `github.com/Zero-One101/Mario3` @ `57bb91a`, the start of a Super Mario Bros. 3 clone (one commit) | built from its own content project by XNA's BuildContent (Windows/Reach) | (2026-10-03) its 256x240 test room with its FPS counter: Mario, still a red block, runs on the arrow keys, jumps on X and stops at the column. No defect found |
| Spelunky Tiles | `github.com/Jewelots/Spelunky-Tiles` @ `fc5c7d4`, `SpelunkyTileTest`, Spelunky-style tiles cut from a boolean map, on its TileGenerator library (`games/SpelunkyTiles/*`) | built from its own content project by XNA's BuildContent (Windows/HiDef) | (2026-10-03) the left button places 64-pixel tiles, which it merges into rectangles with edge decals; the right button removes one, the middle button shows its rectangles. It draws nothing until a tile is placed. No defect found |
| Farseer Physics 3.5 samples | Farseer Physics Engine 3.5's own XNA samples, as `github.com/laie/RescueTheVisualStudio` @ `e5a6f60` ships them with the engine and its DebugView (`games/Farseer35Samples/*`) | built from the samples' and the DebugView's content projects by XNA's BuildContent (Windows/Reach) | (2026-10-03) the samples menu, then Stacked Objects: its pyramid of boxes settles under the agent at 60 fps. No defect found |
| Tile engine (part 9) | `github.com/google-code-export/the-lost-levels` @ `8a8a636`, `tileengineseries9`: the isometric tile-engine tutorial's ninth part | built from its own content project by XNA's BuildContent (Windows/Reach) | (2026-10-03) its isometric map with height tiles and slopes, and its character Vlad walking it on the arrow and keypad keys. Walking off the map's top-left edge throws `ArgumentOutOfRangeException` from its own `TileMap.GetCellAtWorldPoint`, which indexes its rows without a bounds check, as it did under XNA. No defect found |
| MP3Sharp sample | `github.com/ZaneDubya/MP3Sharp` @ `c92d6e5`, its `XNA4Sample`, on the MP3Sharp decoder it ships (`games/Mp3Sharp/*`; the decoder's own project now targets .NET Framework 4.7.2 and is compiled from its sources here) | its `sample.mp3`, copied beside it as its project copies it | (2026-10-03) streams the MP3 through a `DynamicSoundEffectInstance`: the output SDL's disk driver captured matches an ffmpeg decode of the same file to an RMS difference of 20 against a signal of 9,500 (peak 68 of 32,768, decoder rounding). No defect found |
| SharpMik player | `github.com/thegouldfish/SharpMik` @ `9e2aab7`, its XNA Windows test player on the SharpMik library it ships (`games/SharpMik/*`), as transferred from CodePlex: the next commits rework the library for MikMod 3.3.10 without its XNA project, which then lists files the code no longer has | built from its own content project by XNA's BuildContent (Windows/Reach), its six `.mod` files copied as the project copies them | (2026-10-03) Play starts "cannon fodder" and Next "bootup", mixed by SharpMik and streamed through a `DynamicSoundEffectInstance` (SDL's disk driver captured the music). It opens `content/mods/musicN.mod` where its content directory is `Content`, which Windows' file system did not mind, so `content` is linked beside it (`CnaWindowsPath`). No defect found |
| LilyPath logo | `github.com/jaquadro/LilyPath` @ `a3750eb`, its `LilyPathLogo` demo on the library's XNA build (`games/LilyPath/*`): the last commit before its XNA project stopped listing the files the library needs | none (paths, arcs and fills drawn by its `DrawBatch`) | (2026-10-03, after CNA CBIND-156 and CNA.NET CSX-135) its lily-pad logo, matching the XNA-rendered image in its README to 2,281 of 129,600 pixels at 10% (MSAA edges). It drew all black before: CNA's stock effects ignored the brush texture its `DrawBatch` sets on the device after applying a texture-less `BasicEffect` |
| willcraftia's XNA tests | `github.com/willcraftia/TestXna` @ `f271604`: seven demos (`games/WillcraftiaTestXna/*`) -- light-space perspective and parallel-split shadow maps (LiSPSM, PSSM), CDLOD terrain (Terrain, TiledTerrain, MDTerrain) on hardware instancing and vertex texture fetch, midpoint-displacement and Perlin-noise height maps -- on its five libraries | built from their own content projects by XNA's BuildContent (Windows/HiDef); the shadow demos with the sixteen files of Microsoft's Shadow Mapping sample (`dude.fbx`, `grid.fbx` and their textures) their content README asks to be copied in | (2026-10-03, after CNA FX-145 and CNA.NET CSX-136) all seven run. LiSPSM matches its XNA build under Wine, its variance shadow included, which was speckled before: its blur read the Vector2 moments at fp16. TerrainDemo's floating sheets and ribbons are its own: its XNA build under Wine draws the same |
| cocos2d-x for XNA tests | `github.com/cocos2d/cocos2d-x-for-xna` @ `4537342`, its `tests`: the cocos2d-x test scenes ported to XNA 4.0 for Windows Phone, hosted through `CnaPhoneGame` on the cocos2d-xna and CocosDenshion libraries it ships (`games/Cocos2dXna/*`; cocos2d-xna with the SharpZipLib and zlib.net Windows Phone binaries it ships) | built from its own content project by XNA's BuildContent (WindowsPhone/Reach) with its cocos2d.Framework and cocos2d.Content.Pipeline.Importers extensions: textures, fonts, text, TMX maps, a song and a sound | (2026-10-03) its test menu; taps open the action, particle and primitive tests, the arrows step through them, Back exits. It never clears its frame (its director's `glClear` is commented out), so each scene draws over the last one: what a game finds in the back buffer after Present is undefined in XNA. No defect found |
| BoneAnimation example | `github.com/imeteora/BoneAnimation` @ `77cbee5`, `Bones.XNA.Example`, skeletal sprite animation on the Bones.XNA library it ships, which reads its skeleton through the protobuf-net binary it ships (`games/BoneAnimation/*`) | built from its own content project by XNA's BuildContent (Windows/Reach); its `hero.png` and `hero.skt` copied beside it as its project copies them | (2026-10-03) the hero idles; A/D select and Q plays its walk and running animations. No defect found |
| 2D camera Platformer | `github.com/apbeecham/xna-camera-2d` @ `91a8ed4`, `2DCamExample`: Microsoft's Platformer starter kit with a scrolling, zoomed 2D camera (its repository does not ship the `Properties/AssemblyInfo.cs` its project lists, assembly attributes only, so the SDK generates those) | built from its own content project by XNA's BuildContent (Windows/HiDef); its sounds and song are `.wma` files byte-identical to the starter kit's, so they are that kit's retained XNA build output (`--official`) | (2026-10-03) the adventurer runs on the arrows and jumps on Space with the view following him, takes a gem and dies in a pit. No defect found |
| UTS tower defence | `github.com/ddoodm/GameProgramming` @ `4970a5a`, `GameProgrammingMajor`: a UTS Game Programming group's 3D tower defence (quadtree terrain, FSM tanks, tower placement by mouse picking) | built from its own content project by XNA's BuildContent (Windows/Reach); its level and FSM XML copied beside it as its post-build event copied them, and linked under the Windows names it opens (`Levels\level0.xml`) | (2026-10-03) its first level's terrain, path and HUD with the placement cursor. The XNA build its repository ships is of an older revision (a castle and a skybox the source no longer has), so it is no reference. No defect found |
| Windows Phone 7 Recipes | `github.com/Apress/win-phone-7-recipes` @ `9375671`, Fabio Claudio Ferracchiati and Emanuele Garofalo's book (Apress, 2011): its three XNA recipes (`games/Wp7Recipes/*`; the rest are Silverlight), hosted through `CnaPhoneGame` | each built from its own content project by XNA's BuildContent (WindowsPhone/Reach) | (2026-10-03, after CNA.NET CSX-137) the simplest XNA application; the trial application, a full version in its Release build (it simulates trial mode only in Debug) where CNA.NET had answered as XNA on Windows does without gamer services, "trial"; the tombstoning recipe's ball, its settings kept in `PhoneApplicationService.State` |
| ExEn samples | `github.com/jlyonsmith/ExEnCopy` @ `5d76753`, a copy of Andrew Russell's ExEn (XNA's API on iOS, Android and Silverlight): the XNA (Windows) projects of its Marblets, CatGirls test suite and Orientation samples (`games/ExEn/*`) | each built from its own content project by XNA's BuildContent (Marblets Windows/Reach, the others HiDef); CatGirls' fonts through ExEn's own font-shim extension and the Nuclex importer it ships, its MP3 song a labelled stand-in; Orientation's content root is the program's directory, as its content project says | (2026-10-03, after CNA.NET CSX-138 and CSX-139) Marblets deals its board and selects on a tap; CatGirls' sprite font, colour, viewport and timing tests draw; Orientation shows its cat girl. Marblets threw from its constructor (a `VisibleChanged` XNA does not raise) and the timing test from `DrawString` (ICU's U+202F before AM/PM) |
| Programming Windows Phone 7 | `github.com/coderserdar/WindowsPhoneSamples` @ `6551a86`, Charles Petzold's book (Microsoft Press, 2010): 48 of its XNA samples from chapters 1 to 24 beside PhreeCell (`games/Petzold/*`), hosted through `CnaPhoneGame`, some on its Petzold.Phone.Xna library | each built from its own content project by XNA's BuildContent (WindowsPhone/Reach); AccelerometerVisualization's content project is missing from that copy and comes from the same book's code in `github.com/rkks/refer` @ `c6c65714` | (2026-10-03, after CNA.NET CSX-139: XnaSimpleClock prints `DateTime.Now`) hello texts, the clock, taps and touches, text movement and crawl, cars on courses, finger painting into render targets, ripples, affine and non-affine transforms, drag, pinch, flick and rotate on the photo, the Mandelbrot set, PhingerPaint and SpinPaint; the accelerometer samples keep their ball still, as on a phone whose sensor reports nothing. XnaWebBitmap downloads its picture from a web address and stays blank here. XnaTapToBrowse (the phone's `PhotoChooserTask`) and XnaLocation (`System.Device.Location`) need phone services CNA.PhoneCompat does not stand in for |
| Windows Phone Pong demos | the same repository's "Version 1 Demos", chapter 9: eight steps of an XNA Pong game for Windows Phone (`games/Wp7PongDemos/*`), hosted through `CnaPhoneGame` | each built from its own content project by XNA's BuildContent (WindowsPhone/Reach) | (2026-10-03) the dot, its movement and bounce, the paddles, the scored game, its sounds and the full-screen game. "Tipping Pong" starts the accelerometer without catching its failure, and the desktop has none: `Start` throws `AccelerometerFailedException`, as the phone's did when its sensor could not start |
| tiled-xna example | `github.com/zachmu/tiled-xna` @ `515146e`, its example of a Tiled map drawn by its `Tiled.cs` reader | built from its own content project by XNA's BuildContent (Windows/HiDef), its `MapTest.tmx` copied as that project copies it | (2026-10-03) the map spelling "TILE MAPS RULE" with its hero. No defect found |
| XNA 4.0 Game Development by Example | `github.com/AcornPublishing/xna4-game` @ `cf39bfc`, Kurt Jaegers' book (Packt, 2010): the final chapter's project of each of its four games (`games/XnaByExample/*`) -- Flood Control, Asteroid Belt Assault, Robot Rampage and Gemstone Hunter on the book's Tile Engine | each built from its own content project by XNA's BuildContent (Windows/Reach), Gemstone Hunter's maps copied as its project copies them | (2026-10-03, after CNA.NET CSX-141) each title, then Space starts play: the pipe board, the asteroid belt, the robot arena and Gemstone Hunter's first level, read through the Tile Engine's `BinaryFormatter` from a `FileStream` it casts `TitleContainer.OpenStream` to. (2026-10-04, after CSX-144) unchanged Gemstone Hunter also loads the serialized maps and reaches its title in headless Chromium/WebAssembly (.NET 11, SwiftShader) and on the x86_64 Android emulator (.NET 11). The Level Editor is a Windows Forms program |
| Gears VGE | `github.com/spectrumbranch/gearsvge` @ `bcfd122`: GearsDebug, the demo of its 2D middleware and menu engine, on the GearsVGE library it ships (`games/GearsVge`) | built from its own content project by XNA's BuildContent (Windows/Reach): 15 assets, with the "Roses are FF0000" font its repository ships (`_DUMP/`) installed; its MP3 song a labelled stand-in | (2026-10-03, after CNA.NET CSX-142) built as Release, its splash and the "Catalyst" title, as it ships; built as Debug (`dotnet build -c Debug`), its debugger menu, the Development menu and Radial Assault, whose ship circles the arena under the arrow keys. Its settings derive from `ApplicationSettingsBase`, which the System.Configuration.ConfigurationManager package carries. Its `UnloadContent` stops its audio thread with `Thread.Abort`, which .NET 5 and later refuse, so it ends with that `PlatformNotSupportedException`; on the .NET Framework the abort let its foreground thread go |

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
CSX-148 bounded the performance investigation on 2026-10-04: Emscripten can hand an
`OffscreenCanvas` to a worker only while creating that pthread, but .NET owns its managed deputy
thread and exposes no supported canvas-transfer hook. The correct proxy path remains; improving it
is future .NET/browser-host platform work, not a reason to alter this game or patch the runtime.
CSX-150 requalified the path on 2026-10-04 with a threaded archive rebuilt from current CNA
`28f8312f0` (Emscripten 6.0.3, SHA-256
`ce8db116c3d9100f363864d355ad205c7334e5c5b630167c4fee1641c588b6c2`). AimingSample moved under
held keyboard input and exited cleanly. Unchanged Resonance, after its disposable 282-asset output
was rebuilt by the documented XNA BuildContent/XACT workflow, loaded its level on its own thread,
initialized its shipped BEPUphysics, entered the 3D arena and reacted to movement. No new general
CNA/CNA.NET defect was exposed; evidence is in
`/rv/tmp/cs-samples/final-threaded-20261004/`.
The five Microsoft samples added last reach their first screen in a browser and on the Android
emulator too (CNA `fb89c451a` archives, 2026-10-02). In a browser Memory Madness reaches its instructions (a round needs the level link added on 2026-10-03, not run in a browser since) and
Saving Embedded Images opens its keyboard prompt, but its blocking `Guide.EndShowMessageBox` right
after `Begin` cannot wait in a single-threaded page (CNA refuses: no frame can run inside the
wait). Network Game State Management's Single Player stops on "Loading.." in a threaded bundle and
on Android: both run .NET on Mono, whose `Thread.Join` does not consult the
SynchronizationContext that CSX-118 relies on (CoreCLR's does), so the game thread never runs its
loading thread's drawing. The Level Starter Kit (cna-samples SAMPLE-128) is a Silverlight Windows
Phone app, not an XNA game.
The GitHub games added since (CNA `90b553dc1` archives, 2026-10-03): Sonic 3, Disentanglement and
HauntedHouse reach their first screens in a browser; SKraft loads its map sectors on threads of its
own, so it runs as a multithreaded bundle (`--threads`) to its menu; the Forge sample's engine talks
to itself over a local UDP server, which a browser cannot open.
The programs added on 2026-10-03 (CNA `c7b13c14d` archives, both rebuilt that day): in a browser
Mario3, the tile-engine tutorial, MP3Sharp's and SharpMik's players, LilyPath's logo (after CNA
CBIND-156), the LiSPSM and PSSM shadow demos (LiSPSM's variance shadow smooth: SwiftShader samples at
32 bits), the midpoint-displacement and Perlin-noise demos, cocos2d-x for XNA's tests, BoneAnimation
(after CNA.NET CSX-140, which keeps CoreLib whole for its protobuf-net), the 2D camera Platformer,
the UTS tower defence, ExEn's Marblets and the three Windows Phone 7 recipes reach their first
screen; the Farseer 3.5 samples after the generators carried their wildcard version, which needs
`Deterministic` off. TiledTerrainDemo's normal map is `Rgba64`, which WebGL 2 without
`EXT_texture_norm16` has no format for (refused by name); MDTerrainDemo, as a threaded bundle, never
loads a terrain partition -- its thread-pool work items never run (the .NET 11 RC1 worker fault
above). TerrainDemo's clear-only symptom was reduced to its mouse-look loop repeatedly calling
`Mouse.SetPosition`, which a browser cannot physically perform, rather than its compiled effect or
instanced terrain draw. After CNA CSX-145 virtually preserves the requested position and applies
later raw pointer deltas, unchanged original source draws in headless Chromium/SwiftShader with the
deterministic harness action `move:600,350@2000`; the no-action harness starts at raw `(0,0)`, and
the demo itself never centres that first sample. Interactive browser input and a hardware GPU were
not qualified by this run. On the Android emulator
eight Petzold samples, the three recipes, cocos2d-x for XNA's tests (after the generators stopped
handing the game the SDK's `ANDROID` symbol, which switched on its MonoGame-for-Android activity),
BoneAnimation (CSX-140 again), Mario3, the 2D camera Platformer, LilyPath, Marblets, tiled-xna, the
UTS tower defence and LiSPSM all run (`/rv/tmp/cs-samples/{browser,android}-20261003*`).

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
- **Asteria** (`Bryan-Legend/asteria` @ `11334ae`, the Steam game's full source): its Windows
  game saves and loads its player and maps through `System.Xaml`'s `XamlServices` and writes map
  images through WPF's `PngBitmapEncoder`, Windows desktop assemblies .NET does not have on Linux;
  its Xbox 360 project no longer compiles against the shared sources it links (Steamworks,
  `Achievement`), already so in the one commit the source was published as. Its lighting and
  blend-effect demos run (above).
- **SeedWorld** (`ccajas/SeedWorld`): its content project needs Nuclex's sprite-font processor,
  a pipeline extension its repository does not ship, and Lucida Console; its game reads the
  clipboard through WPF's `System.Windows.Clipboard`.
- **BulletXNA demos** (`xexuxjy/bullet-xna`): both content projects' fonts name Miriam, a Windows
  Hebrew font neither the repository nor Game Studio ships.
- **Isosurface** (`Lin20/isosurface`): references `alglibnet2.dll` and `MathNet.Numerics.dll` at
  `E:\Libraries\...`, which the repository does not ship, at versions it does not name.
- **Mythology** (`AlanWills/Mythology`, one commit): its XRpgLibrary project omits
  `TileEngine/ILayer.cs`, which its map layers implement, so it does not build as published.
- **Almirante** (`WoLfulus/Almirante`): its engine compiles a Windows Forms control that hosts XNA
  (`AlmiranteControl`, painting through `System.Drawing.Graphics`) and takes Windows Forms key and
  mouse events in every scene; its test programs build on it. (Its content builds: its pipeline
  extension needs Microsoft's compiler, which `build-xna-content.sh` now falls back to.)
- **illuminati-engine** (`JohnLouderback/illuminati-engine-xna`): its engine references
  Awesomium, BulletSharp and the Kinect SDK, native or Windows-only; its BulletXNA demos' fonts name
  Miriam. **CellSDK samples** (`Syderis/CellSDK-Samples`): Windows Phone samples on Syderis' CellSDK,
  whose assemblies the repository does not ship.
- **Shading** (`bschwind/Shading`): an Xbox 360 project whose `RenderNormals.fx` takes a `NORMAL0`
  pixel-shader input that the Xbox compiler accepted and Windows' `ps_2_0` refuses.
- **Squared** (`sq/Libraries`): its examples' libraries now target .NET Framework 4.8 without XNA
  (the collection moved to FNA). **WPFLight** (`ronnycsharp/WPFLight`): only a Windows Phone
  library, referencing a `System.Threading.Tasks.WP71.dll` it does not ship.
- **Xen Game Client** (`apeape/Xen-Game-Client`): its voxel terrain is PolyVox, a native Windows
  DLL (`PolyVoxCore.dll`) under its SWIG wrapper. **xTile demo** (`colinvella/tIDE`), **XNAVERGE**
  (`breadbros/XNAVERGE`) and **Azmyth** (`GalacticSoft/Azmyth`): sprite fonts naming Lucida
  Console, Garamond and PF Ronda Seven, and Kartika, which neither they nor Game Studio ship (Azmyth
  also lists two icons outside its repository). **DirtyGame** (`4950/DirtyGame`): WPF and MonoGame's
  content processors.
- **YCPU** (`ZaneDubya/YCPU`): its emulator's `Main` shows a console through `kernel32`'s
  `GetConsoleWindow`/`AllocConsole` before anything else.
- **TestBench1** (`geofftnz/TestBench1`): its terrain test bench's sprite font names Consolas, a
  Windows font neither its repository nor Game Studio ships.
- **Rugby League** (`initials/RugbyLeague` @ `a1aa01a`): its XNAFlixel content
  (`initials/XNAFlixel` @ `0ef7a5c`) has sprite fonts that name Munro, Small Pixel and Space
  Marine, which neither repository ships (only `deffont.ttf`, Nokia Cellphone FC).
- **The Lost Levels** (`google-code-export/the-lost-levels`, its game project): compiles its
  Windows Forms level editor (`LevelGUI`, `LevelEditorForm`) into the game. Its tile-engine
  tutorial runs (above).
- **Design Patterns Game** (`brunolm/DesignPatternsGame` @ `109ddea`): its `Main` composes its 20
  mini-games through MEF, which constructs every one -- 21 `Game` objects alive at once, where
  CNA runs one game per process ("Only one C-owned CNA game may be active at a time").
- **Jxqy HD** (`mapic91/JxqyHD`): its game data is a separate download of the commercial original,
  and its engine reads it through code page 936, which .NET has only with a provider registered.
- **Tactile Engine** (`bwdyeti-com/Tactile-Engine`): needs its sibling `TactileSharedLibraries`
  repository and a content project it does not ship; its `Main` reads the registry and `LoadLibrary`s
  OpenAL through `kernel32`.
- **Kodu Game Lab** (`scoy/KoduGameLab`): hosts its game in a Windows Forms window
  (`Application.Run(MainForm)`), with Calibri, Segoe UI, Arial and Consolas sprite fonts and Win32
  keyboard calls.
- **SuperHorrorFactory** (`initials/SuperHorrorFactory`): its XFlixel and midi-dot-net projects live
  in another repository. **DrunkiBoy** (`spectacell/DrunkiBoy`): its `levels\` folder is not in
  its repository and its fonts name "8BIT WONDER". **Asteroids** (`nourselim0/Asteroids-Game`),
  **PACMAN** (`cuza/PACMAN`) and callumlawson's **Shooter**: sprite fonts that name Copperplate
  Gothic and Freestyle Script, Lucida Console, Impact. callumlawson's **Platformer** uses Farseer
  without referencing it and loads assets its content project lacks.
- **Medicraft** (`SuperBigtoo/Medicraft`): MonoGame (net8.0, DesktopGL), not XNA.
- **Old School Adventure** (`Source/OldSchoolAdventure`): its projects are MonoGame's now
  (`net8.0-windows`, MonoGame.Framework.WindowsDX); only its types library is still XNA 4.0.
- **Quarx** (`tommy-xr/quarx`): its game project nests `Content\Content.contentproj`, which the repository
  does not have, and references Scurvy.Media, which it does not ship; its engine's sprite font names Calibri.
  **XNALara** (`AerysBat/XNALara`): takes its game window as a Windows Forms `Form`
  (`Form.FromHandle(Window.Handle)`) and drives its scene from Windows Forms dialogs.

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

willcraftia's LiSPSM and PSSM content projects list Microsoft's Shadow Mapping sample files,
which the repository leaves out as too large; as its content README asks, copy `dude.fbx`,
`grid.fbx`, `Grid.png` and the thirteen `head`/`jacket`/`pants`/`upBody` textures from
`ShadowMappingSample_4_0/ShadowMapping/Content` beside each `.contentproj` before building it.
SharpMik is checked out at `9e2aab7` and LilyPath at `a3750eb` (`git fetch --unshallow` first if
cloned shallow): the commits after those leave their XNA projects naming files the code no longer
has, or missing files it now needs.

`GameRoot` (and `GameContent` for the games with built content) override the checkout locations. The XNA 4.0
reference frames come from the games' own XNA-built executables run under Wine with the XNA 4.0
prefix (`~/.wine-cna-xna40`, WineD3D) on a private Xvfb larger than the game's window (Wine
shrinks a window that does not fit the screen and stretches its back buffer into it).
