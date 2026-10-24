--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8e3d42b0 = require("@lib/event/helper_8e3d42b0")

--- Helper function.
local function helper_7a92069b(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_8e3d42b0(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_8e3d42b0(arg0, arg1)
end

return helper_7a92069b
