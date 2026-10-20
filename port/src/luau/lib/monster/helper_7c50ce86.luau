--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_661d392d = require("@lib/monster/helper_661d392d")

--- Helper function.
local function helper_7c50ce86()
	local var0: s32 = 0
	local var1: f32 = 0
	var0 = 0
	var1 = monster.GetTargetDist() or var1
	if var1 <= 0.0 then
		var0 = vm.i32(bit32.bor(var0, 1))
	elseif var1 <= 80.0 then
		var0 = vm.i32(bit32.bor(var0, 2))
	elseif var1 <= 800.0 then
		var0 = vm.i32(bit32.bor(var0, 4))
	else
		var0 = vm.i32(bit32.bor(var0, 8))
	end
	if var1 <= 80.0 then
		var0 = vm.i32(bit32.bor(var0, 16))
	end
	if helper_661d392d(0, 360.0) ~= 0 then
		var0 = vm.i32(bit32.bor(var0, 32))
	end
	if var1 <= 60.0 then
		var0 = vm.i32(bit32.bor(var0, 64))
	end
	if helper_661d392d(0, 360.0) ~= 0 then
		var0 = vm.i32(bit32.bor(var0, 128))
	end
	monster.VPush(0, var0)
end

return helper_7c50ce86
