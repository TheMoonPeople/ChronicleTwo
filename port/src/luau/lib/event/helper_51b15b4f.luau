--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a79eacca = require("@lib/event/helper_a79eacca")

--- Helper function.
local function helper_51b15b4f(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a79eacca(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_51b15b4f
