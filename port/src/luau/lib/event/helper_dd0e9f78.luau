--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_52df35f7 = require("@lib/event/helper_52df35f7")

--- Helper function.
local function helper_dd0e9f78(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		helper_52df35f7(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_52df35f7(arg0)
end

return helper_dd0e9f78
