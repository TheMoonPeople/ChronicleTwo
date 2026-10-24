--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c4b7dd30 = require("@lib/event/helper_c4b7dd30")

--- Helper function.
local function helper_c14e497f(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c4b7dd30(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_c4b7dd30(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_c14e497f
