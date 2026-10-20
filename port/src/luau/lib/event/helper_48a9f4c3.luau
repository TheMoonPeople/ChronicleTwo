--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_48a9f4c3(arg0: f32, arg1: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 > arg1 then
		return arg0
	else
		return arg1
	end
end

return helper_48a9f4c3
