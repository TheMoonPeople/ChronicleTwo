--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09f6afd7 = require("@lib/event/helper_09f6afd7")

--- Helper function.
local function helper_75e929c3(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_09f6afd7(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_09f6afd7(arg0, arg1)
end

return helper_75e929c3
