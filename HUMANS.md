# HUMANS.md

How to add a known-broken entry and check it before merge. File layout, gate rules, and invariants are in [AGENTS.md](AGENTS.md).

## Quick start

`scripts/check-schema.sh` needs `jq` on your `PATH`. From the repo root, check every list:

```sh
scripts/check-schema.sh
```

`gate` runs that same script (see `.gate.toml`). Pass paths to check a subset:

```sh
scripts/check-schema.sh lists/lethal-company.json
```

## Adding an entry

Edit `lists/<game>.json`. The `game` field must match the file name (without `.json`). One bad entry makes Mortar drop the whole list.

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
- `reason` is required: one non-empty sentence.
- `ids` names the mod on each site it is on; one known id is enough. Known keys are `thunderstore` and `smapi` (non-empty strings), `github` (`owner/repo`), and `nexus` / `curseforge` (positive integers).
- `gameVersions` is optional: constraints separated by spaces (`<`, `<=`, `>`, `>=`, `=`), limiting the entry to those game versions.
- `kind` is `broken` (the default), `superseded` (another mod does its job now), or `notRecommended`.
- `replacement` is optional: the package (`Namespace-Name`) to use instead.
- `dropIn` is optional, and only valid on a `superseded` entry that has a `thunderstore` id and a `replacement`: the replacement does everything the mod did for packs that depend on it. Mortar then counts it as meeting those dependencies and installs it in the mod's place. Set it only when every pack made for the mod works with the replacement.

Do not repeat an id (`site=value`) across entries in the same file.

## Publish

A push to `main` that changes `lists/*.json`, or a manual run of the `publish` workflow, is what players get. CI stamps a `serial`, signs with the `MORTAR_UPDATE_KEY` GitHub secret, and uploads `<game>.json`, `<game>.json.sig`, and `<game>.json.v2.sig` to the `lists` release. `.v2.sig` is signed over the list name plus the payload.

Merge only a verified entry. Do not put the update key or a signature in the repo.

Pull requests run `.github/workflows/schema.yml`, which is `scripts/check-schema.sh` on every `lists/*.json` file.
