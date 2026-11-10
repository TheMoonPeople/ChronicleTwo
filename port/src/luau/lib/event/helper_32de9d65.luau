--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_32de9d65(chara_no: s32, arg1: any, arg2: f32)
	local var4: f32 = 0
	event.get_item_weapon_category(arg1)
	var4 = event.get_character_fit_scale(chara_no, 8.0) or var4
	var4 = vm.f32(var4 * vm.f32(0.6))
	arg2 = var4
	return arg2
end

return helper_32de9d65
