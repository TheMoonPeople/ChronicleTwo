--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_99f45543 = require("@lib/event/helper_99f45543")

--- Helper function.
local function helper_4206e75e(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_99f45543(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_4206e75e
