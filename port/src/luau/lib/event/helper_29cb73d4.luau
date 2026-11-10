--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_29cb73d4()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local position_x: f32 = 0
	local var6: f32 = 0
	local position_z: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	var0 = event.get_triggered_event_data_2(9) or var0
	var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_038.sound.json") or var1
	event.attach_object_handle_to_map_part_2(0, var0)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.call_command(1035, 8, position_x, var6, position_z, var8) -- retail: the handler rejects 5 arguments
	var8 = vm.bits_float(event.get_triggered_event_data_2(11)) or var8
	var8 = vm.f32(var8 - vm.f32(3.1415927))
	var8 = event.wrap_angle(var8) or var8
	event.play_sound_effect(var1, 0)
	event.set_map_piece_character_motion(var0, "d06d00_2-m", "キー付く")
	var9 = 0
	while var9 < 30 do
		event.set_follow_camera_target(position_x, var6 + 40.0, position_z)
		event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
		event.swing_camera_control_to_angle(var8)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var9 = var9 + 1
		vm.wait(1)
	end
	event.play_sound_effect(var1, 1)
	event.set_map_piece_character_motion(var0, "d06d00_2-m", "キー回転")
	wait_frames(44)
	event.set_map_piece_character_motion(var0, "d06d00_2-m", "キー止まる")
	wait_frames(10)
	event.attach_object_handle_to_map_part_3(0, var0, "d06d00_4-m")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, var0, "d06d00_3-m")
	event.set_object_handle_visible(0, 0)
	wait_frames(10)
	event.set_map_piece_character_motion(var0, "d06d00_2-m", "全回転")
	wait_frames(60)
	event.set_map_piece_character_motion(var0, "d06d00_2-m", "全停止")
	event.attach_object_handle_to_map_part_3(0, var0, "d06da00_2-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, var0, "d06dv00_1-c")
	event.set_object_handle_visible(0, 0)
	event.set_function_point_enabled(var0, "key1", 0)
	event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
	event.reset_follow_camera(0)
end

return helper_29cb73d4
