--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e846995c()
	local argc: s32 = 0
	event.set_character_max_hp(0, 240)
	event.set_character_max_hp(1, 240)
	event.set_character_defence(0, 94)
	event.set_character_defence(1, 94)
	argc = event.get_item_count(270) or argc
	if argc < 20 then
		event.add_inventory_item(270, vm.i32(20 - argc))
	end
	event.add_inventory_item(20)
	event.equip_character_item(0, 20)
	event.add_inventory_item(33)
	event.equip_character_item(0, 33)
	event.add_inventory_item(60)
	event.equip_character_item(1, 60)
	event.add_inventory_item(96)
	event.equip_character_item(1, 96)
end

return helper_e846995c
