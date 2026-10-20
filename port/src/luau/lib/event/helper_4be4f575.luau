--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_61c3154f = require("@lib/event/helper_61c3154f")

--- Helper function.
local function helper_4be4f575(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_61c3154f(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_61c3154f(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_4be4f575
