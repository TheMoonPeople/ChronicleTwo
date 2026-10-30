--!strict
-- Shared action helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_dea24da5()
	local result: s32 = 0
	local var1: f32 = 0
	action.play_motion("バク転", -1, 6)
	action.set_invulnerable_time(20)
	while true do
		vm.wait()
		var1 = action.get_motion_progress() or var1
		if var1 > vm.f32(0.18) and var1 < vm.f32(0.8) then
			action.set_move_impulse(3.0, 0.0, 1, 180)
		end
		result = vm.float_bits(action.is_motion_finished()) or result
		if result ~= 0 then
			break
		end
	end
	helper_bac4ec65(6)
	action.set_program_value(0)
end

return helper_dea24da5
