--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_eab3cb3c = require("@lib/event/helper_eab3cb3c")

--- Helper function.
local function helper_3c3b3111(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_eab3cb3c(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_3c3b3111
