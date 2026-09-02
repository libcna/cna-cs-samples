# Third-Party Notices

## XNA Game Studio 4.0 Sample Collection

The samples in this repository are the **original C#** samples of the official
**Microsoft XNA Game Studio 4.0** sample collection, published by Microsoft Corporation under
the **Microsoft Permissive License (Ms-PL)**.

Original samples copyright © Microsoft Corporation. All rights reserved.

The original C# source code is archived at:
https://github.com/SimonDarksideJ/XNAGameStudio

Unlike a port, this repository keeps that C# as close to verbatim as the .NET 8 toolchain
permits. Every deviation from the upstream bytes is recorded in the affected sample's
`missing.md`.

---

## CNA.NET (`cna-cs`)

The samples compile against **CNA.NET**, the C#/.NET binding that supplies the
`Microsoft.Xna.Framework` API surface on top of CNA's C ABI.

CNA.NET is developed by the OpenEggbert project.

---

## CNA

CNA.NET's `CNA.Interop` layer loads **CNA**, a C++ reimplementation of the XNA 4.0 programming
model built on SDL3.

CNA is developed by the OpenEggbert project and is available at:
https://github.com/openeggbert/cna

---

## sharp-runtime

CNA transitively depends on **sharp-runtime**, a C++ port of selected .NET BCL types. It is an
implementation detail of the native layer; the samples in this repository run on the real .NET
BCL and never see it.

sharp-runtime is developed by the OpenEggbert project and is available at:
https://github.com/openeggbert/sharp-runtime

---

## Compiled content (`.xnb`)

The `.xnb` files shipped beside a sample are output of the **original Microsoft XNA Content
Pipeline**. They are taken byte-for-byte from the sibling
[`cna-samples`](https://github.com/openeggbert/cna-samples) repository, which generated and
verified them against the official pipeline. CNA reads `.xnb`; it does not produce it.
