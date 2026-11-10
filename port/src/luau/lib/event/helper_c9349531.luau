--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_c9349531(
	world_coord_pos: f32,
	world_coord_pos_2: f32,
	world_coord_pos_3: f32,
	world_coord_rot: f32
)
	local var4: s32 = 0
	local angle: f32 = 0
	local active_chr_no: s32 = 0
	local var11: f32 = 0
	local at: number = 0
	vm.section(function()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.initialize_event()
		event.enable_drama_skip()
		var4 = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or var4
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		angle = event.wrap_angle(angle) or angle
		event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "dungeon/chara/mints_01in.gltf", "info", 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "dungeon/chara/monica_01in.gltf", "info", 0)
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 116.96, 18.76, 19.22)
		event.set_object_sequence_rotation(0, 0.0, -1.96, 0.0)
		event.delay_object_sequence_sound_track(0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 3)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(186.89, 58.05, -1.19)
		event.set_camera_sequence_look_at(50.97, 32.07, 20.9)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		if active_chr_no == 0 then
			event.move_camera_sequence_eased(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 160, 2, 0.4)
			event.move_object_sequence(0, 23.61, 18.53, -17.13, 140)
			event.set_object_sequence_motion(0, "丸太歩き", 4)
			event.delay_object_sequence_rotation_track(0, 130)
			event.rotate_object_sequence(0, 0.0, -1.0, 0.0, 10)
			at = 2
			wait_objects(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.3)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		else
			event.move_camera_sequence_eased(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 100, 2, 0.4)
			event.move_object_sequence(0, 23.61, 18.53, -17.13, 60)
			event.set_object_sequence_motion(0, "丸太歩き", 4)
			event.delay_object_sequence_rotation_track(0, 50)
			event.rotate_object_sequence(0, 0.0, -1.0, 0.0, 10)
			at = 3
			wait_objects(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.2)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		end
		event.set_object_handle_footstep_sound(0, 16)
		at = 4
		wait_frames(14)
		event.play_sound_effect(var4, 2)
		event.jump_object_sequence(0, -85.0, 0.0, 50.0, -0.25, 30)
		event.delay_object_sequence_rotation_track(0, 10)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 20)
		at = 5
		wait_frames(16)
		at = 6
		wait_objects(0)
		event.play_sound_effect(var4, 4)
		at = 7
		wait_frames(30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -170.0, 0.0, 50.0, 50)
		at = 8
		wait_camera()
		event.start_crossfade(30)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			var11 = out2 or var11
		end
		event.set_camera_sequence_look_at(-170.0, 30.0, 50.0)
		var11 = vm.f32(var11 - vm.f32(3.1415927))
		var11 = event.wrap_angle(var11) or var11
		event.set_camera_sequence_angle_height_distance(var11, 5.0, 100.0)
		at = 9
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		at = 10
		wait_frames(15)
		event.cancel_drama_scene_skip()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(0)
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			wait_frames_skipping(14)
		end
		if at <= 4 then
			wait_frames_skipping(16)
		end
		if at <= 5 then
			helper_238b5abc(0)
		end
		if at <= 6 then
			wait_frames_skipping(30)
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			var11 = vm.f32(var11 - vm.f32(3.1415927))
			helper_238b5abc(0)
		end
		if at <= 9 then
			wait_frames_skipping(15)
		end
		return true
	end)
	at = 11
	vm.entry(11)
	event.fade_in_screen(0)
	event.clear_object_sequence(0)
	event.set_object_handle_motion(0, "立ち")
	event.set_object_handle_position(0, -170.0, 0.0, 50.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.set_camera_look_at(-170.0, 30.0, 50.0)
	event.set_camera_position(-70.0, 35.0, 50.0)
	event.reset_follow_camera(0)
	event.delete_character_extension_packs(0)
end

return helper_c9349531
