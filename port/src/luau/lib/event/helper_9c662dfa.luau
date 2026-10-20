--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2c46ef93 = require("@lib/event/helper_2c46ef93")
local helper_2e36e3e3 = require("@lib/event/helper_2e36e3e3")
local helper_4487d684 = require("@lib/event/helper_4487d684")

--- Helper function.
local function helper_9c662dfa(arg0: s32, arg1: s32, arg2: s32, arg3: s32, sp: number)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_4487d684(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_2e36e3e3(0, arg1, arg0, player_chara, 0, sp + 6)
		end
		if at <= 3 then
			helper_2c46ef93(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_4487d684(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_2e36e3e3(0, arg1, arg0, player_chara, 0, sp + 6)
	if vm.skipping() then
		return skip(3)
	end
	helper_2c46ef93(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_9c662dfa
