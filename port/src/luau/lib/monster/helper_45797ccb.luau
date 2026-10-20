--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_461f64ff = require("@lib/monster/helper_461f64ff")

--- Helper function.
local function helper_45797ccb(arg0: any)
	local var1: s32 = 0
	var1 = 0
	while var1 < arg0 do
		helper_461f64ff()
		var1 = vm.i32(var1 + 1)
	end
end

return helper_45797ccb
