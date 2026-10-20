--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_983c5580 = require("@lib/event/helper_983c5580")

--- Helper function.
local function helper_237db4c5(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		helper_983c5580(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_983c5580(arg0)
end

return helper_237db4c5
