--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6213684d = require("@lib/event/helper_6213684d")
local helper_7087b480 = require("@lib/event/helper_7087b480")
local helper_e90e0255 = require("@lib/event/helper_e90e0255")

--- Helper function.
local function helper_3ebf8f70(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_e90e0255(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_6213684d(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_7087b480(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_e90e0255(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_6213684d(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_7087b480(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_3ebf8f70
