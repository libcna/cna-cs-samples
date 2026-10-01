# ClientServerSample audit — CSSAMPLE-091 ✅

## Result

**The original C# runs unmodified and matches the C++ port** — 0 differing pixels of 640 200 on its session menu. The Windows project's sources, verbatim, build in Debug and Release with no warnings. With nobody signed in the sample itself calls `Guide.ShowSignIn`, so it opens on CNA's Guide sign-in, as XNA's showed one; the retained C++ binary predates that Guide and goes straight to the menu. After creating a local profile in the Guide (Enter, a name, Enter) and closing it, the session menu ("A = create session, B = join session") matches, and Escape exits 0. Creating or joining a session was not exercised.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/ClientServerSample_4_0` |
| Project | `ClientServer/ClientServerWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `ClientServer.Program` |
| Assembly name | `ClientServer` |
| Content | the font and the tank and turret textures — official pipeline output, identical to `../cna-samples` |

## Source deviations

**None.** `diff -r` against the upstream project directory is clean.

```text
488cfbb03a3dcd5701bac2ae57f3437898023093a84871efffc13d83a51f837d  ClientServer/ClientServerGame.cs
fe64155d5e812c733e3c23364b2e547d09de785fed5d9db0bf56b743e30ea666  ClientServer/ClientServer.png
9f0917ca6a4f84188ee787482fc9f20f67683e87e630016be4d05285215284ec  ClientServer/ClientServerWindows.csproj
00b0b82575ef7bdf11932e15bb7dd932a45dce9cf225dd3f883fda0ab52b3217  ClientServer/ClientServerXbox.csproj
683c6ca8ca8e3e6136e945340784d08d048027f3a6c9bdb9855213edb2b69c7b  ClientServer/Game.ico
ff83e13d00fc6e5cbd3a5739b0544ce445d450afe7693f1c8c5289ba07b8a8e0  ClientServer.htm
69118b03b91674d71f1dd6e84b8987438f97ec3572659940edb61fa007dcde6b  ClientServer/Properties/AssemblyInfo.cs
8fd6920aff8c237acb6c3867ec19dabf42d20d446b945917a6ae4627a139358d  ClientServer/Tank.cs
```

## What was verified

The session-menu frame after signing in through the Guide (`/rv/tmp/cs-samples/clientserver-menu/`) at 2% fuzz against the C++ port's frame; Escape as the exit key. The run uses a private home, so the profile is the capture's own. Runs against CNA.NET `a6e0c50`, CNA `9976f4909`
(`build-probe`, Release OPENGLES3, compiled effects) on a private Xvfb.

## Artifacts

`/rv/tmp/cs-samples/gallery-batch-61/ClientServerSample/` (C# capture and logs) and `.../cpp/` (the C++ port through the same route).
