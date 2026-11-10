--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local interpolate = require("@lib/event/interpolate")

--- Helper function.
local function helper_baa247a4(arg0: s32, arg1: s32, arg2: any, arg3: s32)
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var13: f32 = 0
	local rot_y: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var22: f32 = 0
	local middle_z: f32 = 0
	local y: f32 = 0
	local x: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local rot_y_2: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local rot_y_3: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, arg1)
	do
		local out1, out2, out3 = event.get_character_position(arg0)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.get_character_rotation(arg0)
		var13 = out2 or var13
	end
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
	y = vm.f32(pos_x - var6)
	x = vm.f32(pos_z - var8)
	var4 = event.get_look_angle(y, x) or var4
	var5 = event.get_look_angle(-y, -x) or var5
	if arg3 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.get_talk_camera_points(var6, var7, var8, pos_x, pos_y, pos_z, var4)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var22 = out5 or var22
			middle_z = out6 or middle_z
		end
		event.set_camera_position(offset_x, offset_y, offset_z)
		event.set_camera_look_at(middle_x, var22, middle_z)
		event.start_crossfade(10)
	end
	var31 = var13
	var32 = var4
	var33 = vm.f32(var32 - var31)
	if var33 < vm.f32(-3.1415927) then
		var33 = vm.f32(var33 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var33 then
		var33 = vm.f32(var33 - vm.f32(6.2831855))
	end
	var35 = rot_y
	var36 = var5
	var37 = vm.f32(var36 - var35)
	if var37 < vm.f32(-3.1415927) then
		var37 = vm.f32(var37 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var37 then
		var37 = vm.f32(var37 - vm.f32(6.2831855))
	end
	if -0.5 < var33 and var33 < 0.5 then
		event.set_character_motion(arg0, "立ち")
	else
		event.set_character_motion(arg0, "歩き")
	end
	if -0.5 < var37 and var37 < 0.5 then
	else
		event.set_character_motion(arg1, "歩き")
	end
	var39 = 0.0
	var40 = vm.f32(helper_baeaba52(helper_05ce8bed(var33), helper_05ce8bed(var37)) * 8.0)
	while var39 < var40 do
		rot_y_2 = interpolate(0.0, var33, var39, var40)
		rot_y_2 = vm.f32(rot_y_2 + var31)
		event.set_character_rotation(arg0, 0.0, rot_y_2, 0.0)
		rot_y_3 = interpolate(0.0, var37, var39, var40)
		rot_y_3 = vm.f32(rot_y_3 + var35)
		event.set_object_handle_rotation(0, 0.0, rot_y_3, 0.0)
		var39 = vm.f32(var39 + 1.0)
		vm.wait(1)
	end
	event.set_character_motion(arg0, "立ち")
	event.set_character_motion(arg1, "会話")
	event.set_character_rotation(arg0, 0.0, var4, 0.0)
	event.set_object_handle_rotation(0, 0.0, var5, 0.0)
end

return helper_baa247a4
