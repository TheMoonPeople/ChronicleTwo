--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40d091f5 = require("@lib/event/helper_40d091f5")

--- Helper function.
local function helper_f79a50c6(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_40d091f5(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_f79a50c6
