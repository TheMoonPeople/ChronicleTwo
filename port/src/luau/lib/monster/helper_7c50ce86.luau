--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_661d392d = require("@lib/monster/helper_661d392d")

--- Helper function.
local function helper_7c50ce86()
	local value: s32 = 0
	local var1: f32 = 0
	value = 0
	var1 = monster.get_target_distance() or var1
	if var1 <= 0.0 then
		value = vm.i32(bit32.bor(value, 1))
	elseif var1 <= 80.0 then
		value = vm.i32(bit32.bor(value, 2))
	elseif var1 <= 800.0 then
		value = vm.i32(bit32.bor(value, 4))
	else
		value = vm.i32(bit32.bor(value, 8))
	end
	if var1 <= 80.0 then
		value = vm.i32(bit32.bor(value, 16))
	end
	if helper_661d392d(0, 360.0) ~= 0 then
		value = vm.i32(bit32.bor(value, 32))
	end
	if var1 <= 60.0 then
		value = vm.i32(bit32.bor(value, 64))
	end
	if helper_661d392d(0, 360.0) ~= 0 then
		value = vm.i32(bit32.bor(value, 128))
	end
	monster.set_variable(0, value)
end

return helper_7c50ce86
