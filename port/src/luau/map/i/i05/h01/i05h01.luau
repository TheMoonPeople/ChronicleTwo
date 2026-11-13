--!strict
--- Event script for the i05h01 house interior, which plays the e305 cutscene when its save flags are set.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local i05_house_h01 = require("@lib/event/i05_house_h01")
local message = require("@lib/event/message")
local npc = require("@lib/event/npc")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Plays the e305 cutscene where the duck talks with the player and then updates the party NPC's status.
local function play_e305_cutscene()
	local sound_bank_id: s32 = 0
	local active_chr_no: s32 = 0
	local now_party_chara_id: s32 = 0
	local party_status: s32 = 0
	vm.section(function()
		event.fade_out_screen(0)
		event.set_save_flag(305, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(57)
		event.play_music(0)
		sound_bank_id = event.load_sound_effect_file_2(1249) or sound_bank_id
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
		event.set_object_handle_sound_bank(1, sound_bank_id)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(43.93, 53.83, 21.86)
		event.set_camera_sequence_look_at(-14.62, 23.71, 94.06)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(1, "振り向く", 2)
		event.queue_object_sequence_next_motion(1, "振り向くL", 4)
		object.wait_until_done(1)
		event.set_mouth_motions(1, "振り向く会話", 0, "振り向くL", 0)
		message.show_voiced(3050010)
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
		message.show_voiced(3050020)
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "会話2", 2)
		event.queue_object_sequence_next_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		message.show_voiced(3050030)
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 45.0, 0.0, 44.0, 60)
		event.rotate_object_sequence(0, 0.0, 1.57, 0.0, 14)
		wait.for_frame_count(10)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, 24.0, 0.0, 49.0, 50)
		event.rotate_object_sequence(1, 0.0, 1.8, 0.0, 8)
		wait.for_frame_count(20)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(2, 0.0, 0.0, 0.0, 255.0, 30)
		wait.for_frame_count(30)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_motion(0, "立ち", 4)
		event.play_sound_effect(sound_bank_id, 3)
		wait.for_frame_count(20)
		event.play_sound_effect(sound_bank_id, 4)
		wait.for_frame_count(20)
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
	i05_house_h01.show_party_npc_comment()
	vm.wait(15)
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	party_status = event.get_npc_party_status(now_party_chara_id) or party_status
	if bit32.band(party_status, 4) ~= 0 then
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

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = cutscene.noop

--- Plays the e305 cutscene on entry when its save flag is set and not yet finished, then leaves for map m05.
function script.default_event()
	local cutscene_ready_flag: s32 = 0
	local cutscene_done_flag: s32 = 0
	local npc_slot: s32 = 0
	cutscene_ready_flag = event.get_save_flag(304) or cutscene_ready_flag
	cutscene_done_flag = event.get_save_flag(305) or cutscene_done_flag
	if cutscene_ready_flag == 1 and cutscene_done_flag == 0 then
		npc_slot = event.find_scene_character_slot(6) or npc_slot
		event.set_villager_ai_enabled(0, npc_slot)
		event.set_character_active(0, npc_slot)
		play_e305_cutscene()
		event.set_villager_ai_enabled(1, npc_slot)
		event.set_character_active(1, npc_slot)
		event.go_to_outside_map(-1, "m05")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides the square-button handler with nothing.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = npc.talk_to_triggered_npc

--- Plays the e305 cutscene with the villager's AI paused.
function script.cutscene_e305()
	local npc_slot: s32 = 0
	npc_slot = event.find_scene_character_slot(6) or npc_slot
	event.set_villager_ai_enabled(0, npc_slot)
	event.set_character_active(0, npc_slot)
	play_e305_cutscene()
	event.set_villager_ai_enabled(1, npc_slot)
	event.set_character_active(1, npc_slot)
end
script[13050] = script.cutscene_e305

return script
