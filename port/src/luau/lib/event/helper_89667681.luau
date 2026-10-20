--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e799d57b = require("@lib/event/helper_e799d57b")

--- Helper function.
local function helper_89667681(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e799d57b(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_89667681
