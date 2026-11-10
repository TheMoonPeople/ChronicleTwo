--!strict
-- Shared action helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9a354ac4()
	local var1: s32 = 0
	local prog: s32 = 0
	prog = action.get_program_value() or prog
	if prog == 200 then
		action.play_motion("攻撃２", -1, 6)
		vm.wait()
		var1 = action.get_motion_status() or var1
		if var1 == 4 then
			action.set_program_value(0)
		end
		return
	end
end

return helper_9a354ac4
