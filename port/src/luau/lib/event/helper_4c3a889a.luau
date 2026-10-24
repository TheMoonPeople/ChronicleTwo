--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_24e775ca = require("@lib/event/helper_24e775ca")

--- Helper function.
local function helper_4c3a889a(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_24e775ca(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_24e775ca(arg0, arg1)
end

return helper_4c3a889a
