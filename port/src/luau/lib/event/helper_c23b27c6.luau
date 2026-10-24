--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_36526538 = require("@lib/event/helper_36526538")
local helper_c9057fa5 = require("@lib/event/helper_c9057fa5")

--- Helper function.
local function helper_c23b27c6(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c9057fa5(1, 4)
			helper_36526538(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_c9057fa5(1, 4)
	helper_36526538(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_c23b27c6
