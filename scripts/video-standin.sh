#!/usr/bin/env bash
# Writes a STAND-IN for an XNA 4.0 Video: the game's own video file copied unchanged to
# <out>/<name>.wmv, and <out>/<name>.xnb in the layout XNA's VideoWriter writes (VideoReader, then
# the file name, duration in milliseconds, width, height, frame rate and soundtrack type, each a
# dispatched object). XNA's VideoProcessor does nothing else -- it copies the .wmv beside the asset
# and records what Windows Media Format measured -- but it measures through WMF, which does not run
# under Wine, so scripts/build-xna-content.sh cannot build videos. Here ffprobe measures instead,
# and the soundtrack type is VideoProcessor's default (Music). A stand-in is not official pipeline
# output: a game's evidence names every asset made this way.
#
# Usage: scripts/video-standin.sh <source.wmv> <out-dir> <asset-name>
set -euo pipefail
source="$1"; out="$2"; name="$3"
mkdir -p "$out"
cp "$source" "$out/$name.wmv"
probe() { ffprobe -v error -select_streams v:0 -show_entries "$1" -of csv=p=0 "$source"; }
duration_ms="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$source" | awk '{ printf "%d", $1 * 1000 + 0.5 }')"
width="$(probe stream=width)"; height="$(probe stream=height)"
fps="$(probe stream=r_frame_rate | awk -F/ '{ printf "%.6f", ($2 ? $1 / $2 : $1) }')"
python3 - "$out/$name.xnb" "$name.wmv" "$duration_ms" "$width" "$height" "$fps" <<'PYEOF'
import struct, sys
path, stream = sys.argv[1], sys.argv[2].encode()
duration, width, height, fps = int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5]), float(sys.argv[6])
def varint(n):
    out = bytearray()
    while n >= 0x80:
        out.append(n & 0x7F | 0x80); n >>= 7
    return bytes(out) + bytes([n])
def string(b):
    return varint(len(b)) + b
readers = [b"Microsoft.Xna.Framework.Content.VideoReader, Microsoft.Xna.Framework.Video, Version=4.0.0.0, "
           b"Culture=neutral, PublicKeyToken=842cf8be1de50553",
           b"Microsoft.Xna.Framework.Content.StringReader", b"Microsoft.Xna.Framework.Content.Int32Reader",
           b"Microsoft.Xna.Framework.Content.SingleReader"]
body = varint(len(readers)) + b"".join(string(r) + struct.pack("<i", 0) for r in readers) + varint(0)
body += varint(1) + varint(2) + string(stream)
for value in (duration, width, height):
    body += varint(3) + struct.pack("<i", value)
body += varint(4) + struct.pack("<f", fps) + varint(3) + struct.pack("<i", 0)
open(path, "wb").write(b"XNBw\x05\x00" + struct.pack("<I", 10 + len(body)) + body)
PYEOF
echo "stand-in video: $out/$name.xnb ($duration_ms ms, ${width}x$height, $fps fps)"
