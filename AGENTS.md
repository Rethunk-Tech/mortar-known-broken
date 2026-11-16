# AGENTS.md

Signed lists of mods known to be broken, one file per game in `lists/` (`lethal-company.json`, `riskofrain2.json`). Mortar downloads the list for each game a player has set up, checks the signature and flags the listed versions. The entry format is documented in `README.md`.

## Layout

- `lists/<game>.json`: `{"game": "<same as the file name>", "entries": [...]}`.
- `scripts/check-schema.sh`: the schema gate, a `jq` mirror of Mortar's `DecodeBrokenList` and the types it unmarshals into. One bad entry makes Mortar drop the whole list, so this must stay as strict as Mortar.
- `.github/workflows/publish.yml`: on a push to `main` that changes `lists/*.json` (or manual dispatch for all), stamps a serial, signs with the `MORTAR_UPDATE_KEY` secret and uploads `<game>.json`, `.sig` and `.v2.sig` to the `lists` release. `schema.yml` runs the check on pull requests.

## Gate

`gate` runs `scripts/check-schema.sh` (the one gate in `.gate.toml`); pass file paths to check a subset. It fails on a wrong `game`, a missing `through` or `reason`, an empty `ids`, an all-unknown id set, an unknown `kind`, a bad id type, `dropIn` unless `kind` is `superseded` with a thunderstore id and a replacement, or a duplicate id across entries.

## Invariants

- Every entry needs `through` (that version and older are broken) and one non-empty `reason` sentence.
- Merging to `main` publishes to every player. Merge only a verified entry, and never put the update key or a signature in the repo.
- If Mortar's decoder gains a field or a stricter rule, change `check-schema.sh` in step with it.
