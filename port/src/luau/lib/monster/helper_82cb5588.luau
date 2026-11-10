--!strict
-- Shared monster helper used by 111 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_82cb5588(rot_speed: f32)
	local var1: f32 = 0
	var1 = monster.get_target_angle() or var1
	monster.turn_toward_angle(var1, rot_speed)
end

return helper_82cb5588
