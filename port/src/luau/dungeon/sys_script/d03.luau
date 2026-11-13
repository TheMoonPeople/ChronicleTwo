--!strict
--- Dungeon system script for the d03 dungeon covering floor loading, gates, treasure boxes, random circles, the geostone and the Sphida golf minigame.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local dungeon_system_scripts = require("@lib/event/dungeon_system_scripts")
local dungeon_system_scripts_camera = require("@lib/event/dungeon_system_scripts_camera")
local dungeon_system_scripts_character = require("@lib/event/dungeon_system_scripts_character")
local dungeon_system_scripts_cutscene = require("@lib/event/dungeon_system_scripts_cutscene")
local dungeon_system_scripts_item = require("@lib/event/dungeon_system_scripts_item")
local dungeon_system_scripts_message = require("@lib/event/dungeon_system_scripts_message")
local dungeon_system_scripts_minigame = require("@lib/event/dungeon_system_scripts_minigame")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Plays the floor introduction cutscene with the dungeon title logo and the player walking in.
local function play_floor_intro_cutscene()
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_rot: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
		event_point_x = out1 or event_point_x
		event_point_y = out2 or event_point_y
		event_point_z = out3 or event_point_z
		event_point_rot = out4 or event_point_rot
	end
	event_point_rot = vm.f32(event_point_rot + vm.f32(1.5707964))
	if event_point_rot > vm.f32(3.1415927) then
		event_point_rot = vm.f32(event_point_rot - vm.f32(6.2831855))
	end
	event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_rot)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -85.0, 0.0, 50.0)
	event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_sequence_motion(0, "歩き")
	event.set_object_handle_footstep_sound(0, 16)
	event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d02.json", 0)
	event.set_event_image_texture(0, "logo_d02")
	event.set_event_image_source_rect(0, 0, 0, 384, 128)
	event.set_event_image_screen_rect(0, -24, 300, 384, 128)
	event.set_event_image_color(0, 128, 128, 128, 0)
	event.set_event_image_visible(1, 0)
	event.fade_event_image(0, 1, 30)
	event.clear_camera_sequence()
	event.set_camera_sequence_look_at(-170.0, 30.0, 50.0)
	event.set_camera_sequence_angle_height_distance(1.57, 5.0, 160.0)
	event.set_object_sequence_motion(0, "歩き")
	event.move_object_sequence(0, -170.0, 0.0, 50.0, 90)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(30)
	wait.for_frame_count(30)
	event.fade_event_image(0, 1, 30)
	wait.for_frame_count(30)
	event.fade_event_image(0, 0, 30)
	camera.wait_until_done()
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "立ち")
	wait.for_frame_count(30)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Loads the dungeon floor selected in the menu, or the boss or town map for special floors, and starts its intro.
local function load_floor()
	local stage_id: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	event.initialize_sphida()
	event.open_dungeon_floor_map(2)
	vm.wait(1)
	event.set_event_projection(524.9)
	do
		local _, out2, out3, _ = event.get_menu_results_4()
		stage_id = out2 or stage_id
		floor = out3 or floor
	end
	stage_id = 2
	event.set_dungeon_stage_id(stage_id)
	event.set_dungeon_floor(floor)
	dungeon.increment_floor_counter(stage_id, floor)
	if floor == 23 then
		event.load_dungeon_map("d03b02")
		event.load_event_script("d03b02/d03b02.stb", 200)
		return
	else
		if floor >= 1 and floor <= 7 then
			event.load_dungeon_map("d03f01", "d03f01", 6)
		end
		if floor >= 9 and floor <= 14 or floor >= 16 and floor <= 17 then
			event.load_dungeon_map("d03f02")
		end
		if floor >= 19 and floor <= 22 then
			event.load_dungeon_map("d03f03")
		end
		if floor == 0 then
			event.load_dungeon_map("d03f01")
		end
		if floor == 8 then
			event.load_dungeon_map("s17")
			event.load_event_script("s17/s17.stb", 200)
			return
		end
		if floor == 15 then
			event.load_dungeon_map("d03f02")
		end
		if floor == 18 then
			event.load_dungeon_map("d03f02")
		end
		event.place_treasure_box_at_event_point(-1)
		event.load_dungeon_monster(0)
		event.place_dungeon_monster(-1)
		play_floor_intro_cutscene()
		event.load_sound_effect_file_3(4, "snd2/event/ev_200_000.sound.json")
	end
end

--- Plays the cutscene where the gate key opens the gate door, then loads the next floor.
local function play_gate_unlock_cutscene()
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_rot: f32 = 0
	local rot_x: f32 = 0
	local rotation_speed: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point()
		event_point_x = out1 or event_point_x
		event_point_y = out2 or event_point_y
		event_point_z = out3 or event_point_z
		event_point_rot = out4 or event_point_rot
	end
	event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_rot)
	event.attach_object_handle_to_map_part_3(0, "way38", "d02w10_4-m0")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(1, "way38", "d02w10_3-m0")
	event.set_object_handle_visible(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.load_character(5, "effect/g01_gkey.chr", "info", 8)
	event.set_character_active(8)
	event.attach_object_handle_to_character(2, 8)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_position(2, -160.0, 0.0, 15.0)
	event.set_object_sequence_motion(2, "発動", 5)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-96.26, 47.33, -135.06)
	event.set_camera_sequence_look_at(-157.89, 18.41, 5.19)
	wait.for_frame_count(30)
	event.set_object_handle_visible(2, 1)
	event.set_object_sequence_motion(2, "発動", 6)
	event.wait_object_sequence_motion_end(2)
	wait.for_frame_count(40)
	event.set_object_handle_visible(0, 0)
	object.wait_until_done(2)
	rotation_speed = vm.f32(0.001)
	rot_x = 0.0
	while rot_x < vm.f32(1.57) do
		event.set_object_sequence_rotation(1, rot_x, 0.0, 0.0)
		rotation_speed = vm.f32(rotation_speed * vm.f32(1.06))
		rot_x = vm.f32(rot_x + rotation_speed)
		vm.wait(4)
	end
	for i = 0, 2 do
		while true do
			rotation_speed = vm.f32(rotation_speed * vm.f32(0.6))
			rot_x = vm.f32(rot_x - rotation_speed)
			event.set_object_sequence_rotation(1, rot_x, 0.0, 0.0)
			if rotation_speed < vm.f32(0.001) then
				break
			else
				vm.wait(5)
			end
		end
		rotation_speed = vm.f32(rotation_speed + vm.f32(0.001))
		while true do
			rotation_speed = vm.f32(rotation_speed * vm.f32(1.2))
			rot_x = vm.f32(rot_x + rotation_speed)
			event.set_object_sequence_rotation(1, rot_x, 0.0, 0.0)
			if rot_x > vm.f32(1.57) then
				break
			else
				vm.wait(6)
			end
		end
	end
	wait.for_frame_count(30)
	event.delete_character(8)
	event.finish_event()
	load_floor()
end

--- Plays the cutscene of the player jumping through the opened gate and walking away as the screen fades out.
local function play_enter_gate_cutscene()
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_rot: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point()
		event_point_x = out1 or event_point_x
		event_point_y = out2 or event_point_y
		event_point_z = out3 or event_point_z
		event_point_rot = out4 or event_point_rot
	end
	event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_rot)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -158.37, 0.0, -21.16)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "立ち")
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-96.26, 47.33, -135.06)
	event.set_camera_sequence_look_at(-157.89, 18.41, 5.19)
	event.move_camera_sequence(-111.68, 45.66, -74.92, -167.33, 37.66, 86.08, 155)
	wait.for_frame_count(10)
	event.jump_object_sequence(0, -159.92, 29.88, 36.38, -0.2, 25)
	object.wait_until_done(0)
	wait.for_frame_count(10)
	event.move_object_sequence(0, -159.92, 27.83, 183.87, 120)
	event.set_object_sequence_motion(0, "歩き")
	wait.for_frame_count(60)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(60)
	camera.wait_until_done()
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(1)
	camera.wait_until_done()
	event.finish_event()
end

--- Waits for the player to advance or answer the open message while animating the speaker mouth to the voice stream.
local function wait_for_message_input(window: any, allow_cancel: s32, was_cancelled: s32)
	local stream_playing: s32 = 0
	local voice_state: s32 = 0
	local previous_voice_state: s32 = 0
	local input_result: s32 = 0
	local frame_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		stream_playing = event.is_voice_stream_playing() or stream_playing
		event.trigger_mouth_texture_animation(1)
		event.trigger_mouth_motion(0)
		frame_count = 0
		previous_voice_state = event.get_voice_stream_state(1) or previous_voice_state
		while true do
			if stream_playing ~= 0 then
				voice_state = event.get_voice_stream_state(1) or voice_state
				if previous_voice_state ~= 0 and voice_state == 0 then
					event.trigger_mouth_texture_animation(0)
					event.trigger_mouth_motion(2)
				end
				previous_voice_state = voice_state
			end
			input_result = dungeon_system_scripts.poll_message_input(window, allow_cancel)
			if input_result ~= 0 then
				if input_result == 2 then
					was_cancelled = 1
				else
					was_cancelled = 0
				end
				frame_count = vm.i32(frame_count + 1)
				break
			else
				resume_step = 1
				vm.wait(1)
				frame_count = vm.i32(frame_count + 1)
			end
		end
		event.reset_mouth_motions()
		event.trigger_mouth_texture_animation(0)
		event.reset_mouth_texture_animations()
		stream_playing = event.is_voice_stream_playing() or stream_playing
		if stream_playing ~= 0 then
			event.stop_voice_stream(1)
		end
		return frame_count, was_cancelled
	end, function(received: { any })
		if resume_step <= 1 then
			frame_count = frame_count + 1
			return frame_count, was_cancelled
		end
		return nil, was_cancelled
	end)
end

--- Opens a message window and waits until the player dismisses it.
local function show_message_and_wait(window: s32, message_id: s32, style: s32, x: s32, y: s32)
	local was_cancelled: s32 = 0
	local _ = message.open(window, message_id, style, x, y)
	do
		local _: any
		_, was_cancelled = wait_for_message_input(window, 0, was_cancelled)
	end
	message.close(window)
end

--- Shows the item obtained message for the given item and quantity with the pickup sound.
local function show_item_obtained(item: any, count: s32)
	local message_id: s32 = 0
	local system_sound_bank: s32 = 0
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	if count <= 0 then
		return
	end
	if count == 1 then
		message_id = 10
		event.set_message_item_name(1, 1, item)
	end
	if 1 < count then
		message_id = 11
		event.set_message_item_name(1, 1, item)
		event.set_message_number(1, 2, count)
	end
	system_sound_bank = event.get_system_sound_id() or system_sound_bank
	event.play_sound_effect(system_sound_bank, 18)
	show_message_and_wait(1, message_id, 8, 0, 0)
end

--- Plays the treasure box opening scene that reveals and awards a single item.
local function play_treasure_box_item_event(item_no: s32)
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_rot: f32 = 0
	local lid_progress: f32 = 0
	local item_scale: f32 = 0
	event.set_dungeon_pause_flags(23, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		event_point_x = out1 or event_point_x
		event_point_y = out2 or event_point_y
		event_point_z = out3 or event_point_z
		event_point_rot = out4 or event_point_rot
	end
	event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_rot)
	vm.wait(1)
	event.add_inventory_item(item_no, 1)
	event.start_background_file_loads_3(item_no, 1, "effect/itemget.gltf")
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.for_frame_count(15)
	dungeon_system_scripts_item.open_treasure_lid(0)
	wait.for_frame_count(5)
	wait.background_load()
	event.load_character(5, "effect/itemget.gltf", "info", 12)
	event.set_character_active(12)
	event.attach_object_handle_to_character(1, 12)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "ゲット", 5)
	event.set_object_sequence_motion(1, "ゲット", 2)
	wait.for_frame_count(5)
	lid_progress = dungeon_system_scripts_item.open_treasure_lid_fast(lid_progress)
	event.load_item_model(5, item_no, "info", 13, 1)
	event.set_character_active(1, 13)
	event.attach_object_handle_to_character(0, 13)
	item_scale = inventory.get_weapon_display_scale(13, item_no, item_scale)
	event.set_object_handle_scale(0, item_scale, item_scale, item_scale)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, -5.0, 0.0)
	event.delay_object_sequence_position_track(0, 4)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.3, 20)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.4, 8)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.2, 5)
	lid_progress = inventory.open_treasure_box_lid(lid_progress)
	camera.wait_until_done()
	show_item_obtained(item_no, 1)
	event.start_crossfade(10)
	event.set_dungeon_pause_flags(23, 0)
	event.set_character_active(1, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

--- Plays the happy clown chest scene where the player picks one of two boxes to receive its item.
local function play_clown_chest_event(first_item: any, second_item: s32)
	local event_point_x: f32 = 0
	local event_point_y: f32 = 0
	local event_point_z: f32 = 0
	local event_point_rot: f32 = 0
	local lid_progress: f32 = 0
	local language_code: s32 = 0
	local chosen_box: any = 0
	local random_value: s32 = 0
	local swap_item: any = 0
	local item_scale: f32 = 0
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_10(
		first_item,
		1,
		second_item,
		1,
		"event/tbox/p00_27a_ex.gltf",
		"event/tbox/l_box.gltf",
		"event/tbox/r_box.gltf",
		"event/tbox/p00_27a.gltf",
		"event/tbox/p00_27a_ex_l.gltf",
		"event/tbox/p00_27a_ex_r.gltf"
	)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		event_point_x = out1 or event_point_x
		event_point_y = out2 or event_point_y
		event_point_z = out3 or event_point_z
		event_point_rot = out4 or event_point_rot
	end
	event.set_event_world_coordinate(event_point_x, event_point_y, event_point_z, event_point_rot)
	vm.wait(1)
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.for_frame_count(15)
	dungeon_system_scripts_item.open_treasure_lid(0)
	wait.for_frame_count(5)
	wait.background_load()
	event.load_character(5, "event/tbox/p00_27a_ex.gltf", "info", 12)
	event.set_character_active(0, 12)
	event.attach_object_handle_to_character(0, 12)
	event.set_object_handle_position(0, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 5)
	event.load_character(5, "event/tbox/p00_27a.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.attach_object_handle_to_character(1, 13)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "出現", 5)
	lid_progress = dungeon_system_scripts_item.open_treasure_lid_fast(lid_progress)
	event.set_character_active(12)
	event.set_object_handle_motion(0, "宝箱ピエロ出現", 6)
	event.set_character_active(13)
	event.set_object_sequence_motion(1, "出現", 6)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.clear_camera_sequence()
	event.delay_camera_sequence_position_track(4)
	event.move_camera_sequence_eased(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.move_camera_sequence_eased(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	lid_progress = inventory.open_treasure_box_lid(lid_progress)
	wait.for_frame_count(10)
	event.set_character_active(0, 12)
	event.load_character(5, "event/tbox/p00_27a_ex_r.gltf", "info", 14)
	event.set_character_active(14)
	event.set_character_position(14, 0.0, 0.0, 0.0)
	event.set_character_rotation(14, 0.0, 0.0, 0.0)
	event.set_character_motion(14, "宝箱発生（右手）", 6)
	event.attach_character_to_frame(13, "s_pre", 14)
	event.load_character(5, "event/tbox/p00_27a_ex_l.gltf", "info", 15)
	event.set_character_active(15)
	event.set_character_position(15, 0.0, 0.0, 0.0)
	event.set_character_rotation(15, 0.0, 0.0, 0.0)
	event.set_character_motion(15, "宝箱出現（左手）", 6)
	event.attach_character_to_frame(13, "b_pre", 15)
	event.load_character(5, "event/tbox/r_box.gltf", "info", 18)
	event.set_character_active(18)
	event.set_character_position(18, 0.0, 0.0, 0.0)
	event.set_character_rotation(18, 0.0, 0.0, 0.0)
	event.attach_character_to_frame(13, "s_pre", 18)
	event.set_scene_character_type(18, 4)
	event.load_character(5, "event/tbox/l_box.gltf", "info", 19)
	event.set_character_active(19)
	event.set_character_position(19, 0.0, 0.0, 0.0)
	event.set_character_rotation(19, 0.0, 0.0, 0.0)
	event.attach_character_to_frame(13, "b_pre", 19)
	event.set_scene_character_type(19, 4)
	event.set_character_visible(18, 0)
	event.set_character_visible(19, 0)
	wait.for_frame_count(8)
	event.set_character_visible(18, 1, 1, 0.08)
	event.set_character_visible(19, 1, 1, 0.08)
	wait.for_frame_count(10)
	event.set_character_active(0, 14)
	event.set_character_active(0, 15)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	language_code = event.get_language() or language_code
	if language_code == 0 then
		event.open_message_window_2(
			0,
			"はぁーい！やってるかーい。\nハッピーピエロのプレゼントコーナー！\nさあ、好きな方どっちか選んで！"
		)
	else
		event.open_message_window_2(0, "Howdy!\nHow's it going?<page>Happy Clown's gonna give you a gift!\nHere, make your choice.")
	end
	show_message_and_wait(0, -1, 8, 256, 208)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	if language_code == 0 then
		event.open_message_window_2(0, "赤い箱を選ぶ\n黄色い箱を選ぶ")
	else
		event.open_message_window_2(0, "Pick the red box.\nPick the yellow box.")
	end
	local _ = message.open(0, -1, 8, 0, 0)
	chosen_box = dungeon_system_scripts_message.select_option(0, 2, 0, 1)
	event.set_message_bubble_screen_slot(0, 0)
	random_value = event.get_random_number_int(100) or random_value
	if vm.imod(random_value, 2) == 0 then
		swap_item = first_item
		first_item = second_item
		second_item = swap_item
	end
	event.load_item_model(5, first_item, "info", 16, 1)
	event.set_character_active(0, 16)
	event.set_character_position(16, 0.0, 0.0, 0.0)
	event.set_character_rotation(16, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 16)
	item_scale = dungeon_system_scripts_item.get_item_display_scale(16, first_item, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.load_item_model(5, second_item, "info", 17, 1)
	event.set_character_active(0, 17)
	event.set_character_position(17, 0.0, 0.0, 0.0)
	event.set_character_rotation(17, 0.0, 0.0, 0.0)
	event.attach_object_handle_to_character(6, 17)
	item_scale = dungeon_system_scripts_item.get_item_display_scale(17, second_item, item_scale)
	event.set_object_handle_scale(6, item_scale, item_scale, item_scale)
	event.set_character_active(1, 16)
	event.attach_character_to_frame(13, "s_pre", 16)
	event.set_character_active(1, 17)
	event.attach_character_to_frame(13, "b_pre", 17)
	event.set_object_sequence_motion(1, "中身公開", 2)
	if chosen_box == 0 then
		event.queue_object_sequence_next_motion(1, "大きい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "大きい宝箱L", 4)
	else
		event.queue_object_sequence_next_motion(1, "小さい宝箱", 2)
		event.queue_object_sequence_next_motion(1, "小さい宝箱L", 4)
	end
	wait.for_frame_count(10)
	event.set_character_visible(18, 0, 1, 0.04)
	event.set_character_visible(19, 0, 1, 0.04)
	object.wait_until_done(1)
	if chosen_box == 0 then
		show_item_obtained(second_item, 1)
		event.add_inventory_item(second_item, 1)
	else
		show_item_obtained(first_item, 1)
		event.add_inventory_item(first_item, 1)
	end
	event.set_character_active(0)
	event.set_dungeon_pause_flags(17, 0)
	for i = 0, 7 do
		event.delete_character(12 + i)
	end
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

--- Opens a message window as a speech bubble above a character and waits until the player dismisses it.
local function show_bubble_message(window: s32, message_text: any, speaker: any, listener: s32, unused_argument: any)
	local selection_flag: s32 = 0
	vm.wait(1)
	vm.wait(2)
	event.set_message_bubble_screen_slot(window, 0)
	event.open_message_window_2(window, message_text)
	event.place_message_bubble(window, speaker, listener)
	do
		local _: any
		_, selection_flag = wait_for_message_input(window, 0, selection_flag)
	end
	message.close(window)
end

--- Turns the player and a character toward each other, shows the character talk bubble, and restores the character afterwards.
local function show_talk_bubble(speaker: s32, message_text: s32, use_talk_camera: s32, restore_rotation: s32)
	local rot_y: f32 = 0
	local player_slot: s32 = 0
	if restore_rotation ~= 0 then
		event.attach_object_handle_to_character(0, speaker)
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			rot_y = out2 or rot_y
		end
	end
	player_slot = event.get_player_character_slot() or player_slot
	dungeon_system_scripts_character.face_each_other(player_slot, speaker, message_text, use_talk_camera)
	show_bubble_message(0, message_text, speaker, player_slot, 0)
	if restore_rotation ~= 0 then
		dungeon_system_scripts_character.turn_character_to_rotation(speaker, rot_y)
	end
	event.set_character_motion(speaker, "立ち")
	event.finish_event()
	if use_talk_camera ~= 0 then
		event.start_crossfade(10)
	end
end

--- Shows the robot breakdown message for the given playable character.
local function show_robot_breakdown_message(character_index: s32)
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	show_message_and_wait(1, vm.i32(60 + character_index), 8, 0, 0)
end

--- Plays the robot breakdown scene with breakdown music and opens the character change menu.
local function play_robot_breakdown_event()
	local playable_character: s32 = 0
	local event_sound_bank: s32 = 0
	local music_number: s32 = 0
	local music_volume: f32 = 0
	local breakdown_character: s32 = 0
	local is_e3: s32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 then
		event.set_character_motion(0, "故障", 6)
		event.initialize_effect_manager(5)
		event.load_effect_base("ロボ故障")
		event.create_effect_work_buffer(5)
	end
	event_sound_bank = event.get_event_sound_bank(4) or event_sound_bank
	event.stop_sound_effect(event_sound_bank, 0)
	event.set_dungeon_pause_flags(17, 1)
	event.create_effect("ロボ故障")
	music_number = event.get_active_music_number() or music_number
	music_volume = vm.bits_float(event.get_music_master_volume()) or music_volume
	event.stop_music(0)
	event.start_background_file_loads_1("snd2/bgm/bg_060.sound.json")
	wait.for_frame_count(4)
	wait.background_load()
	event.load_music_pack(60)
	event.play_music(0)
	breakdown_character = event.get_playable_character() or breakdown_character
	show_robot_breakdown_message(breakdown_character)
	if playable_character == 2 or playable_character == 3 then
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.clear_effect_manager()
		event.open_dungeon_character_change_menu(-1)
		vm.wait(5)
	else
		is_e3 = event.is_e3_version() or is_e3
		if is_e3 == 1 then
			event.fade_out_screen(30)
			wait.for_frame_count(30)
			event.set_scene_exit_flag(1)
			return
		else
			event.run_dungeon_debug_command(0)
		end
	end
	event.stop_music(0)
	event.clear_effect_manager()
	event.set_dungeon_pause_flags(17, 1)
	wait.for_frame_count(4)
	event.load_music(music_number)
	event.play_music(0)
	event.set_music_master_volume(music_volume)
	event.play_sound_effect(event_sound_bank, 0)
	event.set_dungeon_pause_flags(17, 0)
	event.finish_event()
end

--- Plays the victory scene for the player character after all monsters are defeated, then shows the Sphida hint and the gate hint.
local function play_extermination_clear_event()
	local playable_character: s32 = 0
	local is_e3: s32 = 0
	local stage_id: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local language_code: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		character.set_idle_motion()
		if playable_character == 0 then
			resume_step = 1
			dungeon_system_scripts_cutscene.play_max_victory()
		end
		if playable_character == 1 then
			resume_step = 2
			dungeon_system_scripts_cutscene.play_monica_victory()
		end
		if playable_character == 2 or playable_character == 3 then
			resume_step = 3
			dungeon_system_scripts_cutscene.play_follow_camera_victory(playable_character)
		end
		is_e3 = event.is_e3_version() or is_e3
		if is_e3 ~= 1 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			event.get_dungeon_floor()
			if stage_id ~= 3 then
				minigame.set_up_sphida_course(0)
				do
					local out1, out2, out3 = event.get_previous_camera_next_position()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.set_camera_position(position_x, position_y, position_z)
				do
					local out1, out2, out3 = event.get_previous_camera_next_look_at()
					position_x = out1 or position_x
					position_y = out2 or position_y
					position_z = out3 or position_z
				end
				event.set_camera_look_at(position_x, position_y, position_z)
				event.set_message_window_mode(0, 4)
				event.set_message_draw_speed(0, 1)
				resume_step = 4
				show_message_and_wait(0, 2100, 8, 0, 0)
				event.set_message_window_mode(0, 1)
				event.set_message_draw_speed(0, 0)
			end
		end
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_position(camera_x, camera_y, camera_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
		end
		event.set_camera_look_at(camera_x, camera_y, camera_z)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		language_code = event.get_language() or language_code
		if language_code == 0 then
			event.open_message_window_2(
				0,
				"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
			)
			resume_step = 5
			show_message_and_wait(0, -1, 8, 0, 0)
		else
			event.open_message_window_2(
				0,
				" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
			)
			resume_step = 6
			show_message_and_wait(0, -1, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_step <= 6 then
			if resume_step <= 1 then
				resume_step = 2
				dungeon_system_scripts_cutscene.play_monica_victory()
				return vm.continue_with(function()
					if playable_character == 2 or playable_character == 3 then
						resume_step = 3
						dungeon_system_scripts_cutscene.play_follow_camera_victory(playable_character)
					end
					is_e3 = event.is_e3_version() or is_e3
					if is_e3 ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							minigame.set_up_sphida_course(0)
							do
								local out1, out2, out3 = event.get_previous_camera_next_position()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_position(position_x, position_y, position_z)
							do
								local out1, out2, out3 = event.get_previous_camera_next_look_at()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_look_at(position_x, position_y, position_z)
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							resume_step = 4
							show_message_and_wait(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_position(camera_x, camera_y, camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_look_at(camera_x, camera_y, camera_z)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					language_code = event.get_language() or language_code
					if language_code == 0 then
						event.open_message_window_2(
							0,
							"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
						)
						resume_step = 5
						show_message_and_wait(0, -1, 8, 0, 0)
					else
						event.open_message_window_2(
							0,
							" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
						)
						resume_step = 6
						show_message_and_wait(0, -1, 8, 0, 0)
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				dungeon_system_scripts_cutscene.play_follow_camera_victory(playable_character)
				return vm.continue_with(function()
					is_e3 = event.is_e3_version() or is_e3
					if is_e3 ~= 1 then
						stage_id = event.get_dungeon_stage_id() or stage_id
						event.get_dungeon_floor()
						if stage_id ~= 3 then
							minigame.set_up_sphida_course(0)
							do
								local out1, out2, out3 = event.get_previous_camera_next_position()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_position(position_x, position_y, position_z)
							do
								local out1, out2, out3 = event.get_previous_camera_next_look_at()
								position_x = out1 or position_x
								position_y = out2 or position_y
								position_z = out3 or position_z
							end
							event.set_camera_look_at(position_x, position_y, position_z)
							event.set_message_window_mode(0, 4)
							event.set_message_draw_speed(0, 1)
							resume_step = 4
							show_message_and_wait(0, 2100, 8, 0, 0)
							event.set_message_window_mode(0, 1)
							event.set_message_draw_speed(0, 0)
						end
					end
					do
						local out1, out2, out3 = event.get_previous_camera_next_position()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_position(camera_x, camera_y, camera_z)
					do
						local out1, out2, out3 = event.get_previous_camera_next_look_at()
						camera_x = out1 or camera_x
						camera_y = out2 or camera_y
						camera_z = out3 or camera_z
					end
					event.set_camera_look_at(camera_x, camera_y, camera_z)
					event.set_message_window_mode(0, 4)
					event.set_message_draw_speed(0, 1)
					language_code = event.get_language() or language_code
					if language_code == 0 then
						event.open_message_window_2(
							0,
							"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
						)
						resume_step = 5
						show_message_and_wait(0, -1, 8, 0, 0)
					else
						event.open_message_window_2(
							0,
							" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
						)
						resume_step = 6
						show_message_and_wait(0, -1, 8, 0, 0)
					end
					event.set_message_window_mode(0, 1)
					event.set_message_draw_speed(0, 0)
					event.finish_event()
					return
				end)
			end
			if resume_step <= 3 then
				dungeon_system_scripts_cutscene.noop(0)
				dungeon_system_scripts_message.finish_on_skip(0, 2100, 8, 0, 0)
			end
			if resume_step <= 4 then
				dungeon_system_scripts_message.finish_on_skip(0, -1, 8, 0, 0)
			end
			if resume_step <= 5 then
				dungeon_system_scripts_message.finish_on_skip(0, -1, 8, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Checks the player can play Sphida with an equipped club, returning nonzero with a message when not.
local function prepare_sphida_club()
	local playable_character: s32 = 0
	local equipped_item: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 then
			event.set_message_window_mode(0, 4)
			resume_step = 1
			show_message_and_wait(0, 2000, 8, 0, 0)
			return 1
		end
		equipped_item = event.get_equipped_item(0, 0) or equipped_item
		if equipped_item ~= 10 and equipped_item ~= 11 and equipped_item ~= 12 and equipped_item ~= 13 and equipped_item ~= 14 then
			event.set_message_window_mode(0, 4)
			resume_step = 2
			show_message_and_wait(0, 2001, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(equipped_item)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if resume_step <= 1 then
			return 1
		end
		if resume_step <= 2 then
			return 1
		end
		return nil
	end)
end

--- Restores the character and camera after a Sphida shot and shows the out of strokes message when the round is over.
local function end_sphida_round(pin_hit: s32)
	local remaining_par: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	event.show_dungeon_status_bar(1.0)
	event.start_crossfade(15)
	remaining_par = event.get_sphida_par() or remaining_par
	if pin_hit == 0 and remaining_par <= 0 then
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_position(position_x, position_y, position_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.set_camera_look_at(position_x, position_y, position_z)
		event.set_message_window_mode(0, 4)
		show_message_and_wait(0, 2003, 8, 0, 0)
		event.reset_follow_camera(1)
	end
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Handles using the gate key item to unlock the gate, or enters the opened gate.
function script.use_gate()
	local is_gate_unlocked: s32 = 0
	local item: s32 = 0
	is_gate_unlocked = event.get_local_event_flag(0) or is_gate_unlocked
	if is_gate_unlocked == 0 then
		event.open_use_item_menu(341)
		vm.wait(1)
		item = vmhost.used_item() or item
		if item == 341 then
			event.set_local_event_flag(0, 1)
			play_gate_unlock_cutscene()
		end
		if item <= 0 then
			return
		end
		if item ~= 341 then
			dungeon_system_scripts_cutscene.play_miss_gesture_short_wait()
			return
		end
	else
		play_enter_gate_cutscene()
	end
end
script[10] = script.use_gate

--- Runs the default event, which only yields one frame and finishes.
function script.default_event()
	event.initialize_event()
	vm.wait(1)
	event.finish_event()
end

--- Opens the item menu and prints whether the chosen item was cancelled, wrong or correct.
function script.check_item_menu()
	local item: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.open_use_item_menu(278)
		resume_step = 1
		vm.wait(1)
		item = vmhost.used_item() or item
		if item <= 0 then
			print("----cancel----\n")
			return
		end
		if item ~= 278 then
			print("----CHIGAU=", item, "----\n")
			return
		end
		print("----OK----\n")
		return
	end, function(received: { any })
		if resume_step <= 1 then
			print("----cancel----\n")
			return 0
		end
		return nil
	end)
end
script[102] = script.check_item_menu

script.load_floor = load_floor
script[1000] = script.load_floor

--- Starts the treasure box opening scene for the item the box holds.
function script.treasure_box()
	local playable_character: s32 = 0
	local move_type: s32 = 0
	local item: s32 = 0
	local second_item: s32 = 0
	event.initialize_event()
	event.start_crossfade(30)
	event.set_character_active(0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 then
		move_type = event.get_player_move_type() or move_type
		if move_type == 1 then
			event.set_character_motion(0, "立ち-足")
		end
		if move_type == 2 then
			event.set_character_motion(0, "立ち-キャタピラ")
		end
	end
	do
		local out1, out2 = event.get_treasure_box_item()
		item = out1 or item
		second_item = out2 or second_item
	end
	if second_item <= -1 then
		play_treasure_box_item_event(item)
	else
		play_clown_chest_event(item, second_item)
	end
end

--- Spins the random circle coin and applies the good or bad effect it lands on.
function script.random_circle()
	local language_code: s32 = 0
	local playable_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local blocking_circle_x: f32 = 0
	local blocking_circle_y: f32 = 0
	local blocking_circle_z: f32 = 0
	local yaw: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local sound_bank: s32 = 0
	local motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local circle_id: s32 = 0
	local frame_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local camera_angle: f32 = 0
	local min_spin_frames: s32 = 0
	local angle: f32 = 0
	local roll: s32 = 0
	local threshold: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_value: f32 = 0
	event.initialize_event()
	language_code = event.get_language() or language_code
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 or playable_character == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.set_idle_motion()
		if language_code == 0 then
			if playable_character == 2 then
				event.open_message_window_2(0, "ライドポッドから降りないとダメなようだ。")
			else
				event.open_message_window_2(0, "モンスターに変化した状態だとダメなようだ")
			end
		elseif playable_character == 2 then
			event.open_message_window_2(0, "Must get off the Ridepod.")
		else
			event.open_message_window_2(0, "Looks like you can't do it\nas a monster.")
		end
		show_message_and_wait(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			blocking_circle_x = out1 or blocking_circle_x
			blocking_circle_y = out2 or blocking_circle_y
			blocking_circle_z = out3 or blocking_circle_z
		end
		yaw = event.get_direction_angle(blocking_circle_x, blocking_circle_y, blocking_circle_z, player_x, player_y, player_z) or yaw
		player_x = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + blocking_circle_x)
		player_y = blocking_circle_y
		player_z = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + blocking_circle_z)
		event.set_character_position(0, player_x, player_y, player_z)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		circle_x = out1 or circle_x
		circle_y = out2 or circle_y
		circle_z = out3 or circle_z
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(circle_x, circle_y + 30.0, circle_z)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	character.set_idle_motion()
	event.set_dungeon_pause_flags(17, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(2)
	wait.background_load()
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_bank
	event.start_background_file_loads_2("event/dng/ring.gltf", "event/dng/randomcoin.gltf")
	vm.wait(4)
	wait.background_load()
	motion_frame = event.get_random_circle_motion_frame() or motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "event/dng/ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, circle_x, circle_y, circle_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "event/dng/randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, circle_x, circle_y - 30.0, circle_z)
	coin_angle = event.get_random_number(6.2831855) or coin_angle
	coin_angle = vm.f32(coin_angle - vm.f32(3.1415927))
	coin_angle = event.wrap_angle(coin_angle) or coin_angle
	event.set_character_rotation(13, 0.0, coin_angle, 0.0)
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, circle_x, circle_y + 40.0, circle_z, 30, 2, 0.5)
	frame_count = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		if frame_count == 10 then
			event.play_sound_effect(sound_bank, 0)
		end
		if frame_count == 30 then
			if language_code == 0 then
				dungeon_system_scripts_message.open_stop_hint_japanese()
			else
				event.set_message_window_mode(1, 7)
				event.apply_message_window_preset(1, 2)
				event.open_message_window_2(1, "It stops with (O) button.")
				message.open(1, -1, 15, 0, 0)
			end
		end
		if (if frame_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_count > 300 then
			event.stop_sound_effect(sound_bank, 0)
			event.play_sound_effect(sound_bank, 3)
			vm.wait(6)
			break
		else
			frame_count = frame_count + 1
			vm.wait(7)
		end
	end
	message.close_second_window()
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	camera_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_angle
	min_spin_frames = 0
	min_spin_frames = event.get_random_number_int(10) or min_spin_frames
	min_spin_frames = vm.i32(min_spin_frames + 4)
	frame_count = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		vm.wait(8)
		if frame_count >= min_spin_frames then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			angle = camera_angle
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 0
				break
			end
			angle = vm.f32(camera_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 1
				break
			end
		end
		frame_count = vm.i32(frame_count + 1)
	end
	wait.for_frame_count(20)
	roll = event.get_random_number_int(10) or roll
	if roll < 6 then
		roll = event.get_random_number_int(10) or roll
		if circle_id == 0 then
			threshold = 2
		else
			threshold = 4
		end
		if roll < threshold then
			camera_angle = vm.f32(camera_angle + vm.f32(3.14))
			camera_angle = event.wrap_angle(camera_angle) or camera_angle
			event.rotate_object_sequence(5, 0.0, camera_angle, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			wait.for_frame_count(10)
		else
			roll = event.get_random_number_int(10) or roll
			if roll < 1 then
				camera_angle = vm.f32(camera_angle + vm.f32(3.14))
				camera_angle = event.wrap_angle(camera_angle) or camera_angle
				event.rotate_object_sequence(5, 0.0, camera_angle, 0.0, 6)
				camera_angle = vm.f32(camera_angle + vm.f32(1.57))
				camera_angle = event.wrap_angle(camera_angle) or camera_angle
				event.rotate_object_sequence(5, 0.0, camera_angle, 0.0, 3)
				camera_angle = vm.f32(camera_angle + vm.f32(1.57))
				camera_angle = event.wrap_angle(camera_angle) or camera_angle
				event.rotate_object_sequence(5, 0.0, camera_angle, 0.0, 3)
				wait.for_frame_count(20)
			end
		end
	end
	camera_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, camera_angle, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	frame_count = 0
	effect_id = event.get_random_circle_effect(circle_id) or effect_id
	if circle_id == 0 then
		event.play_sound_effect(sound_bank, 1)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(12)
		end
		if language_code == 0 then
			event.open_message_window_2(0, "コインは天使の面をこちらに向けた。")
			show_message_and_wait(0, -1, 8, 0, 0)
			if effect_id == 1 then
				event.open_message_window_2(0, "ＡＢＳボーナス")
			end
			if effect_id == 2 then
				event.open_message_window_2(
					0,
					"天使は「体力」と「ステータス異常」を\n全回復してくれた。"
				)
			end
			if effect_id == 3 then
				event.open_message_window_2(0, "天使は「ＷＨＰ」を全回復してくれた。")
			end
			if effect_id == 4 then
				event.open_message_window_2(0, "天使は「宝箱」を置いていった。")
				event.place_treasure_box(circle_x, circle_y, circle_z, camera_angle, 294)
			end
		else
			event.open_message_window_2(0, "The coin flipped to the 'Angel'.")
			show_message_and_wait(0, -1, 8, 0, 0)
			if effect_id == 1 then
				event.open_message_window_2(0, "ABS bonus!")
			end
			if effect_id == 2 then
				event.open_message_window_2(0, "Strength & status fully\nrecovered by the Angel.")
			end
			if effect_id == 3 then
				event.open_message_window_2(0, "WHP fully recovered by the Angel.")
			end
			if effect_id == 4 then
				event.open_message_window_2(0, "Angel left a treasure box.")
				event.place_treasure_box(circle_x, circle_y, circle_z, camera_angle, 294)
			end
		end
	else
		event.play_sound_effect(sound_bank, 2)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(15)
		end
		if language_code == 0 then
			event.open_message_window_2(0, "コインは悪魔の面をこちらに向けた。")
			show_message_and_wait(0, -1, 8, 0, 0)
			if effect_id == 5 then
				if playable_character == 0 or playable_character == 2 then
					event.open_message_window_2(0, "悪魔はユリスに「毒」のステータス異常をあたえた。")
				end
				if playable_character == 1 or playable_character == 3 then
					event.open_message_window_2(0, "悪魔はモニカに「毒」のステータス異常をあたえた。")
				end
			end
			if effect_id == 6 then
				if playable_character == 0 then
					event.open_message_window_2(0, "悪魔はユリスの体力を半分にした。")
				end
				if playable_character == 1 or playable_character == 3 then
					event.open_message_window_2(0, "悪魔はモニカの体力を半分にした。")
				end
				if playable_character == 2 then
					event.open_message_window_2(0, "悪魔はスティーブの耐久力を半分にした。")
				end
			end
			if effect_id == 8 then
				event.open_message_window_2(0, "悪魔は銃の「ＷＨＰ」を半分にした。")
			end
			if effect_id == 9 then
				event.open_message_window_2(0, "悪魔はレンチの「ＷＨＰ」を半分にした。")
			end
			if effect_id == 10 then
				event.open_message_window_2(0, "悪魔は腕輪の「ＷＨＰ」を半分にした。")
			end
			if effect_id == 11 then
				event.open_message_window_2(0, "悪魔は剣の「ＷＨＰ」を半分にした。")
			end
			if effect_id == 12 then
				event.open_message_window_2(0, "悪魔は全モンスターを復活させた。")
			end
		else
			event.open_message_window_2(0, "The coin flipped to 'Devil'")
			show_message_and_wait(0, -1, 8, 0, 0)
			if effect_id == 5 then
				if playable_character == 0 or playable_character == 2 then
					event.open_message_window_2(0, "Devil caused an abnormal status.")
				end
				if playable_character == 1 or playable_character == 3 then
					event.open_message_window_2(0, "Devil has poisoned Maximilian.")
				end
			end
			if effect_id == 6 then
				if playable_character == 0 then
					event.open_message_window_2(0, "Devil takes half of Maximilian's health.")
				end
				if playable_character == 1 or playable_character == 3 then
					event.open_message_window_2(0, "Devil takes half of Monica's health.")
				end
				if playable_character == 2 then
					event.open_message_window_2(0, "Devil takes half of Steve's health.")
				end
			end
			if effect_id == 8 then
				event.open_message_window_2(0, "Devil takes half of your gun's WHP.")
			end
			if effect_id == 9 then
				event.open_message_window_2(0, "Devil takes half of your wrench's WHP.")
			end
			if effect_id == 10 then
				event.open_message_window_2(0, "Devil takes half your bracelet's WHP.")
			end
			if effect_id == 11 then
				event.open_message_window_2(0, "Devil takes half of your sword's WHP.")
			end
			if effect_id == 12 then
				event.open_message_window_2(0, "Devil resurrected all monsters.")
			end
		end
	end
	effect_value = event.apply_random_circle_effect(effect_id) or effect_value
	show_message_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if effect_id == 1 then
		event.spawn_pull_items(circle_x, circle_y, circle_z, 1, 10, effect_value / 10.0)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the scene of the character picking up the geostone and receiving the item it grants.
function script.geostone()
	local playable_character: s32 = 0
	local language_code: s32 = 0
	local saved_x: f32 = 0
	local saved_y: f32 = 0
	local saved_z: f32 = 0
	local sound_bank: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local geostone_x: f32 = 0
	local geostone_y: f32 = 0
	local geostone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	event.initialize_event()
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 or playable_character == 3 then
		event.set_dungeon_pause_flags(1, 1)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.set_idle_motion()
		language_code = event.get_language() or language_code
		if language_code == 0 then
			if playable_character == 2 then
				event.open_message_window_2(0, "ライドポッドから降りないとダメなようだ。")
			else
				event.open_message_window_2(0, "モンスターに変化した状態だとダメなようだ")
			end
		elseif playable_character == 2 then
			event.open_message_window_2(0, "Must get off the Ridepod.")
		else
			event.open_message_window_2(0, "Looks like you can't do it\nas a monster.")
		end
		show_message_and_wait(0, -1, 8, 0, 0)
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		saved_x = out1 or saved_x
		saved_y = out2 or saved_y
		saved_z = out3 or saved_z
	end
	if playable_character == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(2)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if playable_character == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(4)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_bank
	event.set_dungeon_pause_flags(17, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	event.copy_vector(player_x, player_y, player_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		geostone_x = out1 or geostone_x
		geostone_y = out2 or geostone_y
		geostone_z = out3 or geostone_z
	end
	geostone_y = vm.f32(player_y + 18.0)
	event.set_object_handle_position(1, geostone_x, geostone_y, geostone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(geostone_x, geostone_y, geostone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if playable_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if playable_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	player_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + geostone_x)
	player_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + geostone_z)
	event.set_character_position(0, player_x, player_y, player_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if playable_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(player_x, player_y + 18.0, player_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, player_x, player_y + 36.0, player_z)
	end
	if playable_character == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(player_x, player_y + 18.0, player_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + player_x)
		effect_y = vm.f32(player_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + player_z)
		event.set_character_position(12, effect_x, effect_y, effect_z)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait.for_frame_count(16)
	event.play_sound_effect(sound_bank, 0)
	wait.for_frame_count(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.for_frame_count(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	facing_angle = event.get_direction_angle(player_x, player_y, player_z, camera_x, camera_y, camera_z) or facing_angle
	event.set_character_rotation(12, 0.0, facing_angle, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait.for_frame_count(20)
	event.play_sound_effect(sound_bank, 1)
	object.wait_until_done(0)
	show_item_obtained(358, 1)
	event.start_crossfade(10)
	if playable_character == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(12)
	end
	event.set_dungeon_pause_flags(17, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, saved_x, saved_y, saved_z)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.detach_geostone_from_character_frame()
	event.set_geostone_placed(0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(12)
	event.finish_event()
end

--- Opens the talk bubble for the monster the player is speaking to.
function script.monster_talk()
	local speaker: s32 = 0
	local message_index: s32 = 0
	do
		local out1, out2 = event.get_monster_talk_data_2()
		speaker = out1 or speaker
		message_index = out2 or message_index
	end
	show_talk_bubble(speaker, vm.i32(message_index + 1000), 1, 1)
end

--- Event 1200, which map data, a script or the engine runs by number.
script.play_robot_breakdown_event = play_robot_breakdown_event
script[1200] = script.play_robot_breakdown_event

--- The dungeon system event run when every monster on the floor has been defeated.
script.floor_clear = play_extermination_clear_event

--- Plays a Sphida golf shot from aiming and the power gauge through ball flight, pin and cup results, and the relocation or penalty that follows.
function script.sphida_shot()
	local texture_bank: s32 = 0
	local sound_bank: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local ball_rot_x: f32 = 0
	local aim_yaw: f32 = 0
	local ball_rot_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local launch_angle: f32 = 0
	local shot_power: f32 = 0
	local spin_scale: f32 = 0
	local shot_result: s32 = 0
	local spin_x: f32 = 0
	local curve_angle: f32 = 0
	local spin_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local pin_hit: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local ceiling_height: f32 = 0
	local fall_limit_y: f32 = 0
	local out_of_bounds_state: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local remaining_distance: f32 = 0
	local vector_length: f32 = 0
	local collision_id: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local frame_index: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local pin_distance: f32 = 0
	local to_pin_x: f32 = 0
	local to_pin_y: f32 = 0
	local to_pin_z: f32 = 0
	local pin_segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local yaw: f32 = 0
	local remaining_par: s32 = 0
	local relocate_choice: any = 0
	vm.wait(1)
	event.initialize_event()
	character.set_idle_motion()
	event.set_character_motion(0, "立ち")
	if prepare_sphida_club() ~= 0 then
		event.finish_event()
		return
	end
	event.show_dungeon_status_bar(0.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_3(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf"
	)
	vm.wait(3)
	wait.background_load()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	texture_bank = event.get_sphida_texture_bank() or texture_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_bank
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	ball_x, ball_y, ball_z, aim_yaw = dungeon_system_scripts_minigame.place_character_at_ball(ball_x, ball_y, ball_z, aim_yaw)
	dungeon_system_scripts_camera.place_camera_behind_character(aim_yaw)
	event.set_sphida_status_panel_visible(1)
	launch_angle = 12.5
	event.set_sphida_carry_angle(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power, spin_scale, shot_result = minigame.get_equipped_club_definition(shot_power, spin_scale, shot_result)
	event.set_sphida_power_gauge_safe_level(shot_result)
	do
		local out1, out2, out3 = event.zero_vector()
		spin_x = out1 or spin_x
		curve_angle = out2 or curve_angle
		spin_z = out3 or spin_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_yaw, launch_angle = dungeon_system_scripts_minigame.run_aim_phase(aim_yaw, launch_angle, texture_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_character_position(0, player_x, player_y, player_z)
			end_sphida_round(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, shot_power, aim_yaw, curve_angle, spin_x, shot_result = dungeon_system_scripts_minigame.run_shot_power_gauge(shot_power, texture_bank, aim_yaw, curve_angle, spin_x, sound_bank, shot_result)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	pin_hit = 0
	if shot_result ~= 1 and shot_result ~= -1 and shot_result ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if shot_result == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if shot_result == 2 or shot_result == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if shot_result == 3 or shot_result == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		wait.for_frame_count(10)
	end
	if shot_power <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.for_frame_count(25)
		if shot_result ~= 4 then
			event.play_sound_effect(sound_bank, 3)
		end
	elseif shot_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.for_frame_count(34)
		event.play_sound_effect(sound_bank, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.for_frame_count(39)
		if shot_result == 0 then
			event.play_sound_effect(sound_bank, 12)
		else
			event.play_sound_effect(sound_bank, 1)
		end
	end
	if shot_result == 4 then
		wait.for_frame_count(50)
		dungeon_system_scripts_minigame.end_when_par_exhausted(sound_bank)
		event.set_character_position(0, player_x, player_y, player_z)
		end_sphida_round(0)
		return
	end
	if shot_result == 0 then
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_event_sprite_position(1, 256, 278)
		event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
		event.set_event_sprite_size(1, 266, 42)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 10, 10, 10)
		event.attach_object_handle_to_sprite(19, 1)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
		event.set_object_sequence_scale(19, 1, 1, 1, 18)
		event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
		event.delay_object_sequence_color_track(19, 30)
		event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
	end
	shot_power = minigame.scale_by_club_power(shot_power)
	launch_angle = vm.f32(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power = vm.f32(shot_power - vm.f32(shot_power * launch_angle))
	velocity_x = vm.f32(vm.sin(aim_yaw) * vm.f32(shot_power * vm.cos(launch_angle)))
	velocity_y = vm.f32(shot_power * vm.sin(launch_angle))
	velocity_z = vm.f32(vm.cos(aim_yaw) * vm.f32(shot_power * vm.cos(launch_angle)))
	curve_angle = vm.f32(vm.f32(curve_angle * vm.f32(3.1415927)) / 2.0)
	spin_z = vm.f32(vm.f32(vm.f32(-velocity_z * spin_scale) * spin_x) * vm.f32(0.4))
	spin_x = vm.f32(vm.f32(vm.f32(-velocity_x * spin_scale) * spin_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	ceiling_height = 180.0
	fall_limit_y = -50.0
	out_of_bounds_state = 0
	shot_result = 0
	sound_cooldown = 0
	frame_index = 0
	while true do
		if ball_y >= ceiling_height then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame_index + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_id = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_id
			if shot_result == 1 and collision_id >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (frame_index + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + spin_x)
				velocity_z = vm.f32(velocity_z + spin_z)
				spin_x = vm.f32(spin_x * vm.f32(0.8))
				spin_z = vm.f32(spin_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (frame_index + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if curve_angle ~= 0.0 then
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			launch_angle = vm.f32(launch_angle + curve_angle)
			launch_angle = event.wrap_angle(launch_angle) or launch_angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(launch_angle) / 10.0) * spin_scale))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(launch_angle) / 10.0) * spin_scale))
		end
		vector_length = event.get_vector_length(spin_x, 0.0, spin_z) or vector_length
		if vector_length > vm.f32(0.01) then
			speed = event.get_vector_length(spin_x, 0.0, spin_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + spin_x, previous_y, previous_z + spin_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				ball_rot_x = out1 or ball_rot_x
				aim_yaw = out2 or aim_yaw
				ball_rot_z = out3 or ball_rot_z
			end
			event.set_character_rotation(8, ball_rot_x, launch_angle, ball_rot_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, ball_rot_x, launch_angle, ball_rot_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				ball_rot_x = out1 or ball_rot_x
				aim_yaw = out2 or aim_yaw
				ball_rot_z = out3 or ball_rot_z
			end
			event.set_character_rotation(8, ball_rot_x, launch_angle, ball_rot_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, ball_rot_x, launch_angle, ball_rot_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		remaining_distance = speed
		launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
		probe_x = vm.f32(vm.sin(vm.f32(launch_angle - vm.f32(1.5707964))) * 3.0)
		probe_z = vm.f32(vm.cos(vm.f32(launch_angle - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			ball_x - probe_x,
			ball_y,
			ball_z - probe_z,
			vm.f32(ball_x + probe_x) + probe_x,
			ball_y,
			vm.f32(ball_z + probe_z) + probe_z
		)
		do
			local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = event.normalize_vector(probe_x, probe_y, probe_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = event.scale_vector(probe_x, probe_y, probe_z, 3.0)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2 =
				event.get_segment_collision_10(0, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 0)
			collision_id = out1 or collision_id
			surface_type = out2 or surface_type
		end
		if collision_id >= 0 and surface_type == 1 then
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 11)
				sound_cooldown = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_id = out7 or collision_id
		end
		while collision_id >= 0 do
			curve_angle = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 6)
				sound_cooldown = 20
			end
			do
				local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.normalize_vector(velocity_x, velocity_y, velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.scale_vector(velocity_x, velocity_y, velocity_z, 3.0)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, velocity_x, velocity_y, velocity_z)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
			end
			do
				local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			vector_length = event.get_vector_length(previous_x, previous_y, previous_z) or vector_length
			vector_length = vm.f32(remaining_distance - vector_length)
			if vector_length <= 0.0 then
				break
			else
				remaining_distance = vector_length
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and normal_y > 0.0 then
					velocity_x = vm.f32(spin_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(spin_z * 2.0)
					spin_x = vm.f32(spin_x * vm.f32(0.2))
					spin_z = vm.f32(spin_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and normal_x > 0.0
						or velocity_x > 0.0 and normal_x < 0.0
						or velocity_z < 0.0 and normal_z > 0.0
						or velocity_z > 0.0 and normal_z < 0.0
					then
						spin_x = 0.0
						spin_z = 0.0
					end
					velocity_x = 0.0
					velocity_y = 0.0
					velocity_z = 0.0
				end
				velocity_x = vm.f32(vm.f32(vm.f32(normal_x * speed) * vm.f32(0.9)) + velocity_x)
				velocity_y = vm.f32(vm.f32(vm.f32(normal_y * speed) * vm.f32(0.58)) + velocity_y)
				velocity_z = vm.f32(vm.f32(vm.f32(normal_z * speed) * vm.f32(0.9)) + velocity_z)
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				do
					local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(probe_x, probe_y, probe_z)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.scale_vector(probe_x, probe_y, probe_z, 3.0)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.scale_vector(normal_x, normal_y, normal_z, vector_length)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, normal_x, normal_y, normal_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
						12,
						previous_x,
						previous_y,
						previous_z,
						ball_x + probe_x,
						ball_y + probe_y,
						ball_z + probe_z,
						1
					)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
					normal_x = out4 or normal_x
					normal_y = out5 or normal_y
					normal_z = out6 or normal_z
					collision_id = out7 or collision_id
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, ball_x, ball_y, ball_z, ball_x, ball_y - 3.0, ball_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_id = out7 or collision_id
			surface_type = out8 or surface_type
		end
		if collision_id >= 0 then
			curve_angle = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			vector_length = event.get_vector_length(velocity_x, 0.0, velocity_z) or vector_length
			if vector_length < vm.f32(2.4) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				shot_result = 1
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.9))
				velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
				velocity_z = vm.f32(velocity_z * vm.f32(0.9))
				velocity_x = vm.f32(velocity_x + vm.f32(spin_x * 2.0))
				velocity_z = vm.f32(velocity_z + vm.f32(spin_z * 2.0))
				spin_x = vm.f32(spin_x * vm.f32(0.2))
				spin_z = vm.f32(spin_z * vm.f32(0.2))
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 5)
					sound_cooldown = 20
				end
			end
			vector_length = event.get_vector_length(spin_x, 0.0, spin_z) or vector_length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and vector_length < vm.f32(0.4) then
				if not (surface_type == 6) then
					break
				end
				out_of_bounds_state = 1
				break
			end
		end
		if ball_y < -500.0 then
			out_of_bounds_state = 1
			break
		elseif frame_index >= 300 then
			out_of_bounds_state = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			to_pin_x = vm.f32(pin_x - ball_x)
			to_pin_y = vm.f32(pin_y - ball_y)
			to_pin_z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(to_pin_x, to_pin_y, to_pin_z) or pin_distance
			if ball_color ~= pin_color then
				pin_segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_segment_distance
				if pin_segment_distance >= 0.0 and pin_segment_distance <= 30.0 then
					pin_hit = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(to_pin_x, to_pin_y, to_pin_z, vm.fdiv(vm.f32(0.6), pin_distance))
							to_pin_x = out1 or to_pin_x
							to_pin_y = out2 or to_pin_y
							to_pin_z = out3 or to_pin_z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, to_pin_x, to_pin_y, to_pin_z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, to_pin_x, to_pin_y, to_pin_z)
							velocity_x = out1 or velocity_x
							velocity_y = out2 or velocity_y
							velocity_z = out3 or velocity_z
						end
					end
				else
					pin_hit = 1
					break
				end
			elseif pin_distance ~= 0.0 then
				if pin_distance <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(to_pin_x, to_pin_y, to_pin_z, vm.fdiv(1.0, pin_distance))
						to_pin_x = out1 or to_pin_x
						to_pin_y = out2 or to_pin_y
						to_pin_z = out3 or to_pin_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, to_pin_x, to_pin_y, to_pin_z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, to_pin_x, to_pin_y, to_pin_z)
						velocity_x = out1 or velocity_x
						velocity_y = out2 or velocity_y
						velocity_z = out3 or velocity_z
					end
				end
			end
			event.set_character_position(8, ball_x, ball_y, ball_z)
			event.set_character_position(9, ball_x, ball_y, ball_z)
			do
				local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			if ball_y <= fall_limit_y then
				event.set_follow_camera_following(0)
				if out_of_bounds_state >= 30 then
					if out_of_bounds_state >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				out_of_bounds_state = out_of_bounds_state + 1
			elseif frame_index >= 20 then
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_camera_speed(6.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.get_camera_position()
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				event.set_follow_camera_height(30.0)
				event.set_follow_camera_distance(200.0)
				yaw = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
				) or yaw
				event.set_follow_camera_angle(yaw)
				event.set_follow_camera_target_alternate(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z
				)
				event.step_follow_camera(1)
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			frame_index = frame_index + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	vm.wait(16)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if out_of_bounds_state == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		if pin_hit == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_bank, 17)
			frame_index = 0
			while frame_index < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_index = frame_index + 1
				vm.wait(17)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			frame_index = 0
			while frame_index < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_index = frame_index + 1
				vm.wait(18)
			end
			event.set_character_active(0, 11)
			event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, launch_angle, 294)
			wait.for_frame_count(54)
			wait.for_frame_count(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_bank
			event.stop_music(0)
			event.play_sound_effect(sound_bank, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
			event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
			event.set_event_sprite_position(0, 256, 208)
			event.set_event_sprite_size(0, 254, 54)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			event.set_event_sprite_scale(0, 5.0, 5.0)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			object.wait_until_done(0)
			wait.for_frame_count(90)
			vm.wait(23)
			event.play_music(0)
			event.set_character_position(0, player_x, player_y, player_z)
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		else
			remaining_par = event.get_sphida_par() or remaining_par
			if remaining_par >= 2 then
				event.set_message_window_mode(0, 5)
				event.set_message_selection_top_line(0, 0)
				relocate_choice = dungeon_system_scripts_message.ask_option(0, 2002, 8, 256, 208, 2, 0)
				vm.wait(25)
				if relocate_choice == 0 then
					do
						local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
						collision_id = out1 or collision_id
						player_x = out2 or player_x
						player_y = out3 or player_y
						player_z = out4 or player_z
					end
					if collision_id == 0 then
						do
							local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
							player_x = out1 or player_x
							player_y = out2 or player_y
							player_z = out3 or player_z
						end
					end
					do
						local out1, out2, out3 = event.get_sphida_pin_position()
						pin_x = out1 or pin_x
						pin_y = out2 or pin_y
						pin_z = out3 or pin_z
					end
					speed = event.get_distance_between(player_x, player_y, player_z, pin_x, pin_y, pin_z) or speed
					if speed < 40.0 then
						launch_angle = event.get_random_number(6.2831855) or launch_angle
						launch_angle = vm.f32(launch_angle - vm.f32(3.1415927))
						player_x = vm.f32(player_x + vm.f32(vm.sin(launch_angle) * 50.0))
						player_z = vm.f32(player_z + vm.f32(vm.cos(launch_angle) * 50.0))
					else
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(player_x, player_y, player_z)
							hit_x = out1 or hit_x
							hit_y = out2 or hit_y
							hit_z = out3 or hit_z
							collision_id = out4 or collision_id
						end
						frame_index = 0
						while collision_id >= 0 do
							do
								local out1, out2, out3 = event.copy_vector(player_x, player_y, player_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.normalize_vector(previous_x, previous_y, previous_z)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.scale_vector(previous_x, previous_y, previous_z, 32.0)
								previous_x = out1 or previous_x
								previous_y = out2 or previous_y
								previous_z = out3 or previous_z
							end
							do
								local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
								player_x = out1 or player_x
								player_y = out2 or player_y
								player_z = out3 or player_z
							end
							do
								local out1, out2, out3 = event.add_vectors(player_x, player_y, player_z, previous_x, previous_y, previous_z)
								player_x = out1 or player_x
								player_y = out2 or player_y
								player_z = out3 or player_z
							end
							do
								local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(player_x, player_y, player_z)
								hit_x = out1 or hit_x
								hit_y = out2 or hit_y
								hit_z = out3 or hit_z
								collision_id = out4 or collision_id
							end
							frame_index = frame_index + 1
							if frame_index > 6 then
								break
							end
						end
					end
					aim_yaw = event.get_direction_angle(player_x, player_y, player_z, ball_x, ball_y, ball_z) or aim_yaw
					event.set_character_position(0, player_x, player_y, player_z)
					event.set_character_rotation(0, 0.0, aim_yaw, 0.0)
					event.set_camera_look_at(player_x, player_y + 30.0, player_z)
					aim_yaw = vm.f32(aim_yaw - vm.f32(3.1415927))
					aim_yaw = event.wrap_angle(aim_yaw) or aim_yaw
					player_x = vm.f32(vm.f32(vm.sin(aim_yaw) * 100.0) + player_x)
					player_y = vm.f32(player_y + 30.0)
					player_z = vm.f32(vm.f32(vm.cos(aim_yaw) * 100.0) + player_z)
					event.set_camera_position(player_x, player_y, player_z)
					event.reset_follow_camera(0)
				else
					event.set_character_position(0, player_x, player_y, player_z)
				end
			else
				event.set_character_position(0, player_x, player_y, player_z)
			end
		end
	else
		event.play_sound_effect(sound_bank, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
		event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
		event.set_event_sprite_position(0, 256, -25)
		event.set_event_sprite_size(0, 160, 50)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
		object.wait_until_done(0)
		wait.for_frame_count(20)
		event.set_event_sprite_draw_pass(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		event.set_sphida_ball_position(ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(8, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(9, ball_x, ball_y + 3.0, ball_z)
		event.set_character_position(0, player_x, player_y, player_z)
		event.release_camera_sequence_follow_object()
	end
	if pin_hit == 1 then
		dungeon_system_scripts_minigame.end_when_par_exhausted(-1)
	else
		dungeon_system_scripts_minigame.end_when_par_exhausted(sound_bank)
	end
	end_sphida_round(pin_hit)
end

--- Offers to move the Sphida ball to the player position when the menu button is pressed near it.
function script.sphida_near_ball()
	local choice: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.set_idle_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	choice = dungeon_system_scripts_message.ask_option(0, 2004, 8, 256, 208, 2, 0)
	if choice == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_sphida_ball_position(player_x, player_y + 3.0, player_z)
		event.set_character_position(8, player_x, player_y + 3.0, player_z)
		event.set_character_position(9, player_x, player_y + 3.0, player_z)
		dungeon_system_scripts_minigame.end_when_par_exhausted(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

return script
