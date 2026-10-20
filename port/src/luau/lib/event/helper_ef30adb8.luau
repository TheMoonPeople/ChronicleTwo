--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3abf1edd = require("@lib/event/helper_3abf1edd")

--- Helper function.
local function helper_ef30adb8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3abf1edd(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_ef30adb8
