--!strict
-- Shared effect helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_777ac8df(arg0: s32)
	for var1 = 0, arg0 - 1 do
		vm.wait()
	end
end

return helper_777ac8df
