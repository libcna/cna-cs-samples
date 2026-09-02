# CNA.NET Samples Instructions for Claude

Before doing any work in this repository, read [`rules.md`](rules.md) completely and follow it.
That applies to analysis, enabling a sample, builds, runs, documentation, commits and reviews.

Read [`plan.md`](plan.md) and the affected sample's `missing.md` as well. The openeggbert-wide
build rules in `../CLAUDE.md` apply in full, and matter most for `../cnanext`'s native build tree:
reuse it, never build under `/tmp` or the scratchpad.

The one thing to understand before touching anything: **this repository does not port samples.**
The original Microsoft C# is checked in as close to verbatim as .NET 8 allows, and everything
needed to build it lives in the project file. A character changed in a `.cs` file is a deviation
that must be recorded; a setting added to `samples/Directory.Build.props` is free.

`../cna-cs` is the only dependency this repository may fix. A defect in `../cnanext` or
`../sharp-runtimenext` is written up in the sample's `missing.md`, the row goes `⛔`, and the next
sample begins.

Start with [`NEXT.md`](NEXT.md)'s **Active handoff**: it names the row to work on next, the
synchronized head of every repository in the chain, and what the last session left open.
