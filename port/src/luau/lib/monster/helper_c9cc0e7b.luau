--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_c9cc0e7b(rot_speed: f32)
	local var1: f32 = 0
	local var2: s32 = 0
	rot_speed = helper_787df986(rot_speed)
	while true do
		var1 = monster.get_target_angle() or var1
		monster.turn_toward_angle(var1, rot_speed)
		helper_b9fff8e1()
		var2 = monster.is_motion_finished() or var2
		if var2 ~= 0 then
			helper_442b9962()
			break
		end
	end
end

return helper_c9cc0e7b
