# CNA.NET Samples Plan

## Authority and scope

This is the only authoritative plan for this repository. It inventories every XNA 4.0 sample that
may be attempted here, records the state of each, and fixes the order they are attempted in.
[`rules.md`](rules.md) is the binding policy; this file is the ledger.

The goal is one measurable claim per row:

> The original C# of this sample, unchanged, compiles and runs on CNA through CNA.NET — with
> exactly these deviations.

Nothing in this repository is a translation. Where `../cna-samples` asks "does the C++ port behave
like the original?", this repository asks "does the original itself still run?".

## Eligibility

A sample is eligible only when `../cna-samples/plan.md` marks its row `✅` **and** that mark stands
for a real C++ port. Measured against `../cna-samples` at `425d772` on 2026-09-02:

| Selection step | Rows |
|---|---:|
| Physical upstream directories in `/rv/tmp/XNAGameStudio/Samples` | 153 |
| `✅` in `../cna-samples/plan.md` | 80 |
| less `SAMPLE-004` StockEffects — owner-accepted non-port (`SAMPLES-DEC-002`) | −1 |
| less `SAMPLE-015` TicTacToe — owner-accepted non-port (`SAMPLES-DEC-004`) | −1 |
| **eligible rows here** | **78** |
| runnable products behind those rows | 85 |

The two exclusions are `✅` for an evidence-backed decision *not* to port, so there is no C++ port
to measure a C# run against. `SAMPLE-152` Racing, every `🛑` row and the three `🛠` rows are simply
not eligible yet; when `../cna-samples` finishes one, add its row here.

Task ids are `CSSAMPLE-nnn`, where `nnn` is deliberately the same number as the `SAMPLE-nnn` row in
`../cna-samples`. The two ledgers can be read side by side, and a commit in either repository says
which sample it belongs to.

## Status legend

| Symbol | Meaning |
|---|---|
| ⬜ | Not started. |
| 🛠 | Sources in place; building, running or writing evidence. |
| ⛔ | Blocked by a CNA defect below the binding. `missing.md` names it; `../cnanext` is not ours to fix. |
| 🛑 | Needs an owner decision before a large change. |
| ✅ | Builds and runs on `OPENGLES3`, sources verbatim or every deviation recorded, `missing.md` current. |

## Progress at a glance

Recount from the table rather than trusting these numbers
(`grep -c '| ✅ |$' plan.md`).

| Status | Rows |
|---|---:|
| ✅ complete | 0 |
| 🛠 in progress | 0 |
| ⛔ blocked on CNA | 0 |
| 🛑 owner decision | 0 |
| ⬜ not started | 78 |
| **total** | **78** |

## Verified toolchain baseline

Measured on 2026-09-02 before the first sample was attempted, so a later failure has something to
be compared against:

| Component | State |
|---|---|
| .NET SDK | 8.0.424 |
| `../cna-cs` | `develop` `859ecd5`; `CNA.Interop`, `CNA.Framework`, `CNA.XnaCompat` build Release with 0 warnings |
| `../cnanext` | `next` `1caa45c84`; C ABI **0.21.0** (`modules/c-api/include/CNA/C/abi.h`) |
| CNA.NET ABI matrix | accepts exactly **0.21.0** — matches |
| Native library | `../cnanext/cmake-build-release-capi/modules/c-api/libcna_c_api.so`, Release, `CNA_GRAPHICS_RENDERER=OPENGLES3` |
| Renderer at runtime | EasyGL on OpenGL ES 3.2 (Mesa 25.0.7), MSAA 8x, 4 MRT, DXT1/3/5 |
| Reference run | `../cna-cs-template` `--smoke-test`, 60 frames, exit 0, under `xvfb-run` |

## Out of scope

- **Browser builds.** `../cna-samples` gates each port on a real Chrome WEBGL2 run; there is no
  .NET route to that backend today. Native `OPENGLES3` is the only target here.
- **Other renderers.** Same boundary as the C++ campaign.
- **Changing `../cnanext` or `../sharp-runtimenext`.** A CNA defect is reported in the sample's
  `missing.md` and the row goes `⛔`.
- **Producing `.xnb`.** CNA reads compiled content and cannot write it; content comes from
  `../cna-samples` byte-for-byte.

## Execution order

Ordered so that each tier introduces one new kind of risk, and a failure in it has as few
candidate causes as possible.

**Tier 1 — no content at all.** Nothing but code, the device and input; a failure is the binding
or the runtime, never the content path.

`CSSAMPLE-001` PrimitivesSample → `CSSAMPLE-008` ShapeRendering → `CSSAMPLE-016` Bounce →
`CSSAMPLE-002` Primitives3D

**Tier 2 — small samples with content**, ascending by upstream size. Adds `Content.Load<T>()`,
textures, fonts, models, compiled effects and audio, one small sample at a time.

`CSSAMPLE-019`, `028`, `018`, `092`, `026`, `084`, `050`, `079`, `078`, `076`, `042`, `102`, `052`,
`098`, `011`, `033`, `038`, `012`, `030`, `041`, `083`, `053`, `034`, `031`, `039`, `040`, `025`,
`006`, `021`, `099`

**Tier 3 — mid-size samples.** Skinning, particles, picking, 3D audio, media playback.

`CSSAMPLE-059`, `007`, `010`, `058`, `049`, `046`, `060`, `080`, `032`, `020`, `054`, `037`, `003`,
`047`, `036`, `057`, `009`, `029`, `074`, `035`, `048`, `073`, `044`, `023`, `027`, `045`

**Tier 4 — multi-thousand-line samples** with their own frameworks and screen systems.

`CSSAMPLE-055`, `051`, `056`, `022`, `043`, `024`, `013`, `077`, `072`, `017`, `082`, `081`

**Tier 5 — full games.** Each is a campaign of its own; `CSSAMPLE-068` is seven products sharing
one row.

`CSSAMPLE-005` ReachGraphicsDemo → `CSSAMPLE-069` CardsStarterKit → `CSSAMPLE-067` CatapultWars →
`CSSAMPLE-063` HoneycombRush → `CSSAMPLE-061` MarbleMaze → `CSSAMPLE-068` CatapultWars Training Kit

Take a sample out of order only for a reason worth writing down in `NEXT.md`.

## Inventory

`Upstream` is the directory under `/rv/tmp/XNAGameStudio/Samples`. `C++ port` is the
`../cna-samples/samples/` directory this row is measured against — the same C++ port supplies the
`Content/` tree. `Size` counts every `.cs` file in the whole upstream directory, including phone
variants and pipeline-extension projects this row may not build, so it is a rough signal rather
than the selected configuration's line count. `.xnb` is how many compiled content files the C++
port ships.

| Task | Upstream | C++ port | Size (files / lines) | .xnb | Status |
|---|---|---|---:|---:|---|
| CSSAMPLE-001 | `PrimitivesSample_4_0` | `PrimitivesSample` | 3 / 586 | 0 | ⬜ |
| CSSAMPLE-002 | `Primitives3DSample_4_0` | `Primitives3D` | 10 / 1484 | 0 | ⬜ |
| CSSAMPLE-003 | `TexturesAndColorsSample_4_0` | `TexturesAndColors` | 4 / 1046 | 8 | ⬜ |
| CSSAMPLE-005 | `ReachGraphicsDemo_4_0` | `ReachGraphicsDemo` | 28 / 4056 | 22 | ⬜ |
| CSSAMPLE-006 | `SpriteEffectsSample_4_0` | `SpriteEffects` | 5 / 770 | 8 | ⬜ |
| CSSAMPLE-007 | `SpriteSheetSample_4_0` | `SpriteSheet` | 9 / 835 | 3 | ⬜ |
| CSSAMPLE-008 | `ShapeRenderingSample_4_0` | `ShapeRendering` | 4 / 662 | 0 | ⬜ |
| CSSAMPLE-009 | `InputReporter_4_0` | `InputReporter` | 6 / 1119 | 15 | ⬜ |
| CSSAMPLE-010 | `InputSequenceSample_4_0` | `InputSequence` | 6 / 859 | 15 | ⬜ |
| CSSAMPLE-011 | `SafeAreaSample_4_0` | `SafeArea` | 4 / 555 | 3 | ⬜ |
| CSSAMPLE-012 | `GeneratedGeometrySample_4_0` | `GeneratedGeometry` | 7 / 629 | 3 | ⬜ |
| CSSAMPLE-013 | `Platformer_4_0` | `Platformer` | 14 / 2214 | 46 | ⬜ |
| CSSAMPLE-016 | `BounceSample_4_0` | `Bounce` | 8 / 1117 | 0 | ⬜ |
| CSSAMPLE-017 | `CollisionSample_4_0` | `CollisionSample` | 13 / 2962 | 1 | ⬜ |
| CSSAMPLE-018 | `PerPixelCollisionSample_4_0` | `PerPixelCollision` | 3 / 335 | 2 | ⬜ |
| CSSAMPLE-019 | `RectangleCollisionSample_4_0` | `RectangleCollision` | 3 / 280 | 2 | ⬜ |
| CSSAMPLE-020 | `TransformedCollisionSample_4_0` | `TransformedCollision`<br>`TransformedCollisionTest` | 8 / 1034 | 6 | ⬜ |
| CSSAMPLE-021 | `PathDrawing_4_0` | `PathDrawing` | 5 / 781 | 3 | ⬜ |
| CSSAMPLE-022 | `Pathfinding_4_0` | `Pathfinding` | 9 / 1726 | 13 | ⬜ |
| CSSAMPLE-023 | `WaypointSample_4_0` | `WaypointSample` | 8 / 1192 | 5 | ⬜ |
| CSSAMPLE-024 | `FlockingSample_4_0` | `FlockingSample` | 14 / 1950 | 6 | ⬜ |
| CSSAMPLE-025 | `ChaseAndEvadeSample_4_0` | `ChaseAndEvade` | 2 / 751 | 4 | ⬜ |
| CSSAMPLE-026 | `AimingSample_4_0` | `AimingSample` | 2 / 391 | 2 | ⬜ |
| CSSAMPLE-027 | `FuzzyLogicSample_4_0` | `FuzzyLogic` | 10 / 1332 | 4 | ⬜ |
| CSSAMPLE-028 | `ColorReplacementSample_4_0` | `ColorReplacement` | 2 / 282 | 4 | ⬜ |
| CSSAMPLE-029 | `ParticleSample_4_0` | `ParticleSample` | 8 / 1130 | 3 | ⬜ |
| CSSAMPLE-030 | `CameraShake_4_0` | `CameraShake` | 5 / 630 | 6 | ⬜ |
| CSSAMPLE-031 | `BloomSample_4_0` | `BloomSample` | 4 / 701 | 8 | ⬜ |
| CSSAMPLE-032 | `DistortionSample_4_0` | `DistortionSample` | 9 / 1015 | 9 | ⬜ |
| CSSAMPLE-033 | `NonPhotoRealisticSample_4_0` | `NonPhotoRealistic` | 3 / 568 | 6 | ⬜ |
| CSSAMPLE-034 | `NormalMappingSample_4_0` | `NormalMappingEffect` | 6 / 679 | 8 | ⬜ |
| CSSAMPLE-035 | `PerPixelLightingSample_4_0` | `PerPixelLighting` | 4 / 1133 | 8 | ⬜ |
| CSSAMPLE-036 | `VertexLightingSample_4_0` | `VertexLighting` | 4 / 1086 | 7 | ⬜ |
| CSSAMPLE-037 | `RimLighting_4_0` | `RimLighting` | 8 / 1041 | 5 | ⬜ |
| CSSAMPLE-038 | `ShadowMappingSample_4_0` | `ShadowMapping` | 5 / 628 | 16 | ⬜ |
| CSSAMPLE-039 | `BillboardSample_4_0` | `BillboardSample` | 4 / 705 | 5 | ⬜ |
| CSSAMPLE-040 | `InstancedModelSample_4_0` | `InstancedModel` | 5 / 716 | 4 | ⬜ |
| CSSAMPLE-041 | `LensFlareSample_4_0` | `LensFlare` | 3 / 643 | 6 | ⬜ |
| CSSAMPLE-042 | `ShatterEffectSample_4_0` | `ShatterEffect` | 5 / 514 | 5 | ⬜ |
| CSSAMPLE-043 | `Particles3DSample_4_0` | `Particles3D` | 12 / 1727 | 7 | ⬜ |
| CSSAMPLE-044 | `Particles2DPipeline_4_0` | `Particles2DPipeline` | 9 / 1172 | 9 | ⬜ |
| CSSAMPLE-045 | `XmlParticles_4_0` | `XmlParticles` | 8 / 1462 | 12 | ⬜ |
| CSSAMPLE-046 | `Graphics3DSample_4_0` | `Graphics3D` | 8 / 962 | 10 | ⬜ |
| CSSAMPLE-047 | `PickingSample_4_0` | `PickingSample` | 6 / 1046 | 10 | ⬜ |
| CSSAMPLE-048 | `TrianglePickingSample_4_0` | `TrianglePicking` | 5 / 1139 | 10 | ⬜ |
| CSSAMPLE-049 | `HeightmapCollisionSample_4_0` | `HeightmapCollision` | 6 / 881 | 4 | ⬜ |
| CSSAMPLE-050 | `SimpleAnimation_4_0` | `SimpleAnimation` | 3 / 404 | 3 | ⬜ |
| CSSAMPLE-051 | `CustomModelAnimation_4_0` | `CustomModelAnimation` | 13 / 1672 | 8 | ⬜ |
| CSSAMPLE-052 | `CustomModelClassSample_4_0` | `CustomModelClass` | 6 / 541 | 3 | ⬜ |
| CSSAMPLE-053 | `CustomModelEffectSample_4_0` | `CustomModelEffect` | 6 / 674 | 4 | ⬜ |
| CSSAMPLE-054 | `SkinningSample_4_0` | `SkinningSample` | 9 / 1040 | 5 | ⬜ |
| CSSAMPLE-055 | `SkinnedModelExtensions_4_0` | `SkinnedModelExtensions` | 13 / 1620 | 7 | ⬜ |
| CSSAMPLE-056 | `CPUSkinningSample_4_0` | `CPUSkinning` | 19 / 1691 | 7 | ⬜ |
| CSSAMPLE-057 | `InverseKinematics_4_0` | `InverseKinematics` | 3 / 1104 | 3 | ⬜ |
| CSSAMPLE-058 | `ChaseCamera_4_0` | `ChaseCamera` | 4 / 880 | 5 | ⬜ |
| CSSAMPLE-059 | `Audio3DSample_4_0` | `Audio3D` | 8 / 821 | 7 | ⬜ |
| CSSAMPLE-060 | `SoundAndMusic_4_0` | `SoundAndMusic` | 5 / 963 | 10 | ⬜ |
| CSSAMPLE-061 | `MarbleMaze_4_0` | `MarbleMaze` | 140 / 25402 | 26 | ⬜ |
| CSSAMPLE-063 | `HoneycombRush_4_0` | `HoneycombRush` | 65 / 16127 | 47 | ⬜ |
| CSSAMPLE-067 | `CatapultWars_4_0` | `CatapultWars` | 61 / 12001 | 33 | ⬜ |
| CSSAMPLE-068 | `CatapultWarsTrainingKit_4_0` | `CatapultWarsTrainingHealthBar`<br>`CatapultWarsTrainingSecondHuman`<br>`CatapultWarsTrainingShotAngle`<br>`CatapultWarsTrainingShotGuide`<br>`CatapultWarsTrainingSupplyCrate`<br>`CatapultWarsTrainingAllFeatures`<br>`CatapultWarsTrainingScrollingScreen` | 150 / 30911 | 242 | ⬜ |
| CSSAMPLE-069 | `CardsStarterKit_4_0` | `CardsStarterKit` | 47 / 8742 | 89 | ⬜ |
| CSSAMPLE-072 | `GSMSample_4_0_WIN_XBOX` | `GameStateManagement` | 15 / 2520 | 5 | ⬜ |
| CSSAMPLE-073 | `SoccerPitchSample_4_0` | `SoccerPitch` | 10 / 1150 | 6 | ⬜ |
| CSSAMPLE-074 | `TankOnAHeightMapSample_4_0` | `TankOnHeightmap` | 7 / 1130 | 5 | ⬜ |
| CSSAMPLE-076 | `SplitScreenSample_4_0` | `SplitScreen` | 4 / 485 | 3 | ⬜ |
| CSSAMPLE-077 | `DynamicMenu_4_0` | `DynamicMenu` | 15 / 2447 | 11 | ⬜ |
| CSSAMPLE-078 | `LocalizationSample_4_0` | `LocalizationSample` | 6 / 481 | 8 | ⬜ |
| CSSAMPLE-079 | `GesturesSample_4_0` | `GesturesSample` | 4 / 456 | 2 | ⬜ |
| CSSAMPLE-080 | `TouchThumbsticksSample_4_0` | `TouchThumbsticks` | 8 / 965 | 4 | ⬜ |
| CSSAMPLE-081 | `PerformanceMeasuringSample_4_0` | `PerformanceMeasuring` | 17 / 3841 | 3 | ⬜ |
| CSSAMPLE-082 | `UISample_4_0` | `UISample` | 25 / 3497 | 11 | ⬜ |
| CSSAMPLE-083 | `SnowShovelSample_4_0` | `SnowShovel` | 3 / 667 | 5 | ⬜ |
| CSSAMPLE-084 | `AccelerometerSample_4_0` | `AccelerometerSample` | 5 / 399 | 2 | ⬜ |
| CSSAMPLE-092 | `ContentManifestExtensions_4_0` | `ContentManifestExtensions` | 5 / 366 | 10 | ⬜ |
| CSSAMPLE-098 | `MicrophoneEchoSample_4_0` | `MicrophoneEcho` | 3 / 550 | 1 | ⬜ |
| CSSAMPLE-099 | `ModelImporterSample_4_0` | `ModelImporterSample` | 4 / 797 | 3 | ⬜ |
| CSSAMPLE-102 | `Orientation_4_0` | `Orientation` | 4 / 528 | 2 | ⬜ |

## Excluded `✅` rows

| Task | Upstream | Why it is not attempted here |
|---|---|---|
| SAMPLE-004 | `StockEffectsSample_4_0` | A Content Pipeline effect-compiler CLI and six educational stock-effect wrappers — an authoring package, not a game. The owner accepted an evidence-backed non-port boundary on 2026-08-23 (`SAMPLES-DEC-002`), so there is no C++ port to measure a C# run against. |
| SAMPLE-015 | `TicTacToe_4_0` | Upstream is a WP7 XNA client plus a WCF/MPNS server, separately deployed; the client needs the retired WP7 SDK and MPNS no longer exists. The owner declined WCF/MPNS emulation on 2026-08-24 (`SAMPLES-DEC-004`). `../cna-samples/samples/TicTacToe` is a labelled free reimplementation and a port of neither original part. |

## Foundation tasks

| Task | Status | Work |
|---|---|---|
| CSINFRA-001 | ✅ | Establish the repository: Ms-PL license and notices, .NET ignore rules, `.gitattributes` keeping `.xnb` binary, README. First commit on `main`. |
| CSINFRA-002 | ✅ | Establish the working documents and build infrastructure on `develop`: `rules.md`, this plan, `AGENTS.md`/`CLAUDE.md`, `NEXT.md`, `Directory.Build.props` chain, solution, `scripts/build-native-cna.sh` and `scripts/run-sample.sh`. Verified the toolchain baseline above. |
| CSINFRA-003 | ⬜ | Add a content-provenance checker that compares every `samples/*/Content/**` file with its `../cna-samples` counterpart by hash and reports drift. |
| CSINFRA-004 | ⬜ | Add a verbatim-source checker that diffs each `samples/<Name>/` upstream subtree against `/rv/tmp/XNAGameStudio/Samples/<Upstream>/` and fails on any `.cs` difference not listed in that sample's `missing.md`. |
| CSINFRA-005 | ⬜ | Add an eligibility checker that re-derives the 78 rows from `../cna-samples/plan.md` and reports rows that became eligible, ineligible or renamed. |

## Session report and commit contract

Every session ends with: which rows moved and to what, which `../cna-cs` fixes were made and their
commit hashes, which CNA defects were recorded, and what the next session should pick up. Put it in
[`NEXT.md`](NEXT.md) under a new **Active handoff**.

Commit `cna-cs-samples` and `../cna-cs` separately, by explicit file list, with the `CSSAMPLE-nnn`
task id in both messages. Do not push unless the owner asks.
