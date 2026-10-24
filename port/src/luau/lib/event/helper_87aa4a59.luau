--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d345d12 = require("@lib/event/helper_0d345d12")
local helper_daa89e49 = require("@lib/event/helper_daa89e49")
local helper_dda46917 = require("@lib/event/helper_dda46917")

--- Helper function.
local function helper_87aa4a59(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_dda46917(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_daa89e49(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_0d345d12(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_dda46917(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_daa89e49(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_0d345d12(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_87aa4a59
