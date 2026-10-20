--!strict
-- Shared monster helper used by 87 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_5743cba3(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	do
		local _, out2, _ = monster.GetRot()
		var5 = out2 or var5
	end
	var2 = monster.GetTargetDist() or var2
	var6 = monster.GetTargetAngle() or var6
	if var2 < arg0 and var5 < vm.f32(var6 + helper_787df986(arg1)) and var5 > vm.f32(var6 + helper_787df986(-arg1)) then
		return 1
	end
	return 0
end

return helper_5743cba3
