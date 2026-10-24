--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d581415c = require("@lib/event/helper_d581415c")

--- Helper function.
local function helper_5b4ebdf3(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d581415c(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_5b4ebdf3
