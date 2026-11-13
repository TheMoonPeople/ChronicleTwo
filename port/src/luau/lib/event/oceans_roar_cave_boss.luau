--!strict
--- Holds the cutscenes and monster setup of the Ocean's Roar Cave boss room.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local oceans_roar_cave_boss = {}

--- Asks a yes or no question and returns 1 after fading out when confirmed, otherwise finishes the event and returns 0.
function oceans_roar_cave_boss.confirm_exit()
	local answer: any = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		step = 1
		answer = message.ask_yes_no(2, -1)
		if answer == 0 then
			event.fade_out_screen(30)
			step = 2
			wait.frames(30)
			return 1
		else
			event.finish_event()
			return 0
		end
	end, function(received: { any })
		if step <= 2 then
			if step == 1 then
				answer = received[1] :: number
			end
			if step <= 1 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Loads and positions the adult and child townspeople as map parts unless the story flag is already set.
function oceans_roar_cave_boss.place_townspeople()
	local story_flag: s32 = 0
	story_flag = event.get_save_flag(438) or story_flag
	if story_flag == 0 then
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/e400/e434/e434_baru.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_position(8, -282.29, 0.0, 1465.71)
		event.set_character_rotation(8, 0.0, 2.3, 0.0)
		event.attach_object_handle_to_map_part_2(0, "p01_otona")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, -282.29, -7.95, 1465.71)
		event.set_object_handle_rotation(0, 0.0, 2.3, 0.0)
		event.load_character(4, "event/e400/d04b01/p02_12a.gltf", "info", 9)
		event.set_character_active(9)
		event.set_character_position(9, 982.95, 0.0, 809.77)
		event.set_character_rotation(9, 0.0, 2.64, 0.0)
		event.attach_object_handle_to_map_part_2(0, "p01_otona-1")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, 982.95, 0.0, 809.77)
		event.set_object_handle_rotation(0, 0.0, 2.64, 0.0)
		event.copy_character(4, 9, 10)
		event.set_character_active(10)
		event.set_character_position(10, -336.11, 0.0, 942.76)
		event.set_character_rotation(10, 0.0, 1.68, 0.0)
		event.attach_object_handle_to_map_part_2(0, "p01_otona-2")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, -336.11, 0.0, 942.76)
		event.set_object_handle_rotation(0, 0.0, 1.68, 0.0)
		event.copy_character(4, 9, 11)
		event.set_character_active(11)
		event.set_character_position(11, 74.96, 0.0, -129.91)
		event.set_character_rotation(11, 0.0, 0.48, 0.0)
		event.attach_object_handle_to_map_part_2(0, "p01_otona-3")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, 74.96, 0.0, -129.91)
		event.set_object_handle_rotation(0, 0.0, 0.48, 0.0)
		event.copy_character(4, 9, 12)
		event.set_character_active(12)
		event.set_character_position(12, 568.34, 0.0, -353.26)
		event.set_character_rotation(12, 0.0, -0.24, 0.0)
		event.attach_object_handle_to_map_part_2(0, "p01_otona-4")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, 568.34, 0.0, -353.26)
		event.set_object_handle_rotation(0, 0.0, -0.24, 0.0)
		event.load_character(4, "event/e400/d04b01/p02_13a.gltf", "info", 13)
		event.set_character_active(13)
		event.set_character_position(13, 195.46, 0.0, 559.67)
		event.set_character_rotation(13, 0.0, -2.92, 0.0)
		event.attach_object_handle_to_map_part_2(0, "p01_kodomo")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, 195.46, 0.0, 559.67)
		event.set_object_handle_rotation(0, 0.0, -2.92, 0.0)
		event.copy_character(4, 13, 14)
		event.set_character_active(14)
		event.set_character_position(14, -20.41, 0.0, 350.29)
		event.set_character_rotation(14, 0.0, 1.04, 0.0)
		event.attach_object_handle_to_map_part_2(0, "p01_kodomo-1")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, -20.41, 0.0, 350.29)
		event.set_object_handle_rotation(0, 0.0, 1.04, 0.0)
		event.copy_character(4, 13, 15)
		event.set_character_active(15)
		event.set_character_position(15, 861.76, 0.0, -107.49)
		event.set_character_rotation(15, 0.0, -1.48, 0.0)
		event.attach_object_handle_to_map_part_2(0, "p01_kodomo-2")
		event.set_object_handle_visible(0, 1)
		event.set_object_handle_position(0, 861.76, 0.0, -107.49)
		event.set_object_handle_rotation(0, 0.0, -1.48, 0.0)
	end
end

--- Plays the skippable pre-boss cutscene in which the playable character (Mints or Monica) confronts the performing monster trio, then restores the dungeon status bar.
function oceans_roar_cave_boss.play_boss_introduction_scene()
	local playable_character: s32 = 0
	local sound_effect_bank: s32 = 0
	local telop_texture_block: s32 = 0
	local vertical_speed: f32 = 0
	local vertical_acceleration: f32 = 0
	local i: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local step: number = 0
	vm.section(function()
		event.set_save_flag(440, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.stop_music(0)
		step = 1
		wait.frames(4)
		event.load_music(34)
		event.load_map_sounds(4826)
		sound_effect_bank = event.load_sound_effect_file_2(4826) or sound_effect_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e440/")
		event.load_message_file(0, 5, "e440_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e440_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e440_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e440_jamming.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e440_sourcer.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e440_seagura.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.copy_character(5, 12, 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.copy_character(5, 12, 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(6, 14)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.copy_character(5, 12, 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(7, 15)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		telop_texture_block = event.load_event_image_4(5, "e440telop01_1.json", 0) or telop_texture_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e440telop01", telop_texture_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 292)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 10)
		event.change_directory("")
		event.load_character(5, "event/e400/e440/mariometto_a.gltf", "info", 16)
		event.set_character_active(16)
		event.attach_character_to_frame(12, "mettoa_null", 16)
		event.copy_character(5, 16, 17)
		event.set_character_active(17)
		event.attach_character_to_frame(13, "mettoa_null", 17)
		event.copy_character(5, 16, 18)
		event.set_character_active(18)
		event.attach_character_to_frame(14, "mettoa_null", 18)
		event.copy_character(5, 16, 19)
		event.set_character_active(19)
		event.attach_character_to_frame(15, "mettoa_null", 19)
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e440/e440_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e400/e440/e440_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(8, 1)
		event.attach_object_handle_to_character(9, 2)
		event.set_object_handle_visible(8, 0)
		event.set_object_handle_visible(9, 0)
		event.set_object_handle_position(0, 682.0, 0.0, 189.0)
		event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "大口")
		event.set_object_handle_position(1, 700.0, 0.0, 200.0)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 1381.99, 900.0, 2158.32)
		event.set_object_handle_rotation(2, 0.0, 3.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_sound_bank(2, sound_effect_bank)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_position(3, 1381.99, 900.0, 2158.32)
		event.set_object_handle_rotation(3, 0.0, 2.04, 0.0)
		event.set_object_handle_position(4, 132.83, 0.0, -305.18)
		event.set_object_handle_rotation(4, 0.0, 0.72, 0.0)
		event.set_object_handle_motion(4, "立ち", 4)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "目赤")
		event.set_object_handle_position(5, -456.48, 0.0, 1086.61)
		event.set_object_handle_rotation(5, 0.0, 2.28, 0.0)
		event.set_object_handle_motion(5, "立ち", 4)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "目赤")
		event.set_object_handle_position(6, 1347.63, 0.0, 856.01)
		event.set_object_handle_rotation(6, 0.0, -2.28, 0.0)
		event.set_object_handle_motion(6, "立ち", 4)
		event.set_object_handle_texture_animation(6, 0)
		event.set_object_handle_texture_animation(6, 1, "目赤")
		event.set_object_handle_position(7, 894.8, 0.0, -315.53)
		event.set_object_handle_rotation(7, 0.0, -0.72, 0.0)
		event.set_object_handle_motion(7, "立ち", 4)
		event.set_object_handle_texture_animation(7, 0)
		event.set_object_handle_texture_animation(7, 1, "目赤")
		event.enable_drama_skip()
		event.play_sound_effect(sound_effect_bank, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1793.56, 223.9, 283.1)
		event.set_camera_sequence_look_at(1848.03, 252.49, 433.57)
		event.move_camera_sequence_eased(1793.56, 403.69, 283.1, 1848.03, 478.81, 433.57, 90, 2, 1.0)
		event.fade_in_screen(30)
		step = 2
		camera.wait_until_done()
		event.set_camera_sequence_position(488.77, 606.28, -354.72)
		event.set_camera_sequence_look_at(488.77, 429.77, -146.44)
		event.move_object_sequence(0, 482.0, 0.0, 189.0, 60)
		event.set_object_sequence_motion(0, "走り", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, 486.99, 0.0, 202.8, 64)
		event.set_object_sequence_motion(1, "走り", 4)
		event.delay_object_sequence_motion_track(1, 64)
		event.set_object_sequence_motion(1, "立ち")
		step = 3
		object.wait_until_done(1)
		event.play_sound_effect(sound_effect_bank, 1)
		event.move_object_sequence(4, 267.78, 0.0, -96.39, 210)
		event.set_object_sequence_motion(4, "歩き", 0)
		event.delay_object_sequence_motion_track(4, 210)
		event.set_object_sequence_motion(4, "立ち")
		event.move_object_sequence(5, 171.77, 0.0, 463.88, 230)
		event.set_object_sequence_motion(5, "歩き", 0, 0.48)
		event.delay_object_sequence_motion_track(5, 230)
		event.set_object_sequence_motion(5, "立ち")
		event.move_object_sequence(6, 773.64, 0.0, 443.16, 220)
		event.set_object_sequence_motion(6, "歩き", 0, 0.48)
		event.delay_object_sequence_motion_track(6, 220)
		event.set_object_sequence_motion(6, "立ち")
		event.move_object_sequence(7, 711.27, 0.0, -99.08, 202)
		event.set_object_sequence_motion(7, "歩き", 0)
		event.delay_object_sequence_motion_track(7, 202)
		event.set_object_sequence_motion(7, "立ち")
		step = 4
		wait.frames(160)
		event.set_camera_sequence_position(433.73, 10.85, 194.55)
		event.set_camera_sequence_look_at(494.45, 22.5, 195.7)
		event.set_object_sequence_motion(0, "あとずさり", 6)
		event.queue_object_sequence_next_motion(0, "あとずさりL", 4)
		event.set_object_sequence_motion(1, "のけぞり", 6)
		event.queue_object_sequence_next_motion(1, "のけぞりL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 5
		message.show_voiced(4400010)
		step = 6
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "指さす", 2)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_effect_bank, 2)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 7
		message.show_voiced(4400020)
		step = 8
		object.wait_until_done(0)
		step = 9
		object.wait_until_done(5)
		event.set_camera_sequence_position(482.22, 295.97, 32.59)
		event.set_camera_sequence_look_at(358.04, 280.12, 4.29)
		event.play_sound_effect(sound_effect_bank, 3)
		step = 10
		message.show_voiced(4400025)
		event.stop_sound_effect(sound_effect_bank, 3)
		event.set_camera_sequence_position(426.29, 336.99, 1022.57)
		event.set_camera_sequence_look_at(446.51, 249.73, 695.36)
		event.play_music(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 11
		message.show_voiced(4400030)
		event.set_camera_sequence_position(466.23, 33.98, 224.28)
		event.set_camera_sequence_look_at(486.89, 17.34, 191.61)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "口とじ～大口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_motion(0, "左上を見る", 6)
		event.queue_object_sequence_next_motion(0, "左上を見るL", 4)
		event.set_object_sequence_motion(1, "左上", 6)
		event.queue_object_sequence_next_motion(1, "左上L", 4)
		step = 12
		message.show_voiced(4400040)
		step = 13
		object.wait_until_done(0)
		event.set_camera_sequence_position(468.1, 89.63, 136.48)
		event.set_camera_sequence_look_at(619.55, 292.69, 882.71)
		event.move_camera_sequence_eased(604.45, 261.89, 808.35, 619.55, 286.12, 882.71, 90, 0, 1.0)
		event.play_sound_effect(sound_effect_bank, 4)
		event.set_object_sequence_position(0, 474.35, 0.0, 208.29)
		event.set_object_sequence_rotation(0, 0.0, 0.5, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(1, 486.05, 0.0, 198.18)
		event.set_object_sequence_rotation(1, 0.0, 0.23, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "演奏1", 4)
		event.move_object_sequence_eased(2, 600.0, 900.0, 850.0, 60, 2, 0.5)
		event.move_object_sequence_eased(3, 600.0, 900.0, 850.0, 60, 2, 0.5)
		vertical_speed = 0.0
		vertical_acceleration = vm.f32(-0.35)
		i = 0
		while i < 70 do
			do
				local out1, out2, out3 = event.get_object_handle_position(2)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			y = vm.f32(y + vertical_speed)
			if i < 50 then
				vertical_speed = vm.f32(vertical_speed + vertical_acceleration)
			else
				vertical_speed = vm.f32(vertical_speed - vm.f32(vertical_acceleration * vm.f32(2.2)))
			end
			event.set_object_handle_position(2, x, y, z)
			event.set_object_handle_position(3, x, y, z)
			i = i + 1
			step = 14
			vm.wait(14)
		end
		event.play_sound_effect(sound_effect_bank, 5)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(8, 128, 128, 128, 128, 30)
		event.delay_object_sequence_motion_track(2, 60)
		event.queue_object_sequence_next_motion(2, "演奏2", 6)
		event.queue_object_sequence_next_motion(2, "演奏1", 4)
		step = 15
		message.show_voiced(4400045)
		step = 16
		object.wait_until_done(2)
		step = 17
		camera.wait_until_done()
		event.set_event_sprite_draw_pass(0, 0)
		event.set_camera_sequence_position(520.65, 18.19, 210.67)
		event.set_camera_sequence_look_at(478.14, 21.46, 206.21)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 18
		message.show_voiced(4400050)
		event.set_camera_sequence_position(640.97, 288.67, 848.2)
		event.set_camera_sequence_look_at(617.43, 290.99, 881.13)
		event.play_sound_effect(sound_effect_bank, 6)
		event.set_object_sequence_motion(2, "耳に手in", 6)
		event.wait_object_sequence_motion_end(2)
		step = 19
		object.wait_until_done(2)
		event.move_camera_sequence_angle_height_distance_eased(-2.74, -19.32, 54.92, 90, 0, 1.0)
		event.set_mouth_motions(2, "耳に手（会話）", 4, "耳に手", 0)
		step = 20
		message.show_voiced(4400060)
		event.set_object_sequence_motion(2, "ギャーンin", 2)
		event.wait_object_sequence_motion_end(2)
		step = 21
		wait.frames(2)
		event.play_sound_effect(sound_effect_bank, 7)
		step = 22
		object.wait_until_done(2)
		event.set_mouth_motions(2, "ギャーン（会話）", 4, "ギャーン", 0)
		step = 23
		message.show_voiced(4400063)
		step = 24
		camera.wait_until_done()
		event.set_object_sequence_motion(2, "笑うin", 2)
		event.queue_object_sequence_next_motion(2, "笑う", 4)
		step = 25
		message.show_voiced(4400066)
		step = 26
		object.wait_until_done(2)
		event.set_camera_sequence_position(493.73, 43.46, 227.63)
		event.set_camera_sequence_look_at(488.06, 20.7, 202.27)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(sound_effect_bank, 8)
		event.set_object_sequence_motion(1, "半歩前", 6)
		event.queue_object_sequence_next_motion(1, "半歩前L", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		step = 27
		message.show_voiced(4400070)
		step = 28
		object.wait_until_done(1)
		event.set_camera_sequence_position(615.36, 287.58, 855.01)
		event.set_camera_sequence_look_at(619.05, 292.49, 877.81)
		event.set_object_sequence_motion(2, "会話（演奏）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（演奏）", 4)
		step = 29
		message.show_voiced(4400080)
		step = 30
		message.show_voiced(4400083)
		event.move_camera_sequence_eased(482.56, 23.28, 34.42, 619.05, 121.85, 877.81, 60, 0, 1.0)
		step = 31
		camera.wait_until_done()
		event.fade_out_screen(30)
		step = 32
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 1 then
			wait.background_load_skipping()
		end
		if step <= 2 then
			cutscene.skip_command(1)
		end
		if step <= 3 then
			wait.frames_skipping(160)
		end
		if step <= 4 then
			message.show_voiced_skipping(4400010)
		end
		if step <= 5 then
			cutscene.skip_command(1)
		end
		if step <= 6 then
			message.show_voiced_skipping(4400020)
		end
		if step <= 7 then
			cutscene.skip_command(0)
		end
		if step <= 8 then
			cutscene.skip_command(5)
		end
		if step <= 9 then
			message.show_voiced_skipping(4400025)
		end
		if step <= 10 then
			message.show_voiced_skipping(4400030)
		end
		if step <= 11 then
			message.show_voiced_skipping(4400040)
		end
		if step <= 12 then
			cutscene.skip_command(0)
		end
		if step <= 13 then
			vertical_speed = 0.0
			vertical_acceleration = vm.f32(-0.35)
			i = 0
			y = vm.f32(y + vertical_speed)
			vertical_speed = vm.f32(vertical_speed + vertical_acceleration)
			vertical_speed = vm.f32(vertical_speed - vm.f32(vertical_acceleration * vm.f32(2.2)))
			local _ = i < 70
			local _ = i < 50
			i = i + 1
		end
		if step <= 14 then
			message.show_voiced_skipping(4400045)
		end
		if step <= 15 then
			cutscene.skip_command(2)
		end
		if step <= 16 then
			wait.background_load_skipping()
		end
		if step <= 17 then
			message.show_voiced_skipping(4400050)
		end
		if step <= 18 then
			cutscene.skip_command(2)
		end
		if step <= 19 then
			message.show_voiced_skipping(4400060)
		end
		if step <= 20 then
			wait.frames_skipping(2)
		end
		if step <= 21 then
			cutscene.skip_command(2)
		end
		if step <= 22 then
			message.show_voiced_skipping(4400063)
		end
		if step <= 23 then
			wait.background_load_skipping()
		end
		if step <= 24 then
			message.show_voiced_skipping(4400066)
		end
		if step <= 25 then
			cutscene.skip_command(2)
		end
		if step <= 26 then
			message.show_voiced_skipping(4400070)
		end
		if step <= 27 then
			cutscene.skip_command(1)
		end
		if step <= 28 then
			message.show_voiced_skipping(4400080)
		end
		if step <= 29 then
			message.show_voiced_skipping(4400083)
		end
		if step <= 30 then
			wait.background_load_skipping()
		end
		if step <= 31 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect_bank, 0)
	event.stop_sound_effect(sound_effect_bank, 3)
	event.stop_sound_effect(sound_effect_bank, 4)
	event.set_event_sprite_draw_pass(0, 0)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.load_message_file(0, -1)
	event.delete_event_image(0)
	event.clear_camera_sequence()
end

--- Plays a short skippable dialogue scene of the heroes reacting dejectedly at the given townsperson's position, then finishes the event.
function oceans_roar_cave_boss.play_dejected_scene(townsperson: s32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local rotation_y: f32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(15)
		wait.frames(15)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		do
			local out1, out2, out3 = event.get_character_position(townsperson)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local _, out2, _ = event.get_character_rotation(townsperson)
			rotation_y = out2 or rotation_y
		end
		event.set_event_world_coordinate(x, y, z, rotation_y)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e436/")
		event.load_message_file(0, 5, "e436_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e436_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e436_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 16)
			event.load_equipment_model(5, 0, 4, "info", 16)
			event.load_equipment_model(5, 0, 3, "info", 16)
			event.load_equipment_model(5, 0, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e436/e436_mints.gltf", "info", 16)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 16)
			event.attach_object_handle_to_character(0, 16)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 16)
			event.load_equipment_model(5, 1, 4, "info", 16)
			event.load_equipment_model(5, 1, 3, "info", 16)
			event.load_equipment_model(5, 1, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e436/e436_monica.gltf", "info", 16)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 16)
			event.attach_object_handle_to_character(1, 16)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(16)
		event.set_character_active(17)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -8.0, 0.0, 180.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.step_object_handle_motion(0)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_position(1, 8.0, 0.0, 180.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_footstep_sound(1, 14)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 30.0, 280.0)
		event.set_camera_sequence_look_at(0.0, 30.0, 100.0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "がっくり", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		message.show_voiced(4360030)
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		message.show_voiced(4360035)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(16)
	event.delete_character(17)
	event.load_message_file(0, -1)
	if playable_character == 0 then
		event.set_object_sequence_position(0, 0.0, 0.0, 180.0)
	else
		event.set_object_sequence_position(1, 0.0, 0.0, 180.0)
	end
	event.set_camera_sequence_position(0.0, 30.0, 280.0)
	event.set_camera_sequence_look_at(0.0, 30.0, 180.0)
	vm.wait(7)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays event 432, the party entering the boss room, looking around and shrugging.
function oceans_roar_cave_boss.play_event_432()
	local playable_character: s32 = 0
	local event_sound_bank: s32 = 0
	local door_sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(432, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.stop_music(0)
		wait.frames(4)
		event.load_music(3)
		event.load_map_sounds(4814)
		door_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_041.sound.json") or door_sound_bank
		event_sound_bank = event.load_sound_effect_file_2(4814) or event_sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e432/")
		event.load_message_file(0, 5, "e432_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e432_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e432_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 16)
			event.load_equipment_model(5, 0, 4, "info", 16)
			event.load_equipment_model(5, 0, 3, "info", 16)
			event.load_equipment_model(5, 0, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e432/e432_mints.gltf", "info", 16)
			event.attach_object_handle_to_character(0, 16)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 16)
			event.load_equipment_model(5, 1, 4, "info", 16)
			event.load_equipment_model(5, 1, 3, "info", 16)
			event.load_equipment_model(5, 1, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e432/e432_monica.gltf", "info", 16)
			event.attach_object_handle_to_character(1, 16)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(16)
		event.set_character_active(17)
		event.attach_object_handle_to_map_part_2(2, "p02_d04b01")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_2(3, "p03_d04b01")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, 2030.0, 0.0, -740.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 2046.0, 0.0, -740.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.rotate_object_sequence_eased(2, 0.0, 0.0, 3.14, 40, 0, 0.5)
		event.delay_object_sequence_rotation_track(2, 168)
		event.rotate_object_sequence_eased(2, 0.0, 0.0, 0.0, 40, 0, 0.5)
		event.play_object_sequence_sound(2, door_sound_bank, 0)
		event.delay_object_sequence_sound_track(2, 170)
		event.play_object_sequence_sound(2, door_sound_bank, 1)
		event.delay_object_sequence_position_track(3, 80)
		event.move_object_sequence_eased(3, 0.0, 80.0, 0.0, 32, 1, 0.5)
		event.delay_object_sequence_position_track(3, 40)
		event.move_object_sequence_eased(3, 0.0, 0.0, 0.0, 32, 2, 0.5)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2198.81, 99.4, -537.94)
		event.set_camera_sequence_look_at(2056.98, 54.61, -679.8)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		wait.frames(110)
		event.move_object_sequence(0, 2030.0, 0.0, -680.0, 60)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		wait.frames(10)
		event.move_object_sequence(1, 2046.0, 0.0, -680.0, 60)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(1)
		event.set_camera_sequence_position(2061.53, 10.96, -648.18)
		event.set_camera_sequence_look_at(2030.82, 23.87, -686.56)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(0, 1, "口とじ～口あけ")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4320010)
		event.set_camera_sequence_position(1924.65, 64.05, 196.6)
		event.set_camera_sequence_look_at(1932.83, 64.94, 223.63)
		event.move_camera_sequence_eased(1924.65, 64.05, 196.6, 1904.25, 64.94, 216.36, 90, 0, 0.4)
		event.play_music(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4320015)
		camera.wait_until_done()
		event.set_camera_sequence_position(1800.0, 39.0, 176.0)
		event.set_camera_sequence_look_at(1800.0, 22.0, 260.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(0, 1794.0, 0.0, 200.0)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.move_object_sequence(0, 1794.0, 0.0, 260.0, 20)
		event.set_object_sequence_motion(0, "走り", 4)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_position(1, 1808.0, 0.0, 190.0)
		event.move_object_sequence(1, 1808.0, 0.0, 260.0, 24)
		event.set_object_sequence_motion(1, "走り", 4)
		event.delay_object_sequence_motion_track(1, 24)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(1)
		event.move_camera_sequence_angle_height_distance_eased(0.9, -10.0, 38.0, 40, 0, 1.0)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4320020)
		camera.wait_until_done()
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4320030)
		object.wait_until_done(0)
		event.play_sound_effect(event_sound_bank, 0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_motion(1, "さぁ？", 6)
		event.queue_object_sequence_next_motion(1, "さぁ？L", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4320040)
		object.wait_until_done(1)
		event.set_camera_sequence_position(1785.99, 22.09, 263.93)
		event.set_camera_sequence_look_at(1808.23, 23.58, 259.85)
		if playable_character == 0 then
			event.set_character_active(0, 0)
		else
			event.set_character_active(0, 16)
			event.set_character_active(0, 17)
		end
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "目とじ～目あき")
		event.set_object_sequence_motion(1, "こぶし", 6)
		event.queue_object_sequence_next_motion(1, "こぶしL", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, event_sound_bank, 1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		message.show_voiced(4320045)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(door_sound_bank, 0)
	event.stop_sound_effect(door_sound_bank, 1)
	event.play_music(0)
	event.set_character_active(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_position(3, 0.0, 0.0, 0.0)
	event.delete_character_extension_packs(0)
	event.delete_character(16)
	event.delete_character(17)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(vm.f32(1779.8), 0.0, 354.5, vm.f32(-0.96))
	event.set_camera_position(1878.94, 40.0, 285.33)
	event.set_camera_look_at(1779.8, 30.0, 354.5)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays event 434, the party putting translation devices to their ears and receiving the dragon elixir.
function oceans_roar_cave_boss.play_event_434()
	local character_slot: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local rotation_y: f32 = 0
	local playable_character: s32 = 0
	local active_music_number: s32 = 0
	local event_sound_bank: s32 = 0
	local step: number = 0
	vm.section(function()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(15)
		step = 1
		wait.frames(15)
		event.set_save_flag(434, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		character_slot = 8
		do
			local out1, out2, out3 = event.get_character_position(character_slot)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		do
			local _, out2, _ = event.get_character_rotation(character_slot)
			rotation_y = out2 or rotation_y
		end
		event.set_event_world_coordinate(x, y, z, rotation_y)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		active_music_number = event.get_active_music_number() or active_music_number
		if active_music_number ~= 3 then
			event.stop_music(0)
			step = 2
			wait.frames(4)
			event.load_music(3)
			event.play_music(0)
		end
		event.load_map_sounds(4817)
		event_sound_bank = event.load_sound_effect_file_2(4817) or event_sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e434/")
		event.load_message_file(0, 5, "e434_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e434_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e434_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.attach_object_handle_to_character(2, 8)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e434_honyaku_Y.gltf", "info", 18)
		event.set_character_active(18)
		event.load_character(5, "e434_honyaku_M.gltf", "info", 19)
		event.set_character_active(19)
		event.load_character(5, "e434_hiyaku.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 16)
			event.load_equipment_model(5, 0, 4, "info", 16)
			event.load_equipment_model(5, 0, 3, "info", 16)
			event.load_equipment_model(5, 0, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e434/e434_mints.gltf", "info", 16)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 16)
			event.attach_object_handle_to_character(0, 16)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 16)
			event.load_equipment_model(5, 1, 4, "info", 16)
			event.load_equipment_model(5, 1, 3, "info", 16)
			event.load_equipment_model(5, 1, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e434/e434_monica.gltf", "info", 16)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 16)
			event.attach_object_handle_to_character(1, 16)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(16)
		event.set_character_active(17)
		event.attach_object_handle_to_character(3, 1)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_visible(4, 0)
		if playable_character == 0 then
			event.attach_character_to_frame(0, "item", 18)
			event.attach_character_to_frame(0, "item", 20)
			event.attach_character_to_frame(16, "item", 19)
		else
			event.attach_character_to_frame(0, "item", 19)
			event.attach_character_to_frame(16, "item", 18)
			event.attach_character_to_frame(16, "item", 20)
		end
		event.set_object_handle_position(0, 8.0, 0.0, 310.0)
		event.set_object_handle_rotation(0, 0.0, -2.9, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -8.0, 0.0, 310.0)
		event.set_object_handle_rotation(1, 0.0, 2.9, 0.0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_motion(2, "立ち（下見）", 4)
		event.set_object_sequence_motion(0, "耳に当てる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "耳に当てるL", 4)
		event.set_object_sequence_motion(1, "耳に当てる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "耳に当てるL", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 22.0, 360.0)
		event.set_camera_sequence_look_at(0.0, 22.0, 236.0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		step = 3
		wait.frames(10)
		event.play_sound_effect(event_sound_bank, 0)
		step = 4
		object.wait_until_done(1)
		step = 5
		wait.frames(10)
		event.move_camera_sequence_eased(0.0, 130.0, 700.0, 0.0, 130.0, 100.0, 60, 0, 1.0)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		step = 6
		message.show_voiced(4340010)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		step = 7
		message.show_voiced(4340015)
		step = 8
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 51.02, 278.53)
		event.set_camera_sequence_look_at(0.0, 17.44, 308.64)
		event.set_object_sequence_motion(0, "耳に当てる会話", 6)
		event.queue_object_sequence_next_motion(0, "耳に当てるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 9
		message.show_voiced(4340020)
		step = 10
		object.wait_until_done(0)
		event.set_camera_sequence_position(136.58, 282.08, 250.29)
		event.set_camera_sequence_look_at(103.01, 274.65, 222.02)
		event.set_object_sequence_motion(2, "立ち（下見）", 4)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		step = 11
		message.show_voiced(4340030)
		event.set_camera_sequence_position(532.81, 223.49, 220.44)
		event.set_camera_sequence_look_at(84.67, 164.89, 164.57)
		event.set_object_sequence_motion(0, "耳に当てる会話", 6)
		event.queue_object_sequence_next_motion(0, "耳に当てるL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 12
		message.show_voiced(4340040)
		step = 13
		object.wait_until_done(0)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 14
		message.show_voiced(4340045)
		event.set_camera_sequence_position(136.58, 282.08, 250.29)
		event.set_camera_sequence_look_at(103.01, 274.65, 222.02)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "こまり顔")
		event.set_object_handle_texture_animation(0, 1, "こまり目パチ")
		event.set_object_sequence_motion(2, "立ち（下見）", 4)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		step = 15
		message.show_voiced(4340050)
		event.set_camera_sequence_position(0.0, 51.02, 278.53)
		event.set_camera_sequence_look_at(0.0, 17.44, 308.64)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 16
		message.show_voiced(4340060)
		event.set_camera_sequence_position(136.58, 282.08, 250.29)
		event.set_camera_sequence_look_at(103.01, 274.65, 222.02)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(2, "首ふる", 6)
		event.queue_object_sequence_next_motion(2, "首ふるL", 4)
		step = 17
		message.show_voiced(4340070)
		step = 18
		object.wait_until_done(2)
		event.queue_object_sequence_next_motion(2, "首ふる戻り", 6)
		event.queue_object_sequence_next_motion(2, "会話入り", 4)
		event.queue_object_sequence_next_motion(2, "立ち（下見）", 4)
		step = 19
		object.wait_until_done(2)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		step = 20
		message.show_voiced(4340075)
		event.set_object_sequence_motion(2, "会話戻り", 2)
		event.queue_object_sequence_next_motion(2, "首後ろにやる", 2)
		event.wait_object_sequence_motion_end(2)
		step = 21
		wait.frames(50)
		event.play_sound_effect(event_sound_bank, 1)
		step = 22
		object.wait_until_done(2)
		event.set_camera_sequence_position(63.79, 24.14, 233.74)
		event.set_camera_sequence_look_at(6.92, 16.71, 285.79)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(20)
		event.set_character_active(0, 19)
		event.set_character_active(0, 18)
		event.play_sound_effect(event_sound_bank, 2)
		event.set_object_sequence_motion(2, "竜の秘薬を渡す2", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "竜の秘薬ゲット", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "秘薬見る", 4, -1.0, 1)
		step = 23
		wait.frames(30)
		step = 24
		inventory.show_obtained_message_for_item_id(375, 1)
		event.set_camera_sequence_position(258.67, 378.76, -28.84)
		event.set_camera_sequence_look_at(79.78, 245.69, 90.44)
		event.set_object_sequence_motion(2, "立ち（下見）", 4)
		event.set_object_sequence_motion(0, "上見る", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		step = 25
		wait.frames(4)
		event.set_mouth_motions(2, "会話L", 0, "立ち（下見）", 0)
		step = 26
		message.show_voiced(4340080)
		event.set_mouth_texture_animations(0, "わらい口パク")
		step = 27
		message.show_voiced(4340090)
		event.set_object_sequence_motion(1, "上から右", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 28
		message.show_voiced(4340100)
		event.set_object_sequence_motion(0, "モニカ見る", 6)
		event.queue_object_sequence_next_motion(0, "モニカ見うなづく", 6)
		event.set_mouth_texture_animations(0, "わらい口パク")
		step = 29
		message.show_voiced(4340110)
		event.fade_out_screen(30)
		step = 30
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 1 then
			character_slot = 8
			wait.frames_skipping(4)
		end
		if step <= 2 then
			wait.frames_skipping(10)
		end
		if step <= 3 then
			cutscene.skip_command(1)
		end
		if step <= 4 then
			wait.frames_skipping(10)
		end
		if step <= 5 then
			message.show_voiced_skipping(4340010)
		end
		if step <= 6 then
			message.show_voiced_skipping(4340015)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		if step <= 8 then
			message.show_voiced_skipping(4340020)
		end
		if step <= 9 then
			cutscene.skip_command(0)
		end
		if step <= 10 then
			message.show_voiced_skipping(4340030)
		end
		if step <= 11 then
			message.show_voiced_skipping(4340040)
		end
		if step <= 12 then
			cutscene.skip_command(0)
		end
		if step <= 13 then
			message.show_voiced_skipping(4340045)
		end
		if step <= 14 then
			message.show_voiced_skipping(4340050)
		end
		if step <= 15 then
			message.show_voiced_skipping(4340060)
		end
		if step <= 16 then
			message.show_voiced_skipping(4340070)
		end
		if step <= 17 then
			cutscene.skip_command(2)
		end
		if step <= 18 then
			cutscene.skip_command(2)
		end
		if step <= 19 then
			message.show_voiced_skipping(4340075)
		end
		if step <= 20 then
			wait.frames_skipping(50)
		end
		if step <= 21 then
			cutscene.skip_command(2)
		end
		if step <= 22 then
			wait.frames_skipping(30)
		end
		if step <= 23 then
			inventory.resume_obtained_message(375, 1)
		end
		if step <= 24 then
			wait.frames_skipping(4)
		end
		if step <= 25 then
			message.show_voiced_skipping(4340080)
		end
		if step <= 26 then
			message.show_voiced_skipping(4340090)
		end
		if step <= 27 then
			message.show_voiced_skipping(4340100)
		end
		if step <= 28 then
			message.show_voiced_skipping(4340110)
		end
		if step <= 29 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.play_music(0)
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.load_message_file(0, -1)
	if playable_character == 0 then
		event.set_object_sequence_position(0, 0.0, 0.0, 180.0)
	else
		event.set_object_sequence_position(1, 0.0, 0.0, 180.0)
	end
	event.set_camera_sequence_position(0.0, 30.0, 280.0)
	event.set_camera_sequence_look_at(0.0, 30.0, 180.0)
	step = 31
	vm.wait(31)
	step = 32
	inventory.resolve_overflow_alt(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays event 436, the party entering the boss room and thinking over the situation.
function oceans_roar_cave_boss.play_event_436()
	local playable_character: s32 = 0
	local door_sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(436, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.stop_music(0)
		event.load_map_sounds(4820)
		door_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_041.sound.json") or door_sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e436/")
		event.load_message_file(0, 5, "e436_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e436_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e436_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 16)
			event.load_equipment_model(5, 0, 4, "info", 16)
			event.load_equipment_model(5, 0, 3, "info", 16)
			event.load_equipment_model(5, 0, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e436/e436_mints.gltf", "info", 16)
			event.attach_object_handle_to_character(0, 16)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 16)
			event.load_equipment_model(5, 1, 4, "info", 16)
			event.load_equipment_model(5, 1, 3, "info", 16)
			event.load_equipment_model(5, 1, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e436/e436_monica.gltf", "info", 16)
			event.attach_object_handle_to_character(1, 16)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(16)
		event.set_character_active(17)
		event.attach_object_handle_to_map_part_2(2, "p02_d04b01")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_2(3, "p03_d04b01")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, 2030.0, 0.0, -740.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 2046.0, 0.0, -740.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.rotate_object_sequence_eased(2, 0.0, 0.0, 3.14, 40, 0, 0.5)
		event.delay_object_sequence_rotation_track(2, 168)
		event.rotate_object_sequence_eased(2, 0.0, 0.0, 0.0, 40, 0, 0.5)
		event.play_object_sequence_sound(2, door_sound_bank, 0)
		event.delay_object_sequence_sound_track(2, 170)
		event.play_object_sequence_sound(2, door_sound_bank, 1)
		event.delay_object_sequence_position_track(3, 80)
		event.move_object_sequence_eased(3, 0.0, 80.0, 0.0, 32, 1, 0.5)
		event.delay_object_sequence_position_track(3, 40)
		event.move_object_sequence_eased(3, 0.0, 0.0, 0.0, 32, 2, 0.5)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2198.81, 99.4, -537.94)
		event.set_camera_sequence_look_at(2056.98, 54.61, -679.8)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		wait.frames(110)
		event.move_object_sequence(0, 2030.0, 0.0, -680.0, 60)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		wait.frames(10)
		event.move_object_sequence(1, 2046.0, 0.0, -680.0, 60)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(1)
		event.set_camera_sequence_position(2061.53, 10.96, -648.18)
		event.set_camera_sequence_look_at(2030.82, 23.87, -686.56)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4360010)
		event.set_camera_sequence_position(1924.65, 64.05, 196.6)
		event.set_camera_sequence_look_at(1932.83, 64.94, 223.63)
		event.move_camera_sequence_eased(1924.65, 64.05, 196.6, 1904.25, 64.94, 216.36, 90, 0, 0.4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(4360015)
		camera.wait_until_done()
		event.set_camera_sequence_position(1800.0, 39.0, 176.0)
		event.set_camera_sequence_look_at(1800.0, 22.0, 260.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "こまり顔")
		event.set_object_handle_texture_animation(0, 1, "こまり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_object_sequence_position(0, 1794.0, 0.0, 200.0)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.move_object_sequence(0, 1794.0, 0.0, 260.0, 20)
		event.set_object_sequence_motion(0, "走り", 4)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_position(1, 1808.0, 0.0, 190.0)
		event.move_object_sequence(1, 1808.0, 0.0, 260.0, 24)
		event.set_object_sequence_motion(1, "走り", 4)
		event.delay_object_sequence_motion_track(1, 24)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(1)
		wait.frames(10)
		event.set_camera_sequence_angle_height_distance(0.9, -10.0, 38.0)
		event.set_object_sequence_motion(0, "考える", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "指当て", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(4360020)
		camera.wait_until_done()
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(door_sound_bank, 0)
	event.stop_sound_effect(door_sound_bank, 1)
	event.set_character_active(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
	event.set_object_handle_position(3, 0.0, 0.0, 0.0)
	event.delete_character_extension_packs(0)
	event.delete_character(16)
	event.delete_character(17)
	event.load_message_file(0, -1)
	character.place_standing_and_reset_cloth(vm.f32(1779.8), 0.0, 354.5, vm.f32(-0.96))
	event.set_camera_position(1878.94, 40.0, 285.33)
	event.set_camera_look_at(1779.8, 30.0, 354.5)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Plays event 444, the boss room cutscene with Shigura, Jamming and Baru, and restores the time of day afterwards.
function oceans_roar_cave_boss.play_event_444()
	local event_sound_bank: s32 = 0
	local playable_character: s32 = 0
	local time_of_day: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(444, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		step = 2
		wait.frames(4)
		event.load_music(53)
		event.load_map_sounds(4829)
		event_sound_bank = event.load_sound_effect_file_2(4829) or event_sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 then
			event.switch_dungeon_main_character(0)
			playable_character = 0
		end
		if playable_character == 3 then
			event.switch_dungeon_main_character(1)
			playable_character = 1
		end
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e444/")
		event.load_message_file(0, 5, "e444_1.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e444_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e444_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e444_shigura.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.copy_character(5, 10, 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.copy_character(5, 10, 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e444/e444_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e400/e444/e444_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.assign_memory_stack(6)
		event.clear_memory_stack(6)
		event.change_directory("event/e400/e444/")
		event.load_character(6, "e444_jamming.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(6, "e440_sourcer.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(6, 14)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(6, "e444_break.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_character_to_frame(14, "null6", 15)
		event.load_character(6, "e444_guiltoni.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(7, 16)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.load_character(6, "e444_soldier.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.copy_character(6, 17, 18)
		event.set_character_active(0, 18)
		event.change_directory("")
		event.attach_object_handle_to_map_part_2(11, "p01_battleship")
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.attach_object_handle_to_character(12, 1)
		event.attach_object_handle_to_character(13, 2)
		event.set_object_handle_visible(12, 0)
		event.set_object_handle_visible(13, 0)
		event.set_object_handle_position(0, 252.3, 0.0, 357.5)
		event.set_object_handle_rotation(0, 0.0, 1.2, 0.0)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_position(1, 258.89, 0.0, 341.43)
		event.set_object_handle_rotation(1, 0.0, 1.2, 0.0)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_position(2, 545.17, 0.0, -7.91)
		event.set_object_handle_rotation(2, 0.0, -0.72, 0.0)
		event.set_object_handle_sound_bank(2, event_sound_bank)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目赤")
		event.set_object_handle_position(3, 129.15, 0.0, -26.35)
		event.set_object_handle_rotation(3, 0.0, 0.6, 0.0)
		event.set_object_handle_sound_bank(3, event_sound_bank)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目赤")
		event.set_object_handle_position(4, 570.53, 0.0, 382.62)
		event.set_object_handle_rotation(4, 0.0, -1.96, 0.0)
		event.set_object_handle_sound_bank(4, event_sound_bank)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "目赤")
		event.set_object_handle_position(5, 300.33, 240.0, 240.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(5, "落ち前（会話）", 4)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "目パチ")
		event.set_object_handle_position(6, 300.33, 240.0, 240.0)
		event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_handle_position(7, 2290.9, 1276.37, 2358.88)
		event.set_object_handle_rotation(7, 0.0, -1.92, 0.0)
		event.set_object_handle_motion(7, "下向き立ち", 4)
		event.set_object_handle_texture_animation(7, 0)
		event.set_object_handle_texture_animation(7, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(7, 1, "下目パチ")
		event.set_character_position(17, 2312.3, 1275.66, 2387.69)
		event.set_character_rotation(17, 0.0, -2.16, 0.0)
		event.set_character_position(18, 2327.72, 1275.66, 2348.04)
		event.set_character_rotation(18, 0.0, -1.68, 0.0)
		event.set_object_handle_position(11, 2627.4, 1276.4, 2639.6)
		event.set_object_handle_rotation(11, 0.0, -0.767, 0.0)
		event.enable_drama_skip()
		time_of_day = event.get_scene_time_of_day() or time_of_day
		event.set_time_of_day_advancing(0)
		event.play_sound_effect(event_sound_bank, 7)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(300.17, 240.56, 319.36)
		event.set_camera_sequence_look_at(300.43, 248.47, 241.14)
		event.fade_in_screen(30)
		step = 3
		message.show_voiced(4440010)
		event.play_sound_effect(event_sound_bank, 8)
		event.move_object_sequence(6, 300.33, 230.0, 240.0, 4)
		event.rotate_object_sequence(6, 0.2, 0.0, -0.4, 4)
		event.jump_object_sequence(5, 320.44, 0.0, 291.73, -0.14, 60)
		event.rotate_object_sequence(5, 0.0, 0.36, 0.0, 4)
		event.set_object_sequence_motion(5, "落ちるin", 6)
		event.queue_object_sequence_next_motion(5, "落ちる", 4)
		step = 4
		wait.frames(20)
		event.set_camera_sequence_position(318.44, 131.15, 661.43)
		event.set_camera_sequence_look_at(322.58, 144.45, 500.53)
		event.stop_sound_effect(event_sound_bank, 7)
		event.move_object_sequence(6, 290.33, 180.0, 220.0, 30)
		event.rotate_object_sequence(6, -0.2, -3.14, 0.0, 30)
		step = 5
		wait.frames(30)
		event.set_camera_sequence_position(318.05, 24.6, 353.37)
		event.set_camera_sequence_look_at(322.78, 4.36, 298.93)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "目あき～目とじ")
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.set_object_sequence_motion(5, "落ちた", 2)
		event.wait_object_sequence_motion_end(5)
		step = 6
		message.show_voiced(4440020)
		step = 7
		object.wait_until_done(5)
		event.set_camera_sequence_position(295.12, 92.37, 617.16)
		event.set_camera_sequence_look_at(303.66, 107.91, 513.32)
		event.set_object_sequence_motion(4, "パウォーンin", 6)
		event.queue_object_sequence_next_motion(4, "パウォーンループ", 4)
		event.delay_object_sequence_sound_track(4, 10)
		event.play_object_sequence_sound(4, event_sound_bank, 9)
		event.delay_object_sequence_motion_track(3, 8)
		event.set_object_sequence_motion(3, "パウォーンin", 6)
		event.queue_object_sequence_next_motion(3, "パウォーンループ", 4)
		event.delay_object_sequence_motion_track(2, 20)
		event.set_object_sequence_motion(2, "パウォーンin", 6)
		event.queue_object_sequence_next_motion(2, "パウォーンループ", 4)
		step = 8
		message.show_voiced(4440030)
		step = 9
		message.show_voiced(4440040)
		step = 10
		object.wait_until_done(2)
		event.set_camera_sequence_position(422.0, 274.04, 460.88)
		event.set_camera_sequence_look_at(457.86, 277.56, 400.77)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "まばたき目パチ")
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "まばたき目パチ")
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "まばたき目パチ")
		event.play_music(0)
		step = 11
		wait.frames(40)
		event.set_camera_sequence_position(218.94, 252.83, 424.76)
		event.set_camera_sequence_look_at(320.08, 29.2, 293.98)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "目パチ")
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "目パチ")
		event.play_sound_effect(event_sound_bank, 10)
		event.set_object_sequence_position(2, 614.03, 0.0, 217.01)
		event.set_object_sequence_rotation(2, 0.0, -1.32, 0.0)
		event.set_object_sequence_motion(2, "くわえるin", 4)
		event.queue_object_sequence_next_motion(2, "くわえるout", 6)
		event.wait_object_sequence_motion_end(2)
		event.set_object_sequence_position(3, 20.52, 0.0, 157.49)
		event.set_object_sequence_rotation(3, 0.0, 1.08, 0.0)
		event.set_object_sequence_motion(3, "見下ろす", 6)
		event.queue_object_sequence_next_motion(3, "見下ろすループ", 4)
		event.set_object_sequence_position(4, 181.65, 0.0, 660.37)
		event.set_object_sequence_rotation(4, 0.0, 2.64, 0.0)
		step = 12
		wait.frames(17)
		event.queue_object_sequence_next_motion(5, "くわえるout", 6)
		step = 13
		object.wait_until_done(2)
		step = 14
		wait.frames(10)
		event.set_camera_sequence_position(229.1, 159.91, 213.0)
		event.set_camera_sequence_look_at(331.44, 4.22, 299.73)
		event.move_camera_sequence_eased(320.69, 24.73, 290.62, 331.44, 4.22, 299.73, 60, 0, 0.8)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "目とじ")
		event.set_object_sequence_motion(2, "なめるin", 6)
		event.queue_object_sequence_next_motion(2, "なめるループ", 4)
		step = 15
		wait.frames(50)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "しか目とじ")
		event.set_object_sequence_motion(5, "なめるループ", 4)
		step = 16
		camera.wait_until_done()
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "しか目とじ～目あき")
		event.set_object_sequence_motion(5, "目を覚ます", 2)
		event.queue_object_sequence_next_motion(5, "目を覚ます（会話）", 4)
		step = 17
		wait.frames(30)
		step = 18
		message.show_voiced(4440050)
		event.set_camera_sequence_position(394.66, 61.86, 362.9)
		event.set_camera_sequence_look_at(331.44, 4.22, 299.73)
		event.move_camera_sequence_eased(2396.78, 1356.17, 2363.54, 331.44, 4.22, 299.73, 120, 0, 0.2)
		event.play_sound_effect(event_sound_bank, 12)
		step = 19
		camera.wait_until_done()
		step = 20
		wait.frames(30)
		event.set_camera_sequence_position(2123.1, 1250.04, 2302.95)
		event.set_camera_sequence_look_at(2287.46, 1298.13, 2360.01)
		event.move_camera_sequence_eased(2196.82, 1272.46, 2328.55, 2287.46, 1298.13, 2360.01, 30, 0, 1.0)
		event.play_sound_effect(event_sound_bank, 13)
		event.set_character_active(16)
		event.set_character_active(17)
		event.set_character_active(18)
		event.set_object_sequence_motion(7, "下向き会話", 2)
		event.queue_object_sequence_next_motion(7, "下向き立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		step = 21
		message.show_voiced(4440060)
		step = 22
		camera.wait_until_done()
		event.set_mouth_texture_animations(7, "通常口パク")
		step = 23
		message.show_voiced(4440065)
		event.play_sound_effect(event_sound_bank, 14)
		event.set_object_sequence_motion(7, "振り返り", 2)
		event.rotate_object_sequence_eased(7, 0.0, 1.2, 0.0, 20, 0, 1.0)
		event.queue_object_sequence_next_motion(7, "歩き", 4)
		event.delay_object_sequence_position_track(7, 45)
		event.move_object_sequence(7, 2312.24, 1276.37, 2366.29, 30)
		step = 24
		wait.frames(30)
		step = 25
		message.show_voiced_for(4440070, 30)
		step = 26
		object.wait_until_done(7)
		event.stop_sound_effect(event_sound_bank, 12)
		event.stop_sound_effect(event_sound_bank, 13)
		event.set_camera_sequence_position(307.51, 36.12, 379.62)
		event.set_camera_sequence_look_at(354.57, 49.17, 421.92)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.set_character_active(0, 15)
		event.set_character_active(0, 16)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_character_active(0, 12)
		event.delete_character(13)
		event.delete_character(14)
		event.delete_character(15)
		event.delete_character(16)
		event.delete_character(17)
		event.delete_character(18)
		event.change_directory("event/e400/e444/")
		event.start_background_file_loads_3("e444_baru.gltf", "e444_paw.gltf", "e444_shigu.gltf")
		event.play_sound_effect(event_sound_bank, 15)
		do
			local out1, out2, out3 = event.get_object_handle_position(11)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		x = vm.f32(vm.f32(vm.sin(vm.f32(-0.767)) * 600.0) + x)
		y = vm.f32(y + 1900.0)
		z = vm.f32(vm.f32(vm.cos(vm.f32(-0.767)) * 600.0) + z)
		event.rotate_object_sequence_eased(11, 0.12, -0.767, 0.0, 60, 0, 1.0)
		event.rotate_object_sequence_eased(11, 0.0, 1.0, 0.0, 60, 1, 1.0)
		event.delay_object_sequence_position_track(11, 10)
		event.move_object_sequence_eased(11, x, y, z, 120, 1, 1.0)
		step = 27
		object.wait_until_done(11)
		x = vm.f32(vm.f32(vm.sin(1.0) * 16000.0) + x)
		y = vm.f32(y - 2000.0)
		z = vm.f32(vm.f32(vm.cos(1.0) * 16000.0) + z)
		event.move_object_sequence(11, x, y, z, 240)
		step = 28
		object.wait_until_done(11)
		step = 29
		wait.background_load()
		event.clear_memory_stack(6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.load_character(6, "e444_baru.gltf", "info", 21)
		event.set_character_active(21)
		event.attach_object_handle_to_character(10, 21)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_handle_position(10, -49.41, 0.0, 184.42)
		event.set_object_handle_rotation(10, 0.0, 1.06, 0.0)
		event.set_object_handle_motion(10, "立ち（下見）", 4)
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "目パチ")
		event.set_object_handle_sound_bank(10, event_sound_bank)
		event.load_character(6, "e444_paw.gltf", "info", 19)
		event.set_character_active(0, 19)
		event.attach_object_handle_to_character(8, 19)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_object_handle_position(8, 743.96, 0.0, 405.8)
		event.set_object_handle_rotation(8, 0.0, -1.68, 0.0)
		event.set_object_handle_motion(8, "立ち", 4)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "目パチ")
		event.set_object_handle_footstep_sound(8, 14)
		event.load_character(6, "e444_shigu.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.attach_object_handle_to_character(9, 20)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "目パチ")
		event.set_object_handle_position(9, 820.94, 0.0, 396.57)
		event.set_object_handle_rotation(9, 0.0, -1.68, 0.0)
		event.set_object_handle_motion(9, "立ち", 4)
		event.set_object_handle_sound_bank(9, event_sound_bank)
		event.change_directory("")
		event.move_camera_sequence_eased(199.68, 6.1, 282.7, 354.57, 49.17, 421.92, 60, 0, 1.0)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		step = 30
		camera.wait_until_done()
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "左・振り返る", 6)
		event.queue_object_sequence_next_motion(0, "左・振り返るL", 4)
		event.delay_object_sequence_sound_track(0, 26)
		event.play_object_sequence_sound(0, event_sound_bank, 16)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "バル見右振り返る", 6)
		event.queue_object_sequence_next_motion(1, "バル見右振り返るL", 4)
		step = 31
		message.show_voiced(4440080)
		step = 32
		object.wait_until_done(1)
		event.set_camera_sequence_position(231.08, 133.37, 346.07)
		event.set_camera_sequence_look_at(117.53, 106.94, 279.75)
		event.move_camera_sequence_eased(231.08, 133.37, 346.07, 117.53, 192.74, 279.75, 40, 2, 1.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(0, 0.0, -2.08, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, -2.08, 0.0)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		step = 33
		message.show_voiced(4440085)
		step = 34
		camera.wait_until_done()
		event.set_camera_sequence_position(238.96, 20.42, 316.49)
		event.set_camera_sequence_look_at(263.11, 21.75, 361.47)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "あきれ顔")
		event.set_object_handle_texture_animation(1, 1, "あきれ目パチ")
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 35
		message.show_voiced(4440090)
		step = 36
		object.wait_until_done(1)
		event.set_camera_sequence_position(222.1, 248.84, 164.7)
		event.set_camera_sequence_look_at(72.33, 243.65, 235.39)
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "通常目～おどろき目")
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		step = 37
		message.show_voiced(4440100)
		event.set_camera_sequence_position(377.63, 113.56, -196.18)
		event.set_camera_sequence_look_at(139.89, 126.6, 285.69)
		event.move_camera_sequence_angle_height_distance_eased(1.08, -13.04, 537.3, 350, 0, 0.2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 38
		message.show_voiced(4440110)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 39
		message.show_voiced(4440120)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 40
		message.show_voiced(4440125)
		step = 41
		camera.wait_until_done()
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "半目")
		event.set_object_sequence_motion(10, "頭下げin", 2)
		event.wait_object_sequence_motion_end(10)
		step = 42
		object.wait_until_done(10)
		event.set_mouth_motions(10, "頭下げ（会話）", 0, "頭下げループ", 0)
		step = 43
		message.show_voiced(4440130)
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "目とじ")
		event.move_camera_sequence_angle_height_distance_eased(-0.59, -13.04, 537.3, 350, 0, 0.2)
		event.set_mouth_motions(10, "頭下げ（会話）", 0, "頭下げループ", 0)
		step = 44
		message.show_voiced(4440140)
		event.set_object_sequence_motion(10, "うなだれるin", 2)
		event.wait_object_sequence_motion_end(10)
		step = 45
		object.wait_until_done(10)
		event.set_mouth_motions(10, "うなだれる（会話）", 0, "うなだれるループ", 0)
		step = 46
		message.show_voiced(4440145)
		step = 47
		camera.wait_until_done()
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "右・振り向く", 6)
		event.queue_object_sequence_next_motion(0, "右・振り向くL", 4)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "上見から振り返り", 6)
		event.queue_object_sequence_next_motion(1, "上見から振り返りL", 4)
		step = 48
		message.show_voiced(4440150)
		event.set_camera_sequence_position(495.19, 17.84, 361.84)
		event.set_camera_sequence_look_at(690.07, 37.26, 383.0)
		event.set_character_active(19)
		event.set_character_active(20)
		event.move_object_sequence(8, 560.22, 0.0, 376.68, 60)
		event.set_object_sequence_motion(8, "走り", 4)
		event.move_object_sequence(9, 730.38, 0.0, 386.74, 60)
		event.set_object_sequence_motion(9, "歩き", 4)
		step = 49
		message.show_voiced_for(4440160, 50)
		step = 50
		object.wait_until_done(8)
		step = 51
		object.wait_until_done(9)
		event.set_camera_sequence_position(268.74, 17.84, 243.45)
		event.set_camera_sequence_look_at(253.91, 23.46, 365.24)
		event.set_object_handle_texture_animation(10, 0)
		event.set_object_handle_texture_animation(10, 1, "目パチ")
		event.set_object_sequence_rotation(1, 0.0, 2.76, 0.0)
		event.set_object_sequence_motion(1, "右向くL", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "右向く戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 6)
		event.delay_object_sequence_texture_animation_track(1, 16)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "前向き～左向き")
		event.set_object_sequence_rotation(0, 0.0, 3.0, 0.0)
		event.set_object_sequence_motion(0, "右向くL", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 16)
		event.set_object_sequence_motion(0, "右向く戻り", 4, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 6)
		event.delay_object_sequence_texture_animation_track(0, 16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～左向き")
		event.set_object_sequence_position(8, 320.83, 0.0, 352.35)
		event.set_object_sequence_rotation(8, 0.0, -2.04, 0.0)
		event.move_object_sequence(8, 266.83, 0.0, 323.49, 40)
		event.delay_object_sequence_motion_track(8, 40)
		event.set_object_sequence_motion(8, "息切れ")
		event.set_object_sequence_position(9, 452.72, 0.0, 425.6)
		event.set_object_sequence_rotation(9, 0.0, -2.04, 0.0)
		event.move_object_sequence(9, 389.06, 0.0, 393.13, 60)
		event.delay_object_sequence_motion_track(9, 60)
		event.set_object_sequence_motion(9, "立ち")
		step = 52
		object.wait_until_done(8)
		event.set_camera_sequence_position(248.36, 14.52, 315.22)
		event.set_camera_sequence_look_at(272.47, 6.08, 326.81)
		event.move_camera_sequence_eased(248.36, 14.52, 315.22, 272.47, 17.46, 326.81, 30, 0, 1.0)
		step = 53
		camera.wait_until_done()
		step = 54
		wait.frames(20)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(0, 0.0, -2.08, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, -2.08, 0.0)
		event.set_object_sequence_motion(8, "上見立ち", 4)
		event.set_camera_sequence_position(709.01, 282.92, 118.6)
		event.set_camera_sequence_look_at(526.53, 220.56, 171.63)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.play_sound_effect(event_sound_bank, 17)
		event.set_object_sequence_motion(10, "顔よせin", 6)
		event.wait_object_sequence_motion_end(10)
		step = 55
		object.wait_until_done(10)
		event.set_mouth_motions(10, "顔よせ（会話）", 0, "顔よせループ", 0)
		step = 56
		message.show_voiced(4440170)
		event.set_camera_sequence_position(241.68, 16.71, 309.43)
		event.set_camera_sequence_look_at(266.8, 16.62, 323.29)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "てれ目パチ")
		event.set_object_sequence_motion(8, "てれる", 6)
		event.queue_object_sequence_next_motion(8, "てれるL", 4)
		step = 57
		message.show_voiced(4440180)
		step = 58
		object.wait_until_done(8)
		event.set_camera_sequence_position(582.83, 16.71, 236.56)
		event.set_camera_sequence_look_at(218.16, 115.67, 270.9)
		event.set_object_sequence_motion(8, "上見立ち", 4)
		event.set_object_sequence_motion(10, "顔よせout", 6)
		event.wait_object_sequence_motion_end(10)
		step = 59
		object.wait_until_done(10)
		step = 60
		wait.frames(30)
		event.set_mouth_motions(10, "シグー見（会話）", 0, "立ち", 0)
		step = 61
		message.show_voiced(4440190)
		event.set_camera_sequence_position(223.01, 93.87, 310.22)
		event.set_camera_sequence_look_at(354.09, 88.95, 375.33)
		event.move_camera_sequence_angle_height_distance_eased(2.61, 4.92, 146.36, 120, 0, 0.6)
		step = 62
		message.show_voiced(4440195)
		step = 63
		camera.wait_until_done()
		event.set_camera_sequence_position(592.78, 70.05, 215.14)
		event.set_camera_sequence_look_at(193.64, 115.67, 314.46)
		event.move_camera_sequence_angle_height_distance_eased(1.09, 289.34, 602.63, 360, 0, 1.0)
		event.set_mouth_motions(10, "シグー見（会話）", 0, "立ち", 0)
		step = 64
		message.show_voiced(4440200)
		event.set_mouth_motions(10, "シグー見（会話）", 0, "立ち", 0)
		step = 65
		message.show_voiced(4440210)
		event.set_mouth_motions(10, "シグー見（会話）", 0, "立ち", 0)
		step = 66
		message.show_voiced(4440220)
		step = 67
		camera.wait_until_done()
		event.set_camera_sequence_position(270.35, 12.55, 273.69)
		event.set_camera_sequence_look_at(266.43, 13.93, 321.78)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "さみし目パチ")
		event.set_object_sequence_motion(8, "うなだれ", 4)
		step = 68
		message.show_voiced_with_button_prompt(4440230, -1, 10)
		event.set_message_button_prompt(0, 1)
		event.delay_object_sequence_motion_track(8, 20)
		event.set_object_sequence_motion(8, "上見る", 2)
		event.queue_object_sequence_next_motion(8, "上見立ち", 4)
		step = 69
		message.show_voiced(4440240)
		step = 70
		object.wait_until_done(8)
		step = 71
		message.show_voiced(4440245)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "笑い目とじ")
		event.set_object_sequence_motion(8, "じゃれる", 6)
		event.queue_object_sequence_next_motion(8, "じゃれるL", 4)
		event.set_object_sequence_position(9, 378.05, 0.0, 378.96)
		event.set_object_sequence_motion(9, "じゃれる", 6)
		event.queue_object_sequence_next_motion(9, "じゃれるL", 4)
		step = 72
		object.wait_until_done(9)
		step = 73
		message.show_voiced(4440250)
		event.set_camera_sequence_position(224.1, 15.74, 287.53)
		event.set_camera_sequence_look_at(268.95, 17.12, 321.25)
		event.move_camera_sequence_eased(248.67, 15.74, 306.0, 268.95, 17.12, 321.25, 60, 0, 1.0)
		event.set_object_sequence_motion(1, "右向くL", 4, -1.0, 1)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "さみし目～片目とじ")
		step = 74
		message.show_voiced(4440260)
		step = 75
		camera.wait_until_done()
		event.fade_out_music(60)
		event.fade_out_screen(60)
		step = 76
		wait.frames(60)
		step = 77
		wait.frames(30)
		event.set_camera_sequence_position(923.53, 319.36, 605.97)
		event.set_camera_sequence_look_at(937.39, 309.52, 676.43)
		event.stop_music(0)
		step = 78
		wait.frames(4)
		event.load_music(112)
		event.set_time_of_day(17.5)
		event.set_object_sequence_position(0, 324.85, 0.0, 743.21)
		event.set_object_sequence_rotation(0, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 339.43, 0.0, 730.36)
		event.set_object_sequence_rotation(1, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(8, 358.56, 0.0, 715.56)
		event.set_object_sequence_rotation(8, 0.0, -2.44, 0.0)
		event.set_object_sequence_motion(8, "上見立ち", 4)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "目パチ")
		event.set_object_sequence_position(9, 354.38, 0.0, 381.34)
		event.set_object_sequence_rotation(9, 0.0, 0.36, 0.0)
		event.set_object_sequence_motion(9, "立ち", 4)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "目パチ")
		event.set_object_sequence_position(10, 84.12, 0.0, 476.19)
		event.set_object_sequence_rotation(10, 0.0, 0.7, 0.0)
		event.set_object_sequence_motion(10, "立ち（下見）", 4)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(260)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 937.39, 309.52, 676.43)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 902.6, 309.52, 674.74)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 882.59, 309.48, 665.11)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 865.02, 306.16, 647.98)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 852.74, 302.36, 620.25)
		event.add_camera_sequence_path_point(923.53, 319.36, 605.97, 851.29, 295.52, 603.41)
		event.start_camera_sequence_path()
		event.fade_in_screen(60)
		step = 79
		camera.wait_until_done()
		event.start_crossfade(60)
		event.set_camera_sequence_position(223.45, 515.0, 150.38)
		event.set_camera_sequence_look_at(212.66, 211.08, 449.02)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "さみし顔")
		event.set_object_handle_texture_animation(0, 1, "さみし目パチ")
		step = 80
		wait.frames(30)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		step = 81
		message.show_voiced(4440270)
		step = 82
		object.wait_until_done(10)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		step = 83
		message.show_voiced(4440280)
		step = 84
		object.wait_until_done(0)
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "うなだれる", 6)
		event.queue_object_sequence_next_motion(0, "うなだれるL", 4)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		step = 85
		message.show_voiced(4440290)
		step = 86
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "うなだれる戻り", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		step = 87
		message.show_voiced(4440300)
		event.set_mouth_motions(10, "会話L", 0, "立ち（下見）", 0)
		step = 88
		message.show_voiced(4440305)
		event.play_sound_effect(event_sound_bank, 18)
		event.set_object_sequence_motion(10, "歩き")
		event.set_object_sequence_motion_blend_step(10, 0.02)
		event.rotate_object_sequence_eased(10, 0.0, -0.74, 0.0, 60, 0, 1.0)
		event.move_object_sequence_eased(10, -91.56, 0.0, 632.05, 160, 1, 1.0)
		step = 89
		object.wait_until_done(10)
		event.set_camera_sequence_position(4.01, 520.98, 81.91)
		event.set_camera_sequence_look_at(-200.88, 47.61, 516.52)
		event.set_object_sequence_position(10, -330.83, 0.0, 588.98)
		event.set_object_sequence_rotation(10, 0.0, -1.1, 0.0)
		event.move_object_sequence(10, -606.74, -12.0, 763.16, 220)
		event.set_object_sequence_motion(10, "水歩き", 4)
		event.set_character_active(10)
		event.set_object_sequence_position(2, 45.1, 0.0, 642.1)
		event.set_object_sequence_rotation(2, 0.0, -1.1, 0.0)
		event.set_object_sequence_motion(2, "歩き", 4)
		event.set_object_sequence_motion_time(2, 12.0)
		event.move_object_sequence(2, -182.51, 0.0, 778.98, 220)
		event.set_character_active(11)
		event.set_object_sequence_position(3, 13.41, 0.0, 156.64)
		event.set_object_sequence_rotation(3, 0.0, -1.1, 0.0)
		event.set_object_sequence_motion(3, "歩き", 4)
		event.set_object_sequence_motion_time(3, 20.0)
		event.move_object_sequence(3, -190.65, 0.0, 240.14, 220)
		step = 90
		object.wait_until_done(10)
		event.set_camera_sequence_position(163.44, 190.58, 781.74)
		event.set_camera_sequence_look_at(-41.96, 53.55, 668.25)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "さみし目パチ")
		event.play_music(0)
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.set_character_active(0, 8)
		event.set_character_active(0, 21)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.set_object_sequence_position(8, -50.0, 0.0, 725.0)
		event.set_object_sequence_rotation(8, 0.0, -3.14, 0.0)
		event.set_object_sequence_motion(8, "上見立ち", 4)
		event.set_object_sequence_position(9, -50.0, 0.0, 530.0)
		event.set_object_sequence_rotation(9, 0.0, 0.0, 0.0)
		event.move_object_sequence(9, -50.0, 0.0, 590.0, 60)
		event.set_object_sequence_motion(9, "歩き", 4)
		event.delay_object_sequence_motion_track(9, 60)
		event.set_object_sequence_motion(9, "立ち")
		step = 91
		wait.frames(80)
		event.play_sound_effect(event_sound_bank, 19)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "目あき～目とじ")
		event.set_object_sequence_motion(8, "なでる", 6)
		event.queue_object_sequence_next_motion(8, "なでるL", 4)
		event.set_object_sequence_motion(9, "なでる", 6)
		event.queue_object_sequence_next_motion(9, "なでるL", 4)
		step = 92
		message.show_voiced(4440310)
		step = 93
		object.wait_until_done(8)
		step = 94
		message.show_voiced(4440320)
		event.play_sound_effect(event_sound_bank, 20)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "目とじ～目あき")
		event.set_object_sequence_motion(9, "なでる戻り", 6)
		event.queue_object_sequence_next_motion(9, "立ち", 4)
		event.set_object_sequence_motion(8, "なでる戻り", 6)
		event.queue_object_sequence_next_motion(8, "うなだれ", 4)
		step = 95
		message.show_voiced(4440330)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "通常目～さみし目")
		event.set_object_sequence_motion(8, "左指す", 6)
		event.queue_object_sequence_next_motion(8, "左指すL", 4)
		step = 96
		message.show_voiced(4440335)
		step = 97
		object.wait_until_done(8)
		event.delay_object_sequence_motion_track(9, 24)
		event.set_object_sequence_motion(9, "左見る", 6)
		event.queue_object_sequence_next_motion(9, "左見るL", 4)
		event.set_object_sequence_motion(8, "左指す戻り", 6)
		event.queue_object_sequence_next_motion(8, "うつむき走り")
		step = 98
		object.wait_until_done(8)
		event.rotate_object_sequence(8, 0.0, 1.57, 0.0, 8)
		event.move_object_sequence(8, 35.37, 0.0, 725.0, 30)
		step = 99
		object.wait_until_done(8)
		event.set_camera_sequence_position(242.62, 3.04, 743.15)
		event.set_camera_sequence_look_at(144.17, 27.78, 743.82)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "さみし目パチ")
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "泣き目とじ")
		event.set_character_active(21)
		event.set_object_sequence_position(10, -6173.0, -82.0, 401.0)
		event.set_object_sequence_rotation(10, 0.0, -1.58, 0.0)
		event.set_character_active(10)
		event.set_object_sequence_position(2, -4863.0, -82.0, -403.0)
		event.set_object_sequence_rotation(2, 0.0, -1.58, 0.0)
		event.set_character_active(11)
		event.set_object_sequence_position(3, -3769.0, -82.0, 836.0)
		event.set_object_sequence_rotation(3, 0.0, -1.46, 0.0)
		event.set_object_sequence_position(8, 190.82, 0.0, 753.88)
		event.set_object_sequence_motion(8, "泣く", 4)
		event.set_object_sequence_position(9, -49.43, 0.0, 673.38)
		step = 100
		message.show_voiced(4440340)
		event.set_object_sequence_motion(9, "左見る戻り", 2)
		event.queue_object_sequence_next_motion(9, "歩き")
		event.set_object_sequence_motion_blend_step(9, 0.02)
		event.delay_object_sequence_motion_track(9, 140)
		event.queue_object_sequence_next_motion(9, "水歩き", 4)
		event.rotate_object_sequence_eased(9, 0.0, -1.57, 0.0, 60, 0, 1.0)
		event.move_object_sequence_eased(9, -838.9, -25.0, 648.72, 300, 1, 1.0)
		step = 101
		message.show_voiced_line_variant(4440350, 300)
		step = 102
		object.wait_until_done(9)
		event.set_object_sequence_motion(9, "立ち")
		event.set_object_sequence_motion_blend_step(9, 0.02)
		step = 103
		wait.frames(20)
		event.set_object_sequence_motion(9, "左見る", 6)
		event.queue_object_sequence_next_motion(9, "左見るL", 4)
		step = 104
		object.wait_until_done(9)
		step = 105
		wait.frames(30)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "なみだ目")
		event.delay_object_sequence_motion_track(8, 10)
		event.wait_object_sequence_motion_end(8)
		event.set_object_sequence_motion(8, "顔上げる", 6)
		event.queue_object_sequence_next_motion(8, "立ち", 4)
		event.delay_object_sequence_texture_animation_track(8, 10)
		event.set_object_sequence_texture_animation(8, 1, "泣き目とじ～目あけ")
		step = 106
		message.show_voiced(4440360)
		step = 107
		object.wait_until_done(8)
		step = 108
		wait.frames(10)
		event.set_object_sequence_motion(9, "左見る戻り", 6)
		event.queue_object_sequence_next_motion(9, "歩き")
		event.play_sound_effect(event_sound_bank, 21)
		event.rotate_object_sequence(8, 0.0, -1.57, 0.0, 10)
		event.move_object_sequence(8, -125.45, 0.0, 754.45, 60)
		event.set_object_sequence_motion(8, "走り")
		event.delay_object_sequence_motion_track(8, 60)
		event.set_object_sequence_motion(8, "叫ぶ")
		step = 109
		wait.frames(40)
		event.set_camera_sequence_position(-997.46, 75.59, 665.14)
		event.set_camera_sequence_look_at(-897.68, 82.51, 666.04)
		event.set_object_handle_texture_animation(8, 0)
		event.set_object_handle_texture_animation(8, 1, "泣き目パチ")
		event.set_object_sequence_motion(9, "立ち")
		event.set_object_sequence_motion_blend_step(9, 0.02)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "なみだ目～うれし目")
		step = 110
		message.show_voiced(4440370)
		event.set_camera_sequence_position(-772.6, 67.51, 676.22)
		event.set_camera_sequence_look_at(-873.85, 79.6, 666.69)
		event.set_object_handle_texture_animation(9, 0)
		event.set_object_handle_texture_animation(9, 1, "キラ目")
		event.set_object_sequence_motion(9, "左見る", 6)
		event.queue_object_sequence_next_motion(9, "左見るL", 4)
		step = 111
		object.wait_until_done(9)
		step = 112
		message.show_voiced(4440380)
		event.move_camera_sequence_eased(-48.23, 14.46, 744.38, -873.85, 79.6, 666.69, 60.0, 0, 1.0)
		event.set_object_sequence_motion(8, "手を振る", 4)
		event.set_object_sequence_motion(9, "左見る戻り", 2)
		event.queue_object_sequence_next_motion(9, "立ち", 4)
		event.set_object_sequence_motion_blend_step(9, 0.02)
		step = 113
		camera.wait_until_done()
		step = 114
		message.show_voiced(4440390)
		step = 115
		message.show_voiced(4440400)
		event.set_character_visible(20, 0, 1, 0.01)
		event.set_character_visible(11, 0, 1, 0.01)
		event.set_character_visible(10, 0, 1, 0.01)
		event.set_character_visible(21, 0, 1, 0.01)
		step = 116
		message.show_voiced(4440410)
		step = 117
		message.show_voiced(4440420)
		event.set_scene_character_type(19, 4)
		event.set_character_visible(19, 0, 1, 0.01)
		step = 118
		message.show_voiced(4440430)
		step = 119
		wait.frames(4)
		event.start_crossfade(60)
		event.set_character_active(0, 19)
		event.set_time_of_day(24.0)
		step = 120
		message.show_voiced(4440435)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		step = 121
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 1 then
			wait.frames_skipping(4)
		end
		if step <= 2 then
			local _ = playable_character == 2
			playable_character = 0
			local _ = playable_character == 3
			playable_character = 1
			message.show_voiced_skipping(4440010)
		end
		if step <= 3 then
			wait.frames_skipping(20)
		end
		if step <= 4 then
			wait.frames_skipping(30)
		end
		if step <= 5 then
			message.show_voiced_skipping(4440020)
		end
		if step <= 6 then
			cutscene.skip_command(5)
		end
		if step <= 7 then
			message.show_voiced_skipping(4440030)
		end
		if step <= 8 then
			message.show_voiced_skipping(4440040)
		end
		if step <= 9 then
			cutscene.skip_command(2)
		end
		if step <= 10 then
			wait.frames_skipping(40)
		end
		if step <= 11 then
			wait.frames_skipping(17)
		end
		if step <= 12 then
			cutscene.skip_command(2)
		end
		if step <= 13 then
			wait.frames_skipping(10)
		end
		if step <= 14 then
			wait.frames_skipping(50)
		end
		if step <= 15 then
			wait.background_load_skipping()
		end
		if step <= 16 then
			wait.frames_skipping(30)
		end
		if step <= 17 then
			message.show_voiced_skipping(4440050)
		end
		if step <= 18 then
			wait.background_load_skipping()
		end
		if step <= 19 then
			wait.frames_skipping(30)
		end
		if step <= 20 then
			message.show_voiced_skipping(4440060)
		end
		if step <= 21 then
			wait.background_load_skipping()
		end
		if step <= 22 then
			message.show_voiced_skipping(4440065)
		end
		if step <= 23 then
			wait.frames_skipping(30)
		end
		if step <= 24 then
			message.show_voiced_for_skipping(4440070, 30)
		end
		if step <= 25 then
			cutscene.skip_command(7)
		end
		if step <= 26 then
			x = vm.f32(vm.f32(vm.sin(vm.f32(-0.767)) * 600.0) + x)
			y = vm.f32(y + 1900.0)
			z = vm.f32(vm.f32(vm.cos(vm.f32(-0.767)) * 600.0) + z)
			cutscene.skip_command(11)
		end
		if step <= 27 then
			x = vm.f32(vm.f32(vm.sin(1.0) * 16000.0) + x)
			y = vm.f32(y - 2000.0)
			z = vm.f32(vm.f32(vm.cos(1.0) * 16000.0) + z)
			cutscene.skip_command(11)
		end
		if step <= 28 then
			wait.background_load_skipping()
		end
		if step <= 29 then
			wait.background_load_skipping()
		end
		if step <= 30 then
			message.show_voiced_skipping(4440080)
		end
		if step <= 31 then
			cutscene.skip_command(1)
		end
		if step <= 32 then
			message.show_voiced_skipping(4440085)
		end
		if step <= 33 then
			wait.background_load_skipping()
		end
		if step <= 34 then
			message.show_voiced_skipping(4440090)
		end
		if step <= 35 then
			cutscene.skip_command(1)
		end
		if step <= 36 then
			message.show_voiced_skipping(4440100)
		end
		if step <= 37 then
			message.show_voiced_skipping(4440110)
		end
		if step <= 38 then
			message.show_voiced_skipping(4440120)
		end
		if step <= 39 then
			message.show_voiced_skipping(4440125)
		end
		if step <= 40 then
			wait.background_load_skipping()
		end
		if step <= 41 then
			cutscene.skip_command(10)
		end
		if step <= 42 then
			message.show_voiced_skipping(4440130)
		end
		if step <= 43 then
			message.show_voiced_skipping(4440140)
		end
		if step <= 44 then
			cutscene.skip_command(10)
		end
		if step <= 45 then
			message.show_voiced_skipping(4440145)
		end
		if step <= 46 then
			wait.background_load_skipping()
		end
		if step <= 47 then
			message.show_voiced_skipping(4440150)
		end
		if step <= 48 then
			message.show_voiced_for_skipping(4440160, 50)
		end
		if step <= 49 then
			cutscene.skip_command(8)
		end
		if step <= 50 then
			cutscene.skip_command(9)
		end
		if step <= 51 then
			cutscene.skip_command(8)
		end
		if step <= 52 then
			wait.background_load_skipping()
		end
		if step <= 53 then
			wait.frames_skipping(20)
		end
		if step <= 54 then
			cutscene.skip_command(10)
		end
		if step <= 55 then
			message.show_voiced_skipping(4440170)
		end
		if step <= 56 then
			message.show_voiced_skipping(4440180)
		end
		if step <= 57 then
			cutscene.skip_command(8)
		end
		if step <= 58 then
			cutscene.skip_command(10)
		end
		if step <= 59 then
			wait.frames_skipping(30)
		end
		if step <= 60 then
			message.show_voiced_skipping(4440190)
		end
		if step <= 61 then
			message.show_voiced_skipping(4440195)
		end
		if step <= 62 then
			wait.background_load_skipping()
		end
		if step <= 63 then
			message.show_voiced_skipping(4440200)
		end
		if step <= 64 then
			message.show_voiced_skipping(4440210)
		end
		if step <= 65 then
			message.show_voiced_skipping(4440220)
		end
		if step <= 66 then
			wait.background_load_skipping()
		end
		if step <= 67 then
			message.show_voiced_then_hold_skipping(4440230, -1, 10)
		end
		if step <= 68 then
			message.show_voiced_skipping(4440240)
		end
		if step <= 69 then
			cutscene.skip_command(8)
		end
		if step <= 70 then
			message.show_voiced_skipping(4440245)
		end
		if step <= 71 then
			cutscene.skip_command(9)
		end
		if step <= 72 then
			message.show_voiced_skipping(4440250)
		end
		if step <= 73 then
			message.show_voiced_skipping(4440260)
		end
		if step <= 74 then
			wait.background_load_skipping()
		end
		if step <= 75 then
			wait.frames_skipping(60)
		end
		if step <= 76 then
			wait.frames_skipping(30)
		end
		if step <= 77 then
			wait.frames_skipping(4)
		end
		if step <= 78 then
			wait.background_load_skipping()
		end
		if step <= 79 then
			wait.frames_skipping(30)
		end
		if step <= 80 then
			message.show_voiced_skipping(4440270)
		end
		if step <= 81 then
			cutscene.skip_command(10)
		end
		if step <= 82 then
			message.show_voiced_skipping(4440280)
		end
		if step <= 83 then
			cutscene.skip_command(0)
		end
		if step <= 84 then
			message.show_voiced_skipping(4440290)
		end
		if step <= 85 then
			cutscene.skip_command(0)
		end
		if step <= 86 then
			message.show_voiced_skipping(4440300)
		end
		if step <= 87 then
			message.show_voiced_skipping(4440305)
		end
		if step <= 88 then
			cutscene.skip_command(10)
		end
		if step <= 89 then
			cutscene.skip_command(10)
		end
		if step <= 90 then
			wait.frames_skipping(80)
		end
		if step <= 91 then
			message.show_voiced_skipping(4440310)
		end
		if step <= 92 then
			cutscene.skip_command(8)
		end
		if step <= 93 then
			message.show_voiced_skipping(4440320)
		end
		if step <= 94 then
			message.show_voiced_skipping(4440330)
		end
		if step <= 95 then
			message.show_voiced_skipping(4440335)
		end
		if step <= 96 then
			cutscene.skip_command(8)
		end
		if step <= 97 then
			cutscene.skip_command(8)
		end
		if step <= 98 then
			cutscene.skip_command(8)
		end
		if step <= 99 then
			message.show_voiced_skipping(4440340)
		end
		if step <= 100 then
			oceans_roar_cave_boss.resume_voiced_message(4440350, 300)
		end
		if step <= 101 then
			cutscene.skip_command(9)
		end
		if step <= 102 then
			wait.frames_skipping(20)
		end
		if step <= 103 then
			cutscene.skip_command(9)
		end
		if step <= 104 then
			wait.frames_skipping(30)
		end
		if step <= 105 then
			message.show_voiced_skipping(4440360)
		end
		if step <= 106 then
			cutscene.skip_command(8)
		end
		if step <= 107 then
			wait.frames_skipping(10)
		end
		if step <= 108 then
			wait.frames_skipping(40)
		end
		if step <= 109 then
			message.show_voiced_skipping(4440370)
		end
		if step <= 110 then
			cutscene.skip_command(9)
		end
		if step <= 111 then
			message.show_voiced_skipping(4440380)
		end
		if step <= 112 then
			wait.background_load_skipping()
		end
		if step <= 113 then
			message.show_voiced_skipping(4440390)
		end
		if step <= 114 then
			message.show_voiced_skipping(4440400)
		end
		if step <= 115 then
			message.show_voiced_skipping(4440410)
		end
		if step <= 116 then
			message.show_voiced_skipping(4440420)
		end
		if step <= 117 then
			message.show_voiced_skipping(4440430)
		end
		if step <= 118 then
			wait.frames_skipping(4)
		end
		if step <= 119 then
			message.show_voiced_skipping(4440435)
		end
		if step <= 120 then
			wait.frames_skipping(30)
		end
		return true
	end)
	step = 122
	vm.entry(122)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.stop_sound_effect(event_sound_bank, 7)
	event.stop_sound_effect(event_sound_bank, 12)
	event.stop_sound_effect(event_sound_bank, 13)
	event.stop_sound_effect(event_sound_bank, 15)
	event.change_directory("")
	event.set_character_active(0)
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
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(21)
	event.load_message_file(0, -1)
	event.set_time_of_day(time_of_day)
	event.set_time_of_day_advancing(1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(12, 1)
	event.set_object_handle_visible(13, 1)
	event.finish_event()
end

--- Plays the short entrance scene where the player walks into the boss room and the camera returns to the player.
function oceans_roar_cave_boss.play_room_entrance()
	local door_sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		door_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_041.sound.json") or door_sound_bank
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p02_d04b01")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_2(3, "p03_d04b01")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 3)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, 2040.0, 0.0, -740.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 14)
		event.play_sound_effect(door_sound_bank, 0)
		event.rotate_object_sequence_eased(1, 0.0, 0.0, 3.14, 40, 0, 0.5)
		event.delay_object_sequence_position_track(2, 80)
		event.move_object_sequence_eased(2, 0.0, 80.0, 0.0, 32, 1, 0.5)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(2198.81, 99.4, -537.94)
		event.set_camera_sequence_look_at(2056.98, 54.61, -679.8)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		wait.frames(110)
		event.move_object_sequence(0, 2040.0, 0.0, -660.0, 60)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		object.wait_until_done(0)
		object.wait_until_done(1)
		wait.frames(10)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_handle_position(3, 0.0, 0.0, 0.0)
	character.place_standing_and_reset_cloth(2040.0, 0.0, -680.0, 0.0)
	event.set_camera_look_at(2040.0, 30.0, -680.0)
	event.set_camera_position(2040.0, 40.0, -580.0)
	event.reset_follow_camera(0)
	event.start_crossfade(30)
	event.finish_event()
end

--- Resumes a skipped voiced message by reopening its window and waiting the given number of frames before closing it.
function oceans_roar_cave_boss.resume_voiced_message(message_id: s32, frames: s32)
	message.open_skipping(0, -1, 8, 0, 0)
	message.run_talking_skipping_variant(0, frames)
	message.close_skipping(0)
end

--- Loads the boss room monsters, places six of them in a ring around the room centre and shows the boss room map part.
function oceans_roar_cave_boss.spawn_boss_room_monsters()
	event.load_dungeon_monster(522, 1)
	event.load_dungeon_monster(514, 0)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
		0.0,
		0.5235988,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
		0.0,
		1.5707964,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
		0.0,
		2.617994,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
		0.0,
		-2.617994,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
		0.0,
		-1.5707964,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
		0.0,
		-0.5235988,
		0.0
	)
	event.place_dungeon_monster(522, 0, 0, 0)
	event.attach_object_handle_to_map_part_2(0, "p04_d04b01")
	event.set_object_handle_visible(0, 1)
	vm.wait(1)
end

--- Deletes the event characters in slots 8 to 25 and clears memory stack 4.
function oceans_roar_cave_boss.unload_event_characters()
	for index = 0, 17 do
		event.delete_character(8 + index)
	end
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
end

return oceans_roar_cave_boss
