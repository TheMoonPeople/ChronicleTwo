--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f3d8a633 = require("@lib/event/helper_f3d8a633")

--- Helper function.
local function helper_8a456003(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f3d8a633(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_8a456003
