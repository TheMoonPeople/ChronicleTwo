--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d142cbc5 = require("@lib/event/helper_d142cbc5")

--- Helper function.
local function helper_26a0ea26(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_d142cbc5(arg0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_d142cbc5(arg0, -1)
end

return helper_26a0ea26
