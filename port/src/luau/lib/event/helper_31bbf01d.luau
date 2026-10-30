--!strict
-- Shared event helper used by 285 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local interpolate = require("@lib/event/interpolate")

--- Helper function.
local function helper_31bbf01d(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local angle: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local angle_2: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local rot_y: f32 = 0
	local rot_y_2: f32 = 0
	do
		local out1, out2, out3 = event.get_character_position(arg0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.get_character_rotation(arg0)
		var10 = out2 or var10
	end
	do
		local out1, out2, out3 = event.get_character_position(arg1)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.get_character_rotation(arg1)
		var13 = out2 or var13
	end
	var15 = event.get_look_angle(var6 - var3, var8 - var5) or var15
	var16 = event.get_look_angle(var3 - var6, var5 - var8) or var16
	if arg2 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.get_talk_camera_points(var3, var4, var5, var6, var7, var8, var15)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var21 = out5 or var21
			middle_z = out6 or middle_z
		end
		event.set_camera_position(offset_x, offset_y, offset_z)
		event.set_camera_look_at(middle_x, var21, middle_z)
		event.start_crossfade(10)
	end
	var27 = var10
	var28 = var15
	angle = vm.f32(var28 - var27)
	angle = event.wrap_angle(angle) or angle
	var30 = var13
	var31 = var16
	angle_2 = vm.f32(var31 - var30)
	angle_2 = event.wrap_angle(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.set_character_motion(arg0, "立ち")
	else
		event.set_character_motion(arg0, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.set_character_motion(arg1, "歩き")
	end
	var33 = 0.0
	var34 = vm.f32(helper_baeaba52(helper_05ce8bed(angle), helper_05ce8bed(angle_2)) * 8.0)
	while var33 < var34 do
		rot_y = interpolate(0.0, angle, var33, var34)
		rot_y = vm.f32(rot_y + var27)
		event.set_character_rotation(arg0, 0.0, rot_y, 0.0)
		rot_y_2 = interpolate(0.0, angle_2, var33, var34)
		rot_y_2 = vm.f32(rot_y_2 + var30)
		event.set_character_rotation(arg1, 0.0, rot_y_2, 0.0)
		var33 = vm.f32(var33 + 1.0)
		vm.wait(1)
	end
	event.set_character_rotation(arg0, 0.0, var15, 0.0)
	event.set_character_motion(arg0, "立ち")
	event.set_character_rotation(arg1, 0.0, var16, 0.0)
	event.set_character_motion(arg1, "会話")
end

return helper_31bbf01d
