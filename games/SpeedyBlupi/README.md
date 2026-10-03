# Speedy Blupi on CNA.NET

A real Windows Phone XNA 4.0 game, not a sample: Speedy Blupi as decompiled from its `.xap` and
rebuilt against the original XNA 4.0 in `openeggbert/mobile-eggbert-legacy/speedy-blupi-xna4`.
`SpeedyBlupi.csproj` compiles exactly what that repository's XNA build compiles (its
`scripts/build.sh`: the same sources and `Microsoft.Devices.Sensors` stand-ins, `TRACE;WINDOWS`,
Reach) against CNA.NET instead of Microsoft's assemblies, and copies its official XNA Content
Pipeline output (`build/bin/Content`, 280 `.xnb`) and levels beside the executable. Nothing in that
repository is changed; `SpeedyBlupiRoot` points at it.

## Measured 2026-10-01 (CNA.NET `c68a246`, CNA `9976f4909`, OPENGLES3)

- Builds with no errors; the five warnings are the decompiled code's own.
- The title screen is **255 px of 384 000** from the original XNA 4.0 build of the same program run
  under Wine (WineD3D) on an 800x480 display, and those pixels are the save-game numbers in the
  player panel: Wine's prefix holds a saved game, the CNA.NET run starts from a private, empty home.
- Play loads the first level; Blupi walks with the arrow keys and jumps with Ctrl, the virtual pad and
  the HUD draw; Escape opens the pause screen (Home, Setup, Continue). No exception, no CNA error.
- `Game1` hardcodes `IsFullScreen = true` with no preferred back buffer. On a bare Xvfb the switch
  falls back to the 800x480 window, the framing the art is drawn for.

## Measured 2026-10-03 (the owner's walk-through, CNA `75b55659c`)

- Played on a real desktop (Xwayland, 2048x1152): the mouse works -- menus, the virtual pad and the
  buttons answer clicks -- after CNA CBIND-157. Xwayland cannot switch to the 800x480 mode `IsFullScreen`
  asks for, so the window takes the desktop mode and letterboxes the back buffer; `Window.ClientBounds`
  reported that 2048x1152 window while the mouse was already in back-buffer space, and the game, which
  maps its pointer by `Viewport / ClientBounds`, missed every button. A fullscreen window's ClientBounds
  is now the back buffer's mode, as XNA's mode switch makes it.

Captures: `/rv/tmp/cs-samples/speedy-blupi-{1,2,3}/` (CNA.NET) and
`/rv/tmp/cs-samples/speedy-blupi-xna/xna-title.png` (XNA 4.0 under Wine).

```bash
dotnet build games/SpeedyBlupi/SpeedyBlupi.csproj -c Release
scripts/capture-sample.sh Bounce --exe games/SpeedyBlupi/bin/Release/net8.0/SpeedyBlupi \
    --window '^Speedy Blupi$' --out /rv/tmp/cs-samples/speedy-blupi --no-exit-check   # any row name; it names the PNG
```
