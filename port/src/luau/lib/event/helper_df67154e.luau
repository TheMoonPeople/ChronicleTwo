--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_059fcb0a = require("@lib/event/helper_059fcb0a")
local helper_27c8a915 = require("@lib/event/helper_27c8a915")
local helper_77cec8da = require("@lib/event/helper_77cec8da")

--- Helper function.
local function helper_df67154e(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_059fcb0a(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_27c8a915(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_77cec8da(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_059fcb0a(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_27c8a915(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_df67154e
