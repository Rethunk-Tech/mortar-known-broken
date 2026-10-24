# Mortar known-broken lists

One file per game in `lists/`, naming mods that are known not to work. Mortar downloads the list of each game a player
has set up, checks its signature and marks the listed versions as broken wherever the mod appears.

```json
{
  "game": "lethal-company",
  "entries": [
    {
      "ids": { "thunderstore": "Namespace-Name", "smapi": "UniqueID", "nexus": 123, "curseforge": 123, "github": "owner/repo" },
      "through": "1.2.3",
      "gameVersions": ">=50",
      "reason": "One sentence on what goes wrong.",
      "replacement": "Namespace-Name"
    }
  ]
}
```

- `through` is required: that version and older are broken; a newer version is taken to be fixed.
- `gameVersions` is optional: constraints separated by spaces (`<`, `<=`, `>`, `>=`, `=`), limiting the entry to those
  game versions.
- `ids` names the mod on each site it is on; one is enough.

A push to `main` that changes a list publishes it: CI stamps a serial, signs it, and uploads `<game>.json` and
`<game>.json.sig` to the `lists` release.
