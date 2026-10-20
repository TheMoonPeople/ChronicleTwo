--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d345d12 = require("@lib/event/helper_0d345d12")
local helper_45bb7c29 = require("@lib/event/helper_45bb7c29")
local helper_daa89e49 = require("@lib/event/helper_daa89e49")

--- Helper function.
local function helper_8d6f315a(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_daa89e49(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_0d345d12(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_45bb7c29(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_daa89e49(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_0d345d12(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_8d6f315a
