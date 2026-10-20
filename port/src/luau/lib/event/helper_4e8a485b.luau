--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8078c41b = require("@lib/event/helper_8078c41b")

--- Helper function.
local function helper_4e8a485b(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8078c41b(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_4e8a485b
