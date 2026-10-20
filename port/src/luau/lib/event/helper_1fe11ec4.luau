--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1d22fc6c = require("@lib/event/helper_1d22fc6c")

--- Helper function.
local function helper_1fe11ec4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_1d22fc6c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_1d22fc6c(arg0, arg1)
end

return helper_1fe11ec4
