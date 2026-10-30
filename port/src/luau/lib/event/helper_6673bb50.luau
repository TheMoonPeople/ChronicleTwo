--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_6673bb50()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local operand_x: f32 = 0
	local operand_y: f32 = 0
	local operand_z: f32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		var0 = event.load_sound_effect_file_2(3803) or var0
		active_chr_no = event.get_playable_character() or active_chr_no
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/d03/p00_26a.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		end
		event.set_character_active(0, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_position(0, -230.0, 62.1, 1210.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_position(1, -150.0, 230.0, 1600.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "飛び", 4)
		event.play_object_sequence_sound(1, var0, 1)
		event.delay_object_sequence_sound_track(1, 34)
		event.play_object_sequence_sound(1, var0, 1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(254.65, 473.72, 1588.47)
		event.set_camera_sequence_look_at(-219.14, 62.76, 1197.82)
		event.play_sound_effect(var0, 0)
		event.fade_in_screen(30)
		x = -150.0
		y = 230.0
		z = 1600.0
		x_2 = 0.0
		y_2 = -8.0
		z_2 = -10.0
		operand_x = 0.0
		operand_y = vm.f32(0.2)
		operand_z = 0.0
		var11 = 0
		while var11 < 60 do
			do
				local out1, out2, out3 = event.add_vectors(x, y, z, x_2, y_2, z_2)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = event.add_vectors(x_2, y_2, z_2, operand_x, operand_y, operand_z)
				x_2 = out1 or x_2
				y_2 = out2 or y_2
				z_2 = out3 or z_2
			end
			event.set_object_handle_position(1, x, y, z)
			var11 = var11 + 1
			at = 2
			vm.wait(2)
		end
		event.set_character_active(0, 8)
		event.set_camera_sequence_position(-195.61, 36.44, 1206.2)
		event.set_camera_sequence_look_at(-227.63, 40.13, 1199.12)
		event.set_character_active(1, 0)
		event.move_object_sequence(0, -230.0, 32.1, 1200.0, 10)
		event.set_object_sequence_motion(0, "d03着地", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 3
		wait_frames(8)
		var12 = event.get_sound_id(1) or var12
		event.play_sound_effect(var12, 3)
		event.play_sound_effect(var12, 2)
		at = 4
		wait_objects(0)
		event.fade_out_screen(30)
		at = 5
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			x = -150.0
			y = 230.0
			z = 1600.0
			x_2 = 0.0
			y_2 = -8.0
			z_2 = -10.0
			operand_x = 0.0
			operand_y = vm.f32(0.2)
			operand_z = 0.0
			var11 = 0
			local _ = var11 < 60
			var11 = var11 + 1
		end
		if at <= 2 then
			wait_frames_skipping(8)
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 6
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.delete_character_extension_packs(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(2, 1)
	event.set_object_handle_visible(3, 1)
	event.set_character_active(1, 0)
	event.set_character_active(1, 8)
	event.set_character_position(8, -316.71, 71.94, 806.78)
	event.set_character_rotation(8, 0.0, 2.06, 0.0)
	event.set_character_motion(8, "立ち", 4)
	event.set_character_position(0, -230.0, 32.1, 1200.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_camera_look_at(-230.0, 62.1, 1200.0)
	event.set_camera_position(-230.0, 72.1, 1300.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_6673bb50
