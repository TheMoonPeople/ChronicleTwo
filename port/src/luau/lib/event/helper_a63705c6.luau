--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6f667513 = require("@lib/event/helper_6f667513")

--- Helper function.
local function helper_a63705c6(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6f667513(arg0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_6f667513(arg0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_a63705c6
