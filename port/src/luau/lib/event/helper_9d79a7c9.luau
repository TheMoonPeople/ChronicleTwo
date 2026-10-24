--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_54be73eb = require("@lib/event/helper_54be73eb")
local helper_e84a97e1 = require("@lib/event/helper_e84a97e1")
local helper_f07c7c86 = require("@lib/event/helper_f07c7c86")

--- Helper function.
local function helper_9d79a7c9(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_54be73eb(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_e84a97e1(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_f07c7c86(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_54be73eb(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_e84a97e1(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f07c7c86(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_9d79a7c9
