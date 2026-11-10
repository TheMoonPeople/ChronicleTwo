--!strict
-- Shared action helper used by 27 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_bac4ec65(arg0: any)
	while arg0 > 0 do
		arg0 = arg0 - 1
		vm.wait()
	end
end

return helper_bac4ec65
