--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_df1edf00 = require("@lib/event/helper_df1edf00")

--- Helper function.
local function helper_f8047a1c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_df1edf00(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_df1edf00(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_f8047a1c
