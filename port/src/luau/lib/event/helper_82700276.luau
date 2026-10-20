--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8e3d42b0 = require("@lib/event/helper_8e3d42b0")

--- Helper function.
local function helper_82700276(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_8e3d42b0(arg0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_8e3d42b0(arg0, -1)
end

return helper_82700276
