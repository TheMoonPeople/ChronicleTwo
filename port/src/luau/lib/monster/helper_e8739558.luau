--!strict
-- Shared monster helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_408a011b = require("@lib/monster/helper_408a011b")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_e8739558(rot_speed: f32, arg1: f32, arg2: s32)
	local var3: f32 = 0
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	var3 = monster.get_target_angle() or var3
	arg1 = helper_787df986(arg1)
	rot_speed = helper_787df986(rot_speed)
	if argc < arg2 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			var3 = vm.f32(var3 + arg1)
		else
			var3 = vm.f32(var3 - arg1)
		end
	end
	monster.turn_toward_angle(var3, rot_speed)
	local _ = helper_408a011b(helper_28452e16(var3), helper_28452e16(rot_speed), 360.0)
	helper_442b9962()
end

return helper_e8739558
