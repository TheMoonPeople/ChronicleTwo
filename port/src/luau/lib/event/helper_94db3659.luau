--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8e549bd9 = require("@lib/event/helper_8e549bd9")

--- Helper function.
local function helper_94db3659(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8e549bd9(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_94db3659
