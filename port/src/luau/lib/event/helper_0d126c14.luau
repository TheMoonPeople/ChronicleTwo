--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_902c690e = require("@lib/event/helper_902c690e")

--- Helper function.
local function helper_0d126c14(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_902c690e(arg0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_902c690e(arg0, -1)
end

return helper_0d126c14
