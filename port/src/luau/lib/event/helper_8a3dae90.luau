--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_72ce4a2d = require("@lib/event/helper_72ce4a2d")

--- Helper function.
local function helper_8a3dae90(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_72ce4a2d(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_8a3dae90
