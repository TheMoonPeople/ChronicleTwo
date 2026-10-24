--!strict
-- Shared event helper used by 435 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_25abe6d2(arg0: any)
	if arg0 > 0 then
		arg0 = arg0
	end
	while arg0 >= 0 do
		arg0 = arg0 - 1
		vm.wait(1)
	end
end

return helper_25abe6d2
