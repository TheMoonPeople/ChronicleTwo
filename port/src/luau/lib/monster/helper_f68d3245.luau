--!strict
-- Shared monster helper used by 14 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")

--- Helper function.
local function helper_f68d3245(arg0: f32, arg1: f32)
	local var3: f32 = 0
	local var5: f32 = 0
	do
		local _, out2, _ = monster.GetRot()
		var3 = out2 or var3
	end
	var5 = monster.GetTargetAngle() or var5
	if helper_8971d3b6(vm.f32(var5 + arg0), var3, vm.f32(arg1 / 2.0)) == 0 then
		return 1
	end
	return 0
end

return helper_f68d3245
