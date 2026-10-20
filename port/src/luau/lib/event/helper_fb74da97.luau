--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a1ed50bd = require("@lib/event/helper_a1ed50bd")
local helper_abdaa976 = require("@lib/event/helper_abdaa976")
local helper_f0b5b912 = require("@lib/event/helper_f0b5b912")

--- Helper function.
local function helper_fb74da97(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f0b5b912(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_a1ed50bd(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_abdaa976(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_f0b5b912(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_a1ed50bd(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_fb74da97
