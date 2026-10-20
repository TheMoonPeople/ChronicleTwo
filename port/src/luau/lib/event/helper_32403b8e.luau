--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9c199376 = require("@lib/event/helper_9c199376")
local helper_aebdaee5 = require("@lib/event/helper_aebdaee5")
local helper_f6134364 = require("@lib/event/helper_f6134364")

--- Helper function.
local function helper_32403b8e(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aebdaee5(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_9c199376(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_f6134364(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_aebdaee5(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_9c199376(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_32403b8e
