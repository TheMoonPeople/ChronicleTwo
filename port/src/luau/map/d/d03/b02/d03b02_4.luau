--!strict
-- map/d/d03/b02/d03b02_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_47084b1b = require("@lib/event/helper_47084b1b")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_5a05ed59 = require("@lib/event/helper_5a05ed59")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_80ad60c2 = require("@lib/event/helper_80ad60c2")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_f0ee9a01 = require("@lib/event/helper_f0ee9a01")
local set_window_mode = require("@lib/event/set_window_mode")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: f32 = 0
local global1: f32 = 0
local global2: f32 = 0
local global3: f32 = 0
local global4: f32 = 0
local global5: f32 = 0
local global6: f32 = 0
local global7: f32 = 0
local global8: s32 = 0
local global9: s32 = 0
local global10: s32 = 0
local global11: s32 = 0
local global12: s32 = 0
local global13: s32 = 0
local global14: s32 = 0
local global15: s32 = 0
local global16: s32 = 0
local global17: s32 = 0
local global18: s32 = 0
local global19: s32 = 0

--- Helper function.
local function helper_108ec()
	local flag: s32 = 0
	flag = event.get_save_flag(348) or flag
	if flag == 1 then
		event.set_function_point_enabled("", "e348", 0)
	end
	do
		local out1, out2, out3 = event.zero_vector()
		global0 = out1 or global0
		global1 = out2 or global1
		global2 = out3 or global2
	end
	global2 = 30.0
	do
		local out1, out2, out3 = event.zero_vector()
		global4 = out1 or global4
		global5 = out2 or global5
		global6 = out3 or global6
	end
end

--- Helper function.
local function helper_3b528()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global18 = 0
		global19 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global18)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", global18)
		event.attach_object_handle_to_character(0, global18)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global18)
		event.load_character(5, "chara/c02_base.gltf", "info", global19)
		event.load_equipment_model(5, 1, 1, "info", global19, 17)
		event.load_equipment_model(5, 1, 0, "info", global19, 18)
		event.load_equipment_model(5, 1, 4, "info", global19)
		event.load_equipment_model(5, 1, 3, "info", global19)
		event.load_equipment_model(5, 1, 2, "info", global19, 36)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global19)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", global19)
		event.attach_object_handle_to_character(1, global19)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global19)
		event.set_character_active(0, 36)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if active_chr_no == 1 then
		global18 = 32
		global19 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global18)
		event.load_equipment_model(5, 0, 1, "info", global18, 17)
		event.load_equipment_model(5, 0, 0, "info", global18, 18)
		event.load_equipment_model(5, 0, 4, "info", global18)
		event.load_equipment_model(5, 0, 3, "info", global18)
		event.load_equipment_model(5, 0, 2, "info", global18, 36)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global18)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", global18)
		event.attach_object_handle_to_character(0, global18)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global18)
		event.set_character_active(0, 36)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global19)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", global19)
		event.attach_object_handle_to_character(1, global19)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global19)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e356/e356_guiltoni.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(6, 39)
	event.clear_object_sequence(6, 39)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e300/e356/e356_jamming.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(7, 40)
	event.clear_object_sequence(7, 40)
	event.set_object_sequence_object(7, 7)
	event.load_character(5, "event/e300/e356/e356_dsmoke.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_map_part_2(8, "p01_battleship")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(10, "p01_d03b01", "d03b01_12-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p02_d03b01", "d03b01_3-m0")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(12, "p02_d03b01", "d03b01_15-m0")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_3(18, "p01_battleship", "tbig-m0")
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 18)
	event.load_message_file(0, 5, "event/e300/e356/e356.txt")
end

--- Helper function.
local function helper_23400000()
	global18 = 0
	global19 = 32
	global18 = 32
	global19 = 0
end

--- Helper function.
local function helper_3ae94()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global18)
		event.set_character_active(0, global19)
		event.delete_character_extension_packs(global18)
		event.delete_character_extension_packs(global19)
		event.delete_character(global19)
		event.delete_character(36)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global19)
		event.set_character_active(0, global18)
		event.delete_character_extension_packs(global18)
		event.delete_character_extension_packs(global19)
		event.delete_character(global18)
		event.delete_character(36)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.set_function_point_enabled("", "func", 1)
	event.set_function_point_enabled("", "func4", 1)
	event.set_object_handle_visible(12, 1)
	event.set_object_handle_scale(8, 1.0, 1.0, 1.0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	event.jump_to_map_3(-1, "d03b01", 503)
end

--- Helper function.
local function helper_3cb94()
	local projection: f32 = 0
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(152)
		helper_3b528()
		projection = event.get_event_projection() or projection
		time = event.get_scene_time_of_day() or time
		event.enable_drama_skip()
		event.set_time_of_day(21.0)
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(7, 0)
		event.set_object_sequence_texture_animation(7, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(7, 1, "目パチ")
		event.set_function_point_enabled("", "func", 0)
		event.set_function_point_enabled("", "func4", 0)
		event.set_object_sequence_rotation(11, 0.0, 1.57, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 1.57, 0.0)
		event.set_object_handle_visible(8, 1)
		event.set_object_handle_visible(9, 1)
		event.set_object_handle_visible(12, 0)
		event.set_object_sequence_rotation(13, -0.4, 1.9, 0.0)
		event.set_character_active(1, 36)
		event.set_character_active(0, global18)
		event.set_character_active(1, 39)
		event.set_character_active(0, 40)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_position(8, -3191.25, 25.75, 1213.17)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_character_active(1, 41)
		event.set_character_position(41, -3714.57, 453.25, 1349.41)
		event.set_character_rotation(41, 0.0, 1.9, 0.0)
		event.set_object_sequence_position(7, -2784.72, 25.75, 1175.72)
		event.set_object_sequence_rotation(7, 0.0, 1.41, 0.0)
		event.fade_in_screen(30)
		event.set_event_projection(1502.9)
		event.set_character_active(0, global19)
		event.set_event_projection(projection)
		event.rotate_object_sequence(8, 0.0, 0.0, 0.06, 90)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_character_active(1, 40)
		at = 2
		wait_frames(90)
		event.set_camera_sequence_look_at(-2045.72, -1258.82, 1215.53)
		event.set_camera_sequence_angle_height_distance(-1.19, -17.66, 32.97)
		event.set_object_sequence_position(6, -2040.96, -1287.62, 1214.97)
		event.set_object_sequence_rotation(6, 0.0, 2.0, 0.0)
		at = 3
		wait_frames(90)
		event.move_camera_sequence_angle_height_distance(-0.71, -17.66, 32.97, 300)
		at = 4
		wait_frames(240)
		event.set_object_sequence_motion(6, "ふりかえり", 6)
		at = 5
		wait_frames(3000)
		event.fade_out_screen(30)
		at = 6
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_23400000()
			wait_frames_skipping(90)
		end
		if at <= 2 then
			wait_frames_skipping(90)
		end
		if at <= 3 then
			wait_frames_skipping(240)
		end
		if at <= 4 then
			wait_frames_skipping(3000)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(projection)
	event.set_time_of_day(time)
	at = 7
	vm.wait(7)
	helper_3ae94()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_11b44()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global8 = 0
		global9 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global8)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", global8)
		event.attach_object_handle_to_character(0, global8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global8)
		event.load_character(5, "chara/c02_base.gltf", "info", global9)
		event.load_equipment_model(5, 1, 1, "info", global9, 17)
		event.load_equipment_model(5, 1, 0, "info", global9, 18)
		event.load_equipment_model(5, 1, 4, "info", global9)
		event.load_equipment_model(5, 1, 3, "info", global9)
		event.load_equipment_model(5, 1, 2, "info", global9, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global9)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica.chr", "info", global9)
		event.attach_object_handle_to_character(1, global9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global9)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if active_chr_no == 1 then
		global8 = 8
		global9 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global8)
		event.load_equipment_model(5, 0, 1, "info", global8, 17)
		event.load_equipment_model(5, 0, 0, "info", global8, 18)
		event.load_equipment_model(5, 0, 4, "info", global8)
		event.load_equipment_model(5, 0, 3, "info", global8)
		event.load_equipment_model(5, 0, 2, "info", global8, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global8)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", global8)
		event.attach_object_handle_to_character(0, global8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global8)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global9)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica.chr", "info", global9)
		event.attach_object_handle_to_character(1, global9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global9)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e352/e352_crest.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(5, 11)
	event.clear_object_sequence(5, 11)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "event/e300/e352/e352_lin2.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(4, 9)
	event.set_object_sequence_object(4, 4)
	event.load_character(5, "event/e300/e352/e352_guiltoni.gltf", "info", 19)
	event.set_character_active(0, 19)
	event.attach_object_handle_to_character(6, 19)
	event.clear_object_sequence(6, 19)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e300/e352/e352_jamming.gltf", "info", 20)
	event.set_character_active(0, 20)
	event.attach_object_handle_to_character(7, 20)
	event.clear_object_sequence(7, 20)
	event.set_object_sequence_object(7, 7)
	event.attach_object_handle_to_map_part_2(8, "p01_battleship")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(11, "p01_battleship", "t01-m0")
	event.load_character(5, "event/e300/e352/e352_houdai.gltf", "info", 15)
	event.set_character_active(0, 15)
	event.attach_object_handle_to_character(10, 15)
	event.clear_object_sequence(10, 15)
	event.set_object_sequence_object(10, 10)
	event.load_character(5, "event/e300/e352/e352_gun_f.gltf", "info", 21)
	event.set_character_active(0, 21)
	event.load_character(5, "event/e300/e352/e352_gun_l.gltf", "info", 22)
	event.set_character_active(0, 22)
	event.attach_object_handle_to_character(12, 22)
	event.clear_object_sequence(11, 22)
	event.set_object_sequence_object(11, 12)
	event.load_character(5, "event/e300/e352/e352_gun_h.gltf", "info", 23)
	event.set_character_active(0, 23)
	event.copy_character(5, 23, 16)
	event.set_character_active(0, 16)
	event.load_character(5, "event/e300/e356/e356_dwarp.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.attach_object_handle_to_character(14, 13)
	event.clear_object_sequence(14, 13)
	event.set_object_sequence_object(14, 14)
	event.load_message_file(0, 5, "event/e300/e352/e352_1.txt")
end

--- Helper function.
local function helper_22300000()
	global8 = 0
	global9 = 8
	global8 = 8
	global9 = 0
end

--- Helper function.
local function helper_11414()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global8)
		event.set_character_active(0, global9)
		event.delete_character_extension_packs(global8)
		event.delete_character_extension_packs(global9)
		event.delete_character(global9)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global9)
		event.set_character_active(0, global8)
		event.delete_character_extension_packs(global8)
		event.delete_character_extension_packs(global9)
		event.delete_character(global8)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(9)
	event.delete_character(11)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(21)
	event.delete_character(22)
	event.delete_character(23)
	event.delete_character(16)
	event.delete_character(15)
	event.delete_character(13)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_scale(8, 1.0, 1.0, 1.0)
	event.set_object_handle_visible(11, 1)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
	event.load_dungeon_map("d03b01")
	event.load_event_script("d03b01/d03b01.stb", 504)
end

--- Helper function.
local function helper_13668()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		at = 3
		vm.wait(3)
		at = 4
		vm.wait(4)
		event.load_music(53)
		event.load_map_sounds(3833)
		var4 = event.load_sound_effect_file_2(3833) or var4
		event.play_music(0)
		helper_11b44()
		projection = event.get_event_projection() or projection
		time = event.get_scene_time_of_day() or time
		event.enable_drama_skip()
		event.set_time_of_day(18.0)
		event.set_time_of_day_advancing(0)
		event.reset_event_sprite(5)
		event.set_event_sprite_type(5, 0)
		event.set_event_sprite_texture_rect(5, 0, 0, 512, 128)
		event.set_event_sprite_size(5, 512, 128)
		event.set_event_sprite_position(5, 320, 334)
		event.set_event_sprite_color(5, 128, 128, 128, 128)
		event.set_event_sprite_scale(5, 1.0, 1.0)
		event.set_event_sprite_draw_pass(5, 0)
		event.attach_object_handle_to_sprite(15, 5)
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		event.set_event_sprite_draw_pass(5, 1)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "左向き目パチ")
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "わらい顔")
		event.set_object_sequence_texture_animation(5, 1, "わらい目パチ")
		event.set_object_sequence_texture_animation(7, 0)
		event.set_object_sequence_texture_animation(7, 1, "目パチ")
		event.set_object_sequence_position(8, -3191.25, 25.75, -1213.17)
		event.set_character_position(13, -3191.25, 25.75, 213.17)
		event.set_character_rotation(13, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(7, -2749.5, 25.75, 1190.29)
		event.set_object_sequence_rotation(7, 0.0, 2.16, 0.0)
		event.set_object_sequence_position(6, -2755.39, 25.75, 1165.67)
		event.set_object_sequence_rotation(6, 0.0, 2.0, 0.0)
		event.set_object_handle_frame_visible(4, "houki", 1)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(10, "立ち", 4)
		event.set_object_handle_visible(8, 0)
		event.set_object_handle_visible(9, 0)
		event.set_camera_sequence_position(-541.54, -501.71, -4164.15)
		event.set_camera_sequence_look_at(29.42, 66.85, -125.36)
		event.set_character_active(0, 12)
		event.set_character_active(0, global8)
		event.set_character_active(0, global9)
		event.set_character_active(1, 9)
		event.set_character_active(1, 11)
		event.move_camera_sequence(-375.99, -501.71, -2993.11, 194.93, 66.85, 1045.42, 90)
		event.set_object_sequence_motion(4, "手すり立ち", 4)
		event.set_object_sequence_motion(5, "手すり上見立ち", 4)
		event.set_object_sequence_position(5, -277.63, 0.0, 112.11)
		event.set_object_sequence_rotation(5, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(4, -284.8, 0.0, 93.56)
		event.set_object_sequence_rotation(4, 0.0, -1.12, 0.0)
		at = 5
		wait_frames(1)
		event.start_crossfade(30)
		event.set_object_sequence_color(15, 128, 128, 128, 0, 0)
		at = 6
		wait_camera()
		event.set_camera_sequence_position(559.2, 635.48, -195.62)
		event.set_camera_sequence_look_at(-204.68, 598.78, 74.08)
		event.start_crossfade(30)
		event.move_camera_sequence_eased(559.2, 143.2, -195.62, -204.68, 106.5, 74.08, 200, 2, 1.0)
		at = 7
		wait_camera()
		event.set_object_handle_shadow_enabled(5, 0)
		event.set_object_handle_shadow_enabled(4, 0)
		event.set_camera_sequence_position(-367.55, 25.75, 136.21)
		event.set_camera_sequence_look_at(-204.68, 29.95, 74.08)
		event.start_crossfade(30)
		event.set_mouth_texture_animations(5, "わらい口パク")
		at = 8
		helper_4116e6bb(3520030)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "左を見る", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_camera_sequence_position(-291.37, 30.93, 159.38)
		event.set_camera_sequence_look_at(-284.82, 29.95, 71.35)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 9
		helper_4116e6bb(3520040)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(5, "わらい口パク")
		at = 10
		helper_4116e6bb(3520050)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "右を見る", 6)
		event.queue_object_sequence_next_motion(5, "右を見るL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_mouth_texture_animations(4, "わらい口パク")
		at = 11
		helper_4116e6bb(3520060)
		event.reset_mouth_texture_animations()
		at = 12
		wait_frames(30)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "大わらい顔")
		event.set_object_sequence_texture_animation(5, 1, "わらい目パチ")
		event.set_camera_sequence_position(-316.38, 25.02, 113.48)
		event.set_camera_sequence_look_at(-254.42, 29.95, 91.23)
		event.set_mouth_texture_animations(5, "わらい口パク")
		at = 13
		helper_4116e6bb(3520070)
		event.reset_mouth_texture_animations()
		at = 14
		wait_frames(30)
		event.set_object_sequence_motion(4, "左を見る戻り", 6)
		event.queue_object_sequence_next_motion(4, "手すり立ち", 4)
		event.move_camera_sequence_eased(-339.97, 25.02, 121.96, -254.42, 29.95, 91.23, 30, 2, 1.0)
		at = 15
		wait_frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 16
		helper_4116e6bb(3520080)
		event.reset_mouth_texture_animations()
		event.fade_out_music(30)
		at = 17
		wait_frames(30)
		event.stop_music(0)
		event.set_object_sequence_motion(5, "右を見る戻り", 6)
		event.queue_object_sequence_next_motion(5, "手すり立ち", 4)
		at = 18
		wait_frames(30)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "おこり顔")
		event.set_object_sequence_texture_animation(5, 1, "おこり目パチ")
		at = 19
		wait_frames(60)
		event.set_object_handle_shadow_enabled(5, 1)
		event.set_object_handle_shadow_enabled(4, 1)
		event.load_music(32)
		event.play_music(0)
		event.set_camera_sequence_position(-175.49, 25.02, 56.65)
		event.set_camera_sequence_look_at(-360.31, 29.95, 136.99)
		at = 20
		wait_frames(1)
		event.set_object_handle_scale(14, 2.0, 2.0, 2.0)
		event.set_character_active(1, 13)
		event.set_character_motion(13, "消える", 2, -1, 1)
		event.set_motion_blur(80)
		event.set_object_handle_visible(8, 1)
		event.start_crossfade(40)
		event.play_sound_effect(var4, 4)
		event.move_object_sequence(8, -3191.25, 25.75, 1000.17, 10)
		event.move_object_sequence(14, -3191.25, 25.75, 2000.17, 10)
		at = 21
		wait_objects(8)
		event.move_object_sequence_eased(8, -3191.25, 25.75, 1213.17, 15, 2, 1.0)
		event.move_object_sequence_eased(14, -3191.25, 25.75, 2213.17, 15, 2, 1.0)
		event.set_character_active(1, 19)
		event.set_character_active(1, 20)
		at = 22
		wait_frames(60)
		event.play_sound_effect(var4, 5)
		at = 23
		wait_frames(60)
		event.set_motion_blur(0)
		event.set_object_sequence_position(8, -3191.25, 25.75, 1213.17)
		event.set_camera_sequence_position(2029.74, 25.02, 5512.95)
		event.set_camera_sequence_look_at(-250.33, 29.95, 2458.27)
		at = 24
		wait_frames(120)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "無表情")
		event.set_object_sequence_texture_animation(5, 1, "通常目パチ")
		event.set_object_sequence_motion(5, "身を乗りだす", 6)
		event.queue_object_sequence_next_motion(5, "身を乗りだすL", 4)
		event.set_camera_sequence_position(-279.45, 29.47, 165.03)
		event.set_camera_sequence_look_at(-304.59, 29.95, 74.61)
		event.play_sound_effect(var4, 6)
		event.set_mouth_texture_animations(5, "通常口パク")
		at = 25
		helper_4116e6bb(3520090)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 7)
		event.set_object_sequence_motion(4, "身を乗りだす", 6)
		event.queue_object_sequence_next_motion(4, "身を乗りだすL", 4)
		at = 26
		wait_frames(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(-322.93, 29.47, 119.9, -410.56, 29.95, 157.34)
		event.add_camera_sequence_path_point(-1822.73, 29.47, 760.68, -1910.36, 29.95, 798.12)
		event.start_camera_sequence_path()
		at = 27
		wait_camera()
		event.set_camera_sequence_position(-2644.48, 43.74, 1174.79)
		event.set_camera_sequence_look_at(-2727.12, 58.9, 1167.6)
		event.start_crossfade(30)
		at = 28
		wait_frames(120)
		event.play_sound_effect(var4, 8)
		event.set_camera_sequence_position(-2700.02, 51.13, 1176.52)
		event.set_camera_sequence_look_at(-2753.54, 58.9, 1178.03)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 29
		helper_4116e6bb(3520100)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(7, "うなづき", 6)
		event.queue_object_sequence_next_motion(7, "立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 30
		helper_4116e6bb(3520110)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 31
		helper_4116e6bb(3520120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_position(6, -2777.54, 25.75, 1176.5)
		event.set_object_sequence_rotation(6, 0.0, 2.4, 0.0)
		event.set_event_projection(584.9)
		event.set_camera_sequence_position(-2817.33, 55.98, 1202.06)
		event.set_camera_sequence_look_at(-2734.28, 58.9, 1166.34)
		event.start_crossfade(30)
		event.play_sound_effect(var4, 9)
		event.rotate_object_sequence(6, 0.0, -1.0, 0.0, 30)
		event.set_object_sequence_motion(6, "振り返り（ＰＧ）左", 6)
		event.queue_object_sequence_next_motion(6, "振り返り（ＰＧ）左Ｌ", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 32
		helper_4116e6bb(3520130)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(7, "右見る", 6)
		event.queue_object_sequence_next_motion(7, "右見るＬ", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 33
		helper_4116e6bb(3520140)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(6, "そのまま左向き", 6)
		event.queue_object_sequence_next_motion(6, "そのまま左向きＬ", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 34
		helper_4116e6bb(3520150)
		event.reset_mouth_texture_animations()
		at = 35
		wait_objects(6)
		event.play_sound_effect(var4, 10)
		event.set_object_sequence_motion(7, "右からはっ", 6)
		event.queue_object_sequence_next_motion(7, "戻り", 6)
		event.queue_object_sequence_next_motion(7, "立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 36
		helper_4116e6bb(3520160)
		event.reset_mouth_texture_animations()
		at = 37
		wait_objects(7)
		event.set_object_sequence_motion(6, "戻り", 6)
		at = 38
		wait_frames(10)
		event.stop_sound_effect(var4, 8)
		event.set_event_projection(projection)
		event.set_object_sequence_rotation(10, 0.0, 1.92, 0.0)
		event.set_character_active(1, 15)
		event.set_object_handle_visible(11, 0)
		event.set_object_sequence_position(10, -2458.92, 167.76, 852.48)
		event.set_camera_sequence_position(-1958.78, 43.74, 1048.53)
		event.set_camera_sequence_look_at(-2036.51, 58.9, 1019.15)
		event.play_sound_effect(var4, 11)
		event.set_object_sequence_motion(10, "横から縦移動", 6)
		event.queue_object_sequence_next_motion(10, "狙う", 6)
		event.queue_object_sequence_next_motion(10, "狙い立ち", 6)
		at = 39
		wait_frames(120)
		event.play_sound_effect(var4, 12)
		event.set_event_projection(222.0)
		event.set_camera_sequence_position(-2502.08, 289.28, 872.69)
		event.set_camera_sequence_look_at(-2429.52, 237.57, 840.94)
		at = 40
		wait_objects(10)
		event.stop_sound_effect(var4, 12)
		at = 41
		wait_frames(30)
		event.set_event_projection(projection)
		event.set_camera_sequence_position(-1862.68, 19.26, 1357.68)
		event.set_camera_sequence_look_at(-2351.83, 177.35, 866.18)
		event.set_character_position(21, -2279.73, 181.5, 788.22)
		event.set_character_rotation(21, 0.0, 1.9, 0.0)
		event.set_character_position(22, -2279.73, 181.5, 788.22)
		event.set_character_rotation(22, 0.0, 1.9, 0.0)
		event.set_character_active(1, 21)
		event.play_sound_effect(var4, 13)
		event.set_character_motion(21, "発射", 6, -1, 1)
		event.set_object_sequence_motion(10, "発射", 6)
		event.queue_object_sequence_next_motion(10, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		at = 42
		wait_frames(5)
		event.set_character_active(1, 22)
		event.move_object_sequence(11, -1846.06, 191.5, 633.95, 10)
		at = 43
		wait_frames(60)
		event.set_character_active(0, 22)
		event.play_sound_effect(var4, 13)
		event.set_character_motion(21, "発射", 6, -1, 1)
		event.set_object_sequence_motion(10, "発射", 6)
		event.queue_object_sequence_next_motion(10, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		at = 44
		wait_frames(5)
		event.set_character_active(1, 22)
		event.set_character_position(22, -2279.73, 181.5, 788.22)
		event.set_character_rotation(22, 0.0, 1.9, 0.0)
		event.move_object_sequence(11, -1846.06, 191.5, 633.95, 10)
		at = 45
		wait_frames(60)
		event.set_character_active(0, 22)
		event.play_sound_effect(var4, 13)
		event.set_character_motion(21, "発射", 2, -1, 1)
		event.set_object_sequence_motion(10, "発射", 6)
		event.queue_object_sequence_next_motion(10, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		at = 46
		wait_frames(5)
		event.set_character_active(1, 22)
		event.set_character_position(22, -2279.73, 181.5, 788.22)
		event.set_character_rotation(22, 0.0, 1.9, 0.0)
		event.move_object_sequence(11, -1846.06, 191.5, 633.95, 10)
		at = 47
		wait_frames(60)
		event.set_character_active(0, 21)
		event.set_character_active(0, 22)
		event.set_object_handle_frame_visible(4, "houki", 0)
		event.set_object_sequence_motion(5, "倒れ", 6)
		event.set_object_sequence_motion(4, "倒れ", 6)
		event.set_object_sequence_position(5, -190.72, 0.0, 61.97)
		event.set_object_sequence_rotation(5, 0.0, 0.72, 0.0)
		event.set_object_sequence_position(4, -193.0, 0.0, 66.79)
		event.set_object_sequence_rotation(4, 0.0, 1.04, 0.0)
		event.set_camera_sequence_position(1488.6, 102.72, 416.88)
		event.set_camera_sequence_look_at(842.64, 111.52, 481.71)
		event.set_character_scale(23, 1.5, 1.5, 1.5)
		event.set_character_scale(16, 1.5, 1.5, 1.5)
		event.set_character_position(23, -171.72, -180.78, 261.44)
		event.set_character_rotation(23, 0.0, 0.0, 0.0)
		event.set_character_position(16, -228.91, 218.2, 212.99)
		event.set_character_rotation(16, 0.0, 0.0, 0.0)
		event.set_character_active(1, 23)
		event.set_character_motion(23, "ヒット", 6, -1, 1)
		event.play_sound_effect(var4, 14)
		event.shake_camera_sequence(0.0, 1.6, 0.0, 60)
		at = 48
		wait_frames(60)
		event.set_character_active(0, 23)
		event.set_camera_sequence_position(228.78, 144.09, 1023.49)
		event.set_camera_sequence_look_at(-311.5, -61.26, 184.25)
		event.shake_camera_sequence(0.0, 1.6, 0.0, 120)
		event.set_character_active(1, 16)
		event.set_character_motion(16, "ヒット", 6, -1, 1)
		event.play_sound_effect(var4, 14)
		at = 49
		wait_frames(60)
		event.set_character_active(1, 23)
		event.set_character_motion(23, "ヒット", 6, -1, 1)
		event.play_sound_effect(var4, 14)
		at = 50
		wait_frames(60)
		event.fade_out_screen(30)
		at = 51
		wait_frames(30)
		at = 52
		wait_frames(15)
		event.set_function_point_enabled("", "func2", 1)
		event.set_function_point_enabled("", "func3", 1)
		event.set_function_point_enabled("", "func0", 0)
		event.set_object_handle_visible(9, 1)
		event.play_sound_effect(var4, 15)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 90)
		event.set_camera_sequence_position(26.69, 78.26, -14.0)
		event.set_camera_sequence_look_at(-133.35, 46.81, 45.49)
		event.fade_in_screen(30)
		at = 53
		wait_frames(120)
		event.set_object_sequence_motion(5, "身を起こす", 6)
		event.set_object_sequence_motion(4, "身を起こす", 6)
		event.play_sound_effect(var4, 16)
		event.set_camera_sequence_position(-140.11, 17.78, 75.17)
		event.set_camera_sequence_look_at(-196.15, 7.54, 67.76)
		at = 54
		wait_frames(60)
		event.play_sound_effect(var4, 17)
		event.set_object_sequence_motion(5, "起きあがる", 6)
		event.queue_object_sequence_next_motion(5, "起きあがるL", 4)
		event.set_object_sequence_motion(4, "起きあがる", 6)
		event.queue_object_sequence_next_motion(4, "起きあがるL", 4)
		event.set_object_sequence_position(5, -203.17, 0.0, 74.79)
		event.set_object_sequence_rotation(5, 0.0, -1.02, 0.0)
		event.set_object_sequence_position(4, -181.97, 0.0, 71.68)
		event.set_object_sequence_rotation(4, 0.0, -2.0, 0.0)
		event.set_camera_sequence_position(-26.74, 52.18, 5.97)
		event.set_camera_sequence_look_at(-138.01, 41.95, 46.59)
		at = 55
		wait_frames(120)
		event.set_character_active(0, 23)
		event.set_character_active(0, 16)
		event.set_camera_sequence_position(-214.82, 16.87, 105.28)
		event.set_camera_sequence_look_at(-206.28, 22.54, 81.27)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-219.67, 16.87, 118.95, -206.28, 22.54, 81.27)
		event.add_camera_sequence_path_point(-214.82, 16.87, 105.28, -206.28, 22.54, 81.27)
		event.start_camera_sequence_path()
		event.fade_out_music(200)
		at = 56
		wait_camera()
		event.stop_music(0)
		event.stop_sound_effect(var4, 5)
	end, function(received: { any }): boolean
		if at <= 4 then
			helper_22300000()
			wait_frames_skipping(1)
		end
		if at <= 5 then
			helper_344d6cd8()
		end
		if at <= 6 then
			helper_344d6cd8()
		end
		if at <= 7 then
			helper_8cd371d7(3520030)
		end
		if at <= 8 then
			helper_8cd371d7(3520040)
		end
		if at <= 9 then
			helper_8cd371d7(3520050)
		end
		if at <= 10 then
			helper_8cd371d7(3520060)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		if at <= 12 then
			helper_8cd371d7(3520070)
		end
		if at <= 13 then
			wait_frames_skipping(30)
		end
		if at <= 14 then
			wait_frames_skipping(30)
		end
		if at <= 15 then
			helper_8cd371d7(3520080)
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			wait_frames_skipping(30)
		end
		if at <= 18 then
			wait_frames_skipping(60)
		end
		if at <= 19 then
			wait_frames_skipping(1)
		end
		if at <= 20 then
			helper_238b5abc(8)
		end
		if at <= 21 then
			wait_frames_skipping(60)
		end
		if at <= 22 then
			wait_frames_skipping(60)
		end
		if at <= 23 then
			wait_frames_skipping(120)
		end
		if at <= 24 then
			helper_8cd371d7(3520090)
		end
		if at <= 25 then
			wait_frames_skipping(60)
		end
		if at <= 26 then
			helper_344d6cd8()
		end
		if at <= 27 then
			wait_frames_skipping(120)
		end
		if at <= 28 then
			helper_8cd371d7(3520100)
		end
		if at <= 29 then
			helper_8cd371d7(3520110)
		end
		if at <= 30 then
			helper_8cd371d7(3520120)
		end
		if at <= 31 then
			helper_8cd371d7(3520130)
		end
		if at <= 32 then
			helper_8cd371d7(3520140)
		end
		if at <= 33 then
			helper_8cd371d7(3520150)
		end
		if at <= 34 then
			helper_238b5abc(6)
		end
		if at <= 35 then
			helper_8cd371d7(3520160)
		end
		if at <= 36 then
			helper_238b5abc(7)
		end
		if at <= 37 then
			wait_frames_skipping(10)
		end
		if at <= 38 then
			wait_frames_skipping(120)
		end
		if at <= 39 then
			helper_238b5abc(10)
		end
		if at <= 40 then
			wait_frames_skipping(30)
		end
		if at <= 41 then
			wait_frames_skipping(5)
		end
		if at <= 42 then
			wait_frames_skipping(60)
		end
		if at <= 43 then
			wait_frames_skipping(5)
		end
		if at <= 44 then
			wait_frames_skipping(60)
		end
		if at <= 45 then
			wait_frames_skipping(5)
		end
		if at <= 46 then
			wait_frames_skipping(60)
		end
		if at <= 47 then
			wait_frames_skipping(60)
		end
		if at <= 48 then
			wait_frames_skipping(60)
		end
		if at <= 49 then
			wait_frames_skipping(60)
		end
		if at <= 50 then
			wait_frames_skipping(30)
		end
		if at <= 51 then
			wait_frames_skipping(15)
		end
		if at <= 52 then
			wait_frames_skipping(120)
		end
		if at <= 53 then
			wait_frames_skipping(60)
		end
		if at <= 54 then
			wait_frames_skipping(120)
		end
		if at <= 55 then
			helper_344d6cd8()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 57
	wait_frames(30)
	event.stop_port_sound_effects(4)
	event.set_event_projection(projection)
	event.set_motion_blur(0)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.skip_next_map_sound_load()
	event.skip_next_music_load()
	at = 58
	vm.wait(58)
	at = 59
	helper_11414()
end

--- Helper function.
local function helper_19860()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global10 = 0
		global11 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global10)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", global10)
		event.attach_object_handle_to_character(0, global10)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global10)
		event.load_character(5, "chara/c02_base.gltf", "info", global11)
		event.load_equipment_model(5, 1, 1, "info", global11, 17)
		event.load_equipment_model(5, 1, 0, "info", global11, 18)
		event.load_equipment_model(5, 1, 4, "info", global11)
		event.load_equipment_model(5, 1, 3, "info", global11)
		event.load_equipment_model(5, 1, 2, "info", global11, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global11)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica1.gltf", "info", global11)
		event.attach_object_handle_to_character(1, global11)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if active_chr_no == 1 then
		global10 = 8
		global11 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global10)
		event.load_equipment_model(5, 0, 1, "info", global10, 17)
		event.load_equipment_model(5, 0, 0, "info", global10, 18)
		event.load_equipment_model(5, 0, 4, "info", global10)
		event.load_equipment_model(5, 0, 3, "info", global10)
		event.load_equipment_model(5, 0, 2, "info", global10, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global10)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", global10)
		event.attach_object_handle_to_character(0, global10)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global10)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global11)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica1.gltf", "info", global11)
		event.attach_object_handle_to_character(1, global11)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global11)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e352/e352_lin2.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(4, 9)
	event.set_object_sequence_object(4, 4)
	event.attach_object_handle_to_map_part_2(8, "p01_battleship")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(10, "p01_d03b01", "d03b01_12-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p02_d03b01", "d03b01_3-m0")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(18, "p02_d03b01", "d03b01_15-m0")
	event.clear_object_sequence(17)
	event.set_object_sequence_object(17, 18)
	event.load_message_file(0, 5, "event/e300/e352/e352_1.txt")
	event.assign_memory_stack(6)
	event.clear_memory_stack(6)
	event.load_character(6, "event/e300/e352/e352_crest.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(5, 11)
	event.clear_object_sequence(5, 11)
	event.set_object_sequence_object(5, 5)
	event.load_character(6, "event/e300/e352/e352_guiltoni.gltf", "info", 19)
	event.set_character_active(0, 19)
	event.attach_object_handle_to_character(6, 19)
	event.clear_object_sequence(6, 19)
	event.set_object_sequence_object(6, 6)
	event.load_character(6, "event/e300/e352/e352_jamming.gltf", "info", 20)
	event.set_character_active(0, 20)
	event.attach_object_handle_to_character(7, 20)
	event.clear_object_sequence(7, 20)
	event.set_object_sequence_object(7, 7)
	event.load_character(6, "event/e300/e352/e352_warp.gltf", "info", 16)
	event.set_character_active(0, 16)
	event.set_character_scale(16, 1.1, 1.1, 1.1)
	event.load_character(6, "event/e300/e352/e352_monica_hi.gltf", "info", 15)
	event.set_character_active(0, 15)
end

--- Helper function.
local function helper_22b00000()
	global10 = 0
	global11 = 8
	global10 = 8
	global11 = 0
end

--- Helper function.
local function helper_190b8()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global10)
		event.set_character_active(0, global11)
		event.delete_character_extension_packs(global10)
		event.delete_character_extension_packs(global11)
		event.delete_character(global11)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global11)
		event.set_character_active(0, global10)
		event.delete_character_extension_packs(global10)
		event.delete_character_extension_packs(global11)
		event.delete_character(global10)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(9)
	event.delete_character(11)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(21)
	event.delete_character(22)
	event.delete_character(23)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.set_function_point_enabled("", "func", 1)
	event.set_function_point_enabled("", "func4", 1)
	event.set_function_point_enabled("", "func2", 0)
	event.set_function_point_enabled("", "func3", 0)
	event.set_object_handle_visible(18, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.show_dungeon_status_bar(1, 1.0)
	vm.wait(1)
	event.finish_event()
end

--- Helper function.
local function helper_1b1b4()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local active_chr_no: s32 = 0
	local at: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(51)
		event.load_map_sounds(3839)
		var4 = event.load_sound_effect_file_2(3839) or var4
		event.play_music(0)
		helper_19860()
		projection = event.get_event_projection() or projection
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(18.0)
		event.set_time_of_day_advancing(0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "無表情")
		event.set_object_sequence_texture_animation(5, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(4, 1, "半口")
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(7, 0)
		event.set_object_sequence_texture_animation(7, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(7, 1, "目パチ")
		event.set_object_handle_visible(9, 1)
		event.set_function_point_enabled("", "func2", 1)
		event.set_function_point_enabled("", "func3", 1)
		event.set_function_point_enabled("", "func0", 0)
		event.set_function_point_enabled("", "func", 0)
		event.set_function_point_enabled("", "func4", 0)
		event.set_object_sequence_rotation(11, 0.0, 1.57, 0.0)
		event.set_object_sequence_rotation(17, 0.0, 1.57, 0.0)
		event.set_object_handle_visible(8, 1)
		event.set_object_handle_visible(18, 0)
		event.play_sound_effect(var4, 4)
		event.play_sound_effect(var4, 5)
		event.set_camera_sequence_position(-104.47, 123.32, -554.46)
		event.set_camera_sequence_look_at(123.37, 22.54, -57.61)
		event.set_character_active(1, 12)
		event.set_character_active(1, global10)
		event.set_character_active(1, global11)
		event.set_character_active(1, 9)
		event.set_character_active(1, 11)
		event.set_character_active(1, 19)
		event.set_character_active(0, 20)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_position(8, -3191.25, 25.75, 1213.17)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(7, -2749.5, 25.75, 1190.29)
		event.set_object_sequence_rotation(7, 0.0, 2.16, 0.0)
		event.set_object_sequence_position(6, -2755.39, 25.75, 1165.67)
		event.set_object_sequence_rotation(6, 0.0, 1.92, 0.0)
		event.set_object_sequence_position(10, 0.0, -50.0, 0.0)
		event.set_object_sequence_position(5, -166.32, 0.0, 83.49)
		event.set_object_sequence_rotation(5, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(4, -71.49, 0.0, 76.37)
		event.set_object_sequence_rotation(4, 0.0, -1.12, 0.0)
		event.set_object_sequence_position(0, 0.0, -50.0, 10.0)
		event.set_object_sequence_rotation(0, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(1, 0.0, -50.0, -10.0)
		event.set_object_sequence_rotation(1, 0.0, -1.2, 0.0)
		event.fade_in_screen(30)
		event.move_object_sequence(1, 0.0, 0.0, -10.0, 180)
		event.move_object_sequence(0, 0.0, 0.0, 10.0, 180)
		event.move_object_sequence(10, 0.0, 0.0, 0.0, 180)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-104.47, 123.32, -554.46, 123.37, 22.54, -57.61)
		event.add_camera_sequence_path_point(-295.35, 123.32, -466.93, -67.52, 22.54, 29.92)
		event.start_camera_sequence_path()
		at = 2
		wait_camera()
		event.enable_drama_skip()
		event.set_camera_sequence_position(94.12, 16.49, 28.03)
		event.set_camera_sequence_look_at(-65.76, 22.54, 25.67)
		at = 3
		wait_frames(30)
		event.stop_sound_effect(var4, 5)
		event.play_sound_effect(var4, 6)
		event.set_object_sequence_motion(5, "振り向く", 6)
		event.queue_object_sequence_next_motion(5, "振り向くL", 4)
		event.set_object_sequence_motion(4, "振り向く", 6)
		event.queue_object_sequence_next_motion(4, "振り向くL", 4)
		at = 4
		wait_frames(60)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_rotation(4, 0.0, -1.12, 0.0)
		event.set_camera_sequence_position(-268.03, 16.49, 76.91)
		event.set_camera_sequence_look_at(-65.76, 22.54, 25.67)
		event.set_object_sequence_motion(1, "歩き", 4, 0.75)
		event.move_object_sequence(1, -263.33, 0.0, 81.55, 180, 1)
		event.set_mouth_texture_animations(5, "通常口パク")
		at = 5
		helper_1584c528(3520190, -1)
		event.reset_mouth_texture_animations()
		at = 6
		wait_frames(30)
		event.set_camera_sequence_position(-198.27, 24.06, -15.13)
		event.set_camera_sequence_look_at(-143.41, 22.54, 150.46)
		event.set_object_sequence_rotation(5, 0.0, 0.24, 0.0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 7
		helper_1584c528(3520200, 60)
		event.reset_mouth_texture_animations()
		at = 8
		wait_frames(60)
		event.set_object_sequence_rotation(5, 0.0, -1.2, 0.0)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.set_camera_sequence_position(-297.3, 23.01, 69.91)
		event.set_camera_sequence_look_at(-176.77, 22.54, 113.71)
		at = 9
		wait_objects(1)
		event.set_object_sequence_motion(1, "にらむ", 4)
		at = 10
		wait_frames(60)
		event.set_camera_sequence_position(-149.75, 53.84, 30.37)
		event.set_camera_sequence_look_at(-284.64, 36.42, 86.71)
		event.play_sound_effect(var4, 7)
		at = 11
		wait_frames(45)
		event.set_camera_sequence_position(-2289.28, -11.1, 1309.03)
		event.set_camera_sequence_look_at(-2581.77, 22.54, 1222.45)
		event.play_sound_effect(var4, 7)
		at = 12
		wait_frames(45)
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "わらい顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		event.set_camera_sequence_position(-2702.74, 44.98, 1141.15)
		event.set_camera_sequence_look_at(-2834.5, 81.31, 1195.57)
		event.set_camera_sequence_position(-2702.74, 48.17, 1141.15)
		event.set_camera_sequence_look_at(-2834.5, 105.2, 1195.57)
		event.set_object_sequence_position(6, -2755.39, 38.24, 1165.67)
		event.set_object_sequence_rotation(6, 0.0, 1.92, 0.0)
		event.reset_object_sequence_dynamic_animation(6)
		event.play_sound_effect(var4, 7)
		at = 13
		wait_frames(45)
		event.set_object_sequence_position(6, -2755.39, 25.75, 1165.67)
		event.set_object_sequence_rotation(6, 0.0, 1.92, 0.0)
		event.set_object_sequence_motion(1, "上にらみ", 4)
		event.set_camera_sequence_position(-297.3, 23.01, 69.91)
		event.set_camera_sequence_look_at(-176.77, 22.54, 113.71)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 14
		helper_4116e6bb(3520203)
		event.reset_mouth_texture_animations()
		at = 15
		wait_frames(30)
		event.set_camera_sequence_position(-391.93, 13.26, 98.06)
		event.set_camera_sequence_look_at(-272.34, 20.12, 89.15)
		at = 16
		wait_frames(30)
		event.play_sound_effect(var4, 8)
		event.set_character_position(15, -347.49, -8.42, 91.78)
		event.set_character_active(1, 15)
		event.set_character_motion(15, "ｴﾌｪｸﾄ_モニカ火", 6, -1, 1)
		event.set_object_sequence_motion(1, "あつい", 6)
		event.queue_object_sequence_next_motion(1, "あついL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 17
		helper_1584c528(3520205, -1)
		event.reset_mouth_texture_animations()
		at = 18
		wait_frames(15)
		event.set_object_sequence_position(5, -157.43, 0.0, 37.77)
		event.set_object_sequence_rotation(5, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(4, -113.67, 0.0, 42.81)
		event.set_object_sequence_rotation(4, 0.0, -1.12, 0.0)
		event.set_object_sequence_position(0, -159.45, 0.0, 85.12)
		event.set_object_sequence_rotation(0, 0.0, -1.56, 0.0)
		event.set_character_active(0, 15)
		event.set_camera_sequence_position(17.51, 106.77, -12.07)
		event.set_camera_sequence_look_at(-167.62, 22.54, 62.55)
		at = 19
		wait_frames(30)
		event.stop_music(0)
		at = 20
		vm.wait(20)
		at = 21
		vm.wait(21)
		at = 22
		vm.wait(22)
		at = 23
		vm.wait(23)
		event.load_music(33)
		event.play_music(0)
		event.set_object_sequence_rotation(5, 0.0, -2.64, 0.0)
		event.set_object_sequence_position(4, -110.41, 0.0, 20.43)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 6)
		event.queue_object_sequence_next_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_camera_sequence_position(-198.48, 18.18, 1.71)
		event.set_camera_sequence_look_at(-152.88, 22.54, 67.21)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 24
		helper_4116e6bb(3520210)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "しがみつく", 6)
		event.queue_object_sequence_next_motion(5, "しがみつくL", 4)
		event.set_object_sequence_motion(4, "しがみつく", 6)
		event.queue_object_sequence_next_motion(4, "しがみつくL", 4)
		event.set_object_sequence_position(4, -157.43, 0.0, 37.77)
		event.set_object_sequence_rotation(4, 0.0, -2.62, 0.0)
		event.play_sound_effect(var4, 9)
		event.set_camera_sequence_position(-195.7, 18.18, -27.74)
		event.set_camera_sequence_look_at(-152.88, 22.54, 67.21)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 6)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 25
		helper_4116e6bb(3520220)
		event.reset_mouth_texture_animations()
		at = 26
		wait_frames(30)
		event.set_object_sequence_position(0, -220.59, 0.0, 24.32)
		event.set_object_sequence_motion(5, "だいじょうぶ", 6)
		event.queue_object_sequence_next_motion(5, "だいじょうぶL", 4)
		event.set_object_sequence_motion(4, "だいじょうぶ", 6)
		event.queue_object_sequence_next_motion(4, "だいじょうぶL", 4)
		event.set_camera_sequence_position(-172.22, 21.82, 12.89)
		event.set_camera_sequence_look_at(-146.82, 22.54, 46.98)
		event.set_mouth_texture_animations(5, "通常口パク")
		at = 27
		helper_4116e6bb(3520230)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "なでなで", 6)
		event.queue_object_sequence_next_motion(5, "だいじょうぶL", 4)
		event.set_object_sequence_motion(4, "なでなで", 6)
		event.queue_object_sequence_next_motion(4, "だいじょうぶL", 4)
		at = 28
		wait_frames(90)
		event.play_sound_effect(var4, 11)
		event.set_object_sequence_motion(5, "方向転換", 6)
		event.queue_object_sequence_next_motion(5, "方向転換L", 4)
		event.set_object_sequence_motion(4, "方向転換", 6)
		event.queue_object_sequence_next_motion(4, "方向転換L", 4)
		at = 29
		wait_frames(60)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 30
		helper_4116e6bb(3520240)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_position(5, -182.1, 0.0, 109.05)
		event.set_object_sequence_rotation(5, 0.0, -0.56, 0.0)
		event.set_camera_sequence_position(-204.21, 71.27, 153.44)
		event.set_camera_sequence_look_at(-185.43, 22.54, 115.87)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.set_camera_sequence_position(-235.14, 83.43, 215.35)
		event.set_camera_sequence_look_at(-216.37, 22.54, 177.78)
		event.move_camera_sequence_eased(-201.16, 83.43, 147.34, -182.39, 22.54, 109.77, 90, 2, 1.0)
		at = 31
		wait_frames(60)
		event.play_sound_effect(var4, 12)
		event.set_object_sequence_motion(5, "顔を上げる", 6)
		event.queue_object_sequence_next_motion(5, "顔を上げるL", 4)
		event.set_mouth_texture_animations(5, "通常口パク")
		at = 32
		helper_4116e6bb(3520250)
		event.reset_mouth_texture_animations()
		at = 33
		wait_camera()
		at = 34
		wait_frames(30)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_rotation(4, 0.0, -0.7, 0.0)
		event.set_camera_sequence_position(-85.52, 20.68, 6.25)
		event.set_camera_sequence_look_at(-208.47, 22.54, 109.19)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 35
		helper_4116e6bb(3520260)
		event.reset_mouth_texture_animations()
		at = 36
		wait_frames(20)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(25)
		event.add_camera_sequence_path_point(-85.52, 20.68, 6.25, -208.47, 22.54, 109.19)
		event.add_camera_sequence_path_point(-85.52, 20.68, 6.25, -208.47, 79.99, 109.19)
		event.start_camera_sequence_path()
		event.play_sound_effect(var4, 13)
		event.set_object_sequence_motion(5, "ジャンプ", 6)
		at = 37
		wait_frames(15)
		event.move_object_sequence(5, -182.1, 100.3, 109.05, 10)
		event.set_object_sequence_motion(4, "見上げる", 6)
		event.queue_object_sequence_next_motion(4, "見上げるL", 4)
		at = 38
		wait_camera()
		event.stop_sound_effect(var4, 8)
		event.play_sound_effect(var4, 14)
		event.set_object_sequence_motion(5, "空中", 4)
		event.set_camera_sequence_position(-492.85, 213.33, 582.49)
		event.set_camera_sequence_look_at(22.56, 390.84, -208.1)
		event.move_camera_sequence_eased(-492.85, 409.38, 582.49, 22.56, 390.84, -208.1, 180, 0, 0.5)
		event.jump_object_sequence(5, -151.79, 185.12, 324.04, -0.6, 40)
		at = 39
		wait_frames(25)
		event.set_object_sequence_motion(5, "着地", 6)
		at = 40
		wait_objects(5)
		event.play_sound_effect(var4, 16)
		event.rotate_object_sequence(5, 0.0, -2.8, 0.0, 20)
		event.set_object_sequence_motion(5, "歩き")
		at = 41
		wait_objects(5)
		event.set_object_sequence_motion(5, "立ち")
		at = 42
		wait_frames(30)
		event.play_sound_effect(var4, 15)
		event.set_object_sequence_motion(5, "ジャンプ", 6)
		event.set_object_sequence_motion(5, "空中", 5)
		at = 43
		wait_objects(5)
		event.jump_object_sequence(5, -171.87, 401.97, -73.85, -0.4, 60)
		event.set_object_sequence_motion(5, "空中", 4)
		event.delay_object_sequence_motion_track(5, 45)
		event.set_object_sequence_motion(5, "着地", 6)
		at = 44
		wait_objects(5)
		event.play_sound_effect(var4, 16)
		at = 45
		wait_frames(50)
		at = 46
		wait_camera()
		event.set_object_sequence_rotation(5, 0.0, -0.37, 0.0)
		event.set_object_sequence_motion(5, "立ち3", 4)
		event.set_camera_sequence_position(-269.68, 499.83, 184.82)
		event.set_camera_sequence_look_at(-101.0, 390.84, -261.7)
		at = 47
		wait_frames(60)
		event.delete_character(11)
		event.set_character_active(1, 20)
		event.set_camera_sequence_position(-1457.89, -261.89, 4173.26)
		event.set_camera_sequence_look_at(-421.4, -280.5, -595.03)
		event.set_object_sequence_rotation(8, 0.0, -1.0, 0.0)
		event.set_object_sequence_position(8, -544.76, -500.0, -1135.49)
		event.set_object_sequence_position(6, -348.21, -500.0, -746.45)
		event.set_object_sequence_rotation(6, 0.0, 0.72, 0.0)
		event.move_object_sequence_eased(6, -348.21, -29.77, -746.45, 420, 2, 1.0)
		event.set_object_sequence_position(7, -382.55, -500.0, -760.19)
		event.set_object_sequence_rotation(7, 0.0, 0.72, 0.0)
		event.move_object_sequence_eased(7, -382.55, -30.09, -760.19, 420, 2, 1.0)
		event.move_object_sequence_eased(8, -544.76, -29.77, -1135.49, 420, 2, 1.0)
		at = 48
		wait_frames(150)
		event.stop_sound_effect(var4, 4)
		event.play_sound_effect(var4, 17)
		event.play_sound_effect(var4, 18)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_motion(1, "にらむ", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, -81.37, 0.0, -233.88)
		event.set_object_sequence_rotation(1, 0.0, -2.74, 0.0)
		event.set_object_sequence_position(4, -95.85, 0.0, -144.83)
		event.set_object_sequence_rotation(4, 0.0, -2.74, 0.0)
		event.set_object_sequence_position(0, -27.4, 0.0, -192.2)
		event.set_object_sequence_rotation(0, 0.0, -2.74, 0.0)
		event.set_camera_sequence_position(72.53, 32.73, -113.44)
		event.set_camera_sequence_look_at(-214.71, 27.16, -908.69)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-121.55, 32.73, -43.34, -408.79, 27.16, -838.6)
		event.add_camera_sequence_path_point(72.53, 32.73, -113.44, -214.71, 27.16, -908.69)
		event.start_camera_sequence_path()
		at = 49
		wait_camera()
		event.set_camera_sequence_position(-104.37, 19.87, -248.05)
		event.set_camera_sequence_look_at(-79.52, 22.03, -232.43)
		at = 50
		wait_frames(90)
		event.set_camera_sequence_position(-34.84, 37.38, -59.03)
		event.set_camera_sequence_look_at(-95.77, 20.25, -225.62)
		at = 51
		wait_frames(90)
		event.set_camera_sequence_position(-348.67, -50.57, -550.42)
		event.set_camera_sequence_look_at(-351.04, 5.47, -770.66)
		at = 52
		wait_frames(90)
		event.set_camera_sequence_position(-318.01, 1.52, -739.61)
		event.set_camera_sequence_look_at(-349.36, 5.47, -775.54)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-339.91, 1.52, -720.51, -371.26, 5.47, -756.44)
		event.add_camera_sequence_path_point(-329.37, 1.52, -729.7, -360.72, 5.47, -765.63)
		event.start_camera_sequence_path()
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		at = 53
		wait_frames(60)
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "わらい顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		at = 54
		wait_camera()
		event.set_camera_sequence_position(-104.37, 19.87, -248.05)
		event.set_camera_sequence_look_at(-79.52, 22.03, -232.43)
		event.start_crossfade(30)
		at = 55
		wait_frames(90)
		event.set_camera_sequence_position(-207.34, 54.9, -452.6)
		event.set_camera_sequence_look_at(-71.26, 17.87, -226.97)
		event.set_object_sequence_position(1, -47.62, 0.0, -137.28)
		event.set_object_sequence_rotation(1, 0.0, -2.74, 0.0)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -70.49, 0.0, -204.72, 40)
		at = 56
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		at = 57
		wait_frames(30)
		event.set_object_sequence_motion(1, "飛び", 2)
		event.move_object_sequence(1, -87.32, 0.0, -244.51, 20)
		at = 58
		wait_frames(20)
		event.play_sound_effect(var4, 19)
		at = 59
		wait_frames(10)
		event.set_camera_sequence_position(-295.37, -86.21, -553.05)
		event.set_camera_sequence_look_at(-123.25, 61.72, -340.9)
		at = 60
		wait_frames(50)
		event.set_camera_sequence_position(-62.09, 9.68, -219.85)
		event.set_camera_sequence_look_at(14.42, 33.43, -191.5)
		event.play_sound_effect(var4, 20)
		event.set_object_sequence_motion(0, "モニカぁあ～", 6)
		event.queue_object_sequence_next_motion(0, "モニカぁあ～L", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 61
		helper_1584c528(3520280, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_position(1, -138.57, 9.72, -786.98)
		event.set_object_sequence_motion(1, "飛び2秒", 4)
		event.set_camera_sequence_position(-389.59, 107.61, -250.29)
		event.set_camera_sequence_look_at(-69.28, 33.43, -379.52)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(60)
		event.add_camera_sequence_path_point(-142.97, 98.14, -135.2, -116.47, 68.27, -429.76)
		event.add_camera_sequence_path_point(-218.4, 98.14, -142.95, -218.24, 68.27, -438.91)
		event.start_camera_sequence_path()
		event.jump_object_sequence(1, -297.28, -20.16, -768.4, -0.15, 60)
		at = 62
		wait_camera()
		event.stop_sound_effect(var4, 18)
		event.set_object_handle_footstep_sound(1, 0)
		event.set_camera_sequence_position(-153.85, 1.75, -965.32)
		event.set_camera_sequence_look_at(-213.98, -16.72, -854.17)
		event.fade_out_music(90)
		event.set_object_sequence_position(1, -213.98, -29.77, -854.17)
		event.play_sound_effect(var4, 21)
		event.set_object_sequence_motion(1, "着地2", 6)
		event.queue_object_sequence_next_motion(1, "着地2Ｌ", 4)
		at = 63
		wait_frames(90)
		event.stop_music(0)
		event.set_object_sequence_motion(1, "にらみ～ギルトーニＬ", 4)
		event.set_object_sequence_rotation(1, 0.0, -0.89, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 2.16, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 2.16, 0.0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-382.3, 9.54, -680.59, -184.92, -16.72, -809.77)
		event.add_camera_sequence_path_point(-413.29, 9.54, -727.92, -215.9, -16.72, -857.11)
		event.start_camera_sequence_path()
		at = 64
		wait_camera()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(360)
		event.add_camera_sequence_path_point(-296.02, -4.19, -748.32, -394.55, 1.71, -679.52)
		event.add_camera_sequence_path_point(-318.45, -4.19, -780.45, -416.98, 1.71, -711.64)
		event.start_camera_sequence_path()
		at = 65
		wait_frames(120)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 66
		helper_1584c528(3520290, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 67
		helper_1584c528(3520295, -1)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 22)
		event.set_object_sequence_motion(7, "立ちからはっ", 6)
		event.queue_object_sequence_next_motion(7, "立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 68
		helper_1584c528(3520300, -1)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 16)
		event.set_character_position(16, -382.55, -29.77, -760.19)
		event.set_character_motion(16, "ワープ", 2, -1, 1)
		event.play_sound_effect(var4, 23)
		event.set_character_visible(20, 0, 1, 0.025)
		at = 69
		wait_frames(30)
		event.set_character_active(0, 20)
		at = 70
		wait_camera()
		at = 71
		wait_frames(30)
		event.delete_character(20)
		event.set_camera_sequence_position(-236.39, -1.57, -810.07)
		event.set_camera_sequence_look_at(-210.96, -15.51, -863.92)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 72
		helper_1584c528(3520310, -1)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-193.72, -11.82, -832.4, -220.35, -5.56, -862.48)
		event.add_camera_sequence_path_point(-209.1, -11.82, -818.79, -235.72, -5.56, -848.88)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 73
		helper_1584c528(3520320, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 74
		helper_1584c528(3520325, -1)
		event.reset_mouth_texture_animations()
		at = 75
		wait_camera()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-298.65, -11.82, -739.54, -325.27, -5.56, -769.63)
		event.add_camera_sequence_path_point(-321.64, -11.82, -719.2, -348.27, -5.56, -749.28)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 76
		helper_1584c528(3520330, -1)
		event.reset_mouth_texture_animations()
		at = 77
		wait_camera()
		at = 78
		wait_frames(30)
		event.set_camera_sequence_position(-311.57, -2.68, -773.5)
		event.set_camera_sequence_look_at(-346.28, 0.67, -749.62)
		event.play_sound_effect(var4, 24)
		event.set_object_sequence_motion(6, "これはこれは", 6)
		event.queue_object_sequence_next_motion(6, "立ち", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 79
		helper_4116e6bb(3520340)
		event.reset_mouth_texture_animations()
		at = 80
		wait_objects(6)
		event.set_event_projection(2000.0)
		event.set_camera_sequence_path_frames(200)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-389.89, 2.83, -660.42, -273.14, -7.07, -813.46)
		event.add_camera_sequence_path_point(-436.6, 2.83, -711.42, -273.14, -7.07, -813.46)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 81
		helper_1584c528(3520350, -1)
		event.reset_mouth_texture_animations()
		at = 82
		wait_frames(30)
		event.play_sound_effect(var4, 25)
		event.set_object_sequence_motion(1, "許さない！", 6)
		event.queue_object_sequence_next_motion(1, "にらみ～ギルトーニＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 83
		helper_1584c528(3520355, -1)
		event.reset_mouth_texture_animations()
		at = 84
		wait_camera()
		event.set_camera_sequence_position(-316.92, -38.16, -871.1)
		event.set_camera_sequence_look_at(-346.81, 0.41, -749.55)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 85
		helper_4116e6bb(3520360)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 86
		helper_4116e6bb(3520365)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-52.38, 14.17, -934.99)
		event.set_camera_sequence_look_at(-338.56, -9.4, -775.64)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 87
		helper_4116e6bb(3520370)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 88
		helper_4116e6bb(3520380)
		event.reset_mouth_texture_animations()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 0 then
			event.set_character_active(1, 17)
			event.set_character_active(1, 18)
		else
			event.attach_object_handle_to_character(2, 1)
			event.set_object_handle_visible(2, 1)
			event.attach_object_handle_to_character(3, 2)
			event.set_object_handle_visible(3, 1)
		end
		event.play_music(0)
		event.set_camera_sequence_position(-315.54, 2.28, -794.45)
		event.set_camera_sequence_look_at(-206.14, -9.4, -856.87)
		event.play_sound_effect(var4, 26)
		event.set_object_sequence_motion(1, "構え", 6)
		event.queue_object_sequence_next_motion(1, "構えＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 89
		helper_4116e6bb(3520390)
		event.reset_mouth_texture_animations()
		at = 90
		wait_frames(30)
		event.fade_out_screen(30)
		at = 91
		wait_frames(30)
		event.delete_character(11)
		event.delete_character(19)
		event.delete_character(20)
		event.delete_character(15)
		event.delete_character(16)
		event.clear_memory_stack(6)
		event.set_event_projection(projection)
		event.load_character(6, "event/e300/e352/e352_fireball.gltf", "info", 21)
		event.attach_object_handle_to_character(12, 21)
		event.clear_object_sequence(12, 21)
		event.set_object_sequence_object(12, 12)
		event.set_character_active(0, 21)
		event.copy_character(6, 21, 22)
		event.attach_object_handle_to_character(13, 22)
		event.clear_object_sequence(13, 22)
		event.set_object_sequence_object(13, 13)
		event.set_character_active(0, 22)
		event.copy_character(6, 21, 23)
		event.attach_object_handle_to_character(14, 23)
		event.clear_object_sequence(14, 23)
		event.set_object_sequence_object(14, 14)
		event.set_character_active(0, 23)
		event.copy_character(6, 21, 13)
		event.attach_object_handle_to_character(15, 13)
		event.clear_object_sequence(15, 13)
		event.set_object_sequence_object(15, 15)
		event.set_character_active(0, 13)
		event.copy_character(6, 21, 14)
		event.attach_object_handle_to_character(16, 14)
		event.clear_object_sequence(16, 14)
		event.set_object_sequence_object(16, 16)
		event.set_character_active(0, 14)
		event.set_object_sequence_position(12, 179.32, 0.0, 162.8)
		event.set_object_sequence_rotation(12, 0.0, -2.4, 0.0)
		event.set_object_sequence_position(13, 82.96, 0.0, 206.67)
		event.set_object_sequence_rotation(13, 0.0, -2.88, 0.0)
		event.set_object_sequence_position(14, -190.58, 0.0, -150.66)
		event.set_object_sequence_rotation(14, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(15, -120.47, 0.0, -224.18)
		event.set_object_sequence_rotation(15, 0.0, 0.24, 0.0)
		event.set_object_sequence_position(16, -87.9, 0.0, -228.03)
		event.set_object_sequence_rotation(16, 0.0, 0.6, 0.0)
		event.set_object_sequence_position(4, -73.68, 0.0, -125.3)
		event.set_object_sequence_rotation(4, 0.0, -2.74, 0.0)
		event.set_object_sequence_position(0, -56.83, 0.0, -155.67)
		event.set_object_sequence_rotation(0, 0.0, -2.74, 0.0)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 6)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 6)
		event.set_object_sequence_motion(4, "おびえ立ち", 4)
		event.set_object_handle_frame_visible(4, "houki", 1)
		event.play_sound_effect(var4, 27)
		event.set_camera_sequence_position(-238.5, 71.05, -462.7)
		event.set_camera_sequence_look_at(-30.96, 27.68, -54.57)
		event.fade_in_screen(30)
		at = 92
		wait_frames(90)
		event.set_camera_sequence_position(-90.18, 13.15, -222.54)
		event.set_camera_sequence_look_at(-38.29, 20.0, -70.1)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 93
		helper_4116e6bb(3520400)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 94
		helper_4116e6bb(3520410)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 95
		helper_4116e6bb(3520420)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 21)
		event.set_camera_sequence_position(289.65, 77.87, 17.75)
		event.set_camera_sequence_look_at(137.1, 27.68, 277.81)
		event.play_sound_effect(var4, 28)
		event.set_object_sequence_motion(12, "飛び込み登場", 6)
		event.queue_object_sequence_next_motion(12, "立ち", 4)
		at = 96
		wait_frames(20)
		event.play_sound_effect(var4, 32)
		at = 97
		wait_objects(12)
		event.set_character_active(1, 22)
		event.play_sound_effect(var4, 28)
		event.set_object_sequence_motion(13, "飛び込み登場", 6)
		event.queue_object_sequence_next_motion(13, "立ち", 4)
		at = 98
		wait_frames(20)
		event.play_sound_effect(var4, 32)
		at = 99
		wait_objects(13)
		at = 100
		wait_frames(30)
		event.set_character_active(1, 23)
		event.set_character_active(1, 13)
		event.set_camera_sequence_position(38.51, 77.87, -229.29)
		event.set_camera_sequence_look_at(-255.97, 27.68, -248.1)
		event.set_object_sequence_motion(14, "立ち", 4)
		event.play_sound_effect(var4, 28)
		event.set_object_sequence_motion(15, "飛び込み登場", 6)
		event.queue_object_sequence_next_motion(15, "立ち", 4)
		at = 101
		wait_frames(20)
		event.play_sound_effect(var4, 32)
		at = 102
		wait_objects(15)
		event.set_character_active(1, 14)
		event.play_sound_effect(var4, 28)
		event.set_object_sequence_motion(16, "飛び込み登場", 6)
		event.queue_object_sequence_next_motion(16, "立ち", 4)
		at = 103
		wait_frames(20)
		event.play_sound_effect(var4, 32)
		at = 104
		wait_objects(16)
		at = 105
		wait_frames(30)
		if active_chr_no == 1 then
			event.set_character_active(1, 17)
			event.set_character_active(1, 18)
		else
			event.attach_object_handle_to_character(2, 1)
			event.set_object_handle_visible(2, 1)
			event.attach_object_handle_to_character(3, 2)
			event.set_object_handle_visible(3, 1)
		end
		event.set_camera_sequence_position(-59.58, 20.53, -228.9)
		event.set_camera_sequence_look_at(-62.47, 27.68, -105.07)
		event.play_sound_effect(var4, 29)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		at = 106
		wait_frames(30)
		event.fade_out_screen(30)
		at = 107
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22b00000()
			helper_344d6cd8()
		end
		if at <= 2 then
			wait_frames_skipping(30)
		end
		if at <= 3 then
			wait_frames_skipping(60)
		end
		if at <= 4 then
			helper_52aadc70(3520190, -1)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			helper_52aadc70(3520200, 60)
		end
		if at <= 7 then
			wait_frames_skipping(60)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			wait_frames_skipping(60)
		end
		if at <= 10 then
			wait_frames_skipping(45)
		end
		if at <= 11 then
			wait_frames_skipping(45)
		end
		if at <= 12 then
			wait_frames_skipping(45)
		end
		if at <= 13 then
			helper_8cd371d7(3520203)
		end
		if at <= 14 then
			wait_frames_skipping(30)
		end
		if at <= 15 then
			wait_frames_skipping(30)
		end
		if at <= 16 then
			helper_52aadc70(3520205, -1)
		end
		if at <= 17 then
			wait_frames_skipping(15)
		end
		if at <= 18 then
			wait_frames_skipping(30)
		end
		if at <= 23 then
			helper_8cd371d7(3520210)
		end
		if at <= 24 then
			helper_8cd371d7(3520220)
		end
		if at <= 25 then
			wait_frames_skipping(30)
		end
		if at <= 26 then
			helper_8cd371d7(3520230)
		end
		if at <= 27 then
			wait_frames_skipping(90)
		end
		if at <= 28 then
			wait_frames_skipping(60)
		end
		if at <= 29 then
			helper_8cd371d7(3520240)
		end
		if at <= 30 then
			wait_frames_skipping(60)
		end
		if at <= 31 then
			helper_8cd371d7(3520250)
		end
		if at <= 32 then
			helper_344d6cd8()
		end
		if at <= 33 then
			wait_frames_skipping(30)
		end
		if at <= 34 then
			helper_8cd371d7(3520260)
		end
		if at <= 35 then
			wait_frames_skipping(20)
		end
		if at <= 36 then
			wait_frames_skipping(15)
		end
		if at <= 37 then
			helper_344d6cd8()
		end
		if at <= 38 then
			wait_frames_skipping(25)
		end
		if at <= 39 then
			helper_238b5abc(5)
		end
		if at <= 40 then
			helper_238b5abc(5)
		end
		if at <= 41 then
			wait_frames_skipping(30)
		end
		if at <= 42 then
			helper_238b5abc(5)
		end
		if at <= 43 then
			helper_238b5abc(5)
		end
		if at <= 44 then
			wait_frames_skipping(50)
		end
		if at <= 45 then
			helper_344d6cd8()
		end
		if at <= 46 then
			wait_frames_skipping(60)
		end
		if at <= 47 then
			wait_frames_skipping(150)
		end
		if at <= 48 then
			helper_344d6cd8()
		end
		if at <= 49 then
			wait_frames_skipping(90)
		end
		if at <= 50 then
			wait_frames_skipping(90)
		end
		if at <= 51 then
			wait_frames_skipping(90)
		end
		if at <= 52 then
			wait_frames_skipping(60)
		end
		if at <= 53 then
			helper_344d6cd8()
		end
		if at <= 54 then
			wait_frames_skipping(90)
		end
		if at <= 55 then
			helper_238b5abc(1)
		end
		if at <= 56 then
			wait_frames_skipping(30)
		end
		if at <= 57 then
			wait_frames_skipping(20)
		end
		if at <= 58 then
			wait_frames_skipping(10)
		end
		if at <= 59 then
			wait_frames_skipping(50)
		end
		if at <= 60 then
			helper_52aadc70(3520280, -1)
		end
		if at <= 61 then
			helper_344d6cd8()
		end
		if at <= 62 then
			wait_frames_skipping(90)
		end
		if at <= 63 then
			helper_344d6cd8()
		end
		if at <= 64 then
			wait_frames_skipping(120)
		end
		if at <= 65 then
			helper_52aadc70(3520290, -1)
		end
		if at <= 66 then
			helper_52aadc70(3520295, -1)
		end
		if at <= 67 then
			helper_52aadc70(3520300, -1)
		end
		if at <= 68 then
			wait_frames_skipping(30)
		end
		if at <= 69 then
			helper_344d6cd8()
		end
		if at <= 70 then
			wait_frames_skipping(30)
		end
		if at <= 71 then
			helper_52aadc70(3520310, -1)
		end
		if at <= 72 then
			helper_52aadc70(3520320, -1)
		end
		if at <= 73 then
			helper_52aadc70(3520325, -1)
		end
		if at <= 74 then
			helper_344d6cd8()
		end
		if at <= 75 then
			helper_52aadc70(3520330, -1)
		end
		if at <= 76 then
			helper_344d6cd8()
		end
		if at <= 77 then
			wait_frames_skipping(30)
		end
		if at <= 78 then
			helper_8cd371d7(3520340)
		end
		if at <= 79 then
			helper_238b5abc(6)
		end
		if at <= 80 then
			helper_52aadc70(3520350, -1)
		end
		if at <= 81 then
			wait_frames_skipping(30)
		end
		if at <= 82 then
			helper_52aadc70(3520355, -1)
		end
		if at <= 83 then
			helper_344d6cd8()
		end
		if at <= 84 then
			helper_8cd371d7(3520360)
		end
		if at <= 85 then
			helper_8cd371d7(3520365)
		end
		if at <= 86 then
			helper_8cd371d7(3520370)
		end
		if at <= 87 then
			helper_8cd371d7(3520380)
		end
		if at <= 88 then
			helper_8cd371d7(3520390)
		end
		if at <= 89 then
			wait_frames_skipping(30)
		end
		if at <= 90 then
			wait_frames_skipping(30)
		end
		if at <= 91 then
			wait_frames_skipping(90)
		end
		if at <= 92 then
			helper_8cd371d7(3520400)
		end
		if at <= 93 then
			helper_8cd371d7(3520410)
		end
		if at <= 94 then
			helper_8cd371d7(3520420)
		end
		if at <= 95 then
			wait_frames_skipping(20)
		end
		if at <= 96 then
			helper_238b5abc(12)
		end
		if at <= 97 then
			wait_frames_skipping(20)
		end
		if at <= 98 then
			helper_238b5abc(13)
		end
		if at <= 99 then
			wait_frames_skipping(30)
		end
		if at <= 100 then
			wait_frames_skipping(20)
		end
		if at <= 101 then
			helper_238b5abc(15)
		end
		if at <= 102 then
			wait_frames_skipping(20)
		end
		if at <= 103 then
			helper_238b5abc(16)
		end
		if at <= 104 then
			wait_frames_skipping(30)
		end
		if at <= 105 then
			wait_frames_skipping(30)
		end
		if at <= 106 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 108
	vm.entry(108)
	event.cancel_drama_scene_skip()
	event.set_object_sequence_position(10, 0.0, 0.0, 0.0)
	event.set_event_projection(projection)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	at = 109
	vm.wait(109)
	at = 110
	helper_190b8()
end

--- Helper function.
local function helper_25978()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global12 = 0
		global13 = 8
		event.load_character(5, "chara/c02_base.gltf", "info", global13)
		event.load_equipment_model(5, 1, 1, "info", global13, 17)
		event.load_equipment_model(5, 1, 0, "info", global13, 18)
		event.load_equipment_model(5, 1, 4, "info", global13)
		event.load_equipment_model(5, 1, 3, "info", global13)
		event.load_equipment_model(5, 1, 2, "info", global13, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global13)
		event.load_character_motion_pack(5, "event/e300/e352/vs_e352_monica.gltf", "info", global13)
		event.attach_object_handle_to_character(1, global13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(1, global13)
		event.set_character_active(1, 12)
		event.set_character_active(1, 17)
		event.set_character_active(1, 18)
	end
	if active_chr_no == 1 then
		global12 = 8
		global13 = 0
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global13)
		event.load_character_motion_pack(5, "event/e300/e352/vs_e352_monica.gltf", "info", global13)
		event.attach_object_handle_to_character(1, global13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global13)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 1)
	end
	event.load_character(5, "event/e300/e352/e352_guiltoni.gltf", "info", 19)
	event.load_character_motion_pack(5, "event/e300/e352/vs_e352_guiltoni.gltf", "info", 19)
	event.set_character_active(0, 19)
	event.attach_object_handle_to_character(6, 19)
	event.clear_object_sequence(6, 19)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/lm/mo_vs_gil2/vs2_cam.gltf", "info", 15)
	event.attach_object_handle_to_map_part_2(8, "p01_battleship")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(10, "p01_d03b01", "d03b01_12-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p02_d03b01", "d03b01_3-m0")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(18, "p02_d03b01", "d03b01_15-m0")
	event.clear_object_sequence(17)
	event.set_object_sequence_object(17, 18)
	block = event.load_event_image_4(5, "textures/dungeon/image/beffect_00.json", 0) or block
	event.create_character_sword_effect(18, 0, 5, 16, 8)
	event.set_character_sword_effect_texture(18, 0, block, "sweff", 0, 0, 64, 32)
	event.create_character_sword_effect(18, 1, 5, 16, 8)
	event.set_character_sword_effect_texture(18, 1, block, "sweff", 0, 0, 64, 32)
	event.create_character_sword_effect(19, 0, 5, 16, 8)
	event.set_character_sword_effect_texture(19, 0, block, "sweff", 64, 0, 64, 32)
	event.create_character_sword_effect(19, 1, 5, 16, 8)
	event.set_character_sword_effect_texture(19, 1, block, "sweff", 64, 0, 64, 32)
	block = event.load_event_image_4(5, "textures/event/e300/e352/e352telop01_1.json", 1) or block
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "e352telop01", block)
	event.set_event_sprite_texture_rect(4, 0, 0, 512, 128)
	event.set_event_sprite_size(4, 512, 128)
	event.set_event_sprite_position(4, 320, 334)
	event.set_event_sprite_color(4, 128, 128, 128, 0)
	event.set_event_sprite_scale(4, 1.0, 1.0)
	event.set_event_sprite_draw_pass(4, 0)
	event.attach_object_handle_to_sprite(14, 4)
	event.clear_object_sequence(14)
	event.set_object_sequence_object(14, 14)
end

--- Helper function.
local function helper_22e00000()
	global12 = 0
	global13 = 8
	global12 = 8
	global13 = 0
end

--- Helper function.
local function helper_253f0()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(0, global13)
		event.delete_character_extension_packs(global13)
		event.delete_character(global13)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global13)
		event.set_character_active(0, global12)
		event.delete_character_extension_packs(global13)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(19)
	event.delete_event_image(0)
	event.delete_event_image(1)
	event.delete_character(15)
	event.set_function_point_enabled("", "func", 1)
	event.set_function_point_enabled("", "func4", 1)
	event.set_object_handle_visible(18, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.show_dungeon_status_bar(1, 1.0)
	vm.wait(1)
	event.finish_event()
end

--- Helper function.
local function helper_26f10()
	local var4: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var12: s32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var4 = event.load_sound_effect_file_2(3839) or var4
		helper_25978()
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(18.0)
		event.set_time_of_day_advancing(0)
		event.enable_drama_skip()
		event.set_object_sequence_position(8, -2195.0, 488.0, -475.0)
		event.set_character_active(0, 19)
		event.set_function_point_enabled("", "func", 0)
		event.set_function_point_enabled("", "func4", 0)
		event.set_object_sequence_rotation(11, 0.0, 1.57, 0.0)
		event.set_object_sequence_rotation(17, 0.0, 1.57, 0.0)
		event.set_object_handle_visible(8, 1)
		event.set_object_handle_visible(9, 0)
		event.set_object_handle_visible(18, 0)
		event.set_character_position(global13, -2195.0, 488.0, -475.0)
		event.set_character_rotation(global13, 0.0, 1.94, 0.0)
		event.set_character_position(19, -2195.0, 488.0, -475.0)
		event.set_character_rotation(19, 0.0, 2.9, 0.0)
		event.set_character_motion(global13, "ふりむき", 2, -1, 1)
		event.set_character_motion(19, "戦い", 1, -1, 1)
		event.set_character_active(1, 15)
		event.set_character_position(15, -2195.0, 488.0, -475.0)
		event.set_character_rotation(15, 0.0, 2.9, 0.0)
		event.set_character_motion(15, "1カメ", 5)
		event.set_character_active(1, global13)
		event.fade_in_screen(30)
		event.play_sound_effect(var4, 30)
		event.set_camera_position(-2170.97, 511.0, -483.67)
		event.set_camera_look_at(-2195.0, 511.0, -475.0)
		at = 2
		wait_frames(50)
		event.start_character_sword_effect(18, 0, "dcol00", "dcol01", 94, 10, 16)
		at = 3
		wait_frames(12)
		event.move_camera_sequence_eased(-2142.85, 509.61, -493.81, -2195.0, 503.11, -475.0, 10, 1, 0.6)
		at = 4
		wait_camera()
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "怒り目")
		event.set_object_handle_texture_animation(1, 1, "怒り口")
		event.set_character_rotation(global13, 0.0, 2.9, 0.0)
		event.set_character_active(1, 19)
		event.set_object_handle_frame_draw_flag(6, "sword", 1)
		event.set_character_motion(global13, "戦い", 6)
		event.set_character_motion(19, "戦い", 6)
		event.set_character_motion(15, "1カメ", 6)
		event.attach_object_handle_to_character(17, 15)
		var12 = 0
		do
			local out1, out2, out3 = event.copy_vector(-2172.93, 510.33, -526.41)
			var13 = out1 or var13
			var14 = out2 or var14
			var15 = out3 or var15
		end
		do
			local out1, out2, out3 = event.copy_vector(-2168.55, 512.98, -523.85)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = event.subtract_vectors(var16, var17, var18, -2172.93, 510.33, -526.41)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = event.scale_vector(var16, var17, var18, 0.03)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		while var12 < 123 do
			if var12 == 10 then
				event.start_character_sword_effect(18, 0, "dcol00", "dcol01", 94, 6, 6)
			end
			if var12 == 26 then
				event.start_character_sword_effect(18, 1, "dcol00", "dcol01", 94, 10, 10)
			end
			if var12 == 46 then
				event.start_character_sword_effect(18, 0, "dcol00", "dcol01", 94, 10, 10)
			end
			if var12 == 46 then
				event.start_character_sword_effect(19, 0, "ken00", "ken01", 94, 4, 8)
			end
			if var12 == 49 then
				event.spawn_hit_effect(0, var13, var14, var15)
			end
			if var12 > 50 and var12 <= 90 then
				do
					local out1, out2, out3 = event.add_vectors(var13, var14, var15, var16, var17, var18)
					var13 = out1 or var13
					var14 = out2 or var14
					var15 = out3 or var15
				end
				if var12 >= 68 and var12 <= 90 and vm.imod(var12, 3) == 0 then
					event.spawn_hit_effect(1, var13, var14, var15)
				end
			end
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(17, "int1")
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(17, "cam1")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			event.set_camera_position(pos_x, pos_y, pos_z)
			event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
			var12 = var12 + 1
			at = 5
			vm.wait(5)
		end
		event.set_object_sequence_motion_time(1, 53.1)
		event.set_object_sequence_motion_time(6, 53.1)
		event.set_character_motion(15, "2カメ", 6)
		var12 = 0
		while var12 < 85 do
			if var12 == 26 then
				event.start_character_sword_effect(19, 0, "ken00", "ken01", 94, 4, 8)
			end
			if var12 == 38 then
				event.start_character_sword_effect(19, 1, "ken00", "ken01", 94, 10, 10)
			end
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(17, "int2")
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(17, "cam2")
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			event.set_camera_position(pos_x, pos_y, pos_z)
			event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
			var12 = var12 + 1
			at = 6
			vm.wait(6)
		end
		event.play_sound_effect(var4, 31)
		event.set_character_motion(19, "着地", 6)
		event.set_camera_position(-2216.51, 515.07, -318.73)
		event.set_camera_look_at(-2223.46, 515.07, -269.18)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(45)
		event.add_camera_sequence_path_point(-2216.51, 497.31, -318.73, -2223.46, 497.3, -269.18)
		event.add_camera_sequence_path_point(-2216.51, 515.07, -318.73, -2223.46, 515.07, -269.18)
		event.start_camera_sequence_path()
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(14, 128, 128, 128, 128, 30)
		at = 7
		wait_frames(90)
		event.set_object_sequence_color(14, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		at = 8
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22e00000()
			wait_frames_skipping(50)
		end
		if at <= 2 then
			wait_frames_skipping(12)
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			var12 = 0
			local _ = var12 < 123
			local _ = var12 == 10
			local _ = var12 == 26
			local _ = var12 == 46
			local _ = var12 == 46
			local _ = var12 == 49
			local _ = var12 > 50
			local _ = var12 <= 90
			local _ = var12 >= 68
			local _ = var12 <= 90
			local _ = vm.imod(var12, 3) == 0
			var12 = var12 + 1
		end
		if at <= 5 then
			var12 = 0
			local _ = var12 < 85
			local _ = var12 == 26
			local _ = var12 == 38
			var12 = var12 + 1
		end
		if at <= 6 then
			wait_frames_skipping(90)
		end
		if at <= 7 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 9
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_object_sequence_position(10, 0.0, 0.0, 0.0)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	at = 10
	vm.wait(10)
	at = 11
	helper_253f0()
end

--- Helper function.
local function helper_29bb4()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global14 = 0
		global15 = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global14)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", global14)
		event.attach_object_handle_to_character(0, global14)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global14)
		event.load_character(5, "chara/c02_base.gltf", "info", global15)
		event.load_equipment_model(5, 1, 1, "info", global15, 41)
		event.load_equipment_model(5, 1, 0, "info", global15, 42)
		event.load_equipment_model(5, 1, 4, "info", global15)
		event.load_equipment_model(5, 1, 3, "info", global15)
		event.load_equipment_model(5, 1, 2, "info", global15, 36)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global15)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", global15)
		event.attach_object_handle_to_character(1, global15)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global15)
		event.set_character_active(1, 36)
		event.set_character_active(0, 41)
		event.set_character_active(0, 42)
	end
	if active_chr_no == 1 then
		global14 = 32
		global15 = 0
		event.load_equipment_model(5, 1, 1, "info", global15, 41)
		event.load_equipment_model(5, 1, 0, "info", global15, 42)
		event.load_character(5, "chara/c01_base.gltf", "info", global14)
		event.load_equipment_model(5, 0, 4, "info", global14)
		event.load_equipment_model(5, 0, 3, "info", global14)
		event.load_equipment_model(5, 0, 2, "info", global14, 36)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global14)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", global14)
		event.attach_object_handle_to_character(0, global14)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global14)
		event.set_character_active(1, 36)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global15)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", global15)
		event.attach_object_handle_to_character(1, global15)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global15)
	end
	event.load_character(5, "event/e300/e356/e356_crest.gltf", "info", 34)
	event.set_character_active(0, 34)
	event.attach_object_handle_to_character(5, 34)
	event.clear_object_sequence(5, 34)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "event/e300/e356/e356_guiltoni.gltf", "info", 37)
	event.set_character_active(0, 37)
	event.attach_object_handle_to_character(6, 37)
	event.clear_object_sequence(6, 37)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e300/e356/e356_jamming.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(7, 38)
	event.clear_object_sequence(7, 38)
	event.set_object_sequence_object(7, 7)
	event.attach_object_handle_to_map_part_2(8, "p01_battleship")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_3(10, "p01_d03b01", "d03b01_12-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p02_d03b01", "d03b01_3-m0")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(12, "p02_d03b01", "d03b01_15-m0")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_3(14, "p01_battleship", "t01-m0")
	event.load_character(5, "event/e300/e352/e352_houdai.gltf", "info", 33)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_character(13, 33)
	event.clear_object_sequence(17, 33)
	event.set_object_sequence_object(17, 13)
	event.load_character(5, "event/e300/e352/e352_gun_f.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.load_character(5, "event/e300/e352/e352_gun_l.gltf", "info", 43)
	event.set_character_active(0, 43)
	event.attach_object_handle_to_character(16, 43)
	event.clear_object_sequence(19, 43)
	event.set_object_sequence_object(19, 16)
	event.load_character(5, "event/e300/e352/e352_gun_h.gltf", "info", 44)
	event.set_character_active(0, 44)
	event.load_character(5, "event/e300/e356/e356_crystal_f.gltf", "info", 45)
	event.set_character_active(0, 45)
	event.load_character(5, "event/e300/e356/e356_crystal_l.gltf", "info", 46)
	event.set_character_active(0, 46)
	event.attach_object_handle_to_character(15, 46)
	event.clear_object_sequence(18, 46)
	event.set_object_sequence_object(18, 15)
	event.load_character(5, "event/e300/e356/e356_crystal_h.gltf", "info", 47)
	event.set_character_active(0, 47)
	event.load_character(5, "event/e300/e356/e356_baria.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.load_character(5, "event/e300/e356/e356_tbaku.gltf", "info", 48)
	event.set_character_active(0, 48)
	event.load_character(5, "event/e300/e352/e352_warp.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.set_character_scale(39, 1.1, 1.1, 1.1)
	event.load_message_file(0, 5, "event/e300/e356/e356_1.txt")
end

--- Helper function.
local function helper_23000000()
	global14 = 0
	global15 = 32
	global14 = 32
	global15 = 0
end

--- Helper function.
local function helper_294a0()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global14)
		event.set_character_active(0, global15)
		event.delete_character_extension_packs(global14)
		event.delete_character_extension_packs(global15)
		event.delete_character(global15)
		event.delete_character(36)
		event.delete_character(41)
		event.delete_character(42)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global15)
		event.set_character_active(0, global14)
		event.delete_character_extension_packs(global14)
		event.delete_character_extension_packs(global15)
		event.delete_character(global14)
		event.delete_character(36)
		event.delete_character(41)
		event.delete_character(42)
	end
	event.delete_character(34)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_character(33)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(43)
	event.delete_character(44)
	event.delete_character(45)
	event.delete_character(46)
	event.delete_character(47)
	event.delete_character(35)
	event.delete_character(48)
	event.set_function_point_enabled("", "func", 1)
	event.set_function_point_enabled("", "func4", 1)
	event.set_object_handle_visible(12, 1)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_visible(14, 1)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Helper function.
local function helper_2b9e4()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(356, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		at = 3
		vm.wait(3)
		at = 4
		vm.wait(4)
		event.load_map_sounds(3841)
		var4 = event.load_sound_effect_file_2(3841) or var4
		event.fade_out_screen(30)
		at = 5
		wait_frames(35)
		helper_29bb4()
		event.set_scene_status_flags(1, 0, 256, 1)
		at = 6
		vm.wait(6)
		projection = event.get_event_projection() or projection
		time = event.get_scene_time_of_day() or time
		event.enable_drama_skip()
		event.set_time_of_day(21.0)
		event.set_time_of_day_advancing(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "無表情")
		event.set_object_sequence_texture_animation(5, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "くるし顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(7, 0)
		event.set_object_sequence_texture_animation(7, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(7, 1, "目パチ")
		event.set_function_point_enabled("", "func2", 1)
		event.set_function_point_enabled("", "func3", 1)
		event.set_function_point_enabled("", "func0", 0)
		event.set_function_point_enabled("", "func", 0)
		event.set_function_point_enabled("", "func4", 0)
		event.set_object_sequence_rotation(11, 0.0, 1.57, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 1.57, 0.0)
		event.set_object_handle_visible(8, 1)
		event.set_object_handle_visible(9, 1)
		event.play_sound_effect(var4, 4)
		event.set_camera_sequence_position(-3228.79, 35.27, 1184.49)
		event.set_camera_sequence_look_at(-3120.21, 64.65, 1226.19)
		event.set_character_active(1, 36)
		event.set_character_active(0, global14)
		event.set_character_active(1, global15)
		event.set_character_active(0, 34)
		event.set_character_active(1, 37)
		event.set_character_active(0, 38)
		event.set_object_sequence_motion(5, "手ひろげ立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(6, "ひざまづきＬ", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_position(8, -3191.25, 25.75, 1213.17)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(7, -3213.34, 25.75, 1386.39)
		event.set_object_sequence_rotation(7, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(6, -3191.25, 25.75, 1213.17)
		event.set_object_sequence_rotation(6, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(1, -3193.71, 25.75, 1113.77)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_sequence_position(5, -171.87, 401.97, -73.85)
		event.set_object_sequence_rotation(5, 0.0, -0.96, 0.0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.2, 0.0)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 7
		helper_4116e6bb(3560010)
		event.reset_mouth_texture_animations()
		at = 8
		wait_frames(30)
		event.set_character_active(1, 41)
		event.set_character_active(1, 42)
		event.set_camera_sequence_position(-3217.06, 43.8, 1135.37)
		event.set_camera_sequence_look_at(-3161.01, 46.88, 1099.01)
		event.play_sound_effect(var4, 5)
		event.set_object_sequence_motion(1, "剣おろし", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 9
		helper_4116e6bb(3560020)
		event.reset_mouth_texture_animations()
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 120)
		event.add_object_sequence_path_point(1, -3193.71, 25.75, 1113.77)
		event.add_object_sequence_path_point(1, -3191.52, 25.75, 1171.04)
		event.start_object_sequence_path(1, 1)
		event.set_object_sequence_motion(1, "歩き")
		at = 10
		wait_frames(60)
		event.set_camera_sequence_position(-3252.89, 52.03, 1136.53)
		event.set_camera_sequence_look_at(-3191.9, 46.88, 1186.49)
		at = 11
		wait_objects(1)
		event.set_object_sequence_motion(1, "立ち")
		at = 12
		wait_frames(60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目下パチ")
		event.set_camera_sequence_position(-3235.05, 37.69, 1207.12)
		event.set_camera_sequence_look_at(-3196.19, 46.88, 1176.66)
		event.play_sound_effect(var4, 6)
		event.set_object_sequence_motion(1, "剣突きつけ", 6)
		event.queue_object_sequence_next_motion(1, "剣突きつけＬ", 4)
		at = 13
		wait_frames(60)
		event.play_sound_effect(var4, 6)
		event.set_object_sequence_motion(1, "剣突きつけ", 6)
		event.queue_object_sequence_next_motion(1, "剣突きつけＬ", 4)
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "わらい顔")
		event.set_object_sequence_texture_animation(6, 1, "目とじ")
		event.set_camera_sequence_position(-3214.05, 52.19, 1179.0)
		event.set_camera_sequence_look_at(-3184.91, 48.9, 1206.85)
		at = 14
		wait_frames(60)
		event.play_sound_effect(var4, 7)
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "わらい顔")
		event.set_object_sequence_texture_animation(6, 1, "目とじ～目あき")
		event.set_object_sequence_texture_animation(6, 1, "わらい口～口とじ")
		event.set_object_sequence_motion(6, "顔上げる", 6)
		event.queue_object_sequence_next_motion(6, "顔上げるＬ", 4)
		at = 15
		wait_frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-3240.43, 47.09, 1159.88, -3177.08, 48.9, 1166.47)
		event.add_camera_sequence_path_point(-3243.26, 47.09, 1187.11, -3179.91, 48.9, 1193.69)
		event.start_camera_sequence_path()
		at = 16
		wait_camera()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(90)
		event.add_camera_sequence_path_point(-3227.95, 37.5, 1215.78, -3178.62, 48.9, 1184.83)
		event.add_camera_sequence_path_point(-3234.28, 37.5, 1205.7, -3184.95, 48.9, 1174.74)
		event.start_camera_sequence_path()
		at = 17
		wait_camera()
		event.start_crossfade(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(90)
		event.add_camera_sequence_path_point(-3203.96, 45.24, 1194.92, -3154.63, 56.45, 1163.97)
		event.add_camera_sequence_path_point(-3207.72, 45.24, 1188.92, -3158.39, 56.45, 1157.97)
		event.start_camera_sequence_path()
		at = 18
		wait_camera()
		event.set_camera_sequence_position(-3909.29, 148.98, 1182.03)
		event.set_camera_sequence_look_at(-3563.8, -10.58, 1141.1)
		event.set_character_position(47, -3756.47, -58.75, 1194.56)
		event.set_character_rotation(47, 0.0, 0.0, 0.0)
		event.set_character_active(1, 47)
		event.set_character_motion(47, "ヒット", 2, -1, 1)
		event.play_sound_effect(var4, 8)
		event.delay_camera_sequence_shake_track(30)
		event.shake_camera_sequence(0.0, 0.3, 0.0, 120)
		at = 19
		wait_frames(60)
		event.set_character_active(0, 47)
		event.set_camera_sequence_position(-3218.05, 58.5, 1186.27)
		event.set_camera_sequence_look_at(-3110.83, 8.26, 1127.13)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～半口")
		event.play_sound_effect(var4, 9)
		event.set_object_sequence_motion(1, "え？", 6)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 20
		helper_1584c528(3560025, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		event.set_camera_sequence_position(-3229.37, 62.21, 1210.77)
		event.set_camera_sequence_look_at(-3103.54, 8.26, 1191.57)
		event.play_sound_effect(var4, 10)
		event.set_object_sequence_motion(6, "なんだ？", 6)
		event.queue_object_sequence_next_motion(6, "なんだ？Ｌ", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 21
		helper_1584c528(3560030, -1)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 11)
		event.set_object_sequence_motion(6, "バク転", 6)
		at = 22
		wait_frames(5)
		event.move_object_sequence(6, -3186.11, 25.75, 1357.13, 45)
		at = 23
		wait_frames(10)
		event.set_camera_sequence_position(-3322.33, 78.68, 1141.68)
		event.set_camera_sequence_look_at(-3203.67, 55.98, 1199.43)
		at = 24
		wait_frames(20)
		event.set_camera_sequence_position(-3184.57, 48.67, 1183.98)
		event.set_camera_sequence_look_at(-3185.6, 46.46, 1288.4)
		at = 25
		wait_objects(6)
		event.play_sound_effect(var4, 12)
		event.play_sound_effect(var4, 13)
		event.set_character_active(1, 39)
		event.set_character_position(39, -3213.34, 25.75, 1386.39)
		event.set_character_motion(39, "ワープ", 2, -1, 1)
		at = 26
		wait_frames(30)
		event.set_character_active(1, 38)
		event.set_character_visible(38, 1, 1, 0.025)
		event.set_object_sequence_motion(7, "立ちから話しポーズ", 6)
		event.queue_object_sequence_next_motion(7, "話し", 4)
		event.set_camera_sequence_position(-3197.25, 55.23, 1301.14)
		event.set_camera_sequence_look_at(-3198.28, 53.02, 1405.56)
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 27
		helper_4116e6bb(3560040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(7, "話しポーズ待機", 4)
		event.set_object_sequence_motion(6, "会話", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 28
		helper_4116e6bb(3560050)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 29
		helper_4116e6bb(3560055)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(7, "はっ！", 6)
		event.queue_object_sequence_next_motion(7, "立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 30
		helper_4116e6bb(3560060)
		event.reset_mouth_texture_animations()
		at = 31
		wait_frames(30)
		event.stop_sound_effect(var4, 4)
		event.play_sound_effect(var4, 14)
		event.set_character_active(1, 34)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(90)
		event.add_camera_sequence_path_point(-2317.41, 409.93, 812.37, -2227.35, 407.72, 780.15)
		event.add_camera_sequence_path_point(-1582.49, 409.93, 549.51, -1495.25, 407.72, 518.31)
		event.start_camera_sequence_path()
		at = 32
		wait_camera()
		event.set_camera_sequence_position(-572.71, 409.93, 60.46)
		event.set_camera_sequence_look_at(-485.48, 407.72, 29.26)
		at = 33
		wait_frames(60)
		event.set_object_sequence_motion(5, "呪文", 4)
		event.play_sound_effect(var4, 15)
		event.set_camera_sequence_position(-215.86, 432.29, -37.91)
		event.set_camera_sequence_look_at(-143.93, 430.08, -96.45)
		event.set_mouth_texture_animations(5, "通常口パク")
		at = 34
		helper_1584c528(3560070, -1)
		event.reset_mouth_texture_animations()
		at = 35
		wait_frames(30)
		event.set_camera_sequence_position(2634.97, 591.93, 821.31)
		event.set_camera_sequence_look_at(1909.14, 546.61, 812.29)
		event.set_character_scale(45, 1.5, 1.5, 1.5)
		event.set_character_scale(46, 1.5, 1.5, 1.5)
		event.set_character_scale(47, 1.5, 1.5, 1.5)
		event.set_character_position(45, 0.0, 480.68, 0.0)
		event.set_character_rotation(45, 0.0, 0.0, 0.0)
		event.set_character_active(1, 45)
		event.set_character_position(46, 0.0, 480.68, 0.0)
		event.set_character_rotation(46, 0.0, -1.2, 0.0)
		event.set_character_position(47, -2741.37, 499.29, 1144.49)
		event.set_character_rotation(47, 0.0, 0.0, 0.0)
		event.set_character_motion(45, "発射", 6, -1, 1)
		at = 36
		wait_frames(15)
		event.play_sound_effect(var4, 16)
		at = 37
		wait_frames(15)
		event.set_character_active(1, 46)
		event.move_object_sequence(18, -2884.97, 501.86, 1101.17, 30)
		at = 38
		wait_frames(20)
		event.set_camera_sequence_position(-1963.8, 545.73, 2572.58)
		event.set_camera_sequence_look_at(-2020.19, 543.47, 2470.6)
		at = 39
		wait_frames(9)
		event.set_character_active(0, 46)
		event.set_character_active(1, 47)
		event.play_sound_effect(var4, 17)
		event.set_character_motion(47, "ヒット", 6, -1, 1)
		event.delay_camera_sequence_shake_track(10)
		event.shake_camera_sequence(0.0, 10.3, 0.0, 90)
		at = 40
		wait_frames(30)
		event.rotate_object_sequence(8, 0.0, 0.0, 0.06, 60)
		at = 41
		wait_frames(60)
		event.set_character_active(0, 47)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.play_sound_effect(var4, 18)
		event.stop_sound_effect(var4, 14)
		event.set_camera_sequence_position(-1938.53, 42.72, 1126.84)
		event.set_camera_sequence_look_at(-1989.75, 48.9, 1098.63)
		event.set_object_sequence_rotation(17, 0.0, 1.92, 0.0)
		event.set_character_active(1, 33)
		event.set_object_handle_visible(14, 0)
		event.set_object_sequence_position(17, -2458.92, 167.76, 852.48)
		event.play_sound_effect(var4, 19)
		event.set_object_sequence_motion(17, "横から縦移動", 6)
		event.queue_object_sequence_next_motion(17, "狙う", 6)
		event.queue_object_sequence_next_motion(17, "狙い立ち", 6)
		at = 42
		wait_objects(17)
		event.stop_sound_effect(var4, 19)
		event.set_character_position(40, -2279.73, 181.5, 788.22)
		event.set_character_rotation(40, 0.0, 1.9, 0.0)
		event.set_character_position(43, -2279.73, 181.5, 788.22)
		event.set_character_rotation(43, 0.0, 1.9, 0.0)
		event.set_character_active(1, 40)
		event.play_sound_effect(var4, 20)
		event.set_character_motion(40, "発射", 6, -1, 1)
		event.set_object_sequence_motion(17, "発射", 6)
		event.queue_object_sequence_next_motion(17, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		at = 43
		wait_frames(5)
		event.set_character_active(1, 43)
		event.move_object_sequence(19, -1846.06, 191.5, 633.95, 30)
		at = 44
		wait_frames(60)
		event.set_character_active(0, 43)
		event.play_sound_effect(var4, 20)
		event.set_character_motion(40, "発射", 6, -1, 1)
		event.set_object_sequence_motion(17, "発射", 6)
		event.queue_object_sequence_next_motion(17, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		at = 45
		wait_frames(5)
		event.set_character_active(1, 43)
		event.set_character_position(43, -2279.73, 181.5, 788.22)
		event.set_character_rotation(43, 0.0, 1.9, 0.0)
		event.move_object_sequence(19, -1846.06, 191.5, 633.95, 30)
		at = 46
		wait_frames(60)
		event.set_character_active(0, 40)
		event.set_character_active(0, 43)
		event.stop_sound_effect(var4, 18)
		event.play_sound_effect(var4, 21)
		event.set_event_projection(208.9)
		event.set_camera_sequence_position(-2164.25, 179.07, 755.08)
		event.set_camera_sequence_look_at(-2064.38, 141.78, 719.62)
		event.set_character_active(1, 43)
		event.set_object_sequence_position(19, -2064.38, 141.78, 719.62)
		event.clear_object_sequence_path(19)
		event.set_object_sequence_path_frames(19, 90)
		event.add_object_sequence_path_point(19, -2064.38, 141.78, 719.62)
		event.add_object_sequence_path_point(19, 0.0, 480.68, 0.0)
		event.start_object_sequence_path(19)
		event.set_camera_sequence_follow_object(16, 0.0, 0.0, 0.0, -1.23, 37.29, 105.98)
		at = 47
		wait_frames(60)
		event.clear_object_sequence_path(19)
		event.set_object_sequence_object(19, 16)
		event.release_camera_sequence_follow_object()
		event.set_event_projection(projection)
		event.set_camera_sequence_position(-207.36, 438.78, -44.18)
		event.set_camera_sequence_look_at(-170.18, 431.53, -74.54)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "はっと顔")
		event.set_object_sequence_texture_animation(5, 1, "通常目パチ")
		event.set_object_sequence_motion(5, "ふせぐ", 6)
		event.queue_object_sequence_next_motion(5, "ふせぐL", 4)
		at = 48
		wait_frames(30)
		event.set_camera_sequence_position(-87.05, 438.78, 734.67)
		event.set_camera_sequence_look_at(-222.41, 431.53, -65.71)
		event.set_character_position(35, -280.28, 480.68, 182.19)
		event.set_character_rotation(35, 0.0, -1.68, 0.0)
		event.set_character_motion(35, "バリア", 2, -1, 1)
		event.set_character_active(1, 35)
		event.delay_camera_sequence_shake_track(10)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 120)
		at = 49
		wait_frames(60)
		event.set_character_active(0, 35)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "くいしばり")
		event.set_object_sequence_texture_animation(5, 1, "通常目パチ")
		event.play_sound_effect(var4, 22)
		event.set_camera_sequence_position(-180.2, 426.54, -51.75)
		event.set_camera_sequence_look_at(-169.56, 436.78, -92.29)
		at = 50
		wait_frames(90)
		event.play_sound_effect(var4, 23)
		event.set_event_projection(208.9)
		event.set_camera_sequence_position(-2164.25, 179.07, 755.08)
		event.set_camera_sequence_look_at(-2064.38, 141.78, 719.62)
		event.set_object_sequence_position(19, -2064.38, 141.78, 719.62)
		event.clear_object_sequence_path(19)
		event.set_object_sequence_path_frames(19, 90)
		event.add_object_sequence_path_point(19, -2064.38, 141.78, 719.62)
		event.add_object_sequence_path_point(19, -280.28, 480.68, 182.19)
		event.start_object_sequence_path(19)
		event.set_camera_sequence_follow_object(16, 0.0, 0.0, 0.0, -1.23, 37.29, 105.98)
		at = 51
		wait_frames(60)
		event.clear_object_sequence_path(19)
		event.set_object_sequence_object(19, 16)
		event.release_camera_sequence_follow_object()
		event.set_event_projection(projection)
		event.set_camera_sequence_position(-1229.21, -140.51, 2033.13)
		event.set_camera_sequence_look_at(-413.29, 265.59, -747.44)
		event.set_character_position(48, -280.28, 480.68, 182.19)
		event.set_character_rotation(48, 0.0, -1.68, 0.0)
		at = 52
		wait_frames(29)
		event.set_character_active(0, 43)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 30)
		event.set_character_motion(48, "命中", 6, -1, 1)
		event.set_character_active(1, 48)
		at = 53
		wait_frames(30)
		event.set_camera_sequence_position(-499.15, 603.41, 701.23)
		event.set_camera_sequence_look_at(-222.41, 431.53, -65.71)
		event.start_crossfade(30)
		event.set_character_active(0, 48)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 30)
		event.set_character_motion(48, "命中", 6, -1, 1)
		event.set_character_active(1, 48)
		at = 54
		wait_frames(40)
	end, function(received: { any }): boolean
		if at <= 4 then
			wait_frames_skipping(35)
		end
		if at <= 5 then
			helper_23000000()
		end
		if at <= 6 then
			helper_8cd371d7(3560010)
		end
		if at <= 7 then
			wait_frames_skipping(30)
		end
		if at <= 8 then
			helper_8cd371d7(3560020)
		end
		if at <= 9 then
			wait_frames_skipping(60)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			wait_frames_skipping(60)
		end
		if at <= 12 then
			wait_frames_skipping(60)
		end
		if at <= 13 then
			wait_frames_skipping(60)
		end
		if at <= 14 then
			wait_frames_skipping(30)
		end
		if at <= 15 then
			helper_344d6cd8()
		end
		if at <= 16 then
			helper_344d6cd8()
		end
		if at <= 17 then
			helper_344d6cd8()
		end
		if at <= 18 then
			wait_frames_skipping(60)
		end
		if at <= 19 then
			helper_52aadc70(3560025, -1)
		end
		if at <= 20 then
			helper_52aadc70(3560030, -1)
		end
		if at <= 21 then
			wait_frames_skipping(5)
		end
		if at <= 22 then
			wait_frames_skipping(10)
		end
		if at <= 23 then
			wait_frames_skipping(20)
		end
		if at <= 24 then
			helper_238b5abc(6)
		end
		if at <= 25 then
			wait_frames_skipping(30)
		end
		if at <= 26 then
			helper_8cd371d7(3560040)
		end
		if at <= 27 then
			helper_8cd371d7(3560050)
		end
		if at <= 28 then
			helper_8cd371d7(3560055)
		end
		if at <= 29 then
			helper_8cd371d7(3560060)
		end
		if at <= 30 then
			wait_frames_skipping(30)
		end
		if at <= 31 then
			helper_344d6cd8()
		end
		if at <= 32 then
			wait_frames_skipping(60)
		end
		if at <= 33 then
			helper_52aadc70(3560070, -1)
		end
		if at <= 34 then
			wait_frames_skipping(30)
		end
		if at <= 35 then
			wait_frames_skipping(15)
		end
		if at <= 36 then
			wait_frames_skipping(15)
		end
		if at <= 37 then
			wait_frames_skipping(20)
		end
		if at <= 38 then
			wait_frames_skipping(9)
		end
		if at <= 39 then
			wait_frames_skipping(30)
		end
		if at <= 40 then
			wait_frames_skipping(60)
		end
		if at <= 41 then
			helper_238b5abc(17)
		end
		if at <= 42 then
			wait_frames_skipping(5)
		end
		if at <= 43 then
			wait_frames_skipping(60)
		end
		if at <= 44 then
			wait_frames_skipping(5)
		end
		if at <= 45 then
			wait_frames_skipping(60)
		end
		if at <= 46 then
			wait_frames_skipping(60)
		end
		if at <= 47 then
			wait_frames_skipping(30)
		end
		if at <= 48 then
			wait_frames_skipping(60)
		end
		if at <= 49 then
			wait_frames_skipping(90)
		end
		if at <= 50 then
			wait_frames_skipping(60)
		end
		if at <= 51 then
			wait_frames_skipping(29)
		end
		if at <= 52 then
			wait_frames_skipping(30)
		end
		if at <= 53 then
			wait_frames_skipping(40)
		end
		return true
	end)
	at = 55
	vm.entry(55)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 56
	wait_frames(30)
	event.set_event_projection(projection)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.stop_sound_effect(var4, 4)
	event.stop_sound_effect(var4, 14)
	event.stop_sound_effect(var4, 18)
	event.stop_sound_effect(var4, 19)
	event.stop_sound_effect(var4, 25)
	event.stop_sound_effect(var4, 30)
	event.stop_port_sound_effects(4)
	at = 57
	vm.wait(57)
	helper_294a0()
end

--- Helper function.
local function helper_31ed0()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global16 = 0
		global17 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global16)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", global16)
		event.attach_object_handle_to_character(0, global16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global16)
		event.load_character(5, "chara/c02_base.gltf", "info", global17)
		event.load_equipment_model(5, 1, 1, "info", global17, 17)
		event.load_equipment_model(5, 1, 0, "info", global17, 18)
		event.load_equipment_model(5, 1, 4, "info", global17)
		event.load_equipment_model(5, 1, 3, "info", global17)
		event.load_equipment_model(5, 1, 2, "info", global17, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global17)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", global17)
		event.attach_object_handle_to_character(1, global17)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global17)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if active_chr_no == 1 then
		global16 = 8
		global17 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global16)
		event.load_equipment_model(5, 0, 1, "info", global16, 17)
		event.load_equipment_model(5, 0, 0, "info", global16, 18)
		event.load_equipment_model(5, 0, 4, "info", global16)
		event.load_equipment_model(5, 0, 3, "info", global16)
		event.load_equipment_model(5, 0, 2, "info", global16, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global16)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", global16)
		event.attach_object_handle_to_character(0, global16)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global16)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global17)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", global17)
		event.attach_object_handle_to_character(1, global17)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global17)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e356/e356_crest2.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.attach_object_handle_to_character(5, 11)
	event.clear_object_sequence(5, 11)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "event/e300/e356/e356_lin2.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(4, 9)
	event.set_object_sequence_object(4, 4)
	event.load_character(5, "event/e300/e356/e356_guiltoni.gltf", "info", 15)
	event.set_character_active(0, 15)
	event.attach_object_handle_to_character(6, 15)
	event.clear_object_sequence(6, 15)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e300/e356/e356_jamming.gltf", "info", 21)
	event.set_character_active(0, 21)
	event.attach_object_handle_to_character(7, 21)
	event.clear_object_sequence(7, 21)
	event.set_object_sequence_object(7, 7)
	event.load_character(5, "event/e300/e356/e356_dsmoke.gltf", "info", 22)
	event.set_character_active(0, 22)
	event.load_character(5, "event/e300/e356/e356_cre_kemuri.gltf", "info", 20)
	event.set_character_active(0, 20)
	event.load_character(5, "event/e300/e356/e356_dwarp.gltf", "info", 19)
	event.set_character_active(0, 19)
	event.attach_object_handle_to_character(14, 19)
	event.clear_object_sequence(14, 19)
	event.set_object_sequence_object(14, 14)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ３５６火の粉")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_map_part_2(8, "p01_battleship")
	event.clear_object_sequence(8)
	event.set_object_sequence_object(8, 8)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.attach_object_handle_to_map_part_2(15, "p07_d03b01")
	event.clear_object_sequence(15)
	event.set_object_sequence_object(15, 15)
	event.attach_object_handle_to_map_part_3(10, "p01_d03b01", "d03b01_12-m0")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.attach_object_handle_to_map_part_3(11, "p02_d03b01", "d03b01_3-m0")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 11)
	event.attach_object_handle_to_map_part_3(12, "p02_d03b01", "d03b01_15-m0")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	event.attach_object_handle_to_map_part_3(13, "p01_battleship", "tbig-m0")
	event.clear_object_sequence(13)
	event.set_object_sequence_object(13, 13)
	event.load_message_file(0, 5, "event/e300/e356/e356_1.txt")
end

--- Helper function.
local function helper_23200000()
	global16 = 0
	global17 = 8
	global16 = 8
	global17 = 0
end

--- Helper function.
local function helper_31840()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global16)
		event.set_character_active(0, global17)
		event.delete_character_extension_packs(global16)
		event.delete_character_extension_packs(global17)
		event.delete_character(global17)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global17)
		event.set_character_active(0, global16)
		event.delete_character_extension_packs(global16)
		event.delete_character_extension_packs(global17)
		event.delete_character(global16)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(9)
	event.delete_character(11)
	event.delete_character(15)
	event.delete_character(21)
	event.delete_character(22)
	event.delete_character(20)
	event.delete_character(19)
	event.set_function_point_enabled("", "func", 1)
	event.set_function_point_enabled("", "func4", 1)
	event.set_object_handle_visible(12, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
end

--- Helper function.
local function helper_33a7c()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		helper_31ed0()
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(152)
		event.load_map_sounds(3841)
		var4 = event.load_sound_effect_file_2(3841) or var4
		event.stop_port_sound_effects(1)
		projection = event.get_event_projection() or projection
		time = event.get_scene_time_of_day() or time
		event.enable_drama_skip()
		event.set_time_of_day(21.0)
		event.set_time_of_day_advancing(0)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "直撃顔")
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "おこり顔")
		event.set_object_sequence_texture_animation(4, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(7, 0)
		event.set_object_sequence_texture_animation(7, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(7, 1, "目パチ")
		event.set_function_point_enabled("", "func", 0)
		event.set_function_point_enabled("", "func4", 0)
		event.set_object_sequence_rotation(11, 0.0, 1.57, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 1.57, 0.0)
		event.set_object_handle_visible(8, 1)
		event.set_object_handle_visible(9, 1)
		event.set_object_handle_visible(12, 0)
		event.set_object_sequence_rotation(13, -0.4, 1.9, 0.0)
		event.create_effect("Ｅ３５６火の粉")
		event.set_effect_first_vector(0.0, 60.0, 0.0)
		event.set_camera_sequence_position(-130.8, 38.79, 63.09)
		event.set_camera_sequence_look_at(-74.0, 16.13, 36.55)
		event.set_character_active(1, 12)
		event.set_character_active(1, global16)
		event.set_character_active(1, global17)
		event.set_character_active(1, 9)
		event.set_character_active(1, 11)
		event.set_character_active(1, 15)
		event.set_character_active(0, 21)
		event.set_object_sequence_motion(4, "上見かまえ", 4)
		event.set_object_sequence_motion(5, "ふせぐL", 4)
		event.set_object_sequence_motion(1, "驚き", 4)
		event.set_object_sequence_motion(0, "上見かまえ", 4)
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(7, "立ち", 4)
		event.set_object_sequence_position(8, -3191.25, 25.75, 1213.17)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_character_active(1, 22)
		event.set_character_position(22, -3714.57, 453.25, 1349.41)
		event.set_character_rotation(22, 0.0, 0.0, 0.0)
		event.set_character_position(19, -3191.25, 25.75, 2275.09)
		event.set_character_rotation(19, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(7, -2784.72, 25.75, 1175.72)
		event.set_object_sequence_rotation(7, 0.0, 1.41, 0.0)
		event.set_object_sequence_position(6, -2765.6, 25.75, 1210.21)
		event.set_object_sequence_rotation(6, 0.0, 1.4, 0.0)
		event.set_object_sequence_position(1, -2766.34, 25.75, 1080.7)
		event.set_object_sequence_rotation(1, 0.0, 1.68, 0.0)
		event.set_object_sequence_position(5, -171.87, 401.97, -73.85)
		event.set_object_sequence_rotation(5, 0.0, -0.96, 0.0)
		event.set_object_sequence_position(4, -76.99, 0.0, 21.53)
		event.set_object_sequence_rotation(4, 0.0, -1.12, 0.0)
		event.set_object_sequence_position(0, -75.67, 0.0, 49.73)
		event.set_object_sequence_rotation(0, 0.0, -1.2, 0.0)
		event.set_character_position(20, -171.87, 402.97, -73.85)
		event.set_character_rotation(20, 0.0, -0.96, 0.0)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 3
		helper_1584c528(3560080, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "大口パク")
		at = 4
		helper_1584c528(3560090, -1)
		event.reset_mouth_texture_animations()
		at = 5
		wait_frames(30)
		event.clear_effect_manager()
		event.set_character_active(1, 20)
		event.set_camera_sequence_position(-184.06, 415.94, -34.92)
		event.set_camera_sequence_look_at(-164.04, 432.34, -99.26)
		at = 6
		wait_frames(90)
		event.set_character_active(0, 20)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "つらい顔")
		event.play_sound_effect(var4, 24)
		event.set_camera_sequence_position(-281.06, 415.94, -39.36)
		event.set_camera_sequence_look_at(-151.02, 432.34, -81.4)
		event.set_object_sequence_motion(5, "振り返る", 6)
		event.queue_object_sequence_next_motion(5, "振り返るＬ", 4)
		event.rotate_object_sequence(5, 0.0, 0.72, 0.0, 30)
		at = 7
		wait_frames(60)
		event.set_camera_sequence_position(-140.77, 480.0, -15.54)
		event.set_camera_sequence_look_at(-172.28, 437.71, -70.64)
		at = 8
		wait_frames(60)
		event.set_camera_sequence_position(-258.09, 457.17, -222.7)
		event.set_camera_sequence_look_at(-172.28, 437.71, -70.64)
		at = 9
		wait_frames(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-154.99, 437.5, -84.08, -289.74, 438.77, 31.8)
		event.add_camera_sequence_path_point(-154.99, 431.92, -84.08, -289.74, 433.19, 31.8)
		event.start_camera_sequence_path()
		at = 10
		wait_frames(100)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "つらいわらい顔")
		at = 11
		wait_camera()
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "目をとじる")
		at = 12
		wait_frames(60)
		event.set_object_sequence_motion(5, "倒れる", 6)
		at = 13
		wait_frames(60)
		event.play_music(0)
		event.set_object_handle_visible(9, 0)
		event.set_object_handle_visible(15, 1)
		event.set_motion_blur(60)
		event.set_object_sequence_motion(5, "落下", 4)
		event.set_object_handle_shadow_enabled(5, 0)
		event.set_camera_sequence_position(-553.51, 200.25, 54.3)
		event.set_camera_sequence_look_at(-469.06, 205.75, 43.81)
		event.start_crossfade(60)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 150)
		event.add_object_sequence_path_point(5, -249.12, 273.7, 22.14)
		event.add_object_sequence_path_point(5, -249.12, 240.32, 22.14)
		event.start_object_sequence_path(5)
		at = 14
		wait_frames(70)
		event.start_crossfade(60)
		event.set_camera_sequence_position(-317.2, 237.89, -76.53)
		event.set_camera_sequence_look_at(-279.42, 243.39, -22.7)
		at = 15
		wait_objects(5)
		event.set_motion_blur(0)
		event.set_object_handle_visible(9, 1)
		event.set_object_handle_visible(15, 0)
		event.set_event_projection(1502.9)
		event.play_sound_effect(var4, 25)
		event.set_camera_sequence_position(-2744.52, 54.57, 1323.71)
		event.set_camera_sequence_look_at(-2754.11, 50.78, 1201.72)
		event.set_object_sequence_motion(1, "驚き", 4, -1, 1)
		at = 16
		wait_frames(60)
		event.set_object_sequence_motion(1, "驚きからギル見", 6)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 17
		helper_4116e6bb(3560100)
		event.reset_mouth_texture_animations()
		at = 18
		wait_frames(30)
		event.set_camera_sequence_position(-3256.95, 81.8, 1278.1)
		event.set_camera_sequence_look_at(-3074.49, 50.78, 1211.03)
		event.set_object_sequence_position(1, -3078.05, 25.75, 1210.56)
		event.set_object_sequence_rotation(1, 0.0, 1.92, 0.0)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(1, -2826.26, 25.75, 1118.0, 60)
		at = 19
		wait_frames(40)
		event.queue_object_sequence_next_motion(1, "走り飛び", 6)
		event.queue_object_sequence_next_motion(1, "走り飛びＬ", 4)
		at = 20
		wait_objects(1)
		event.play_sound_effect(var4, 26)
		event.set_character_active(0, global17)
		event.set_object_handle_shadow_enabled(5, 1)
		event.set_object_handle_footstep_sound(1, 0)
		event.set_object_sequence_motion(0, "下向くL", 4)
		event.set_object_sequence_motion(4, "かかえ", 4)
		event.set_object_sequence_motion(5, "かかえ", 4)
		event.set_object_sequence_position(4, -137.71, 0.0, 40.8)
		event.set_object_sequence_rotation(4, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(0, -75.67, 0.0, 49.73)
		event.set_object_sequence_rotation(0, 0.0, -1.8, 0.0)
		event.set_object_sequence_position(5, -137.71, 0.0, 40.8)
		event.set_object_sequence_rotation(5, 0.0, -0.64, 0.0)
		event.set_object_sequence_position(1, -211.67, 0.0, 80.32)
		event.set_object_sequence_rotation(1, 0.0, 2.04, 0.0)
		event.set_camera_sequence_position(189.22, 107.03, -74.97)
		event.set_camera_sequence_look_at(87.21, 74.64, -36.26)
		at = 21
		wait_frames(60)
		event.play_sound_effect(var4, 27)
		event.set_object_sequence_motion(1, "着地２", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_character_active(1, global17)
		at = 22
		wait_frames(60)
		event.set_event_projection(projection)
		event.set_camera_sequence_position(-4827.61, 834.34, 4724.51)
		event.set_camera_sequence_look_at(-4506.58, 801.95, 4143.46)
		event.rotate_object_sequence(8, 0.0, 0.0, 0.06, 90)
		at = 23
		wait_frames(90)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_character_active(1, 21)
		event.set_camera_sequence_position(-2612.44, 131.75, 1201.26)
		event.set_camera_sequence_look_at(-2814.26, 47.07, 1200.05)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 24
		helper_4116e6bb(3560110)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(7, "通常口パク")
		at = 25
		helper_4116e6bb(3560120)
		event.reset_mouth_texture_animations()
		at = 26
		wait_frames(30)
		event.set_camera_sequence_position(-2737.6, 60.99, 1210.81)
		event.set_camera_sequence_look_at(-2832.46, 47.07, 1205.56)
		event.set_mouth_texture_animations(6, "通常口パク")
		at = 27
		helper_4116e6bb(3560130)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 28)
		event.set_object_sequence_motion(6, "ふりかえり", 6)
		at = 28
		wait_frames(30)
		event.set_character_active(0, 21)
		event.set_character_active(0, 15)
		event.set_character_active(0, 22)
		event.set_object_handle_scale(14, 2.0, 2.0, 2.0)
		event.set_character_active(1, 19)
		event.set_camera_sequence_position(-8070.2, 232.04, 2437.64)
		event.set_camera_sequence_look_at(-3648.73, 198.15, 1794.44)
		event.play_sound_effect(var4, 29)
		event.stop_sound_effect(var4, 14)
		event.stop_sound_effect(var4, 18)
		event.stop_sound_effect(var4, 19)
		event.stop_sound_effect(var4, 25)
		event.stop_sound_effect(var4, 30)
		event.set_character_motion(19, "消える", 2, -1, 1)
		at = 29
		wait_frames(60)
		event.start_crossfade(60)
		event.set_object_handle_visible(8, 0)
		event.fade_out_music(90)
		at = 30
		wait_frames(90)
		event.stop_music(0)
		event.set_function_point_enabled("p01_battleship", "func", 0)
		event.set_function_point_enabled("p01_battleship", "func0", 0)
		event.set_function_point_enabled("p01_battleship", "func1", 0)
		event.set_function_point_enabled("p01_battleship", "func2", 0)
		event.set_function_point_enabled("p01_battleship", "func3", 0)
		event.set_function_point_enabled("p01_battleship", "func4", 0)
		event.set_function_point_enabled("p01_battleship", "func5", 0)
		event.set_function_point_enabled("p01_battleship", "func6", 0)
		event.set_function_point_enabled("p01_battleship", "bframe01", 0)
		event.set_function_point_enabled("p01_battleship", "bframe02", 0)
		event.set_function_point_enabled("p01_battleship", "bframe03", 0)
		at = 31
		vm.wait(31)
		at = 32
		vm.wait(32)
		at = 33
		vm.wait(33)
		at = 34
		vm.wait(34)
		event.load_music(52)
		event.play_music(0)
		event.set_character_active(0, 19)
		event.set_object_sequence_position(8, -13191.25, 25.75, 1213.17)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.play_sound_effect(var4, 30, 10)
		event.set_motion_blur(0)
		event.set_object_sequence_position(1, -102.8, 0.0, 11.44)
		event.set_object_sequence_rotation(1, 0.0, -0.72, 0.0)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "かなし顔")
		event.set_object_sequence_texture_animation(4, 1, "なき目パチ")
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "くるし目とじ顔")
		event.set_camera_sequence_position(-151.61, 15.21, 74.52)
		event.set_camera_sequence_look_at(-132.03, 7.02, 23.84)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 35
		helper_4116e6bb(3560140)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "目をあける")
		event.set_mouth_texture_animations(5, "くるし口パク")
		at = 36
		helper_4116e6bb(3560150)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "ひきよせる", 2)
		event.queue_object_sequence_next_motion(4, "ゆする", 4)
		event.set_object_sequence_motion(5, "ひきよせる", 2)
		event.queue_object_sequence_next_motion(5, "ゆする", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 37
		helper_4116e6bb(3560160)
		event.reset_mouth_texture_animations()
		at = 38
		wait_objects(4)
		event.queue_object_sequence_next_motion(4, "ひきよせるL")
		event.queue_object_sequence_next_motion(5, "ひきよせるL")
		event.set_mouth_texture_animations(5, "くるし口パク")
		at = 39
		helper_4116e6bb(3560170)
		event.reset_mouth_texture_animations()
		at = 40
		wait_frames(30)
		event.set_object_sequence_motion(4, "ゆする")
		event.set_object_sequence_motion(5, "ゆする")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "かなし顔")
		event.set_object_sequence_texture_animation(1, 1, "かなし目パチ")
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-20.51, 20.32, 55.72, -95.9, 19.0, 70.13)
		event.add_camera_sequence_path_point(-26.7, 20.32, 23.31, -102.09, 19.0, 37.72)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 41
		helper_4116e6bb(3560180)
		event.reset_mouth_texture_animations()
		at = 42
		wait_camera()
		at = 43
		wait_frames(30)
		event.set_object_sequence_motion(4, "かかえ", 4)
		event.set_object_sequence_motion(5, "かかえ", 4)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "くるし顔")
		event.set_object_sequence_texture_animation(5, 1, "くるし目パチ")
		event.set_camera_sequence_position(-171.94, 29.88, 48.93)
		event.set_camera_sequence_look_at(-139.58, 8.06, 46.52)
		event.set_mouth_texture_animations(5, "くるし口パク")
		at = 44
		helper_4116e6bb(3560190)
		event.reset_mouth_texture_animations()
		at = 45
		wait_frames(30)
		event.set_object_sequence_position(0, -91.26, 0.0, 25.67)
		event.set_object_sequence_rotation(0, 0.0, -1.2, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1, 1)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ショック顔")
		event.set_object_sequence_texture_animation(0, 1, "ショック目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "ショック顔")
		event.set_object_sequence_texture_animation(1, 1, "ショック目パチ")
		event.set_camera_sequence_position(-151.61, 15.21, 74.52)
		event.set_camera_sequence_look_at(-132.03, 7.02, 23.84)
		event.set_object_sequence_motion(4, "ゆする（小）", 4)
		event.set_object_sequence_motion(5, "ゆする（小）", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 46
		helper_4116e6bb(3560200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "ひきよせるL")
		event.set_object_sequence_motion(5, "ひきよせるL")
		event.play_sound_effect(var4, 32)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 47
		helper_4116e6bb(3560210)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "なき目あき～なき目とじ")
		event.set_object_sequence_motion(4, "すりすり", 2)
		event.queue_object_sequence_next_motion(4, "すりすりL", 4)
		event.set_object_sequence_motion(5, "すりすり", 2)
		event.queue_object_sequence_next_motion(5, "すりすりL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 48
		helper_4116e6bb(3560215)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "なき目とじ～なき目あき")
		event.set_object_sequence_motion(4, "すりすり戻り", 2)
		event.queue_object_sequence_next_motion(4, "ひきよせるL", 4)
		event.set_object_sequence_motion(5, "すりすり戻り", 2)
		event.queue_object_sequence_next_motion(5, "ひきよせるL", 4)
		event.set_mouth_texture_animations(5, "くるし口パク")
		at = 49
		helper_4116e6bb(3560220)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "目をとじる")
		event.set_object_sequence_motion(4, "死ぬ", 2)
		event.queue_object_sequence_next_motion(4, "死ぬL", 4)
		event.set_object_sequence_motion(5, "死ぬ", 2)
		event.queue_object_sequence_next_motion(5, "死ぬL", 4)
		at = 50
		wait_frames(38)
		event.set_object_sequence_motion(4, "先生？", 2)
		event.queue_object_sequence_next_motion(4, "泣く", 2)
		event.queue_object_sequence_next_motion(4, "泣くL", 4)
		event.set_object_sequence_motion(5, "先生？", 2)
		event.queue_object_sequence_next_motion(5, "泣く", 2)
		event.queue_object_sequence_next_motion(5, "泣くL", 4)
		at = 51
		wait_frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "ごうきゅう目とじ")
		event.play_sound_effect(var4, 33)
		event.set_mouth_texture_animations(4, "大口パク")
		event.delay_camera_sequence_position_track(150)
		event.set_camera_sequence_position(-129.66, 28.98, 36.73)
		event.set_camera_sequence_look_at(-83.24, 17.19, 9.16)
		event.delay_object_sequence_motion_track(1, 150)
		event.set_object_sequence_motion(1, "顔そむけ", 6)
		event.queue_object_sequence_next_motion(1, "顔そむけL", 4)
		event.delay_object_sequence_texture_animation_track(1, 150)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "ショック顔")
		event.set_object_sequence_texture_animation(1, 1, "目あき～目とじ")
		event.set_object_sequence_texture_animation(1, 1, "口あき～口とじ")
		at = 52
		helper_1584c528(3560230, -1)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-2715.35, 28.98, 1572.42, -83.24, 17.19, 9.16)
		event.add_camera_sequence_path_point(-4454.34, 28.98, 2605.23, -83.24, 17.19, 9.16)
		event.start_camera_sequence_path()
		event.fade_out_music(200)
		at = 53
		wait_frames(170)
		event.fade_out_screen(30)
		at = 54
		wait_frames(30)
		at = 55
		wait_camera()
		event.stop_sound_effect(var4, 30)
		event.stop_music(0)
		at = 56
		vm.wait(56)
		at = 57
		vm.wait(57)
		at = 58
		vm.wait(58)
		at = 59
		vm.wait(59)
		event.load_music(112)
		event.play_music(0)
		event.delete_character(9)
		event.load_character(5, "event/e300/e356/e356_lin3.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(4, 9)
		event.clear_object_sequence(4, 9)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_object_sequence_position(4, -137.49, 0.0, 51.6)
		event.set_object_sequence_rotation(4, 0.0, -1.24, 0.0)
		event.set_object_sequence_position(5, -137.49, 0.0, 51.6)
		event.set_object_sequence_rotation(5, 0.0, -1.24, 0.0)
		event.set_character_active(1, 9)
		event.set_character_active(0, global16)
		event.set_character_active(0, global17)
		event.set_character_active(0, 12)
		event.set_object_sequence_motion(4, "ひざまくら", 4)
		event.set_object_sequence_motion(5, "ひざまくら", 4)
		event.set_object_handle_visible(9, 0)
		event.set_function_point_enabled("", "func2", 0)
		event.set_function_point_enabled("", "func3", 0)
		event.set_function_point_enabled("", "func0", 1)
		event.set_camera_sequence_position(-27.09, 20.37, 12.51)
		event.set_camera_sequence_look_at(-106.92, 28.16, 40.78)
		event.fade_in_screen(30)
		at = 60
		wait_frames(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-207.92, 44.8, 103.93, -142.38, 14.02, 55.1)
		event.add_camera_sequence_path_point(-170.48, 44.8, 76.03, -142.38, 14.02, 55.1)
		event.start_camera_sequence_path()
		at = 61
		wait_camera()
		event.set_mouth_texture_animations(4, "わらい口パク")
		at = 62
		helper_4116e6bb(3560270)
		event.reset_mouth_texture_animations()
		at = 63
		wait_frames(60)
		event.set_camera_sequence_position(-27.09, 20.37, 12.51)
		event.set_camera_sequence_look_at(-106.92, 28.16, 40.78)
		event.set_mouth_texture_animations(4, "わらい口パク")
		at = 64
		helper_4116e6bb(3560280)
		event.reset_mouth_texture_animations()
		at = 65
		wait_frames(30)
		event.set_camera_sequence_position(-132.45, 11.9, 87.83)
		event.set_camera_sequence_look_at(-142.38, 10.03, 55.1)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "目あき～かなし目とじ")
		event.set_object_sequence_motion(4, "下向く", 6)
		event.queue_object_sequence_next_motion(4, "下向くL", 4)
		event.set_mouth_texture_animations(4, "わらい口パク")
		at = 66
		helper_4116e6bb(3560290)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "わらい口パク")
		at = 67
		helper_4116e6bb(3560295)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "わらい口パク")
		at = 68
		helper_4116e6bb(3560300)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "かなし目とじ～目あき")
		event.set_object_sequence_motion(4, "下向く戻り", 6)
		event.queue_object_sequence_next_motion(4, "ひざまくら", 4)
		event.set_mouth_texture_animations(4, "わらい口パク")
		at = 69
		helper_4116e6bb(3560310)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "涙目あき～目とじ")
		event.set_object_sequence_motion(4, "涙をふく", 6)
		event.queue_object_sequence_next_motion(4, "ひざまくら", 4)
		at = 70
		wait_frames(60)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_camera_sequence_position(-27.09, 20.37, 12.51)
		event.set_camera_sequence_look_at(-106.92, 28.16, 40.78)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 71
		helper_4116e6bb(3560320)
		event.reset_mouth_texture_animations()
		at = 72
		wait_frames(60)
		event.set_camera_sequence_position(-169.91, 44.8, 75.61)
		event.set_camera_sequence_look_at(-142.38, 14.02, 55.1)
		event.move_camera_sequence_eased(-189.8, 92.55, 87.58, -142.38, 14.02, 55.1, 200, 2, 1.0)
		event.set_mouth_texture_animations(4, "通常口パク")
		at = 73
		helper_4116e6bb(3560330)
		event.reset_mouth_texture_animations()
		at = 74
		wait_camera()
		event.set_camera_sequence_position(-1140.72, -772.93, 5162.45)
		event.set_camera_sequence_look_at(-1053.47, -759.54, 4629.56)
		event.move_camera_sequence_eased(-1140.72, -772.93, 5162.45, -1053.47, -306.64, 4629.56, 200, 2, 1.0)
		event.fade_out_music(200)
		at = 75
		wait_frames(200)
		event.stop_music(0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_23200000()
			wait_frames_skipping(4)
		end
		if at <= 2 then
			helper_52aadc70(3560080, -1)
		end
		if at <= 3 then
			helper_52aadc70(3560090, -1)
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		if at <= 5 then
			wait_frames_skipping(90)
		end
		if at <= 6 then
			wait_frames_skipping(60)
		end
		if at <= 7 then
			wait_frames_skipping(60)
		end
		if at <= 8 then
			wait_frames_skipping(60)
		end
		if at <= 9 then
			wait_frames_skipping(100)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			wait_frames_skipping(60)
		end
		if at <= 12 then
			wait_frames_skipping(60)
		end
		if at <= 13 then
			wait_frames_skipping(70)
		end
		if at <= 14 then
			helper_238b5abc(5)
		end
		if at <= 15 then
			wait_frames_skipping(60)
		end
		if at <= 16 then
			helper_8cd371d7(3560100)
		end
		if at <= 17 then
			wait_frames_skipping(30)
		end
		if at <= 18 then
			wait_frames_skipping(40)
		end
		if at <= 19 then
			helper_238b5abc(1)
		end
		if at <= 20 then
			wait_frames_skipping(60)
		end
		if at <= 21 then
			wait_frames_skipping(60)
		end
		if at <= 22 then
			wait_frames_skipping(90)
		end
		if at <= 23 then
			helper_8cd371d7(3560110)
		end
		if at <= 24 then
			helper_8cd371d7(3560120)
		end
		if at <= 25 then
			wait_frames_skipping(30)
		end
		if at <= 26 then
			helper_8cd371d7(3560130)
		end
		if at <= 27 then
			wait_frames_skipping(30)
		end
		if at <= 28 then
			wait_frames_skipping(60)
		end
		if at <= 29 then
			wait_frames_skipping(90)
		end
		if at <= 34 then
			helper_8cd371d7(3560140)
		end
		if at <= 35 then
			helper_8cd371d7(3560150)
		end
		if at <= 36 then
			helper_8cd371d7(3560160)
		end
		if at <= 37 then
			helper_238b5abc(4)
		end
		if at <= 38 then
			helper_8cd371d7(3560170)
		end
		if at <= 39 then
			wait_frames_skipping(30)
		end
		if at <= 40 then
			helper_8cd371d7(3560180)
		end
		if at <= 41 then
			helper_344d6cd8()
		end
		if at <= 42 then
			wait_frames_skipping(30)
		end
		if at <= 43 then
			helper_8cd371d7(3560190)
		end
		if at <= 44 then
			wait_frames_skipping(30)
		end
		if at <= 45 then
			helper_8cd371d7(3560200)
		end
		if at <= 46 then
			helper_8cd371d7(3560210)
		end
		if at <= 47 then
			helper_8cd371d7(3560215)
		end
		if at <= 48 then
			helper_8cd371d7(3560220)
		end
		if at <= 49 then
			wait_frames_skipping(38)
		end
		if at <= 50 then
			wait_frames_skipping(30)
		end
		if at <= 51 then
			helper_52aadc70(3560230, -1)
		end
		if at <= 52 then
			wait_frames_skipping(170)
		end
		if at <= 53 then
			wait_frames_skipping(30)
		end
		if at <= 54 then
			helper_344d6cd8()
		end
		if at <= 59 then
			wait_frames_skipping(60)
		end
		if at <= 60 then
			helper_344d6cd8()
		end
		if at <= 61 then
			helper_8cd371d7(3560270)
		end
		if at <= 62 then
			wait_frames_skipping(60)
		end
		if at <= 63 then
			helper_8cd371d7(3560280)
		end
		if at <= 64 then
			wait_frames_skipping(30)
		end
		if at <= 65 then
			helper_8cd371d7(3560290)
		end
		if at <= 66 then
			helper_8cd371d7(3560295)
		end
		if at <= 67 then
			helper_8cd371d7(3560300)
		end
		if at <= 68 then
			helper_8cd371d7(3560310)
		end
		if at <= 69 then
			wait_frames_skipping(60)
		end
		if at <= 70 then
			helper_8cd371d7(3560320)
		end
		if at <= 71 then
			wait_frames_skipping(60)
		end
		if at <= 72 then
			helper_8cd371d7(3560330)
		end
		if at <= 73 then
			helper_344d6cd8()
		end
		if at <= 74 then
			wait_frames_skipping(200)
		end
		return true
	end)
	at = 76
	vm.entry(76)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	at = 77
	wait_frames(30)
	event.set_event_projection(projection)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	event.stop_port_sound_effects(1)
	event.skip_next_map_sound_load()
	event.skip_next_music_load()
	event.clear_effect_manager()
	event.set_object_handle_visible(9, 1)
	event.set_object_handle_visible(15, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_sound_effect(var4, 14)
	event.stop_sound_effect(var4, 18)
	event.stop_sound_effect(var4, 19)
	event.stop_sound_effect(var4, 25)
	event.stop_sound_effect(var4, 30)
	event.set_motion_blur(0)
	at = 78
	vm.wait(78)
	at = 79
	helper_31840()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_10aa8()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.init_sepia_effect(5)
	event.start_sepia_effect()
	vm.wait(1)
	vm.wait(2)
	active_chr_no = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 or active_chr_no == 3 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			global4 = out1 or global4
			global5 = out2 or global5
			global6 = out3 or global6
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			global7 = out2 or global7
		end
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.set_character_change_unmasked(0, 1)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(1, 0)
		event.set_character_change_unmasked(3, 0)
		event.set_character_position(0, global0, global1, global2)
		event.set_character_rotation(0, 0.0, global3, 0.0)
		event.load_map_sounds(3690)
	else
		do
			local out1, out2, out3 = event.get_character_position(0)
			global0 = out1 or global0
			global1 = out2 or global1
			global2 = out3 or global2
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			global3 = out2 or global3
		end
		event.switch_dungeon_main_character(1)
		event.set_playable_character(1)
		event.set_character_change_unmasked(0, 0)
		event.set_character_change_unmasked(2, 0)
		event.set_character_change_unmasked(1, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_character_position(0, global4, global5, global6)
		event.set_character_rotation(0, 0.0, global7, 0.0)
		event.load_map_sounds(3691)
	end
	event.reset_dungeon_collision_primitives()
	event.set_character_motion(0, "かまえ立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 20.0)
	do
		local out1, out2, out3 = event.get_previous_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_previous_camera_look_at()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.end_sepia_effect()
	event.start_crossfade(1, 1, 20)
	vm.wait(3)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_108ec

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.initialize_event()
	event.set_character_position(0, 0.0, 0.0, 0.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.fade_in_screen(30)
	vm.wait(1)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_3cb94

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_music(10)
	event.fade_out_screen(10)
	wait_frames(10)
	event.stop_music(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.switch_dungeon_main_character(0)
	end
	if active_chr_no == 3 then
		event.switch_dungeon_main_character(1)
	end
	event.clear_event_battle_monsters(-1)
	stage_id = event.get_dungeon_stage_id() or stage_id
	var2 = event.get_dungeon_floor() or var2
	event.set_dungeon_floor_info(stage_id, var2, 5, 2)
	vm.wait(2)
	event.go_to_georama_edit(62, 504)
end

--- Event 502, which map data, a script or the engine runs by number.
script.event_502 = helper_13668

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	local time: f32 = 0
	local active_chr_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		helper_108ec()
		at = 1
		helper_1b1b4()
		at = 2
		helper_26f10()
		event.attach_object_handle_to_map_part_2(0, "p01_battleship")
		event.set_object_handle_position(0, -2194.9, 487.8, -474.2)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		time = event.get_scene_time_of_day() or time
		event.set_event_saved_time_of_day(time)
		event.set_time_of_day_advancing(0)
		event.set_time_of_day(18.0)
		at = 3
		vm.wait(3)
		event.initialize_event()
		at = 4
		vm.wait(4)
		event.stop_music(0)
		at = 5
		wait_frames(4)
		event.load_music(190)
		event.play_music(0)
		event.load_map_sounds(3691)
		event.set_function_point_enabled("", "func0", 0)
		event.set_function_point_enabled("", "func2", 1)
		event.set_function_point_enabled("", "func3", 1)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 1 then
			event.switch_dungeon_main_character(1)
			event.set_playable_character(1)
		end
		event.set_character_change_unmasked(0, 0)
		event.set_character_change_unmasked(2, 0)
		event.set_save_control_bits(1, 1)
		event.set_character_position(0, -2195.0, 488.0, -515.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_camera_look_at(-2195.0, 513.0, -475.0)
		event.set_camera_position(-2195.0, 518.0, -555.0)
		event.reset_follow_camera(0)
		event.initialize_sound_port(4)
		event.load_dungeon_monster(510, 1)
		event.load_dungeon_monster(513, 0)
		event.load_dungeon_monster(602, 0)
		event.place_dungeon_monster(510, -2195.0, 488.0, -435.0, 0.0, 3.14, 0.0)
		event.place_dungeon_monster(602, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		event.show_dungeon_status_bar(1, 0.16666667)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				at = 2
				helper_26f10()
				return vm.continue_with(function()
					event.attach_object_handle_to_map_part_2(0, "p01_battleship")
					event.set_object_handle_position(0, -2194.9, 487.8, -474.2)
					event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
					time = event.get_scene_time_of_day() or time
					event.set_event_saved_time_of_day(time)
					event.set_time_of_day_advancing(0)
					event.set_time_of_day(18.0)
					at = 3
					vm.wait(3)
					event.initialize_event()
					at = 4
					vm.wait(4)
					event.stop_music(0)
					at = 5
					wait_frames(4)
					event.load_music(190)
					event.play_music(0)
					event.load_map_sounds(3691)
					event.set_function_point_enabled("", "func0", 0)
					event.set_function_point_enabled("", "func2", 1)
					event.set_function_point_enabled("", "func3", 1)
					active_chr_no = event.get_playable_character() or active_chr_no
					if active_chr_no ~= 1 then
						event.switch_dungeon_main_character(1)
						event.set_playable_character(1)
					end
					event.set_character_change_unmasked(0, 0)
					event.set_character_change_unmasked(2, 0)
					event.set_save_control_bits(1, 1)
					event.set_character_position(0, -2195.0, 488.0, -515.0)
					event.set_character_rotation(0, 0.0, 0.0, 0.0)
					event.set_camera_look_at(-2195.0, 513.0, -475.0)
					event.set_camera_position(-2195.0, 518.0, -555.0)
					event.reset_follow_camera(0)
					event.initialize_sound_port(4)
					event.load_dungeon_monster(510, 1)
					event.load_dungeon_monster(513, 0)
					event.load_dungeon_monster(602, 0)
					event.place_dungeon_monster(510, -2195.0, 488.0, -435.0, 0.0, 3.14, 0.0)
					event.place_dungeon_monster(602, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					event.show_dungeon_status_bar(1, 0.16666667)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			if at <= 4 then
				wait_frames_skipping(4)
			end
			return 0
		end
		return nil
	end)
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	local keep_time: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.stop_music(0)
		keep_time = event.get_event_saved_time_of_day() or keep_time
		event.set_time_of_day(keep_time)
		at = 1
		helper_2b9e4()
		at = 2
		helper_33a7c()
		event.jump_to_map_3(-1, "d03b01", 503)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_33a7c()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "d03b01", 503)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local flag: s32 = 0
	helper_10aa8()
	flag = event.get_save_flag(64) or flag
	if flag == 0 then
		wait_frames(20)
		event.set_dungeon_pause_flags(3, 1)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "Proteggi Lin dal Fuoco maligno!")
		helper_75684dd8(0, -1, 8, 0, 0)
		event.set_save_flag(64, 1)
		event.set_dungeon_pause_flags(3, 0)
	end
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local block: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.fade_out_music(30)
	event.start_background_file_loads_3(
		"snd2/bgm/bg_060.sound.json",
		"textures/dungeon/image/gameover/gameover_1.json",
		"event/boss_btl_lose_1.txt"
	)
	event.show_dungeon_status_bar(0, 0.033333335)
	wait_frames(30)
	helper_479dc9e9()
	event.stop_music(0)
	event.load_music_pack(60)
	set_window_mode(0, 7)
	event.load_message_file(0, 5, "event/boss_btl_lose_1.txt")
	helper_0e75aa9e(3520430, -1, 10)
	wait_frames(10)
	event.load_message_file(0, -1)
	event.play_music(0)
	block = event.load_event_image_4(5, "textures/dungeon/image/gameover/gameover_1.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "gameover1", block)
	event.set_event_sprite_color(0, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
	event.set_event_sprite_size(0, 576, 128)
	event.set_event_sprite_position(0, -320, 208)
	event.set_event_sprite_draw_pass(0, 1)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, 288, 208, 0.0, 20)
	wait_frames(30)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "gameover1", block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
	event.set_event_sprite_size(1, 576, 64)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 1)
	event.attach_object_handle_to_sprite(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
	wait_frames(120)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(7)
		end
	end
	event.fade_out_music(30)
	event.fade_out_screen(30)
	wait_frames(30)
	event.stop_music(0)
	event.set_scene_exit_flag(1)
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 or active_chr_no == 3 then
			var1 = vm.float_bits(event.get_random_number(100)) or var1
			if vm.imod(var1, 2) == 0 then
				at = 1
				helper_47084b1b(0, 8530100)
			else
				at = 2
				helper_47084b1b(0, 8530110)
			end
		else
			at = 3
			helper_f0ee9a01(0)
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_80ad60c2(0, 8530110)
			end
			if at <= 2 then
				helper_5a05ed59(0)
			end
			return 0
		end
		return nil
	end)
end

--- Event 13560, which map data, a script or the engine runs by number.
function script.event_13560()
	local at: number = 0
	return vm.guard(function()
		event.stop_music(0)
		at = 1
		helper_2b9e4()
		at = 2
		helper_33a7c()
		event.jump_to_map_3(-1, "d03b01", 503)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_33a7c()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "d03b01", 503)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 23030, which map data, a script or the engine runs by number.
function script.event_23030()
	local argc: s32 = 0
	local active_chr_no: s32 = 0
	helper_108ec()
	event.initialize_event()
	vm.wait(1)
	event.attach_object_handle_to_map_part_2(0, "p06_d03b01")
	event.set_object_handle_visible(0, 1)
	event.set_time_of_day(17.5)
	event.set_time_of_day_advancing(0)
	event.set_character_max_hp(0, 240)
	event.set_character_max_hp(1, 96)
	event.set_character_defence(0, 94)
	event.set_character_defence(1, 28)
	argc = event.get_item_count(270) or argc
	if argc < 20 then
		event.add_inventory_item(270, vm.i32(20 - argc))
	end
	event.add_inventory_item(20)
	event.equip_character_item(0, 20)
	event.add_inventory_item(33)
	event.equip_character_item(0, 33)
	event.add_inventory_item(54)
	event.equip_character_item(1, 54)
	event.add_inventory_item(104)
	event.equip_character_item(1, 104)
	event.set_function_point_enabled("", "func0", 0)
	event.set_function_point_enabled("", "func2", 1)
	event.set_function_point_enabled("", "func3", 1)
	event.load_music(190)
	event.play_music(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no ~= 1 then
		event.switch_dungeon_main_character(1)
		event.set_playable_character(1)
	end
	event.set_character_position(0, -2195.0, 488.0, -515.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_camera_look_at(-2195.0, 513.0, -475.0)
	event.set_camera_position(-2195.0, 518.0, -555.0)
	event.reset_follow_camera(0)
	event.load_dungeon_monster(510, 1)
	event.load_dungeon_monster(513, 0)
	event.load_dungeon_monster(602, 0)
	event.place_dungeon_monster(510, -2195.0, 488.0, -435.0, 0.0, 3.14, 0.0)
	event.place_dungeon_monster(602, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.show_dungeon_status_bar(1, 0.16666667)
	event.set_character_change_unmasked(0, 0)
	event.set_character_change_unmasked(2, 0)
	event.set_save_control_bits(1, 1)
	event.fade_in_screen(30)
	event.finish_event()
end

return script
