--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8158e835 = require("@lib/event/helper_8158e835")

--- Helper function.
local function helper_a10acb03(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_8158e835(arg0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_8158e835(arg0, -1)
end

return helper_a10acb03
