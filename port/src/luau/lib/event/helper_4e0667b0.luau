--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1dc9449e = require("@lib/event/helper_1dc9449e")

--- Helper function.
local function helper_4e0667b0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1dc9449e(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_4e0667b0
