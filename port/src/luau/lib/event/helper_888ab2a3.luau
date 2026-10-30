--!strict
-- Shared event helper used by 170 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_888ab2a3(arg0: any)
	while arg0 >= 0 do
		arg0 = arg0 - 1
		vm.wait(1)
	end
end

return helper_888ab2a3
