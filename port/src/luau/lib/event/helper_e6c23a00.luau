--!strict
-- Shared event helper used by 71 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e6c23a00(chara_no: s32, arg1: s32, arg2: f32)
	local category: s32 = 0
	local var4: f32 = 0
	category = event.get_item_weapon_category(arg1) or category
	var4 = event.get_character_fit_scale(chara_no, 6.0) or var4
	if category == 0 then
		var4 = vm.f32(var4 / 2.0)
	end
	if category == 2 then
		var4 = vm.f32(var4 / 2.0)
	end
	if category == 4 then
		var4 = vm.f32(var4 / 2.0)
	end
	arg2 = var4
	return arg2
end

return helper_e6c23a00
