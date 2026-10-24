--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25e49687 = require("@lib/event/helper_25e49687")

--- Helper function.
local function helper_ee8539bd(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_25e49687(arg0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_25e49687(arg0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_ee8539bd
