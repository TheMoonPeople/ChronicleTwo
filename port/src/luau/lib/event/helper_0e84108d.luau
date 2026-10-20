--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1291fad0 = require("@lib/event/helper_1291fad0")

--- Helper function.
local function helper_0e84108d(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_1291fad0(arg0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_1291fad0(arg0, -1)
end

return helper_0e84108d
