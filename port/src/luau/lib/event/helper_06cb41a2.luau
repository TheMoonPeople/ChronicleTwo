--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local interpolate = require("@lib/event/interpolate")

--- Helper function.
local function helper_06cb41a2(arg0: s32, rot_y: f32)
	local rot_y_2: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local rot_y_3: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	event.attach_object_handle_to_character(0, arg0)
	event.get_object_handle_position(0)
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		rot_y_2 = out2 or rot_y_2
	end
	var10 = rot_y_2
	var11 = rot_y
	var12 = vm.f32(var11 - var10)
	if var12 < vm.f32(-3.1415927) then
		var12 = vm.f32(var12 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var12 then
		var12 = vm.f32(var12 - vm.f32(6.2831855))
	end
	if -0.5 < var12 and var12 < 0.5 then
		event.set_character_motion(arg0, "立ち")
	else
		event.set_character_motion(arg0, "歩き")
	end
	var14 = 0.0
	var15 = 10.0
	while var14 <= var15 do
		rot_y_3 = interpolate(0.0, var12, var14, var15)
		rot_y_3 = vm.f32(rot_y_3 + var10)
		event.set_object_handle_rotation(0, 0.0, rot_y_3, 0.0)
		var14 = vm.f32(var14 + 1.0)
		vm.wait(1)
	end
	event.set_object_handle_rotation(0, 0.0, rot_y, 0.0)
end

return helper_06cb41a2
