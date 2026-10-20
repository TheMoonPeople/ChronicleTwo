--!strict
-- Shared monster helper used by 111 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_82cb5588(arg0: f32)
	local var1: f32 = 0
	var1 = monster.GetTargetAngle() or var1
	monster.SetNextRot(var1, arg0)
end

return helper_82cb5588
