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
      "kind": "broken",
      "reason": "One sentence on what goes wrong.",
      "replacement": "Namespace-Name",
      "dropIn": true
    }
  ]
}
```

- `through` is required: that version and older are broken; a newer version is taken to be fixed.
- `gameVersions` is optional: constraints separated by spaces (`<`, `<=`, `>`, `>=`, `=`), limiting the entry to those
  game versions.
- `kind` is `broken` (the default), `superseded` (another mod does its job now) or `notRecommended`.
- `replacement` is optional: the package (`Namespace-Name`) to use instead.
- `dropIn` is optional, on a `superseded` entry with a `thunderstore` id and a `replacement`: the replacement does
  everything the mod did for packs that depend on it. Mortar then counts it as meeting those dependencies and installs it
  in the mod's place. Set it only when every pack made for the mod works with the replacement.
- `ids` names the mod on each site it is on; one is enough.

A push to `main` that changes a list publishes it: CI stamps a serial, signs it, and uploads `<game>.json` and
`<game>.json.sig` to the `lists` release.
