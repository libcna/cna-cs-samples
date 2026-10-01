#!/usr/bin/env bash
# Writes a STAND-IN for an XNA 4.0 Song: <out>/<name>.wma encoded by ffmpeg from the game's own
# source file, and <out>/<name>.xnb in the layout XNA's SongProcessor writes (SongReader, the .wma
# file name, the duration in milliseconds). XNA's SongProcessor encodes through the Windows Media
# Format SDK's writer (XnaMediaHelper_1.dll -> WMVCore.DLL), which does not run under Wine 10 even
# with WMF 11 installed, so scripts/build-xna-content.sh cannot build songs. A stand-in is not
# official pipeline output: a game's evidence names every asset made this way.
#
# Usage: scripts/song-standin.sh <source.mp3|wav> <out-dir> <asset-name>
# The encoding matches an official XNA song (Platformer's): WMA v2, 48 kHz, stereo, 128 kbit/s.
set -euo pipefail
source="$1"; out="$2"; name="$3"
mkdir -p "$out"
ffmpeg -nostdin -loglevel error -y -i "$source" -map 0:a -c:a wmav2 -ar 48000 -ac 2 -b:a 128k "$out/$name.wma"
duration_ms="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$out/$name.wma" | awk '{ printf "%d", $1 * 1000 + 0.5 }')"
python3 - "$out/$name.xnb" "$name.wma" "$duration_ms" <<'PYEOF'
import struct, sys
path, stream, duration = sys.argv[1], sys.argv[2].encode(), int(sys.argv[3])
def string(b):
    out, n = bytearray(), len(b)
    while n >= 0x80:
        out.append(n & 0x7F | 0x80); n >>= 7
    return bytes(out) + bytes([n]) + b
body = b"\x01" + string(b"Microsoft.Xna.Framework.Content.SongReader") + struct.pack("<i", 0) + b"\x00" + b"\x01" \
       + string(stream) + struct.pack("<i", duration)
open(path, "wb").write(b"XNBw\x05\x00" + struct.pack("<I", 10 + len(body)) + body)
PYEOF
echo "stand-in song: $out/$name.xnb ($duration_ms ms)"
