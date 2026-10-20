--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_dcfc74de = require("@lib/event/helper_dcfc74de")

--- Helper function.
local function helper_dff0cdbe(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_dcfc74de(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_dff0cdbe
