# CLAUDE.md - MMOSkillTamingPack

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
is also gated on the `mmoskilltree:feature` factor (`Param: "taming"`) so it stays
hidden too. Nothing here
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
├── Server/MMOSkillTree/
│   ├── Control/MMOSkillTamingPack.json          add mode for XpMaps/CommandRewards
│   ├── XpMaps/MMOSkillTamingPack.json           TAMING source -> XP overrides
│   └── CommandRewards/MMOSkillTamingPack.json   per-level boost-token rewards (auto-claim)
└── Server/ZiggfreedCommon/
    ├── Quests/MMOSkillTree/Taming/*.json        progression (REACH_LEVEL) + repeatable daily/weekly quests (BREED_ANIMAL / FEED_ANIMAL / HARVEST_ANIMAL / GAIN_XP)
    └── Achievements/MMOSkillTree/Taming/*.json  Tamer level ladder (REACH_LEVEL); breeding / feeding / harvesting / companion-combat ladders (BREED_ANIMAL / FEED_ANIMAL / HARVEST_ANIMAL / COMPANION_COMBAT); Bloodline (GAIN_XP)
```

## Conventions (native quest/achievement assets)

- Quests and achievements are ziggfreed-common's native Pattern A assets (the
  `QuestAsset` / `AchievementAsset` codecs), NOT the mastery pack's `Name`/`Payload`
  raw-Payload template DSL. The **filename is the id** (lower-cased); `MMOSkillTree`
  and `Taming` are plain organizational folders that do not affect the id, so
  renaming either folder is free but renaming a *file* renames the id (and starts
  any in-progress player over on that quest/achievement).
- Every entry gates on the `taming` feature via `Requires.Factors`:
  `{"Factor": "mmoskilltree:feature", "Param": "taming", "Min": 1}`, the native
  replacement for the old `requiresFeatures` list.
- Quest steps and achievement criteria share one leaf set (`Kind`/`Target`/
  `MatchMode`/`Qualifier`/`Amount`/`Zone`/`TextKey`). `REACH_LEVEL` and `GAIN_XP`
  still match `Target` against the skill id (`"TAMING"`) with `MatchMode: "EXACT"`.
  Companion-activity kinds (`BREED_ANIMAL`, `FEED_ANIMAL`, `HARVEST_ANIMAL`,
  `COMPANION_COMBAT`) fire one per companion feed / harvest / breed / combat event
  through the Tamework integration; omit `Target` for "any companion" (there is no
  per-species filter) and omit `MatchMode` (unauthored already means the forgiving
  `CONTAINS`).
- **Achievement `Criteria` is an ordered array and the order is the persistence
  contract**: progress is stored by each entry's position (`"<id>#<index>"`), so
  appending a criterion is safe but inserting, removing, or reordering one moves
  every player's progress onto a different criterion. Every achievement here is
  still single-criterion, so this pack never has to think about it, but do not
  reorder `Criteria` on a future multi-step achievement without a migration.
- Level ladders (Tamer I/II/III/Grandmaster), breeding ladders (First Litter through
  Living Legend), and the feeding/harvesting/combat ladders each declare themselves
  on `Listing.Chains: [{"Id": "taming_tamer", "Tier": 2}]` - the shared ladder leaf,
  so the page draws a whole climb as one entry with the rung a player is on. `Id` is
  the ladder (`taming_tamer`, `taming_breeder`, `taming_caretaker`, `taming_forager`,
  `taming_warbeasts`), `Tier` the rung counting from 1, and `SortOrder` still places
  the entry on the page. `Listing.Subcategory` (`"taming"`) groups them all together.
- Rewards are `RewardEntryAsset` (`Kind` + `Params`), not the old `type`/scalar-field
  form: `{"Kind": "xp", "Params": {"Skill": "TAMING", "Amount": "..."}}` and
  `{"Kind": "boost_token", "Params": {"Skill": "TAMING", "Multiplier": "...",
  "DurationMinutes": "..."}}` are the two kinds this pack authors, on a quest's
  `Rewards` or an achievement's `Rewards` (instant) / `ClaimRewards` (collected
  later). This pack needs no currency and no extra features beyond `"taming"`.
- Display text is localization keys only, never a raw name: `Text.TitleKey` /
  `Text.FlavorKey` point at the `quest.<id>.title|flavor` / `achievement.<id>.title|desc`
  keys this pack already ships in `Server/Languages/en-US/mmoskilltree.lang`
  (the sibling `Languages/<locale>/` files carry the translations; a locale
  fan-out fills them in, this file is never hand-edited per locale).
- `CommandRewards/MMOSkillTamingPack.json` (the level 15/50/100 boost payouts) is
  unaffected by this rewrite: it stays the old raw-Payload asset type, still uses
  `BOOST_TOKEN`-style `/mmoboost give --args={player}|TAMING|<mult>|<minutes>`
  commands (the pipe blob must travel in `--args=`; the Hytale parser never binds
  optional args positionally).

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
2. Start the server; in the log confirm `[Integrations] Taming: activated ...`,
   the `pack layer applied` lines for Xp-maps / CommandRewards, and the six quests
   plus nineteen achievements loading from the native ZiggfreedCommon asset stores.
   No `Asset validation FAILED` lines.
3. With Animal Husbandry absent, confirm the Taming skill and all of this pack's content
   are hidden, and feeding/breeding a companion grants no MMO XP.
