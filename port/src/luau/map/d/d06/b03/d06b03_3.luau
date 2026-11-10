--!strict
-- map/d/d06/b03/d06b03_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_23cc77c6 = require("@lib/event/helper_23cc77c6")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_47084b1b = require("@lib/event/helper_47084b1b")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_6018b985 = require("@lib/event/helper_6018b985")
local helper_80ad60c2 = require("@lib/event/helper_80ad60c2")
local helper_d42be94f = require("@lib/event/helper_d42be94f")
local helper_f0ee9a01 = require("@lib/event/helper_f0ee9a01")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_19e04()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.switch_dungeon_main_character(0)
		active_chr_no = 0
	end
	if active_chr_no == 3 then
		event.switch_dungeon_main_character(1)
		active_chr_no = 1
	end
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.load_character(5, "chara/c02_base.gltf", "info", global1)
		event.load_equipment_model(5, 1, 1, "info", global1, 17)
		event.load_equipment_model(5, 1, 0, "info", global1, 18)
		event.load_equipment_model(5, 1, 4, "info", global1)
		event.load_equipment_model(5, 1, 3, "info", global1)
		event.load_equipment_model(5, 1, 2, "info", global1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", global1)
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
		event.load_equipment_model(5, 0, 1, "info", global0, 17)
		event.load_equipment_model(5, 0, 0, "info", global0, 18)
		event.load_equipment_model(5, 0, 4, "info", global0)
		event.load_equipment_model(5, 0, 3, "info", global0)
		event.load_equipment_model(5, 0, 2, "info", global0, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.attach_object_handle_to_character(0, global0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global0)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.attach_object_handle_to_character(1, global1)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global1)
	end
	event.attach_object_handle_to_map_part_2(6, "p06_d06b03-0")
	event.set_object_handle_visible(6, 0)
	event.set_character_active(1, 17)
	event.set_character_active(1, 18)
	event.load_message_file(0, 5, "event/e700/e732/e732_1.txt")
end

--- Helper function.
local function helper_22300000()
	local var0: s32 = 0
	local _ = var0 == 2
	var0 = 0
	local _ = var0 == 3
	var0 = 1
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_19958()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global0)
		event.set_character_active(0, global1)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global1)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global1)
		event.set_character_active(0, global0)
		event.delete_character_extension_packs(global0)
		event.delete_character_extension_packs(global1)
		event.delete_character(global0)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.set_object_handle_visible(6, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
end

--- Helper function.
local function helper_1ae20()
	local projection: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(732, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(53)
		event.play_music(0)
		event.load_map_sounds(7841)
		helper_19e04()
		projection = event.get_event_projection() or projection
		event.enable_drama_skip()
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, global0)
		event.set_character_active(1, global1)
		event.set_camera_sequence_position(281.98, 20.1, 298.37)
		event.set_camera_sequence_look_at(1436.08, 1324.63, 1446.43)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(0, 457.63, 0.0, 460.14)
		event.set_object_sequence_rotation(0, 0.0, 0.72, 0.0)
		event.set_object_sequence_position(1, 443.3, 0.0, 472.44)
		event.set_object_sequence_rotation(1, 0.0, 0.72, 0.0)
		event.fade_in_screen(30)
		at = 2
		wait_frames(15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(281.98, 20.1, 298.37, 1436.08, 1324.63, 1446.43)
		event.add_camera_sequence_path_point(281.98, 20.1, 298.37, 1436.08, 215.39, 1446.43)
		event.start_camera_sequence_path()
		at = 3
		wait_camera()
		at = 4
		wait_frames(30)
		event.set_camera_sequence_position(520.35, 27.62, 447.72)
		event.set_camera_sequence_look_at(443.3, 23.28, 472.44)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 5
		helper_1584c528(7320210, -1)
		event.reset_mouth_texture_animations()
		at = 6
		wait_frames(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 7
		helper_1584c528(7320215, -1)
		event.reset_mouth_texture_animations()
		at = 8
		wait_frames(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 9
		helper_1584c528(7320220, -1)
		event.reset_mouth_texture_animations()
		at = 10
		wait_frames(30)
		event.set_camera_sequence_position(422.7, -0.4, 438.35)
		event.set_camera_sequence_look_at(1436.08, 1232.78, 1446.43)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 11
		helper_1584c528(7320230, -1)
		event.reset_mouth_texture_animations()
		at = 12
		wait_frames(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 13
		helper_1584c528(7320240, -1)
		event.reset_mouth_texture_animations()
		at = 14
		wait_frames(30)
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 15
		helper_1584c528(7320250, -1)
		event.reset_mouth_texture_animations()
		at = 16
		wait_objects(0)
		at = 17
		wait_frames(30)
		event.set_event_projection(projection)
		event.set_camera_sequence_position(520.35, 27.62, 447.72)
		event.set_camera_sequence_look_at(443.3, 23.28, 472.44)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 18
		helper_1584c528(7320255, -1)
		event.reset_mouth_texture_animations()
		at = 19
		wait_frames(15)
		event.set_object_sequence_motion(1, "上から左", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "詩人ね", 6)
		event.queue_object_sequence_next_motion(1, "詩人ねL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 20
		helper_1584c528(7320260, -1)
		event.reset_mouth_texture_animations()
		at = 21
		wait_objects(0)
		at = 22
		wait_objects(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～下向き")
		event.set_object_sequence_motion(0, "そうかな", 6)
		event.queue_object_sequence_next_motion(0, "そうかなL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 23
		helper_1584c528(7320270, -1)
		event.reset_mouth_texture_animations()
		at = 24
		wait_objects(0)
		at = 25
		wait_frames(30)
		event.set_event_projection(projection)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_camera_sequence_position(281.98, 20.1, 298.37)
		event.set_camera_sequence_look_at(1436.08, 215.39, 1446.43)
		at = 26
		helper_1584c528(7320280, -1)
		at = 27
		wait_frames(30)
		at = 28
		helper_1584c528(7320285, -1)
		at = 29
		wait_frames(30)
		at = 30
		helper_1584c528(7320290, -1)
		at = 31
		wait_frames(30)
		at = 32
		helper_1584c528(7320295, -1)
		event.move_camera_sequence_eased(281.98, 20.1, 298.37, 1436.08, 1963.82, 1446.43, 300, 0, 1.0)
		at = 33
		wait_frames(30)
		at = 34
		helper_1584c528(7320300, -1)
		at = 35
		wait_frames(30)
		at = 36
		helper_1584c528(7320310, -1)
		at = 37
		wait_camera()
		at = 38
		helper_1584c528(7320320, -1)
		at = 39
		wait_frames(30)
		at = 40
		helper_1584c528(7320330, -1)
		at = 41
		wait_frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_camera_sequence_position(539.13, 94.76, 524.34)
		event.set_camera_sequence_look_at(457.63, 10.5, 460.14)
		event.move_camera_sequence_eased(484.6, 41.24, 479.15, 471.35, 30.37, 469.8, 300, 2, 1.0)
		event.start_crossfade(30)
		at = 42
		helper_1584c528(7320340, -1)
		at = 43
		wait_frames(30)
		at = 44
		helper_1584c528(7320350, -1)
		at = 45
		wait_frames(30)
		at = 46
		helper_1584c528(7320360, -1)
		at = 47
		wait_camera()
		at = 48
		wait_frames(30)
		event.set_object_sequence_motion(0, "帽子取る", 6)
		event.queue_object_sequence_next_motion(0, "帽子取るL", 4)
		at = 49
		helper_1584c528(7320370, -1)
		at = 50
		wait_objects(0)
		event.set_object_sequence_motion(0, "ぶるぶる", 6)
		event.queue_object_sequence_next_motion(0, "帽子取るL", 4)
		at = 51
		helper_1584c528(7320380, -1)
		at = 52
		wait_objects(0)
		event.set_event_projection(182.9)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(240)
		event.add_camera_sequence_path_point(422.7, 30.65, 438.35, 1436.08, 349.8, 1446.43)
		event.add_camera_sequence_path_point(353.73, 30.65, 369.74, 1436.08, 349.8, 1446.43)
		event.start_camera_sequence_path()
		at = 53
		wait_frames(180)
		event.fade_out_music(60)
		event.fade_out_screen(60)
		at = 54
		wait_frames(60)
		event.stop_music(0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22300000()
			wait_frames_skipping(15)
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			wait_frames_skipping(30)
		end
		if at <= 4 then
			helper_52aadc70(7320210, -1)
		end
		if at <= 5 then
			wait_frames_skipping(30)
		end
		if at <= 6 then
			helper_52aadc70(7320215, -1)
		end
		if at <= 7 then
			wait_frames_skipping(30)
		end
		if at <= 8 then
			helper_52aadc70(7320220, -1)
		end
		if at <= 9 then
			wait_frames_skipping(30)
		end
		if at <= 10 then
			helper_52aadc70(7320230, -1)
		end
		if at <= 11 then
			wait_frames_skipping(30)
		end
		if at <= 12 then
			helper_52aadc70(7320240, -1)
		end
		if at <= 13 then
			wait_frames_skipping(30)
		end
		if at <= 14 then
			helper_52aadc70(7320250, -1)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			wait_frames_skipping(30)
		end
		if at <= 17 then
			helper_52aadc70(7320255, -1)
		end
		if at <= 18 then
			wait_frames_skipping(15)
		end
		if at <= 19 then
			helper_52aadc70(7320260, -1)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			helper_238b5abc(1)
		end
		if at <= 22 then
			helper_52aadc70(7320270, -1)
		end
		if at <= 23 then
			helper_238b5abc(0)
		end
		if at <= 24 then
			wait_frames_skipping(30)
		end
		if at <= 25 then
			helper_52aadc70(7320280, -1)
		end
		if at <= 26 then
			wait_frames_skipping(30)
		end
		if at <= 27 then
			helper_52aadc70(7320285, -1)
		end
		if at <= 28 then
			wait_frames_skipping(30)
		end
		if at <= 29 then
			helper_52aadc70(7320290, -1)
		end
		if at <= 30 then
			wait_frames_skipping(30)
		end
		if at <= 31 then
			helper_52aadc70(7320295, -1)
		end
		if at <= 32 then
			wait_frames_skipping(30)
		end
		if at <= 33 then
			helper_52aadc70(7320300, -1)
		end
		if at <= 34 then
			wait_frames_skipping(30)
		end
		if at <= 35 then
			helper_52aadc70(7320310, -1)
		end
		if at <= 36 then
			helper_344d6cd8()
		end
		if at <= 37 then
			helper_52aadc70(7320320, -1)
		end
		if at <= 38 then
			wait_frames_skipping(30)
		end
		if at <= 39 then
			helper_52aadc70(7320330, -1)
		end
		if at <= 40 then
			wait_frames_skipping(30)
		end
		if at <= 41 then
			helper_52aadc70(7320340, -1)
		end
		if at <= 42 then
			wait_frames_skipping(30)
		end
		if at <= 43 then
			helper_52aadc70(7320350, -1)
		end
		if at <= 44 then
			wait_frames_skipping(30)
		end
		if at <= 45 then
			helper_52aadc70(7320360, -1)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			wait_frames_skipping(30)
		end
		if at <= 48 then
			helper_52aadc70(7320370, -1)
		end
		if at <= 49 then
			helper_238b5abc(0)
		end
		if at <= 50 then
			helper_52aadc70(7320380, -1)
		end
		if at <= 51 then
			helper_238b5abc(0)
		end
		if at <= 52 then
			wait_frames_skipping(180)
		end
		if at <= 53 then
			wait_frames_skipping(60)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(projection)
	at = 55
	helper_19958()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local active_chr_no: s32 = 0
	event.initialize_event()
	flag = event.get_save_flag(728) or flag
	if flag == 1 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		event.show_dungeon_status_bar(0, 1.0)
		helper_d42be94f()
		event.show_dungeon_status_bar(1, 1.0)
		event.load_dungeon_monster(621, 1)
		event.load_dungeon_monster(622, 0)
		event.place_dungeon_monster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		event.place_dungeon_monster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
		event.control_stopwatch(3, 350, 370, 1)
		event.control_stopwatch(2, 18000)
		event.control_stopwatch_1(0)
	end
	event.set_character_position(0, 0.0, 0.0, -400.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -400.0)
	event.set_camera_position(0.0, 40.0, -520.0)
	event.reset_follow_camera(0)
	vm.wait(2)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_23cc77c6

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local active_chr_no_2: s32 = 0
	print(">>>>>>>>>>>>>>>>>RUN 500\n")
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_screen(20)
	wait_frames(20)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_status(0, 8, 1)
	end
	if active_chr_no == 1 then
		event.set_character_status(1, 8, 1)
	end
	event.clear_event_battle_monsters(-1)
	event.set_dungeon_floor_info(5, 27, 5, 2)
	active_chr_no_2 = event.get_playable_character() or active_chr_no_2
	if active_chr_no_2 == 2 then
		event.switch_dungeon_main_character(0)
	end
	if active_chr_no_2 == 3 then
		event.switch_dungeon_main_character(1)
	end
	event.go_to_georama_edit(180, 500)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_1ae20()
	event.set_save_data_value(0, 10)
	vm.wait(2)
	event.jump_to_map_3(-1, "s66", 520)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	event.show_dungeon_status_bar(0, 1.0)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	helper_6018b985()
	event.skip_next_music_load()
	vm.wait(2)
	event.load_dungeon_map("d06b02")
	event.load_event_script("d06b02/d06b02.stb", 100)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(728) or flag
		flag_2 = event.get_save_flag(732) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = vm.float_bits(event.get_random_number(100)) or var2
			if var2 < 50 then
				at = 1
				helper_47084b1b(0, 8570060)
			else
				at = 2
				helper_47084b1b(0, 8570070)
			end
			return
		end
		at = 3
		helper_f0ee9a01(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_80ad60c2(0, 8570070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 1201, which map data, a script or the engine runs by number.
function script.event_1201()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local boss_map: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(15, 1)
	var0 = 0
	event.initialize_event()
	var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_052.sound.json") or var1
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_dungeon_pause_flags(16384, 1)
	event.play_sound_effect(var1, 0)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(0, 128, 128, 128, 128, 90)
	wait_frames(90)
	event.save_music_status(-1)
	var2 = event.get_event_sound_bank(4) or var2
	argc = event.get_sound_effect_status(var2, 0) or argc
	battle_bgm_vol = event.get_battle_music_volume() or battle_bgm_vol
	event.stop_sound_effect(var2, 0)
	event.stop_music(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	event.start_background_file_loads_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	wait_frames(30)
	helper_479dc9e9()
	event.load_music_pack(60)
	event.play_music(0)
	wait_frames(30)
	event.set_dungeon_pause_flags(1, 1)
	event.reset_dungeon_collision_primitives()
	block = event.load_event_image_4(5, "textures/dungeon/image/gameover.json", 0) or block
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "gameover1", block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 576, 128)
	event.set_event_sprite_size(1, 576, 128)
	event.set_event_sprite_position(1, -320, 208)
	event.set_event_sprite_draw_pass(1, 1)
	event.attach_object_handle_to_sprite(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.move_object_sequence(1, 288, 208, 0.0, 20)
	wait_frames(30)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "gameover1", block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 128, 576, 64)
	event.set_event_sprite_size(2, 576, 64)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 1)
	event.attach_object_handle_to_sprite(2, 2)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_color(2, 128, 128, 128, 128, 120)
	wait_frames(120)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(7)
		end
	end
	debug_flag = event.get_debug_flag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.run_dungeon_debug_command(0)
		event.reset_action_character_motion(0, 4)
	else
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait_frames(30)
		if active_chr_no == 2 then
			event.clear_effect_manager()
		end
		event.stop_music(0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(0)
		if var0 == 1 then
			event.add_hp_by_rate(1.0, 0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			event.run_dungeon_event(-1)
			event.clear_event_battle_monsters(-1)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return 1
		else
			event.set_scene_exit_flag(1)
			event.finish_event()
			return 0
		end
	end
	event.stop_music(0)
	wait_frames(4)
	load_no = event.get_saved_music_number() or load_no
	event.load_music(load_no)
	event.restore_music_status(-1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(0)
	boss_map = event.is_dungeon_boss_floor() or boss_map
	if boss_map ~= 1 then
		if argc == 1 then
			event.play_sound_effect(var2, 0)
			event.set_sound_effect_volume(var2, 0, battle_bgm_vol)
		end
	end
	event.set_camera_control_enabled(1)
	event.show_dungeon_status_bar(1, 1.0)
	if debug_flag ~= 1 then
		event.fade_in_screen(30)
	end
	event.set_dungeon_pause_flags(16385, 0)
	event.finish_event()
	return 0
end

--- Event 27070, which map data, a script or the engine runs by number.
script.event_27070 = helper_23cc77c6

return script
