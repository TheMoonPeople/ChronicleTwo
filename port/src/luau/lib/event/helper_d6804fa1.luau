--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_eb106592 = require("@lib/event/helper_eb106592")

--- Helper function.
local function helper_d6804fa1(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_eb106592(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_d6804fa1
