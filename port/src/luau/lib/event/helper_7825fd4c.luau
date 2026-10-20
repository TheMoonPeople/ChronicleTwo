--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47977a48 = require("@lib/event/helper_47977a48")

--- Helper function.
local function helper_7825fd4c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_47977a48(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_7825fd4c
