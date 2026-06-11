# MMO Skill Tree - Taming Pack

Add a **Taming** skill to MMO Skill Tree that levels up as you care for your tamed companions.

This pack pairs [MMO Skill Tree](https://www.curseforge.com/hytale/mmoskilltree) with **[Alec's Animal Husbandry](https://www.curseforge.com/hytale/mods/alecs-animal-husbandry)**, the companion mod (built on the Alec's Tamework API that the Taming skill reads). Install them and the Taming skill switches on automatically. Without Animal Husbandry, the skill and all of this pack's content stay hidden, so it is safe to keep installed either way.

## What you get

- **Taming XP from your companions.** Feeding and watering your animals is a small steady trickle, harvesting their drops is worth more, and breeding gives the biggest reward. Combat experience is kept low to discourage grinding, and experience from damage your companions take is off by default.
- **Progression quests** - First Bond, Companion Keeper, and Beastmaster - each handing out a Taming experience boost.
- **Repeatable daily and weekly quests** - daily breeding and companion-care goals plus a weekly husbandry goal, all granting flat Taming XP.
- **Achievements for every companion activity** - a four-tier Tamer level chain to Grandmaster at level 100, a five-tier breeding chain (to 25,000 bred) plus a lifetime Taming XP milestone, and chains for feeding, harvesting, and companion combat.
- **Automatic boost rewards** at Taming levels 15, 50, and 100, including a powerful all-skill boost at the cap.

## Requirements

- [MMO Skill Tree](https://www.curseforge.com/hytale/mmoskilltree) (1.2.0 or newer for the breeding quests and achievements)
- [Alec's Animal Husbandry](https://www.curseforge.com/hytale/mods/alecs-animal-husbandry) (the companion mod; it runs on the Alec's Tamework API)

## Install

Drop the pack into your server's mods folder next to MMO Skill Tree and Alec's Animal Husbandry, then restart. Server owners can fine-tune every Taming XP value in `mods/mmoskilltree/xp-maps.json`.

## Versions

| Pack  | Plugin | Notes |
| ----- | ------ | ----- |
| 1.1.0 | 1.3.0+ | Fixes the automatic boost rewards at Taming levels 15, 50, and 100 never actually granting (the reward command's arguments never bound, so it silently did nothing). Reward lines drop their baked English names; the plugin renders each line localized in the player's language. |
| 1.0.0 | 1.2.0+ | First release. Taming XP map, progression + repeatable daily/weekly quests, achievement chains for every companion activity, and per-level boost rewards. |
