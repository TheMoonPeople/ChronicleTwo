--!strict
--- Event scenes and map toggles shared by the maps of the Cave of Ancient Murals.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local cave_of_ancient_murals = {}

--- Asks the player to confirm leaving with one of two prompts and fades out on acceptance, returning 1 if accepted and 0 otherwise.
function cave_of_ancient_murals.confirm_exit(prompt_variant: s32)
	local choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		if prompt_variant == 1 then
			resume_step = 1
			choice = message.ask_yes_no(1, -1)
		else
			resume_step = 2
			choice = message.ask_yes_no(2, -1)
		end
		if choice == 0 then
			event.fade_out_screen(30)
			resume_step = 3
			wait.frames(30)
			return 1
		else
			event.finish_event()
			return 0
		end
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step == 1 then
				choice = received[1] :: number
			end
			if resume_step == 2 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				choice = message.ask_prompt_choice(2, -1)
			end
			if resume_step <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Fades out the battle and plays the boss death animation before returning the character to the arena.
function cave_of_ancient_murals.play_boss_death()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	event.reset_action_character_motion(0, 4)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_dungeon_pause_flags(1, 1)
	event.clear_event_battle_monsters(-1)
	wait.frames(30)
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_360.sound.json") or sound_bank
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.show_dungeon_status_bar(0, 1.0)
	event.load_character(5, "dungeon/monster/b07a.gltf", "b07a", 8)
	event.set_character_active(1, 8)
	event.attach_object_handle_to_character(0, 8)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.fade_in_screen(15)
	event.set_camera_position(-50.62, 42.66, 812.75)
	event.set_camera_look_at(-50.82, 71.75, 656.03)
	event.set_character_active(0, 0)
	event.play_sound_effect(sound_bank, 24)
	event.set_object_sequence_position(0, -50.62, 4.34, 553.77)
	event.set_object_sequence_rotation(0, 0.0, 0.02, 0.0)
	event.set_object_sequence_motion(0, "死に", 6)
	event.wait_object_sequence_motion_end(0)
	object.wait_until_done(0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character ~= 2 then
		event.set_camera_position(-21.21, 14.5, 728.16)
		event.set_camera_look_at(-33.94, 17.9, 751.25)
	else
		event.set_camera_position(8.06, 23.77, 675.07)
		event.set_camera_look_at(-39.51, 29.49, 761.36)
	end
	event.set_character_active(1, 0)
	event.set_character_position(0, -40.07, 1.76, 766.47)
	event.set_character_rotation(0, 0.0, -3.12, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.delete_character(8)
	event.finish_event()
end

--- Plays event 416, which shows a title banner as the party reaches the gate chamber and ends by placing the party and a monster.
function cave_of_ancient_murals.play_gate_chamber_arrival()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local telop_image_block: s32 = 0
	local gate_rotation_x: f32 = 0
	local gate_rotation_y: f32 = 0
	local gate_target_rotation_z: f32 = 0
	local gate_original_rotation_x: f32 = 0
	local gate_original_rotation_y: f32 = 0
	local gate_original_rotation_z: f32 = 0
	local gate_original_position_x: f32 = 0
	local gate_original_position_y: f32 = 0
	local gate_original_position_z: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.set_save_flag(416, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		resume_step = 2
		wait.frames(6)
		event.load_music(30)
		event.load_map_sounds(4809)
		sound_bank = event.load_sound_effect_file_2(4809) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e416/")
		event.load_message_file(0, 5, "e416_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e416_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e416_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		telop_image_block = event.load_event_image_4(5, "e416telop01_1.json", 0) or telop_image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e416telop01", telop_image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(7, 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 7)
		event.change_directory("")
		event.load_character(5, "event/e400/e410/e410_shigu.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e400/e410/mariometto_a.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_character_to_frame(10, "metto_null", 11)
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e416/e416_mints.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e416/e416_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.attach_object_handle_to_map_part_3(3, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_handle_position(0, -65.0, -38.28, 1157.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, -85.0, -38.13, 1157.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, -78.11, -15.13, 426.88)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "威嚇", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "赤目パチ")
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(3)
			gate_rotation_x = out1 or gate_rotation_x
			gate_rotation_y = out2 or gate_rotation_y
			gate_target_rotation_z = out3 or gate_target_rotation_z
		end
		do
			local out1, out2, out3 = event.copy_vector(gate_rotation_x, gate_rotation_y, gate_target_rotation_z)
			gate_original_rotation_x = out1 or gate_original_rotation_x
			gate_original_rotation_y = out2 or gate_original_rotation_y
			gate_original_rotation_z = out3 or gate_original_rotation_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(4)
			gate_original_position_x = out1 or gate_original_position_x
			gate_original_position_y = out2 or gate_original_position_y
			gate_original_position_z = out3 or gate_original_position_z
		end
		gate_target_rotation_z = vm.f32(gate_original_rotation_z - vm.f32(3.1415927))
		gate_target_rotation_z = event.wrap_angle(gate_target_rotation_z) or gate_target_rotation_z
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-228.84, 94.46, 882.3)
		event.set_camera_sequence_look_at(-94.17, 38.37, 1068.72)
		event.rotate_object_sequence_eased(3, gate_rotation_x, gate_rotation_y, gate_target_rotation_z, 40, 0, 0.5)
		event.delay_object_sequence_position_track(4, 80)
		event.move_object_sequence_eased(4, gate_original_position_x, gate_original_position_y + 80.0, gate_original_position_z, 32, 1, 0.5)
		event.delay_object_sequence_position_track(0, 100)
		event.move_object_sequence(0, -65.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(0, 100)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(1, 110)
		event.move_object_sequence(1, -85.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(1, 110)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		resume_step = 3
		wait.frames(30)
		event.play_sound_effect(sound_bank, 0)
		resume_step = 4
		object.wait_until_done(1)
		resume_step = 5
		wait.frames(10)
		event.set_camera_sequence_position(-70.27, 35.0, 783.66)
		event.set_camera_sequence_look_at(-73.25, 38.33, 674.48)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(5, 128, 128, 128, 128, 30)
		event.play_sound_effect(sound_bank, 1)
		event.set_object_sequence_position(0, -50.18, 3.08, 671.54)
		event.set_object_sequence_rotation(0, 0.0, -2.9, 0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -96.49, 3.79, 674.91)
		event.set_object_sequence_rotation(1, 0.0, 2.78, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.play_music(0)
		resume_step = 6
		message.show_voiced(4160010)
		event.set_event_sprite_draw_pass(0, 0)
		event.stop_sound_effect(sound_bank, 1)
		event.set_camera_sequence_position(-29.56, 15.56, 642.62)
		event.set_camera_sequence_look_at(-64.62, 25.05, 676.95)
		event.set_object_sequence_motion(0, "間抜け立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, -78.55, 3.48, 677.41)
		event.set_object_sequence_rotation(1, 0.0, 2.3, 0.0)
		event.set_object_sequence_motion(1, "指差し", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "指差し会話", 6)
		event.queue_object_sequence_next_motion(1, "指差しＬ", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		resume_step = 7
		message.show_voiced(4160020)
		resume_step = 8
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "うん！", 2)
		event.queue_object_sequence_next_motion(0, "間抜け立ち", 4)
		resume_step = 9
		wait.frames(10)
		event.play_sound_effect(sound_bank, 2)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 10
		message.show_voiced(4160030)
		resume_step = 11
		object.wait_until_done(0)
		event.fade_out_screen(30)
		resume_step = 12
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			wait.frames_skipping(6)
		end
		if resume_step <= 2 then
			gate_target_rotation_z = vm.f32(gate_original_rotation_z - vm.f32(3.1415927))
			wait.frames_skipping(30)
		end
		if resume_step <= 3 then
			cutscene.skip_command(1)
		end
		if resume_step <= 4 then
			wait.frames_skipping(10)
		end
		if resume_step <= 5 then
			message.show_voiced_skipping(4160010)
		end
		if resume_step <= 6 then
			message.show_voiced_skipping(4160020)
		end
		if resume_step <= 7 then
			cutscene.skip_command(1)
		end
		if resume_step <= 8 then
			wait.frames_skipping(10)
		end
		if resume_step <= 9 then
			message.show_voiced_skipping(4160030)
		end
		if resume_step <= 10 then
			cutscene.skip_command(0)
		end
		if resume_step <= 11 then
			wait.frames_skipping(30)
		end
		return true
	end)
	resume_step = 13
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.stop_sound_effect(sound_bank, 1)
	event.stop_sound_effect(sound_bank, 2)
	event.set_event_sprite_draw_pass(0, 0)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_rotation(3, gate_original_rotation_x, gate_original_rotation_y, gate_original_rotation_z)
	event.set_object_handle_position(4, gate_original_position_x, gate_original_position_y, gate_original_position_z)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.set_character_active(0)
	event.set_character_position(0, -96.2, 1.8, 851.5)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_look_at(-96.2, 31.8, 851.5)
	event.set_camera_position(-96.2, 41.8, 951.5)
	event.reset_follow_camera(0)
	resume_step = 14
	vm.wait(14)
	event.load_dungeon_monster(516, 1)
	event.load_dungeon_monster(1001, 0)
	event.place_dungeon_monster(516, -78.11, -15.13, 426.88, 0.0, 0.0, 0.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays the scene in which the gate parts turn and rise while the character runs and walks toward them.
function cave_of_ancient_murals.play_gate_opening()
	local sound_bank: s32 = 0
	local gate_rotation_x: f32 = 0
	local gate_rotation_y: f32 = 0
	local gate_target_rotation_z: f32 = 0
	local gate_original_rotation_x: f32 = 0
	local gate_original_rotation_y: f32 = 0
	local gate_original_rotation_z: f32 = 0
	local gate_original_position_x: f32 = 0
	local gate_original_position_y: f32 = 0
	local gate_original_position_z: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.initialize_event()
		sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or sound_bank
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_3(1, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(3, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -75.0, -35.0, 1200.0)
		event.set_object_handle_rotation(0, 0.0, 3.1415927, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 7)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-127.01131, -7.1499996, 911.04)
		event.set_camera_sequence_look_at(-62.911304, 39.29, 1129.9199)
		event.mark_camera_sequence_fade_track()
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.play_sound_effect(sound_bank, 1)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(1)
			gate_rotation_x = out1 or gate_rotation_x
			gate_rotation_y = out2 or gate_rotation_y
			gate_target_rotation_z = out3 or gate_target_rotation_z
		end
		do
			local out1, out2, out3 = event.copy_vector(gate_rotation_x, gate_rotation_y, gate_target_rotation_z)
			gate_original_rotation_x = out1 or gate_original_rotation_x
			gate_original_rotation_y = out2 or gate_original_rotation_y
			gate_original_rotation_z = out3 or gate_original_rotation_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(3)
			gate_original_position_x = out1 or gate_original_position_x
			gate_original_position_y = out2 or gate_original_position_y
			gate_original_position_z = out3 or gate_original_position_z
		end
		gate_target_rotation_z = vm.f32(gate_original_rotation_z - vm.f32(3.1415927))
		gate_target_rotation_z = event.wrap_angle(gate_target_rotation_z) or gate_target_rotation_z
		event.rotate_object_sequence_eased(1, gate_rotation_x, gate_rotation_y, gate_target_rotation_z, 40, 0, 0.5)
		resume_step = 2
		object.wait_until_done(1)
		event.move_object_sequence_eased(3, gate_original_position_x, gate_original_position_y + 80.0, gate_original_position_z, 32, 1, 0.5)
		resume_step = 3
		wait.frames(20)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -75.0, -35.0, 1055.0, 30)
		event.set_object_handle_footstep_sound(0, 16)
		resume_step = 4
		object.wait_until_done(3)
		event.move_object_sequence_eased(3, gate_original_position_x, gate_original_position_y, gate_original_position_z, 32, 0, 0.5)
		resume_step = 5
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 30)
		event.delay_object_sequence_position_track(0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -75.0, -25.0, 1015.0, 40)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 6
		object.wait_until_done(3)
		event.set_object_handle_footstep_sound(0, 0)
		event.rotate_object_sequence_eased(1, gate_original_rotation_x, gate_original_rotation_y, gate_original_rotation_z, 40, 0, 0.5)
		resume_step = 7
		object.wait_until_done(1)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			gate_target_rotation_z = vm.f32(gate_original_rotation_z - vm.f32(3.1415927))
			cutscene.skip_command(1)
		end
		if resume_step <= 2 then
			wait.frames_skipping(20)
		end
		if resume_step <= 3 then
			cutscene.skip_command(3)
		end
		if resume_step <= 4 then
			cutscene.skip_command(0)
		end
		if resume_step <= 5 then
			cutscene.skip_command(3)
		end
		if resume_step <= 6 then
			cutscene.skip_command(1)
		end
		return true
	end)
	resume_step = 8
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 1)
	resume_step = 9
	vm.wait(9)
	event.set_object_handle_rotation(1, gate_original_rotation_x, gate_original_rotation_y, gate_original_rotation_z)
	event.set_object_handle_position(3, gate_original_position_x, gate_original_position_y, gate_original_position_z)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	character.place_standing_and_reset_cloth(-75.0, -10.0, 950.0, vm.f32(3.1415927))
	event.set_camera_position(-75.0, 50.0, 1030.0)
	event.set_camera_look_at(-75.0, 20.0, 950.0)
	event.reset_follow_camera(0)
	event.start_crossfade(30)
	event.finish_event()
end

--- Plays event 410, in which the gate parts turn and rise, the party runs in and argues with a threatening marionette creature.
function cave_of_ancient_murals.play_marionette_confrontation()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local gate_rotation_x: f32 = 0
	local gate_rotation_y: f32 = 0
	local gate_target_rotation_z: f32 = 0
	local gate_original_rotation_x: f32 = 0
	local gate_original_rotation_y: f32 = 0
	local gate_original_rotation_z: f32 = 0
	local gate_original_position_x: f32 = 0
	local gate_original_position_y: f32 = 0
	local gate_original_position_z: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.set_save_flag(410, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_map_sounds(4806)
		sound_bank = event.load_sound_effect_file_2(4806) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e410/")
		event.load_message_file(0, 5, "e410_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e410_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e410_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e410_shigu.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "mariometto_a.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_character_to_frame(10, "metto_null", 11)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e410/e410_mints.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e410/e410_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.attach_object_handle_to_map_part_3(3, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_handle_position(0, -65.0, -38.28, 1157.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -85.0, -38.13, 1157.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -78.11, -15.13, 426.88)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "威嚇", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "赤目パチ")
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(3)
			gate_rotation_x = out1 or gate_rotation_x
			gate_rotation_y = out2 or gate_rotation_y
			gate_target_rotation_z = out3 or gate_target_rotation_z
		end
		do
			local out1, out2, out3 = event.copy_vector(gate_rotation_x, gate_rotation_y, gate_target_rotation_z)
			gate_original_rotation_x = out1 or gate_original_rotation_x
			gate_original_rotation_y = out2 or gate_original_rotation_y
			gate_original_rotation_z = out3 or gate_original_rotation_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(4)
			gate_original_position_x = out1 or gate_original_position_x
			gate_original_position_y = out2 or gate_original_position_y
			gate_original_position_z = out3 or gate_original_position_z
		end
		gate_target_rotation_z = vm.f32(gate_original_rotation_z - vm.f32(3.1415927))
		gate_target_rotation_z = event.wrap_angle(gate_target_rotation_z) or gate_target_rotation_z
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-228.84, 94.46, 882.3)
		event.set_camera_sequence_look_at(-94.17, 38.37, 1068.72)
		event.rotate_object_sequence_eased(3, gate_rotation_x, gate_rotation_y, gate_target_rotation_z, 40, 0, 0.5)
		event.delay_object_sequence_position_track(4, 80)
		event.move_object_sequence_eased(4, gate_original_position_x, gate_original_position_y + 80.0, gate_original_position_z, 32, 1, 0.5)
		event.delay_object_sequence_position_track(0, 100)
		event.move_object_sequence(0, -65.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(0, 100)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(1, 110)
		event.move_object_sequence(1, -85.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(1, 110)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		resume_step = 2
		wait.frames(30)
		event.play_sound_effect(sound_bank, 0)
		resume_step = 3
		object.wait_until_done(1)
		resume_step = 4
		wait.frames(6)
		event.set_camera_sequence_position(-70.27, 35.0, 783.66)
		event.set_camera_sequence_look_at(-73.25, 38.33, 674.48)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "こまり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(sound_bank, 1)
		event.set_object_sequence_position(0, -50.18, 3.08, 671.54)
		event.set_object_sequence_rotation(0, 0.0, -2.9, 0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -96.49, 3.79, 674.91)
		event.set_object_sequence_rotation(1, 0.0, 2.78, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		resume_step = 5
		message.show_voiced(4100010)
		resume_step = 6
		message.show_voiced(4100020)
		resume_step = 7
		message.show_voiced(4100030)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, -73.19, 2.27, 776.78, 60, 1)
		event.rotate_object_sequence(1, 0.0, 0.26, 0.0, 10)
		resume_step = 8
		wait.frames(10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -63.51, 2.44, 748.06, 50, 1)
		event.rotate_object_sequence(0, 0.0, -0.14, 0.0, 10)
		resume_step = 9
		wait.frames(20)
		event.fade_out_screen(30)
		resume_step = 10
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			gate_target_rotation_z = vm.f32(gate_original_rotation_z - vm.f32(3.1415927))
			wait.frames_skipping(30)
		end
		if resume_step <= 2 then
			cutscene.skip_command(1)
		end
		if resume_step <= 3 then
			wait.frames_skipping(6)
		end
		if resume_step <= 4 then
			message.show_voiced_skipping(4100010)
		end
		if resume_step <= 5 then
			message.show_voiced_skipping(4100020)
		end
		if resume_step <= 6 then
			message.show_voiced_skipping(4100030)
		end
		if resume_step <= 7 then
			wait.frames_skipping(10)
		end
		if resume_step <= 8 then
			wait.frames_skipping(20)
		end
		if resume_step <= 9 then
			wait.frames_skipping(30)
		end
		return true
	end)
	resume_step = 11
	vm.entry(11)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.stop_sound_effect(sound_bank, 1)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_rotation(3, gate_original_rotation_x, gate_original_rotation_y, gate_original_rotation_z)
	event.set_object_handle_position(4, gate_original_position_x, gate_original_position_y, gate_original_position_z)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.finish_event()
end

--- Plays event 420, in which the marionette creature is electrocuted, loses its helmet and collapses while the party speaks voiced dialogue.
function cave_of_ancient_murals.play_marionette_shock()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local voice_stream_delay: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.set_save_flag(420, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		event.load_map_sounds(4811)
		sound_bank = event.load_sound_effect_file_2(4811) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e420/")
		event.load_message_file(0, 5, "e420_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e420_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e420_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e420_paw.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e420_shigu.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "mariometto_a.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_character_to_frame(11, "metto_null", 12)
		event.attach_object_handle_to_character(6, 12)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "e420_kanden.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e420/e420_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e420/e420_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_position(0, -50.18, 3.08, 671.54)
		event.set_object_handle_rotation(0, 0.0, -2.9, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -96.49, 3.79, 674.91)
		event.set_object_handle_rotation(1, 0.0, 2.78, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -72.89, 2.34, 770.75)
		event.set_object_handle_rotation(2, 0.0, -3.02, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_handle_position(3, -78.16, -9.08, 455.31)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "立ち2", 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "赤目パチ")
		event.set_character_position(13, -78.16, -9.08, 455.31)
		event.set_character_rotation(13, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.enable_drama_skip()
		event.set_camera_sequence_position(-91.15, 8.06, 663.16)
		event.set_camera_sequence_look_at(-79.05, 47.63, 524.91)
		event.set_object_sequence_motion(3, "感電", 6)
		event.queue_object_sequence_next_motion(3, "感電L", 4)
		event.fade_in_screen(30)
		event.set_message_button_prompt(0, 0)
		event.open_voice_stream_wave(1, 4200010)
		resume_step = 2
		voice_stream_delay = sound.wait_voice_stream_ready_counting(1)
		resume_step = 3
		wait.frames(vm.i32(10 - voice_stream_delay))
		event.play_voice_stream(1)
		resume_step = 4
		wait.frames(vm.i32(30 - voice_stream_delay))
		resume_step = 5
		object.wait_until_done(3)
		event.set_function_point_enabled("", "e420_lg", 1)
		event.play_sound_effect(sound_bank, 4)
		event.set_character_active(1, 13)
		resume_step = 6
		wait.frames(80)
		event.set_character_active(0, 13)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		event.set_function_point_enabled("", "e420_lg", 0)
		event.set_camera_sequence_position(-39.38, 84.75, 556.88)
		event.set_camera_sequence_look_at(-82.55, -1.03, 671.45)
		event.move_object_sequence(2, -72.44, 3.87, 634.26, 40, 1)
		event.set_object_sequence_motion(2, "上見走り", 4)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "上見立ち")
		resume_step = 7
		message.show_voiced(4200020)
		resume_step = 8
		object.wait_until_done(2)
		event.set_camera_sequence_position(-81.13, -20.11, 556.35)
		event.set_camera_sequence_look_at(-83.71, 9.43, 543.03)
		event.stop_sound_effect(sound_bank, 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "赤目～赤目とじ")
		event.set_object_sequence_motion(3, "メット落ちる", 6)
		event.queue_object_sequence_next_motion(3, "倒れる", 6)
		event.wait_object_sequence_motion_end(3)
		event.delay_object_sequence_sound_track(3, 60)
		event.play_object_sequence_sound(3, sound_bank, 6)
		event.move_object_sequence_eased(6, -75.71, -140.18, 221.57, 30, 1, 1.0)
		event.rotate_object_sequence_eased(6, 0.0, 0.0, 1.8, 30, 0, 1.0)
		event.delay_object_sequence_sound_track(6, 50)
		event.play_object_sequence_sound(6, sound_bank, 5)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		resume_step = 9
		wait.frames(60)
		event.set_character_active(0, 12)
		resume_step = 10
		object.wait_until_done(3)
		event.set_camera_sequence_position(-266.34, 202.78, 745.86)
		event.set_camera_sequence_look_at(-86.65, 17.8, 537.9)
		event.set_camera_sequence_position(-77.85, 7.32, 623.69)
		event.set_camera_sequence_look_at(-79.23, 12.59, 599.39)
		event.shake_camera_sequence(0.0, 2.0, 0.0, 25)
		resume_step = 11
		wait.frames(25)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "苦痛目とじ")
		event.set_object_sequence_motion(3, "ぐったり", 6)
		event.set_camera_sequence_position(-266.34, 202.78, 745.86)
		event.set_camera_sequence_look_at(-86.65, 17.8, 537.9)
		resume_step = 12
		message.show_voiced(4200030)
		event.move_object_sequence(2, -49.93, 4.12, 578.82, 30, 1)
		event.rotate_object_sequence(2, 0.0, 2.78, 0.0, 10)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "立ち")
		resume_step = 13
		message.show_voiced(4200040)
		resume_step = 14
		object.wait_until_done(2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-126.48, 23.27, 645.95)
		event.set_camera_sequence_look_at(-48.09, 21.64, 692.16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		resume_step = 15
		message.show_voiced(4200050)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 16
		message.show_voiced(4200060)
		event.move_object_sequence(0, -73.29, 4.2, 606.39, 40, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.rotate_object_sequence(0, 0.0, 2.9, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 17
		wait.frames(8)
		event.move_object_sequence(1, -89.41, 4.65, 588.63, 40, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, 2.18, 0.0, 10)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 18
		wait.frames(30)
		event.set_camera_sequence_position(-23.86, 87.25, 654.66)
		event.set_camera_sequence_look_at(-59.69, 21.64, 584.77)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "半目パチ")
		resume_step = 19
		object.wait_until_done(1)
		resume_step = 20
		message.show_voiced(4200070)
		resume_step = 21
		message.show_voiced(4200080)
		resume_step = 22
		message.show_voiced(4200090)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		resume_step = 23
		message.show_voiced(4200100)
		event.fade_out_screen(30)
		resume_step = 24
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step == 2 then
			voice_stream_delay = received[1] :: number
		end
		if resume_step <= 1 then
			voice_stream_delay = sound.wait_voice_stream_ready_counting_skipping(1)
		end
		if resume_step <= 2 then
			wait.frames_skipping(vm.i32(10 - voice_stream_delay))
		end
		if resume_step <= 3 then
			wait.frames_skipping(vm.i32(30 - voice_stream_delay))
		end
		if resume_step <= 4 then
			cutscene.skip_command(3)
		end
		if resume_step <= 5 then
			wait.frames_skipping(80)
		end
		if resume_step <= 6 then
			message.show_voiced_skipping(4200020)
		end
		if resume_step <= 7 then
			cutscene.skip_command(2)
		end
		if resume_step <= 8 then
			wait.frames_skipping(60)
		end
		if resume_step <= 9 then
			cutscene.skip_command(3)
		end
		if resume_step <= 10 then
			wait.frames_skipping(25)
		end
		if resume_step <= 11 then
			message.show_voiced_skipping(4200030)
		end
		if resume_step <= 12 then
			message.show_voiced_skipping(4200040)
		end
		if resume_step <= 13 then
			cutscene.skip_command(2)
		end
		if resume_step <= 14 then
			message.show_voiced_skipping(4200050)
		end
		if resume_step <= 15 then
			message.show_voiced_skipping(4200060)
		end
		if resume_step <= 16 then
			wait.frames_skipping(8)
		end
		if resume_step <= 17 then
			wait.frames_skipping(30)
		end
		if resume_step <= 18 then
			cutscene.skip_command(1)
		end
		if resume_step <= 19 then
			message.show_voiced_skipping(4200070)
		end
		if resume_step <= 20 then
			message.show_voiced_skipping(4200080)
		end
		if resume_step <= 21 then
			message.show_voiced_skipping(4200090)
		end
		if resume_step <= 22 then
			message.show_voiced_skipping(4200100)
		end
		if resume_step <= 23 then
			wait.frames_skipping(30)
		end
		return true
	end)
	resume_step = 25
	vm.entry(25)
	event.cancel_drama_scene_skip()
	event.set_function_point_enabled("", "e420_lg", 0)
	event.stop_sound_effect(sound_bank, 4)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	event.finish_event()
end

--- Plays event 408, the long scene in which the party meets the creatures, a monster appears and the party runs from it.
function cave_of_ancient_murals.play_monster_encounter()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local gate_rotation_x: f32 = 0
	local gate_rotation_y: f32 = 0
	local gate_target_rotation_z: f32 = 0
	local gate_original_rotation_x: f32 = 0
	local gate_original_rotation_y: f32 = 0
	local gate_original_rotation_z: f32 = 0
	local gate_original_position_x: f32 = 0
	local gate_original_position_y: f32 = 0
	local gate_original_position_z: f32 = 0
	local camera_look_x: f32 = 0
	local camera_look_speed: f32 = 0
	local camera_look_deceleration: f32 = 0
	local i: s32 = 0
	local is_voice_opening: s32 = 0
	local is_voice_ready: s32 = 0
	local stream_open_state: s32 = 0
	local voice_message_id: s32 = 0
	local voice_stream_delay: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.set_save_flag(408, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_map_sounds(4803)
		sound_bank = event.load_sound_effect_file_2(4803) or sound_bank
		event.play_sound_effect(sound_bank, 11)
		resume_step = 2
		vm.wait(2)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e408/")
		event.load_message_file(0, 5, "e408_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e408_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e408_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e408_paw.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e408_shigu.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "mariometto_a.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_character_to_frame(11, "metto_null", 12)
		event.load_character(5, "e408_mizusibuki.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.set_scene_character_type(13, 4)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e408/e408_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e408/e408_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(6, 1)
		event.attach_object_handle_to_character(7, 2)
		event.attach_object_handle_to_map_part_3(4, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_handle_position(0, -70.0, 5.18, 610.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -85.0, 5.18, 620.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -76.0, -38.33, 1157.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_handle_position(3, -68.33, -4.68, 302.5)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "出現", 5)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "赤目パチ")
		event.set_character_position(13, -72.26, 0.0, 371.59)
		event.set_character_rotation(13, 0.0, -0.12, 0.0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_visible(7, 0)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(4)
			gate_rotation_x = out1 or gate_rotation_x
			gate_rotation_y = out2 or gate_rotation_y
			gate_target_rotation_z = out3 or gate_target_rotation_z
		end
		do
			local out1, out2, out3 = event.copy_vector(gate_rotation_x, gate_rotation_y, gate_target_rotation_z)
			gate_original_rotation_x = out1 or gate_original_rotation_x
			gate_original_rotation_y = out2 or gate_original_rotation_y
			gate_original_rotation_z = out3 or gate_original_rotation_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			gate_original_position_x = out1 or gate_original_position_x
			gate_original_position_y = out2 or gate_original_position_y
			gate_original_position_z = out3 or gate_original_position_z
		end
		gate_target_rotation_z = vm.f32(gate_original_rotation_z - vm.f32(3.1415927))
		gate_target_rotation_z = event.wrap_angle(gate_target_rotation_z) or gate_target_rotation_z
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-78.09, 35.57, 471.0)
		event.set_camera_sequence_look_at(-77.73, 22.13, 561.51)
		event.move_object_sequence(0, -70.0, 4.89, 540.0, 60, 1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, -85.0, 5.18, 540.0, 70, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 70)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		resume_step = 3
		object.wait_until_done(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 4
		message.show_voiced(4080010)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 5
		message.show_voiced(4080020)
		event.set_camera_sequence_position(-80.97, 22.27, 518.15)
		event.set_camera_sequence_look_at(-69.62, 27.4, 537.26)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 6
		message.show_voiced(4080030)
		event.set_message_button_prompt(0, 0)
		camera_look_x = -140.0
		camera_look_speed = vm.f32(1.9)
		camera_look_deceleration = vm.f32(-0.044)
		event.set_camera_sequence_position(-86.24, 243.02, 628.3)
		event.set_camera_sequence_look_at(camera_look_x, 253.78, 519.17)
		is_voice_opening = 0
		is_voice_ready = 0
		i = 0
		while i < 440 do
			event.set_camera_sequence_look_at(camera_look_x, 253.78, 519.17)
			camera_look_x = vm.f32(camera_look_x + camera_look_speed)
			if i < 42 then
				camera_look_speed = vm.f32(camera_look_speed + camera_look_deceleration)
			end
			if is_voice_opening == 1 then
				stream_open_state = event.get_voice_stream_open_state() or stream_open_state
				if stream_open_state == 0 then
					is_voice_opening = 0
					is_voice_ready = 1
					event.ready_voice_stream(1)
				end
			end
			if is_voice_ready == 1 then
				stream_open_state = event.get_voice_stream_open_state() or stream_open_state
				if stream_open_state == 0 then
					is_voice_ready = 0
					event.open_message_window_2(0, voice_message_id)
					message.open(0, -1, 8, 0, 0)
					event.play_voice_stream(1)
				end
			end
			if i == 0 then
				voice_message_id = 4080040
				event.open_voice_stream_wave(1, voice_message_id)
				is_voice_opening = 1
			end
			if i == 180 then
				message.close(0)
				event.close_voice_stream(1)
				voice_message_id = 4080045
				event.open_voice_stream_wave(1, voice_message_id)
				is_voice_opening = 1
			end
			i = i + 1
			resume_step = 7
			vm.wait(7)
		end
		message.close(0)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		event.set_camera_sequence_position(-71.52, 55.19, 769.57)
		event.set_camera_sequence_look_at(-78.08, 79.65, 504.61)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 8
		message.show_voiced(4080050)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 9
		message.show_voiced(4080060)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 10
		message.show_voiced(4080070)
		resume_step = 11
		object.wait_until_done(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 12
		message.show_voiced(4080080)
		resume_step = 13
		message.show_voiced(4080090)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		resume_step = 14
		object.wait_until_done(0)
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_object_sequence_motion(3, "出現", 6)
		event.queue_object_sequence_next_motion(3, "出現L", 4)
		event.set_character_active(1, 13)
		event.set_character_motion(13, "出現", 6)
		event.play_sound_effect(sound_bank, 2)
		resume_step = 15
		wait.frames(50)
		event.set_camera_sequence_position(-79.56, 83.32, 667.05)
		event.set_camera_sequence_look_at(-76.25, 31.32, 465.62)
		event.set_object_sequence_motion(0, "驚く", 6)
		event.queue_object_sequence_next_motion(0, "驚くL", 4)
		event.set_object_sequence_motion(1, "びっくりから上見", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		resume_step = 16
		object.wait_until_done(3)
		event.stop_music(0)
		event.start_background_file_loads_1("snd2/bgm/bg_191.sound.json")
		resume_step = 17
		wait.frames(4)
		resume_step = 18
		wait.background_load()
		event.load_music_pack(191)
		event.play_music(0)
		event.set_camera_sequence_position(-82.34, 24.64, 525.1)
		event.set_camera_sequence_look_at(-68.49, 28.0, 544.23)
		event.set_character_active(0, 13)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "大口パク")
		resume_step = 19
		message.show_voiced(4080100)
		event.set_camera_sequence_position(-73.64, 31.85, 524.1)
		event.set_camera_sequence_look_at(-86.33, 28.93, 539.68)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 20
		message.show_voiced(4080110)
		event.set_camera_sequence_position(-80.48, 94.7, 723.29)
		event.set_camera_sequence_look_at(-76.25, 38.16, 465.62)
		event.set_object_sequence_position(3, -78.11, -15.13, 426.88)
		event.set_object_sequence_motion(3, "攻撃", 6)
		event.queue_object_sequence_next_motion(3, "立ち2", 4)
		resume_step = 21
		wait.frames(10)
		event.play_sound_effect(sound_bank, 3)
		event.move_object_sequence(0, -44.9, 3.81, 599.34, 20)
		event.rotate_object_sequence(0, 0.0, 0.38, 0.0, 8)
		event.delay_object_sequence_rotation_track(0, 4)
		event.rotate_object_sequence(0, 0.0, -2.98, 0.0, 8)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, -112.34, 5.0, 594.97, 20)
		event.rotate_object_sequence(1, 0.0, -0.5, 0.0, 8)
		event.delay_object_sequence_rotation_track(1, 4)
		event.rotate_object_sequence(1, 0.0, 2.78, 0.0, 8)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 22
		object.wait_until_done(0)
		resume_step = 23
		object.wait_until_done(3)
		event.set_camera_sequence_position(-62.07, 18.74, 574.92)
		event.set_camera_sequence_look_at(-42.47, 24.02, 598.1)
		event.play_sound_effect(sound_bank, 4)
		event.set_object_sequence_motion(0, "やめろ", 6)
		event.queue_object_sequence_next_motion(0, "驚くL", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		resume_step = 24
		message.show_voiced(4080120)
		resume_step = 25
		object.wait_until_done(0)
		event.set_camera_sequence_position(-90.65, 28.85, 590.7)
		event.set_camera_sequence_look_at(-115.93, 29.03, 592.13)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "大口パク")
		resume_step = 26
		message.show_voiced(4080130)
		event.set_camera_sequence_position(-72.77, 80.75, 769.84)
		event.set_camera_sequence_look_at(-77.4, 43.66, 562.84)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(3, "威嚇", 6)
		event.queue_object_sequence_next_motion(3, "立ち2", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		resume_step = 27
		message.show_voiced(4080140)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 28
		message.show_voiced(4080150)
		event.stop_sound_effect(sound_bank, 5)
		event.set_camera_sequence_position(-76.95, 45.52, 498.09)
		event.set_camera_sequence_look_at(-76.43, 15.43, 706.96)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目～通常目")
		event.set_character_active(10)
		event.rotate_object_sequence_eased(4, gate_rotation_x, gate_rotation_y, gate_target_rotation_z, 40, 0, 0.5)
		event.delay_object_sequence_rotation_track(4, 168)
		event.rotate_object_sequence_eased(4, gate_original_rotation_x, gate_original_rotation_y, gate_original_rotation_z, 40, 0, 0.5)
		event.delay_object_sequence_position_track(5, 80)
		event.move_object_sequence_eased(5, gate_original_position_x, gate_original_position_y + 80.0, gate_original_position_z, 32, 1, 0.5)
		event.delay_object_sequence_position_track(5, 40)
		event.move_object_sequence_eased(5, gate_original_position_x, gate_original_position_y, gate_original_position_z, 32, 0, 0.5)
		event.set_object_sequence_motion(0, "立ち", 6)
		event.delay_object_sequence_motion_track(0, 4)
		event.set_object_sequence_motion(0, "振り向く（左）", 6)
		event.queue_object_sequence_next_motion(0, "振り向く（左）L", 4)
		event.set_object_sequence_motion(1, "立ち", 6)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "振り向き", 6)
		event.queue_object_sequence_next_motion(1, "振り向きＬ", 4)
		resume_step = 29
		wait.frames(90)
		event.set_object_sequence_motion(2, "上見走り")
		event.move_object_sequence(2, -76.55, 0.45, 877.82, 60, 1)
		resume_step = 30
		wait.frames(10)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 31
		message.show_voiced_for(4080160, 50)
		resume_step = 32
		object.wait_until_done(2)
		event.set_camera_sequence_follow_object(2, 0.0, 18.3, -4.0, -2.0, -0.57, 24.0)
		event.set_object_sequence_position(2, -76.0, 1.92, 813.28)
		event.move_object_sequence(2, -78.0, 4.89, 551.73, 120, 1)
		event.delay_object_sequence_motion_track(2, 120)
		event.set_object_sequence_motion(2, "上見立ち")
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目")
		event.set_object_sequence_motion(0, "驚くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		resume_step = 33
		message.show_voiced(4080170)
		resume_step = 34
		object.wait_until_done(2)
		event.release_camera_sequence_follow_object()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 35
		message.show_voiced(4080180)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 36
		message.show_voiced(4080185)
		resume_step = 37
		wait.frames(10)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目～おどろき目")
		event.set_object_sequence_motion(2, "！！", 2)
		event.queue_object_sequence_next_motion(2, "上見立ち")
		resume_step = 38
		message.show_voiced_with_button_prompt(4080190, -1, 0)
		event.set_camera_sequence_position(-73.07, -10.65, 595.6)
		event.set_camera_sequence_look_at(-87.35, 69.1, 460.59)
		event.play_sound_effect(sound_bank, 7)
		event.set_character_active(0, 10)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目")
		event.set_object_sequence_motion(3, "攻撃", 6)
		event.delay_object_sequence_motion_track(3, 30)
		event.set_object_sequence_motion(3, "攻撃", 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_voice_stream_wave(1, 4080200)
		resume_step = 39
		voice_stream_delay = sound.wait_voice_stream_ready_counting(1)
		event.set_message_button_prompt(0, 0)
		event.open_message_window_2(0, 4080200)
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		resume_step = 40
		wait.frames(vm.i32(30 - voice_stream_delay))
		event.set_camera_sequence_position(-92.53, 6.56, 559.96)
		event.set_camera_sequence_look_at(-39.54, 19.62, 593.16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "大口パク")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -64.66, 4.79, 541.75, 14, 1)
		resume_step = 41
		wait.frames(14)
		message.close(0)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		event.set_camera_sequence_position(-77.13, 11.5, 549.0)
		event.set_camera_sequence_look_at(-117.01, 21.86, 587.27)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "大口")
		event.set_object_sequence_motion(1, "上見びっくり", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		resume_step = 42
		wait.frames(10)
		event.set_camera_sequence_position(-81.01, 33.49, 535.66)
		event.set_camera_sequence_look_at(-86.5, 39.49, 520.89)
		event.play_sound_effect(sound_bank, 8)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "大口")
		event.set_object_sequence_motion(3, "攻撃2", 6)
		event.delay_object_sequence_motion_track(3, 10)
		event.set_object_sequence_motion(3, "攻撃", 1)
		event.set_object_sequence_position(0, -8.54, 2.83, 545.17)
		event.set_object_sequence_rotation(0, 0.0, -1.7, 0.0)
		resume_step = 43
		wait.frames(4)
		event.move_camera_sequence_eased(-81.01, 33.49, 535.66, -67.85, 33.31, 537.58, 12, 0, 0.4)
		resume_step = 44
		wait.frames(3)
		event.set_object_sequence_motion(0, "タックル", 6, -1.0, 1)
		resume_step = 45
		camera.wait_until_done()
		event.set_object_sequence_motion(3, "攻撃3", 6)
		event.move_camera_sequence_eased(-157.5, 18.3, 524.15, -141.51, 23.91, 526.12, 8, 2, 1.0)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 30)
		resume_step = 46
		wait.frames(2)
		if playable_character == 0 then
			event.set_character_active(0, 0)
		else
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
		end
		resume_step = 47
		message.show_voiced_for(4080205, 40)
		resume_step = 48
		camera.wait_until_done()
		event.set_camera_sequence_position(-154.32, 107.18, 768.06)
		event.set_camera_sequence_look_at(-95.44, 20.24, 463.89)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		if playable_character == 0 then
			event.set_character_active(0)
		else
			event.set_character_active(8)
			event.set_character_active(9)
		end
		event.set_character_active(10)
		event.set_object_sequence_position(0, -144.47, 6.3, 567.45)
		event.set_object_sequence_rotation(0, 0.0, 2.02, 0.0)
		event.set_object_sequence_motion(0, "立ちあがる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(2, -168.07, 3.48, 508.64)
		event.set_object_sequence_rotation(2, 0.0, 1.22, 0.0)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "立ちあがる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_position(3, -50.57, -15.41, 428.09)
		event.set_object_sequence_rotation(3, 0.0, -0.36, 0.0)
		event.set_object_sequence_motion(3, "立ち2", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 49
		message.show_voiced(4080210)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -111.4, 3.75, 698.18, 40, 1)
		event.rotate_object_sequence(1, 0.0, 0.14, 0.0, 8)
		resume_step = 50
		wait.frames(2)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -146.03, 4.47, 681.95, 50, 1)
		event.rotate_object_sequence(0, 0.0, 0.1, 0.0, 8)
		resume_step = 51
		wait.frames(8)
		event.set_object_sequence_motion(2, "走り")
		event.move_object_sequence(2, -157.24, 4.74, 682.84, 50, 1)
		event.rotate_object_sequence(2, 0.0, 0.02, 0.0, 8)
		resume_step = 52
		object.wait_until_done(2)
		event.set_camera_sequence_position(-76.59, 45.52, 642.13)
		event.set_camera_sequence_look_at(-76.07, 15.43, 850.71)
		event.fade_out_music(60)
		event.move_object_sequence(1, -85.95, -25.91, 1068.48, 80, 1)
		event.delay_object_sequence_motion_track(1, 80)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_rotation_track(1, 72)
		event.rotate_object_sequence(1, 0.0, 3.02, 0.0, 8)
		event.delay_object_sequence_rotation_track(4, 90)
		event.rotate_object_sequence_eased(4, gate_rotation_x, gate_rotation_y, gate_target_rotation_z, 40, 0, 0.5)
		event.delay_object_sequence_position_track(5, 130)
		event.move_object_sequence_eased(5, gate_original_position_x, gate_original_position_y + 80.0, gate_original_position_z, 32, 1, 0.5)
		event.delay_object_sequence_sound_track(5, 90)
		event.play_object_sequence_sound(5, sound_bank, 9)
		resume_step = 53
		wait.frames(4)
		event.set_object_sequence_position(0, -61.85, 3.51, 650.67)
		event.set_object_sequence_rotation(0, 0.0, -0.1, 0.0)
		event.move_object_sequence(0, -54.15, -4.35, 911.55, 60, 1)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 5)
		event.set_object_sequence_motion(0, "振り向く（右）", 6)
		event.queue_object_sequence_next_motion(0, "振り向く（右）L", 4)
		resume_step = 54
		wait.frames(10)
		event.set_object_sequence_position(2, -87.61, 3.87, 655.48)
		event.set_object_sequence_rotation(2, 0.0, 0.1, 0.0)
		event.move_object_sequence(2, -87.84, 2.52, 774.78, 40, 1)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "振り向く", 2)
		event.queue_object_sequence_next_motion(2, "振り向くL", 4)
		resume_step = 55
		object.wait_until_done(2)
		resume_step = 56
		message.show_voiced(4080220)
		event.set_mouth_texture_animations(0, "大口パク")
		resume_step = 57
		message.show_voiced(4080230)
		resume_step = 58
		object.wait_until_done(5)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 50)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, -19.76, -41.08, 1213.94, 50)
		event.rotate_object_sequence(1, 0.0, 0.26, 0.0, 6)
		event.set_object_sequence_motion(0, "振り向く（右）戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_position_track(0, 18)
		event.move_object_sequence(0, -66.76, -20.35, 1068.29, 40, 1)
		resume_step = 59
		wait.frames(10)
		event.set_object_sequence_motion(2, "振り向く戻り", 6)
		event.queue_object_sequence_next_motion(2, "走り")
		event.delay_object_sequence_position_track(2, 20)
		event.move_object_sequence(2, -82.88, -2.14, 896.69, 40, 1)
		resume_step = 60
		wait.frames(4)
		resume_step = 61
		wait.frames(6)
		event.fade_out_screen(30)
		resume_step = 62
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step == 39 then
			voice_stream_delay = received[1] :: number
		end
		if resume_step <= 2 then
			gate_target_rotation_z = vm.f32(gate_original_rotation_z - vm.f32(3.1415927))
			cutscene.skip_command(1)
		end
		if resume_step <= 3 then
			message.show_voiced_skipping(4080010)
		end
		if resume_step <= 4 then
			message.show_voiced_skipping(4080020)
		end
		if resume_step <= 5 then
			message.show_voiced_skipping(4080030)
		end
		if resume_step <= 6 then
			camera_look_x = -140.0
			camera_look_speed = vm.f32(1.9)
			camera_look_deceleration = vm.f32(-0.044)
			is_voice_opening = 0
			is_voice_ready = 0
			i = 0
			camera_look_x = vm.f32(camera_look_x + camera_look_speed)
			camera_look_speed = vm.f32(camera_look_speed + camera_look_deceleration)
			local _ = is_voice_opening == 1
			is_voice_opening = 0
			is_voice_ready = 1
			local _ = is_voice_ready == 1
			is_voice_ready = 0
			message.open_skipping(0, -1, 8, 0, 0)
			voice_message_id = 4080040
			is_voice_opening = 1
			message.close_skipping(0)
			voice_message_id = 4080045
			is_voice_opening = 1
			local _ = i < 440
			local _ = i < 42
			local _ = i == 0
			local _ = i == 180
			i = i + 1
		end
		if resume_step <= 7 then
			message.close_skipping(0)
			message.show_voiced_skipping(4080050)
		end
		if resume_step <= 8 then
			message.show_voiced_skipping(4080060)
		end
		if resume_step <= 9 then
			message.show_voiced_skipping(4080070)
		end
		if resume_step <= 10 then
			cutscene.skip_command(0)
		end
		if resume_step <= 11 then
			message.show_voiced_skipping(4080080)
		end
		if resume_step <= 12 then
			message.show_voiced_skipping(4080090)
		end
		if resume_step <= 13 then
			cutscene.skip_command(0)
		end
		if resume_step <= 14 then
			wait.frames_skipping(50)
		end
		if resume_step <= 15 then
			cutscene.skip_command(3)
		end
		if resume_step <= 16 then
			wait.frames_skipping(4)
		end
		if resume_step <= 17 then
			wait.background_load_skipping()
		end
		if resume_step <= 18 then
			message.show_voiced_skipping(4080100)
		end
		if resume_step <= 19 then
			message.show_voiced_skipping(4080110)
		end
		if resume_step <= 20 then
			wait.frames_skipping(10)
		end
		if resume_step <= 21 then
			cutscene.skip_command(0)
		end
		if resume_step <= 22 then
			cutscene.skip_command(3)
		end
		if resume_step <= 23 then
			message.show_voiced_skipping(4080120)
		end
		if resume_step <= 24 then
			cutscene.skip_command(0)
		end
		if resume_step <= 25 then
			message.show_voiced_skipping(4080130)
		end
		if resume_step <= 26 then
			message.show_voiced_skipping(4080140)
		end
		if resume_step <= 27 then
			message.show_voiced_skipping(4080150)
		end
		if resume_step <= 28 then
			wait.frames_skipping(90)
		end
		if resume_step <= 29 then
			wait.frames_skipping(10)
		end
		if resume_step <= 30 then
			message.show_voiced_for_skipping(4080160, 50)
		end
		if resume_step <= 31 then
			cutscene.skip_command(2)
		end
		if resume_step <= 32 then
			message.show_voiced_skipping(4080170)
		end
		if resume_step <= 33 then
			cutscene.skip_command(2)
		end
		if resume_step <= 34 then
			message.show_voiced_skipping(4080180)
		end
		if resume_step <= 35 then
			message.show_voiced_skipping(4080185)
		end
		if resume_step <= 36 then
			wait.frames_skipping(10)
		end
		if resume_step <= 37 then
			message.show_voiced_then_hold_skipping(4080190, -1, 0)
		end
		if resume_step <= 38 then
			voice_stream_delay = sound.wait_voice_stream_ready_counting_skipping(1)
		end
		if resume_step <= 39 then
			message.open_skipping(0, -1, 8, 0, 0)
			wait.frames_skipping(vm.i32(30 - voice_stream_delay))
		end
		if resume_step <= 40 then
			wait.frames_skipping(14)
		end
		if resume_step <= 41 then
			message.close_skipping(0)
			wait.frames_skipping(10)
		end
		if resume_step <= 42 then
			wait.frames_skipping(4)
		end
		if resume_step <= 43 then
			wait.frames_skipping(3)
		end
		if resume_step <= 44 then
			wait.background_load_skipping()
		end
		if resume_step <= 45 then
			wait.frames_skipping(2)
		end
		if resume_step <= 46 then
			message.show_voiced_for_skipping(4080205, 40)
		end
		if resume_step <= 47 then
			wait.background_load_skipping()
		end
		if resume_step <= 48 then
			message.show_voiced_skipping(4080210)
		end
		if resume_step <= 49 then
			wait.frames_skipping(2)
		end
		if resume_step <= 50 then
			wait.frames_skipping(8)
		end
		if resume_step <= 51 then
			cutscene.skip_command(2)
		end
		if resume_step <= 52 then
			wait.frames_skipping(4)
		end
		if resume_step <= 53 then
			wait.frames_skipping(10)
		end
		if resume_step <= 54 then
			cutscene.skip_command(2)
		end
		if resume_step <= 55 then
			message.show_voiced_skipping(4080220)
		end
		if resume_step <= 56 then
			message.show_voiced_skipping(4080230)
		end
		if resume_step <= 57 then
			cutscene.skip_command(5)
		end
		if resume_step <= 58 then
			wait.frames_skipping(10)
		end
		if resume_step <= 59 then
			wait.frames_skipping(4)
		end
		if resume_step <= 60 then
			wait.frames_skipping(6)
		end
		if resume_step <= 61 then
			wait.frames_skipping(30)
		end
		return true
	end)
	resume_step = 63
	vm.entry(63)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 2)
	event.stop_sound_effect(sound_bank, 5)
	event.stop_sound_effect(sound_bank, 6)
	event.stop_sound_effect(sound_bank, 8)
	event.stop_sound_effect(sound_bank, 9)
	event.stop_sound_effect(sound_bank, 11)
	event.stop_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_rotation(4, gate_original_rotation_x, gate_original_rotation_y, gate_original_rotation_z)
	event.set_object_handle_position(5, gate_original_position_x, gate_original_position_y, gate_original_position_z)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(6, 1)
	event.set_object_handle_visible(7, 1)
	event.skip_next_music_load()
	event.finish_event()
end

--- Shows or hides the s19_02-a0 map part.
function cave_of_ancient_murals.set_map_part_visible(visible: s32)
	event.initialize_event()
	vm.wait(1)
	event.attach_object_handle_to_map_part_3(0, "p01_s19", "s19_02-a0")
	event.set_object_handle_visible(0, visible)
	event.finish_event()
end

return cave_of_ancient_murals
