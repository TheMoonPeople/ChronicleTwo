--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_bd088cc0(arg0: s32, arg1: any)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var12: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var16: s32 = 0
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, arg0)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		var9 = out2 or var9
	end
	do
		local out1, out2, out3 = event.get_character_position(arg0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local _, out2, _ = event.get_character_rotation(arg0)
		var12 = out2 or var12
	end
	yaw = event.get_direction_angle(var2, var3, var4, var5, var6, var7) or yaw
	yaw_2 = event.get_direction_angle(var5, var6, var7, var2, var3, var4) or yaw_2
	var16 = event.compare_angles(var9, yaw, 0.1) or var16
	if var16 ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	var16 = event.compare_angles(var12, yaw_2, 0.1) or var16
	if var16 ~= 0 then
		event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait_frames(20)
	event.set_mouth_motions(1, "会話", 0, "立ち", 0)
	helper_0ffc2526(0, -1, arg0, 0, 0)
	var16 = event.compare_angles(var12, yaw_2, 0.1) or var16
	if var16 ~= 0 then
		event.rotate_object_sequence(1, 0.0, var12, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait_frames(11)
end

return helper_bd088cc0
