--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a9782f59 = require("@lib/event/helper_a9782f59")

--- Helper function.
local function helper_f1057d79(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a9782f59(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_f1057d79
