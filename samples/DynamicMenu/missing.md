# DynamicMenu audit — CSSAMPLE-077 🛑

## Result

**Blocked on `DEC-001`'s entry-point question**, on the same rung as `CSSAMPLE-021` PathDrawing:
the sample has **no `Main` anywhere**. Its only game project is
`OutputType=Library`, `XnaPlatform=Windows Phone`, packaged as a XAP whose host supplied the entry
point.

Nothing is checked in for this row beyond this record, because there is nothing to check that could
build.

## What was established

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/DynamicMenu_4_0` |
| Solution | `DynamicMenuSample.sln` — the only one upstream ships |
| Projects | `DynamicMenuSample/DynamicMenuSample/DynamicMenuSample.csproj` (`Library`, Windows Phone) and `DynamicMenu/DynamicMenu - Windows.csproj` (the menu library) |
| `static void Main` in the whole directory | **0 occurrences** |
| Content | `Fonts/`, `Menus/`, `Textures/` in the C++ port |

## Why it is 🛑 rather than attempted

`grep -a "static void Main"` across every `.cs` file in the upstream directory returns nothing. So
unlike `CSSAMPLE-079` GesturesSample and `CSSAMPLE-080` TouchThumbsticks, there is no guarded entry
point that a `DefineConstants` change can switch on, and unlike `CSSAMPLE-016` Bounce there is not
even a broken one to repair. Running it means **writing a `Program` class**, which is new authored
code and the second half of `DEC-001`.

This is the second row on that rung, after `CSSAMPLE-021`. Two rows now wait on the same one-file
ruling.

## Not verified

Everything. The row was classified and stopped.
