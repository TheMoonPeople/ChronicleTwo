--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06a7f473 = require("@lib/event/helper_06a7f473")
local helper_7edb8eda = require("@lib/event/helper_7edb8eda")
local helper_b8950300 = require("@lib/event/helper_b8950300")

--- Helper function.
local function helper_dcc4fb72(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8950300(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_06a7f473(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_7edb8eda(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_b8950300(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_06a7f473(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_dcc4fb72
