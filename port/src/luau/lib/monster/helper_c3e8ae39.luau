--!strict
-- Shared monster helper used by 73 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c3e8ae39(arg0: any)
	while arg0 > 0 do
		vm.wait()
		arg0 = arg0 - 1
	end
end

return helper_c3e8ae39
