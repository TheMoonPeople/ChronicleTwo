--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_32de9d65(arg0: s32, arg1: any, arg2: f32)
	local var4: f32 = 0
	event.GetItemType(arg1)
	var4 = event.GetAdjustPolygonScale(arg0, 8.0) or var4
	var4 = vm.f32(var4 * vm.f32(0.6))
	arg2 = var4
	return arg2
end

return helper_32de9d65
