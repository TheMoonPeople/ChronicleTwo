--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d0552354 = require("@lib/event/helper_d0552354")

--- Helper function.
local function helper_8a57ebd6(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_d0552354(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_d0552354(arg0, arg1)
end

return helper_8a57ebd6
