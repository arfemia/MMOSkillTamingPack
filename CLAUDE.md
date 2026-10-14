# Taming Pack

The family-wide rules apply here; this file adds only what is specific to this pack.

- `TAMING` is a built-in jar skill with no native trigger: its play XP arrives only through the Java `AlecsTameworkAdapter` (the pack's `XpToken_Taming_*` items pay it too). This pack ships content referencing it, every entry gated on `{"Factor": "mmoskilltree:feature", "Param": "Taming", "Min": 1}` (the feature id is matched case-insensitively, so the shipped `taming` spelling still works).
- Companion kinds (`BREED_ANIMAL`, `FEED_ANIMAL`, `HARVEST_ANIMAL`, `COMPANION_COMBAT`) fire with a blank target, so never author a `Target` on them.
- `Server/MMOSkillTree/CommandRewards/MMOSkillTamingPack.json` stays on the older `Name`/`Payload` shape, and its `/mmoboost give` pipe blob must travel in `--args=`. Its rows are collected (`autoClaim` false, R400), so each needs a `localizationKey` for its name: a row with no display info renders no card and never pays (`CommandRewardService.isRewardDisplayable`). The jar shows the boost's multiplier and minutes as the card's description, so the row authors no `descriptionKey` and the lang value carries no digits.
