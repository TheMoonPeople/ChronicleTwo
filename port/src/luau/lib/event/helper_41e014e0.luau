--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26b14944 = require("@lib/event/helper_26b14944")

--- Helper function.
local function helper_41e014e0()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_26b14944(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_26b14944(1)
end

return helper_41e014e0
