--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f2a31d5 = require("@lib/event/helper_2f2a31d5")
local helper_e769163a = require("@lib/event/helper_e769163a")

--- Helper function.
local function helper_28e87631(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e769163a(1, 4)
			helper_2f2a31d5(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_e769163a(1, 4)
	helper_2f2a31d5(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_28e87631
