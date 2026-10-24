--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_aa53c510(arg0: any, arg1: s32)
	for var3 = 0, arg1 - 1 do
		vm.wait(1)
		if var3 == 60 then
			event.PlayBgm(0)
		end
	end
end

return helper_aa53c510
