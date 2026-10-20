--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3177c03c = require("@lib/event/helper_3177c03c")

--- Helper function.
local function helper_7430440d(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3177c03c(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_3177c03c(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_7430440d
