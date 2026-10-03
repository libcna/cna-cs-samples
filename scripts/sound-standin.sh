#!/usr/bin/env bash
# Writes a STAND-IN for an XNA 4.0 SoundEffect: <out>/<name>.xnb in the layout XNA's
# SoundEffectProcessor writes at its default quality (Best, PCM): a WAVEFORMATEX, the 16-bit PCM
# data, the loop region (the whole sound) and the duration in milliseconds. XNA reads .mp3 and .wma
# sources through the Windows Media Format SDK (Mp3Importer, WmaImporter), which does not run under
# Wine, so ffmpeg decodes the game's own source file here instead. A stand-in is not official
# pipeline output: a game's evidence names every asset made this way.
#
# Usage: scripts/sound-standin.sh <source.mp3|wma> <out-dir> <asset-name>
set -euo pipefail
source="$1"; out="$2"; name="$3"
mkdir -p "$out"
work="$(mktemp -d "${TMPDIR:-/tmp}/sound-standin.XXXXXX")"
trap 'rm -rf "$work"' EXIT
ffmpeg -nostdin -loglevel error -y -i "$source" -map 0:a -c:a pcm_s16le -f wav "$work/sound.wav"
python3 - "$work/sound.wav" "$out/$name.xnb" <<'PYEOF'
import struct, sys, wave
source, path = sys.argv[1], sys.argv[2]
with wave.open(source, "rb") as w:
    channels, width, rate, frames = w.getnchannels(), w.getsampwidth(), w.getframerate(), w.getnframes()
    data = w.readframes(frames)
def string(b):
    out, n = bytearray(), len(b)
    while n >= 0x80:
        out.append(n & 0x7F | 0x80); n >>= 7
    return bytes(out) + bytes([n]) + b
block = channels * width
fmt = struct.pack("<HHIIHHH", 1, channels, rate, rate * block, block, width * 8, 0)
duration = int(frames * 1000 / rate + 0.5)
body = b"\x01" + string(b"Microsoft.Xna.Framework.Content.SoundEffectReader") + struct.pack("<i", 0) + b"\x00" + b"\x01" \
       + struct.pack("<i", len(fmt)) + fmt + struct.pack("<i", len(data)) + data \
       + struct.pack("<iii", 0, frames, duration)
open(path, "wb").write(b"XNBw\x05\x00" + struct.pack("<I", 10 + len(body)) + body)
print(f"stand-in sound: {path} ({duration} ms, {channels} ch, {rate} Hz)")
PYEOF
