#!/usr/bin/env python3
"""CSX-051: derive the C# sample corpus from the published gallery.

A sample is in scope when it is published in ../samples.libcna.com and its C++ CNA port exists in
../cna-samples (whose plan.md row says how far it got). For each one this reports the SAMPLE id,
the upstream Microsoft directory, the C++ evidence directory under /rv/tmp/samples, this
repository's row and status, and what the original C# needs from outside the strict XNA facade
(GamerServices, Net, Avatar, Windows Phone SDK) or whether it lacks its own Main.

Usage: scripts/gallery-inventory.py [--markdown OUT.md]

Everything is read from the sibling checkouts; nothing is cached, so a new gallery card shows up
on the next run.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
ROOT = HERE.parent
GALLERY = ROOT / "samples.libcna.com"
PORTS = ROOT / "cna-samples"
UPSTREAM = Path("/rv/tmp/XNAGameStudio/Samples")
EVIDENCE = Path("/rv/tmp/samples")

# What a sample actually uses, not what its using directives name: XNA's project template put
# `using Microsoft.Xna.Framework.GamerServices;` and `.Net;` into nearly every Game1.cs, and a
# namespace only has to exist for those to compile. "GS(using)" marks that case.
USES = {
    "GS": re.compile(r"\b(Guide|SignedInGamer|Gamer|GamerServicesComponent|GamerServicesDispatcher|GamerProfile|"
                     r"LeaderboardReader|LeaderboardWriter|AchievementCollection|GamerPresence)\b\s*[.(<\[]"),
    "Net": re.compile(r"\b(NetworkSession|PacketReader|PacketWriter|NetworkGamer|LocalNetworkGamer|"
                      r"AvailableNetworkSession)\b"),
    "Avatar": re.compile(r"\bAvatar(Description|Renderer|Animation)\b"),
    "Phone": re.compile(r"\bMicrosoft\.(Devices|Phone)\b"),
}
USING_ONLY = {
    "GS(using)": re.compile(r"^\s*using\s+Microsoft\.Xna\.Framework\.GamerServices\s*;", re.M),
    "Net(using)": re.compile(r"^\s*using\s+Microsoft\.Xna\.Framework\.Net\s*;", re.M),
}


def gallery_samples() -> list[str]:
    names = []
    for directory in sorted(GALLERY.iterdir()):
        if directory.is_dir() and any(directory.glob("*_cna_samples.html")):
            names.append(directory.name)
    return names


def plan_upstreams() -> dict[str, str]:
    """SAMPLE id -> upstream directory, from ../cna-samples/plan.md's task table."""
    rows = {}
    for line in (PORTS / "plan.md").read_text(encoding="utf-8").splitlines():
        match = re.match(r"\|\s*(SAMPLE-\d+)\s*\|\s*`([^`]+)`", line)
        if match:
            rows[match.group(1)] = match.group(2)
    return rows


UPSTREAMS: dict[str, str] = {}


def port_identity(name: str) -> tuple[str, str] | None:
    """The port's SAMPLE id is the first one its own records name; the upstream comes from plan.md."""
    directory = PORTS / "samples" / name
    for record in ("missing.md", "diff.md"):
        path = directory / record
        if not path.is_file():
            continue
        match = re.search(r"SAMPLE-\d+", path.read_text(encoding="utf-8", errors="replace"))
        if match and match.group(0) in UPSTREAMS:
            return match.group(0), UPSTREAMS[match.group(0)]
    return None


def plan_status(path: Path, task: str) -> str:
    if not path.is_file():
        return "?"
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith(f"| {task} "):
            return line.rstrip().rstrip("|").rsplit("|", 1)[-1].strip() or "?"
    return "-"


def cs_rows() -> dict[str, str]:
    manifest = HERE / "samples" / "manifest.tsv"
    rows = {}
    for line in manifest.read_text(encoding="utf-8").splitlines():
        if line.startswith("#") or not line.strip():
            continue
        fields = line.split("\t")
        rows[fields[1]] = fields[0]
    return rows


def upstream_needs(upstream: str) -> tuple[list[str], bool]:
    directory = UPSTREAM / upstream
    found = set()
    has_main = False
    for source in directory.rglob("*.cs"):
        text = source.read_text(encoding="utf-8-sig", errors="replace")
        code = "\n".join(l for l in text.splitlines() if not l.lstrip().startswith(("using ", "//")))
        for key, pattern in USES.items():
            if pattern.search(code):
                found.add(key)
        for key, pattern in USING_ONLY.items():
            if pattern.search(text):
                found.add(key)
        if re.search(r"\bstatic\s+(void|int)\s+Main\s*\(", text):
            has_main = True
    for key in ("GS", "Net"):
        if key in found:
            found.discard(f"{key}(using)")
    return sorted(found), has_main


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--markdown", type=Path)
    arguments = parser.parse_args()

    UPSTREAMS.update(plan_upstreams())
    rows = cs_rows()
    lines = [
        "| Gallery sample | SAMPLE | Upstream | C++ plan | Evidence | C# row | C# status | Needs | Main |",
        "|---|---|---|---|---|---|---|---|---|",
    ]
    problems = 0
    for name in gallery_samples():
        identity = port_identity(name)
        if identity is None:
            lines.append(f"| {name} | ? | ? | no port record | - | - | - | - | - |")
            problems += 1
            continue
        task, upstream = identity
        cpp = plan_status(PORTS / "plan.md", task)
        evidence = sorted(EVIDENCE.glob(f"{task}-*"))
        cs_task = task.replace("SAMPLE-", "CSSAMPLE-")
        cs_dir = rows.get(upstream, "-")
        cs = plan_status(HERE / "plan.md", cs_task)
        needs, has_main = upstream_needs(upstream)
        lines.append(
            f"| {name} | {task} | `{upstream}` | {cpp} | {'yes' if evidence else 'no'} | "
            f"{cs_dir} | {cs} | {', '.join(needs) or '-'} | {'yes' if has_main else '**no**'} |"
        )

    text = "\n".join(lines) + "\n"
    if arguments.markdown:
        arguments.markdown.write_text(
            "# Gallery inventory\n\n"
            "Generated by `scripts/gallery-inventory.py` from `../samples.libcna.com`, "
            "`../cna-samples` and `/rv/tmp`; do not edit by hand.\n\n" + text,
            encoding="utf-8",
        )
    else:
        sys.stdout.write(text)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
