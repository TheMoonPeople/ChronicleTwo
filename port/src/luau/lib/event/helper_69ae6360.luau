--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_69ae6360(arg0: s32, chara_no: s32, arg2: any)
	local var3: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local y: f32 = 0
	local x: f32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, chara_no)
	do
		local out1, out2, out3 = event.get_character_position(arg0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.get_character_rotation(arg0)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		rot_y = out2 or rot_y
	end
	var23 = vm.f32(vm.sin(rot_y) * 30.0)
	var24 = vm.f32(vm.cos(rot_y) * 30.0)
	var23 = vm.f32(var23 + pos_x)
	var24 = vm.f32(var24 + pos_z)
	var5 = var23
	var7 = var24
	event.set_character_position(arg0, var5, var6, var7)
	y = vm.f32(pos_x - var5)
	x = vm.f32(pos_z - var7)
	var3 = event.get_look_angle(y, x) or var3
	event.set_character_rotation(arg0, 0.0, var3, 0.0)
	do
		local out1, out2, out3, out4, out5, out6 = event.get_talk_camera_points(var5, var6, var7, pos_x, pos_y, pos_z, var3)
		offset_x = out1 or offset_x
		offset_y = out2 or offset_y
		offset_z = out3 or offset_z
		middle_x = out4 or middle_x
		var21 = out5 or var21
		middle_z = out6 or middle_z
	end
	event.set_camera_position(offset_x, offset_y, offset_z)
	event.set_camera_look_at(middle_x, var21, middle_z)
end

return helper_69ae6360
