--!strict
-- Shared action helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_969ab7e3()
	local var0: s32 = 0
	local prog: s32 = 0
	local var3: f32 = 0
	prog = action.get_program_value() or prog
	if prog == 200 then
		action.play_motion("中距離攻撃", -1, 6)
		action.set_program_value(prog + 1)
	end
	if prog == 201 then
		var3 = action.get_motion_progress() or var3
		if var3 >= vm.f32(0.137) and var3 < vm.f32(0.495) then
			action.set_move_impulse(6.0, 0.0, 1)
		end
		var0 = action.get_motion_status() or var0
		if var0 == 4 then
			action.set_program_value(0)
		end
		return
	end
end

return helper_969ab7e3
