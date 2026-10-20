--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_70a467af = require("@lib/event/helper_70a467af")

--- Helper function.
local function helper_1effc8e5(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_70a467af(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_70a467af(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_1effc8e5
