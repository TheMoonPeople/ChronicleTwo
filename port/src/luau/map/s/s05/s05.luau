--!strict
--- Event script for the swamp fishing area: the arrival scene, the fishing rod trade with Noam, the Murdan scenes, and the NPC talks that advance the swamp progress counter.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local fish_monster_swamp = require("@lib/event/fish_monster_swamp")
local inventory = require("@lib/event/inventory")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local mints_slot: s32 = 0
local monica_slot: s32 = 0

--- Enables saving and fades the screen in when the map is entered.
local function fade_in_on_entry()
	event.set_save_control_bits(16, 1)
	event.fade_in_screen(15)
end

--- Loads the swamp character set, using the near-fade variant until the swamp progress counter reaches seven.
local function load_swamp_characters()
	local swamp_progress: s32 = 0
	swamp_progress = event.get_save_counter(3) or swamp_progress
	if swamp_progress < 7 then
		fish_monster_swamp.load_characters_wide_near_fade(1)
	else
		fish_monster_swamp.load_characters_wide_near_fade(0)
	end
end

--- Fades in on the party jumping down and walking into the swamp, then hands control back at the placed position.
local function play_swamp_reentry_walk(world_coord_pos: f32, world_coord_pos_2: f32, world_coord_pos_3: f32, world_coord_rot: f32)
	local sound_bank: s32 = 0
	local angle: f32 = 0
	local active_chr_no: s32 = 0
	local facing_angle: f32 = 0
	local at: number = 0
	vm.section(function()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		event.initialize_event()
		event.enable_drama_skip()
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or sound_bank
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
			object.wait_until_done(0)
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
			object.wait_until_done(0)
			event.set_object_sequence_motion(0, "ジャンプ", 2)
			event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.2)
			event.queue_object_sequence_next_motion(0, "着地", 6)
		end
		event.set_object_handle_footstep_sound(0, 16)
		at = 4
		wait.for_frame_count(14)
		event.play_sound_effect(sound_bank, 2)
		event.jump_object_sequence(0, -85.0, 0.0, 50.0, -0.25, 30)
		event.delay_object_sequence_rotation_track(0, 10)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 20)
		at = 5
		wait.for_frame_count(16)
		at = 6
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 4)
		at = 7
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -170.0, 0.0, 50.0, 50)
		at = 8
		camera.wait_until_done()
		event.start_crossfade(30)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			facing_angle = out2 or facing_angle
		end
		event.set_camera_sequence_look_at(-170.0, 30.0, 50.0)
		facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
		facing_angle = event.wrap_angle(facing_angle) or facing_angle
		event.set_camera_sequence_angle_height_distance(facing_angle, 5.0, 100.0)
		at = 9
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		at = 10
		wait.for_frame_count(15)
		event.cancel_drama_scene_skip()
	end, function(received: { any }): boolean
		if at <= 1 then
			cutscene.skip_command(0)
		end
		if at <= 2 then
			cutscene.skip_command(0)
		end
		if at <= 3 then
			wait.skip_frame_count(14)
		end
		if at <= 4 then
			wait.skip_frame_count(16)
		end
		if at <= 5 then
			cutscene.skip_command(0)
		end
		if at <= 6 then
			wait.skip_frame_count(30)
		end
		if at <= 7 then
			wait.background_load_skipping()
		end
		if at <= 8 then
			facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
			cutscene.skip_command(0)
		end
		if at <= 9 then
			wait.skip_frame_count(15)
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

--- Loads the party's characters, motion packs and message file for the swamp arrival scene.
local function load_arrival_scene_actors()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e215/e215_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e215/e215_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e215/e215_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e215/e215_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_message_file(0, 5, "event/e200/e215/e215.txt")
end

--- Swaps the two party character slots when the cutscene is skipped.
local function swap_party_slots()
	mints_slot = 0
	monica_slot = 32
	mints_slot = 32
	monica_slot = 0
end

--- Releases the party characters loaded for the swamp arrival scene.
local function unload_arrival_scene_actors()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
end

--- Plays the scene where the party runs into the swamp with an orbiting camera and a short argument.
local function cutscene_arrival_at_swamp()
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local midpoint_x: f32 = 0
	local midpoint_y: f32 = 0
	local midpoint_z: f32 = 0
	local camera_angle: f32 = 0
	local camera_angle_step: f32 = 0
	local i: s32 = 0
	local sound_bank: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(215, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(2800) or sound_bank
		load_arrival_scene_actors()
		event.enable_drama_skip()
		event.stop_music(0)
		event.set_object_handle_sound_bank(0, sound_bank)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2810.55, 19.2, 1417.95)
		event.set_camera_sequence_look_at(2838.92, 19.55, 1472.76)
		event.set_object_sequence_position(0, 3016.47, 0.01, 1619.33)
		event.set_object_sequence_rotation(0, 0.0, -2.17, 0.0)
		event.set_object_sequence_position(1, 3035.62, 0.01, 1589.73)
		event.set_object_sequence_rotation(1, 0.0, -2.28, 0.0)
		event.move_object_sequence(0, 2903.57, 0.01, 1552.25, 130)
		event.rotate_object_sequence(0, 0.0, -2.05, 0.0, 90)
		event.move_object_sequence(1, 2918.09, 0.01, 1527.87, 130)
		event.rotate_object_sequence(1, 0.0, -2.04, 0.0, 90)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "きょろきょろ歩き", 4, -1.0, 1)
		camera_angle = vm.f32(0.46)
		camera_angle_step = vm.f32(0.0066666664)
		i = 0
		while i < 121 do
			do
				local out1, out2, out3 = event.get_character_position(mints_slot)
				midpoint_x = out1 or midpoint_x
				midpoint_y = out2 or midpoint_y
				midpoint_z = out3 or midpoint_z
			end
			do
				local out1, out2, out3 = event.get_character_position(monica_slot)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.subtract_vectors(offset_x, offset_y, offset_z, midpoint_x, midpoint_y, midpoint_z)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.scale_vector(offset_x, offset_y, offset_z, 0.5)
				offset_x = out1 or offset_x
				offset_y = out2 or offset_y
				offset_z = out3 or offset_z
			end
			do
				local out1, out2, out3 = event.add_vectors(midpoint_x, midpoint_y, midpoint_z, offset_x, offset_y, offset_z)
				midpoint_x = out1 or midpoint_x
				midpoint_y = out2 or midpoint_y
				midpoint_z = out3 or midpoint_z
			end
			midpoint_y = vm.f32(midpoint_y + 20.0)
			event.set_camera_sequence_look_at(midpoint_x, midpoint_y, midpoint_z)
			do
				local out1, out2, out3 = event.copy_vector(midpoint_x, midpoint_y, midpoint_z)
				vector_x = out1 or vector_x
				vector_y = out2 or vector_y
				vector_z = out3 or vector_z
			end
			vector_x = vm.f32(vector_x + vm.f32(130.0 * vm.sin(camera_angle)))
			vector_z = vm.f32(vector_z + vm.f32(130.0 * vm.cos(camera_angle)))
			vector_y = vm.f32(vector_y + vm.f32(29.79))
			event.set_camera_sequence_position(vector_x, vector_y, vector_z)
			camera_angle = vm.f32(camera_angle + camera_angle_step)
			if camera_angle > vm.f32(3.1415927) then
				camera_angle = vm.f32(camera_angle - vm.f32(6.2831855))
			end
			if camera_angle <= vm.f32(-3.1415927) then
				camera_angle = vm.f32(camera_angle + vm.f32(6.2831855))
			end
			i = i + 1
			at = 2
			vm.wait(2)
		end
		at = 3
		wait.for_frame_count(10)
		event.set_camera_sequence_position(2803.91, 11.38, 1411.86)
		event.set_camera_sequence_look_at(2831.84, 19.55, 1460.49)
		event.set_object_sequence_position(0, 2831.19, 0.01, 1465.72)
		event.set_object_sequence_rotation(0, 0.0, -2.05, 0.0)
		event.set_object_sequence_position(1, 2837.63, 0.01, 1446.26)
		event.set_object_sequence_rotation(1, 0.0, -1.92, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 4
		message.show_voiced(2150010)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 4)
		event.set_object_sequence_motion(0, "待って", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "待ってL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 5
		message.show_voiced(2150020)
		event.reset_mouth_texture_animations()
		at = 6
		object.wait_until_done(0)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		at = 7
		wait.for_frame_count(6)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 8
		message.show_voiced(2150030)
		event.reset_mouth_texture_animations()
		at = 9
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "待って戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 10
		wait.for_frame_count(10)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(1, "左向く戻り", 2)
		event.wait_object_sequence_motion_end(1)
		at = 11
		object.wait_until_done(1)
		event.play_sound_effect(sound_bank, 5)
		event.queue_object_sequence_next_motion(1, "身を乗り出す", 2)
		event.queue_object_sequence_next_motion(1, "身を乗り出すＬ", 0)
		at = 12
		object.wait_until_done(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 13
		message.show_voiced(2150040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "身を乗り出す戻り", 6)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 14
		message.show_voiced(2150050)
		event.reset_mouth_texture_animations()
		event.queue_object_sequence_next_motion(0, "右向くうなづき", 2)
		event.queue_object_sequence_next_motion(0, "右向くL", 0)
		at = 15
		wait.for_frame_count(16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 16
		message.show_voiced(2150060)
		event.reset_mouth_texture_animations()
	end, function(received: { any }): boolean
		if at <= 1 then
			swap_party_slots()
			camera_angle = vm.f32(0.46)
			camera_angle_step = vm.f32(0.0066666664)
			i = 0
			midpoint_y = vm.f32(midpoint_y + 20.0)
			vector_x = vm.f32(vector_x + vm.f32(130.0 * vm.sin(camera_angle)))
			vector_z = vm.f32(vector_z + vm.f32(130.0 * vm.cos(camera_angle)))
			vector_y = vm.f32(vector_y + vm.f32(29.79))
			camera_angle = vm.f32(camera_angle + camera_angle_step)
			local _ = camera_angle > vm.f32(3.1415927)
			camera_angle = vm.f32(camera_angle - vm.f32(6.2831855))
			local _ = camera_angle <= vm.f32(-3.1415927)
			camera_angle = vm.f32(camera_angle + vm.f32(6.2831855))
			local _ = i < 121
			i = i + 1
		end
		if at <= 2 then
			wait.skip_frame_count(10)
		end
		if at <= 3 then
			message.show_voiced_skipping(2150010)
		end
		if at <= 4 then
			message.show_voiced_skipping(2150020)
		end
		if at <= 5 then
			cutscene.skip_command(0)
		end
		if at <= 6 then
			wait.skip_frame_count(6)
		end
		if at <= 7 then
			message.show_voiced_skipping(2150030)
		end
		if at <= 8 then
			cutscene.skip_command(1)
		end
		if at <= 9 then
			wait.skip_frame_count(10)
		end
		if at <= 10 then
			cutscene.skip_command(1)
		end
		if at <= 11 then
			cutscene.skip_command(1)
		end
		if at <= 12 then
			message.show_voiced_skipping(2150040)
		end
		if at <= 13 then
			message.show_voiced_skipping(2150050)
		end
		if at <= 14 then
			wait.skip_frame_count(16)
		end
		if at <= 15 then
			message.show_voiced_skipping(2150060)
		end
		return true
	end)
	at = 17
	vm.entry(17)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 18
	wait.for_frame_count(45)
	unload_arrival_scene_actors()
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
end

--- Plays the arrival scene and sets the swamp progress counter to the first stage.
local function play_arrival_scene()
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		at = 2
		cutscene_arrival_at_swamp()
		event.set_save_counter(3, 1)
		fish_monster_swamp.update_progress_function_points()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				cutscene_arrival_at_swamp()
				return vm.continue_with(function()
					event.set_save_counter(3, 1)
					fish_monster_swamp.update_progress_function_points()
					return
				end)
			end
			fish_monster_swamp.print_progress_debug()
			return 0
		end
		return nil
	end)
end

--- Loads the party, Noam, the fishing rod and the item-get effect for the rod trade scene.
local function load_noam_trade_actors()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e220/e220_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e220/e220_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e220/e220_noam.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, 34, "wine")
	event.load_character(5, "item/f_rod.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(4, 35)
	event.clear_object_sequence(3, 35)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(5, 36)
	event.clear_object_sequence(4, 36)
	event.set_object_sequence_object(4, 5)
	event.load_message_file(0, 5, "event/e200/e220/e220.txt")
end

--- Releases the characters loaded for the rod trade scene.
local function unload_noam_trade_actors()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
end

--- Swaps the two party character slots when the cutscene is skipped.
local function swap_party_slots_noam_trade()
	mints_slot = 0
	monica_slot = 32
	mints_slot = 32
	monica_slot = 0
end

--- Does nothing when the rod trade scene is skipped.
local function skip_noop() end

--- Plays the scene where Noam trades a fishing rod and bait for the wine and explains fishing.
local function cutscene_noam_rod_trade()
	local item: s32 = 0
	local wine_was_visible: s32 = 0
	local flag: s32 = 0
	local shared_sound_bank: s32 = 0
	local noam_sound_bank: s32 = 0
	local flag_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		noam_sound_bank = event.load_sound_effect_file_2(2803) or noam_sound_bank
		shared_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or shared_sound_bank
		event.fade_out_screen(30)
		at = 1
		wait.for_frame_count(45)
		load_noam_trade_actors()
		event.stop_music(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_character_active(0, 9)
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(2187.89, 60.39, 925.42)
		event.set_camera_sequence_look_at(2234.31, 29.74, 1032.94)
		event.set_object_sequence_position(0, 2298.04, 0.0, 1110.65)
		event.set_object_sequence_rotation(0, 0.0, -2.41, 0.0)
		event.set_object_sequence_position(1, 2311.91, 0.0, 1092.4)
		event.set_object_sequence_rotation(1, 0.0, -2.28, 0.0)
		event.set_object_sequence_position(2, 2199.07, 29.83, 981.55)
		event.set_object_sequence_rotation(2, 0.0, 2.68, 0.0)
		wine_was_visible = event.is_object_handle_frame_visible(2, "wine") or wine_was_visible
		event.set_object_handle_frame_visible(2, "wine", 0)
		event.set_object_handle_sound_bank(2, noam_sound_bank)
		event.fade_in_screen(30)
		flag = event.get_save_flag(220) or flag
		if flag == 0 then
			event.set_save_flag(220, 1)
			event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(2, "釣り", 4)
			at = 2
			wait.for_frame_count(15)
			event.set_object_sequence_motion(2, "釣り会話", 0)
			event.delay_object_sequence_motion_track(2, 195)
			event.set_object_sequence_motion(2, "釣り", 0)
			at = 3
			message.show_voiced(2200010)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_motion(2, "釣り", 0)
			event.set_object_sequence_motion(0, "会話", 2)
			event.queue_object_sequence_next_motion(0, "立ち", 0)
			event.set_mouth_texture_animations(0, "通常口パク")
			at = 4
			message.show_voiced(2200020)
			event.reset_mouth_texture_animations()
			at = 5
			object.wait_until_done(0)
			event.set_object_sequence_motion(2, "釣り会話", 0)
			event.delay_object_sequence_motion_track(2, 270)
			event.set_object_sequence_motion(2, "釣り", 0)
			at = 6
			message.show_voiced(2200030)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_motion(2, "釣り", 0)
			event.set_object_sequence_motion(2, "釣り会話", 0)
			event.delay_object_sequence_motion_track(2, 180)
			event.set_object_sequence_motion(2, "釣り", 0)
			at = 7
			message.show_voiced(2200040)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_object_sequence_motion(2, "釣り", 0)
		else
			event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(2, "釣り", 4)
		end
		at = 8
		wait.for_frame_count(15)
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "右向く", 6)
		event.queue_object_sequence_next_motion(2, "右向くL", 0)
		at = 9
		wait.for_frame_count(10)
		at = 10
		message.show_voiced(2200050)
		at = 11
		message.show_voiced(2200055)
		event.set_object_sequence_motion(0, "右向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_object_sequence_motion(1, "左向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		at = 12
		wait.for_frame_count(16)
		event.open_use_item_menu(370)
		at = 13
		vm.wait(13)
		item = vmhost.used_item() or item
		if item == 370 then
			event.set_save_flag(28, 1)
			event.set_object_handle_frame_draw_flag(2, "wine", wine_was_visible)
			event.set_object_handle_frame_visible(2, "wine", 1)
			event.set_camera_sequence_position(2256.03, 46.87, 1157.6)
			event.set_camera_sequence_look_at(2209.88, 21.76, 1049.74)
			event.set_object_sequence_position(0, 2212.29, 0.0, 1088.81)
			event.set_object_sequence_rotation(0, 0.0, 3.03, 0.0)
			event.set_object_sequence_position(1, 2241.69, 0.0, 1085.4)
			event.set_object_sequence_rotation(1, 0.0, -2.64, 0.0)
			event.set_object_sequence_position(2, 2211.11, -1.43, 1044.24)
			event.set_object_sequence_rotation(2, 0.0, 0.16, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(2, "とびおり", 6)
			event.set_mouth_texture_animations(0, "通常口パク")
			at = 14
			message.show_voiced(2200080)
			event.reset_mouth_texture_animations()
			event.set_mouth_texture_animations(0, "通常口パク")
			at = 15
			message.show_voiced(2200085)
			event.reset_mouth_texture_animations()
			event.play_sound_effect(noam_sound_bank, 5)
			event.set_object_sequence_motion(2, "竿やる", 2)
			event.queue_object_sequence_next_motion(2, "竿やるL", 0)
			at = 16
			message.show_voiced(2200090)
			event.set_object_handle_frame_visible(2, "rod", 0)
			event.set_object_handle_frame_visible(2, "obj3", 0)
			event.set_object_handle_frame_visible(2, "obj4", 0)
			event.set_character_active(0, monica_slot)
			event.set_character_active(0, 34)
			event.set_character_active(1, 35)
			event.set_character_active(1, 36)
			event.set_camera_sequence_position(2216.13, 50.5, 1037.69)
			event.set_camera_sequence_look_at(2211.23, 28.7, 1078.48)
			event.set_object_sequence_position(4, 2209.46, 34.32, 1071.72)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
			event.play_sound_effect(noam_sound_bank, 6)
			event.play_sound_effect(shared_sound_bank, 0)
			event.attach_character_to_frame(mints_slot, "gun_hand", 35)
			event.set_object_sequence_motion(0, "釣り竿ゲット", 4, -1.0, 1)
			event.set_object_sequence_motion(4, "発動", 6)
			at = 17
			inventory.announce_received(302, 1)
			at = 18
			inventory.announce_received(313, 1)
			event.set_character_active(1, monica_slot)
			event.set_character_active(1, 34)
			event.set_character_active(0, 35)
			event.set_character_active(0, 36)
			event.set_camera_sequence_position(2256.03, 46.87, 1157.6)
			event.set_camera_sequence_look_at(2209.88, 21.76, 1049.74)
			event.set_object_handle_frame_visible(2, "chn64", 0)
			event.set_object_sequence_position(0, 2212.29, 0.0, 1088.81)
			event.set_object_sequence_rotation(0, 0.0, 3.03, 0.0)
			event.set_object_sequence_position(1, 2241.69, 0.0, 1085.4)
			event.set_object_sequence_rotation(1, 0.0, -2.64, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
			event.set_object_sequence_motion(2, "立ち", 4)
			event.set_object_sequence_motion(2, "会話", 6)
			event.queue_object_sequence_next_motion(2, "立ち", 0)
			at = 19
			message.show_voiced(2200095)
			event.set_message_window_mode(0, 8)
			event.open_message_window_2(
				0,
				"[(!)] 釣りをするには、釣り竿を装備してください。\n   次にエサ（ミミー）をアイテムメニューのコマンドで\n   竿につけます。エサをつけ忘れると釣れません。"
			)
			at = 20
			message.show(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"[(!)]その状態で、水際に立って(O)ボタンを\n   押せば、釣りを始めることができます。"
			)
			at = 21
			message.show(0, -1, 8, 0, 0)
			event.set_message_window_mode(0, 7)
		else
			event.set_object_sequence_motion(0, "右向く戻り", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "立ち", 4)
			event.set_object_sequence_motion(1, "左向く戻り", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(1, "立ち", 4)
			at = 22
			wait.for_frame_count(16)
			if item <= 0 then
				event.set_object_sequence_motion(2, "そっぽ向く", 2)
				event.queue_object_sequence_next_motion(2, "そっぽ向くL", 0)
				at = 23
				wait.for_frame_count(5)
				at = 24
				message.show_voiced(2200060)
				at = 25
				object.wait_until_done(2)
				event.set_camera_sequence_position(2342.69, 17.58, 1135.11)
				event.set_camera_sequence_look_at(2285.51, 29.74, 1075.97)
			else
				event.set_object_sequence_motion(2, "首を振る", 6)
				event.queue_object_sequence_next_motion(2, "釣り", 0)
				at = 26
				wait.for_frame_count(15)
				at = 27
				message.show_voiced(2200070)
				at = 28
				object.wait_until_done(2)
				event.set_camera_sequence_position(2342.69, 17.58, 1135.11)
				event.set_camera_sequence_look_at(2285.51, 29.74, 1075.97)
			end
		end
		event.fade_out_screen(30)
		at = 29
		wait.for_frame_count(45)
		unload_noam_trade_actors()
		event.set_character_active(1, 9)
		flag_2 = event.get_save_flag(28) or flag_2
		if flag_2 ~= 0 then
			event.add_inventory_item(302, 1)
			event.add_inventory_item(313, 1)
			at = 30
			inventory.open_overflow_menu()
			event.remove_item(370, 1)
			event.attach_object_handle_to_character(0, 9)
			event.set_object_handle_frame_draw_flag(0, "wine", 1)
		end
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		return
	end, function(received: { any })
		if at <= 30 then
			if at <= 1 then
				swap_party_slots_noam_trade()
				wait.skip_frame_count(15)
			end
			if at <= 2 then
				message.show_voiced_skipping(2200010)
			end
			if at <= 3 then
				message.show_voiced_skipping(2200020)
			end
			if at <= 4 then
				cutscene.skip_command(0)
			end
			if at <= 5 then
				message.show_voiced_skipping(2200030)
			end
			if at <= 6 then
				message.show_voiced_skipping(2200040)
			end
			if at <= 7 then
				wait.skip_frame_count(15)
			end
			if at <= 8 then
				wait.skip_frame_count(10)
			end
			if at <= 9 then
				message.show_voiced_skipping(2200050)
			end
			if at <= 10 then
				message.show_voiced_skipping(2200055)
			end
			if at <= 11 then
				wait.skip_frame_count(16)
			end
			if at <= 13 then
				message.show_voiced_skipping(2200080)
			end
			if at <= 14 then
				message.show_voiced_skipping(2200085)
			end
			if at <= 15 then
				message.show_voiced_skipping(2200090)
			end
			if at <= 16 then
				inventory.resume_obtained_message(302, 1)
			end
			if at <= 17 then
				inventory.resume_obtained_message(313, 1)
			end
			if at <= 18 then
				message.show_voiced_skipping(2200095)
			end
			if at <= 19 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if at <= 20 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if at <= 21 then
				wait.skip_frame_count(16)
			end
			if at <= 22 then
				wait.skip_frame_count(5)
			end
			if at <= 23 then
				message.show_voiced_skipping(2200060)
			end
			if at <= 24 then
				cutscene.skip_command(2)
			end
			if at <= 25 then
				wait.skip_frame_count(15)
			end
			if at <= 26 then
				message.show_voiced_skipping(2200070)
			end
			if at <= 27 then
				cutscene.skip_command(2)
			end
			if at <= 28 then
				wait.skip_frame_count(45)
			end
			if at <= 29 then
				skip_noop()
				cutscene.skip_step()
			end
			return 0
		end
		return nil
	end)
end

--- Loads the party, Murdan, fishing line and water effect characters for the line-snapping scene.
local function load_murdan_line_scene_actors()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e240/e240_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e240/e240_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e240/e240_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e240/e240_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e240/e240_madan.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e200/e240/e240_sao.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(4, 35)
	event.clear_object_sequence(3, 35)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "event/e200/e240/e240_wink.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.set_scene_character_type(38, 4)
	event.load_character(5, "event/e200/e240/mizubasira.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e200/e240/hamon.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e240/e240_line.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(5, 41)
	event.clear_object_sequence(4, 41)
	event.set_object_sequence_object(4, 5)
	event.load_character(5, "event/e200/e240/e240_line1.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.load_message_file(0, 5, "event/e200/e240/e240.txt")
end

--- Swaps the two party character slots when the cutscene is skipped.
local function swap_party_slots_murdan_line()
	mints_slot = 0
	monica_slot = 32
	mints_slot = 32
	monica_slot = 0
end

--- Releases every character loaded for the line-snapping scene.
local function unload_murdan_line_scene_actors()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
end

--- Plays the scene where Murdan rises from the water and breaks the fishing line.
local function cutscene_murdan_snaps_line()
	local sound_bank: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(240, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait.for_frame_count(4)
		event.load_music(193)
		event.play_music(1)
		event.load_map_sounds(2812)
		sound_bank = event.load_sound_effect_file_2(2812) or sound_bank
		event.fade_out_screen(30)
		at = 2
		wait.for_frame_count(45)
		load_murdan_line_scene_actors()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 35)
		event.set_character_active(0, 34)
		event.set_character_active(1, 41)
		event.set_camera_position(-111.63, 33.95, -443.55)
		event.set_camera_look_at(-297.56, 30.0, -373.68)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(0, -303.57, 0.0, -356.14)
		event.set_object_sequence_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(1, -327.35, 0.0, -377.28)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(2, -127.39, 0.0, -701.37)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.set_character_rotation(41, 0.0, 0.0, 1.57)
		event.attach_character_to_frame(35, "ito", 41)
		at = 3
		vm.wait(3)
		event.attach_character_to_frame(mints_slot, "gun_hand", 35)
		event.play_sound_effect(sound_bank, 4)
		event.play_sound_effect(sound_bank, 6)
		event.fade_in_screen(30)
		event.set_character_motion(41, "糸切れる", 5, -1, 1)
		event.set_object_sequence_motion(0, "竿を引く", 4, -1.0, 1)
		event.set_object_sequence_motion(3, "竿を引く", 4)
		event.set_object_sequence_motion(1, "釣り観戦", 4, -1.0, 1)
		at = 4
		wait.for_frame_count(15)
		event.move_object_sequence(0, -300.7, 0.0, -364.52, 90)
		event.play_sound_effect(sound_bank, 5)
		at = 5
		object.wait_until_done(0)
		at = 6
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-331.46, 23.14, -254.41)
		event.set_camera_sequence_look_at(-295.08, 10.97, -376.82)
		event.move_object_sequence(0, -297.56, 0.0, -373.68, 90)
		event.play_sound_effect(sound_bank, 8)
		at = 7
		object.wait_until_done(0)
		at = 8
		wait.for_frame_count(60)
		event.stop_sound_effect(sound_bank, 4)
		event.stop_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 7)
		event.set_character_motion(41, "糸切れる", 2, -1, 1)
		event.set_character_active(1, 42)
		event.set_character_position(42, -184.19, -4.56, -446.98)
		event.set_character_rotation(42, 0.0, 2.57, 0.0)
		event.set_character_motion(42, "糸切れる", 2, -1, 1)
		event.set_object_sequence_motion(0, "糸切れる", 2)
		event.set_object_sequence_motion(3, "糸切れる", 2)
		event.set_object_sequence_motion(1, "ユリス追う（顔）", 2)
		at = 9
		wait.for_frame_count(15)
		event.play_sound_effect(sound_bank, 5)
		at = 10
		wait.for_frame_count(30)
		event.set_character_active(0, 42)
		event.set_character_active(0, 41)
		event.set_character_active(0, 35)
		event.delete_character(35)
		event.delete_character(41)
		event.delete_character(42)
		event.set_object_sequence_position(0, -284.58, 0.0, -370.78)
		event.set_object_sequence_rotation(0, 0.0, 2.93, 0.0)
		event.set_object_sequence_position(1, -370.53, 0.0, -348.56)
		event.set_object_sequence_rotation(1, 0.0, 0.89, 0.0)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.move_object_sequence(1, -334.31, 0.0, -340.4, 60)
		event.set_camera_sequence_position(-390.3, 27.35, -176.88)
		event.set_camera_sequence_look_at(-290.9, 59.06, -387.86)
		event.delay_camera_sequence_shake_track(30)
		event.shake_camera_sequence(0.0, 0.3, 0.0, 90)
		event.set_character_active(1, 40)
		event.set_character_position(40, -127.39, -18.0, -701.37)
		event.set_character_rotation(40, 0.0, -1.68, 0.0)
		at = 11
		wait.for_frame_count(30)
		at = 12
		wait.for_frame_count(30)
		event.set_character_active(1, 34)
		event.set_object_sequence_motion(2, "浮かび笑", 6)
		event.queue_object_sequence_next_motion(2, "待機")
		event.set_character_active(1, 39)
		event.set_character_position(39, -241.56, -9.72, -479.54)
		event.set_character_rotation(39, 0.0, 0.0, 0.0)
		event.set_character_motion(39, "水柱", 2, -1, 1)
		at = 13
		object.wait_until_done(1)
		event.play_sound_effect(sound_bank, 9)
		event.rotate_object_sequence(1, 0.0, 2.45, 0.0, 10)
		at = 14
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(0, "マーダン出現", 2)
		event.set_object_sequence_motion(3, "マーダン出現", 2)
		event.queue_object_sequence_next_motion(0, "マーダン出現L")
		event.queue_object_sequence_next_motion(3, "マーダン出現L")
		at = 15
		wait.for_frame_count(30)
		at = 16
		wait.for_frame_count(15)
		event.fade_out_music(60)
		at = 17
		wait.for_frame_count(60)
		event.stop_music(1)
		at = 18
		vm.wait(18)
		at = 19
		vm.wait(19)
		at = 20
		vm.wait(20)
		at = 21
		vm.wait(21)
		event.load_music(193)
		event.play_music(0)
		event.stop_sound_effect(sound_bank, 9)
		event.play_sound_effect(sound_bank, 10)
		at = 22
		wait.for_frame_count(60)
		event.set_character_active(0, 39)
		event.delete_character(39)
		event.set_object_sequence_motion(2, "あせる")
		at = 23
		wait.for_frame_count(10)
		at = 24
		message.show_voiced_for_stopping(2400010, -1)
		at = 25
		message.show_voiced_for_stopping(2400015, -1)
		event.wait_object_sequence_motion_end(2)
		event.set_object_sequence_motion(2, "ユリスを見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL")
		at = 26
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "モニカを見る", 2)
		event.queue_object_sequence_next_motion(2, "モニカを見るL")
		at = 27
		wait.for_frame_count(120)
		event.set_camera_sequence_position(-312.91, 53.63, -372.03)
		event.set_camera_sequence_look_at(-334.31, 16.44, -340.4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 28
		message.show_voiced(2400020)
		event.reset_mouth_texture_animations()
		at = 29
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 30
		message.show_voiced(2400025)
		event.reset_mouth_texture_animations()
		at = 31
		object.wait_until_done(1)
		at = 32
		wait.for_frame_count(15)
		event.set_camera_sequence_position(-390.3, 27.35, -176.88)
		event.set_camera_sequence_look_at(-290.9, 59.06, -387.86)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.set_object_sequence_position(0, -305.91, 0.0, -329.68)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(2, "目ほそめ", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめL", 4)
		at = 33
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 4)
		at = 34
		message.show_voiced_for_stopping(2400030, -1)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "ウィンク", 2, -1, 1)
		event.set_object_sequence_motion(2, "ウィンク", 2)
		at = 35
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "目とじ", 2)
		event.queue_object_sequence_next_motion(2, "目とじL", 4)
		at = 36
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 4)
		at = 37
		message.show_voiced_for_stopping(2400035, -1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.wait_object_sequence_motion_end(2)
		event.set_object_sequence_motion(2, "目とじ戻り", 2)
		event.queue_object_sequence_next_motion(2, "モニカを見る", 2)
		event.queue_object_sequence_next_motion(2, "モニカを見るL")
		event.set_object_sequence_motion(1, "上向く", 2)
		event.queue_object_sequence_next_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL")
		at = 38
		message.show_voiced(2400040)
		at = 39
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "上向く会話", 2)
		event.queue_object_sequence_next_motion(1, "上向くL")
		at = 40
		message.show_voiced(2400045)
		at = 41
		object.wait_until_done(1)
		event.set_object_sequence_motion(2, "会話")
		at = 42
		message.show_voiced(2400050)
		event.set_object_sequence_motion(2, "目ほそめ", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめL", 4)
		at = 43
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目とじ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 4)
		at = 44
		message.show_voiced_for_stopping(2400055, -1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(-292.54, 67.5, -392.04)
		event.set_camera_sequence_look_at(-319.35, 18.11, -332.98)
		event.set_object_sequence_motion(1, "上向きから頭抱え", 2)
		event.queue_object_sequence_next_motion(1, "頭かかえＬ", 4)
		event.set_object_sequence_motion(0, "左向く", 2)
		event.queue_object_sequence_next_motion(0, "左向くL")
		at = 45
		message.show_voiced(2400060)
		at = 46
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "左向く戻り", 2)
		event.queue_object_sequence_next_motion(0, "上向く", 2)
		event.queue_object_sequence_next_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 47
		message.show_voiced(2400070)
		event.reset_mouth_texture_animations()
		at = 48
		object.wait_until_done(0)
		event.set_camera_sequence_position(-348.01, 19.24, -271.83)
		event.set_camera_sequence_look_at(-309.88, 30.88, -357.76)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(2, "ユリスを見る", 6)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL", 4)
		at = 49
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 50
		message.show_voiced_for_stopping(2400080, -1)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "ウィンク", 2, -1, 1)
		event.set_object_sequence_motion(2, "ぶちゅー", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL")
		event.wait_object_sequence_motion_end(2)
		at = 51
		message.show_voiced_for_stopping(2400085, -1)
		event.set_character_active(0, 38)
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 52
		message.show_voiced(2400090)
		at = 53
		message.show_voiced_for_stopping(2400095, -1)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "ウィンク", 2, -1, 1)
		event.set_object_sequence_motion(2, "ウィンク", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見会話")
		at = 54
		message.show_voiced_for_stopping(2400100, -1)
		event.set_character_active(0, 38)
		at = 55
		message.show_voiced_for_stopping(2400105, -1)
		at = 56
		message.show_voiced(2400110)
		at = 57
		message.show_voiced_for_stopping(2400115, -1)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "ウィンク", 2, -1, 1)
		event.set_object_sequence_motion(2, "ウィンク", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL")
		at = 58
		wait.for_frame_count(60)
		event.set_character_active(0, 38)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 59
		message.show_voiced(2400120)
		at = 60
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 61
		message.show_voiced(2400125)
		at = 62
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "上向くL")
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 63
		message.show_voiced(2400130)
		event.set_object_sequence_motion(1, "上向きから驚き", 2)
		event.queue_object_sequence_next_motion(1, "驚きＬ")
		event.queue_object_sequence_next_motion(2, "モニカを見る", 2)
		event.queue_object_sequence_next_motion(2, "モニカを見るL")
		event.play_sound_effect(sound_bank, 11)
		at = 64
		message.show_voiced(2400140)
		at = 65
		object.wait_until_done(1)
		at = 66
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-756.17, 221.27, 17.93)
		event.set_camera_sequence_look_at(-308.68, 56.91, -420.42)
		event.stop_sound_effect(sound_bank, 10)
		at = 67
		wait.for_frame_count(15)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 68
		message.show_voiced_for_stopping(2400150, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "ユリスを見るL")
		event.fade_out_music(60)
		at = 69
		wait.for_frame_count(60)
		event.fade_out_screen(30)
		at = 70
		wait.for_frame_count(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait.skip_frame_count(45)
		end
		if at <= 2 then
			swap_party_slots_murdan_line()
		end
		if at <= 3 then
			wait.skip_frame_count(15)
		end
		if at <= 4 then
			cutscene.skip_command(0)
		end
		if at <= 5 then
			wait.skip_frame_count(30)
		end
		if at <= 6 then
			cutscene.skip_command(0)
		end
		if at <= 7 then
			wait.skip_frame_count(60)
		end
		if at <= 8 then
			wait.skip_frame_count(15)
		end
		if at <= 9 then
			wait.skip_frame_count(30)
		end
		if at <= 10 then
			wait.skip_frame_count(30)
		end
		if at <= 11 then
			wait.skip_frame_count(30)
		end
		if at <= 12 then
			cutscene.skip_command(1)
		end
		if at <= 13 then
			cutscene.skip_command(1)
		end
		if at <= 14 then
			wait.skip_frame_count(30)
		end
		if at <= 15 then
			wait.skip_frame_count(15)
		end
		if at <= 16 then
			wait.skip_frame_count(60)
		end
		if at <= 21 then
			wait.skip_frame_count(60)
		end
		if at <= 22 then
			wait.skip_frame_count(10)
		end
		if at <= 23 then
			message.show_voiced_for_stopping_skipping(2400010, -1)
		end
		if at <= 24 then
			message.show_voiced_for_stopping_skipping(2400015, -1)
		end
		if at <= 25 then
			wait.skip_frame_count(30)
		end
		if at <= 26 then
			wait.skip_frame_count(120)
		end
		if at <= 27 then
			message.show_voiced_skipping(2400020)
		end
		if at <= 28 then
			cutscene.skip_command(1)
		end
		if at <= 29 then
			message.show_voiced_skipping(2400025)
		end
		if at <= 30 then
			cutscene.skip_command(1)
		end
		if at <= 31 then
			wait.skip_frame_count(15)
		end
		if at <= 32 then
			cutscene.skip_command(2)
		end
		if at <= 33 then
			message.show_voiced_for_stopping_skipping(2400030, -1)
		end
		if at <= 34 then
			wait.skip_frame_count(30)
		end
		if at <= 35 then
			cutscene.skip_command(2)
		end
		if at <= 36 then
			message.show_voiced_for_stopping_skipping(2400035, -1)
		end
		if at <= 37 then
			message.show_voiced_skipping(2400040)
		end
		if at <= 38 then
			cutscene.skip_command(1)
		end
		if at <= 39 then
			message.show_voiced_skipping(2400045)
		end
		if at <= 40 then
			cutscene.skip_command(1)
		end
		if at <= 41 then
			message.show_voiced_skipping(2400050)
		end
		if at <= 42 then
			cutscene.skip_command(2)
		end
		if at <= 43 then
			message.show_voiced_for_stopping_skipping(2400055, -1)
		end
		if at <= 44 then
			message.show_voiced_skipping(2400060)
		end
		if at <= 45 then
			cutscene.skip_command(1)
		end
		if at <= 46 then
			message.show_voiced_skipping(2400070)
		end
		if at <= 47 then
			cutscene.skip_command(0)
		end
		if at <= 48 then
			cutscene.skip_command(2)
		end
		if at <= 49 then
			message.show_voiced_for_stopping_skipping(2400080, -1)
		end
		if at <= 50 then
			message.show_voiced_for_stopping_skipping(2400085, -1)
		end
		if at <= 51 then
			message.show_voiced_skipping(2400090)
		end
		if at <= 52 then
			message.show_voiced_for_stopping_skipping(2400095, -1)
		end
		if at <= 53 then
			message.show_voiced_for_stopping_skipping(2400100, -1)
		end
		if at <= 54 then
			message.show_voiced_for_stopping_skipping(2400105, -1)
		end
		if at <= 55 then
			message.show_voiced_skipping(2400110)
		end
		if at <= 56 then
			message.show_voiced_for_stopping_skipping(2400115, -1)
		end
		if at <= 57 then
			wait.skip_frame_count(60)
		end
		if at <= 58 then
			message.show_voiced_skipping(2400120)
		end
		if at <= 59 then
			cutscene.skip_command(0)
		end
		if at <= 60 then
			message.show_voiced_skipping(2400125)
		end
		if at <= 61 then
			cutscene.skip_command(0)
		end
		if at <= 62 then
			message.show_voiced_skipping(2400130)
		end
		if at <= 63 then
			message.show_voiced_skipping(2400140)
		end
		if at <= 64 then
			cutscene.skip_command(1)
		end
		if at <= 65 then
			wait.skip_frame_count(30)
		end
		if at <= 66 then
			wait.skip_frame_count(15)
		end
		if at <= 67 then
			message.show_voiced_for_stopping_skipping(2400150, -1)
		end
		if at <= 68 then
			wait.skip_frame_count(60)
		end
		if at <= 69 then
			wait.skip_frame_count(35)
		end
		return true
	end)
	at = 71
	vm.entry(71)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 4)
	event.stop_sound_effect(sound_bank, 6)
	event.stop_sound_effect(sound_bank, 10)
	event.stop_music(0)
	unload_murdan_line_scene_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads the party, Murdan and the spell effect characters for the spell-release scene.
local function load_murdan_spell_scene_actors()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		mints_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		mints_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e245/e245_madan.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_object_handle_to_character(4, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 4)
	event.load_character(5, "event/e200/e245/e245_ma_kaeru.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(6, 39)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 6)
	event.set_scene_character_type(39, 4)
	event.load_character(5, "event/e200/e245/e245_ma_hamon.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e200/e245/e245_magicwink.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.load_character(5, "event/e200/e245/e245_pink.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.load_message_file(0, 5, "event/e200/e245/e245.txt")
end

--- Swaps the two party character slots when the cutscene is skipped.
local function swap_party_slots_murdan_spell()
	mints_slot = 0
	monica_slot = 32
	mints_slot = 32
	monica_slot = 0
end

--- Releases the characters loaded for the spell-release scene.
local function unload_murdan_spell_scene_actors()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(37)
	end
	event.delete_character(34)
	event.delete_character(38)
	event.delete_character(41)
	event.delete_character(39)
	event.delete_character(40)
end

--- Plays the scene where Murdan releases the pink-world spell and leaves as a frog.
local function cutscene_murdan_releases_spell()
	local sound_bank: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(245, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 2
		wait.for_frame_count(4)
		event.load_music(193)
		event.play_music(0)
		sound_bank = event.load_sound_effect_file_2(2815) or sound_bank
		event.fade_out_screen(30)
		at = 3
		wait.for_frame_count(45)
		load_murdan_spell_scene_actors()
		event.enable_drama_skip()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 34)
		event.set_camera_sequence_position(-390.3, 27.35, -176.88)
		event.set_camera_sequence_look_at(-290.9, 59.06, -387.86)
		event.set_character_position(0, -297.56, 0.0, -373.68)
		event.set_character_rotation(0, 0.0, 2.57, 0.0)
		event.set_character_active(1, 40)
		event.set_character_position(40, -127.39, -18.0, -701.37)
		event.set_character_rotation(40, 0.0, -1.68, 0.0)
		event.set_object_sequence_position(0, -289.3, 0.0, -369.79)
		event.set_object_sequence_rotation(0, 0.0, 2.93, 0.0)
		event.set_object_sequence_position(1, -320.6, 0.0, -374.1)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_object_sequence_position(2, -127.39, 0.0, -701.37)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_bank, 4)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 2, -1.0, 1)
		event.set_object_sequence_motion(2, "笑う", 2)
		event.queue_object_sequence_next_motion(2, "会話速", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "会話速", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 4)
		at = 4
		wait.for_frame_count(15)
		at = 5
		message.show_voiced_for_stopping(2450010, -1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 4)
		event.set_object_sequence_motion(2, "会話速", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 2)
		event.queue_object_sequence_next_motion(2, "会話速", 2)
		event.queue_object_sequence_next_motion(2, "目ほそめ会話", 4)
		at = 6
		message.show_voiced_for_stopping(2450015, -1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 4)
		at = 7
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "笑う", 4)
		at = 8
		message.show_voiced_for_stopping(2450020, -1)
		event.set_object_sequence_motion(2, "ユリスを見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリスを見るL", 4)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 9
		message.show_voiced(2450030)
		at = 10
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "上向くL")
		event.set_object_sequence_motion(2, "ユリス見会話")
		at = 11
		message.show_voiced_for_stopping(2450040, -1)
		event.set_object_sequence_motion(2, "ウィンク", 2)
		event.queue_object_sequence_next_motion(2, "待機")
		at = 12
		wait.for_frame_count(30)
		event.set_character_active(1, 38)
		event.set_character_position(38, -127.39, 0.0, -701.37)
		event.set_character_rotation(38, 0.0, -1.68, 0.0)
		event.set_character_motion(38, "魔法解く", 2, -1, 1)
		event.set_character_active(1, 41)
		event.set_character_position(41, -127.39, 0.0, -701.37)
		event.set_character_rotation(41, 0.0, -1.68, 0.0)
		event.set_character_motion(41, "桃色世界", 2, -1, 1)
		event.play_sound_effect(sound_bank, 5)
		at = 13
		wait.for_frame_count(150)
		event.set_character_visible(41, 0, 1, 0.025)
		at = 14
		wait.for_frame_count(40)
		event.set_object_sequence_motion(0, "上向く会話", 2)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		at = 15
		message.show_voiced(2450050)
		at = 16
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "上向くL")
		event.set_object_sequence_motion(2, "ユリスを見る", 2)
		event.queue_object_sequence_next_motion(2, "ユリス見会話")
		at = 17
		object.wait_until_done(2)
		at = 18
		message.show_voiced_for_stopping(2450060, -1)
		event.set_object_sequence_position(4, -127.39, 0.0, -701.37)
		event.set_object_sequence_rotation(4, 0.0, -1.68, 0.0)
		event.set_character_scale(39, 2.0, 2.0, 2.0)
		event.delay_object_sequence_motion_track(2, 70)
		event.set_object_sequence_motion(2, "帰る", 2)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(4, "帰る", 5)
		event.delay_object_sequence_motion_track(4, 70)
		event.set_object_sequence_motion(4, "帰る", 6)
		event.delay_object_sequence_sound_track(2, 70)
		event.play_object_sequence_sound(2, sound_bank, 6)
		at = 19
		message.show_voiced_for_stopping(2450070, -1)
		at = 20
		object.wait_until_done(2)
		event.set_character_active(0, 39)
		event.set_character_active(0, 40)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, -324.44, 0.0, -385.55)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_camera_sequence_position(-247.47, 25.33, -442.62)
		event.set_camera_sequence_look_at(-302.69, 22.64, -384.86)
		event.set_object_sequence_motion(0, "左向く", 2)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 21
		message.show_voiced(2450080)
		event.reset_mouth_texture_animations()
		at = 22
		object.wait_until_done(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 23
		message.show_voiced(2450090)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 24
		message.show_voiced(2450100)
		event.reset_mouth_texture_animations()
		at = 25
		object.wait_until_done(1)
		event.fade_out_music(60)
		at = 26
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait.skip_frame_count(4)
		end
		if at <= 2 then
			wait.skip_frame_count(45)
		end
		if at <= 3 then
			swap_party_slots_murdan_spell()
			wait.skip_frame_count(15)
		end
		if at <= 4 then
			message.show_voiced_for_stopping_skipping(2450010, -1)
		end
		if at <= 5 then
			message.show_voiced_for_stopping_skipping(2450015, -1)
		end
		if at <= 6 then
			cutscene.skip_command(2)
		end
		if at <= 7 then
			message.show_voiced_for_stopping_skipping(2450020, -1)
		end
		if at <= 8 then
			message.show_voiced_skipping(2450030)
		end
		if at <= 9 then
			cutscene.skip_command(0)
		end
		if at <= 10 then
			message.show_voiced_for_stopping_skipping(2450040, -1)
		end
		if at <= 11 then
			wait.skip_frame_count(30)
		end
		if at <= 12 then
			wait.skip_frame_count(150)
		end
		if at <= 13 then
			wait.skip_frame_count(40)
		end
		if at <= 14 then
			message.show_voiced_skipping(2450050)
		end
		if at <= 15 then
			cutscene.skip_command(0)
		end
		if at <= 16 then
			cutscene.skip_command(2)
		end
		if at <= 17 then
			message.show_voiced_for_stopping_skipping(2450060, -1)
		end
		if at <= 18 then
			message.show_voiced_for_stopping_skipping(2450070, -1)
		end
		if at <= 19 then
			cutscene.skip_command(2)
		end
		if at <= 20 then
			message.show_voiced_skipping(2450080)
		end
		if at <= 21 then
			cutscene.skip_command(0)
		end
		if at <= 22 then
			message.show_voiced_skipping(2450090)
		end
		if at <= 23 then
			message.show_voiced_skipping(2450100)
		end
		if at <= 24 then
			cutscene.skip_command(1)
		end
		if at <= 25 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	at = 27
	vm.entry(27)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 28
	wait.for_frame_count(35)
	event.stop_music(0)
	event.stop_sound_effect(sound_bank, 4)
	unload_murdan_spell_scene_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Hides the swamp NPC markers, plays the Murdan spell-release scene and advances the swamp progress counter.
local function deliver_priscleen_fish()
	local at: number = 0
	return vm.guard(function()
		at = 1
		vm.entry(1)
		event.fade_out_screen(15)
		at = 2
		wait.for_frame_count(15)
		event.delete_character(14)
		event.set_function_point_enabled("p01_s0501", "invent_2008-0", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa02-0", 0)
		event.attach_object_handle_to_map_part_2(0, "p08_s0501")
		event.set_object_handle_visible(0, 0)
		at = 3
		cutscene_murdan_releases_spell()
		event.set_save_counter(3, 6)
		fish_monster_swamp.update_progress_function_points()
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				wait.skip_frame_count(15)
			end
			if at <= 2 then
				at = 3
				cutscene_murdan_releases_spell()
				return vm.continue_with(function()
					event.set_save_counter(3, 6)
					fish_monster_swamp.update_progress_function_points()
					return
				end)
			end
			fish_monster_swamp.print_progress_debug()
			return 0
		end
		return nil
	end)
end

--- Asks whether to advance to the next floor, walking out through the exit when accepted, and returns whether the player left.
local function ask_to_go_to_next_floor()
	local choice: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local frame_index: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "次のフロアに進みますか？")
		at = 1
		choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
		if choice == 0 then
			event.clear_camera_sequence()
			event.set_camera_sequence_position(-2144.16, 79.66, 654.8)
			event.set_camera_sequence_look_at(-2382.06, 11.3, 623.75)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, -2363.64, 0.4, 625.83)
			event.set_object_sequence_rotation(0, 0.0, -1.52, 0.0)
			event.set_object_sequence_motion(0, "走り", 4)
			event.move_object_sequence(0, -2489.67, 0.4, 624.1, 60)
			event.move_camera_sequence_eased(-2144.16, 79.66, 654.8, -2388.46, 36.03, 632.32, 48, 60, 2.5)
			event.mark_camera_sequence_fade_track()
			event.delay_camera_sequence_fade_track(30)
			event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
			at = 2
			wait.for_frame_count(60)
			return 1
		end
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		character_x = vm.f32(character_x + vm.f32(30.0 * vm.sin(vm.f32(1.59))))
		character_z = vm.f32(character_z + vm.f32(30.0 * vm.cos(vm.f32(1.59))))
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, 1.59, 0.0, 15)
		event.move_object_sequence(0, character_x, character_y, character_z, 45)
		for var4_i = 0, 44 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				character_x = out1 or character_x
				character_y = out2 or character_y
				character_z = out3 or character_z
			end
			event.set_camera_sequence_look_at(character_x, character_y + 30.0, character_z)
			at = 3
			vm.wait(3)
		end
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				choice = received[1] :: number
			end
			if at <= 1 then
				wait.skip_frame_count(60)
			end
			return 1
		end
		if at <= 3 then
			local _ = frame_index < 45
			frame_index = frame_index + 1
			return 0
		end
		return nil
	end)
end

--- Turns the player toward the character in the given slot and waits for the turn to finish.
local function turn_toward_character(target_slot: s32)
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local target_angle: f32 = 0
	local turn_frames: any = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = event.get_character_position(target_slot)
		offset_x = out1 or offset_x
		offset_y = out2 or offset_y
		offset_z = out3 or offset_z
	end
	do
		local out1, out2, out3 = event.subtract_vectors(offset_x, offset_y, offset_z, player_x, player_y, player_z)
		offset_x = out1 or offset_x
		offset_y = out2 or offset_y
		offset_z = out3 or offset_z
	end
	target_angle = event.get_arc_tangent(offset_x, offset_z) or target_angle
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	print("angle=", vm.float(target_angle), "----------\n")
	turn_frames = vm.ftoi(vm.f32(target_angle / vm.f32(0.19634955)))
	turn_frames = fish_monster_swamp.get_absolute_value(turn_frames)
	print("frame=", turn_frames, "-------------\n")
	event.rotate_object_sequence(0, 0.0, target_angle, 0.0, turn_frames)
	wait.for_frame_count(turn_frames)
	event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
end

--- Asks whether to go back to the station, fading out when accepted, and returns whether the player left.
local function ask_to_return_to_station()
	local choice: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち", 4)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "『シャーロット停車場』に戻りますか？")
		at = 1
		choice = message.ask_choice(0, -1, 8, 256, 208, 2, 1)
		if choice == 0 then
			event.fade_out_screen(30)
			at = 2
			wait.for_frame_count(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				choice = received[1] :: number
			end
			if at <= 1 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load.
function script.setup() end

script.fade_in_on_entry = fade_in_on_entry
script[99] = script.fade_in_on_entry

--- Sets up the swamp on entry, restoring the party position after a memory card load or playing the entrance scene.
function script.default_event()
	local visit_count: s32 = 0
	local old_map_no: s32 = 0
	local flag: s32 = 0
	local mc_load: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.stop_music(0)
		event.initialize_event()
		visit_count = event.get_dungeon_floor_info(1, 6, 7) or visit_count
		event.set_dungeon_floor_info(1, 6, 7, vm.i32(visit_count + 1))
		print("s05StartEvent kita------------------------------------------\n")
		fade_in_on_entry()
		load_swamp_characters()
		fish_monster_swamp.update_progress_function_points()
		mc_load = event.take_memory_card_load_state() or mc_load
		if mc_load == 1 then
			event.set_character_position(0, 2808.3, 0.0, 1609.9)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			event.get_map_type(old_map_no)
			flag = event.get_save_flag(215) or flag
			if flag ~= 0 then
				at = 1
				play_swamp_reentry_walk(vm.f32(3205.97), 0.0, vm.f32(1599.83), 0.0)
			end
			event.fade_in_screen(15)
			flag = event.get_save_flag(209) or flag
			if flag == 1 then
				flag = event.get_save_flag(215) or flag
				if flag == 0 then
					at = 2
					play_arrival_scene()
					event.fade_in_screen(15)
				end
			end
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				play_arrival_scene()
				return vm.continue_with(function()
					event.fade_in_screen(15)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Plays the line-snapping scene and then loads the second swamp script.
function script.key_open() end

--- Resets the swamp progress flags and counter and removes the fishing rod.
function script.reset_swamp_progress()
	event.set_save_counter(3, 0)
	event.set_save_flag(215, 0)
	event.set_save_flag(220, 0)
	event.set_save_flag(230, 0)
	event.set_save_flag(235, 0)
	event.remove_item(302, 1)
	fish_monster_swamp.update_progress_function_points()
	vm.wait(1)
	wait.until_button_pressed(32)
end
script[151] = script.reset_swamp_progress

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_type_7

script.play_arrival_scene = play_arrival_scene
script[501] = script.play_arrival_scene

--- Plays the rod trade scene and sets the progress counter from the rod and save flag state.
function script.trade_with_noam()
	local flag: s32 = 0
	local rod_count: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_character_motion(0, "立ち")
		at = 1
		cutscene_noam_rod_trade()
		rod_count = event.get_item_count(302) or rod_count
		flag = event.get_save_flag(230) or flag
		if rod_count ~= 0 and flag == 1 then
			event.set_save_counter(3, 3)
			fish_monster_swamp.update_progress_function_points()
		end
		if rod_count > 0 and flag == 0 then
			event.set_save_counter(3, 2)
			fish_monster_swamp.update_progress_function_points()
		end
		fish_monster_swamp.update_progress_function_points()
		return
	end, function(received: { any })
		if at <= 1 then
			fish_monster_swamp.print_progress_debug()
			fish_monster_swamp.print_progress_debug()
			fish_monster_swamp.print_progress_debug()
			return 0
		end
		return nil
	end)
end
script[502] = script.trade_with_noam

--- Loads the second swamp script's Utan scene.
function script.start_utan_scene()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b.stb", 501)
end
script[503] = script.start_utan_scene

--- Loads the second swamp script's fishing tutorial scene.
function script.start_fishing_tutorial_scene()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b.stb", 502)
end
script[504] = script.start_fishing_tutorial_scene

--- Plays the line-snapping scene, advances the progress counter and reloads the characters for it.
function script.start_murdan_line_scene()
	local at: number = 0
	return vm.guard(function()
		at = 1
		cutscene_murdan_snaps_line()
		event.set_save_counter(3, 5)
		load_swamp_characters()
		fish_monster_swamp.update_progress_function_points()
		return
	end, function(received: { any })
		if at <= 1 then
			fish_monster_swamp.ignore_both_toggles()
			fish_monster_swamp.print_progress_debug()
			return 0
		end
		return nil
	end)
end
script[505] = script.start_murdan_line_scene

script.deliver_priscleen_fish = deliver_priscleen_fish
script[506] = script.deliver_priscleen_fish

--- Loads the second swamp script's villager reunion scene.
function script.start_villagers_scene()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b.stb", 503)
end
script[507] = script.start_villagers_scene

--- Loads the second swamp script's rock-lifting scene.
function script.start_utan_rock_scene()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b.stb", 504)
end
script[508] = script.start_utan_rock_scene

--- Asks the player to give the Priscleen fish and plays the delivery scene if it is used.
function script.use_item_for_holy_one()
	local prompt_stage: s32 = 0
	local confirmed: s32 = 0
	local item: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		print("use item--------------\n")
		prompt_stage = event.get_triggered_event_data_2(6) or prompt_stage
		if prompt_stage == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "ぬしさまにハグハグを渡そう。\n（(#)でメニューを開く）")
			at = 1
			confirmed = message.ask_confirmation(0, -1, 5, 256, 208, confirmed)
			event.set_message_bubble_tail(0, 1)
			if confirmed == 1 then
				prompt_stage = 2
			end
		end
		if prompt_stage == 2 then
			event.open_use_item_menu(310)
			at = 2
			vm.wait(2)
			item = vmhost.used_item() or item
			if item == 310 then
				at = 3
				deliver_priscleen_fish()
			elseif item <= 0 then
			else
				at = 4
				fish_monster_swamp.play_refuse_gesture()
			end
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				confirmed = received[2] :: number
			end
			if at <= 1 then
				local _ = prompt_stage == 1
				prompt_stage = 2
			end
			if at <= 2 then
				at = 3
				deliver_priscleen_fish()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 3 then
				cutscene.do_nothing()
			end
			return 0
		end
		return nil
	end)
end
script[550] = script.use_item_for_holy_one

--- Leaves the swamp for the next dungeon floor after the walk to the exit.
function script.exit_to_dungeon()
	local dungeon_id: s32 = 0
	local swamp_floor: s32 = 0
	local target_floor: s32 = 0
	event.initialize_event()
	if ask_to_go_to_next_floor() == 1 then
		event.set_save_control_bits(16, 0)
		dungeon_id = 1
		target_floor = 4
		swamp_floor = 6
		event.set_dungeon_floor(target_floor)
		event.set_dungeon_floor_info(dungeon_id, swamp_floor, 5, 2)
		event.set_dungeon_floor_info(dungeon_id, target_floor, 5, 1)
		event.set_function_point_enabled("", "next_floor", 0)
		event.go_to_dungeon(1, target_floor, 1000)
		vm.wait(2)
	end
end
script[551] = script.exit_to_dungeon

--- Turns to the NPC who wants a Priscleen fish and plays the delivery scene when the fish is used.
function script.talk_to_priscleen_requester()
	local prompt_stage: s32 = 0
	local player_character: s32 = 0
	local npc_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local npc_x: f32 = 0
	local npc_z: f32 = 0
	local target_angle: f32 = 0
	local item: s32 = 0
	local at: number = 0
	return vm.guard(function()
		print("e552--------------\n")
		prompt_stage = event.get_triggered_event_data_2(6) or prompt_stage
		if prompt_stage == 1 then
			event.set_camera_position(-203.52, 16.84, -181.02)
			event.set_camera_look_at(-184.65, 30.0, -343.81)
			player_character = event.get_player_character_slot() or player_character
			npc_slot = 14
			event.set_message_bubble_tail(0, 1)
			event.apply_message_window_preset(0, 0)
			do
				local out1, _, out3 = event.get_character_position(player_character)
				player_x = out1 or player_x
				player_z = out3 or player_z
			end
			do
				local out1, _, out3 = event.get_character_position(npc_slot)
				npc_x = out1 or npc_x
				npc_z = out3 or npc_z
			end
			target_angle = event.get_look_angle(npc_x - player_x, npc_z - player_z) or target_angle
			at = 1
			character.turn_to_angle(player_character, target_angle)
			event.set_character_rotation(player_character, 0.0, target_angle, 0.0)
			event.set_character_motion(player_character, "立ち")
			event.set_character_motion(14, "会話")
			event.open_message_window_2(
				0,
				"ハグハグちゃんは\nゲットできたのかしら？<page>ワタクシの美貌がそこなわれると\n世界的な損失ざますのよ。<page>心してはりきってちょうだい。\n（(#)でアイテム使用）"
			)
			at = 2
			message.show(0, -1, 3, 170, 208)
			event.set_character_motion(14, "立ち")
		end
		if prompt_stage == 2 then
			event.open_use_item_menu(310)
			at = 3
			vm.wait(3)
			item = vmhost.used_item() or item
			if item == 310 then
				at = 4
				deliver_priscleen_fish()
			elseif 0 < item then
				at = 5
				fish_monster_swamp.play_refuse_gesture()
			end
		end
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				message.show_and_wait_skipping(0, -1, 3, 170, 208)
			end
			if at <= 3 then
				at = 4
				deliver_priscleen_fish()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 4 then
				cutscene.do_nothing()
			end
			return 0
		end
		return nil
	end)
end
script[552] = script.talk_to_priscleen_requester

--- Turns to the villager who talks about the Holy One and speaks a line that depends on swamp progress.
function script.talk_to_holy_one_follower()
	local player_character: s32 = 0
	local npc_slot: s32 = 0
	local player_x: f32 = 0
	local player_z: f32 = 0
	local npc_x: f32 = 0
	local npc_z: f32 = 0
	local target_angle: f32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	player_character = event.get_player_character_slot() or player_character
	npc_slot = 8
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	do
		local out1, _, out3 = event.get_character_position(player_character)
		player_x = out1 or player_x
		player_z = out3 or player_z
	end
	do
		local out1, _, out3 = event.get_character_position(npc_slot)
		npc_x = out1 or npc_x
		npc_z = out3 or npc_z
	end
	target_angle = event.get_look_angle(npc_x - player_x, npc_z - player_z) or target_angle
	character.turn_to_angle(player_character, target_angle)
	event.set_character_rotation(player_character, 0.0, target_angle, 0.0)
	event.set_character_motion(player_character, "立ち")
	flag = event.get_save_flag(240) or flag
	if flag == 0 then
		event.open_message_window_2(0, "沼のぬしさまは\n神聖なるお魚さまで\nあらせられる。")
		message.say_bubble(0, -1, npc_slot, player_character, 0)
		event.open_message_window_2(0, "お目にかかりたいあまり\n釣り上げたりしては\nバチがあたるぞ。")
	else
		flag_2 = event.get_save_flag(253) or flag_2
		if flag_2 == 0 then
			event.open_message_window_2(
				0,
				"なんとまぁ、ぬしさまに\nお目にかかれたとな。<page>ご無礼がなかったじゃろうな。"
			)
		else
			event.open_message_window_2(
				0,
				"こんな岩など、若い頃なら\nはるかかなたに投げ飛ばせたんじゃ。<page>年はとりたくないのう・・・"
			)
		end
	end
	message.say_bubble(0, -1, npc_slot, player_character, 0)
end
script[553] = script.talk_to_holy_one_follower

--- Gives four of item 291 the first time when the player has none.
function script.receive_starter_items()
	local item_count: s32 = 0
	local at: number = 0
	return vm.guard(function()
		item_count = event.get_item_count(291) or item_count
		if item_count <= 0 then
			event.set_character_motion(0, "立ち")
			at = 1
			inventory.announce_received(291, 4)
			event.add_inventory_item(291, 4)
			at = 2
			inventory.resolve_overflow(1)
			event.set_message_window_mode(0, 7)
		end
		fish_monster_swamp.update_progress_function_points()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				wait.skip_ten_frames(1)
			end
			fish_monster_swamp.print_progress_debug()
			return 0
		end
		return nil
	end)
end
script[560] = script.receive_starter_items

--- Gives five bait when the player has none, otherwise comforts the player.
function script.talk_to_bait_fisherman()
	local npc_slot: s32 = 0
	local bait_count: s32 = 0
	local attached_bait: s32 = 0
	local player_character: s32 = 0
	event.set_character_motion(0, "立ち", 4)
	npc_slot = 9
	turn_toward_character(npc_slot)
	event.set_message_window_mode(0, 1)
	bait_count = event.get_item_count(313) or bait_count
	attached_bait = event.get_save_data_value(3, 302) or attached_bait
	if bait_count <= 0 and attached_bait ~= 313 then
		event.open_message_window_2(0, "エサがなくなっちまたのか？\nしょうがねぇな、ほらよ。")
	else
		event.open_message_window_2(0, "釣れる日もありゃダメな日もある。\nエサのことなら心配すんな。")
	end
	player_character = event.get_player_character_slot() or player_character
	message.say_bubble(0, -1, npc_slot, player_character, 0)
	if bait_count <= 0 and attached_bait ~= 313 then
		event.set_message_window_mode(0, 7)
		inventory.announce_received(313, 5)
		event.add_inventory_item(313, 5)
		inventory.resolve_overflow(1)
	end
end
script[561] = script.talk_to_bait_fisherman

--- Confirms leaving and jumps to the town map.
function script.leave_swamp()
	if ask_to_return_to_station() == 1 then
		event.set_dungeon_stage_id(1)
		event.set_dungeon_floor(0)
		event.set_save_control_bits(16, 0)
		event.jump_to_map_2(-1, "s02")
		vm.wait(2)
	end
end
script[600] = script.leave_swamp

--- Speaks a line chosen by which swamp resident was talked to.
function script.talk_to_swamp_resident()
	local window_frame: s32 = 0
	local npc_slot: s32 = 0
	local player_character: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local player_character_2: s32 = 0
	local player_character_3: s32 = 0
	local player_character_4: s32 = 0
	window_frame = event.get_message_window_frame(0) or window_frame
	event.set_message_window_mode(0, 1)
	npc_slot = event.get_triggered_event_data_2(13) or npc_slot
	event.get_triggered_event_data_2(14)
	event.set_character_motion(0, "立ち", 4)
	turn_toward_character(npc_slot)
	if npc_slot == 8 then
		flag = event.get_save_flag(240) or flag
		if flag == 0 then
			event.open_message_window_2(0, "沼のぬしさまは\n神聖なるお魚さまで\nあらせられる。")
			event.open_message_window_2(
				0,
				"お目にかかりたいあまり\n釣り上げたりしては\nバチがあたるぞ。"
			)
		else
			flag_2 = event.get_save_flag(253) or flag_2
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"なんとまぁ、ぬしさまに\nお目にかかれたとな。<page>ご無礼がなかったじゃろうな。"
				)
			else
				event.open_message_window_2(
					0,
					"こんな岩など、若い頃なら\nはるかかなたに投げ飛ばせたんじゃ。<page>年はとりたくないのう・・・"
				)
			end
		end
		player_character = event.get_player_character_slot() or player_character
		message.say_bubble(0, -1, 10, player_character, 0)
	end
	if npc_slot == 10 then
		event.open_message_window_2(0, "ワタシは今幸せなのだ。\nそっと、しておいてくれないか。")
		player_character_2 = event.get_player_character_slot() or player_character_2
		message.say_bubble(0, -1, 10, player_character_2, 0)
	end
	if npc_slot == 11 then
		event.open_message_window_2(
			0,
			"おいらは戻らねぇよ\nここで一生幸せに暮らすことに\n決めたんだもんね。"
		)
		player_character_3 = event.get_player_character_slot() or player_character_3
		message.say_bubble(0, -1, 11, player_character_3, 0)
	end
	if npc_slot == 12 then
		event.open_message_window_2(
			0,
			"ここは最高だよ。\nボーッとしているだけで不思議と\n幸せな気分になってくる。\n連れ戻そうたって無駄だぜ。"
		)
		player_character_4 = event.get_player_character_slot() or player_character_4
		message.say_bubble(0, -1, 12, player_character_4, 0)
	end
	event.set_message_window_mode(0, window_frame)
end
script[1000] = script.talk_to_swamp_resident

--- Resets the arrival state and replays the arrival scene.
function script.debug_play_arrival_scene()
	event.set_save_flag(215, 0)
	event.set_save_counter(3, 0)
	fish_monster_swamp.load_characters_wide_near_fade(1)
	cutscene_arrival_at_swamp()
end
script[12150] = script.debug_play_arrival_scene

--- Resets the trade flags and replays the rod trade scene.
function script.debug_play_noam_trade_scene()
	event.set_save_flag(220, 0)
	event.set_save_flag(28, 0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_character_active(10)
	event.set_character_motion(0, "立ち")
	cutscene_noam_rod_trade()
end
script[12200] = script.debug_play_noam_trade_scene

--- Loads the second swamp script's Utan scene.
function script.debug_start_utan_scene()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b.stb", 501)
end
script[12300] = script.debug_start_utan_scene

--- Loads the second swamp script's fishing tutorial scene.
function script.debug_start_fishing_tutorial_scene()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b.stb", 502)
end
script[12350] = script.debug_start_fishing_tutorial_scene

--- Plays the line-snapping scene and advances the swamp progress counter.
function script.debug_play_murdan_line_scene()
	local at: number = 0
	return vm.guard(function()
		at = 1
		cutscene_murdan_snaps_line()
		event.set_save_counter(3, 5)
		fish_monster_swamp.update_progress_function_points()
		return
	end, function(received: { any })
		if at <= 1 then
			fish_monster_swamp.print_progress_debug()
			return 0
		end
		return nil
	end)
end
script[12400] = script.debug_play_murdan_line_scene

--- Event 12450, which map data, a script or the engine runs by number.
script.cutscene_murdan_releases_spell = cutscene_murdan_releases_spell
script[12450] = script.cutscene_murdan_releases_spell

--- Loads the second swamp script's villager reunion scene.
function script.debug_start_villagers_scene()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b.stb", 503)
end
script[12470] = script.debug_start_villagers_scene

--- Loads the second swamp script's rock-lifting scene.
function script.debug_start_utan_rock_scene()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s05/s05b.stb", 504)
end
script[12530] = script.debug_start_utan_rock_scene

return script
