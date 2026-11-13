--!strict
--- Italian text and flow for the time gate travel cutscenes.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local time_gate = {}

--- Plays the time gate cutscene that sends the party to the future with Atla's warp effect.
function time_gate.jump_to_future(
	world_x: f32,
	world_y: f32,
	world_z: f32,
	world_rotation: f32,
	is_red_gate: s32,
	with_both_characters: s32
)
	local ixion_flag: s32 = 0
	local party_npc: s32 = 0
	local playable_character: s32 = 0
	local ixion_sound: s32 = 0
	local warp_sound: s32 = 0
	local atla_frame_x: f32 = 0
	local atla_frame_y: f32 = 0
	local atla_frame_z: f32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		ixion_flag = event.get_save_flag(612) or ixion_flag
		event.set_character_motion(0, "立ち")
		if is_red_gate ~= 0 then
			event.start_background_file_loads_2("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
		end
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
		wait.background_load()
		event.enable_drama_skip()
		event.set_drama_skip_button(20)
		event.set_drama_skip_fade_color(255.0, 255.0, 255.0)
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		event.set_character_visible(120, 0)
		event.set_character_visible(121, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if is_red_gate ~= 0 then
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
		party_npc = event.get_party_npc() or party_npc
		if party_npc ~= -1 then
			event.load_npc_character(0, 5, party_npc, 34)
			event.set_character_active(34)
			event.attach_object_handle_to_character(2, 34)
			event.set_object_handle_position(2, 49.73999, 0.0, 8.969971)
			event.set_object_handle_rotation(2, 0.0, -1.76, 0.0)
		end
		if with_both_characters ~= 0 then
			playable_character = event.get_playable_character() or playable_character
			if playable_character == 0 then
				event.get_equipped_item(1, 2)
				event.get_equipped_item(1, 3)
				event.get_equipped_item(1, 4)
			end
			if playable_character == 1 then
				event.get_equipped_item(0, 2)
				event.get_equipped_item(0, 3)
				event.get_equipped_item(0, 4)
			end
			if playable_character == 0 then
				if ixion_flag ~= 0 then
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
			if playable_character == 1 then
				event.load_character(5, "chara/c01_base.gltf", "info", 32)
				if ixion_flag ~= 0 then
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
		if ixion_flag ~= 0 then
			ixion_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or ixion_sound
		else
			warp_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_013.sound.json") or warp_sound
		end
		if is_red_gate ~= 0 then
			event.start_background_file_loads_2("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
		end
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "旧・立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		if ixion_flag ~= 0 then
			event.play_sound_effect(ixion_sound, 0)
		else
			event.play_sound_effect(warp_sound, 0)
			wait.frames(30)
		end
		event.fade_in_screen(30)
		if ixion_flag ~= 0 then
			event.set_camera_sequence_position(-56.29, 15.74, 3.56)
			event.set_camera_sequence_look_at(-12.65, 16.48, 2.06)
		else
			event.set_camera_sequence_position(-48.179993, 19.61, -28.70996)
			event.set_camera_sequence_look_at(-0.789978, 16.48, -0.05999756)
		end
		if with_both_characters == 0 and is_red_gate == 0 and ixion_flag == 0 then
			event.set_camera_sequence_position(-30.09, 19.5, 4.41)
			event.set_camera_sequence_look_at(-14.63, 21.71, 1.0)
		end
		event.set_object_sequence_motion(0, "タイムワープ", 6, 0.45)
		event.queue_object_sequence_next_motion(0, "タイムワープL", 4)
		event.set_object_sequence_texture_animation(0, 1, "開閉口")
		object.wait_until_done(0)
		wait.background_load()
		if is_red_gate ~= 0 then
			event.load_character(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
		else
			event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
		end
		if ixion_flag ~= 0 then
			event.set_character_active(0, 38)
		else
			event.set_character_active(1, 38)
		end
		event.attach_object_handle_to_character(6, 38)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "atoramiria")
			atla_frame_x = out1 or atla_frame_x
			atla_frame_y = out2 or atla_frame_y
			atla_frame_z = out3 or atla_frame_z
		end
		if is_red_gate ~= 0 then
			event.set_object_sequence_position(6, atla_frame_x, atla_frame_y, atla_frame_z)
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
		if ixion_flag == 0 then
			object.wait_until_done(6)
		else
			event.play_sound_effect(ixion_sound, 2)
		end
		if is_red_gate ~= 0 then
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
		wait.frames(60)
		event.fade_out_screen(60, 255.0, 255.0, 255.0)
		wait.frames(60)
		time_gate.show_travel_caption(1)
	end)
	vm.entry(11)
	event.cancel_drama_scene_skip()
	if ixion_flag ~= 0 then
		event.stop_sound_effect(ixion_sound, 0)
	else
		event.stop_sound_effect(warp_sound, 0)
	end
	event.fade_out_music(30)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.delete_character_extension_packs(0)
		event.delete_character(33)
	end
	if playable_character == 1 then
		event.delete_character(32)
	end
	party_npc = event.get_party_npc() or party_npc
	if party_npc ~= -1 then
		event.delete_character(34)
	end
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_character(39)
end

--- Plays the red time gate jump to the future, staging both characters only when character 1 is in the party, then clears the world coordinate.
function time_gate.play_red_time_gate(world_x: f32, world_y: f32, world_z: f32, world_rotation: f32)
	local is_character_1_in_party: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		is_character_1_in_party = event.set_party_member(1) or is_character_1_in_party
		if is_character_1_in_party == 1 then
			resume_step = 1
			time_gate.jump_to_future(world_x, world_y, world_z, world_rotation, 1, 1)
		else
			resume_step = 2
			time_gate.jump_to_future(world_x, world_y, world_z, world_rotation, 1, 0)
		end
		event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				time_gate.jump_to_future(world_x, world_y, world_z, world_rotation, 1, 0)
				return vm.continue_with(function()
					event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the time gate cutscene that returns the party to the present with Atla's warp effect.
function time_gate.return_to_present(
	world_x: f32,
	world_y: f32,
	world_z: f32,
	world_rotation: f32,
	is_red_gate: s32,
	with_both_characters: s32
)
	local party_npc: s32 = 0
	local playable_character: s32 = 0
	local ixion_flag: s32 = 0
	local ixion_sound: s32 = 0
	local warp_sound: s32 = 0
	local atla_frame_x: f32 = 0
	local atla_frame_y: f32 = 0
	local atla_frame_z: f32 = 0
	local equipped_item: s32 = 0
	local cleanup_playable_character: s32 = 0
	local step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_character_motion(0, "立ち")
		if is_red_gate == 0 then
			event.start_background_file_loads_2("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
		end
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		step = 1
		camera.wait_until_done()
		event.enable_drama_skip()
		event.set_drama_skip_button(20)
		event.set_drama_skip_fade_color(255.0, 255.0, 255.0)
		event.set_character_visible(120, 0)
		event.set_character_visible(121, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		step = 2
		wait.background_load()
		if is_red_gate == 0 then
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
		party_npc = event.get_party_npc() or party_npc
		if party_npc ~= -1 then
			event.load_npc_character(0, 5, party_npc, 34)
			event.set_character_active(34)
			event.attach_object_handle_to_character(2, 34)
			event.set_object_handle_position(2, 23.24, 0.0, -46.31)
			event.set_object_handle_rotation(2, 0.0, -0.44, 0.0)
			event.set_object_handle_texture_animation(2, 0)
		end
		if with_both_characters ~= 0 then
			playable_character = event.get_playable_character() or playable_character
			if playable_character == 1 then
				event.get_equipped_item(0, 2)
				event.get_equipped_item(0, 3)
				event.get_equipped_item(0, 4)
			end
			if playable_character == 0 then
				event.get_equipped_item(1, 2)
				event.get_equipped_item(1, 3)
				event.get_equipped_item(1, 4)
			end
			if playable_character == 1 then
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
			if playable_character == 0 then
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
		ixion_flag = event.get_save_flag(612) or ixion_flag
		if ixion_flag ~= 0 then
			ixion_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or ixion_sound
		else
			warp_sound = event.load_sound_effect_file_3(8, "snd2/sp/sp_013.sound.json") or warp_sound
		end
		if is_red_gate == 0 then
			event.start_background_file_loads_2("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/red/atora_shine2.chr", "event/time_gate/red/atora_glare2.chr")
		end
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		if ixion_flag ~= 0 then
			event.play_sound_effect(ixion_sound, 0)
		else
			event.play_sound_effect(warp_sound, 0)
			step = 3
			wait.frames(20)
		end
		event.fade_in_screen(30)
		if ixion_flag ~= 0 then
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
		step = 4
		object.wait_until_done(0)
		step = 5
		wait.background_load()
		if is_red_gate == 0 then
			event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
		else
			event.load_character(5, "event/time_gate/red/atora_shine2.chr", "info", 38)
		end
		if ixion_flag ~= 0 then
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
			atla_frame_x = out1 or atla_frame_x
			atla_frame_y = out2 or atla_frame_y
			atla_frame_z = out3 or atla_frame_z
		end
		event.set_object_sequence_position(6, atla_frame_x + vm.f32(0.18), atla_frame_y + vm.f32(0.02), atla_frame_z + vm.f32(0.3))
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		equipped_item = event.get_equipped_item(1, 4) or equipped_item
		if equipped_item == 263 then
			print("pumpkin---------------------------\n")
			event.set_object_sequence_position(6, -0.35, 22.68, 1.67)
			event.set_object_sequence_rotation(6, 0.0, -6.33, 0.0)
		end
		if equipped_item == 264 then
			print("stripte -----------------------------\n")
			event.set_object_sequence_position(6, -0.48, 22.78, 2.07)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if equipped_item == 265 then
			event.set_object_sequence_position(6, -0.33, 22.73, 1.95)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if equipped_item == 266 then
			print("princess-----------------------------\n")
			event.set_object_sequence_position(6, -0.42, 22.89, 1.99)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if equipped_item == 267 then
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
		if ixion_flag ~= 0 then
			event.play_sound_effect(ixion_sound, 2)
		end
		step = 6
		object.wait_until_done(6)
		if is_red_gate == 0 then
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
		step = 7
		wait.frames(60)
		event.fade_out_screen(60, 255.0, 255.0, 255.0)
		step = 8
		wait.frames(60)
		step = 9
		time_gate.show_travel_caption(0)
	end, function(received: { any }): boolean
		if step <= 1 then
			wait.background_load_skipping()
		end
		if step <= 2 then
			wait.frames_skipping(20)
		end
		if step <= 3 then
			cutscene.skip_command(0)
		end
		if step <= 4 then
			wait.background_load_skipping()
		end
		if step <= 5 then
			print("pumpkin---------------------------\n")
			print("stripte -----------------------------\n")
			print("princess-----------------------------\n")
			print("separate----------------------------\n")
			cutscene.skip_command(6)
		end
		if step <= 6 then
			wait.frames_skipping(60)
		end
		if step <= 7 then
			wait.frames_skipping(60)
		end
		if step <= 8 then
			cutscene.ignore_argument(0)
		end
		return true
	end)
	step = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	if ixion_flag ~= 0 then
		event.stop_sound_effect(ixion_sound, 0)
	end
	event.fade_out_music(30)
	event.stop_sound_effect(warp_sound, 0)
	party_npc = event.get_party_npc() or party_npc
	cleanup_playable_character = event.get_playable_character() or cleanup_playable_character
	event.delete_character(37)
	if cleanup_playable_character == 1 then
		event.delete_character_extension_packs(0)
		event.delete_character(33)
	end
	if cleanup_playable_character == 0 then
		event.delete_character(32)
	end
	if party_npc ~= -1 then
		event.delete_character(34)
	end
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(39)
end

--- Shows the Ixion time travel caption over a white screen when the Ixion flag is set.
function time_gate.show_travel_caption(to_future: s32)
	local ixion_flag: s32 = 0
	ixion_flag = event.get_save_flag(612) or ixion_flag
	if ixion_flag == 0 then
		return
	end
	event.set_message_window_mode(0, 12)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_color(0, 255, 255, 255, 255)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.set_event_sprite_draw_pass(0, 1)
	event.fade_in_screen(0)
	vm.wait(1)
	if to_future ~= 0 then
		event.open_message_window_2(0, "Siamo andati nel futuro con un\nviaggio temporale dell'Ixion.")
	else
		event.open_message_window_2(0, "Siamo tornati al presente con un\nviaggio temporale dell'Ixion.")
	end
	vm.wait(2)
	message.show(0, -1, 5, 0, 0)
	vm.wait(4)
	event.fade_out_screen(0, 255.0, 255.0, 255.0)
	vm.wait(5)
	cutscene.hide_event_sprite()
end

--- Plays a time gate trip, returning to the present when Monica is in the party, otherwise playing the one-time first-use scene when its flags allow and then jumping to the future.
function time_gate.warp_through_gate(world_x: f32, world_y: f32, world_z: f32, world_rotation: f32)
	local is_monica_in_party: s32 = 0
	local save_flag_520: s32 = 0
	local save_flag_532: s32 = 0
	local first_use_scene_seen: s32 = 0
	local step: number = 0
	return vm.guard(function()
		is_monica_in_party = event.set_party_member(1) or is_monica_in_party
		if is_monica_in_party == 1 then
			step = 1
			time_gate.return_to_present(world_x, world_y, world_z, world_rotation, 0, 1)
		else
			save_flag_520 = event.get_save_flag(520) or save_flag_520
			save_flag_532 = event.get_save_flag(532) or save_flag_532
			if save_flag_520 ~= 0 and save_flag_532 == 0 then
				first_use_scene_seen = event.get_save_flag(522) or first_use_scene_seen
				if first_use_scene_seen == 0 then
					step = 2
					cutscene.play_atlamillia_touch_scene(world_x, world_y, world_z, world_rotation)
				end
			end
			step = 3
			time_gate.jump_to_future(world_x, world_y, world_z, world_rotation, 0, 0)
		end
		event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
		return
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				step = 2
				cutscene.play_atlamillia_touch_scene(world_x, world_y, world_z, world_rotation)
				return vm.continue_with(function()
					step = 3
					time_gate.jump_to_future(world_x, world_y, world_z, world_rotation, 0, 0)
					event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
					return
				end)
			end
			if step <= 2 then
				step = 3
				time_gate.jump_to_future(world_x, world_y, world_z, world_rotation, 0, 0)
				return vm.continue_with(function()
					event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return time_gate
