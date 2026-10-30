--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")

--- Helper function.
local function helper_17069978(arg0: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	helper_238b5abc(0)
	helper_238b5abc(1)
	helper_238b5abc(0)
	helper_238b5abc(1)
	helper_238b5abc(12)
	helper_238b5abc(13)
	var4 = 150.0
	var5 = 1.0
	var2 = vm.f32(vm.fdiv(vm.f32(107.00003), var4))
	var3 = vm.f32(var2 * var5)
	var3 = vm.f32(vm.f32(417.9) + var3)
	var5 = vm.f32(var5 + 1.0)
	helper_238b5abc(0)
	helper_238b5abc(1)
	helper_344d6cd8()
end

return helper_17069978
