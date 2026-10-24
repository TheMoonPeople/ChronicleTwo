--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31d31ab1 = require("@lib/event/helper_31d31ab1")

--- Helper function.
local function helper_bd048af9(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_31d31ab1(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_bd048af9
