# CLAUDE.md — MMOSkillTamingPack

A **standalone Hytale content pack** that ships the Taming skill's content for
the [MMOSkillTree mod](https://www.curseforge.com/hytale/mods/mmo-skill-tree): quests,
achievements, per-level boost rewards, and the Taming XP map.

## How the Taming skill activates

The TAMING skill is built into the MMOSkillTree jar but **gated on the
`"taming"` feature**, which is on only while the `AlecsTameworkAdapter`
integration is active. Players get companions from [Alec's Animal Husbandry](https://www.curseforge.com/hytale/mods/alecs-animal-husbandry),
which runs on the [Alec's Tamework](https://www.curseforge.com/hytale/mods/alecs-tamework)
API; the adapter listens to Tamework's companion events. When that integration is
absent the skill is hidden everywhere and earns no XP, and every entry in this pack
is also gated on `requiresFeatures: ["taming"]` so it stays hidden too. Nothing here
defines the skill itself; a content pack cannot ship a skill (skills are code-backed).
This pack only ships content that references the skill.

## XP source mapping

The adapter credits TAMING XP per companion activity by reading the `TAMING`
xp-map keyed by `CompanionXpSource` enum name. This pack's
`XpMaps/MMOSkillTamingPack.json` is the tunable override of the in-jar defaults
(`TamingDefaults`):

| Source                | Default | Notes |
|-----------------------|---------|-------|
| `FEED`                | 1       | feeding + drinking (hunger/thirst) - tiny passive trickle |
| `HARVEST`             | 5       | harvesting companion drops - medium |
| `BREEDING`            | 25      | breeding - largest award |
| `COMBAT_DAMAGE_DEALT` | 1       | small; combat is the most abusable source |
| `COMBAT_DAMAGE_TAKEN` | 0       | disabled (author guidance) |
| `CUSTOM`              | 0       | no XP for custom sources |

`0` or `-1` for a source means no XP. Server owners retune by editing the
`TAMING` block in `mods/mmoskilltree/xp-maps.json`, which wins over this pack.

## Layout

```
taming-pack/
├── manifest.json
├── build.ps1                                    forward-slash zip + deploy
└── Server/MMOSkillTree/
    ├── Control/MMOSkillTamingPack.json          add mode for XpMaps/Quests/Achievements/CommandRewards
    ├── XpMaps/MMOSkillTamingPack.json           TAMING source -> XP overrides
    ├── Quests/*.json                            progression (REACH_LEVEL) + repeatable daily/weekly quests (BREED_ANIMAL / FEED_ANIMAL / HARVEST_ANIMAL / GAIN_XP)
    ├── Achievements/*.json                      Tamer level chain (REACH_LEVEL); breeding / feeding / harvesting / companion-combat chains (BREED_ANIMAL / FEED_ANIMAL / HARVEST_ANIMAL / COMPANION_COMBAT); Bloodline (GAIN_XP)
    └── CommandRewards/MMOSkillTamingPack.json   per-level boost-token rewards (auto-claim)
```

## Conventions (same as the mastery pack)

- Asset key = filename in PascalCase; the inner `Name` echoes it. `Payload` is a
  nested JSON object (not an escaped string).
- Quest / achievement runtime ids come from the inner Payload `id` (lowercase).
- Quest + achievement `REACH_LEVEL` objectives match `target` against the skill
  id (`"TAMING"`) case-insensitively, so use `target: "TAMING"` (not `"*"`).
- Companion-activity goals use the `BREED_ANIMAL`, `FEED_ANIMAL`, `HARVEST_ANIMAL`,
  and `COMPANION_COMBAT` objective / trigger types (requires MMO Skill Tree 1.1.7+,
  which fires one per companion feed / harvest / breed / combat event through the
  Tamework integration). Use `target: ""` (any companion); there is no per-species
  filter. Lifetime-XP goals use `GAIN_XP` with `target: "TAMING"`.
- Rewards here use `BOOST_TOKEN` (`skill` + `multiplier` + `durationMinutes`) and
  the per-level `/mmoboost give --args={player}|TAMING|<mult>|<minutes>` command
  (the pipe blob must travel in `--args=`; the Hytale parser never binds
  optional args positionally), so the pack needs no currency and no extra
  features beyond `"taming"`.

## Release notes (patch-notes paradigm)

Per-version public release notes live in `patch-notes/<version>.md`, same paradigm as the main mod repo: YAML frontmatter (`version`, `title`, `type: patch-note`, `status: held|released`), a one-line summary, then user-facing `- **New/Fixed: ...**` bullets. No em-dashes. `patch-notes/_INDEX.md` lists them newest-first. `CURSEFORGE.md` is the public listing copy; keep its Versions table in sync with each release. (No docs-site publishing for packs yet.)

## Build & deploy

```powershell
.\build.ps1                  # build the zip, and install it if a Mods folder is known
.\build.ps1 -Install:$false  # build only, no copy
.\build.ps1 -ModsDir <path>  # build + install into an explicit folder
```

`build.ps1` is self-locating and cross-platform (Windows PowerShell, or `pwsh ./build.ps1` on macOS/Linux). The zip is named `MMOSkillTamingPack-<version>.zip` with the version read from `manifest.json` (single source); on install the script first removes any older `MMOSkillTamingPack*.zip` from the Mods folder so only the current version loads. To auto-install on build, set `HYTALE_MODS_DIR` once to your Hytale `UserData/Mods` folder (or pass `-ModsDir`); without it the script just builds the zip.

## Verification

1. Build + deploy this pack and the MMOSkillTree jar, plus Alec's Animal Husbandry (and its Alec's Tamework API dependency).
2. Start the server; in the log confirm `[Integrations] Taming: activated ...`
   and the `pack layer applied` lines for Xp-maps / Quests / Achievements /
   CommandRewards. No `Asset validation FAILED` lines.
3. With Animal Husbandry absent, confirm the Taming skill and all of this pack's content
   are hidden, and feeding/breeding a companion grants no MMO XP.
