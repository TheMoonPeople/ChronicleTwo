--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_6558fc8d = require("@lib/event/helper_6558fc8d")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_d91fc4aa(arg0: s32)
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	var1 = event.get_triggered_event_data_2(9) or var1
	event.attach_object_handle_to_map_part_2(0, var1)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.open_minimap_door(pos_x, pos_y, pos_z)
	event.call_command(1035, 8, var5, var6, var7, var8) -- retail: the handler rejects 5 arguments
	var8 = vm.bits_float(event.get_triggered_event_data_2(11)) or var8
	var8 = vm.f32(var8 - vm.f32(3.1415927))
	var8 = event.wrap_angle(var8) or var8
	var9 = 0
	if arg0 == 0 then
		event.start_background_file_loads_1("snd2/sp/sp_026.sound.json")
		while var9 < 30 do
			event.set_follow_camera_target(var5, var6 + 40.0, var7)
			event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
			event.swing_camera_control_to_angle(var8)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			var9 = var9 + 1
			vm.wait(1)
		end
		helper_479dc9e9()
		var10 = event.load_sound_effect_file_3(8, "snd2/sp/sp_026.sound.json") or var10
		event.play_sound_effect(var10, 0)
		event.attach_object_handle_to_map_part_3(0, var1, "d05d05_3-m0")
		event.set_object_handle_visible(0, 1)
		event.set_function_point_enabled(var1, "eff_d05ef-0", 0)
		wait_frames(10)
		event.clear_camera_sequence()
		event.set_map_piece_character_motion(var1, "d05d05_2-m0", "飛ぶ")
		event.shake_camera_sequence(0.0, 0.2, 0.0, 80)
		wait_frames(20)
		event.play_sound_effect(var10, 1)
		wait_frames(60)
		event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
		event.set_function_point_enabled(var1, "door01", 0)
		event.attach_object_handle_to_map_part_3(0, var1, "d05d05_2-m0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, var1, "d05da05b-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, var1, "d05dv05-c")
		event.set_object_handle_visible(0, 0)
	else
		event.start_background_file_loads_2("event/dng_inout/whitewind.gltf", "snd2/sp/sp_027.sound.json")
		while var9 < 30 do
			event.set_follow_camera_target(var5, var6 + 40.0, var7)
			event.set_camera_control_range(18.0, 10.0, 200.0, 220.0)
			event.swing_camera_control_to_angle(var8)
			event.move_camera_control_with_pad(0)
			event.step_camera_control()
			var9 = var9 + 1
			vm.wait(6)
		end
		var11 = event.load_sound_effect_file_3(8, "snd2/sp/sp_027.sound.json") or var11
		event.play_sound_effect(var11, 0)
		event.load_character(5, "event/dng_inout/whitewind.gltf", "info", 12)
		event.set_character_active(1, 12)
		event.set_character_position(12, var5, var6 + 10.0, var7)
		event.set_character_rotation(12, 0.0, var8, 0.0)
		event.set_character_scale(12, 2.4, 2.4, 2.4)
		event.set_character_motion(12, "ホワイトウィンド", 6)
		event.set_function_point_enabled(var1, "door01", 0)
		wait_frames(60)
		var12 = event.compare_map_parts_part_name(var1, "door04") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 0)
		end
		var12 = event.compare_map_parts_part_name(var1, "door05") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 0)
		end
		var12 = event.compare_map_parts_part_name(var1, "door06") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 0)
		end
		var12 = event.compare_map_parts_part_name(var1, "door07") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 0)
		end
		var12 = event.compare_map_parts_part_name(var1, "door12") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 1)
		end
		var12 = event.compare_map_parts_part_name(var1, "door13") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 1)
		end
		var12 = event.compare_map_parts_part_name(var1, "door14") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 1)
		end
		var12 = event.compare_map_parts_part_name(var1, "door15") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 1)
		end
		var12 = event.compare_map_parts_part_name(var1, "door20") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 2)
		end
		var12 = event.compare_map_parts_part_name(var1, "door21") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 2)
		end
		var12 = event.compare_map_parts_part_name(var1, "door22") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 2)
		end
		var12 = event.compare_map_parts_part_name(var1, "door23") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 2)
		end
		var12 = event.compare_map_parts_part_name(var1, "door32") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 3)
		end
		var12 = event.compare_map_parts_part_name(var1, "door33") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 3)
		end
		var12 = event.compare_map_parts_part_name(var1, "door34") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 3)
		end
		var12 = event.compare_map_parts_part_name(var1, "door35") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 3)
		end
		var12 = event.compare_map_parts_part_name(var1, "door40") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 4)
		end
		var12 = event.compare_map_parts_part_name(var1, "door41") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 4)
		end
		var12 = event.compare_map_parts_part_name(var1, "door42") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 4)
		end
		var12 = event.compare_map_parts_part_name(var1, "door43") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 4)
		end
		var12 = event.compare_map_parts_part_name(var1, "door48") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 5)
		end
		var12 = event.compare_map_parts_part_name(var1, "door49") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 5)
		end
		var12 = event.compare_map_parts_part_name(var1, "door50") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 5)
		end
		var12 = event.compare_map_parts_part_name(var1, "door51") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 5)
		end
		var12 = event.compare_map_parts_part_name(var1, "door68") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 6)
		end
		var12 = event.compare_map_parts_part_name(var1, "door69") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 6)
		end
		var12 = event.compare_map_parts_part_name(var1, "door70") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 6)
		end
		var12 = event.compare_map_parts_part_name(var1, "door71") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 6)
		end
		var12 = event.compare_map_parts_part_name(var1, "door76") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 7)
		end
		var12 = event.compare_map_parts_part_name(var1, "door77") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 7)
		end
		var12 = event.compare_map_parts_part_name(var1, "door78") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 7)
		end
		var12 = event.compare_map_parts_part_name(var1, "door79") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 7)
		end
		var12 = event.compare_map_parts_part_name(var1, "door84") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 8)
		end
		var12 = event.compare_map_parts_part_name(var1, "door85") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 8)
		end
		var12 = event.compare_map_parts_part_name(var1, "door86") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 8)
		end
		var12 = event.compare_map_parts_part_name(var1, "door87") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 8)
		end
		var12 = event.compare_map_parts_part_name(var1, "door96") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 9)
		end
		var12 = event.compare_map_parts_part_name(var1, "door97") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 9)
		end
		var12 = event.compare_map_parts_part_name(var1, "door98") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 9)
		end
		var12 = event.compare_map_parts_part_name(var1, "door99") or var12
		if var12 == 0 then
			helper_6558fc8d(var1, 9)
		end
		event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
		event.delete_character(12)
		event.start_crossfade(30)
	end
	event.reset_follow_camera(0)
end

return helper_d91fc4aa
