--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_acc0d20a = require("@lib/event/helper_acc0d20a")

--- Helper function.
local function helper_345547bb(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_acc0d20a(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_acc0d20a(arg0, arg1)
end

return helper_345547bb
