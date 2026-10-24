--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27cf7b30 = require("@lib/event/helper_27cf7b30")

--- Helper function.
local function helper_1d2bc77a(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_27cf7b30(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_1d2bc77a
