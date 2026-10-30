--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_c15328c3 = require("@lib/event/helper_c15328c3")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_6944feb4(
	world_coord_pos: f32,
	world_coord_pos_2: f32,
	world_coord_pos_3: f32,
	world_coord_rot: f32,
	arg4: s32,
	arg5: s32
)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		flag = event.get_save_flag(612) or flag
		event.set_character_motion(0, "立ち")
		if arg4 ~= 0 then
			event.start_background_file_loads_2("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
		end
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		wait_camera()
		helper_479dc9e9()
		event.enable_drama_skip()
		event.set_drama_skip_button(20)
		event.set_drama_skip_fade_color(255.0, 255.0, 255.0)
		event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
		event.set_character_visible(120, 0)
		event.set_character_visible(121, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if arg4 ~= 0 then
			event.load_character(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
			event.load_character(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
		else
			event.load_character(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
			event.load_character(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
		end
		event.set_character_active(35)
		event.set_scene_character_type(35, 4)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 70.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_character_active(36)
		event.set_scene_character_type(36, 4)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		now_party_chara_id = event.get_party_npc() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.load_npc_character(0, 5, now_party_chara_id, 34)
			event.set_character_active(34)
			event.attach_object_handle_to_character(2, 34)
			event.set_object_handle_position(2, 49.73999, 0.0, 8.969971)
			event.set_object_handle_rotation(2, 0.0, -1.76, 0.0)
		end
		if arg5 ~= 0 then
			active_chr_no = event.get_playable_character() or active_chr_no
			if active_chr_no == 0 then
				event.get_equipped_item(1, 2)
				event.get_equipped_item(1, 3)
				event.get_equipped_item(1, 4)
			end
			if active_chr_no == 1 then
				event.get_equipped_item(0, 2)
				event.get_equipped_item(0, 3)
				event.get_equipped_item(0, 4)
			end
			if active_chr_no == 0 then
				if flag ~= 0 then
					event.load_character_motion_pack(5, "event/e00/e80/e80_mints.gltf", "info", 0)
				else
					event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
				end
				event.set_character_active(0)
				event.attach_object_handle_to_character(0, 0)
				event.load_character(5, "chara/c02_base.gltf", "info", 33)
				event.set_character_active(33)
				event.attach_object_handle_to_character(1, 33)
				event.load_equipment_model(5, 1, 4, "info", 33)
				event.load_equipment_model(5, 1, 3, "info", 33)
				event.load_equipment_model(5, 1, 2, "info", 33, 37)
				event.set_character_active(37)
				event.attach_object_handle_to_character(5, 37)
				event.set_object_handle_visible(5, 1)
			end
			if active_chr_no == 1 then
				event.load_character(5, "chara/c01_base.gltf", "info", 32)
				if flag ~= 0 then
					event.load_character_motion_pack(5, "event/e00/e80/e80_mints.gltf", "info", 32)
				else
					event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
				end
				event.set_character_active(32)
				event.attach_object_handle_to_character(0, 32)
				event.load_equipment_model(5, 0, 4, "info", 32)
				event.load_equipment_model(5, 0, 3, "info", 32)
				event.load_equipment_model(5, 0, 2, "info", 32, 37)
				event.set_character_active(37)
				event.attach_object_handle_to_character(5, 37)
				event.set_object_handle_visible(5, 1)
				event.set_character_active(0)
				event.attach_object_handle_to_character(1, 0)
			end
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 38.0, 0.0, 22.0)
			event.set_object_sequence_rotation(0, 0.0, -2.12, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_handle_position(1, 18.619995, 0.0, 35.179993)
			event.set_object_handle_rotation(1, 0.0, -2.48, 0.0)
			event.set_object_handle_motion(1, "立ち", 0.02)
			event.reset_object_handle_dynamic_animation(1)
		else
			event.get_equipped_item(1, 2)
			event.get_equipped_item(1, 3)
			event.get_equipped_item(1, 4)
			event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/e500/e523/e523_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 38.0, 0.0, 22.0)
			event.set_object_sequence_rotation(0, 0.0, -2.12, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4)
			event.set_object_sequence_texture_animation(0, 0)
		end
		if flag ~= 0 then
			var12 = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or var12
		else
			var13 = event.load_sound_effect_file_3(8, "snd2/sp/sp_013.sound.json") or var13
		end
		if arg4 ~= 0 then
			event.start_background_file_loads_2("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
		end
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "旧・立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		if flag ~= 0 then
			event.play_sound_effect(var12, 0)
		else
			event.play_sound_effect(var13, 0)
			wait_frames(30)
		end
		event.fade_in_screen(30)
		if flag ~= 0 then
			event.set_camera_sequence_position(-56.29, 15.74, 3.56)
			event.set_camera_sequence_look_at(-12.65, 16.48, 2.06)
		else
			event.set_camera_sequence_position(-48.179993, 19.61, -28.70996)
			event.set_camera_sequence_look_at(-0.789978, 16.48, -0.05999756)
		end
		if arg5 == 0 and arg4 == 0 and flag == 0 then
			event.set_camera_sequence_position(-30.09, 19.5, 4.41)
			event.set_camera_sequence_look_at(-14.63, 21.71, 1.0)
		end
		event.set_object_sequence_motion(0, "タイムワープ", 6, 0.45)
		event.queue_object_sequence_next_motion(0, "タイムワープL", 4)
		event.set_object_sequence_texture_animation(0, 1, "開閉口")
		wait_objects(0)
		helper_479dc9e9()
		if arg4 ~= 0 then
			event.load_character(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
		else
			event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
		end
		if flag ~= 0 then
			event.set_character_active(0, 38)
		else
			event.set_character_active(1, 38)
		end
		event.attach_object_handle_to_character(6, 38)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "atoramiria")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		if arg4 ~= 0 then
			event.set_object_sequence_position(6, pos_x, pos_y, pos_z)
		else
			event.set_object_sequence_position(6, -3.54, 17.04, -1.46)
		end
		event.set_object_sequence_rotation(6, -0.45, -2.12, 0.0)
		event.set_camera_sequence_position(-21.5, 23.92, -12.580017)
		event.set_camera_sequence_look_at(-0.789978, 16.17, -0.05999756)
		event.set_object_sequence_texture_animation(0, 0, "開閉口")
		event.set_object_sequence_texture_animation(0, 1, "開き口")
		event.set_object_sequence_motion(0, "タイムワープL", 5)
		event.set_object_sequence_motion(6, "発動", 6)
		event.queue_object_sequence_next_motion(6, "発動L", 4)
		if flag == 0 then
			wait_objects(6)
		else
			event.play_sound_effect(var12, 2)
		end
		if arg4 ~= 0 then
			event.load_character(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
		else
			event.load_character(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
		end
		event.set_character_active(39)
		event.attach_object_handle_to_character(7, 39)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, -2.12, 0.0)
		event.set_camera_sequence_position(-40.590027, 19.47, -24.339966)
		event.set_camera_sequence_look_at(13.950012, 15.23, 9.190002)
		event.move_camera_sequence_eased(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
		event.set_object_sequence_scale(3, 2.8, 2.8, 2.8, 90)
		event.set_object_sequence_scale(4, 2.0, 2.0, 2.0, 90)
		event.set_object_sequence_scale(7, 2.0, 2.0, 2.0, 90)
		wait_frames(60)
		event.fade_out_screen(60, 255.0, 255.0, 255.0)
		wait_frames(60)
		helper_c15328c3(1)
	end)
	vm.entry(11)
	event.cancel_drama_scene_skip()
	if flag ~= 0 then
		event.stop_sound_effect(var12, 0)
	else
		event.stop_sound_effect(var13, 0)
	end
	event.fade_out_music(30)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.delete_character_extension_packs(0)
		event.delete_character(33)
	end
	if active_chr_no == 1 then
		event.delete_character(32)
	end
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.delete_character(34)
	end
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_character(39)
end

return helper_6944feb4
