--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_13c3517e = require("@lib/event/helper_13c3517e")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_a15cb0ee = require("@lib/event/helper_a15cb0ee")

--- Helper function.
local function helper_ed7a22dd(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_13c3517e(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_a15cb0ee(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_403f0e66(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_13c3517e(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_ed7a22dd
