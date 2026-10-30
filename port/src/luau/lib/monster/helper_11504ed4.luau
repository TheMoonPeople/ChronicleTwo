--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_11504ed4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: f32 = 0
	monster.call_command(
		20,
		vm.f32(vm.f32(arg2 - arg0) * vm.f32(arg2 - arg0)) + vm.f32(vm.f32(arg3 - arg1) * vm.f32(arg3 - arg1)),
		var4
	) -- retail: command 20 is not registered
	return var4
end

return helper_11504ed4
