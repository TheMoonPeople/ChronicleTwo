--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_72f8861f = require("@lib/event/helper_72f8861f")

--- Helper function.
local function helper_cb5b2ae9(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_72f8861f(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_cb5b2ae9
