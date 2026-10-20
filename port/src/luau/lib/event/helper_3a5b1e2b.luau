--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3bc49271 = require("@lib/event/helper_3bc49271")

--- Helper function.
local function helper_3a5b1e2b(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_3bc49271(arg0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_3bc49271(arg0, -1)
end

return helper_3a5b1e2b
