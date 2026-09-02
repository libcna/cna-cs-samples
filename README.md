# CNA.NET Samples

The official **Microsoft XNA Game Studio 4.0** sample collection — still in its original C# —
running on [CNA](https://github.com/openeggbert/cna) through the
[CNA.NET](https://github.com/openeggbert/cna-cs) binding, on .NET 8.

This is not a port. The sibling [`cna-samples`](https://github.com/openeggbert/cna-samples)
repository is the C++ port campaign; here the upstream C# files are checked in as close to
verbatim as .NET 8 permits, and everything that has to change to make them build and run lives in
the project file, not in the sample's code. Each sample's `missing.md` lists every byte that
differs from upstream, and why.

```text
original C# XNA sample          ← unchanged
        ↓
CNA.XnaCompat                   Microsoft.Xna.Framework facade   (../cna-cs)
        ↓
CNA.Framework → CNA.Interop     P/Invoke boundary                (../cna-cs)
        ↓
CNA C ABI → CNA C++             native runtime                   (../cnanext)
```

## Prerequisites

| Tool | Version |
|---|---|
| .NET SDK | 8.0 or later |
| CNA.NET | sibling checkout, `../cna-cs` (or `../_bindings/cna-cs`) |
| CNA | sibling checkout, `../cnanext`, built with `CNA_GRAPHICS_RENDERER=OPENGLES3` |
| A GL ES 3 capable display | or `xvfb-run` for headless runs |

CNA.NET pins one reviewed CNA C ABI generation at a time, so the two checkouts must agree; see
`../cna-cs/docs/native-abi-compatibility.md`.

## Building and running

```bash
scripts/build-native-cna.sh          # builds ../cnanext's C ABI library, reusing its build tree
dotnet build CnaCsSamples.sln -c Release
scripts/run-sample.sh PrimitivesSample
```

`scripts/run-sample.sh` resolves the native library, sets `CNA_NATIVE_LIBRARY` and starts the
sample; `--headless` wraps it in `xvfb-run`, and `--frames N` runs a fixed-length deterministic
pass. Any additional arguments are forwarded to the sample unchanged.

## Scope

Only samples the C++ campaign has already finished and proved are eligible here: a sample must be
`✅` in `../cna-samples/plan.md` **and** have a real port behind that mark. A sample that does not
yet work on C++ CNA is not attempted, because a failure here could not be attributed. See
[plan.md](plan.md) for the eligible inventory and the current state of each row.

Compiled content (`.xnb`) is copied byte-for-byte from `../cna-samples`. CNA reads `.xnb` and
cannot produce it, so no content is built in this repository.

`../cna-cs` is the only dependency this repository fixes. A defect below the C ABI is recorded in
[cna-bugs.md](cna-bugs.md) with a reproduction script instead, because CNA is not ours to change
from here.

## License

Microsoft Permissive License (Ms-PL) — see [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md).
The samples are derived from the XNA Game Studio 4.0 sample collection © Microsoft Corporation.
