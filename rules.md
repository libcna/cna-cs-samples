# CNA.NET Samples Rules

## Mandatory status

This file is the binding working agreement for every change in `cna-cs-samples`. Read it
completely before analysing, enabling, building, running, documenting or reviewing a sample. Also
read [`plan.md`](plan.md) and the affected sample's `missing.md`.

Where this file and a historical note disagree, this file and `plan.md` win. The campaign brief
of 2026-10-01 (`../cna-cs/CAMPAIGN.md`) superseded the earlier read-only and stop-for-owner rules:
defects are fixed in the repository they live in, and phone-only or entry-point-less samples are
hosted rather than declared out of scope.

## What this repository is

`cna-samples` **ports** the XNA 4.0 sample collection to C++. This repository does not port
anything. It takes the **original C# sample sources** and makes them build and run unmodified on
.NET 8 against CNA.NET, which supplies `Microsoft.Xna.Framework`.

The measured claim of a finished row here is therefore narrow and precise:

> This much of the original C# compiles and runs on CNA with these exact deviations.

## Repository chain

| Repository | Checkout | Branch | Role |
|---|---|---|---|
| samples | `cna-cs-samples` | `develop` | this repository |
| C# binding | `../cna-cs` | `develop` | `Microsoft.Xna.Framework` facade |
| XNA runtime | `../cna` | `next` | native C ABI implementation |
| .NET runtime | `../sharp-runtime` | as checked out | CNA's internal BCL; not visible to these samples |
| gallery | `../samples.libcna.com` | `main` | which samples are in scope |
| C++ ports | `../cna-samples`, evidence `/rv/tmp/samples/SAMPLE-*` | `develop` | the working C++ CNA port and its evidence, `.xnb` source |
| originals | `/rv/tmp/XNAGameStudio/Samples` | -- | authoritative Microsoft C# |

CNA.NET admits exactly one reviewed CNA C ABI generation at a time
(`../cna-cs/docs/native-abi-compatibility.md`). If `../cna`'s `modules/c-api/include/CNA/C/abi.h`
and that matrix disagree, migrate the binding (review the new generation into the matrix) -- never
widen the matrix to make a sample run.

## Eligibility: which samples may be attempted

A sample is in scope when **both** hold:

1. it is published in the `../samples.libcna.com` gallery; and
2. its C++ CNA port runs (the `SAMPLE-*` evidence under `/rv/tmp/samples` and the port in
   `../cna-samples`), not an evidence-backed non-port decision.

`SAMPLE-004` StockEffects and `SAMPLE-015` TicTacToe have no C++ port and are excluded.

The reason for the rule is attribution. If a sample has never run on C++ CNA, a failure here
cannot be assigned to the C# binding, to CNA, or to the sample; with a working C++ port beside it,
it can. Do not attempt an ineligible sample, even a small one, and do not promote a row in
`../cna-samples/plan.md` from this repository.

## Fidelity is the primary requirement

The original C# is the deliverable. The goal is that the checked-in `.cs` files are
**byte-identical** to `/rv/tmp/XNAGameStudio/Samples/<UpstreamDirectory>/`.

- Do not reformat, re-indent, re-encode or strip the UTF-8 BOM. Copy with `cp -a`.
- Do not rename types, members, files or namespaces.
- Do not delete `#if`/`#else` branches for platforms this configuration does not build.
- Do not "modernize": no implicit usings, no nullable annotations, no file-scoped namespaces, no
  target-typed `new`, no `var` sweep, no top-level statements.
- Do not add diagnostics, frame counters, screenshot hooks, help overlays or exit-after-N-frames
  logic to a sample's source. Deterministic runs are a launcher concern
  (`scripts/run-sample.sh --frames N`), not a source concern.

Everything needed to build the original C# belongs in the **project file**, which is ours to
write: target framework, `DefineConstants`, `GenerateAssemblyInfo`, content copying, the
`CNA.XnaCompat` reference. A setting in `samples/Directory.Build.props` is free; a character
changed in a `.cs` file is a recorded deviation.

### When a source edit is unavoidable

Some upstream C# genuinely cannot compile on .NET 8 — a reference to a type that only ever existed
on Xbox 360 or Windows Phone 7, for instance. Then, in this order:

1. If the API is XNA 4.0's, it belongs in `../cna-cs`. **Fix it there.**
2. If the gap is in CNA itself — a missing native behaviour, a wrong result, a crash below the
   binding — reduce it to the smallest native reproducer, **fix it in `../cna`** (or
   `../sharp-runtime` if it is below CNA) with a regression test at the lowest layer that can see
   it, record it in [`cna-bugs.md`](cna-bugs.md), and come back to the same sample. A row is `⛔`
   only while such a fix is in progress or genuinely needs something outside these repositories.

   A record must separate what is established from what is not. A comparison against a C++ port
   built from a different CNA revision is not evidence, and saying so is what stops it being quoted
   as such later.
3. If the API is not XNA's but a Windows Phone SDK one (`Microsoft.Devices`, ...), it goes into the
   separate opt-in phone compatibility assembly of `../cna-cs`, never into the strict XNA facade.
4. A sample without its own `Main` (its host supplied one) gets an external host project around the
   unchanged source.
5. Only when none of these applies is the source edited. Make the smallest possible edit, keep the
   original line in a comment beside it, and record it in `missing.md` under *Source deviations*
   with the exact upstream text, the replacement, and why no project-file setting could do it.

An unrecorded source edit is the one failure mode this repository exists to avoid. A row with an
undocumented `.cs` difference is not `✅`, however well it runs.

## Content and `.xnb` policy

- CNA reads `.xnb` and cannot write it. **No content is built in this repository.**
- The content must be **official XNA Content Pipeline output**. The C++ campaign's retained pipeline
  output (`/rv/tmp/samples/SAMPLE-nnn-*/xna4-original/**/bin/**/Content/`) and
  `../cna-samples/samples/<Port>/Content/` are where it lives: re-deriving it here would add risk and
  prove nothing.
- **Check what the port actually ships before copying it.** A C++ port may carry a CNA-native asset
  instead of the compiled one — `CSSAMPLE-002`'s font is `hudfont.cnj`, regenerated because of a
  premultiplied-alpha difference. Copying that here would be wrong twice: the original C# calls
  `Content.Load<SpriteFont>("hudfont")`, which is an `.xnb` contract, and a CNA-native substitute is
  the runtime substitution this policy forbids. Use the pipeline output the campaign retained in its
  artifact root instead (`/rv/tmp/samples/SAMPLE-nnn-*/xna4-original/**/bin/**/Content/`), and record
  which source was used and why.
- Record the source path and a hash summary in the sample's `missing.md`.
- Do not check in content *source* assets — `.fbx`, `.tga`, `.wav`, `.spritefont`, `.fx`. They are
  inputs to a pipeline this repository does not run. The upstream directory keeps them; cite it.
- Never substitute a loose `.png` for an `.xnb`, hand-build an asset, or add a sidecar.

## Definition of done for one sample

A row may become `✅` only when all of these hold:

1. **Selected configuration recorded.** Which upstream `.sln`/`.csproj` and which platform
   configuration this row builds, and which `DefineConstants` that configuration set.
2. **Sources verbatim.** `diff -r` against the upstream directory reports no difference in any
   `.cs` file, or every difference is listed in `missing.md` under *Source deviations*.
3. **Content provenance.** Every `.xnb` matches its `../cna-samples` counterpart bit for bit.
4. **Builds clean.** `dotnet build -c Debug` and `-c Release` succeed. Warnings are expected from
   2010-era C# and are listed, not suppressed with a blanket `NoWarn`.
5. **Runs.** The sample starts against the native CNA library on `OPENGLES3`, renders, accepts its
   original input, and exits cleanly with code 0 through its own original exit path. Runs happen on
   a private display (`scripts/run-sample.sh`, `scripts/capture-sample.sh`), never the owner's.
6. **Compared with the C++ port.** The corresponding C++ port and its evidence are the reference
   for what correct looks like: same geometry and conditions, pixel comparison where the C++
   evidence supports it, synchronized frames or stable regions for animated scenes, and the method
   recorded.
7. **`missing.md` current.** Selected configuration, deviations, content provenance, binding fixes,
   build/run commands, and what was and was not exercised.
8. **Committed by explicit file list**, with the row's task id in the message.

Anything less is `🛠`. A sample blocked by a CNA defect that is being fixed is `⛔` and its `missing.md` names the
defect and where its fix lives.

## Scope boundaries

- **Browser and Android** runs of these samples come after the desktop rows and are qualified only
  by real runs (a real browser; a real Android runtime).
- **Renderers other than `OPENGLES3`** are not this repository's baseline.
- **Re-auditing a C++ port** is not this repository's job; its evidence is taken as the reference.

## Build rules

The openeggbert-wide build rules in `../CLAUDE.md` apply in full, and matter most for the native
dependency:

- Reuse `../cna`'s existing build tree. `scripts/build-native-cna.sh` looks for a usable one
  (OPENGLES3 with compiled effects, `build-probe` today) and only configures
  `cmake-build-release-capi` when none exists.
- Never build in `/tmp` or the session scratchpad.
- At most `-j8` (owner rule, memory is shared).
- Always pass `ccache` launchers to a CMake configure.

.NET output (`bin/`, `obj/`) stays inside each sample directory and is git-ignored.

## Per-sample workflow

1. Find the row in [`plan.md`](plan.md); set it `🛠`.
2. Read the upstream directory. Identify the runnable Windows project, its configuration, its
   `DefineConstants`, its content project and any library projects it references.
3. `cp -a` the upstream project directories into `samples/<Name>/`. Do not touch a byte.
4. Copy `Content/` from `../cna-samples/samples/<Port>/Content/` and verify the hashes.
5. Write `samples/<Name>/<Name>.csproj` — as small as the shared props allow — and add it to
   `CnaCsSamples.sln`.
6. `dotnet build -c Debug` and `-c Release`. Compile errors are triaged with the ladder above:
   binding fix, CNA report, or (last) a recorded source deviation.
7. Run it with `scripts/run-sample.sh`, headless and windowed. Exercise the original controls and
   the original exit path.
8. Compare against `../cna-samples/samples/<Port>/` and its `missing.md`.
9. Write `samples/<Name>/missing.md`.
10. Update the `plan.md` row and `NEXT.md`.
11. Commit `cna-cs-samples` by explicit file list; commit `../cna-cs`, `../cna` or
    `../sharp-runtime` separately in their own repositories if they were fixed. Do not push unless
    the owner asks.

## Owner decision boundary

Continue without interrupting the owner. Large subsystems in `../cna-cs`/`../cna`, cross-repository
fixes, phone compatibility and sample hosts are authorized. Stop only for something genuinely
outside these repositories (a toolchain, a device, a legal question), state the measured scope, and
continue with the next sample meanwhile.
