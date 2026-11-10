--!strict
-- Shared event helper used by 36 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_684bf7e6(arg0: s32, row: s32)
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: s32 = 0
	var2 = event.get_villager_training_value(1, row) or var2
	do
		local out1, out2, out3, _ = event.get_train_seat_position(var2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var7 = event.get_villager_training_value(2, row) or var7
	if var3 < 0 then
		var3 = vm.f32(var7 * -1.0)
	else
		var3 = var7
	end
	event.set_character_position(arg0, var3, var4, var5)
	event.set_character_rotation(arg0, 0.0, 3.1415927, 0.0)
	event.set_character_motion(arg0, "待機", 4)
end

return helper_684bf7e6
