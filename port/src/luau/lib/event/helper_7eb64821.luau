--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bf3c1120 = require("@lib/event/helper_bf3c1120")

--- Helper function.
local function helper_7eb64821(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_bf3c1120(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_bf3c1120(arg0, arg1)
end

return helper_7eb64821
