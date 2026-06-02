# MMO Skill Tree - Taming Pack

A content pack for the MMO Skill Tree mod that adds the **Taming** skill's
quests, achievements, and level rewards.

## Requirements

- MMO Skill Tree (the main mod). Version 1.1.7 or newer for the breeding quests
  and achievements (that release added breeding tracking).
- Alec's Animal Husbandry (the companion mod). It runs on the Alec's Tamework
  API, which is what the Taming skill reads, so the Taming skill turns on
  automatically when Animal Husbandry is installed and stays hidden otherwise.

## Install

1. Drop `MMOSkillTamingPack.zip` into your server's `UserData/Mods` folder
   (alongside the MMO Skill Tree jar and Alec's Animal Husbandry).
2. Restart the server.

## What it adds

- A Taming XP map so your companions' feeding, harvesting, breeding, and combat
  grant Taming experience. Feeding is a small steady trickle, harvesting is
  medium, breeding gives the most, combat is kept low, and damage taken is off
  by default.
- Progression quests (First Bond, Companion Keeper, Beastmaster) that grant
  Taming XP boosts.
- Repeatable daily and weekly quests: a daily breeding goal, a daily companion-care
  goal (feeding and harvesting), and a weekly husbandry goal, each granting flat
  Taming XP.
- Achievements for every companion activity: a four-tier "Tamer" level chain (to
  Grandmaster at Taming 100), a five-tier breeding chain (to 25,000 bred) plus a
  1,000,000 lifetime-XP "Bloodline" milestone, and three-tier chains for feeding
  (Caretaker), harvesting (Forager), and companion combat (War Beasts).
- Automatic XP-boost rewards at Taming levels 15, 50, and 100.

## Tuning

Server owners can retune every Taming XP value by editing the `TAMING` block in
`mods/mmoskilltree/xp-maps.json`. Set a source to `0` to turn it off.
