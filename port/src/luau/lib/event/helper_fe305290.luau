--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_216f4751 = require("@lib/event/helper_216f4751")

--- Helper function.
local function helper_fe305290(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_216f4751(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_fe305290
