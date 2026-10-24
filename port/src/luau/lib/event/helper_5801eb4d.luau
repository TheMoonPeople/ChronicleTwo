--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e28e3237 = require("@lib/event/helper_e28e3237")

--- Helper function.
local function helper_5801eb4d(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e28e3237(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_5801eb4d
