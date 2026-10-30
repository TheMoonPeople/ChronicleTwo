--!strict
-- map/d/d02/b01/d02b01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_11a8d6f3 = require("@lib/event/helper_11a8d6f3")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4734c9b2 = require("@lib/event/helper_4734c9b2")
local helper_4a9b8bc5 = require("@lib/event/helper_4a9b8bc5")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_66ee0e0a = require("@lib/event/helper_66ee0e0a")
local helper_7c656a4f = require("@lib/event/helper_7c656a4f")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_8e2d9b9a = require("@lib/event/helper_8e2d9b9a")
local helper_acde31fa = require("@lib/event/helper_acde31fa")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_e57e2768 = require("@lib/event/helper_e57e2768")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local interpolate = require("@lib/event/interpolate")
local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_1754c()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e256/e256_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e256/e256_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 13)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e256/e256_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e256/e256_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_message_file(0, 5, "event/e200/e256/e256_1.txt")
end

--- Helper function.
local function helper_22200000()
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_171b4()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(13)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(13)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
end

--- Helper function.
local function helper_18268()
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local stream_open_state_3: s32 = 0
	local stream_open_state_4: s32 = 0
	local var14: s32 = 0
	local var15: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(256, 1)
		helper_66ee0e0a(2)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 1
		wait_frames(30)
		event.load_map_sounds(2830)
		var4 = event.load_sound_effect_file_2(2830) or var4
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		helper_1754c()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
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
		var6 = event.get_vector_length(13.2361, 0.0, -6.22552) or var6
		var7 = event.get_arc_tangent(13.2361, -6.22552) or var7
		var8 = vm.f32(vm.sin(vm.f32(vm.f32(-1.51) + var7)) * var6)
		var9 = vm.f32(vm.cos(vm.f32(vm.f32(-1.51) + var7)) * var6)
		event.set_object_sequence_position(1, vm.f32(238.89) + var8, 10.0, vm.f32(-8.34) + var9)
		event.set_object_sequence_rotation(1, 0.0, -1.51, 0.0)
		event.set_object_sequence_motion(1, "触ろうとする", 5, -1.0, 1)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.fade_in_screen(30)
		at = 2
		wait_frames(60)
		event.set_object_sequence_motion(0, "触ろうとする", 6)
		event.queue_object_sequence_next_motion(0, "触ろうとするL", 4)
		event.set_object_sequence_motion(1, "触ろうとする", 6)
		event.queue_object_sequence_next_motion(1, "触ろうとするL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 3
		helper_4116e6bb(2560010)
		event.reset_mouth_texture_animations()
		at = 4
		wait_objects(0)
		at = 5
		wait_objects(1)
		event.set_object_sequence_motion(0, "やめときなよ", 6)
		event.queue_object_sequence_next_motion(0, "やめときなよL", 4)
		event.set_object_sequence_motion(1, "やめときなよ", 6)
		event.queue_object_sequence_next_motion(1, "やめときなよL", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var4, 0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 6
		helper_4116e6bb(2560020)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 7
		helper_4116e6bb(2560030)
		event.reset_mouth_texture_animations()
		at = 8
		wait_objects(0)
		at = 9
		wait_objects(1)
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
		at = 10
		wait_frames(11)
		event.open_voice_stream_wave(1, 2560040)
		while true do
			stream_open_state = event.get_voice_stream_open_state() or stream_open_state
			if stream_open_state == 0 then
				break
			else
				at = 11
				vm.wait(11)
			end
		end
		event.ready_voice_stream(1)
		while true do
			stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
			if stream_open_state_2 == 0 then
				break
			else
				at = 12
				vm.wait(12)
			end
		end
		event.play_voice_stream(1)
		at = 13
		wait_frames(11)
		event.play_sound_effect(var4, 1)
		at = 14
		wait_frames(8)
		event.close_voice_stream(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_sequence_texture_animation(0, 1, "大口パク")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "通常口パク")
		event.play_sound_effect(var4, 2)
		event.set_camera_sequence_position(227.57, 420.0, -4.83)
		event.set_camera_sequence_look_at(236.82, 22.53, -16.55)
		event.move_object_sequence(0, 238.89, 410.0, -8.34, 60)
		event.move_object_sequence(1, vm.f32(238.89) + var8, 410.0, vm.f32(-8.34) + var9, 60)
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
			stream_open_state_3 = event.get_voice_stream_open_state() or stream_open_state_3
			if stream_open_state_3 == 0 then
				break
			else
				at = 15
				vm.wait(15)
			end
		end
		event.ready_voice_stream(1)
		while true do
			stream_open_state_4 = event.get_voice_stream_open_state() or stream_open_state_4
			if stream_open_state_4 == 0 then
				break
			else
				at = 16
				vm.wait(16)
			end
		end
		event.play_voice_stream(1)
		event.set_function_point_enabled("neba", "nebaanime", 0)
		event.attach_object_handle_to_map_part_3(28, "neba", "neba3")
		for var14_i = 0, 59 do
			var15 = interpolate(1.0, vm.f32(0.45), var14_i, 60)
			event.set_object_handle_scale(28, var15, var15, var15)
			at = 17
			vm.wait(17)
		end
		event.fade_out_screen(30)
		at = 18
		wait_frames(45)
		event.close_voice_stream(1)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22200000()
			var8 = vm.f32(vm.sin(vm.f32(vm.f32(-1.51) + var7)) * var6)
			var9 = vm.f32(vm.cos(vm.f32(vm.f32(-1.51) + var7)) * var6)
			wait_frames_skipping(60)
		end
		if at <= 2 then
			helper_8cd371d7(2560010)
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			helper_8cd371d7(2560020)
		end
		if at <= 6 then
			helper_8cd371d7(2560030)
		end
		if at <= 7 then
			helper_238b5abc(0)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			wait_frames_skipping(11)
		end
		if at <= 12 then
			wait_frames_skipping(11)
		end
		if at <= 13 then
			wait_frames_skipping(8)
		end
		if at <= 16 then
			var14 = 0
			var15 = interpolate(1.0, vm.f32(0.45), var14, 60)
		end
		if at <= 17 then
			local _ = var14 < 60
			var14 = var14 + 1
			wait_frames_skipping(45)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	helper_171b4()
	event.show_dungeon_status_bar(1, 1.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_12be0()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e255/e255_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e255/e255_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 13)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e255/e255_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e255/e255_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
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

--- Helper function.
local function helper_21d00000()
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_12788()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(13)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
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

--- Helper function.
local function helper_13d74()
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	local var13: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(255, 1)
		helper_66ee0e0a(0)
		event.set_function_point_enabled("", "e255", 0)
		event.set_function_point_enabled("", "e256", 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 2
		wait_frames(30)
		event.load_map_sounds(2827)
		var4 = event.load_sound_effect_file_2(2827) or var4
		event.stop_music(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		helper_12be0()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 11)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(165.23, 27.59, -378.25)
		event.set_camera_sequence_look_at(193.46, 7.26, -193.75)
		event.attach_character_to_frame(global0, "ef00", 11)
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
		at = 3
		wait_frames(60)
		event.set_object_sequence_motion(0, "投げる", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 4
		wait_frames(15)
		event.play_sound_effect(var4, 0)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "ef00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.detach_character_from_frame(11)
		event.set_object_sequence_position(3, pos_x, pos_y, pos_z)
		var9 = vm.f32(vm.f32(vm.f32(280.0 - pos_x) * vm.f32(0.7)) + pos_x)
		var10 = -30.0
		var11 = vm.f32(vm.f32(vm.f32(-360.0 - pos_z) * vm.f32(0.7)) + pos_z)
		event.jump_object_sequence(3, var9, var10, var11, -0.5, 30)
		at = 5
		wait_frames(30)
		event.create_effect("足水パシャ")
		event.set_effect_first_vector(var9, var10, var11)
		event.play_sound_effect(var4, 1)
		event.set_character_active(0, 11)
		at = 6
		wait_frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(376.67, 142.57, -99.0)
		event.set_camera_sequence_look_at(308.65, 16.16, -300.89)
		at = 7
		wait_frames(60)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(4, 306.62, 23.94, -274.4)
		event.set_object_sequence_motion(4, "ラフレシアの光", 6)
		event.play_sound_effect(var4, 2)
		at = 8
		wait_frames(120)
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
		at = 9
		wait_frames(30)
		event.set_function_point_enabled("", "light", 0)
		at = 10
		wait_frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "目とじ～目あき")
		event.set_object_sequence_texture_animation(0, 1, "大口～半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		at = 11
		wait_frames(30)
		event.shake_camera_sequence(0.0, 0.5, 0.0, -1)
		event.play_sound_effect(var4, 3)
		at = 12
		wait_frames(15)
		event.set_object_sequence_motion(0, "きょろきょろ入り", 2)
		event.queue_object_sequence_next_motion(0, "きょろきょろ", 4)
		event.set_object_sequence_motion(1, "きょろきょろ入り", 2)
		event.queue_object_sequence_next_motion(1, "きょろきょろ入りＬ", 4)
		at = 13
		wait_frames(30)
		event.move_camera_sequence(209.92, 140.41, -217.76, 193.9, 142.53, -164.47, 150)
		event.move_object_sequence(0, 203.0, 120.0, -178.08, 150)
		event.move_object_sequence(1, 195.5, 120.0, -191.28, 150)
		at = 14
		wait_frames(60)
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
		at = 15
		wait_frames(15)
		event.play_sound_effect(var4, 4)
		at = 16
		wait_frames(30)
		event.play_sound_effect(var4, 5)
		at = 17
		wait_frames(45)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(66.68, 32.93, 571.9)
		event.set_camera_sequence_look_at(9.6, -29.41, 637.45)
		event.move_camera_sequence(66.68, 94.82, 571.9, 9.6, -29.41, 637.45, 300)
		helper_66ee0e0a(1)
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
		event.set_character_model_lighting(global0, 0)
		event.set_character_model_lighting(global1, 0)
		event.set_character_model_lighting(13, 0)
		event.set_character_model_lighting(3, 0)
		var12 = 0
		while var12 < 120 do
			var13 = interpolate(128.0, 64.0, var12, 120)
			event.set_character_model_color(global0, var13, var13, var13, 128.0)
			event.set_character_model_color(global1, var13, var13, var13, 128.0)
			event.set_character_model_color(13, var13, var13, var13, 128.0)
			event.set_character_model_color(3, var13, var13, var13, 128.0)
			var12 = var12 + 1
			at = 18
			vm.wait(18)
		end
		event.set_object_sequence_motion(0, "見上げる", 2)
		event.queue_object_sequence_next_motion(0, "見上げるL", 4)
		at = 19
		wait_frames(180)
		event.set_character_active(0, 15)
		event.stop_sound_effect(var4, 3)
		event.set_camera_sequence_position(102.35, 17.52, 484.45)
		event.set_camera_sequence_look_at(149.91, 29.34, 259.34)
		event.move_camera_sequence(102.35, 17.52, 484.45, 149.91, 192.84, 259.34, 150)
		at = 20
		wait_frames(180)
		event.set_camera_sequence_position(27.96, 10.19, 586.18)
		event.set_camera_sequence_look_at(27.35, -2.18, 625.61)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 21
		helper_1584c528(2550010, 180)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "大口パク")
		at = 22
		helper_1584c528(2550020, 90)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		at = 23
		wait_frames(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_4a9b8bc5(0)
			wait_frames_skipping(30)
		end
		if at <= 2 then
			helper_21d00000()
			wait_frames_skipping(60)
		end
		if at <= 3 then
			wait_frames_skipping(15)
		end
		if at <= 4 then
			var9 = vm.f32(vm.f32(vm.f32(280.0 - pos_x) * vm.f32(0.7)) + pos_x)
			var10 = -30.0
			var11 = vm.f32(vm.f32(vm.f32(-360.0 - pos_z) * vm.f32(0.7)) + pos_z)
			wait_frames_skipping(30)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			wait_frames_skipping(60)
		end
		if at <= 7 then
			wait_frames_skipping(120)
		end
		if at <= 8 then
			wait_frames_skipping(30)
		end
		if at <= 9 then
			wait_frames_skipping(15)
		end
		if at <= 10 then
			wait_frames_skipping(30)
		end
		if at <= 11 then
			wait_frames_skipping(15)
		end
		if at <= 12 then
			wait_frames_skipping(30)
		end
		if at <= 13 then
			wait_frames_skipping(60)
		end
		if at <= 14 then
			wait_frames_skipping(15)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			wait_frames_skipping(45)
		end
		if at <= 17 then
			helper_4a9b8bc5(1)
			var12 = 0
			var13 = interpolate(128.0, 64.0, var12, 120)
			local _ = var12 < 120
			var12 = var12 + 1
		end
		if at <= 18 then
			wait_frames_skipping(180)
		end
		if at <= 19 then
			wait_frames_skipping(180)
		end
		if at <= 20 then
			helper_52aadc70(2550010, 180)
		end
		if at <= 21 then
			helper_52aadc70(2550020, 90)
		end
		if at <= 22 then
			wait_frames_skipping(35)
		end
		return true
	end)
	at = 24
	vm.entry(24)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var4, 3)
	event.set_character_model_lighting(global0, 1)
	event.set_character_model_lighting(global1, 1)
	event.set_character_model_lighting(13, 1)
	event.set_character_model_lighting(3, 1)
	helper_12788()
	event.show_dungeon_status_bar(1, 1.0)
	helper_66ee0e0a(2)
	event.set_character_motion(0, "立ち")
	event.set_character_position(0, 152.66, 0.07, 288.35)
	event.set_character_rotation(0, 0.0, 2.57, 0.0)
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_1054c()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e255/e255_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e255/e255_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
		event.set_character_active(1, 13)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global0)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e200/e255/e255_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e200/e255/e255_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
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

--- Helper function.
local function helper_21b00000()
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_10154()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(13)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
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

--- Helper function.
local function helper_11514()
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(255, 1)
		helper_66ee0e0a(3)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.fade_out_screen(30)
		at = 2
		wait_frames(30)
		event.load_map_sounds(2824)
		var4 = event.load_sound_effect_file_2(2824) or var4
		event.stop_music(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		helper_1054c()
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_character_active(1, 11)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_motion(1, "立ち")
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(165.23, 27.59, -378.25)
		event.set_camera_sequence_look_at(193.46, 7.26, -193.75)
		event.attach_character_to_frame(global0, "ef00", 11)
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
		at = 3
		wait_frames(60)
		event.set_object_sequence_motion(0, "投げる", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 4
		wait_frames(15)
		event.play_sound_effect(var4, 0)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "ef00")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.detach_character_from_frame(11)
		event.set_object_sequence_position(3, pos_x, pos_y, pos_z)
		event.jump_object_sequence(3, 280.0, -30.0, -360.0, -0.5, 30)
		at = 5
		wait_frames(30)
		event.create_effect("足水パシャ")
		event.set_effect_first_vector(280.0, -30.0, -360.0)
		event.play_sound_effect(var4, 1)
		event.set_character_active(0, 11)
		at = 6
		wait_frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(376.67, 142.57, -99.0)
		event.set_camera_sequence_look_at(308.65, 16.16, -300.89)
		at = 7
		wait_frames(60)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(4, 306.62, 23.94, -274.4)
		event.set_object_sequence_motion(4, "ｴﾌｪｸﾄ_ラフレシア爆発", 6)
		event.play_sound_effect(var4, 2)
		event.attach_object_handle_to_map_part_2(10, "p05_d02b01")
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_position(10, 280.0, -30.0, -360.0)
		var9 = 0.0
		var10 = 30.0
		while var9 < var10 do
			var11 = interpolate(0.0, 1.0, var9, var10)
			event.set_object_handle_scale(10, var11, var11, var11)
			var9 = vm.f32(var9 + 1.0)
			at = 8
			vm.wait(8)
		end
		event.set_object_handle_scale(10, 1.0, 1.0, 1.0)
		at = 9
		wait_frames(90)
		event.fade_out_screen(30)
		at = 10
		wait_frames(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_4a9b8bc5(3)
			wait_frames_skipping(30)
		end
		if at <= 2 then
			helper_21b00000()
			wait_frames_skipping(60)
		end
		if at <= 3 then
			wait_frames_skipping(15)
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			wait_frames_skipping(60)
		end
		if at <= 7 then
			var9 = 0.0
			var10 = 30.0
			var11 = interpolate(0.0, 1.0, var9, var10)
			local _ = var9 < var10
			var9 = vm.f32(var9 + 1.0)
		end
		if at <= 8 then
			wait_frames_skipping(90)
		end
		if at <= 9 then
			wait_frames_skipping(35)
		end
		return true
	end)
	at = 11
	vm.entry(11)
	event.cancel_drama_scene_skip()
	helper_10154()
	event.show_dungeon_status_bar(1, 1.0)
	helper_66ee0e0a(0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local at: number = 0
	return vm.guard(function()
		print("############################start_event_in\n")
		helper_4734c9b2(1)
		helper_e57e2768()
		at = 1
		helper_11a8d6f3()
		print("###############################start_event_out\n")
		return
	end, function(received: { any })
		if at <= 1 then
			print("###############################start_event_out\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_18268

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local at: number = 0
	return vm.guard(function()
		print("############################start_event_tree_in\n")
		event.set_function_point_enabled("", "exit", 1)
		helper_4734c9b2(1)
		helper_e57e2768()
		at = 1
		helper_11a8d6f3()
		event.reset_follow_camera(0)
		print("###############################start_event_tree_out\n")
		return
	end, function(received: { any })
		if at <= 1 then
			print("###############################start_event_tree_out\n")
			return 0
		end
		return nil
	end)
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	event.set_function_point_enabled("", "exit", 1)
	helper_4734c9b2(1)
	helper_e57e2768()
	event.play_environment_music(0)
	event.reset_follow_camera(0)
	event.initialize_event()
	helper_7d7eee8f(vm.f32(94.3), vm.f32(-7.7), vm.f32(537.9), vm.f32(2.46))
	event.set_camera_position(78.24, 23.07, 626.86)
	event.set_camera_look_at(94.3, 22.26, 537.9)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	local flag: s32 = 0
	local item: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(6) or var0
		if var0 == 1 then
			flag = event.get_save_flag(24) or flag
			if flag ~= 0 then
			else
				event.apply_message_window_preset(0, 0)
				event.set_message_bubble_tail(0, 0)
				flag = event.get_save_flag(23) or flag
				if flag ~= 0 then
					event.open_message_window_2(
						0,
						"Da w[UNI00e4]chst ein gro[UNI00df]er Spross.\nAber irgendwas fehlt noch.<page>Etwas Wachstumsf[UNI00f6]rderndes ...?\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)"
					)
				else
					event.open_message_window_2(
						0,
						"Da ist ein kleiner Sumpf. Er hat\netwas Geheimnisvolles ...\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)"
					)
				end
				event.set_character_motion(0, "立ち")
				at = 1
				var3 = helper_c292fa16(0, -1, 5, 0, 0, var3)
				event.set_message_bubble_tail(0, 1)
				if var3 == 1 then
					var0 = 2
				end
			end
		end
		if var0 == 2 then
			flag = event.get_save_flag(24) or flag
			if flag ~= 0 then
			else
				flag = event.get_save_flag(23) or flag
				if flag ~= 0 then
					event.open_use_item_menu(356)
					at = 2
					vm.wait(2)
					item = vmhost.used_item() or item
					if 0 < item then
						if item == 356 then
							event.set_character_motion(0, "立ち")
							at = 3
							helper_13d74()
							helper_acde31fa(0)
							event.set_save_flag(24, 1)
						else
							at = 4
							helper_5fb66cb1()
						end
					end
				else
					event.open_use_item_menu(361)
					at = 5
					vm.wait(5)
					item = vmhost.used_item() or item
					if 0 < item then
						if item == 361 then
							event.set_character_motion(0, "立ち")
							at = 6
							helper_11514()
							helper_acde31fa(0)
							event.set_save_flag(23, 1)
						else
							at = 7
							helper_5fb66cb1()
						end
					end
				end
			end
		end
		return
	end, function(received: { any })
		if at <= 7 then
			if at == 1 then
				var3 = received[2] :: number
			end
			if at <= 1 then
				local _ = var0 == 1
				var0 = 2
			end
			if at <= 2 then
				at = 3
				helper_13d74()
				return vm.continue_with(function()
					helper_acde31fa(0)
					event.set_save_flag(24, 1)
					return
				end)
			end
			if at <= 3 then
				helper_4a9b8bc5(0)
				helper_7c656a4f()
			end
			if at <= 5 then
				at = 6
				helper_11514()
				return vm.continue_with(function()
					helper_acde31fa(0)
					event.set_save_flag(23, 1)
					return
				end)
			end
			if at <= 6 then
				helper_4a9b8bc5(0)
				helper_7c656a4f()
			end
			return 0
		end
		return nil
	end)
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(6) or var0
	if var0 == 1 then
		helper_18268()
		helper_4734c9b2(0)
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
			wait_frames(1)
			event.fade_in_screen(1)
			wait_frames(1)
			event.apply_message_window_preset(1, 4)
			set_window_mode(1, 4)
			event.open_message_window_2(1, "To be continue...")
			open_message(1, -1, 5, 0, 0)
			helper_c956b4a2(64)
			close_message(1)
			event.fade_out_screen(30)
			wait_frames(30)
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

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local yaw: f32 = 0
	local get_angle: f32 = 0
	event.set_character_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			show_message(0, 20, 5, 256, 208)
		else
			show_message(0, 21, 5, 256, 208)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.set_character_position(0, 94.3, -7.7, 537.9)
		event.set_character_rotation(0, 0.0, 2.46, 0.0)
		event.finish_event()
		return
	end
	var1 = helper_ed4dc120(6, 16)
	if var1 == 0 then
		helper_8e2d9b9a()
		event.set_function_point_enabled("", "exit", 0)
		helper_4734c9b2(0)
		event.go_to_georama_edit(16)
		return
	else
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "歩き", 4)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.get_character_rotation(0)
		yaw = event.get_direction_angle(var2, var3, var4, 112.99, 3.46, 468.16) or yaw
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 15)
		event.move_object_sequence(0, 112.99, 3.46, 468.16, 90, 1)
		get_angle = event.get_follow_camera_angle() or get_angle
		if get_angle > vm.f32(1.5707964) or get_angle < vm.f32(-1.5707964) then
			event.move_camera_sequence(141.62, 78.35, 269.76, var2, var3 + 30.0, var4, 90)
		end
		for var10 = 0, 59 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			event.set_camera_sequence_look_at(var2, var3 + 30.0, var4)
			event.set_camera_look_at(var2, var3 + 30.0, var4)
			vm.wait(5)
		end
		event.set_object_sequence_motion(0, "立ち")
		event.reset_follow_camera(0)
		event.finish_event()
	end
end

--- Event 12551, which map data, a script or the engine runs by number.
script.event_12551 = helper_11514

--- Event 12552, which map data, a script or the engine runs by number.
script.event_12552 = helper_13d74

--- Event 12560, which map data, a script or the engine runs by number.
script.event_12560 = helper_18268

return script
