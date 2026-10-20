--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_79d4180d = require("@lib/event/helper_79d4180d")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_f6634238 = require("@lib/event/helper_f6634238")

--- Helper function.
local function helper_bf8a16c2(arg0: s32, arg1: s32, arg2: s32, arg3: s32, sp: number)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_79d4180d(arg0, arg2, arg3, sp + 7)
		end
		if at <= 2 then
			helper_b8950300(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_f6634238(arg0, var4, arg2, arg3, sp + 6)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_79d4180d(arg0, arg2, arg3, sp + 7)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_b8950300(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f6634238(arg0, var4, arg2, arg3, sp + 6)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_bf8a16c2
