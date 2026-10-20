--!strict
-- Shared monster helper used by 93 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_93495fdf()
	local var0: f32 = 0
	var0 = monster.GetTargetAngle() or var0
	monster.SetRot(0.0, var0, 0.0)
end

return helper_93495fdf
