#!/usr/bin/env bash
# Writes an Ogg Vorbis copy beside every Windows Media Audio file under an XNA content directory.
# XNA's SongProcessor writes each song as .wma, which neither CNA nor FNA decodes; both, and CNA.NET
# (CSX-105), play the .ogg beside the .wma a song's .xnb names. The .xnb and the .wma stay as they
# are. This is the one conversion an FNA port of the same game makes.
#
# Usage: scripts/convert-xna-songs.sh <content-dir>
set -euo pipefail
dir="$1"
[ -d "$dir" ] || { echo "error: $dir is not a directory" >&2; exit 2; }
find "$dir" -iname '*.wma' -print0 | while IFS= read -r -d '' wma; do
    ogg="${wma%.*}.ogg"
    [ -f "$ogg" ] && continue
    ffmpeg -nostdin -loglevel error -i "$wma" -map 0:a -c:a libvorbis -q:a 5 "$ogg"
    echo "$ogg"
done
