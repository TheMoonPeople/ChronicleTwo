--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_88dc4e26 = require("@lib/event/helper_88dc4e26")

--- Helper function.
local function helper_e42033a8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_88dc4e26(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_88dc4e26(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_e42033a8
