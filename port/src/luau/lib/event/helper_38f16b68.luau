--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_905df00c = require("@lib/event/helper_905df00c")

--- Helper function.
local function helper_38f16b68(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_905df00c(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_38f16b68
