--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d82070da = require("@lib/event/helper_d82070da")

--- Helper function.
local function helper_1d597f0c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d82070da(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_1d597f0c
