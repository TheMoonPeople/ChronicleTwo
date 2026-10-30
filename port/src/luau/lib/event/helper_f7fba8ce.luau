--!strict
-- Shared event helper used by 113 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_f7fba8ce(first_angle: f32, second_angle: f32, tolerance: f32)
	local var3: s32 = 0
	var3 = event.compare_angles(first_angle, second_angle, tolerance) or var3
	return var3
end

return helper_f7fba8ce
