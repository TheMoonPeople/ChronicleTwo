--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_2c717f26(arg0: any)
	if arg0 < 0 then
		arg0 = vm.wrap(arg0 * -1)
	end
	return arg0
end

return helper_2c717f26
