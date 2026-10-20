--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_5f4a60e2(arg0: any)
	arg0 = arg0
	while arg0 > 0 do
		vm.wait()
		arg0 = arg0 - 1
	end
end

return helper_5f4a60e2
