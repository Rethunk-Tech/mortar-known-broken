<h1 align="center">Mortar known-broken lists</h1>

<div align="center">

[![schema](https://github.com/Rethunk-Tech/mortar-known-broken/actions/workflows/schema.yml/badge.svg)](https://github.com/Rethunk-Tech/mortar-known-broken/actions/workflows/schema.yml)

</div>

---

This repo is the source for the signed JSON lists Mortar downloads. There is one file per game under `lists/`. Each file names mods (and the versions they fail through) so Mortar can flag those versions wherever the mod appears.

Mortar fetches the list for every game a player has set up, checks the signature, and applies the entries. Editors change the JSON in this repository. A merge to `main` is what stamps a serial, signs the file, and uploads it.

## Quick start

Check every list with the same rules Mortar uses when it decodes one:

```sh
scripts/check-schema.sh
```

How to add an entry, which fields are required, and what merge publishes are in [HUMANS.md](HUMANS.md).

## Highlights

- One JSON file per game in `lists/`, each with a `through` version and a reason sentence per entry
- `scripts/check-schema.sh` (the `gate` target in `.gate.toml`) rejects a list Mortar would drop, including duplicate ids
- A push to `main` that changes `lists/*.json` signs the file with the `MORTAR_UPDATE_KEY` secret and uploads `<game>.json`, `.sig`, and `.v2.sig` to the `lists` release

## Documentation

| Doc | What it covers |
| --- | --- |
| [HUMANS.md](HUMANS.md) | Adding entries, field meanings, checking, publish |
| [AGENTS.md](AGENTS.md) | Layout, gate rules, invariants |
| [LICENSE](LICENSE) | License text |

## License

Apache License 2.0. See [LICENSE](LICENSE).
