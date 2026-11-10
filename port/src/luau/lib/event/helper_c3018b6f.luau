--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_b52ffc81 = require("@lib/event/helper_b52ffc81")
local helper_bbae31fd = require("@lib/event/helper_bbae31fd")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_c3018b6f(
	world_coord_pos: f32,
	world_coord_pos_2: f32,
	world_coord_pos_3: f32,
	world_coord_rot: f32,
	arg4: s32,
	arg5: s32
)
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var17: s32 = 0
	local active_chr_no_2: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_character_motion(0, "立ち")
		if arg4 == 0 then
			event.start_background_file_loads_2("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
		end
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		at = 1
		wait_camera()
		event.enable_drama_skip()
		event.set_drama_skip_button(20)
		event.set_drama_skip_fade_color(255.0, 255.0, 255.0)
		event.set_character_visible(120, 0)
		event.set_character_visible(121, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
		at = 2
		helper_479dc9e9()
		if arg4 == 0 then
			event.load_character(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
			event.set_character_active(35)
			event.set_scene_character_type(35, 4)
			event.attach_object_handle_to_character(3, 35)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_sequence_position(3, 0.0, 70.0, 0.0)
			event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
			event.load_character(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
			event.set_character_active(36)
			event.set_scene_character_type(36, 4)
			event.attach_object_handle_to_character(4, 36)
			event.clear_object_sequence(4)
			event.set_object_sequence_object(4, 4)
			event.set_object_sequence_position(4, 0.0, 0.88, 0.0)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		else
			event.load_character(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
			event.set_character_active(35)
			event.set_scene_character_type(35, 4)
			event.attach_object_handle_to_character(3, 35)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_sequence_position(3, 0.0, 70.0, 0.0)
			event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
			event.load_character(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
			event.set_character_active(36)
			event.set_scene_character_type(36, 4)
			event.attach_object_handle_to_character(4, 36)
			event.clear_object_sequence(4)
			event.set_object_sequence_object(4, 4)
			event.set_object_sequence_position(4, 0.0, 0.88, 0.0)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		end
		now_party_chara_id = event.get_party_npc() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.load_npc_character(0, 5, now_party_chara_id, 34)
			event.set_character_active(34)
			event.attach_object_handle_to_character(2, 34)
			event.set_object_handle_position(2, 23.24, 0.0, -46.31)
			event.set_object_handle_rotation(2, 0.0, -0.44, 0.0)
			event.set_object_handle_texture_animation(2, 0)
		end
		if arg5 ~= 0 then
			active_chr_no = event.get_playable_character() or active_chr_no
			if active_chr_no == 1 then
				event.get_equipped_item(0, 2)
				event.get_equipped_item(0, 3)
				event.get_equipped_item(0, 4)
			end
			if active_chr_no == 0 then
				event.get_equipped_item(1, 2)
				event.get_equipped_item(1, 3)
				event.get_equipped_item(1, 4)
			end
			if active_chr_no == 1 then
				event.load_character_motion_pack(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
				event.set_character_active(0)
				event.attach_object_handle_to_character(0, 0)
				event.load_character(5, "chara/c01_base.gltf", "info", 33)
				event.set_character_active(33)
				event.attach_object_handle_to_character(1, 33)
				event.load_equipment_model(5, 0, 4, "info", 33)
				event.load_equipment_model(5, 0, 3, "info", 33)
				event.load_equipment_model(5, 0, 2, "info", 33, 37)
				event.set_character_active(37)
				event.attach_object_handle_to_character(5, 37)
			end
			if active_chr_no == 0 then
				event.load_character(5, "chara/c02_base.gltf", "info", 32)
				event.set_character_active(32)
				event.attach_object_handle_to_character(0, 32)
				event.load_equipment_model(5, 1, 4, "info", 32)
				event.load_equipment_model(5, 1, 3, "info", 32)
				event.load_equipment_model(5, 1, 2, "info", 32, 37)
				event.load_character_motion_pack(5, "event/time_gate/blue/c02a_warp.gltf", "info", 32)
				event.set_character_active(37)
				event.attach_object_handle_to_character(5, 37)
				event.set_character_active(0)
				event.attach_object_handle_to_character(1, 0)
			end
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 3.19, 0.0, -55.28)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4, 0.02)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_handle_position(1, -23.79, 0.0, -39.77)
			event.set_object_handle_rotation(1, 0.0, 0.64, 0.0)
			event.set_object_handle_motion(1, "立ち", 0.02)
		else
			event.get_equipped_item(1, 2)
			event.get_equipped_item(1, 3)
			event.get_equipped_item(1, 4)
			event.load_character_motion_pack(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 3.19, 0.0, -55.28)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4, 0.02)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
		end
		flag = event.get_save_flag(612) or flag
		if flag ~= 0 then
			var12 = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or var12
		else
			var13 = event.load_sound_effect_file_3(8, "snd2/sp/sp_013.sound.json") or var13
		end
		if arg4 == 0 then
			event.start_background_file_loads_2("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/red/atora_shine2.chr", "event/time_gate/red/atora_glare2.chr")
		end
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		if flag ~= 0 then
			event.play_sound_effect(var12, 0)
		else
			event.play_sound_effect(var13, 0)
			at = 3
			wait_frames(20)
		end
		event.fade_in_screen(30)
		if flag ~= 0 then
			event.set_camera_sequence_position(21.59, 19.4, 49.13)
			event.set_camera_sequence_look_at(3.27, 21.44, 1.91)
		else
			event.set_camera_sequence_position(-1.62, 25.82, 35.3)
			event.set_camera_sequence_look_at(-0.26, 22.33, -0.02)
		end
		event.set_object_sequence_motion(0, "タイムワープ", 6)
		event.queue_object_sequence_next_motion(0, "タイムワープL", 5)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目を閉じる")
		event.set_object_sequence_texture_animation(0, 1, "すまし口")
		at = 4
		wait_objects(0)
		at = 5
		helper_479dc9e9()
		if arg4 == 0 then
			event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
		else
			event.load_character(5, "event/time_gate/red/atora_shine2.chr", "info", 38)
		end
		if flag ~= 0 then
			event.set_character_active(0, 38)
		else
			event.set_character_active(1, 38)
		end
		event.set_scene_character_type(38, 4)
		event.attach_object_handle_to_character(6, 38)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "atoramiria")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_sequence_position(6, pos_x + vm.f32(0.18), pos_y + vm.f32(0.02), pos_z + vm.f32(0.3))
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		var17 = event.get_equipped_item(1, 4) or var17
		if var17 == 263 then
			print("pumpkin---------------------------\n")
			event.set_object_sequence_position(6, -0.35, 22.68, 1.67)
			event.set_object_sequence_rotation(6, 0.0, -6.33, 0.0)
		end
		if var17 == 264 then
			print("stripte -----------------------------\n")
			event.set_object_sequence_position(6, -0.48, 22.78, 2.07)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if var17 == 265 then
			event.set_object_sequence_position(6, -0.33, 22.73, 1.95)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if var17 == 266 then
			print("princess-----------------------------\n")
			event.set_object_sequence_position(6, -0.42, 22.89, 1.99)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if var17 == 267 then
			print("separate----------------------------\n")
			event.set_object_sequence_position(6, -0.23, 23.26, 2.52)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		event.set_object_sequence_motion(0, "タイムワープL", 5)
		event.set_object_sequence_motion(6, "発動", 6)
		event.queue_object_sequence_next_motion(6, "発動L", 4)
		event.set_object_sequence_texture_animation(0, 0, "目を閉じる")
		event.set_object_sequence_texture_animation(0, 1, "閉じたまま")
		event.set_object_sequence_texture_animation(0, 1, "すまし口")
		if flag ~= 0 then
			event.play_sound_effect(var12, 2)
		end
		at = 6
		wait_objects(6)
		if arg4 == 0 then
			event.load_character(5, "event/time_gate/blue/atora_glare2.gltf", "info", 39)
		else
			event.load_character(5, "event/time_gate/red/atora_glare2.chr", "info", 39)
		end
		event.set_character_active(39)
		event.set_scene_character_type(39, 4)
		event.attach_object_handle_to_character(7, 39)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 0.88, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(-2.99, 25.82, 71.15)
		event.set_camera_sequence_look_at(-0.26, 22.33, 0.02)
		event.move_camera_sequence_eased(-7.1, 25.8, 178.24, -0.26, 45.36, 0.02, 90, 0, 0.4)
		event.set_object_sequence_scale(3, 2.8, 2.8, 2.8, 90)
		event.set_object_sequence_scale(4, 2.0, 2.0, 2.0, 90)
		event.set_object_sequence_scale(7, 2.0, 2.0, 2.0, 90)
		at = 7
		wait_frames(60)
		event.fade_out_screen(60, 255.0, 255.0, 255.0)
		at = 8
		wait_frames(60)
		at = 9
		helper_b52ffc81(0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			wait_frames_skipping(20)
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			helper_344d6cd8()
		end
		if at <= 5 then
			print("pumpkin---------------------------\n")
			print("stripte -----------------------------\n")
			print("princess-----------------------------\n")
			print("separate----------------------------\n")
			helper_238b5abc(6)
		end
		if at <= 6 then
			wait_frames_skipping(60)
		end
		if at <= 7 then
			wait_frames_skipping(60)
		end
		if at <= 8 then
			helper_bbae31fd(0)
		end
		return true
	end)
	at = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	if flag ~= 0 then
		event.stop_sound_effect(var12, 0)
	end
	event.fade_out_music(30)
	event.stop_sound_effect(var13, 0)
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	active_chr_no_2 = event.get_playable_character() or active_chr_no_2
	event.delete_character(37)
	if active_chr_no_2 == 1 then
		event.delete_character_extension_packs(0)
		event.delete_character(33)
	end
	if active_chr_no_2 == 0 then
		event.delete_character(32)
	end
	if now_party_chara_id ~= -1 then
		event.delete_character(34)
	end
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(39)
end

return helper_c3018b6f
