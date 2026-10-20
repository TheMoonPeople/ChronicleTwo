--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_14c68180(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	var5 = monster.Atan2f(arg3 - arg0, arg4 - arg1) or var5
	var5 = vm.f32(var5 - arg2)
	if var5 > vm.f32(3.1415927) then
		var5 = vm.f32(var5 - vm.f32(6.2831855))
	end
	if var5 <= vm.f32(-3.1415927) then
		var5 = vm.f32(var5 + vm.f32(6.2831855))
	end
	return var5
end

return helper_14c68180
