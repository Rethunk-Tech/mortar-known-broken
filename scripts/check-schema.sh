#!/bin/sh
set -e
if [ "$#" -eq 0 ]; then
  set -- lists/*.json
fi
for f in "$@"; do
  [ -f "$f" ] || continue
  jq -e '.game and (.entries | type == "array") and all(.entries[]; .through and .reason and (.ids | length > 0) and ((.kind // "broken") | IN("broken", "superseded", "notRecommended")))' "$f" >/dev/null
done
