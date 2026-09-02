# SpriteEffects audit — CSSAMPLE-006 ⛔

## Result

**Blocked, and not by anything in the sample or the binding.** The original C# is checked in
verbatim and builds 0/0 in both configurations. It cannot run because no native library with
compiled-effect support can currently be built:

```text
'desaturate': EffectReader could not create the compiled effect ---> The active graphics renderer
does not support compiled XNA/FNA Effect Framework bytecode (GraphicsCapability::CompiledEffects is false)
```

The project is in `CnaCsSamples.sln` and the solution builds clean; only the run is blocked.

## Selected configuration

| | |
|---|---|
| Upstream directory | `/rv/tmp/XNAGameStudio/Samples/SpriteEffectsSample_4_0` |
| Solution | `SpriteEffects (Windows).sln` |
| Project | `SpriteEffects/SpriteEffectsWindows.csproj` |
| Configuration | `Release\|x86` and `Debug\|x86`, Windows, Reach |
| Entry point | `SpriteEffects.Program.Main`, a static `Program` class at the bottom of `SpriteEffects.cs` |
| Assembly name | `SpriteEffects` |
| Content | 8 official pipeline XNBs, three of them compiled effects: `desaturate`, `disappear`, `normalmap` |

The upstream project's own `Content/` subdirectory — `normalmap.fx`, `disappear.fx`,
`desaturate.fx`, `cat_depth.jpg`, `waterfall.jpg`, `glacier.jpg` and the rest — is excluded per
`rules.md`: those are pipeline inputs, and the compiled output is checked in instead.

## Why it cannot run right now

This is a supply problem, not a defect in CNA's effect support, and the distinction matters:

1. Compiled `.fx` bytecode needs a CNA library built with `CNA_EASYGL_COMPILED_EFFECTS=ON`.
   `CSSAMPLE-028` established that renderer and build type alone do not give you one.
2. The only OPENGLES3 tree that had it, `cmake-build-debug`, segfaults during shutdown —
   `CNA-REPORT-003` — and was in any case deleted from `../cnanext` by other work partway through
   this session, along with every other OPENGLES3 tree.
3. Configuring a fresh one with `CNA_EASYGL_COMPILED_EFFECTS=ON` **fails to configure**:

   ```text
   error: corrupt patch at line 20
   CMake Error at cmake/patches/apply-fna3d-mojoshader-patch.cmake:52 (message):
     CNA: failed to apply mojoshader-6333f74-xna4-effect-state-identifiers.patch to FNA3D's
     MojoShader submodule
   ```

   `../cnanext`'s working tree currently has that patch, `cmake/ThirdPartyFNA3D.cmake` and
   `modules/graphics/src/Xna/Effect.cpp` modified by another session's in-flight effect work.

So the library this row was measured against is `cmake-build-release-capi` configured
**without** compiled effects, which is what every other row in this batch used and what
`scripts/build-native-cna.sh` now falls back to with a warning naming exactly this failure.

**This is transient.** It is not filed in `cna-bugs.md`, because there is nothing for CNA to fix
here that is not already `CNA-REPORT-003`: retry the row once `../cnanext`'s patch tree settles and
a working `CNA_EASYGL_COMPILED_EFFECTS=ON` OPENGLES3 build exists.

## Source deviations

**None** in any `.cs` file. `diff -r` over the code is clean; the excluded `Content/` inputs are
listed above.

## What was verified

- Sources verbatim; both configurations build with 0 warnings and 0 errors.
- The window opens at 800x480 and the failure is at content load, not at draw, so everything up to
  and including the non-effect content path works.

## Artifacts

`/rv/tmp/cs-samples/SpriteEffects/evidence/release/run.log`
