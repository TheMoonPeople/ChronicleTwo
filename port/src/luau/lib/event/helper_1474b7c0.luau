--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_21d48e61 = require("@lib/event/helper_21d48e61")
local helper_98ae051c = require("@lib/event/helper_98ae051c")
local helper_fbf80ccd = require("@lib/event/helper_fbf80ccd")

--- Helper function.
local function helper_1474b7c0(arg0: s32, arg1: s32, arg2: s32, arg3: s32, sp: number)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_21d48e61(arg0, arg2, arg3, sp + 7)
		end
		if at <= 2 then
			helper_98ae051c(0, arg1, arg0, player_chara, 0, sp + 6)
		end
		if at <= 3 then
			helper_fbf80ccd(arg0, var4, arg2, arg3, sp + 6)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_21d48e61(arg0, arg2, arg3, sp + 7)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_98ae051c(0, arg1, arg0, player_chara, 0, sp + 6)
	if vm.skipping() then
		return skip(3)
	end
	helper_fbf80ccd(arg0, var4, arg2, arg3, sp + 6)
	if vm.skipping() then
		return skip(4)
	end
end

return helper_1474b7c0
