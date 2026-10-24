--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7cfe6161 = require("@lib/event/helper_7cfe6161")

--- Helper function.
local function helper_6ae9ae21(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7cfe6161(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_6ae9ae21
