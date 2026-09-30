# Taming Pack

The family-wide rules apply here; this file adds only what is specific to this pack.

- `TAMING` is a built-in jar skill whose XP arrives only through the Java `AlecsTameworkAdapter`. This pack ships content referencing it, every entry gated on `{"Factor": "mmoskilltree:feature", "Param": "taming", "Min": 1}`.
- Companion kinds (`BREED_ANIMAL`, `FEED_ANIMAL`, `HARVEST_ANIMAL`, `COMPANION_COMBAT`) fire with a blank target, so never author a `Target` on them.
- `CommandRewards/MMOSkillTamingPack.json` stays on the older `Name`/`Payload` shape, and its `/mmoboost give` pipe blob must travel in `--args=`.
