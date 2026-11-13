--!strict
--- Stonehenge platform script covering the hologram device cutscene, the four gem altars and the departure talk.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local kazarov_stonehenge_s11 = require("@lib/event/kazarov_stonehenge_s11")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local town_prompt = require("@lib/event/french/town_prompt")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Resets the train cars and shows the gems already placed on the altars.
local function show_placed_gems()
	local flag: s32 = 0
	local placed_gems: s32 = 0
	object.reset_train_car_parts()
	flag = event.get_save_flag(640) or flag
	kazarov_stonehenge_s11.set_map_part_visible(flag)
	placed_gems = event.get_save_counter(16) or placed_gems
	if bit32.band(placed_gems, 1) ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_10-m0")
		event.set_object_handle_visible(0, 1)
	end
	if bit32.band(placed_gems, 2) ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_09-m1")
		event.set_object_handle_visible(0, 1)
	end
	if bit32.band(placed_gems, 4) ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_08-m0")
		event.set_object_handle_visible(0, 1)
	end
	if bit32.band(placed_gems, 8) ~= 0 then
		event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_07-m0")
		event.set_object_handle_visible(0, 1)
	end
end

--- Plays the partner's talk before leaving and tells whether the party leaves.
local function ask_leave_stonehenge()
	local character_slot: s32 = 0
	local flag: s32 = 0
	local stay_choice: any = 0
	local language_code: s32 = 0
	local original_rotation: f32 = 0
	local voiced_stay_choice: any = 0
	local resume_step: number = 0
	return vm.guard(function()
		character_slot = event.get_triggered_event_data_2(13) or character_slot
		flag = event.get_save_flag(55) or flag
		if flag == 0 then
			event.set_save_flag(55, 1)
			event.set_message_bubble_tail(0, 1)
			event.apply_message_window_preset(0, 0)
			resume_step = 1
			cutscene.face_each_other(0, character_slot, 0)
			event.open_message_window_2(
				0,
				"Ohh ! Ainsi les Unions chrono sont\npossibles ! Je n'en reviens pas !<page>Le savoir des anciens devait [UNI00ea]tre\nimmense..."
			)
			resume_step = 2
			message.say_bubble(0, -1, character_slot, 0, 0)
			event.open_message_window_2(
				0,
				"Selon mes recherches, un objet peut\nexister simultan[UNI00e9]ment en 2 lieux et\nespaces au sein d'une union chrono."
			)
			resume_step = 3
			message.say_bubble(0, -1, character_slot, 0, 0)
			event.open_message_window_2(
				0,
				"Ainsi Paznos est ici,\ndans notre temps, mais\nexiste aussi dans le futur.<page>Je l'admets, ce concept est \nun peu compliqu[UNI00e9] [UNI00e0] saisir."
			)
			resume_step = 4
			message.say_bubble(0, -1, character_slot, 0, 0)
			event.open_message_window_2(0, "Bon, je suppose qu'on\nferait mieux d'y aller.")
			resume_step = 5
			message.say_bubble(0, -1, character_slot, 0, 0)
			event.set_character_motion(character_slot, "立ち")
			message.set_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(0, "Ouais !\nJe veux rester encore un peu.")
			resume_step = 6
			stay_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
			event.set_message_window_option(0, 0, 0)
			event.set_message_bubble_tail(0, 1)
			if stay_choice ~= 0 then
				event.set_character_motion(character_slot, "会話")
				event.open_message_window_2(0, "Allez, on acc[UNI00e9]l[UNI00e8]re.")
				resume_step = 7
				message.say_bubble(0, -1, character_slot, 0, 0)
				event.set_character_motion(character_slot, "立ち")
				event.finish_event()
				return 0
			end
			return 1
		else
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			language_code = event.get_language() or language_code
			if language_code == 0 then
				event.load_message_file(0, 5, "event/e600/e648/e648.txt")
			else
				event.load_message_file(0, 5, "event/e600/e648/e648_1.txt")
			end
			event.stop_music(0)
			resume_step = 8
			original_rotation = cutscene.begin_talk(character_slot, 0, 0)
			resume_step = 9
			message.show_voiced(6480010)
			event.set_character_motion(character_slot, "立ち")
			message.set_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(0, "Ouais !\nJe veux rester encore un peu.")
			resume_step = 10
			voiced_stay_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
			event.set_message_window_option(0, 0, 0)
			event.set_message_bubble_tail(0, 1)
			if voiced_stay_choice ~= 0 then
				event.set_character_motion(character_slot, "会話")
				event.set_message_window_mode(0, 7)
				resume_step = 11
				message.show_voiced(6480020)
			end
			event.load_message_file(0, -1)
			message.set_window_mode(0, 1)
			resume_step = 12
			cutscene.end_talk(character_slot, original_rotation, 0, 0)
			if voiced_stay_choice == 0 then
				return 1
			else
				event.play_music(0)
				return 0
			end
		end
	end, function(received: { any })
		if resume_step <= 7 then
			if resume_step == 6 then
				stay_choice = received[1] :: number
			end
			if resume_step <= 1 then
				message.show_then_close(0, -1, character_slot, 0, 0)
			end
			if resume_step <= 2 then
				message.show_then_close(0, -1, character_slot, 0, 0)
			end
			if resume_step <= 3 then
				message.show_then_close(0, -1, character_slot, 0, 0)
			end
			if resume_step <= 4 then
				message.show_then_close(0, -1, character_slot, 0, 0)
			end
			if resume_step <= 5 then
				message.set_window_mode_stub(0, 1)
				stay_choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			if resume_step <= 6 then
				message.show_then_close(0, -1, character_slot, 0, 0)
			end
			return 0
		end
		if resume_step <= 12 then
			if resume_step == 8 then
				original_rotation = received[1] :: number
			end
			if resume_step == 10 then
				voiced_stay_choice = received[1] :: number
			end
			if resume_step <= 8 then
				message.show_voiced_skipping(6480010)
			end
			if resume_step <= 9 then
				message.set_window_mode_stub(0, 1)
				voiced_stay_choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			if resume_step <= 10 then
				message.show_voiced_skipping(6480020)
			end
			if resume_step <= 11 then
				message.set_window_mode_stub(0, 1)
				character.restore_facing_skipping(character_slot, original_rotation, 0, 0)
			end
			return 1
		end
		return nil
	end)
end

--- Loads the party, Osmond, the hologram models and event sprites for the hologram cutscene.
local function load_hologram_cutscene()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(13, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 13)
	event.load_character(5, "event/e600/e616/e616_eina_holo.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(6, 41)
	event.clear_object_sequence(6, 41)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e600/e616/e616_touei.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.load_character(5, "event/e600/e616/e616_hologram.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.set_scene_character_type(40, 4)
	event.load_character(5, "event/e600/e616/e616_key_h.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 43)
	event.attach_object_handle_to_character(15, 43)
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 15)
	event.set_character_active(0, 43)
	event.attach_object_handle_to_map_part_2(16, "p10_s48")
	event.attach_object_handle_to_map_part_2(4, "p01_train01")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_12-m1")
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.attach_object_handle_to_map_part_3(7, "p01_s11", "s11_06-m0")
	event.clear_object_sequence(7)
	event.set_object_sequence_object(7, 7)
	event.attach_object_handle_to_map_part_3(8, "p01_s11", "s11_04-m0")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_3(9, "p01_s11", "s11_05-m0")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_4(10, "p01_s11", "s11_04-m0", "mi1")
	event.attach_object_handle_to_map_part_4(11, "p01_s11", "s11_05-m0", "mi2")
	event.attach_object_handle_to_map_part_4(12, "p01_s11", "s11_06-m0", "mi")
	event.attach_object_handle_to_map_part_3(14, "p01_s11", "s11_03-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 14)
	block = event.load_event_image_4(5, "textures/event/e600/e616/e616.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e61601", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e61602", block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 416)
	event.set_event_sprite_size(1, 512, 416)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 0)
	event.attach_object_handle_to_sprite(21, 1)
	event.clear_object_sequence(21)
	event.set_object_sequence_object(21, 21)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "e61603", block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 0, 512, 416)
	event.set_event_sprite_size(2, 512, 416)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 0)
	event.attach_object_handle_to_sprite(22, 2)
	event.clear_object_sequence(22)
	event.set_object_sequence_object(22, 22)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "e61604", block)
	event.set_event_sprite_color(3, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(3, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(3, 512, 416)
	event.set_event_sprite_position(3, 256, 208)
	event.set_event_sprite_draw_pass(3, 0)
	event.attach_object_handle_to_sprite(23, 3)
	event.clear_object_sequence(23)
	event.set_object_sequence_object(23, 23)
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "e61605", block)
	event.set_event_sprite_color(4, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(4, 0, 0, 512.0, 416.0)
	event.set_event_sprite_size(4, 512, 416)
	event.set_event_sprite_position(4, 256, 208)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(24, 4)
	event.clear_object_sequence(24)
	event.set_object_sequence_object(24, 24)
	event.load_message_file(0, 5, "event/e600/e616/e616_1.txt")
end

--- Sets the two party member slots to the layout used when the second character is playable.
local function reset_party_slots()
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
end

--- Unloads the hologram cutscene models and places the player at the platform.
local function unload_hologram_cutscene()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
	end
	event.set_object_sequence_position(4, 895.0, -254.5, 3348.1)
	event.set_object_sequence_rotation(4, 0.0, 1.57, 0.0)
	event.set_object_sequence_position(9, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(8, 0.0, 0.0, 0.0)
	event.set_object_sequence_position(7, 0.0, 0.0, 0.0)
	event.set_object_handle_frame_visible(10, "", 1)
	event.set_object_handle_frame_visible(11, "", 1)
	event.delete_event_image(0)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.set_character_position(0, 1.4, -13.3, 312.5)
	event.set_character_rotation(0, 0.0, 3.12, 0.0)
	event.set_scene_status_flags(1, 0, 256, 0)
end

--- Plays the cutscene where the party activates the hologram device, meets Eina's hologram, watches the pillars spin and receives the key item.
local function play_hologram_device_cutscene()
	local sound_bank: s32 = 0
	local special_sound_bank: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local i: s32 = 0
	local bounce_amplitude: f32 = 0
	local radius: f32 = 0
	local angle: f32 = 0
	local center_x: f32 = 0
	local center_z: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local frame: s32 = 0
	local rotated_x: f32 = 0
	local rotated_z: f32 = 0
	local resume_step: number = 0
	vm.section(function()
		resume_step = 1
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		resume_step = 2
		vm.wait(2)
		resume_step = 3
		vm.wait(3)
		resume_step = 4
		vm.wait(4)
		resume_step = 5
		vm.wait(5)
		event.load_music(5)
		event.play_music(0)
		sound_bank = event.load_sound_effect_file_2(6201) or sound_bank
		special_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or special_sound_bank
		object.reset_train_car_parts()
		load_hologram_cutscene()
		event.set_scene_status_flags(1, 0, 256, 1)
		event.set_object_handle_frame_visible(10, "", 0)
		event.set_object_handle_frame_visible(11, "", 0)
		event.set_object_handle_visible(16, 0)
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_footstep_sound(13, 14)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "目パチ")
		event.set_object_sequence_position(9, 0.0, 45.5, 0.0)
		event.set_object_sequence_position(8, 0.0, 45.5, 0.0)
		event.set_object_sequence_position(7, 0.0, -71.0, 0.0)
		event.set_object_handle_position(4, 6000.0, 2400.0, 5548.1)
		event.set_object_handle_rotation(4, 0.2, -1.77, 0.0)
		event.set_camera_sequence_position(0.0, 95.11, 4837.34)
		event.set_camera_sequence_look_at(6000.0, 2400.0, 5548.1)
		event.play_sound_effect(sound_bank, 0)
		event.fade_in_screen(30)
		event.rotate_object_sequence_eased(4, 0.0, -1.57, 0.0, 60, 2, 1.0)
		i = 0
		while i < 90 do
			resume_step = 6
			vm.wait(6)
			do
				local out1, out2, out3 = event.get_object_handle_position(4)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(-790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(-254.5 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(vm.f32(3348.1) - pos_z) / 16.0))
			event.set_object_handle_position(4, pos_x, pos_y, pos_z)
			event.set_camera_sequence_look_at(pos_x, pos_y, pos_z)
			i = i + 1
		end
		event.move_object_sequence_eased(4, -790.0, -254.5, 3348.1, 30, 2, 1.0)
		event.move_camera_sequence_look_at(0.0, 102.15, 3577.24, 60)
		event.rotate_object_sequence(4, 0.0, -1.57, 0.0, 30)
		bounce_amplitude = 2.0
		i = 0
		while i < 30 do
			do
				local out1, out2, out3 = event.get_object_handle_position(4)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			if vm.imod(i, 2) == 0 then
				pos_y = vm.f32(pos_y + bounce_amplitude)
			else
				pos_y = vm.f32(pos_y - bounce_amplitude)
			end
			bounce_amplitude = vm.f32(bounce_amplitude - vm.f32(bounce_amplitude / 30.0))
			event.set_object_handle_position(4, pos_x, pos_y, pos_z)
			i = i + 1
			resume_step = 7
			vm.wait(7)
		end
		resume_step = 8
		object.wait_until_done(4)
		resume_step = 9
		camera.wait_until_done()
		resume_step = 10
		wait.frames(60)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_camera_sequence_follow_object(0, 0.0, 25.0, 0.0, -3.12, -10.0, 70.0)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "歩き")
		event.set_object_sequence_position(1, -20.0, -268.4, 2550.0)
		event.set_object_sequence_rotation(1, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(0, 0.0, -268.4, 2550.0)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(2, 20.0, -268.4, 2550.0)
		event.set_object_sequence_rotation(2, 0.0, -3.12, 0.0)
		event.move_object_sequence(0, 0.0, -268.4, 2450.0, 60, 1)
		event.move_object_sequence(1, -20.0, -268.4, 2450.0, 60, 1)
		event.move_object_sequence(2, 20.0, -268.4, 2450.0, 60, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 11
		message.show_voiced_for(6160130, -1)
		event.reset_mouth_texture_animations()
		resume_step = 12
		wait.frames(30)
		event.release_camera_sequence_follow_object()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(581.19, 1481.15, 2239.69, 100.38, -155.85, 234.68)
		event.add_camera_sequence_path_point(855.1, 1481.15, 2395.2, 100.38, -155.85, 234.68)
		event.start_camera_sequence_path()
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 240)
		event.add_object_sequence_path_point(0, 0.0, -118.38, 1388.15)
		event.add_object_sequence_path_point(0, 0.0, -79.03, 1037.78)
		event.start_object_sequence_path(0, 1)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 240)
		event.add_object_sequence_path_point(1, -20.0, -118.38, 1388.15)
		event.add_object_sequence_path_point(1, -20.0, -79.03, 1037.78)
		event.start_object_sequence_path(1, 1)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 240)
		event.add_object_sequence_path_point(2, 20.0, -118.38, 1388.15)
		event.add_object_sequence_path_point(2, 20.0, -79.03, 1037.78)
		event.start_object_sequence_path(2, 1)
		resume_step = 13
		message.show_voiced_for(6160140, -1)
		resume_step = 14
		message.show_voiced_for(6160150, -1)
		resume_step = 15
		wait.frames(30)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_footstep_sound(13, 2)
		event.set_camera_sequence_position(5.17, 166.7, 673.45)
		event.set_camera_sequence_look_at(0.43, 32.65, 49.45)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 200)
		event.add_object_sequence_path_point(0, -11.19, -13.08, 430.16)
		event.add_object_sequence_path_point(0, 13.82, -7.06, 230.85)
		event.add_object_sequence_path_point(0, 57.64, -7.06, 139.2)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 220)
		event.add_object_sequence_path_point(1, -25.21, -13.07, 432.0)
		event.add_object_sequence_path_point(1, -23.57, -9.29, 250.9)
		event.add_object_sequence_path_point(1, -36.33, -7.06, 152.97)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 240)
		event.add_object_sequence_path_point(2, 39.42, -13.09, 422.23)
		event.add_object_sequence_path_point(2, 6.38, -13.28, 301.26)
		event.add_object_sequence_path_point(2, -3.42, -7.89, 248.04)
		event.add_object_sequence_path_point(2, 0.66, -7.06, 171.52)
		event.start_object_sequence_path(2)
		resume_step = 16
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 1)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 17
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 18
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "立ち")
		resume_step = 19
		message.show_voiced(6160160)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_camera_sequence_position(30.32, 33.53, 321.43)
		event.set_camera_sequence_look_at(-19.91, 9.23, 144.84)
		event.set_character_position(39, -2.0, -3.77, 210.36)
		event.set_character_rotation(39, 0.0, 3.05, 0.0)
		event.set_character_position(40, -2.0, -3.77, 210.36)
		event.set_character_rotation(40, 0.0, 3.05, 0.0)
		event.set_object_sequence_position(1, -32.3, -7.06, 187.68)
		event.set_object_sequence_rotation(1, 0.0, 0.83, 0.0)
		event.set_object_sequence_position(0, 28.47, -7.06, 175.02)
		event.set_object_sequence_rotation(0, 0.0, -0.49, 0.0)
		event.set_object_sequence_position(2, -3.65, -7.06, 218.56)
		event.set_object_sequence_rotation(2, 0.0, 3.05, 0.0)
		event.set_object_sequence_motion(0, "下見立ち")
		event.set_object_sequence_motion(1, "下見立ち")
		event.play_sound_effect(sound_bank, 2)
		event.set_object_sequence_motion(2, "装置置く", 6)
		event.queue_object_sequence_next_motion(2, "装置置くループ", 4)
		resume_step = 20
		wait.frames(60)
		event.set_object_sequence_motion(2, "装置置く戻り", 6)
		resume_step = 21
		object.wait_until_done(2)
		event.set_character_active(1, 39)
		event.set_character_active(1, 40)
		event.play_sound_effect(sound_bank, 3)
		event.set_character_motion(40, "現れる", 6, -1, 1)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		resume_step = 22
		wait.frames(30)
		event.set_character_active(0, 38)
		event.set_character_active(1, 41)
		event.set_object_sequence_position(6, -2.0, 5.2, 210.36)
		event.set_object_sequence_rotation(6, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_camera_sequence_position(25.82, 26.72, 190.12)
		event.set_camera_sequence_look_at(-1.98, 29.58, 205.98)
		event.set_mouth_texture_animations(6, "口パク")
		resume_step = 23
		message.show_voiced(6160170)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(25.82, 26.72, 190.12, -1.98, 29.58, 205.98)
		event.add_camera_sequence_path_point(-28.98, 26.72, 187.0, -1.98, 29.58, 205.98)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(6, "口パク")
		resume_step = 24
		message.show_voiced(6160180)
		event.reset_mouth_texture_animations()
		resume_step = 25
		camera.wait_until_done()
		event.set_mouth_texture_animations(6, "口パク")
		resume_step = 26
		message.show_voiced(6160190)
		event.reset_mouth_texture_animations()
		resume_step = 27
		wait.frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(20.07, 36.4, 255.98)
		event.set_camera_sequence_look_at(-5.23, 17.06, 110.89)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 28
		message.show_voiced(6160200)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "口パク")
		resume_step = 29
		message.show_voiced(6160210)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(20.07, 36.4, 255.98, -5.23, 17.06, 110.89)
		event.add_camera_sequence_path_point(-24.67, 36.4, 257.05, -5.23, 17.06, 110.89)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 30
		message.show_voiced(6160220)
		event.reset_mouth_texture_animations()
		resume_step = 31
		camera.wait_until_done()
		event.set_mouth_texture_animations(6, "口パク")
		resume_step = 32
		message.show_voiced(6160230)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_step = 33
		message.show_voiced(6160240)
		event.reset_mouth_texture_animations()
		resume_step = 34
		wait.frames(15)
		event.set_character_active(1, 38)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(800)
		event.add_camera_sequence_path_point(-17.0, 360.21, 536.27, -2.0, 596.27, 210.36)
		event.add_camera_sequence_path_point(-17.0, 142.48, 536.27, -2.0, 17.1, 210.36)
		event.start_camera_sequence_path()
		resume_step = 35
		message.show_voiced_for(6160250, -1)
		resume_step = 36
		message.show_voiced_for(6160255, -1)
		resume_step = 37
		message.show_voiced_for(6160260, -1)
		resume_step = 38
		message.show_voiced_for(6160270, -1)
		resume_step = 39
		message.show_voiced_for(6160275, -1)
		resume_step = 40
		message.show_voiced_for(6160280, -1)
		resume_step = 41
		message.show_voiced(6160290)
		resume_step = 42
		wait.frames(30)
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(24, 128, 128, 128, 128, 30)
		resume_step = 43
		message.show_voiced(6160300)
		resume_step = 44
		message.show_voiced(6160305)
		event.clear_camera_sequence_path()
		event.clear_camera_sequence()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(20.07, 36.4, 255.98)
		event.set_camera_sequence_look_at(-5.23, 17.06, 110.89)
		resume_step = 45
		vm.wait(45)
		event.set_object_sequence_color(24, 128, 128, 128, 0, 30)
		resume_step = 46
		wait.frames(30)
		resume_step = 47
		message.show_voiced(6160310)
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		resume_step = 48
		wait.frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(0.0, 140.0, 0.0, -229.22, 17.06, 307.42)
		event.add_camera_sequence_path_point(0.0, 140.0, 0.0, -276.98, 17.06, -272.13)
		event.start_camera_sequence_path()
		resume_step = 49
		message.show_voiced(6160320)
		resume_step = 50
		message.show_voiced(6160330)
		resume_step = 51
		camera.wait_until_done()
		resume_step = 52
		wait.frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(0.0, 140.0, 0.0, 236.12, 17.06, -313.37)
		event.add_camera_sequence_path_point(0.0, 140.0, 0.0, 282.78, 17.06, 279.16)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		resume_step = 53
		message.show_voiced(6160340)
		resume_step = 54
		message.show_voiced(6160350)
		resume_step = 55
		camera.wait_until_done()
		resume_step = 56
		wait.frames(30)
		event.set_camera_sequence_position(-1.43, 44.53, 179.99)
		event.set_camera_sequence_look_at(-2.0, 29.91, 210.36)
		event.set_mouth_texture_animations(6, "口パク")
		resume_step = 57
		message.show_voiced(6160360)
		event.reset_mouth_texture_animations()
		resume_step = 58
		wait.frames(30)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(20, 128, 128, 128, 128, 30)
		resume_step = 59
		message.show_voiced(6160370)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_object_sequence_color(21, 128, 128, 128, 128, 30)
		resume_step = 60
		message.show_voiced(6160373)
		event.set_event_sprite_draw_pass(2, 1)
		event.set_object_sequence_color(22, 128, 128, 128, 128, 30)
		resume_step = 61
		message.show_voiced(6160377)
		event.set_event_sprite_draw_pass(3, 1)
		event.set_object_sequence_color(23, 128, 128, 128, 128, 30)
		resume_step = 62
		wait.frames(60)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_object_sequence_color(23, 128, 128, 128, 0, 30)
		event.set_camera_sequence_position(-1.02, 0.96, 158.0)
		event.set_camera_sequence_look_at(-2.0, 21.86, 210.36)
		event.set_mouth_texture_animations(6, "口パク")
		resume_step = 63
		message.show_voiced(6160380)
		event.reset_mouth_texture_animations()
		resume_step = 64
		wait.frames(30)
		event.set_character_active(1, 38)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_camera_sequence_position(625.14, 908.7, 665.85)
		event.set_camera_sequence_look_at(-3.77, 13.41, -2.77)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -32.3, -7.06, 187.68)
		event.add_object_sequence_path_point(1, -11.34, -7.06, 108.48)
		event.add_object_sequence_path_point(1, -9.03, -7.06, 99.73)
		event.start_object_sequence_path(1, 1)
		resume_step = 65
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(0, 25.73, -7.06, 162.26)
		event.set_object_sequence_rotation(0, 0.0, -2.65, 0.0)
		event.set_camera_sequence_position(-198.14, 96.68, 321.01)
		event.set_camera_sequence_look_at(-28.92, 35.2, 133.4)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -8.28, -7.06, 120.98)
		event.add_object_sequence_path_point(1, -5.01, -7.06, 90.55)
		event.add_object_sequence_path_point(1, -2.73, 3.81, 72.64)
		event.add_object_sequence_path_point(1, -1.59, 3.81, 44.63)
		event.start_object_sequence_path(1, 1)
		resume_step = 66
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 67
		wait.frames(30)
		event.set_object_sequence_motion(1, "覗きこみ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		resume_step = 68
		object.wait_until_done(1)
		event.rotate_object_sequence(1, 0.0, -1.98, 0.0, 10)
		resume_step = 69
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "歩き")
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -1.59, 3.81, 44.63)
		event.add_object_sequence_path_point(1, -55.75, 3.81, 20.86)
		event.start_object_sequence_path(1)
		resume_step = 70
		object.wait_until_done(1)
		event.rotate_object_sequence(1, 0.0, 3.12, 0.0, 10)
		resume_step = 71
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 72
		wait.frames(30)
		event.set_object_sequence_motion(1, "触れる", 2)
		event.queue_object_sequence_next_motion(1, "触れるL", 4)
		resume_step = 73
		object.wait_until_done(1)
		event.play_sound_effect(sound_bank, 4)
		event.set_object_handle_frame_visible(10, "", 1)
		resume_step = 74
		wait.frames(30)
		event.set_object_sequence_position(0, 5.82, -7.06, 132.65)
		event.set_camera_sequence_position(-74.97, 23.62, 244.3)
		event.set_camera_sequence_look_at(-15.01, 35.2, 88.03)
		event.set_object_sequence_motion(1, "ユリス見", 2)
		event.queue_object_sequence_next_motion(1, "ユリス見L", 4)
		resume_step = 75
		object.wait_until_done(1)
		resume_step = 76
		wait.frames(30)
		event.set_object_sequence_motion(0, "歩き")
		event.rotate_object_sequence(0, 0.0, 2.77, 0.0, 10)
		resume_step = 77
		object.wait_until_done(0)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 120)
		event.add_object_sequence_path_point(0, 5.82, -7.06, 132.65)
		event.add_object_sequence_path_point(0, 22.37, -7.06, 90.22)
		event.add_object_sequence_path_point(0, 28.16, 3.81, 76.4)
		event.add_object_sequence_path_point(0, 55.75, 3.81, 20.86)
		event.start_object_sequence_path(0)
		resume_step = 78
		object.wait_until_done(0)
		event.rotate_object_sequence(0, 0.0, 3.12, 0.0, 10)
		resume_step = 79
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "立ち")
		resume_step = 80
		wait.frames(30)
		event.set_object_sequence_motion(0, "柱をさわる", 6)
		event.queue_object_sequence_next_motion(0, "柱をさわるL", 4)
		resume_step = 81
		object.wait_until_done(0)
		event.set_object_handle_frame_visible(11, "", 1)
		event.play_sound_effect(sound_bank, 4)
		resume_step = 82
		wait.frames(30)
		event.set_camera_sequence_position(-254.77, 157.73, -140.36)
		event.set_camera_sequence_look_at(17.9, 3.44, 114.28)
		event.set_object_sequence_motion(1, "触れるL", 4)
		event.set_object_sequence_position(2, -30.16, -7.06, 211.83)
		event.set_object_sequence_rotation(2, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		resume_step = 83
		wait.frames(30)
		frame = 0
		event.set_object_sequence_motion(0, "びっくり", 6)
		event.queue_object_sequence_next_motion(0, "びっくりL", 4)
		event.play_sound_effect(sound_bank, 5)
		while frame < 300 do
			do
				local out1, out2, out3 = event.get_character_position(monica_slot)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			radius = event.get_vector_length(offset_x, offset_y, offset_z) or radius
			angle = event.get_arc_tangent(offset_x, offset_z) or angle
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			event.set_character_position(monica_slot, x, y, z)
			event.offset_character_rotation(monica_slot, 0.0, 0.020933334, 0.0)
			do
				local out1, out2, out3 = event.get_character_position(max_slot)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			radius = event.get_vector_length(offset_x, offset_y, offset_z) or radius
			angle = event.get_arc_tangent(offset_x, offset_z) or angle
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			event.set_character_position(max_slot, x, y, z)
			event.offset_character_rotation(max_slot, 0.0, 0.020933334, 0.0)
			do
				local out1, out2, out3 = event.get_object_handle_position(8)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = event.get_object_handle_rotation(8)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			radius = event.get_vector_length(offset_x, offset_y, offset_z) or radius
			angle = event.get_arc_tangent(offset_x, offset_z) or angle
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			event.set_object_handle_position(8, x, y - vm.f32(0.15166667), z)
			event.set_object_handle_rotation(8, rot_x, rot_y + vm.f32(0.020933334), rot_z)
			do
				local out1, out2, out3 = event.get_object_handle_position(9)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = event.get_object_handle_rotation(9)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			radius = event.get_vector_length(offset_x, offset_y, offset_z) or radius
			angle = event.get_arc_tangent(offset_x, offset_z) or angle
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			event.set_object_handle_position(9, x, y - vm.f32(0.15166667), z)
			event.set_object_handle_rotation(9, rot_x, rot_y + vm.f32(0.020933334), rot_z)
			do
				local out1, out2, out3 = event.get_object_handle_position(7)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = event.get_object_handle_rotation(7)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			radius = event.get_vector_length(offset_x, offset_y, offset_z) or radius
			angle = event.get_arc_tangent(offset_x, offset_z) or angle
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			event.set_object_handle_position(7, x, y + vm.f32(0.23666666), z)
			event.set_object_handle_rotation(7, rot_x, rot_y + vm.f32(0.020933334), rot_z)
			do
				local out1, out2, out3 = event.get_object_handle_position(14)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = event.get_object_handle_rotation(14)
				rot_x = out1 or rot_x
				rot_y = out2 or rot_y
				rot_z = out3 or rot_z
			end
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			radius = event.get_vector_length(offset_x, offset_y, offset_z) or radius
			angle = event.get_arc_tangent(offset_x, offset_z) or angle
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			event.set_object_handle_position(14, x, y, z)
			event.set_object_handle_rotation(14, rot_x, rot_y + vm.f32(0.020933334), rot_z)
			frame = frame + 1
			resume_step = 84
			vm.wait(84)
		end
		resume_step = 85
		wait.frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_rotation(1, 0.0, 1.27, 0.0)
		event.set_camera_sequence_position(0.0, 38.4, 184.95)
		event.set_camera_sequence_look_at(0.0, 47.52, 19.95)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		resume_step = 86
		message.show_voiced(6160400)
		event.set_object_sequence_motion(1, "歩き")
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -55.82, 3.81, 20.68)
		event.add_object_sequence_path_point(1, -13.49, 3.81, 33.82)
		event.start_object_sequence_path(1)
		resume_step = 87
		object.wait_until_done(1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_position(1, 0.14, 3.81, 53.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.attach_character_to_frame(monica_slot, "item", 42)
		event.set_character_active(1, 42)
		event.set_object_sequence_position(11, 5.51, 34.53, 53.38)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(0.8, 51.44, 69.42)
		event.set_camera_sequence_look_at(2.22, 23.76, 49.14)
		event.pause_music()
		event.set_character_active(1, 43)
		event.set_object_sequence_motion(11, "発動", 6)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(special_sound_bank, 0)
		event.set_object_sequence_motion(1, "ゲット", 4)
		resume_step = 88
		inventory.announce_received(362, 1)
		resume_step = 89
		wait.frames(30)
		event.play_music(0)
		event.set_character_active(0, 42)
		event.set_character_active(0, 43)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.set_camera_sequence_position(-96.59, 8.53, 249.67)
		event.set_camera_sequence_look_at(33.2, 23.76, 157.73)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -14.5, -7.06, 117.32)
		event.add_object_sequence_path_point(1, -12.84, -7.06, 160.19)
		event.start_object_sequence_path(1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 90)
		event.add_object_sequence_path_point(0, 14.5, -7.06, 117.32)
		event.add_object_sequence_path_point(0, 12.84, -7.06, 160.19)
		event.start_object_sequence_path(0)
		resume_step = 90
		object.wait_until_done(0)
		resume_step = 91
		object.wait_until_done(1)
		event.turn_object_sequence_toward(0, -2.0, -7.06, 210.36, 10)
		event.turn_object_sequence_toward(1, -2.0, -7.06, 210.36, 10)
		resume_step = 92
		object.wait_until_done(0)
		resume_step = 93
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		resume_step = 94
		wait.frames(20)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		resume_step = 95
		message.show_voiced(6160410)
		resume_step = 96
		message.show_voiced(6160415)
		event.set_object_sequence_motion(0, "上向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		resume_step = 97
		message.show_voiced(6160420)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-0.69, 31.06, 181.32)
		event.set_camera_sequence_look_at(-2.0, 30.17, 210.36)
		event.set_mouth_texture_animations(6, "口パク")
		resume_step = 98
		message.show_voiced(6160430)
		event.set_character_motion(40, "消える", 6, -1, 1)
		event.set_character_visible(41, 0, 1, 0.05)
		event.play_sound_effect(sound_bank, 7)
		resume_step = 99
		wait.frames(30)
	end, function(received: { any }): boolean
		if resume_step <= 5 then
			cutscene.noop()
			reset_party_slots()
			i = 0
		end
		if resume_step <= 6 then
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(-790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(-254.5 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(vm.f32(3348.1) - pos_z) / 16.0))
			local _ = i < 90
			i = i + 1
			bounce_amplitude = 2.0
			i = 0
			pos_y = vm.f32(pos_y + bounce_amplitude)
			pos_y = vm.f32(pos_y - bounce_amplitude)
			bounce_amplitude = vm.f32(bounce_amplitude - vm.f32(bounce_amplitude / 30.0))
			local _ = i < 30
			local _ = vm.imod(i, 2) == 0
			i = i + 1
		end
		if resume_step <= 7 then
			cutscene.skip_command(4)
		end
		if resume_step <= 8 then
			wait.background_load_skipping()
		end
		if resume_step <= 9 then
			wait.frames_skipping(60)
		end
		if resume_step <= 10 then
			message.show_voiced_for_skipping(6160130, -1)
		end
		if resume_step <= 11 then
			wait.frames_skipping(30)
		end
		if resume_step <= 12 then
			message.show_voiced_for_skipping(6160140, -1)
		end
		if resume_step <= 13 then
			message.show_voiced_for_skipping(6160150, -1)
		end
		if resume_step <= 14 then
			wait.frames_skipping(30)
		end
		if resume_step <= 15 then
			cutscene.skip_command(0)
		end
		if resume_step <= 16 then
			cutscene.skip_command(1)
		end
		if resume_step <= 17 then
			cutscene.skip_command(2)
		end
		if resume_step <= 18 then
			message.show_voiced_skipping(6160160)
		end
		if resume_step <= 19 then
			wait.frames_skipping(60)
		end
		if resume_step <= 20 then
			cutscene.skip_command(2)
		end
		if resume_step <= 21 then
			wait.frames_skipping(30)
		end
		if resume_step <= 22 then
			message.show_voiced_skipping(6160170)
		end
		if resume_step <= 23 then
			message.show_voiced_skipping(6160180)
		end
		if resume_step <= 24 then
			wait.background_load_skipping()
		end
		if resume_step <= 25 then
			message.show_voiced_skipping(6160190)
		end
		if resume_step <= 26 then
			wait.frames_skipping(15)
		end
		if resume_step <= 27 then
			message.show_voiced_skipping(6160200)
		end
		if resume_step <= 28 then
			message.show_voiced_skipping(6160210)
		end
		if resume_step <= 29 then
			message.show_voiced_skipping(6160220)
		end
		if resume_step <= 30 then
			wait.background_load_skipping()
		end
		if resume_step <= 31 then
			message.show_voiced_skipping(6160230)
		end
		if resume_step <= 32 then
			message.show_voiced_skipping(6160240)
		end
		if resume_step <= 33 then
			wait.frames_skipping(15)
		end
		if resume_step <= 34 then
			message.show_voiced_for_skipping(6160250, -1)
		end
		if resume_step <= 35 then
			message.show_voiced_for_skipping(6160255, -1)
		end
		if resume_step <= 36 then
			message.show_voiced_for_skipping(6160260, -1)
		end
		if resume_step <= 37 then
			message.show_voiced_for_skipping(6160270, -1)
		end
		if resume_step <= 38 then
			message.show_voiced_for_skipping(6160275, -1)
		end
		if resume_step <= 39 then
			message.show_voiced_for_skipping(6160280, -1)
		end
		if resume_step <= 40 then
			message.show_voiced_skipping(6160290)
		end
		if resume_step <= 41 then
			wait.frames_skipping(30)
		end
		if resume_step <= 42 then
			message.show_voiced_skipping(6160300)
		end
		if resume_step <= 43 then
			message.show_voiced_skipping(6160305)
		end
		if resume_step <= 45 then
			wait.frames_skipping(30)
		end
		if resume_step <= 46 then
			message.show_voiced_skipping(6160310)
		end
		if resume_step <= 47 then
			wait.frames_skipping(30)
		end
		if resume_step <= 48 then
			message.show_voiced_skipping(6160320)
		end
		if resume_step <= 49 then
			message.show_voiced_skipping(6160330)
		end
		if resume_step <= 50 then
			wait.background_load_skipping()
		end
		if resume_step <= 51 then
			wait.frames_skipping(30)
		end
		if resume_step <= 52 then
			message.show_voiced_skipping(6160340)
		end
		if resume_step <= 53 then
			message.show_voiced_skipping(6160350)
		end
		if resume_step <= 54 then
			wait.background_load_skipping()
		end
		if resume_step <= 55 then
			wait.frames_skipping(30)
		end
		if resume_step <= 56 then
			message.show_voiced_skipping(6160360)
		end
		if resume_step <= 57 then
			wait.frames_skipping(30)
		end
		if resume_step <= 58 then
			message.show_voiced_skipping(6160370)
		end
		if resume_step <= 59 then
			message.show_voiced_skipping(6160373)
		end
		if resume_step <= 60 then
			message.show_voiced_skipping(6160377)
		end
		if resume_step <= 61 then
			wait.frames_skipping(60)
		end
		if resume_step <= 62 then
			message.show_voiced_skipping(6160380)
		end
		if resume_step <= 63 then
			wait.frames_skipping(30)
		end
		if resume_step <= 64 then
			cutscene.skip_command(1)
		end
		if resume_step <= 65 then
			cutscene.skip_command(1)
		end
		if resume_step <= 66 then
			wait.frames_skipping(30)
		end
		if resume_step <= 67 then
			cutscene.skip_command(1)
		end
		if resume_step <= 68 then
			cutscene.skip_command(1)
		end
		if resume_step <= 69 then
			cutscene.skip_command(1)
		end
		if resume_step <= 70 then
			cutscene.skip_command(1)
		end
		if resume_step <= 71 then
			wait.frames_skipping(30)
		end
		if resume_step <= 72 then
			cutscene.skip_command(1)
		end
		if resume_step <= 73 then
			wait.frames_skipping(30)
		end
		if resume_step <= 74 then
			cutscene.skip_command(1)
		end
		if resume_step <= 75 then
			wait.frames_skipping(30)
		end
		if resume_step <= 76 then
			cutscene.skip_command(0)
		end
		if resume_step <= 77 then
			cutscene.skip_command(0)
		end
		if resume_step <= 78 then
			cutscene.skip_command(0)
		end
		if resume_step <= 79 then
			wait.frames_skipping(30)
		end
		if resume_step <= 80 then
			cutscene.skip_command(0)
		end
		if resume_step <= 81 then
			wait.frames_skipping(30)
		end
		if resume_step <= 82 then
			wait.frames_skipping(30)
		end
		if resume_step <= 83 then
			frame = 0
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			center_x = 0.0
			center_z = 0.0
			offset_x = vm.f32(x - center_x)
			offset_z = vm.f32(z - center_z)
			rotated_x = vm.f32(center_x + vm.f32(radius * vm.sin(vm.f32(angle + vm.f32(0.020933334)))))
			rotated_z = vm.f32(center_z + vm.f32(radius * vm.cos(vm.f32(angle + vm.f32(0.020933334)))))
			x = rotated_x
			z = rotated_z
			local _ = frame < 300
			frame = frame + 1
		end
		if resume_step <= 84 then
			wait.frames_skipping(30)
		end
		if resume_step <= 85 then
			message.show_voiced_skipping(6160400)
		end
		if resume_step <= 86 then
			cutscene.skip_command(1)
		end
		if resume_step <= 87 then
			inventory.skip_announce_received(362, 1)
		end
		if resume_step <= 88 then
			wait.frames_skipping(30)
		end
		if resume_step <= 89 then
			cutscene.skip_command(0)
		end
		if resume_step <= 90 then
			cutscene.skip_command(1)
		end
		if resume_step <= 91 then
			cutscene.skip_command(0)
		end
		if resume_step <= 92 then
			cutscene.skip_command(1)
		end
		if resume_step <= 93 then
			wait.frames_skipping(20)
		end
		if resume_step <= 94 then
			message.show_voiced_skipping(6160410)
		end
		if resume_step <= 95 then
			message.show_voiced_skipping(6160415)
		end
		if resume_step <= 96 then
			message.show_voiced_skipping(6160420)
		end
		if resume_step <= 97 then
			message.show_voiced_skipping(6160430)
		end
		if resume_step <= 98 then
			wait.frames_skipping(30)
		end
		return true
	end)
	resume_step = 100
	vm.entry(100)
	event.cancel_drama_scene_skip()
	event.fade_out_music(30)
	event.fade_out_screen(30)
	resume_step = 101
	wait.frames(35)
	event.stop_music(0)
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.skip_next_music_load()
	unload_hologram_cutscene()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Handles an altar prompt and places the matching gem on the altar when the player has it.
local function examine_gem_altar(gem_item_id: s32)
	local placed_gems: s32 = 0
	local gem_bit: s32 = 0
	local prompt_state: s32 = 0
	local item: s32 = 0
	local wants_to_use: s32 = 0
	local sound_bank: s32 = 0
	local all_gems_mask: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	if gem_item_id == 365 then
		gem_bit = 1
	end
	if gem_item_id == 367 then
		gem_bit = 2
	end
	if gem_item_id == 366 then
		gem_bit = 4
	end
	if gem_item_id == 368 then
		gem_bit = 8
	end
	placed_gems = event.get_save_counter(16) or placed_gems
	if vm.i32(bit32.band(placed_gems, gem_bit)) ~= 0 then
		if gem_item_id == 365 then
			event.open_message_window_2(0, "La Pierre de terre brille")
		end
		if gem_item_id == 367 then
			event.open_message_window_2(0, "La Pierre de vent brille")
		end
		if gem_item_id == 366 then
			event.open_message_window_2(0, "La Pierre d'eau brille")
		end
		if gem_item_id == 368 then
			event.open_message_window_2(0, "La Pierre de feu brille")
		end
		message.show(0, -1, 8, 0, 0)
		return
	end
	prompt_state = event.get_triggered_event_data_2(6) or prompt_state
	if prompt_state == 1 then
		if gem_item_id == 365 then
			event.open_message_window_2(0, "Il y a un Autel de Pierre de terre.\n(Pour ouvrir le menu : (#))")
		end
		if gem_item_id == 367 then
			event.open_message_window_2(0, "Il y a un Autel de Pierre de vent.\n(Pour ouvrir le menu : (#))")
		end
		if gem_item_id == 366 then
			event.open_message_window_2(0, "Il y a un Autel de Pierre d'eau.\n(Pour ouvrir le menu : (#))")
		end
		if gem_item_id == 368 then
			event.open_message_window_2(0, "Il y a un Autel de Pierre de feu.\n(Pour ouvrir le menu : (#))")
		end
		wants_to_use = message.ask_confirmation(0, -1, 5, 256, 208, wants_to_use)
		if wants_to_use == 1 then
			prompt_state = 2
		end
	end
	if prompt_state == 2 then
		event.open_use_item_menu(gem_item_id)
		vm.wait(3)
		item = vmhost.used_item() or item
		if item > 0 then
			if item == gem_item_id then
				placed_gems = vm.i32(bit32.bor(placed_gems, gem_bit))
				event.set_save_counter(16, placed_gems)
				event.start_background_file_loads_1("snd2/sp/sp_033.sound.json")
				vm.wait(4)
				wait.background_load()
				sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or sound_bank
				event.play_sound_effect(sound_bank, 2)
				if gem_item_id == 365 then
					event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_10-m0")
				end
				if gem_item_id == 367 then
					event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_09-m1")
				end
				if gem_item_id == 366 then
					event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_08-m0")
				end
				if gem_item_id == 368 then
					event.attach_object_handle_to_map_part_3(0, "p01_s11", "s11_07-m0")
				end
				event.set_object_handle_visible(0, 1)
				all_gems_mask = 15
				if vm.i32(bit32.band(placed_gems, all_gems_mask)) == all_gems_mask then
					kazarov_stonehenge_s11.leave_for_s66()
				end
			else
				character.shake_head()
			end
		end
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

script.show_placed_gems = show_placed_gems
script[99] = script.show_placed_gems

--- Places the player on the platform and plays the arrival matching how they came.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local map_type: s32 = 0
	local train_station_counter: s32 = 0
	event.initialize_event()
	show_placed_gems()
	print("start_event--------------------------------------------\n")
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		kazarov_stonehenge_s11.spawn_platform_character()
		character.place_standing_and_reset_cloth(-40.0, vm.f32(-268.4), 3160.0, vm.f32(3.14))
		event.reset_follow_camera(1, 0.0, 10.0)
		event.fade_in_screen(30)
	else
		character.place_standing_and_reset_cloth(0.0, vm.f32(-268.4), 3000.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		old_map_no = event.get_previous_map() or old_map_no
		map_type = event.get_map_type(old_map_no) or map_type
		if map_type ~= -1 then
			train_station_counter = event.get_save_counter(1) or train_station_counter
			if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and train_station_counter == 6 then
				kazarov_stonehenge_s11.spawn_platform_character()
				kazarov_stonehenge_s11.play_arrival_for_train_id()
			else
				kazarov_stonehenge_s11.play_train_arrival()
				kazarov_stonehenge_s11.spawn_platform_character()
			end
		end
		event.set_character_motion(0, "立ち")
	end
end

--- Plays the leave prompt and then the hologram device cutscene.
function script.key_open()
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		ask_leave_stonehenge()
		resume_step = 2
		play_hologram_device_cutscene()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_hologram_device_cutscene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Asks to board a train and starts the matching departure.
function script.board_train()
	local answer: s32 = 0
	local train_route: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		answer = town_prompt.ask_enter_or_leave()
		if answer ~= 1 then
			return
		end
		event.set_save_counter(1, 6)
		train_route = event.get_triggered_event_data_2(3) or train_route
		if train_route <= 1 then
			resume_step = 2
			train.board_short_train()
			event.stop_music(0)
			resume_step = 3
			vm.wait(3)
			event.jump_to_map_2(-1, "s37")
			resume_step = 4
			vm.wait(4)
		else
			resume_step = 5
			train.board_train_via_gangway()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if resume_step <= 1 then
			if resume_step == 1 then
				answer = received[1] :: number
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 4 then
				train.board_train_via_gangway_skipping()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.board_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Gives the key item, plays the hologram cutscene and goes to the next area.
function script.cutscene_receive_key_item()
	event.add_inventory_item(362, 1)
	play_hologram_device_cutscene()
	event.jump_to_map_3(-1, "s37", 530)
	vm.wait(2)
end
script[502] = script.cutscene_receive_key_item

--- Places the player on the platform and fades in.
function script.enter_platform_after_cutscene()
	show_placed_gems()
	kazarov_stonehenge_s11.spawn_platform_character()
	character.place_standing_and_reset_cloth(170.0, vm.f32(-268.4), 3140.0, vm.f32(3.14))
	event.reset_follow_camera(1, 0.0, 0.0)
	event.fade_in_screen(30)
end
script[510] = script.enter_platform_after_cutscene

--- Plays Osmond's departure and goes to the next area.
function script.cutscene_osmond_departure()
	kazarov_stonehenge_s11.play_osmond_departure()
	event.jump_to_map_3(-1, "s12", 500)
	vm.wait(2)
end
script[520] = script.cutscene_osmond_departure

--- Examines the Earth Gem altar.
function script.examine_earth_gem_altar()
	examine_gem_altar(365)
end
script[550] = script.examine_earth_gem_altar

--- Examines the Wind Gem altar.
function script.examine_wind_gem_altar()
	examine_gem_altar(367)
end
script[552] = script.examine_wind_gem_altar

--- Examines the Water Gem altar.
function script.examine_water_gem_altar()
	examine_gem_altar(366)
end
script[554] = script.examine_water_gem_altar

--- Examines the Fire Gem altar.
function script.examine_fire_gem_altar()
	examine_gem_altar(368)
end
script[556] = script.examine_fire_gem_altar

--- Places the player on the platform, resolves inventory overflow and fades in.
function script.enter_platform_after_item_overflow()
	show_placed_gems()
	kazarov_stonehenge_s11.spawn_platform_character()
	character.place_standing_and_reset_cloth(170.0, vm.f32(-268.4), 3140.0, vm.f32(3.14))
	event.reset_follow_camera(1, 0.0, 0.0)
	inventory.resolve_overflow_alt(0)
	event.fade_in_screen(30)
end
script[599] = script.enter_platform_after_item_overflow

--- Asks whether to leave when the party is ready, or announces that the other party is waiting outside.
function script.talk_to_npc()
	local npc_id: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	if npc_id == 301 then
		flag = event.get_save_flag(640) or flag
		flag_2 = event.get_save_flag(648) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			if ask_leave_stonehenge() ~= 0 then
				event.fade_out_screen(30)
				wait.frames(30)
				event.jump_to_map_3(-1, "s37", 520)
				vm.wait(3)
			end
			return
		end
		town_prompt.say_waiting_outside()
	end
end
script[1000] = script.talk_to_npc

return script
