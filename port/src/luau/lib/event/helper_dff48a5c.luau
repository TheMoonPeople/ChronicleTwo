--!strict
-- Shared event helper used by 95 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_dff48a5c(arg0: f32)
	local var1: s32 = 0
	local power: f32 = 0
	var1 = event.GetEquipItemno(0, 0) or var1
	do
		local out1, _, _ = event.SphidaGetCulbDef(var1)
		power = out1 or power
	end
	arg0 = vm.f32(arg0 * power)
	return arg0
end

return helper_dff48a5c
