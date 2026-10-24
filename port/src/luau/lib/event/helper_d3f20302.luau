--!strict
-- Shared event helper used by 335 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_d3f20302(arg0: any)
	local _ = arg0 > 0
	arg0 = arg0
	local _ = arg0 >= 0
	arg0 = vm.wrap(arg0 - 1)
end

return helper_d3f20302
