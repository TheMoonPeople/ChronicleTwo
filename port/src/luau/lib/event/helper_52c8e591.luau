--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_356809e0 = require("@lib/event/helper_356809e0")
local helper_e84a97e1 = require("@lib/event/helper_e84a97e1")
local helper_f07c7c86 = require("@lib/event/helper_f07c7c86")

--- Helper function.
local function helper_52c8e591(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e84a97e1(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_f07c7c86(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_356809e0(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_e84a97e1(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_f07c7c86(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_52c8e591
