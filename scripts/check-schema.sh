#!/bin/sh
# Mirrors Mortar's DecodeBrokenList plus the JSON types it unmarshals into: one bad entry makes Mortar drop the whole list.
# Mortar's decoder lives in an internal package another module cannot import, so its rules are ported here.
set -e
if [ "$#" -eq 0 ]; then
  set -- lists/*.json
fi
for f in "$@"; do
  [ -f "$f" ] || {
    echo "check-schema: $f does not exist" >&2
    exit 1
  }
  jq -e --arg game "$(basename "$f" .json)" '
    def str: type == "string" and length > 0;
    def num: type == "number" and . > 0 and . == floor;
    def idok: (.thunderstore // "x" | str) and (.smapi // "x" | str) and (.github // "x" | str)
      and (.nexus // 1 | num) and (.curseforge // 1 | num);
    def hasKnownId: any(to_entries[]; (.key | IN("thunderstore", "smapi", "github", "nexus", "curseforge")) and .value != null);
    .game == $game and (.entries | type == "array")
    and all(.entries[];
      (.through | str) and (.reason | str)
      and (.ids | type == "object" and length > 0 and idok and hasKnownId)
      and ((.kind // "broken") | IN("broken", "superseded", "notRecommended"))
      and (.gameVersions // "x" | str) and all((.gameVersions // "" | split("[ \\t\\n\\r]+"; "g") | map(select(length > 0)))[]; test("^(<=|>=|<|>|=)\\S+$")) and (.replacement // "x" | str) and (.dropIn // false | type == "boolean")
      and ((.dropIn | not) or (.kind == "superseded" and (.replacement | str) and (.ids.thunderstore | str))))
    and ([.entries[].ids | to_entries[] | "\(.key)=\(.value)"] | length == (unique | length))
  ' "$f" >/dev/null || {
    echo "check-schema: $f is invalid or has a duplicate id" >&2
    exit 1
  }
done
