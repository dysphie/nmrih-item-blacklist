# [NMRiH] Item Blacklist
Prevent unwanted inventory items from spawning, including those spawned through supply crates.


# ConVars
- `item_blacklist_ids` (Default `""`)

Space-separated list of IDs of items you would like to remove. Use `dump_weapon_registry` to see a list of weapon IDs
Example: `43 61` would prevent the spawning of walkietalkies and boards respectively.

- `item_blacklist_supply_patch_method` (Default: `1`)

What to do with blocked items in supply crates. 1 = Replace with similar item, 2 = Leave slot empty.

> [!NOTE]  
> This plugin doesn't currently support filtering "uncategorized" supply crates.

- `item_blacklist_verbose` (Default: `0`)

Prints item removals to console
