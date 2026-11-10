--!strict
-- map/i/i05/h01/i05h01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_2b30a52e = require("@lib/event/helper_2b30a52e")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4e319702 = require("@lib/event/helper_4e319702")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_35e04()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local now_party_chara_id: s32 = 0
	local var3: s32 = 0
	vm.section(function()
		event.fade_out_screen(0)
		event.set_save_flag(305, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(57)
		event.play_music(0)
		var0 = event.load_sound_effect_file_2(1249) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.load_message_file(0, 5, "event/e300/e305/e305.txt")
		if active_chr_no ~= 0 then
			event.set_character_active(0, 0)
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.set_character_active(32)
			event.set_character_active(33)
			event.attach_object_handle_to_character(0, 32)
		else
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
		end
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/e300/e305/e305_duck.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(1, 34)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_color(0, 0, 0, 0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_position(0, 41.0, 0.0, 44.0)
		event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_position(1, -31.0, 0.0, 90.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "花見立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "目パチ")
		event.set_object_handle_sound_bank(1, var0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(43.93, 53.83, 21.86)
		event.set_camera_sequence_look_at(-14.62, 23.71, 94.06)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(1, "振り向く", 2)
		event.queue_object_sequence_next_motion(1, "振り向くL", 4)
		wait_objects(1)
		event.set_mouth_motions(1, "振り向く会話", 0, "振り向くL", 0)
		helper_4116e6bb(3050010)
		event.set_camera_sequence_position(29.17, 40.75, 148.74)
		event.set_camera_sequence_look_at(-14.4, 16.43, 33.37)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, -31.0, 0.0, 49.0, 40)
		event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 18)
		event.delay_object_sequence_rotation_track(1, 12)
		event.rotate_object_sequence(1, 0.0, 1.92, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -2.0, 0.0, 44.0, 50)
		event.delay_object_sequence_rotation_track(0, 40)
		event.rotate_object_sequence(0, 0.0, -1.11, 0.0, 10)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3050020)
		wait_objects(1)
		event.set_object_sequence_motion(1, "会話2", 2)
		event.queue_object_sequence_next_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		helper_4116e6bb(3050030)
		wait_objects(1)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 45.0, 0.0, 44.0, 60)
		event.rotate_object_sequence(0, 0.0, 1.57, 0.0, 14)
		helper_888ab2a3(10)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, 24.0, 0.0, 49.0, 50)
		event.rotate_object_sequence(1, 0.0, 1.8, 0.0, 8)
		helper_888ab2a3(20)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(2, 0.0, 0.0, 0.0, 255.0, 30)
		helper_888ab2a3(30)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_motion(0, "立ち", 4)
		event.play_sound_effect(var0, 3)
		helper_888ab2a3(20)
		event.play_sound_effect(var0, 4)
		helper_888ab2a3(20)
	end)
	event.cancel_drama_scene_skip()
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(2, 0.0, 0.0, 0.0, 128.0)
	event.fade_in_screen(0)
	helper_2b30a52e()
	vm.wait(15)
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	var3 = event.get_npc_party_status(now_party_chara_id) or var3
	if bit32.band(var3, 4) ~= 0 then
		event.set_npc_party_status(now_party_chara_id, 4)
	else
		event.set_npc_party_status(now_party_chara_id, 2)
	end
	event.set_npc_party_status(6, 128)
	event.set_npc_party_status(6, 1)
	event.set_event_sprite_draw_pass(0, 0)
	event.fade_out_screen(0)
	if active_chr_no ~= 0 then
		event.delete_character(32)
		event.delete_character(33)
	else
		event.delete_character_extension_packs(0)
	end
	event.delete_character(34)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	vm.wait(16)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	flag = event.get_save_flag(304) or flag
	flag_2 = event.get_save_flag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		var2 = event.find_scene_character_slot(6) or var2
		event.set_villager_ai_enabled(0, var2)
		event.set_character_active(0, var2)
		helper_35e04()
		event.set_villager_ai_enabled(1, var2)
		event.set_character_active(1, var2)
		event.go_to_outside_map(-1, "m05")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_4e319702

--- Event 13050, which map data, a script or the engine runs by number.
function script.event_13050()
	local var0: s32 = 0
	var0 = event.find_scene_character_slot(6) or var0
	event.set_villager_ai_enabled(0, var0)
	event.set_character_active(0, var0)
	helper_35e04()
	event.set_villager_ai_enabled(1, var0)
	event.set_character_active(1, var0)
end

return script
