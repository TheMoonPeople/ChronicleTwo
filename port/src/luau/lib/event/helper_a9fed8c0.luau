--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a55c98d8 = require("@lib/event/helper_a55c98d8")

--- Helper function.
local function helper_a9fed8c0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a55c98d8(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_a9fed8c0
