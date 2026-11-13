--!strict
--- Runs the rainbow butterfly wood boss room events, including planting the seed, growing the sprout with an item and climbing the vine to the next area.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local rainbow_butterfly_wood_boss_1 = require("@lib/event/rainbow_butterfly_wood_boss_1")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads Max and Monica with the vine climb motions and arranges their character slots for the cutscene.
local function load_vine_climb_characters()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		max_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e256/e256_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e256/e256_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 13)
	end
	if active_character == 1 then
		max_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e256/e256_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e256/e256_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_message_file(0, 5, "event/e200/e256/e256_1.txt")
end

--- Reapplies the Max and Monica character slot assignment when the vine climb cutscene is skipped before it loaded them.
local function apply_vine_climb_slots_on_skip()
	max_slot = 0
	monica_slot = 8
	max_slot = 8
	monica_slot = 0
end

--- Removes the vine climb cutscene models and restores the player character.
local function unload_vine_climb_characters()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(13)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(13)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
end

--- Plays the cutscene in which Max and Monica grab the vine and are carried up out of the room.
local function cutscene_climb_vine()
	local sound_id: s32 = 0
	local active_character: s32 = 0
	local offset_distance: f32 = 0
	local offset_angle: f32 = 0
	local monica_offset_x: f32 = 0
	local monica_offset_z: f32 = 0
	local first_voice_open_state: s32 = 0
	local first_voice_ready_state: s32 = 0
	local second_voice_open_state: s32 = 0
	local second_voice_ready_state: s32 = 0
	local i: s32 = 0
	local scale: f32 = 0
	local step: number = 0
	vm.section(function()
		event.set_save_flag(256, 1)
		rainbow_butterfly_wood_boss_1.set_boss_room_stage(2)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		step = 1
		wait.frames(30)
		event.load_map_sounds(2830)
		sound_id = event.load_sound_effect_file_2(2830) or sound_id
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		load_vine_climb_characters()
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(198.99, 28.85, 11.03)
		event.set_camera_sequence_look_at(261.25, 30.97, -11.58)
		event.set_object_sequence_position(0, 238.89, 10.0, -8.34)
		event.set_object_sequence_rotation(0, 0.0, -1.51, 0.0)
		event.set_object_sequence_motion(0, "触ろうとする", 5, -1.0, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		offset_distance = event.get_vector_length(13.2361, 0.0, -6.22552) or offset_distance
		offset_angle = event.get_arc_tangent(13.2361, -6.22552) or offset_angle
		monica_offset_x = vm.f32(vm.sin(vm.f32(vm.f32(-1.51) + offset_angle)) * offset_distance)
		monica_offset_z = vm.f32(vm.cos(vm.f32(vm.f32(-1.51) + offset_angle)) * offset_distance)
		event.set_object_sequence_position(1, vm.f32(238.89) + monica_offset_x, 10.0, vm.f32(-8.34) + monica_offset_z)
		event.set_object_sequence_rotation(1, 0.0, -1.51, 0.0)
		event.set_object_sequence_motion(1, "触ろうとする", 5, -1.0, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.fade_in_screen(30)
		step = 2
		wait.frames(60)
		event.set_object_sequence_motion(0, "触ろうとする", 6)
		event.queue_object_sequence_next_motion(0, "触ろうとするL", 4)
		event.set_object_sequence_motion(1, "触ろうとする", 6)
		event.queue_object_sequence_next_motion(1, "触ろうとするL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 3
		message.show_voiced(2560010)
		event.reset_mouth_texture_animations()
		step = 4
		object.wait_until_done(0)
		step = 5
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "やめときなよ", 6)
		event.queue_object_sequence_next_motion(0, "やめときなよL", 4)
		event.set_object_sequence_motion(1, "やめときなよ", 6)
		event.queue_object_sequence_next_motion(1, "やめときなよL", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(sound_id, 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 6
		message.show_voiced(2560020)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "わらい口パク")
		step = 7
		message.show_voiced(2560030)
		event.reset_mouth_texture_animations()
		step = 8
		object.wait_until_done(0)
		step = 9
		object.wait_until_done(1)
		event.set_object_sequence_motion(0, "つるをつかむ", 6)
		event.queue_object_sequence_next_motion(0, "つるをつかむL", 4)
		event.set_object_sequence_motion(0, "上へ", 6)
		event.queue_object_sequence_next_motion(0, "上へL", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(1, "つるをつかむ", 6)
		event.queue_object_sequence_next_motion(1, "つるをつかむL", 4)
		event.set_object_sequence_motion(1, "上へ", 6)
		event.queue_object_sequence_next_motion(1, "上へL", 4)
		step = 10
		wait.frames(11)
		event.open_voice_stream_wave(1, 2560040)
		while true do
			first_voice_open_state = event.get_voice_stream_open_state() or first_voice_open_state
			if first_voice_open_state == 0 then
				break
			else
				step = 11
				vm.wait(11)
			end
		end
		event.ready_voice_stream(1)
		while true do
			first_voice_ready_state = event.get_voice_stream_open_state() or first_voice_ready_state
			if first_voice_ready_state == 0 then
				break
			else
				step = 12
				vm.wait(12)
			end
		end
		event.play_voice_stream(1)
		step = 13
		wait.frames(11)
		event.play_sound_effect(sound_id, 1)
		step = 14
		wait.frames(8)
		event.close_voice_stream(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "大口パク")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "通常口パク")
		event.play_sound_effect(sound_id, 2)
		event.set_camera_sequence_position(227.57, 420.0, -4.83)
		event.set_camera_sequence_look_at(236.82, 22.53, -16.55)
		event.move_object_sequence(0, 238.89, 410.0, -8.34, 60)
		event.move_object_sequence(1, vm.f32(238.89) + monica_offset_x, 410.0, vm.f32(-8.34) + monica_offset_z, 60)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.open_voice_stream_wave(1, 2560050)
		while true do
			second_voice_open_state = event.get_voice_stream_open_state() or second_voice_open_state
			if second_voice_open_state == 0 then
				break
			else
				step = 15
				vm.wait(15)
			end
		end
		event.ready_voice_stream(1)
		while true do
			second_voice_ready_state = event.get_voice_stream_open_state() or second_voice_ready_state
			if second_voice_ready_state == 0 then
				break
			else
				step = 16
				vm.wait(16)
			end
		end
		event.play_voice_stream(1)
		event.set_function_point_enabled("neba", "nebaanime", 0)
		event.attach_object_handle_to_map_part_3(28, "neba", "neba3")
		for var14_i = 0, 59 do
			scale = calc.interpolate(1.0, vm.f32(0.45), var14_i, 60)
			event.set_object_handle_scale(28, scale, scale, scale)
			step = 17
			vm.wait(17)
		end
		event.fade_out_screen(30)
		step = 18
		wait.frames(45)
		event.close_voice_stream(1)
	end, function(received: { any }): boolean
		if step <= 1 then
			apply_vine_climb_slots_on_skip()
			monica_offset_x = vm.f32(vm.sin(vm.f32(vm.f32(-1.51) + offset_angle)) * offset_distance)
			monica_offset_z = vm.f32(vm.cos(vm.f32(vm.f32(-1.51) + offset_angle)) * offset_distance)
			wait.frames_skipping(60)
		end
		if step <= 2 then
			message.show_voiced_skipping(2560010)
		end
		if step <= 3 then
			cutscene.skip_command(0)
		end
		if step <= 4 then
			cutscene.skip_command(1)
		end
		if step <= 5 then
			message.show_voiced_skipping(2560020)
		end
		if step <= 6 then
			message.show_voiced_skipping(2560030)
		end
		if step <= 7 then
			cutscene.skip_command(0)
		end
		if step <= 8 then
			cutscene.skip_command(1)
		end
		if step <= 9 then
			wait.frames_skipping(11)
		end
		if step <= 12 then
			wait.frames_skipping(11)
		end
		if step <= 13 then
			wait.frames_skipping(8)
		end
		if step <= 16 then
			i = 0
			scale = calc.interpolate(1.0, vm.f32(0.45), i, 60)
		end
		if step <= 17 then
			local _ = i < 60
			i = i + 1
			wait.frames_skipping(45)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	unload_vine_climb_characters()
	event.show_dungeon_status_bar(1, 1.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads Max, Monica and the light and shadow models for the sprout growth cutscene.
local function load_sprout_growth_characters()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		max_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e255/e255_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e255/e255_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 13)
	end
	if active_character == 1 then
		max_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e255/e255_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e255/e255_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e200/e255/taiysizk_t.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(4, 11)
	event.clear_object_sequence(3, 11)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "event/e200/e255/e255_rafhikari.gltf", "info", 14)
	event.set_character_active(0, 14)
	event.attach_object_handle_to_character(5, 14)
	event.clear_object_sequence(4, 14)
	event.set_object_sequence_object(4, 5)
	event.load_character(5, "event/e200/e255/e255_rafkage.gltf", "info", 15)
	event.set_character_active(0, 15)
	event.attach_object_handle_to_character(6, 15)
	event.clear_object_sequence(5, 15)
	event.set_object_sequence_object(5, 6)
	event.set_scene_status_flags(1, 15, 512, 1)
	event.initialize_effect_manager(5)
	event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.create_effect_work_buffer(5)
	event.load_message_file(0, 5, "event/e200/e255/e255_1.txt")
end

--- Reapplies the Max and Monica character slot assignment when the sprout growth cutscene is skipped before it loaded them.
local function apply_sprout_growth_slots_on_skip()
	max_slot = 0
	monica_slot = 8
	max_slot = 8
	monica_slot = 0
end

--- Removes the sprout growth cutscene models and restores the player character.
local function unload_sprout_growth_characters()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(13)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(13)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(11)
	event.delete_character(14)
	event.delete_character(15)
	event.clear_effect_manager()
	event.load_message_file(0, -1)
end

--- Plays the cutscene in which the growth item makes the sprout glow and the party tumbles toward the grown plant.
local function cutscene_grow_sprout_with_item()
	local sound_id: s32 = 0
	local active_character: s32 = 0
	local item_x: f32 = 0
	local item_y: f32 = 0
	local item_z: f32 = 0
	local splash_x: f32 = 0
	local splash_y: f32 = 0
	local splash_z: f32 = 0
	local i: s32 = 0
	local shade: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(255, 1)
		rainbow_butterfly_wood_boss_1.set_boss_room_stage(0)
		event.set_function_point_enabled("", "e255", 0)
		event.set_function_point_enabled("", "e256", 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		step = 2
		wait.frames(30)
		event.load_map_sounds(2827)
		sound_id = event.load_sound_effect_file_2(2827) or sound_id
		event.stop_music(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		load_sprout_growth_characters()
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 11)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(165.23, 27.59, -378.25)
		event.set_camera_sequence_look_at(193.46, 7.26, -193.75)
		event.attach_character_to_frame(max_slot, "ef00", 11)
		event.set_object_sequence_position(0, 205.98, 0.0, -180.32)
		event.set_object_sequence_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_motion(0, "投げる", 5)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(1, 171.66, 0.0, -193.35)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.move_camera_sequence(201.05, 139.37, -720.52, 257.49, -54.51, -224.57, 150)
		event.fade_in_screen(30)
		step = 3
		wait.frames(60)
		event.set_object_sequence_motion(0, "投げる", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		step = 4
		wait.frames(15)
		event.play_sound_effect(sound_id, 0)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "ef00")
			item_x = out1 or item_x
			item_y = out2 or item_y
			item_z = out3 or item_z
		end
		event.detach_character_from_frame(11)
		event.set_object_sequence_position(3, item_x, item_y, item_z)
		splash_x = vm.f32(vm.f32(vm.f32(280.0 - item_x) * vm.f32(0.7)) + item_x)
		splash_y = -30.0
		splash_z = vm.f32(vm.f32(vm.f32(-360.0 - item_z) * vm.f32(0.7)) + item_z)
		event.jump_object_sequence(3, splash_x, splash_y, splash_z, -0.5, 30)
		step = 5
		wait.frames(30)
		event.create_effect("足水パシャ")
		event.set_effect_first_vector(splash_x, splash_y, splash_z)
		event.play_sound_effect(sound_id, 1)
		event.set_character_active(0, 11)
		step = 6
		wait.frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(376.67, 142.57, -99.0)
		event.set_camera_sequence_look_at(308.65, 16.16, -300.89)
		step = 7
		wait.frames(60)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(4, 306.62, 23.94, -274.4)
		event.set_object_sequence_motion(4, "ラフレシアの光", 6)
		event.play_sound_effect(sound_id, 2)
		step = 8
		wait.frames(120)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(209.92, 20.41, -217.76)
		event.set_camera_sequence_look_at(193.9, 22.53, -164.47)
		event.set_object_sequence_position(0, 203.0, 0.0, -178.08)
		event.set_object_sequence_rotation(0, 0.0, 2.21, 0.0)
		event.set_object_sequence_motion(0, "まぶしい", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(0, 1, "大口")
		event.set_object_sequence_position(1, 195.5, 0.0, -191.28)
		event.set_object_sequence_rotation(1, 0.0, 1.85, 0.0)
		event.set_object_sequence_motion(1, "まぶしいＬ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_function_point_enabled("", "light", 1)
		step = 9
		wait.frames(30)
		event.set_function_point_enabled("", "light", 0)
		step = 10
		wait.frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.set_object_sequence_texture_animation(0, 1, "大口～半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		step = 11
		wait.frames(30)
		event.shake_camera_sequence(0.0, 0.5, 0.0, -1)
		event.play_sound_effect(sound_id, 3)
		step = 12
		wait.frames(15)
		event.set_object_sequence_motion(0, "きょろきょろ入り", 2)
		event.queue_object_sequence_next_motion(0, "きょろきょろ", 4)
		event.set_object_sequence_motion(1, "きょろきょろ入り", 2)
		event.queue_object_sequence_next_motion(1, "きょろきょろ入りＬ", 4)
		step = 13
		wait.frames(30)
		event.move_camera_sequence(209.92, 140.41, -217.76, 193.9, 142.53, -164.47, 150)
		event.move_object_sequence(0, 203.0, 120.0, -178.08, 150)
		event.move_object_sequence(1, 195.5, 120.0, -191.28, 150)
		step = 14
		wait.frames(60)
		event.set_object_sequence_motion(0, "ころげる", 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "大口パク")
		event.set_object_sequence_motion(1, "こける", 2)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口パク")
		step = 15
		wait.frames(15)
		event.play_sound_effect(sound_id, 4)
		step = 16
		wait.frames(30)
		event.play_sound_effect(sound_id, 5)
		step = 17
		wait.frames(45)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(66.68, 32.93, 571.9)
		event.set_camera_sequence_look_at(9.6, -29.41, 637.45)
		event.move_camera_sequence(66.68, 94.82, 571.9, 9.6, -29.41, 637.45, 300)
		rainbow_butterfly_wood_boss_1.set_boss_room_stage(1)
		event.set_character_active(1, 15)
		event.set_object_sequence_position(5, 304.99, -11.65, 256.72)
		event.set_object_sequence_rotation(5, 0.0, -0.6, 0.0)
		event.move_object_sequence(5, 180.23, -11.65, 406.64, 300)
		event.set_object_sequence_position(0, 35.85, -11.65, 620.66)
		event.set_object_sequence_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_motion(0, "ころげるふるふる", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目とじ")
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "ころげるL")
		event.delay_object_sequence_texture_animation_track(0, 90)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目とじ～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_position(1, 25.34, -12.1, 603.98)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_object_sequence_motion(1, "体おこし", 5)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "ひき目とじ")
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "体おこし", 6)
		event.queue_object_sequence_next_motion(1, "おこしＬ", 4)
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "ひき目とじ～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～おどろき口")
		event.reset_object_sequence_dynamic_animation(1)
		event.set_character_model_lighting(max_slot, 0)
		event.set_character_model_lighting(monica_slot, 0)
		event.set_character_model_lighting(13, 0)
		event.set_character_model_lighting(3, 0)
		i = 0
		while i < 120 do
			shade = calc.interpolate(128.0, 64.0, i, 120)
			event.set_character_model_color(max_slot, shade, shade, shade, 128.0)
			event.set_character_model_color(monica_slot, shade, shade, shade, 128.0)
			event.set_character_model_color(13, shade, shade, shade, 128.0)
			event.set_character_model_color(3, shade, shade, shade, 128.0)
			i = i + 1
			step = 18
			vm.wait(18)
		end
		event.set_object_sequence_motion(0, "見上げる", 2)
		event.queue_object_sequence_next_motion(0, "見上げるL", 4)
		step = 19
		wait.frames(180)
		event.set_character_active(0, 15)
		event.stop_sound_effect(sound_id, 3)
		event.set_camera_sequence_position(102.35, 17.52, 484.45)
		event.set_camera_sequence_look_at(149.91, 29.34, 259.34)
		event.move_camera_sequence(102.35, 17.52, 484.45, 149.91, 192.84, 259.34, 150)
		step = 20
		wait.frames(180)
		event.set_camera_sequence_position(27.96, 10.19, 586.18)
		event.set_camera_sequence_look_at(27.35, -2.18, 625.61)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 21
		message.show_voiced_for(2550010, 180)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "大口パク")
		step = 22
		message.show_voiced_for(2550020, 90)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		step = 23
		wait.frames(35)
	end, function(received: { any }): boolean
		if step <= 1 then
			cutscene.ignore_value(0)
			wait.frames_skipping(30)
		end
		if step <= 2 then
			apply_sprout_growth_slots_on_skip()
			wait.frames_skipping(60)
		end
		if step <= 3 then
			wait.frames_skipping(15)
		end
		if step <= 4 then
			splash_x = vm.f32(vm.f32(vm.f32(280.0 - item_x) * vm.f32(0.7)) + item_x)
			splash_y = -30.0
			splash_z = vm.f32(vm.f32(vm.f32(-360.0 - item_z) * vm.f32(0.7)) + item_z)
			wait.frames_skipping(30)
		end
		if step <= 5 then
			wait.frames_skipping(30)
		end
		if step <= 6 then
			wait.frames_skipping(60)
		end
		if step <= 7 then
			wait.frames_skipping(120)
		end
		if step <= 8 then
			wait.frames_skipping(30)
		end
		if step <= 9 then
			wait.frames_skipping(15)
		end
		if step <= 10 then
			wait.frames_skipping(30)
		end
		if step <= 11 then
			wait.frames_skipping(15)
		end
		if step <= 12 then
			wait.frames_skipping(30)
		end
		if step <= 13 then
			wait.frames_skipping(60)
		end
		if step <= 14 then
			wait.frames_skipping(15)
		end
		if step <= 15 then
			wait.frames_skipping(30)
		end
		if step <= 16 then
			wait.frames_skipping(45)
		end
		if step <= 17 then
			cutscene.ignore_value(1)
			i = 0
			shade = calc.interpolate(128.0, 64.0, i, 120)
			local _ = i < 120
			i = i + 1
		end
		if step <= 18 then
			wait.frames_skipping(180)
		end
		if step <= 19 then
			wait.frames_skipping(180)
		end
		if step <= 20 then
			message.show_voiced_for_skipping(2550010, 180)
		end
		if step <= 21 then
			message.show_voiced_for_skipping(2550020, 90)
		end
		if step <= 22 then
			wait.frames_skipping(35)
		end
		return true
	end)
	step = 24
	vm.entry(24)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_id, 3)
	event.set_character_model_lighting(max_slot, 1)
	event.set_character_model_lighting(monica_slot, 1)
	event.set_character_model_lighting(13, 1)
	event.set_character_model_lighting(3, 1)
	unload_sprout_growth_characters()
	event.show_dungeon_status_bar(1, 1.0)
	rainbow_butterfly_wood_boss_1.set_boss_room_stage(2)
	event.set_character_motion(0, "立ち")
	event.set_character_position(0, 152.66, 0.07, 288.35)
	event.set_character_rotation(0, 0.0, 2.57, 0.0)
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Loads Max, Monica and the seed and explosion models for the seed planting cutscene.
local function load_seed_planting_characters()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		max_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e255/e255_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e255/e255_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 13)
	end
	if active_character == 1 then
		max_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e255/e255_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e255/e255_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e200/e255/e255_rafu_tane.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(4, 11)
	event.clear_object_sequence(3, 11)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "event/e200/e255/e255_rafbaku.gltf", "info", 14)
	event.set_character_active(0, 14)
	event.attach_object_handle_to_character(5, 14)
	event.clear_object_sequence(4, 14)
	event.set_object_sequence_object(4, 5)
	event.initialize_effect_manager(5)
	event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.create_effect_work_buffer(5)
end

--- Reapplies the Max and Monica character slot assignment when the seed planting cutscene is skipped before it loaded them.
local function apply_seed_planting_slots_on_skip()
	max_slot = 0
	monica_slot = 8
	max_slot = 8
	monica_slot = 0
end

--- Removes the seed planting cutscene models and restores the player character.
local function unload_seed_planting_characters()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(13)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(13)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(11)
	event.delete_character(14)
	event.clear_effect_manager()
end

--- Plays the cutscene in which Max throws the seed into the swamp and a sprout bursts out of it.
local function cutscene_plant_seed_in_swamp()
	local sound_id: s32 = 0
	local active_character: s32 = 0
	local seed_x: f32 = 0
	local seed_y: f32 = 0
	local seed_z: f32 = 0
	local elapsed_frames: f32 = 0
	local total_frames: f32 = 0
	local scale: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(255, 1)
		rainbow_butterfly_wood_boss_1.set_boss_room_stage(3)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		step = 2
		wait.frames(30)
		event.load_map_sounds(2824)
		sound_id = event.load_sound_effect_file_2(2824) or sound_id
		event.stop_music(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		load_seed_planting_characters()
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 11)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(165.23, 27.59, -378.25)
		event.set_camera_sequence_look_at(193.46, 7.26, -193.75)
		event.attach_character_to_frame(max_slot, "ef00", 11)
		event.set_object_sequence_position(0, 205.98, 0.0, -180.32)
		event.set_object_sequence_rotation(0, 0.0, 2.57, 0.0)
		event.set_object_sequence_motion(0, "投げる", 5)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_position(1, 171.66, 0.0, -193.35)
		event.set_object_sequence_rotation(1, 0.0, 2.57, 0.0)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.move_camera_sequence(201.05, 139.37, -720.52, 257.49, -54.51, -224.57, 150)
		event.fade_in_screen(30)
		step = 3
		wait.frames(60)
		event.set_object_sequence_motion(0, "投げる", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		step = 4
		wait.frames(15)
		event.play_sound_effect(sound_id, 0)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "ef00")
			seed_x = out1 or seed_x
			seed_y = out2 or seed_y
			seed_z = out3 or seed_z
		end
		event.detach_character_from_frame(11)
		event.set_object_sequence_position(3, seed_x, seed_y, seed_z)
		event.jump_object_sequence(3, 280.0, -30.0, -360.0, -0.5, 30)
		step = 5
		wait.frames(30)
		event.create_effect("足水パシャ")
		event.set_effect_first_vector(280.0, -30.0, -360.0)
		event.play_sound_effect(sound_id, 1)
		event.set_character_active(0, 11)
		step = 6
		wait.frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(376.67, 142.57, -99.0)
		event.set_camera_sequence_look_at(308.65, 16.16, -300.89)
		step = 7
		wait.frames(60)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(4, 306.62, 23.94, -274.4)
		event.set_object_sequence_motion(4, "ｴﾌｪｸﾄ_ラフレシア爆発", 6)
		event.play_sound_effect(sound_id, 2)
		event.attach_object_handle_to_map_part_2(10, "p05_d02b01")
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_position(10, 280.0, -30.0, -360.0)
		elapsed_frames = 0.0
		total_frames = 30.0
		while elapsed_frames < total_frames do
			scale = calc.interpolate(0.0, 1.0, elapsed_frames, total_frames)
			event.set_object_handle_scale(10, scale, scale, scale)
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
			step = 8
			vm.wait(8)
		end
		event.set_object_handle_scale(10, 1.0, 1.0, 1.0)
		step = 9
		wait.frames(90)
		event.fade_out_screen(30)
		step = 10
		wait.frames(35)
	end, function(received: { any }): boolean
		if step <= 1 then
			cutscene.ignore_value(3)
			wait.frames_skipping(30)
		end
		if step <= 2 then
			apply_seed_planting_slots_on_skip()
			wait.frames_skipping(60)
		end
		if step <= 3 then
			wait.frames_skipping(15)
		end
		if step <= 4 then
			wait.frames_skipping(30)
		end
		if step <= 5 then
			wait.frames_skipping(30)
		end
		if step <= 6 then
			wait.frames_skipping(60)
		end
		if step <= 7 then
			elapsed_frames = 0.0
			total_frames = 30.0
			scale = calc.interpolate(0.0, 1.0, elapsed_frames, total_frames)
			local _ = elapsed_frames < total_frames
			elapsed_frames = vm.f32(elapsed_frames + 1.0)
		end
		if step <= 8 then
			wait.frames_skipping(90)
		end
		if step <= 9 then
			wait.frames_skipping(35)
		end
		return true
	end)
	step = 11
	vm.entry(11)
	event.cancel_drama_scene_skip()
	unload_seed_planting_characters()
	event.show_dungeon_status_bar(1, 1.0)
	rainbow_butterfly_wood_boss_1.set_boss_room_stage(0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing because the script needs no load-time preparation.
function script.setup() end

--- Restores the boss room state and fades the player into the room on entry.
function script.default_event()
	local step: number = 0
	return vm.guard(function()
		print("############################start_event_in\n")
		rainbow_butterfly_wood_boss_1.set_controls_locked(1)
		rainbow_butterfly_wood_boss_1.restore_boss_room_state()
		step = 1
		rainbow_butterfly_wood_boss_1.run_in_with_fade_in()
		print("###############################start_event_out\n")
		return
	end, function(received: { any })
		if step <= 1 then
			print("###############################start_event_out\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = cutscene_climb_vine

--- Restores the boss room state and fades the player in after entering through the tree.
function script.enter_from_tree()
	local step: number = 0
	return vm.guard(function()
		print("############################start_event_tree_in\n")
		event.set_function_point_enabled("", "exit", 1)
		rainbow_butterfly_wood_boss_1.set_controls_locked(1)
		rainbow_butterfly_wood_boss_1.restore_boss_room_state()
		step = 1
		rainbow_butterfly_wood_boss_1.run_in_with_fade_in()
		event.reset_follow_camera(0)
		print("###############################start_event_tree_out\n")
		return
	end, function(received: { any })
		if step <= 1 then
			print("###############################start_event_tree_out\n")
			return 0
		end
		return nil
	end)
end
script[200] = script.enter_from_tree

--- Places the player at the exit point of the room and fades the screen in.
function script.enter_at_exit_point()
	event.set_function_point_enabled("", "exit", 1)
	rainbow_butterfly_wood_boss_1.set_controls_locked(1)
	rainbow_butterfly_wood_boss_1.restore_boss_room_state()
	event.play_environment_music(0)
	event.reset_follow_camera(0)
	event.initialize_event()
	character.place_standing(vm.f32(94.3), vm.f32(-7.7), vm.f32(537.9), vm.f32(2.46))
	event.set_camera_position(78.24, 23.07, 626.86)
	event.set_camera_look_at(94.3, 22.26, 537.9)
	event.fade_in_screen(30)
	event.finish_event()
end
script[201] = script.enter_at_exit_point

--- Describes the swamp or sprout and lets the player use the seed or growth item on it to start the matching cutscene.
function script.examine_swamp_sprout()
	local interaction_kind: s32 = 0
	local flag: s32 = 0
	local item: s32 = 0
	local answer: s32 = 0
	local step: number = 0
	return vm.guard(function()
		interaction_kind = event.get_triggered_event_data_2(6) or interaction_kind
		if interaction_kind == 1 then
			flag = event.get_save_flag(24) or flag
			if flag ~= 0 then
			else
				event.apply_message_window_preset(0, 0)
				event.set_message_bubble_tail(0, 0)
				flag = event.get_save_flag(23) or flag
				if flag ~= 0 then
					event.open_message_window_2(
						0,
						"Qui c'[UNI00e8] un germoglio enorme.\nSembra manchi ancora qualcosa.<page>Si potr[UNI00e0] accelerare la crescita?\n(Usa (#) per accedere al Menu.)"
					)
				else
					event.open_message_window_2(
						0,
						"Qui c'[UNI00e8] una piccola palude.\nHa qualcosa di misterioso...\n(Usa (#) per accedere al Menu.)"
					)
				end
				event.set_character_motion(0, "立ち")
				step = 1
				answer = message.ask_confirmation(0, -1, 5, 0, 0, answer)
				event.set_message_bubble_tail(0, 1)
				if answer == 1 then
					interaction_kind = 2
				end
			end
		end
		if interaction_kind == 2 then
			flag = event.get_save_flag(24) or flag
			if flag ~= 0 then
			else
				flag = event.get_save_flag(23) or flag
				if flag ~= 0 then
					event.open_use_item_menu(356)
					step = 2
					vm.wait(2)
					item = vmhost.used_item() or item
					if 0 < item then
						if item == 356 then
							event.set_character_motion(0, "立ち")
							step = 3
							cutscene_grow_sprout_with_item()
							rainbow_butterfly_wood_boss_1.set_party_display_visible(0)
							event.set_save_flag(24, 1)
						else
							step = 4
							character.shake_head()
						end
					end
				else
					event.open_use_item_menu(361)
					step = 5
					vm.wait(5)
					item = vmhost.used_item() or item
					if 0 < item then
						if item == 361 then
							event.set_character_motion(0, "立ち")
							step = 6
							cutscene_plant_seed_in_swamp()
							rainbow_butterfly_wood_boss_1.set_party_display_visible(0)
							event.set_save_flag(23, 1)
						else
							step = 7
							character.shake_head()
						end
					end
				end
			end
		end
		return
	end, function(received: { any })
		if step <= 7 then
			if step == 1 then
				answer = received[2] :: number
			end
			if step <= 1 then
				local _ = interaction_kind == 1
				interaction_kind = 2
			end
			if step <= 2 then
				step = 3
				cutscene_grow_sprout_with_item()
				return vm.continue_with(function()
					rainbow_butterfly_wood_boss_1.set_party_display_visible(0)
					event.set_save_flag(24, 1)
					return
				end)
			end
			if step <= 3 then
				cutscene.ignore_value(0)
				character.resume_shake_head()
			end
			if step <= 5 then
				step = 6
				cutscene_plant_seed_in_swamp()
				return vm.continue_with(function()
					rainbow_butterfly_wood_boss_1.set_party_display_visible(0)
					event.set_save_flag(23, 1)
					return
				end)
			end
			if step <= 6 then
				cutscene.ignore_value(0)
				character.resume_shake_head()
			end
			return 0
		end
		return nil
	end)
end
script[400] = script.examine_swamp_sprout

--- Plays the vine climb cutscene and loads the next dungeon map.
function script.climb_vine_to_next_area()
	local interaction_kind: s32 = 0
	interaction_kind = event.get_triggered_event_data_2(6) or interaction_kind
	if interaction_kind == 1 then
		cutscene_climb_vine()
		rainbow_butterfly_wood_boss_1.set_controls_locked(0)
		if false then
			event.initialize_event()
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_position(0, 256, 208)
			event.set_event_sprite_size(0, 512, 416)
			event.set_event_sprite_color(0, 0, 0, 0, 0)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(11, 0)
			event.clear_object_sequence(11)
			event.set_object_sequence_object(11, 11)
			event.set_object_sequence_color(11, 0, 0, 0, 255, 1)
			wait.frames(1)
			event.fade_in_screen(1)
			wait.frames(1)
			event.apply_message_window_preset(1, 4)
			message.set_window_mode(1, 4)
			event.open_message_window_2(1, "To be continue...")
			message.open(1, -1, 5, 0, 0)
			wait.until_button_pressed(64)
			message.close(1)
			event.fade_out_screen(30)
			wait.frames(30)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_scene_exit_flag(1)
			event.fade_in_screen(30)
			return
		end
		event.skip_next_music_load()
		event.load_dungeon_map("d02b02")
		event.load_event_script("d02b02/d02b02.stb", 500)
	end
end
script[401] = script.climb_vine_to_next_area

--- Asks whether to leave the room and either returns to the georama or walks the player toward the room's exit passage.
function script.examine_exit()
	local active_character: s32 = 0
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local walk_angle: f32 = 0
	local camera_angle: f32 = 0
	event.set_character_motion(0, "立ち")
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show(0, 20, 5, 256, 208)
		else
			message.show(0, 21, 5, 256, 208)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.set_character_position(0, 94.3, -7.7, 537.9)
		event.set_character_rotation(0, 0.0, 2.46, 0.0)
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(6, 16)
	if answer == 0 then
		rainbow_butterfly_wood_boss_1.run_out_with_fade_out()
		event.set_function_point_enabled("", "exit", 0)
		rainbow_butterfly_wood_boss_1.set_controls_locked(0)
		event.go_to_georama_edit(16)
		return
	else
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "歩き", 4)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.get_character_rotation(0)
		walk_angle = event.get_direction_angle(player_x, player_y, player_z, 112.99, 3.46, 468.16) or walk_angle
		event.rotate_object_sequence(0, 0.0, walk_angle, 0.0, 15)
		event.move_object_sequence(0, 112.99, 3.46, 468.16, 90, 1)
		camera_angle = event.get_follow_camera_angle() or camera_angle
		if camera_angle > vm.f32(1.5707964) or camera_angle < vm.f32(-1.5707964) then
			event.move_camera_sequence(141.62, 78.35, 269.76, player_x, player_y + 30.0, player_z, 90)
		end
		for i = 0, 59 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
			event.set_camera_sequence_look_at(player_x, player_y + 30.0, player_z)
			event.set_camera_look_at(player_x, player_y + 30.0, player_z)
			vm.wait(5)
		end
		event.set_object_sequence_motion(0, "立ち")
		event.reset_follow_camera(0)
		event.finish_event()
	end
end
script[402] = script.examine_exit

--- Event 12551, which map data, a script or the engine runs by number.
script.cutscene_plant_seed_in_swamp = cutscene_plant_seed_in_swamp
script[12551] = script.cutscene_plant_seed_in_swamp

--- Event 12552, which map data, a script or the engine runs by number.
script.cutscene_grow_sprout_with_item = cutscene_grow_sprout_with_item
script[12552] = script.cutscene_grow_sprout_with_item

--- Event 12560, which map data, a script or the engine runs by number.
script.cutscene_climb_vine = cutscene_climb_vine
script[12560] = script.cutscene_climb_vine

return script
