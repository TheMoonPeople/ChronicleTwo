--!strict
-- Shared event helper used by 40 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c171f5cd = require("@lib/event/helper_c171f5cd")

--- Helper function.
local function helper_4896c0c7(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c171f5cd(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_c171f5cd(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_4896c0c7
