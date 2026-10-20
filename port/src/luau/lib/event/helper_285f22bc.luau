--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_814c8263 = require("@lib/event/helper_814c8263")

--- Helper function.
local function helper_285f22bc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_814c8263(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_285f22bc
