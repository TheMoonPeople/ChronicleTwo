--!strict
-- Shared monster helper used by 76 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_8cdd6198(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	var4 = monster.GetTargetAngle() or var4
	do
		local _, out2, _ = monster.GetRot()
		var2 = out2 or var2
	end
	if var2 < vm.f32(var4 + helper_787df986(arg0)) and var2 > vm.f32(var4 + helper_787df986(-arg0)) then
		return 1
	end
	return 0
end

return helper_8cdd6198
