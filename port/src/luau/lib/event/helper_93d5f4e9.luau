--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_fde7786c = require("@lib/event/helper_fde7786c")

--- Helper function.
local function helper_93d5f4e9(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fde7786c(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_fde7786c(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_93d5f4e9
