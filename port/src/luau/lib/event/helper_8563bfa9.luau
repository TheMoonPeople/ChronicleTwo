--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bcca6021 = require("@lib/event/helper_bcca6021")

--- Helper function.
local function helper_8563bfa9(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_bcca6021(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_8563bfa9
