--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_fe535421 = require("@lib/event/helper_fe535421")

--- Helper function.
local function helper_e5d5457f(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_fe535421(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_fe535421(arg0, arg1)
end

return helper_e5d5457f
