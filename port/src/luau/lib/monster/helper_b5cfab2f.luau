--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_bee0409d = require("@lib/monster/helper_bee0409d")

--- Helper function.
local function helper_b5cfab2f(arg0: s32, rot_speed: f32, arg2: s32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var9: f32 = 0
	rot_speed = helper_787df986(rot_speed)
	for var10 = 0, arg2 - 1 do
		do
			local out1, out2, out3 = monster.get_monster_position(arg0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		var9 = monster.get_angle_to_position(var3, var4, var5) or var9
		monster.turn_toward_angle(var9, rot_speed)
		helper_bee0409d()
	end
	helper_442b9962()
end

return helper_b5cfab2f
