--!strict
--- Event script for the d03b02 battleship boss fight, covering the cannon barrage, Guiltoni confrontation, duel, barrier and post-battle scenes.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local saved_max_x: f32 = 0
local saved_max_y: f32 = 0
local saved_max_z: f32 = 0
local saved_max_rotation: f32 = 0
local saved_monica_x: f32 = 0
local saved_monica_y: f32 = 0
local saved_monica_z: f32 = 0
local saved_monica_rotation: f32 = 0
local cannon_barrage_max_slot: s32 = 0
local cannon_barrage_monica_slot: s32 = 0
local confrontation_max_slot: s32 = 0
local confrontation_monica_slot: s32 = 0
local duel_max_slot: s32 = 0
local duel_monica_slot: s32 = 0
local shield_max_slot: s32 = 0
local shield_monica_slot: s32 = 0
local mourning_max_slot: s32 = 0
local mourning_monica_slot: s32 = 0
local guiltoni_intro_max_slot: s32 = 0
local guiltoni_intro_monica_slot: s32 = 0

--- Resets the map state by hiding the e348 trigger once its save flag is set and zeroing the saved character positions.
local function initialize_map()
	local flag: s32 = 0
	flag = event.get_save_flag(348) or flag
	if flag == 1 then
		event.set_function_point_enabled("", "e348", 0)
	end
	do
		local out1, out2, out3 = event.zero_vector()
		saved_max_x = out1 or saved_max_x
		saved_max_y = out2 or saved_max_y
		saved_max_z = out3 or saved_max_z
	end
	saved_max_z = 30.0
	do
		local out1, out2, out3 = event.zero_vector()
		saved_monica_x = out1 or saved_monica_x
		saved_monica_y = out2 or saved_monica_y
		saved_monica_z = out3 or saved_monica_z
	end
end

--- Loads the characters, motions, map parts and messages for the Guiltoni and Jamming introduction scene.
local function load_guiltoni_intro_assets()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		guiltoni_intro_max_slot = 0
		guiltoni_intro_monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", guiltoni_intro_max_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", guiltoni_intro_max_slot)
		event.attach_object_handle_to_character(0, guiltoni_intro_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, guiltoni_intro_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", guiltoni_intro_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", guiltoni_intro_monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", guiltoni_intro_monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", guiltoni_intro_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", guiltoni_intro_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", guiltoni_intro_monica_slot, 36)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", guiltoni_intro_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", guiltoni_intro_monica_slot)
		event.attach_object_handle_to_character(1, guiltoni_intro_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, guiltoni_intro_monica_slot)
		event.set_character_active(0, 36)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if playable_character == 1 then
		guiltoni_intro_max_slot = 32
		guiltoni_intro_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", guiltoni_intro_max_slot)
		event.load_equipment_model(5, 0, 1, "info", guiltoni_intro_max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", guiltoni_intro_max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", guiltoni_intro_max_slot)
		event.load_equipment_model(5, 0, 3, "info", guiltoni_intro_max_slot)
		event.load_equipment_model(5, 0, 2, "info", guiltoni_intro_max_slot, 36)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", guiltoni_intro_max_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", guiltoni_intro_max_slot)
		event.attach_object_handle_to_character(0, guiltoni_intro_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, guiltoni_intro_max_slot)
		event.set_character_active(0, 36)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", guiltoni_intro_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", guiltoni_intro_monica_slot)
		event.attach_object_handle_to_character(1, guiltoni_intro_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, guiltoni_intro_monica_slot)
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

--- Assigns the Max and Monica slots of the introduction scene as the loader leaves them when Monica is playable.
local function assign_guiltoni_intro_slots()
	guiltoni_intro_max_slot = 0
	guiltoni_intro_monica_slot = 32
	guiltoni_intro_max_slot = 32
	guiltoni_intro_monica_slot = 0
end

--- Unloads the introduction scene characters, restores the map objects and returns to the d03b01 map at event 503.
local function end_guiltoni_intro()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, guiltoni_intro_max_slot)
		event.set_character_active(0, guiltoni_intro_monica_slot)
		event.delete_character_extension_packs(guiltoni_intro_max_slot)
		event.delete_character_extension_packs(guiltoni_intro_monica_slot)
		event.delete_character(guiltoni_intro_monica_slot)
		event.delete_character(36)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, guiltoni_intro_monica_slot)
		event.set_character_active(0, guiltoni_intro_max_slot)
		event.delete_character_extension_packs(guiltoni_intro_max_slot)
		event.delete_character_extension_packs(guiltoni_intro_monica_slot)
		event.delete_character(guiltoni_intro_max_slot)
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

--- Plays the scene of Guiltoni and Jamming aboard the battleship, then returns to the d03b01 map.
local function cutscene_guiltoni_and_jamming_aboard_ship()
	local saved_projection: f32 = 0
	local saved_time_of_day: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		checkpoint = 1
		wait.frames(4)
		event.load_music(152)
		load_guiltoni_intro_assets()
		saved_projection = event.get_event_projection() or saved_projection
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
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
		event.set_character_active(0, guiltoni_intro_max_slot)
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
		event.set_character_active(0, guiltoni_intro_monica_slot)
		event.set_event_projection(saved_projection)
		event.rotate_object_sequence(8, 0.0, 0.0, 0.06, 90)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_character_active(1, 40)
		checkpoint = 2
		wait.frames(90)
		event.set_camera_sequence_look_at(-2045.72, -1258.82, 1215.53)
		event.set_camera_sequence_angle_height_distance(-1.19, -17.66, 32.97)
		event.set_object_sequence_position(6, -2040.96, -1287.62, 1214.97)
		event.set_object_sequence_rotation(6, 0.0, 2.0, 0.0)
		checkpoint = 3
		wait.frames(90)
		event.move_camera_sequence_angle_height_distance(-0.71, -17.66, 32.97, 300)
		checkpoint = 4
		wait.frames(240)
		event.set_object_sequence_motion(6, "ふりかえり", 6)
		checkpoint = 5
		wait.frames(3000)
		event.fade_out_screen(30)
		checkpoint = 6
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			assign_guiltoni_intro_slots()
			wait.frames_skipping(90)
		end
		if checkpoint <= 2 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 3 then
			wait.frames_skipping(240)
		end
		if checkpoint <= 4 then
			wait.frames_skipping(3000)
		end
		if checkpoint <= 5 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(saved_projection)
	event.set_time_of_day(saved_time_of_day)
	checkpoint = 7
	vm.wait(7)
	end_guiltoni_intro()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads the characters, motions, map parts and messages for the battleship cannon barrage scene.
local function load_cannon_barrage_assets()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		cannon_barrage_max_slot = 0
		cannon_barrage_monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", cannon_barrage_max_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", cannon_barrage_max_slot)
		event.attach_object_handle_to_character(0, cannon_barrage_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, cannon_barrage_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", cannon_barrage_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", cannon_barrage_monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", cannon_barrage_monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", cannon_barrage_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", cannon_barrage_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", cannon_barrage_monica_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", cannon_barrage_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica.chr", "info", cannon_barrage_monica_slot)
		event.attach_object_handle_to_character(1, cannon_barrage_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, cannon_barrage_monica_slot)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if playable_character == 1 then
		cannon_barrage_max_slot = 8
		cannon_barrage_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", cannon_barrage_max_slot)
		event.load_equipment_model(5, 0, 1, "info", cannon_barrage_max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", cannon_barrage_max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", cannon_barrage_max_slot)
		event.load_equipment_model(5, 0, 3, "info", cannon_barrage_max_slot)
		event.load_equipment_model(5, 0, 2, "info", cannon_barrage_max_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", cannon_barrage_max_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", cannon_barrage_max_slot)
		event.attach_object_handle_to_character(0, cannon_barrage_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, cannon_barrage_max_slot)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", cannon_barrage_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica.chr", "info", cannon_barrage_monica_slot)
		event.attach_object_handle_to_character(1, cannon_barrage_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, cannon_barrage_monica_slot)
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

--- Assigns the Max and Monica slots of the post-battle scene as the loader leaves them when Monica is playable.
local function assign_mourning_slots()
	cannon_barrage_max_slot = 0
	cannon_barrage_monica_slot = 8
	cannon_barrage_max_slot = 8
	cannon_barrage_monica_slot = 0
end

--- Unloads the cannon barrage scene characters, restores the map objects and continues in the d03b01 dungeon at event 504.
local function end_cannon_barrage()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, cannon_barrage_max_slot)
		event.set_character_active(0, cannon_barrage_monica_slot)
		event.delete_character_extension_packs(cannon_barrage_max_slot)
		event.delete_character_extension_packs(cannon_barrage_monica_slot)
		event.delete_character(cannon_barrage_monica_slot)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, cannon_barrage_monica_slot)
		event.set_character_active(0, cannon_barrage_max_slot)
		event.delete_character_extension_packs(cannon_barrage_max_slot)
		event.delete_character_extension_packs(cannon_barrage_monica_slot)
		event.delete_character(cannon_barrage_max_slot)
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

--- Plays the scene in which the battleship cannons fire on the party and knock down the characters at the railing.
local function cutscene_cannon_barrage()
	local sound_bank: s32 = 0
	local saved_projection: f32 = 0
	local saved_time_of_day: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		checkpoint = 1
		vm.wait(1)
		checkpoint = 2
		vm.wait(2)
		checkpoint = 3
		vm.wait(3)
		checkpoint = 4
		vm.wait(4)
		event.load_music(53)
		event.load_map_sounds(3833)
		sound_bank = event.load_sound_effect_file_2(3833) or sound_bank
		event.play_music(0)
		load_cannon_barrage_assets()
		saved_projection = event.get_event_projection() or saved_projection
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
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
		event.set_character_active(0, cannon_barrage_max_slot)
		event.set_character_active(0, cannon_barrage_monica_slot)
		event.set_character_active(1, 9)
		event.set_character_active(1, 11)
		event.move_camera_sequence(-375.99, -501.71, -2993.11, 194.93, 66.85, 1045.42, 90)
		event.set_object_sequence_motion(4, "手すり立ち", 4)
		event.set_object_sequence_motion(5, "手すり上見立ち", 4)
		event.set_object_sequence_position(5, -277.63, 0.0, 112.11)
		event.set_object_sequence_rotation(5, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(4, -284.8, 0.0, 93.56)
		event.set_object_sequence_rotation(4, 0.0, -1.12, 0.0)
		checkpoint = 5
		wait.frames(1)
		event.start_crossfade(30)
		event.set_object_sequence_color(15, 128, 128, 128, 0, 0)
		checkpoint = 6
		camera.wait_until_done()
		event.set_camera_sequence_position(559.2, 635.48, -195.62)
		event.set_camera_sequence_look_at(-204.68, 598.78, 74.08)
		event.start_crossfade(30)
		event.move_camera_sequence_eased(559.2, 143.2, -195.62, -204.68, 106.5, 74.08, 200, 2, 1.0)
		checkpoint = 7
		camera.wait_until_done()
		event.set_object_handle_shadow_enabled(5, 0)
		event.set_object_handle_shadow_enabled(4, 0)
		event.set_camera_sequence_position(-367.55, 25.75, 136.21)
		event.set_camera_sequence_look_at(-204.68, 29.95, 74.08)
		event.start_crossfade(30)
		event.set_mouth_texture_animations(5, "わらい口パク")
		checkpoint = 8
		message.show_voiced(3520030)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "左を見る", 6)
		event.queue_object_sequence_next_motion(4, "左を見るL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_camera_sequence_position(-291.37, 30.93, 159.38)
		event.set_camera_sequence_look_at(-284.82, 29.95, 71.35)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 9
		message.show_voiced(3520040)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(5, "わらい口パク")
		checkpoint = 10
		message.show_voiced(3520050)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "右を見る", 6)
		event.queue_object_sequence_next_motion(5, "右を見るL", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_mouth_texture_animations(4, "わらい口パク")
		checkpoint = 11
		message.show_voiced(3520060)
		event.reset_mouth_texture_animations()
		checkpoint = 12
		wait.frames(30)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "大わらい顔")
		event.set_object_sequence_texture_animation(5, 1, "わらい目パチ")
		event.set_camera_sequence_position(-316.38, 25.02, 113.48)
		event.set_camera_sequence_look_at(-254.42, 29.95, 91.23)
		event.set_mouth_texture_animations(5, "わらい口パク")
		checkpoint = 13
		message.show_voiced(3520070)
		event.reset_mouth_texture_animations()
		checkpoint = 14
		wait.frames(30)
		event.set_object_sequence_motion(4, "左を見る戻り", 6)
		event.queue_object_sequence_next_motion(4, "手すり立ち", 4)
		event.move_camera_sequence_eased(-339.97, 25.02, 121.96, -254.42, 29.95, 91.23, 30, 2, 1.0)
		checkpoint = 15
		wait.frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "無表情")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 16
		message.show_voiced(3520080)
		event.reset_mouth_texture_animations()
		event.fade_out_music(30)
		checkpoint = 17
		wait.frames(30)
		event.stop_music(0)
		event.set_object_sequence_motion(5, "右を見る戻り", 6)
		event.queue_object_sequence_next_motion(5, "手すり立ち", 4)
		checkpoint = 18
		wait.frames(30)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "おこり顔")
		event.set_object_sequence_texture_animation(5, 1, "おこり目パチ")
		checkpoint = 19
		wait.frames(60)
		event.set_object_handle_shadow_enabled(5, 1)
		event.set_object_handle_shadow_enabled(4, 1)
		event.load_music(32)
		event.play_music(0)
		event.set_camera_sequence_position(-175.49, 25.02, 56.65)
		event.set_camera_sequence_look_at(-360.31, 29.95, 136.99)
		checkpoint = 20
		wait.frames(1)
		event.set_object_handle_scale(14, 2.0, 2.0, 2.0)
		event.set_character_active(1, 13)
		event.set_character_motion(13, "消える", 2, -1, 1)
		event.set_motion_blur(80)
		event.set_object_handle_visible(8, 1)
		event.start_crossfade(40)
		event.play_sound_effect(sound_bank, 4)
		event.move_object_sequence(8, -3191.25, 25.75, 1000.17, 10)
		event.move_object_sequence(14, -3191.25, 25.75, 2000.17, 10)
		checkpoint = 21
		object.wait_until_done(8)
		event.move_object_sequence_eased(8, -3191.25, 25.75, 1213.17, 15, 2, 1.0)
		event.move_object_sequence_eased(14, -3191.25, 25.75, 2213.17, 15, 2, 1.0)
		event.set_character_active(1, 19)
		event.set_character_active(1, 20)
		checkpoint = 22
		wait.frames(60)
		event.play_sound_effect(sound_bank, 5)
		checkpoint = 23
		wait.frames(60)
		event.set_motion_blur(0)
		event.set_object_sequence_position(8, -3191.25, 25.75, 1213.17)
		event.set_camera_sequence_position(2029.74, 25.02, 5512.95)
		event.set_camera_sequence_look_at(-250.33, 29.95, 2458.27)
		checkpoint = 24
		wait.frames(120)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "無表情")
		event.set_object_sequence_texture_animation(5, 1, "通常目パチ")
		event.set_object_sequence_motion(5, "身を乗りだす", 6)
		event.queue_object_sequence_next_motion(5, "身を乗りだすL", 4)
		event.set_camera_sequence_position(-279.45, 29.47, 165.03)
		event.set_camera_sequence_look_at(-304.59, 29.95, 74.61)
		event.play_sound_effect(sound_bank, 6)
		event.set_mouth_texture_animations(5, "通常口パク")
		checkpoint = 25
		message.show_voiced(3520090)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(4, "身を乗りだす", 6)
		event.queue_object_sequence_next_motion(4, "身を乗りだすL", 4)
		checkpoint = 26
		wait.frames(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(-322.93, 29.47, 119.9, -410.56, 29.95, 157.34)
		event.add_camera_sequence_path_point(-1822.73, 29.47, 760.68, -1910.36, 29.95, 798.12)
		event.start_camera_sequence_path()
		checkpoint = 27
		camera.wait_until_done()
		event.set_camera_sequence_position(-2644.48, 43.74, 1174.79)
		event.set_camera_sequence_look_at(-2727.12, 58.9, 1167.6)
		event.start_crossfade(30)
		checkpoint = 28
		wait.frames(120)
		event.play_sound_effect(sound_bank, 8)
		event.set_camera_sequence_position(-2700.02, 51.13, 1176.52)
		event.set_camera_sequence_look_at(-2753.54, 58.9, 1178.03)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 29
		message.show_voiced(3520100)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(7, "うなづき", 6)
		event.queue_object_sequence_next_motion(7, "立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		checkpoint = 30
		message.show_voiced(3520110)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 31
		message.show_voiced(3520120)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_position(6, -2777.54, 25.75, 1176.5)
		event.set_object_sequence_rotation(6, 0.0, 2.4, 0.0)
		event.set_event_projection(584.9)
		event.set_camera_sequence_position(-2817.33, 55.98, 1202.06)
		event.set_camera_sequence_look_at(-2734.28, 58.9, 1166.34)
		event.start_crossfade(30)
		event.play_sound_effect(sound_bank, 9)
		event.rotate_object_sequence(6, 0.0, -1.0, 0.0, 30)
		event.set_object_sequence_motion(6, "振り返り（ＰＧ）左", 6)
		event.queue_object_sequence_next_motion(6, "振り返り（ＰＧ）左Ｌ", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 32
		message.show_voiced(3520130)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(7, "右見る", 6)
		event.queue_object_sequence_next_motion(7, "右見るＬ", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		checkpoint = 33
		message.show_voiced(3520140)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(6, "そのまま左向き", 6)
		event.queue_object_sequence_next_motion(6, "そのまま左向きＬ", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 34
		message.show_voiced(3520150)
		event.reset_mouth_texture_animations()
		checkpoint = 35
		object.wait_until_done(6)
		event.play_sound_effect(sound_bank, 10)
		event.set_object_sequence_motion(7, "右からはっ", 6)
		event.queue_object_sequence_next_motion(7, "戻り", 6)
		event.queue_object_sequence_next_motion(7, "立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		checkpoint = 36
		message.show_voiced(3520160)
		event.reset_mouth_texture_animations()
		checkpoint = 37
		object.wait_until_done(7)
		event.set_object_sequence_motion(6, "戻り", 6)
		checkpoint = 38
		wait.frames(10)
		event.stop_sound_effect(sound_bank, 8)
		event.set_event_projection(saved_projection)
		event.set_object_sequence_rotation(10, 0.0, 1.92, 0.0)
		event.set_character_active(1, 15)
		event.set_object_handle_visible(11, 0)
		event.set_object_sequence_position(10, -2458.92, 167.76, 852.48)
		event.set_camera_sequence_position(-1958.78, 43.74, 1048.53)
		event.set_camera_sequence_look_at(-2036.51, 58.9, 1019.15)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(10, "横から縦移動", 6)
		event.queue_object_sequence_next_motion(10, "狙う", 6)
		event.queue_object_sequence_next_motion(10, "狙い立ち", 6)
		checkpoint = 39
		wait.frames(120)
		event.play_sound_effect(sound_bank, 12)
		event.set_event_projection(222.0)
		event.set_camera_sequence_position(-2502.08, 289.28, 872.69)
		event.set_camera_sequence_look_at(-2429.52, 237.57, 840.94)
		checkpoint = 40
		object.wait_until_done(10)
		event.stop_sound_effect(sound_bank, 12)
		checkpoint = 41
		wait.frames(30)
		event.set_event_projection(saved_projection)
		event.set_camera_sequence_position(-1862.68, 19.26, 1357.68)
		event.set_camera_sequence_look_at(-2351.83, 177.35, 866.18)
		event.set_character_position(21, -2279.73, 181.5, 788.22)
		event.set_character_rotation(21, 0.0, 1.9, 0.0)
		event.set_character_position(22, -2279.73, 181.5, 788.22)
		event.set_character_rotation(22, 0.0, 1.9, 0.0)
		event.set_character_active(1, 21)
		event.play_sound_effect(sound_bank, 13)
		event.set_character_motion(21, "発射", 6, -1, 1)
		event.set_object_sequence_motion(10, "発射", 6)
		event.queue_object_sequence_next_motion(10, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		checkpoint = 42
		wait.frames(5)
		event.set_character_active(1, 22)
		event.move_object_sequence(11, -1846.06, 191.5, 633.95, 10)
		checkpoint = 43
		wait.frames(60)
		event.set_character_active(0, 22)
		event.play_sound_effect(sound_bank, 13)
		event.set_character_motion(21, "発射", 6, -1, 1)
		event.set_object_sequence_motion(10, "発射", 6)
		event.queue_object_sequence_next_motion(10, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		checkpoint = 44
		wait.frames(5)
		event.set_character_active(1, 22)
		event.set_character_position(22, -2279.73, 181.5, 788.22)
		event.set_character_rotation(22, 0.0, 1.9, 0.0)
		event.move_object_sequence(11, -1846.06, 191.5, 633.95, 10)
		checkpoint = 45
		wait.frames(60)
		event.set_character_active(0, 22)
		event.play_sound_effect(sound_bank, 13)
		event.set_character_motion(21, "発射", 2, -1, 1)
		event.set_object_sequence_motion(10, "発射", 6)
		event.queue_object_sequence_next_motion(10, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		checkpoint = 46
		wait.frames(5)
		event.set_character_active(1, 22)
		event.set_character_position(22, -2279.73, 181.5, 788.22)
		event.set_character_rotation(22, 0.0, 1.9, 0.0)
		event.move_object_sequence(11, -1846.06, 191.5, 633.95, 10)
		checkpoint = 47
		wait.frames(60)
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
		event.play_sound_effect(sound_bank, 14)
		event.shake_camera_sequence(0.0, 1.6, 0.0, 60)
		checkpoint = 48
		wait.frames(60)
		event.set_character_active(0, 23)
		event.set_camera_sequence_position(228.78, 144.09, 1023.49)
		event.set_camera_sequence_look_at(-311.5, -61.26, 184.25)
		event.shake_camera_sequence(0.0, 1.6, 0.0, 120)
		event.set_character_active(1, 16)
		event.set_character_motion(16, "ヒット", 6, -1, 1)
		event.play_sound_effect(sound_bank, 14)
		checkpoint = 49
		wait.frames(60)
		event.set_character_active(1, 23)
		event.set_character_motion(23, "ヒット", 6, -1, 1)
		event.play_sound_effect(sound_bank, 14)
		checkpoint = 50
		wait.frames(60)
		event.fade_out_screen(30)
		checkpoint = 51
		wait.frames(30)
		checkpoint = 52
		wait.frames(15)
		event.set_function_point_enabled("", "func2", 1)
		event.set_function_point_enabled("", "func3", 1)
		event.set_function_point_enabled("", "func0", 0)
		event.set_object_handle_visible(9, 1)
		event.play_sound_effect(sound_bank, 15)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 90)
		event.set_camera_sequence_position(26.69, 78.26, -14.0)
		event.set_camera_sequence_look_at(-133.35, 46.81, 45.49)
		event.fade_in_screen(30)
		checkpoint = 53
		wait.frames(120)
		event.set_object_sequence_motion(5, "身を起こす", 6)
		event.set_object_sequence_motion(4, "身を起こす", 6)
		event.play_sound_effect(sound_bank, 16)
		event.set_camera_sequence_position(-140.11, 17.78, 75.17)
		event.set_camera_sequence_look_at(-196.15, 7.54, 67.76)
		checkpoint = 54
		wait.frames(60)
		event.play_sound_effect(sound_bank, 17)
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
		checkpoint = 55
		wait.frames(120)
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
		checkpoint = 56
		camera.wait_until_done()
		event.stop_music(0)
		event.stop_sound_effect(sound_bank, 5)
	end, function(received: { any }): boolean
		if checkpoint <= 4 then
			assign_mourning_slots()
			wait.frames_skipping(1)
		end
		if checkpoint <= 5 then
			wait.background_load_skipping()
		end
		if checkpoint <= 6 then
			wait.background_load_skipping()
		end
		if checkpoint <= 7 then
			message.show_voiced_skipping(3520030)
		end
		if checkpoint <= 8 then
			message.show_voiced_skipping(3520040)
		end
		if checkpoint <= 9 then
			message.show_voiced_skipping(3520050)
		end
		if checkpoint <= 10 then
			message.show_voiced_skipping(3520060)
		end
		if checkpoint <= 11 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 12 then
			message.show_voiced_skipping(3520070)
		end
		if checkpoint <= 13 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 14 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 15 then
			message.show_voiced_skipping(3520080)
		end
		if checkpoint <= 16 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 17 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 18 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 19 then
			wait.frames_skipping(1)
		end
		if checkpoint <= 20 then
			cutscene.skip_command(8)
		end
		if checkpoint <= 21 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 22 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 23 then
			wait.frames_skipping(120)
		end
		if checkpoint <= 24 then
			message.show_voiced_skipping(3520090)
		end
		if checkpoint <= 25 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 26 then
			wait.background_load_skipping()
		end
		if checkpoint <= 27 then
			wait.frames_skipping(120)
		end
		if checkpoint <= 28 then
			message.show_voiced_skipping(3520100)
		end
		if checkpoint <= 29 then
			message.show_voiced_skipping(3520110)
		end
		if checkpoint <= 30 then
			message.show_voiced_skipping(3520120)
		end
		if checkpoint <= 31 then
			message.show_voiced_skipping(3520130)
		end
		if checkpoint <= 32 then
			message.show_voiced_skipping(3520140)
		end
		if checkpoint <= 33 then
			message.show_voiced_skipping(3520150)
		end
		if checkpoint <= 34 then
			cutscene.skip_command(6)
		end
		if checkpoint <= 35 then
			message.show_voiced_skipping(3520160)
		end
		if checkpoint <= 36 then
			cutscene.skip_command(7)
		end
		if checkpoint <= 37 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 38 then
			wait.frames_skipping(120)
		end
		if checkpoint <= 39 then
			cutscene.skip_command(10)
		end
		if checkpoint <= 40 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 41 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 42 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 43 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 44 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 45 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 46 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 47 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 48 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 49 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 50 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 51 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 52 then
			wait.frames_skipping(120)
		end
		if checkpoint <= 53 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 54 then
			wait.frames_skipping(120)
		end
		if checkpoint <= 55 then
			wait.background_load_skipping()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	checkpoint = 57
	wait.frames(30)
	event.stop_port_sound_effects(4)
	event.set_event_projection(saved_projection)
	event.set_motion_blur(0)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.skip_next_map_sound_load()
	event.skip_next_music_load()
	checkpoint = 58
	vm.wait(58)
	checkpoint = 59
	end_cannon_barrage()
end

--- Loads the message file for the Guiltoni confrontation scene and resizes the Monica effect model.
local function load_confrontation_assets()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		confrontation_max_slot = 0
		confrontation_monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", confrontation_max_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", confrontation_max_slot)
		event.attach_object_handle_to_character(0, confrontation_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, confrontation_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", confrontation_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", confrontation_monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", confrontation_monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", confrontation_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", confrontation_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", confrontation_monica_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", confrontation_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica1.gltf", "info", confrontation_monica_slot)
		event.attach_object_handle_to_character(1, confrontation_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, confrontation_monica_slot)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if playable_character == 1 then
		confrontation_max_slot = 8
		confrontation_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", confrontation_max_slot)
		event.load_equipment_model(5, 0, 1, "info", confrontation_max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", confrontation_max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", confrontation_max_slot)
		event.load_equipment_model(5, 0, 3, "info", confrontation_max_slot)
		event.load_equipment_model(5, 0, 2, "info", confrontation_max_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", confrontation_max_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", confrontation_max_slot)
		event.attach_object_handle_to_character(0, confrontation_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, confrontation_max_slot)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", confrontation_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica1.gltf", "info", confrontation_monica_slot)
		event.attach_object_handle_to_character(1, confrontation_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, confrontation_monica_slot)
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

--- Assigns the Max and Monica slots of the barrier scene as the loader leaves them when Monica is playable.
local function assign_shield_slots()
	confrontation_max_slot = 0
	confrontation_monica_slot = 8
	confrontation_max_slot = 8
	confrontation_monica_slot = 0
end

--- Re-enables the map triggers and ends the Guiltoni confrontation scene.
local function end_confrontation()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, confrontation_max_slot)
		event.set_character_active(0, confrontation_monica_slot)
		event.delete_character_extension_packs(confrontation_max_slot)
		event.delete_character_extension_packs(confrontation_monica_slot)
		event.delete_character(confrontation_monica_slot)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, confrontation_monica_slot)
		event.set_character_active(0, confrontation_max_slot)
		event.delete_character_extension_packs(confrontation_max_slot)
		event.delete_character_extension_packs(confrontation_monica_slot)
		event.delete_character(confrontation_max_slot)
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

--- Plays the scene in which the flames burn Monica and Guiltoni confronts Max and Monica before the fight.
local function cutscene_guiltoni_confrontation()
	local sound_bank: s32 = 0
	local saved_projection: f32 = 0
	local saved_time_of_day: f32 = 0
	local playable_character: s32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		checkpoint = 1
		wait.frames(4)
		event.load_music(51)
		event.load_map_sounds(3839)
		sound_bank = event.load_sound_effect_file_2(3839) or sound_bank
		event.play_music(0)
		load_confrontation_assets()
		saved_projection = event.get_event_projection() or saved_projection
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
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
		event.play_sound_effect(sound_bank, 4)
		event.play_sound_effect(sound_bank, 5)
		event.set_camera_sequence_position(-104.47, 123.32, -554.46)
		event.set_camera_sequence_look_at(123.37, 22.54, -57.61)
		event.set_character_active(1, 12)
		event.set_character_active(1, confrontation_max_slot)
		event.set_character_active(1, confrontation_monica_slot)
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
		checkpoint = 2
		camera.wait_until_done()
		event.enable_drama_skip()
		event.set_camera_sequence_position(94.12, 16.49, 28.03)
		event.set_camera_sequence_look_at(-65.76, 22.54, 25.67)
		checkpoint = 3
		wait.frames(30)
		event.stop_sound_effect(sound_bank, 5)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(5, "振り向く", 6)
		event.queue_object_sequence_next_motion(5, "振り向くL", 4)
		event.set_object_sequence_motion(4, "振り向く", 6)
		event.queue_object_sequence_next_motion(4, "振り向くL", 4)
		checkpoint = 4
		wait.frames(60)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_rotation(4, 0.0, -1.12, 0.0)
		event.set_camera_sequence_position(-268.03, 16.49, 76.91)
		event.set_camera_sequence_look_at(-65.76, 22.54, 25.67)
		event.set_object_sequence_motion(1, "歩き", 4, 0.75)
		event.move_object_sequence(1, -263.33, 0.0, 81.55, 180, 1)
		event.set_mouth_texture_animations(5, "通常口パク")
		checkpoint = 5
		message.show_voiced_for(3520190, -1)
		event.reset_mouth_texture_animations()
		checkpoint = 6
		wait.frames(30)
		event.set_camera_sequence_position(-198.27, 24.06, -15.13)
		event.set_camera_sequence_look_at(-143.41, 22.54, 150.46)
		event.set_object_sequence_rotation(5, 0.0, 0.24, 0.0)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 7
		message.show_voiced_for(3520200, 60)
		event.reset_mouth_texture_animations()
		checkpoint = 8
		wait.frames(60)
		event.set_object_sequence_rotation(5, 0.0, -1.2, 0.0)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.set_camera_sequence_position(-297.3, 23.01, 69.91)
		event.set_camera_sequence_look_at(-176.77, 22.54, 113.71)
		checkpoint = 9
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "にらむ", 4)
		checkpoint = 10
		wait.frames(60)
		event.set_camera_sequence_position(-149.75, 53.84, 30.37)
		event.set_camera_sequence_look_at(-284.64, 36.42, 86.71)
		event.play_sound_effect(sound_bank, 7)
		checkpoint = 11
		wait.frames(45)
		event.set_camera_sequence_position(-2289.28, -11.1, 1309.03)
		event.set_camera_sequence_look_at(-2581.77, 22.54, 1222.45)
		event.play_sound_effect(sound_bank, 7)
		checkpoint = 12
		wait.frames(45)
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
		event.play_sound_effect(sound_bank, 7)
		checkpoint = 13
		wait.frames(45)
		event.set_object_sequence_position(6, -2755.39, 25.75, 1165.67)
		event.set_object_sequence_rotation(6, 0.0, 1.92, 0.0)
		event.set_object_sequence_motion(1, "上にらみ", 4)
		event.set_camera_sequence_position(-297.3, 23.01, 69.91)
		event.set_camera_sequence_look_at(-176.77, 22.54, 113.71)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 14
		message.show_voiced(3520203)
		event.reset_mouth_texture_animations()
		checkpoint = 15
		wait.frames(30)
		event.set_camera_sequence_position(-391.93, 13.26, 98.06)
		event.set_camera_sequence_look_at(-272.34, 20.12, 89.15)
		checkpoint = 16
		wait.frames(30)
		event.play_sound_effect(sound_bank, 8)
		event.set_character_position(15, -347.49, -8.42, 91.78)
		event.set_character_active(1, 15)
		event.set_character_motion(15, "ｴﾌｪｸﾄ_モニカ火", 6, -1, 1)
		event.set_object_sequence_motion(1, "あつい", 6)
		event.queue_object_sequence_next_motion(1, "あついL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 17
		message.show_voiced_for(3520205, -1)
		event.reset_mouth_texture_animations()
		checkpoint = 18
		wait.frames(15)
		event.set_object_sequence_position(5, -157.43, 0.0, 37.77)
		event.set_object_sequence_rotation(5, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(4, -113.67, 0.0, 42.81)
		event.set_object_sequence_rotation(4, 0.0, -1.12, 0.0)
		event.set_object_sequence_position(0, -159.45, 0.0, 85.12)
		event.set_object_sequence_rotation(0, 0.0, -1.56, 0.0)
		event.set_character_active(0, 15)
		event.set_camera_sequence_position(17.51, 106.77, -12.07)
		event.set_camera_sequence_look_at(-167.62, 22.54, 62.55)
		checkpoint = 19
		wait.frames(30)
		event.stop_music(0)
		checkpoint = 20
		vm.wait(20)
		checkpoint = 21
		vm.wait(21)
		checkpoint = 22
		vm.wait(22)
		checkpoint = 23
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
		checkpoint = 24
		message.show_voiced(3520210)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "しがみつく", 6)
		event.queue_object_sequence_next_motion(5, "しがみつくL", 4)
		event.set_object_sequence_motion(4, "しがみつく", 6)
		event.queue_object_sequence_next_motion(4, "しがみつくL", 4)
		event.set_object_sequence_position(4, -157.43, 0.0, 37.77)
		event.set_object_sequence_rotation(4, 0.0, -2.62, 0.0)
		event.play_sound_effect(sound_bank, 9)
		event.set_camera_sequence_position(-195.7, 18.18, -27.74)
		event.set_camera_sequence_look_at(-152.88, 22.54, 67.21)
		event.set_object_sequence_motion(0, "キョロキョロ", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 6)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 25
		message.show_voiced(3520220)
		event.reset_mouth_texture_animations()
		checkpoint = 26
		wait.frames(30)
		event.set_object_sequence_position(0, -220.59, 0.0, 24.32)
		event.set_object_sequence_motion(5, "だいじょうぶ", 6)
		event.queue_object_sequence_next_motion(5, "だいじょうぶL", 4)
		event.set_object_sequence_motion(4, "だいじょうぶ", 6)
		event.queue_object_sequence_next_motion(4, "だいじょうぶL", 4)
		event.set_camera_sequence_position(-172.22, 21.82, 12.89)
		event.set_camera_sequence_look_at(-146.82, 22.54, 46.98)
		event.set_mouth_texture_animations(5, "通常口パク")
		checkpoint = 27
		message.show_voiced(3520230)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(5, "なでなで", 6)
		event.queue_object_sequence_next_motion(5, "だいじょうぶL", 4)
		event.set_object_sequence_motion(4, "なでなで", 6)
		event.queue_object_sequence_next_motion(4, "だいじょうぶL", 4)
		checkpoint = 28
		wait.frames(90)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(5, "方向転換", 6)
		event.queue_object_sequence_next_motion(5, "方向転換L", 4)
		event.set_object_sequence_motion(4, "方向転換", 6)
		event.queue_object_sequence_next_motion(4, "方向転換L", 4)
		checkpoint = 29
		wait.frames(60)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 30
		message.show_voiced(3520240)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_position(5, -182.1, 0.0, 109.05)
		event.set_object_sequence_rotation(5, 0.0, -0.56, 0.0)
		event.set_camera_sequence_position(-204.21, 71.27, 153.44)
		event.set_camera_sequence_look_at(-185.43, 22.54, 115.87)
		event.set_object_sequence_motion(5, "立ち2", 4)
		event.set_camera_sequence_position(-235.14, 83.43, 215.35)
		event.set_camera_sequence_look_at(-216.37, 22.54, 177.78)
		event.move_camera_sequence_eased(-201.16, 83.43, 147.34, -182.39, 22.54, 109.77, 90, 2, 1.0)
		checkpoint = 31
		wait.frames(60)
		event.play_sound_effect(sound_bank, 12)
		event.set_object_sequence_motion(5, "顔を上げる", 6)
		event.queue_object_sequence_next_motion(5, "顔を上げるL", 4)
		event.set_mouth_texture_animations(5, "通常口パク")
		checkpoint = 32
		message.show_voiced(3520250)
		event.reset_mouth_texture_animations()
		checkpoint = 33
		camera.wait_until_done()
		checkpoint = 34
		wait.frames(30)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_rotation(4, 0.0, -0.7, 0.0)
		event.set_camera_sequence_position(-85.52, 20.68, 6.25)
		event.set_camera_sequence_look_at(-208.47, 22.54, 109.19)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 35
		message.show_voiced(3520260)
		event.reset_mouth_texture_animations()
		checkpoint = 36
		wait.frames(20)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(25)
		event.add_camera_sequence_path_point(-85.52, 20.68, 6.25, -208.47, 22.54, 109.19)
		event.add_camera_sequence_path_point(-85.52, 20.68, 6.25, -208.47, 79.99, 109.19)
		event.start_camera_sequence_path()
		event.play_sound_effect(sound_bank, 13)
		event.set_object_sequence_motion(5, "ジャンプ", 6)
		checkpoint = 37
		wait.frames(15)
		event.move_object_sequence(5, -182.1, 100.3, 109.05, 10)
		event.set_object_sequence_motion(4, "見上げる", 6)
		event.queue_object_sequence_next_motion(4, "見上げるL", 4)
		checkpoint = 38
		camera.wait_until_done()
		event.stop_sound_effect(sound_bank, 8)
		event.play_sound_effect(sound_bank, 14)
		event.set_object_sequence_motion(5, "空中", 4)
		event.set_camera_sequence_position(-492.85, 213.33, 582.49)
		event.set_camera_sequence_look_at(22.56, 390.84, -208.1)
		event.move_camera_sequence_eased(-492.85, 409.38, 582.49, 22.56, 390.84, -208.1, 180, 0, 0.5)
		event.jump_object_sequence(5, -151.79, 185.12, 324.04, -0.6, 40)
		checkpoint = 39
		wait.frames(25)
		event.set_object_sequence_motion(5, "着地", 6)
		checkpoint = 40
		object.wait_until_done(5)
		event.play_sound_effect(sound_bank, 16)
		event.rotate_object_sequence(5, 0.0, -2.8, 0.0, 20)
		event.set_object_sequence_motion(5, "歩き")
		checkpoint = 41
		object.wait_until_done(5)
		event.set_object_sequence_motion(5, "立ち")
		checkpoint = 42
		wait.frames(30)
		event.play_sound_effect(sound_bank, 15)
		event.set_object_sequence_motion(5, "ジャンプ", 6)
		event.set_object_sequence_motion(5, "空中", 5)
		checkpoint = 43
		object.wait_until_done(5)
		event.jump_object_sequence(5, -171.87, 401.97, -73.85, -0.4, 60)
		event.set_object_sequence_motion(5, "空中", 4)
		event.delay_object_sequence_motion_track(5, 45)
		event.set_object_sequence_motion(5, "着地", 6)
		checkpoint = 44
		object.wait_until_done(5)
		event.play_sound_effect(sound_bank, 16)
		checkpoint = 45
		wait.frames(50)
		checkpoint = 46
		camera.wait_until_done()
		event.set_object_sequence_rotation(5, 0.0, -0.37, 0.0)
		event.set_object_sequence_motion(5, "立ち3", 4)
		event.set_camera_sequence_position(-269.68, 499.83, 184.82)
		event.set_camera_sequence_look_at(-101.0, 390.84, -261.7)
		checkpoint = 47
		wait.frames(60)
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
		checkpoint = 48
		wait.frames(150)
		event.stop_sound_effect(sound_bank, 4)
		event.play_sound_effect(sound_bank, 17)
		event.play_sound_effect(sound_bank, 18)
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
		checkpoint = 49
		camera.wait_until_done()
		event.set_camera_sequence_position(-104.37, 19.87, -248.05)
		event.set_camera_sequence_look_at(-79.52, 22.03, -232.43)
		checkpoint = 50
		wait.frames(90)
		event.set_camera_sequence_position(-34.84, 37.38, -59.03)
		event.set_camera_sequence_look_at(-95.77, 20.25, -225.62)
		checkpoint = 51
		wait.frames(90)
		event.set_camera_sequence_position(-348.67, -50.57, -550.42)
		event.set_camera_sequence_look_at(-351.04, 5.47, -770.66)
		checkpoint = 52
		wait.frames(90)
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
		checkpoint = 53
		wait.frames(60)
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "わらい顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		checkpoint = 54
		camera.wait_until_done()
		event.set_camera_sequence_position(-104.37, 19.87, -248.05)
		event.set_camera_sequence_look_at(-79.52, 22.03, -232.43)
		event.start_crossfade(30)
		checkpoint = 55
		wait.frames(90)
		event.set_camera_sequence_position(-207.34, 54.9, -452.6)
		event.set_camera_sequence_look_at(-71.26, 17.87, -226.97)
		event.set_object_sequence_position(1, -47.62, 0.0, -137.28)
		event.set_object_sequence_rotation(1, 0.0, -2.74, 0.0)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -70.49, 0.0, -204.72, 40)
		checkpoint = 56
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		checkpoint = 57
		wait.frames(30)
		event.set_object_sequence_motion(1, "飛び", 2)
		event.move_object_sequence(1, -87.32, 0.0, -244.51, 20)
		checkpoint = 58
		wait.frames(20)
		event.play_sound_effect(sound_bank, 19)
		checkpoint = 59
		wait.frames(10)
		event.set_camera_sequence_position(-295.37, -86.21, -553.05)
		event.set_camera_sequence_look_at(-123.25, 61.72, -340.9)
		checkpoint = 60
		wait.frames(50)
		event.set_camera_sequence_position(-62.09, 9.68, -219.85)
		event.set_camera_sequence_look_at(14.42, 33.43, -191.5)
		event.play_sound_effect(sound_bank, 20)
		event.set_object_sequence_motion(0, "モニカぁあ～", 6)
		event.queue_object_sequence_next_motion(0, "モニカぁあ～L", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		checkpoint = 61
		message.show_voiced_for(3520280, -1)
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
		checkpoint = 62
		camera.wait_until_done()
		event.stop_sound_effect(sound_bank, 18)
		event.set_object_handle_footstep_sound(1, 0)
		event.set_camera_sequence_position(-153.85, 1.75, -965.32)
		event.set_camera_sequence_look_at(-213.98, -16.72, -854.17)
		event.fade_out_music(90)
		event.set_object_sequence_position(1, -213.98, -29.77, -854.17)
		event.play_sound_effect(sound_bank, 21)
		event.set_object_sequence_motion(1, "着地2", 6)
		event.queue_object_sequence_next_motion(1, "着地2Ｌ", 4)
		checkpoint = 63
		wait.frames(90)
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
		checkpoint = 64
		camera.wait_until_done()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(360)
		event.add_camera_sequence_path_point(-296.02, -4.19, -748.32, -394.55, 1.71, -679.52)
		event.add_camera_sequence_path_point(-318.45, -4.19, -780.45, -416.98, 1.71, -711.64)
		event.start_camera_sequence_path()
		checkpoint = 65
		wait.frames(120)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 66
		message.show_voiced_for(3520290, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 67
		message.show_voiced_for(3520295, -1)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 22)
		event.set_object_sequence_motion(7, "立ちからはっ", 6)
		event.queue_object_sequence_next_motion(7, "立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		checkpoint = 68
		message.show_voiced_for(3520300, -1)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 16)
		event.set_character_position(16, -382.55, -29.77, -760.19)
		event.set_character_motion(16, "ワープ", 2, -1, 1)
		event.play_sound_effect(sound_bank, 23)
		event.set_character_visible(20, 0, 1, 0.025)
		checkpoint = 69
		wait.frames(30)
		event.set_character_active(0, 20)
		checkpoint = 70
		camera.wait_until_done()
		checkpoint = 71
		wait.frames(30)
		event.delete_character(20)
		event.set_camera_sequence_position(-236.39, -1.57, -810.07)
		event.set_camera_sequence_look_at(-210.96, -15.51, -863.92)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 72
		message.show_voiced_for(3520310, -1)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-193.72, -11.82, -832.4, -220.35, -5.56, -862.48)
		event.add_camera_sequence_path_point(-209.1, -11.82, -818.79, -235.72, -5.56, -848.88)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 73
		message.show_voiced_for(3520320, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 74
		message.show_voiced_for(3520325, -1)
		event.reset_mouth_texture_animations()
		checkpoint = 75
		camera.wait_until_done()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(-298.65, -11.82, -739.54, -325.27, -5.56, -769.63)
		event.add_camera_sequence_path_point(-321.64, -11.82, -719.2, -348.27, -5.56, -749.28)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 76
		message.show_voiced_for(3520330, -1)
		event.reset_mouth_texture_animations()
		checkpoint = 77
		camera.wait_until_done()
		checkpoint = 78
		wait.frames(30)
		event.set_camera_sequence_position(-311.57, -2.68, -773.5)
		event.set_camera_sequence_look_at(-346.28, 0.67, -749.62)
		event.play_sound_effect(sound_bank, 24)
		event.set_object_sequence_motion(6, "これはこれは", 6)
		event.queue_object_sequence_next_motion(6, "立ち", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 79
		message.show_voiced(3520340)
		event.reset_mouth_texture_animations()
		checkpoint = 80
		object.wait_until_done(6)
		event.set_event_projection(2000.0)
		event.set_camera_sequence_path_frames(200)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-389.89, 2.83, -660.42, -273.14, -7.07, -813.46)
		event.add_camera_sequence_path_point(-436.6, 2.83, -711.42, -273.14, -7.07, -813.46)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 81
		message.show_voiced_for(3520350, -1)
		event.reset_mouth_texture_animations()
		checkpoint = 82
		wait.frames(30)
		event.play_sound_effect(sound_bank, 25)
		event.set_object_sequence_motion(1, "許さない！", 6)
		event.queue_object_sequence_next_motion(1, "にらみ～ギルトーニＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 83
		message.show_voiced_for(3520355, -1)
		event.reset_mouth_texture_animations()
		checkpoint = 84
		camera.wait_until_done()
		event.set_camera_sequence_position(-316.92, -38.16, -871.1)
		event.set_camera_sequence_look_at(-346.81, 0.41, -749.55)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 85
		message.show_voiced(3520360)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 86
		message.show_voiced(3520365)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-52.38, 14.17, -934.99)
		event.set_camera_sequence_look_at(-338.56, -9.4, -775.64)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 87
		message.show_voiced(3520370)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 88
		message.show_voiced(3520380)
		event.reset_mouth_texture_animations()
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 0 then
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
		event.play_sound_effect(sound_bank, 26)
		event.set_object_sequence_motion(1, "構え", 6)
		event.queue_object_sequence_next_motion(1, "構えＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 89
		message.show_voiced(3520390)
		event.reset_mouth_texture_animations()
		checkpoint = 90
		wait.frames(30)
		event.fade_out_screen(30)
		checkpoint = 91
		wait.frames(30)
		event.delete_character(11)
		event.delete_character(19)
		event.delete_character(20)
		event.delete_character(15)
		event.delete_character(16)
		event.clear_memory_stack(6)
		event.set_event_projection(saved_projection)
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
		event.play_sound_effect(sound_bank, 27)
		event.set_camera_sequence_position(-238.5, 71.05, -462.7)
		event.set_camera_sequence_look_at(-30.96, 27.68, -54.57)
		event.fade_in_screen(30)
		checkpoint = 92
		wait.frames(90)
		event.set_camera_sequence_position(-90.18, 13.15, -222.54)
		event.set_camera_sequence_look_at(-38.29, 20.0, -70.1)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 93
		message.show_voiced(3520400)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 94
		message.show_voiced(3520410)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 95
		message.show_voiced(3520420)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 21)
		event.set_camera_sequence_position(289.65, 77.87, 17.75)
		event.set_camera_sequence_look_at(137.1, 27.68, 277.81)
		event.play_sound_effect(sound_bank, 28)
		event.set_object_sequence_motion(12, "飛び込み登場", 6)
		event.queue_object_sequence_next_motion(12, "立ち", 4)
		checkpoint = 96
		wait.frames(20)
		event.play_sound_effect(sound_bank, 32)
		checkpoint = 97
		object.wait_until_done(12)
		event.set_character_active(1, 22)
		event.play_sound_effect(sound_bank, 28)
		event.set_object_sequence_motion(13, "飛び込み登場", 6)
		event.queue_object_sequence_next_motion(13, "立ち", 4)
		checkpoint = 98
		wait.frames(20)
		event.play_sound_effect(sound_bank, 32)
		checkpoint = 99
		object.wait_until_done(13)
		checkpoint = 100
		wait.frames(30)
		event.set_character_active(1, 23)
		event.set_character_active(1, 13)
		event.set_camera_sequence_position(38.51, 77.87, -229.29)
		event.set_camera_sequence_look_at(-255.97, 27.68, -248.1)
		event.set_object_sequence_motion(14, "立ち", 4)
		event.play_sound_effect(sound_bank, 28)
		event.set_object_sequence_motion(15, "飛び込み登場", 6)
		event.queue_object_sequence_next_motion(15, "立ち", 4)
		checkpoint = 101
		wait.frames(20)
		event.play_sound_effect(sound_bank, 32)
		checkpoint = 102
		object.wait_until_done(15)
		event.set_character_active(1, 14)
		event.play_sound_effect(sound_bank, 28)
		event.set_object_sequence_motion(16, "飛び込み登場", 6)
		event.queue_object_sequence_next_motion(16, "立ち", 4)
		checkpoint = 103
		wait.frames(20)
		event.play_sound_effect(sound_bank, 32)
		checkpoint = 104
		object.wait_until_done(16)
		checkpoint = 105
		wait.frames(30)
		if playable_character == 1 then
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
		event.play_sound_effect(sound_bank, 29)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		checkpoint = 106
		wait.frames(30)
		event.fade_out_screen(30)
		checkpoint = 107
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			assign_shield_slots()
			wait.background_load_skipping()
		end
		if checkpoint <= 2 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 3 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 4 then
			message.show_voiced_for_skipping(3520190, -1)
		end
		if checkpoint <= 5 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 6 then
			message.show_voiced_for_skipping(3520200, 60)
		end
		if checkpoint <= 7 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 8 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 9 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 10 then
			wait.frames_skipping(45)
		end
		if checkpoint <= 11 then
			wait.frames_skipping(45)
		end
		if checkpoint <= 12 then
			wait.frames_skipping(45)
		end
		if checkpoint <= 13 then
			message.show_voiced_skipping(3520203)
		end
		if checkpoint <= 14 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 15 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 16 then
			message.show_voiced_for_skipping(3520205, -1)
		end
		if checkpoint <= 17 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 18 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 23 then
			message.show_voiced_skipping(3520210)
		end
		if checkpoint <= 24 then
			message.show_voiced_skipping(3520220)
		end
		if checkpoint <= 25 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 26 then
			message.show_voiced_skipping(3520230)
		end
		if checkpoint <= 27 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 28 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 29 then
			message.show_voiced_skipping(3520240)
		end
		if checkpoint <= 30 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 31 then
			message.show_voiced_skipping(3520250)
		end
		if checkpoint <= 32 then
			wait.background_load_skipping()
		end
		if checkpoint <= 33 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 34 then
			message.show_voiced_skipping(3520260)
		end
		if checkpoint <= 35 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 36 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 37 then
			wait.background_load_skipping()
		end
		if checkpoint <= 38 then
			wait.frames_skipping(25)
		end
		if checkpoint <= 39 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 40 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 41 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 42 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 43 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 44 then
			wait.frames_skipping(50)
		end
		if checkpoint <= 45 then
			wait.background_load_skipping()
		end
		if checkpoint <= 46 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 47 then
			wait.frames_skipping(150)
		end
		if checkpoint <= 48 then
			wait.background_load_skipping()
		end
		if checkpoint <= 49 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 50 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 51 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 52 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 53 then
			wait.background_load_skipping()
		end
		if checkpoint <= 54 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 55 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 56 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 57 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 58 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 59 then
			wait.frames_skipping(50)
		end
		if checkpoint <= 60 then
			message.show_voiced_for_skipping(3520280, -1)
		end
		if checkpoint <= 61 then
			wait.background_load_skipping()
		end
		if checkpoint <= 62 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 63 then
			wait.background_load_skipping()
		end
		if checkpoint <= 64 then
			wait.frames_skipping(120)
		end
		if checkpoint <= 65 then
			message.show_voiced_for_skipping(3520290, -1)
		end
		if checkpoint <= 66 then
			message.show_voiced_for_skipping(3520295, -1)
		end
		if checkpoint <= 67 then
			message.show_voiced_for_skipping(3520300, -1)
		end
		if checkpoint <= 68 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 69 then
			wait.background_load_skipping()
		end
		if checkpoint <= 70 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 71 then
			message.show_voiced_for_skipping(3520310, -1)
		end
		if checkpoint <= 72 then
			message.show_voiced_for_skipping(3520320, -1)
		end
		if checkpoint <= 73 then
			message.show_voiced_for_skipping(3520325, -1)
		end
		if checkpoint <= 74 then
			wait.background_load_skipping()
		end
		if checkpoint <= 75 then
			message.show_voiced_for_skipping(3520330, -1)
		end
		if checkpoint <= 76 then
			wait.background_load_skipping()
		end
		if checkpoint <= 77 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 78 then
			message.show_voiced_skipping(3520340)
		end
		if checkpoint <= 79 then
			cutscene.skip_command(6)
		end
		if checkpoint <= 80 then
			message.show_voiced_for_skipping(3520350, -1)
		end
		if checkpoint <= 81 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 82 then
			message.show_voiced_for_skipping(3520355, -1)
		end
		if checkpoint <= 83 then
			wait.background_load_skipping()
		end
		if checkpoint <= 84 then
			message.show_voiced_skipping(3520360)
		end
		if checkpoint <= 85 then
			message.show_voiced_skipping(3520365)
		end
		if checkpoint <= 86 then
			message.show_voiced_skipping(3520370)
		end
		if checkpoint <= 87 then
			message.show_voiced_skipping(3520380)
		end
		if checkpoint <= 88 then
			message.show_voiced_skipping(3520390)
		end
		if checkpoint <= 89 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 90 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 91 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 92 then
			message.show_voiced_skipping(3520400)
		end
		if checkpoint <= 93 then
			message.show_voiced_skipping(3520410)
		end
		if checkpoint <= 94 then
			message.show_voiced_skipping(3520420)
		end
		if checkpoint <= 95 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 96 then
			cutscene.skip_command(12)
		end
		if checkpoint <= 97 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 98 then
			cutscene.skip_command(13)
		end
		if checkpoint <= 99 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 100 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 101 then
			cutscene.skip_command(15)
		end
		if checkpoint <= 102 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 103 then
			cutscene.skip_command(16)
		end
		if checkpoint <= 104 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 105 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 106 then
			wait.frames_skipping(30)
		end
		return true
	end)
	checkpoint = 108
	vm.entry(108)
	event.cancel_drama_scene_skip()
	event.set_object_sequence_position(10, 0.0, 0.0, 0.0)
	event.set_event_projection(saved_projection)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	checkpoint = 109
	vm.wait(109)
	checkpoint = 110
	end_confrontation()
end

--- Loads the Monica and Guiltoni characters, camera model, sword effects and title sprite for the duel scene.
local function load_duel_assets()
	local playable_character: s32 = 0
	local image_block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		duel_max_slot = 0
		duel_monica_slot = 8
		event.load_character(5, "chara/c02_base.gltf", "info", duel_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", duel_monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", duel_monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", duel_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", duel_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", duel_monica_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", duel_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e352/vs_e352_monica.gltf", "info", duel_monica_slot)
		event.attach_object_handle_to_character(1, duel_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(1, duel_monica_slot)
		event.set_character_active(1, 12)
		event.set_character_active(1, 17)
		event.set_character_active(1, 18)
	end
	if playable_character == 1 then
		duel_max_slot = 8
		duel_monica_slot = 0
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", duel_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e352/vs_e352_monica.gltf", "info", duel_monica_slot)
		event.attach_object_handle_to_character(1, duel_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, duel_monica_slot)
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
	image_block = event.load_event_image_4(5, "textures/dungeon/image/beffect_00.json", 0) or image_block
	event.create_character_sword_effect(18, 0, 5, 16, 8)
	event.set_character_sword_effect_texture(18, 0, image_block, "sweff", 0, 0, 64, 32)
	event.create_character_sword_effect(18, 1, 5, 16, 8)
	event.set_character_sword_effect_texture(18, 1, image_block, "sweff", 0, 0, 64, 32)
	event.create_character_sword_effect(19, 0, 5, 16, 8)
	event.set_character_sword_effect_texture(19, 0, image_block, "sweff", 64, 0, 64, 32)
	event.create_character_sword_effect(19, 1, 5, 16, 8)
	event.set_character_sword_effect_texture(19, 1, image_block, "sweff", 64, 0, 64, 32)
	image_block = event.load_event_image_4(5, "textures/event/e300/e352/e352telop01_1.json", 1) or image_block
	event.reset_event_sprite(4)
	event.set_event_sprite_type(4, 0)
	event.set_event_sprite_texture(4, "e352telop01", image_block)
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

--- Assigns the Max and Monica slots of the duel scene as the loader leaves them when Monica is playable.
local function assign_duel_slots()
	duel_max_slot = 0
	duel_monica_slot = 8
	duel_max_slot = 8
	duel_monica_slot = 0
end

--- Unloads the duel scene characters, restores the map objects and ends the event.
local function end_duel()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(0, duel_monica_slot)
		event.delete_character_extension_packs(duel_monica_slot)
		event.delete_character(duel_monica_slot)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, duel_monica_slot)
		event.set_character_active(0, duel_max_slot)
		event.delete_character_extension_packs(duel_monica_slot)
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

--- Plays the sword duel between Monica and Guiltoni with scripted hit effects and a camera following the animated rig.
local function cutscene_duel_with_guiltoni()
	local sound_bank: s32 = 0
	local saved_time_of_day: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local frame: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local hit_step_x: f32 = 0
	local hit_step_y: f32 = 0
	local hit_step_z: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(3839) or sound_bank
		load_duel_assets()
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
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
		event.set_character_position(duel_monica_slot, -2195.0, 488.0, -475.0)
		event.set_character_rotation(duel_monica_slot, 0.0, 1.94, 0.0)
		event.set_character_position(19, -2195.0, 488.0, -475.0)
		event.set_character_rotation(19, 0.0, 2.9, 0.0)
		event.set_character_motion(duel_monica_slot, "ふりむき", 2, -1, 1)
		event.set_character_motion(19, "戦い", 1, -1, 1)
		event.set_character_active(1, 15)
		event.set_character_position(15, -2195.0, 488.0, -475.0)
		event.set_character_rotation(15, 0.0, 2.9, 0.0)
		event.set_character_motion(15, "1カメ", 5)
		event.set_character_active(1, duel_monica_slot)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_bank, 30)
		event.set_camera_position(-2170.97, 511.0, -483.67)
		event.set_camera_look_at(-2195.0, 511.0, -475.0)
		checkpoint = 2
		wait.frames(50)
		event.start_character_sword_effect(18, 0, "dcol00", "dcol01", 94, 10, 16)
		checkpoint = 3
		wait.frames(12)
		event.move_camera_sequence_eased(-2142.85, 509.61, -493.81, -2195.0, 503.11, -475.0, 10, 1, 0.6)
		checkpoint = 4
		camera.wait_until_done()
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "怒り目")
		event.set_object_handle_texture_animation(1, 1, "怒り口")
		event.set_character_rotation(duel_monica_slot, 0.0, 2.9, 0.0)
		event.set_character_active(1, 19)
		event.set_object_handle_frame_draw_flag(6, "sword", 1)
		event.set_character_motion(duel_monica_slot, "戦い", 6)
		event.set_character_motion(19, "戦い", 6)
		event.set_character_motion(15, "1カメ", 6)
		event.attach_object_handle_to_character(17, 15)
		frame = 0
		do
			local out1, out2, out3 = event.copy_vector(-2172.93, 510.33, -526.41)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
		end
		do
			local out1, out2, out3 = event.copy_vector(-2168.55, 512.98, -523.85)
			hit_step_x = out1 or hit_step_x
			hit_step_y = out2 or hit_step_y
			hit_step_z = out3 or hit_step_z
		end
		do
			local out1, out2, out3 = event.subtract_vectors(hit_step_x, hit_step_y, hit_step_z, -2172.93, 510.33, -526.41)
			hit_step_x = out1 or hit_step_x
			hit_step_y = out2 or hit_step_y
			hit_step_z = out3 or hit_step_z
		end
		do
			local out1, out2, out3 = event.scale_vector(hit_step_x, hit_step_y, hit_step_z, 0.03)
			hit_step_x = out1 or hit_step_x
			hit_step_y = out2 or hit_step_y
			hit_step_z = out3 or hit_step_z
		end
		while frame < 123 do
			if frame == 10 then
				event.start_character_sword_effect(18, 0, "dcol00", "dcol01", 94, 6, 6)
			end
			if frame == 26 then
				event.start_character_sword_effect(18, 1, "dcol00", "dcol01", 94, 10, 10)
			end
			if frame == 46 then
				event.start_character_sword_effect(18, 0, "dcol00", "dcol01", 94, 10, 10)
			end
			if frame == 46 then
				event.start_character_sword_effect(19, 0, "ken00", "ken01", 94, 4, 8)
			end
			if frame == 49 then
				event.spawn_hit_effect(0, hit_x, hit_y, hit_z)
			end
			if frame > 50 and frame <= 90 then
				do
					local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, hit_step_x, hit_step_y, hit_step_z)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
				end
				if frame >= 68 and frame <= 90 and vm.imod(frame, 3) == 0 then
					event.spawn_hit_effect(1, hit_x, hit_y, hit_z)
				end
			end
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(17, "int1")
				look_at_x = out1 or look_at_x
				look_at_y = out2 or look_at_y
				look_at_z = out3 or look_at_z
			end
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(17, "cam1")
				camera_x = out1 or camera_x
				camera_y = out2 or camera_y
				camera_z = out3 or camera_z
			end
			event.set_camera_position(camera_x, camera_y, camera_z)
			event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
			frame = frame + 1
			checkpoint = 5
			vm.wait(5)
		end
		event.set_object_sequence_motion_time(1, 53.1)
		event.set_object_sequence_motion_time(6, 53.1)
		event.set_character_motion(15, "2カメ", 6)
		frame = 0
		while frame < 85 do
			if frame == 26 then
				event.start_character_sword_effect(19, 0, "ken00", "ken01", 94, 4, 8)
			end
			if frame == 38 then
				event.start_character_sword_effect(19, 1, "ken00", "ken01", 94, 10, 10)
			end
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(17, "int2")
				look_at_x = out1 or look_at_x
				look_at_y = out2 or look_at_y
				look_at_z = out3 or look_at_z
			end
			do
				local out1, out2, out3 = event.get_object_handle_frame_position(17, "cam2")
				camera_x = out1 or camera_x
				camera_y = out2 or camera_y
				camera_z = out3 or camera_z
			end
			event.set_camera_position(camera_x, camera_y, camera_z)
			event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
			frame = frame + 1
			checkpoint = 6
			vm.wait(6)
		end
		event.play_sound_effect(sound_bank, 31)
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
		checkpoint = 7
		wait.frames(90)
		event.set_object_sequence_color(14, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		checkpoint = 8
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			assign_duel_slots()
			wait.frames_skipping(50)
		end
		if checkpoint <= 2 then
			wait.frames_skipping(12)
		end
		if checkpoint <= 3 then
			wait.background_load_skipping()
		end
		if checkpoint <= 4 then
			frame = 0
			local _ = frame < 123
			local _ = frame == 10
			local _ = frame == 26
			local _ = frame == 46
			local _ = frame == 46
			local _ = frame == 49
			local _ = frame > 50
			local _ = frame <= 90
			local _ = frame >= 68
			local _ = frame <= 90
			local _ = vm.imod(frame, 3) == 0
			frame = frame + 1
		end
		if checkpoint <= 5 then
			frame = 0
			local _ = frame < 85
			local _ = frame == 26
			local _ = frame == 38
			frame = frame + 1
		end
		if checkpoint <= 6 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 7 then
			wait.frames_skipping(30)
		end
		return true
	end)
	checkpoint = 9
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_object_sequence_position(10, 0.0, 0.0, 0.0)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	checkpoint = 10
	vm.wait(10)
	checkpoint = 11
	end_duel()
end

--- Loads the party, Guiltoni, Jamming, crest, cannon and crystal models and messages for the barrier scene.
local function load_shield_assets()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		shield_max_slot = 0
		shield_monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", shield_max_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", shield_max_slot)
		event.attach_object_handle_to_character(0, shield_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, shield_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", shield_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", shield_monica_slot, 41)
		event.load_equipment_model(5, 1, 0, "info", shield_monica_slot, 42)
		event.load_equipment_model(5, 1, 4, "info", shield_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", shield_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", shield_monica_slot, 36)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", shield_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", shield_monica_slot)
		event.attach_object_handle_to_character(1, shield_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, shield_monica_slot)
		event.set_character_active(1, 36)
		event.set_character_active(0, 41)
		event.set_character_active(0, 42)
	end
	if playable_character == 1 then
		shield_max_slot = 32
		shield_monica_slot = 0
		event.load_equipment_model(5, 1, 1, "info", shield_monica_slot, 41)
		event.load_equipment_model(5, 1, 0, "info", shield_monica_slot, 42)
		event.load_character(5, "chara/c01_base.gltf", "info", shield_max_slot)
		event.load_equipment_model(5, 0, 4, "info", shield_max_slot)
		event.load_equipment_model(5, 0, 3, "info", shield_max_slot)
		event.load_equipment_model(5, 0, 2, "info", shield_max_slot, 36)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", shield_max_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", shield_max_slot)
		event.attach_object_handle_to_character(0, shield_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, shield_max_slot)
		event.set_character_active(1, 36)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", shield_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", shield_monica_slot)
		event.attach_object_handle_to_character(1, shield_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, shield_monica_slot)
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

--- Assigns the Max and Monica slots of the confrontation scene as the loader leaves them when Monica is playable.
local function assign_confrontation_slots()
	shield_max_slot = 0
	shield_monica_slot = 32
	shield_max_slot = 32
	shield_monica_slot = 0
end

--- Unloads the barrier scene characters, re-enables the map triggers and ends the event.
local function end_shield_scene()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, shield_max_slot)
		event.set_character_active(0, shield_monica_slot)
		event.delete_character_extension_packs(shield_max_slot)
		event.delete_character_extension_packs(shield_monica_slot)
		event.delete_character(shield_monica_slot)
		event.delete_character(36)
		event.delete_character(41)
		event.delete_character(42)
	end
	if playable_character == 1 then
		event.set_character_active(1, shield_monica_slot)
		event.set_character_active(0, shield_max_slot)
		event.delete_character_extension_packs(shield_max_slot)
		event.delete_character_extension_packs(shield_monica_slot)
		event.delete_character(shield_max_slot)
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

--- Plays the scene in which Guiltoni and Jamming fire crystal cannons and the crest raises a barrier to protect the party.
local function cutscene_crest_shields_party()
	local sound_bank: s32 = 0
	local saved_projection: f32 = 0
	local saved_time_of_day: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.set_save_flag(356, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		checkpoint = 1
		vm.wait(1)
		checkpoint = 2
		vm.wait(2)
		checkpoint = 3
		vm.wait(3)
		checkpoint = 4
		vm.wait(4)
		event.load_map_sounds(3841)
		sound_bank = event.load_sound_effect_file_2(3841) or sound_bank
		event.fade_out_screen(30)
		checkpoint = 5
		wait.frames(35)
		load_shield_assets()
		event.set_scene_status_flags(1, 0, 256, 1)
		checkpoint = 6
		vm.wait(6)
		saved_projection = event.get_event_projection() or saved_projection
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
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
		event.play_sound_effect(sound_bank, 4)
		event.set_camera_sequence_position(-3228.79, 35.27, 1184.49)
		event.set_camera_sequence_look_at(-3120.21, 64.65, 1226.19)
		event.set_character_active(1, 36)
		event.set_character_active(0, shield_max_slot)
		event.set_character_active(1, shield_monica_slot)
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
		checkpoint = 7
		message.show_voiced(3560010)
		event.reset_mouth_texture_animations()
		checkpoint = 8
		wait.frames(30)
		event.set_character_active(1, 41)
		event.set_character_active(1, 42)
		event.set_camera_sequence_position(-3217.06, 43.8, 1135.37)
		event.set_camera_sequence_look_at(-3161.01, 46.88, 1099.01)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_motion(1, "剣おろし", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 9
		message.show_voiced(3560020)
		event.reset_mouth_texture_animations()
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 120)
		event.add_object_sequence_path_point(1, -3193.71, 25.75, 1113.77)
		event.add_object_sequence_path_point(1, -3191.52, 25.75, 1171.04)
		event.start_object_sequence_path(1, 1)
		event.set_object_sequence_motion(1, "歩き")
		checkpoint = 10
		wait.frames(60)
		event.set_camera_sequence_position(-3252.89, 52.03, 1136.53)
		event.set_camera_sequence_look_at(-3191.9, 46.88, 1186.49)
		checkpoint = 11
		object.wait_until_done(1)
		event.set_object_sequence_motion(1, "立ち")
		checkpoint = 12
		wait.frames(60)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目下パチ")
		event.set_camera_sequence_position(-3235.05, 37.69, 1207.12)
		event.set_camera_sequence_look_at(-3196.19, 46.88, 1176.66)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(1, "剣突きつけ", 6)
		event.queue_object_sequence_next_motion(1, "剣突きつけＬ", 4)
		checkpoint = 13
		wait.frames(60)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(1, "剣突きつけ", 6)
		event.queue_object_sequence_next_motion(1, "剣突きつけＬ", 4)
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "わらい顔")
		event.set_object_sequence_texture_animation(6, 1, "目とじ")
		event.set_camera_sequence_position(-3214.05, 52.19, 1179.0)
		event.set_camera_sequence_look_at(-3184.91, 48.9, 1206.85)
		checkpoint = 14
		wait.frames(60)
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "わらい顔")
		event.set_object_sequence_texture_animation(6, 1, "目とじ～目あき")
		event.set_object_sequence_texture_animation(6, 1, "わらい口～口とじ")
		event.set_object_sequence_motion(6, "顔上げる", 6)
		event.queue_object_sequence_next_motion(6, "顔上げるＬ", 4)
		checkpoint = 15
		wait.frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-3240.43, 47.09, 1159.88, -3177.08, 48.9, 1166.47)
		event.add_camera_sequence_path_point(-3243.26, 47.09, 1187.11, -3179.91, 48.9, 1193.69)
		event.start_camera_sequence_path()
		checkpoint = 16
		camera.wait_until_done()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(90)
		event.add_camera_sequence_path_point(-3227.95, 37.5, 1215.78, -3178.62, 48.9, 1184.83)
		event.add_camera_sequence_path_point(-3234.28, 37.5, 1205.7, -3184.95, 48.9, 1174.74)
		event.start_camera_sequence_path()
		checkpoint = 17
		camera.wait_until_done()
		event.start_crossfade(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(90)
		event.add_camera_sequence_path_point(-3203.96, 45.24, 1194.92, -3154.63, 56.45, 1163.97)
		event.add_camera_sequence_path_point(-3207.72, 45.24, 1188.92, -3158.39, 56.45, 1157.97)
		event.start_camera_sequence_path()
		checkpoint = 18
		camera.wait_until_done()
		event.set_camera_sequence_position(-3909.29, 148.98, 1182.03)
		event.set_camera_sequence_look_at(-3563.8, -10.58, 1141.1)
		event.set_character_position(47, -3756.47, -58.75, 1194.56)
		event.set_character_rotation(47, 0.0, 0.0, 0.0)
		event.set_character_active(1, 47)
		event.set_character_motion(47, "ヒット", 2, -1, 1)
		event.play_sound_effect(sound_bank, 8)
		event.delay_camera_sequence_shake_track(30)
		event.shake_camera_sequence(0.0, 0.3, 0.0, 120)
		checkpoint = 19
		wait.frames(60)
		event.set_character_active(0, 47)
		event.set_camera_sequence_position(-3218.05, 58.5, 1186.27)
		event.set_camera_sequence_look_at(-3110.83, 8.26, 1127.13)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～半口")
		event.play_sound_effect(sound_bank, 9)
		event.set_object_sequence_motion(1, "え？", 6)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 20
		message.show_voiced_for(3560025, -1)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(6, 0)
		event.set_object_sequence_texture_animation(6, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(6, 1, "通常目パチ")
		event.set_camera_sequence_position(-3229.37, 62.21, 1210.77)
		event.set_camera_sequence_look_at(-3103.54, 8.26, 1191.57)
		event.play_sound_effect(sound_bank, 10)
		event.set_object_sequence_motion(6, "なんだ？", 6)
		event.queue_object_sequence_next_motion(6, "なんだ？Ｌ", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 21
		message.show_voiced_for(3560030, -1)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(6, "バク転", 6)
		checkpoint = 22
		wait.frames(5)
		event.move_object_sequence(6, -3186.11, 25.75, 1357.13, 45)
		checkpoint = 23
		wait.frames(10)
		event.set_camera_sequence_position(-3322.33, 78.68, 1141.68)
		event.set_camera_sequence_look_at(-3203.67, 55.98, 1199.43)
		checkpoint = 24
		wait.frames(20)
		event.set_camera_sequence_position(-3184.57, 48.67, 1183.98)
		event.set_camera_sequence_look_at(-3185.6, 46.46, 1288.4)
		checkpoint = 25
		object.wait_until_done(6)
		event.play_sound_effect(sound_bank, 12)
		event.play_sound_effect(sound_bank, 13)
		event.set_character_active(1, 39)
		event.set_character_position(39, -3213.34, 25.75, 1386.39)
		event.set_character_motion(39, "ワープ", 2, -1, 1)
		checkpoint = 26
		wait.frames(30)
		event.set_character_active(1, 38)
		event.set_character_visible(38, 1, 1, 0.025)
		event.set_object_sequence_motion(7, "立ちから話しポーズ", 6)
		event.queue_object_sequence_next_motion(7, "話し", 4)
		event.set_camera_sequence_position(-3197.25, 55.23, 1301.14)
		event.set_camera_sequence_look_at(-3198.28, 53.02, 1405.56)
		event.set_mouth_texture_animations(7, "通常口パク")
		checkpoint = 27
		message.show_voiced(3560040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(7, "話しポーズ待機", 4)
		event.set_object_sequence_motion(6, "会話", 4)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 28
		message.show_voiced(3560050)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 29
		message.show_voiced(3560055)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(6, "立ち", 4)
		event.set_object_sequence_motion(7, "はっ！", 6)
		event.queue_object_sequence_next_motion(7, "立ち", 4)
		event.set_mouth_texture_animations(7, "通常口パク")
		checkpoint = 30
		message.show_voiced(3560060)
		event.reset_mouth_texture_animations()
		checkpoint = 31
		wait.frames(30)
		event.stop_sound_effect(sound_bank, 4)
		event.play_sound_effect(sound_bank, 14)
		event.set_character_active(1, 34)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(90)
		event.add_camera_sequence_path_point(-2317.41, 409.93, 812.37, -2227.35, 407.72, 780.15)
		event.add_camera_sequence_path_point(-1582.49, 409.93, 549.51, -1495.25, 407.72, 518.31)
		event.start_camera_sequence_path()
		checkpoint = 32
		camera.wait_until_done()
		event.set_camera_sequence_position(-572.71, 409.93, 60.46)
		event.set_camera_sequence_look_at(-485.48, 407.72, 29.26)
		checkpoint = 33
		wait.frames(60)
		event.set_object_sequence_motion(5, "呪文", 4)
		event.play_sound_effect(sound_bank, 15)
		event.set_camera_sequence_position(-215.86, 432.29, -37.91)
		event.set_camera_sequence_look_at(-143.93, 430.08, -96.45)
		event.set_mouth_texture_animations(5, "通常口パク")
		checkpoint = 34
		message.show_voiced_for(3560070, -1)
		event.reset_mouth_texture_animations()
		checkpoint = 35
		wait.frames(30)
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
		checkpoint = 36
		wait.frames(15)
		event.play_sound_effect(sound_bank, 16)
		checkpoint = 37
		wait.frames(15)
		event.set_character_active(1, 46)
		event.move_object_sequence(18, -2884.97, 501.86, 1101.17, 30)
		checkpoint = 38
		wait.frames(20)
		event.set_camera_sequence_position(-1963.8, 545.73, 2572.58)
		event.set_camera_sequence_look_at(-2020.19, 543.47, 2470.6)
		checkpoint = 39
		wait.frames(9)
		event.set_character_active(0, 46)
		event.set_character_active(1, 47)
		event.play_sound_effect(sound_bank, 17)
		event.set_character_motion(47, "ヒット", 6, -1, 1)
		event.delay_camera_sequence_shake_track(10)
		event.shake_camera_sequence(0.0, 10.3, 0.0, 90)
		checkpoint = 40
		wait.frames(30)
		event.rotate_object_sequence(8, 0.0, 0.0, 0.06, 60)
		checkpoint = 41
		wait.frames(60)
		event.set_character_active(0, 47)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.play_sound_effect(sound_bank, 18)
		event.stop_sound_effect(sound_bank, 14)
		event.set_camera_sequence_position(-1938.53, 42.72, 1126.84)
		event.set_camera_sequence_look_at(-1989.75, 48.9, 1098.63)
		event.set_object_sequence_rotation(17, 0.0, 1.92, 0.0)
		event.set_character_active(1, 33)
		event.set_object_handle_visible(14, 0)
		event.set_object_sequence_position(17, -2458.92, 167.76, 852.48)
		event.play_sound_effect(sound_bank, 19)
		event.set_object_sequence_motion(17, "横から縦移動", 6)
		event.queue_object_sequence_next_motion(17, "狙う", 6)
		event.queue_object_sequence_next_motion(17, "狙い立ち", 6)
		checkpoint = 42
		object.wait_until_done(17)
		event.stop_sound_effect(sound_bank, 19)
		event.set_character_position(40, -2279.73, 181.5, 788.22)
		event.set_character_rotation(40, 0.0, 1.9, 0.0)
		event.set_character_position(43, -2279.73, 181.5, 788.22)
		event.set_character_rotation(43, 0.0, 1.9, 0.0)
		event.set_character_active(1, 40)
		event.play_sound_effect(sound_bank, 20)
		event.set_character_motion(40, "発射", 6, -1, 1)
		event.set_object_sequence_motion(17, "発射", 6)
		event.queue_object_sequence_next_motion(17, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		checkpoint = 43
		wait.frames(5)
		event.set_character_active(1, 43)
		event.move_object_sequence(19, -1846.06, 191.5, 633.95, 30)
		checkpoint = 44
		wait.frames(60)
		event.set_character_active(0, 43)
		event.play_sound_effect(sound_bank, 20)
		event.set_character_motion(40, "発射", 6, -1, 1)
		event.set_object_sequence_motion(17, "発射", 6)
		event.queue_object_sequence_next_motion(17, "狙い立ち", 6)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 60)
		checkpoint = 45
		wait.frames(5)
		event.set_character_active(1, 43)
		event.set_character_position(43, -2279.73, 181.5, 788.22)
		event.set_character_rotation(43, 0.0, 1.9, 0.0)
		event.move_object_sequence(19, -1846.06, 191.5, 633.95, 30)
		checkpoint = 46
		wait.frames(60)
		event.set_character_active(0, 40)
		event.set_character_active(0, 43)
		event.stop_sound_effect(sound_bank, 18)
		event.play_sound_effect(sound_bank, 21)
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
		checkpoint = 47
		wait.frames(60)
		event.clear_object_sequence_path(19)
		event.set_object_sequence_object(19, 16)
		event.release_camera_sequence_follow_object()
		event.set_event_projection(saved_projection)
		event.set_camera_sequence_position(-207.36, 438.78, -44.18)
		event.set_camera_sequence_look_at(-170.18, 431.53, -74.54)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "はっと顔")
		event.set_object_sequence_texture_animation(5, 1, "通常目パチ")
		event.set_object_sequence_motion(5, "ふせぐ", 6)
		event.queue_object_sequence_next_motion(5, "ふせぐL", 4)
		checkpoint = 48
		wait.frames(30)
		event.set_camera_sequence_position(-87.05, 438.78, 734.67)
		event.set_camera_sequence_look_at(-222.41, 431.53, -65.71)
		event.set_character_position(35, -280.28, 480.68, 182.19)
		event.set_character_rotation(35, 0.0, -1.68, 0.0)
		event.set_character_motion(35, "バリア", 2, -1, 1)
		event.set_character_active(1, 35)
		event.delay_camera_sequence_shake_track(10)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 120)
		checkpoint = 49
		wait.frames(60)
		event.set_character_active(0, 35)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "くいしばり")
		event.set_object_sequence_texture_animation(5, 1, "通常目パチ")
		event.play_sound_effect(sound_bank, 22)
		event.set_camera_sequence_position(-180.2, 426.54, -51.75)
		event.set_camera_sequence_look_at(-169.56, 436.78, -92.29)
		checkpoint = 50
		wait.frames(90)
		event.play_sound_effect(sound_bank, 23)
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
		checkpoint = 51
		wait.frames(60)
		event.clear_object_sequence_path(19)
		event.set_object_sequence_object(19, 16)
		event.release_camera_sequence_follow_object()
		event.set_event_projection(saved_projection)
		event.set_camera_sequence_position(-1229.21, -140.51, 2033.13)
		event.set_camera_sequence_look_at(-413.29, 265.59, -747.44)
		event.set_character_position(48, -280.28, 480.68, 182.19)
		event.set_character_rotation(48, 0.0, -1.68, 0.0)
		checkpoint = 52
		wait.frames(29)
		event.set_character_active(0, 43)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 30)
		event.set_character_motion(48, "命中", 6, -1, 1)
		event.set_character_active(1, 48)
		checkpoint = 53
		wait.frames(30)
		event.set_camera_sequence_position(-499.15, 603.41, 701.23)
		event.set_camera_sequence_look_at(-222.41, 431.53, -65.71)
		event.start_crossfade(30)
		event.set_character_active(0, 48)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 30)
		event.set_character_motion(48, "命中", 6, -1, 1)
		event.set_character_active(1, 48)
		checkpoint = 54
		wait.frames(40)
	end, function(received: { any }): boolean
		if checkpoint <= 4 then
			wait.frames_skipping(35)
		end
		if checkpoint <= 5 then
			assign_confrontation_slots()
		end
		if checkpoint <= 6 then
			message.show_voiced_skipping(3560010)
		end
		if checkpoint <= 7 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 8 then
			message.show_voiced_skipping(3560020)
		end
		if checkpoint <= 9 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 10 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 11 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 12 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 13 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 14 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 15 then
			wait.background_load_skipping()
		end
		if checkpoint <= 16 then
			wait.background_load_skipping()
		end
		if checkpoint <= 17 then
			wait.background_load_skipping()
		end
		if checkpoint <= 18 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 19 then
			message.show_voiced_for_skipping(3560025, -1)
		end
		if checkpoint <= 20 then
			message.show_voiced_for_skipping(3560030, -1)
		end
		if checkpoint <= 21 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 22 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 23 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 24 then
			cutscene.skip_command(6)
		end
		if checkpoint <= 25 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 26 then
			message.show_voiced_skipping(3560040)
		end
		if checkpoint <= 27 then
			message.show_voiced_skipping(3560050)
		end
		if checkpoint <= 28 then
			message.show_voiced_skipping(3560055)
		end
		if checkpoint <= 29 then
			message.show_voiced_skipping(3560060)
		end
		if checkpoint <= 30 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 31 then
			wait.background_load_skipping()
		end
		if checkpoint <= 32 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 33 then
			message.show_voiced_for_skipping(3560070, -1)
		end
		if checkpoint <= 34 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 35 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 36 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 37 then
			wait.frames_skipping(20)
		end
		if checkpoint <= 38 then
			wait.frames_skipping(9)
		end
		if checkpoint <= 39 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 40 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 41 then
			cutscene.skip_command(17)
		end
		if checkpoint <= 42 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 43 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 44 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 45 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 46 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 47 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 48 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 49 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 50 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 51 then
			wait.frames_skipping(29)
		end
		if checkpoint <= 52 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 53 then
			wait.frames_skipping(40)
		end
		return true
	end)
	checkpoint = 55
	vm.entry(55)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	checkpoint = 56
	wait.frames(30)
	event.set_event_projection(saved_projection)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.stop_sound_effect(sound_bank, 4)
	event.stop_sound_effect(sound_bank, 14)
	event.stop_sound_effect(sound_bank, 18)
	event.stop_sound_effect(sound_bank, 19)
	event.stop_sound_effect(sound_bank, 25)
	event.stop_sound_effect(sound_bank, 30)
	event.stop_port_sound_effects(4)
	checkpoint = 57
	vm.wait(57)
	end_shield_scene()
end

--- Loads the characters, motions and messages for the scene after the battle.
local function load_mourning_assets()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mourning_max_slot = 0
		mourning_monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mourning_max_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", mourning_max_slot)
		event.attach_object_handle_to_character(0, mourning_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mourning_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", mourning_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", mourning_monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", mourning_monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", mourning_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", mourning_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", mourning_monica_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", mourning_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", mourning_monica_slot)
		event.attach_object_handle_to_character(1, mourning_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, mourning_monica_slot)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if playable_character == 1 then
		mourning_max_slot = 8
		mourning_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mourning_max_slot)
		event.load_equipment_model(5, 0, 1, "info", mourning_max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", mourning_max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", mourning_max_slot)
		event.load_equipment_model(5, 0, 3, "info", mourning_max_slot)
		event.load_equipment_model(5, 0, 2, "info", mourning_max_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mourning_max_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", mourning_max_slot)
		event.attach_object_handle_to_character(0, mourning_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mourning_max_slot)
		event.set_character_active(0, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", mourning_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", mourning_monica_slot)
		event.attach_object_handle_to_character(1, mourning_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, mourning_monica_slot)
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

--- Assigns the Max and Monica slots of the cannon barrage scene as the loader leaves them when Monica is playable.
local function assign_cannon_barrage_slots()
	mourning_max_slot = 0
	mourning_monica_slot = 8
	mourning_max_slot = 8
	mourning_monica_slot = 0
end

--- Unloads the post-battle scene characters, restores the map objects and ends the event.
local function end_mourning()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mourning_max_slot)
		event.set_character_active(0, mourning_monica_slot)
		event.delete_character_extension_packs(mourning_max_slot)
		event.delete_character_extension_packs(mourning_monica_slot)
		event.delete_character(mourning_monica_slot)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, mourning_monica_slot)
		event.set_character_active(0, mourning_max_slot)
		event.delete_character_extension_packs(mourning_max_slot)
		event.delete_character_extension_packs(mourning_monica_slot)
		event.delete_character(mourning_max_slot)
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

--- Plays the post-battle scene in which Guiltoni leaves and the party grieves over the fallen crest.
local function cutscene_mourning()
	local sound_bank: s32 = 0
	local saved_projection: f32 = 0
	local saved_time_of_day: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		load_mourning_assets()
		event.stop_music(0)
		checkpoint = 2
		wait.frames(4)
		event.load_music(152)
		event.load_map_sounds(3841)
		sound_bank = event.load_sound_effect_file_2(3841) or sound_bank
		event.stop_port_sound_effects(1)
		saved_projection = event.get_event_projection() or saved_projection
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
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
		event.set_character_active(1, mourning_max_slot)
		event.set_character_active(1, mourning_monica_slot)
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
		checkpoint = 3
		message.show_voiced_for(3560080, -1)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "大口パク")
		checkpoint = 4
		message.show_voiced_for(3560090, -1)
		event.reset_mouth_texture_animations()
		checkpoint = 5
		wait.frames(30)
		event.clear_effect_manager()
		event.set_character_active(1, 20)
		event.set_camera_sequence_position(-184.06, 415.94, -34.92)
		event.set_camera_sequence_look_at(-164.04, 432.34, -99.26)
		checkpoint = 6
		wait.frames(90)
		event.set_character_active(0, 20)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "つらい顔")
		event.play_sound_effect(sound_bank, 24)
		event.set_camera_sequence_position(-281.06, 415.94, -39.36)
		event.set_camera_sequence_look_at(-151.02, 432.34, -81.4)
		event.set_object_sequence_motion(5, "振り返る", 6)
		event.queue_object_sequence_next_motion(5, "振り返るＬ", 4)
		event.rotate_object_sequence(5, 0.0, 0.72, 0.0, 30)
		checkpoint = 7
		wait.frames(60)
		event.set_camera_sequence_position(-140.77, 480.0, -15.54)
		event.set_camera_sequence_look_at(-172.28, 437.71, -70.64)
		checkpoint = 8
		wait.frames(60)
		event.set_camera_sequence_position(-258.09, 457.17, -222.7)
		event.set_camera_sequence_look_at(-172.28, 437.71, -70.64)
		checkpoint = 9
		wait.frames(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-154.99, 437.5, -84.08, -289.74, 438.77, 31.8)
		event.add_camera_sequence_path_point(-154.99, 431.92, -84.08, -289.74, 433.19, 31.8)
		event.start_camera_sequence_path()
		checkpoint = 10
		wait.frames(100)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "つらいわらい顔")
		checkpoint = 11
		camera.wait_until_done()
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "目をとじる")
		checkpoint = 12
		wait.frames(60)
		event.set_object_sequence_motion(5, "倒れる", 6)
		checkpoint = 13
		wait.frames(60)
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
		checkpoint = 14
		wait.frames(70)
		event.start_crossfade(60)
		event.set_camera_sequence_position(-317.2, 237.89, -76.53)
		event.set_camera_sequence_look_at(-279.42, 243.39, -22.7)
		checkpoint = 15
		object.wait_until_done(5)
		event.set_motion_blur(0)
		event.set_object_handle_visible(9, 1)
		event.set_object_handle_visible(15, 0)
		event.set_event_projection(1502.9)
		event.play_sound_effect(sound_bank, 25)
		event.set_camera_sequence_position(-2744.52, 54.57, 1323.71)
		event.set_camera_sequence_look_at(-2754.11, 50.78, 1201.72)
		event.set_object_sequence_motion(1, "驚き", 4, -1, 1)
		checkpoint = 16
		wait.frames(60)
		event.set_object_sequence_motion(1, "驚きからギル見", 6)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 17
		message.show_voiced(3560100)
		event.reset_mouth_texture_animations()
		checkpoint = 18
		wait.frames(30)
		event.set_camera_sequence_position(-3256.95, 81.8, 1278.1)
		event.set_camera_sequence_look_at(-3074.49, 50.78, 1211.03)
		event.set_object_sequence_position(1, -3078.05, 25.75, 1210.56)
		event.set_object_sequence_rotation(1, 0.0, 1.92, 0.0)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(1, -2826.26, 25.75, 1118.0, 60)
		checkpoint = 19
		wait.frames(40)
		event.queue_object_sequence_next_motion(1, "走り飛び", 6)
		event.queue_object_sequence_next_motion(1, "走り飛びＬ", 4)
		checkpoint = 20
		object.wait_until_done(1)
		event.play_sound_effect(sound_bank, 26)
		event.set_character_active(0, mourning_monica_slot)
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
		checkpoint = 21
		wait.frames(60)
		event.play_sound_effect(sound_bank, 27)
		event.set_object_sequence_motion(1, "着地２", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_character_active(1, mourning_monica_slot)
		checkpoint = 22
		wait.frames(60)
		event.set_event_projection(saved_projection)
		event.set_camera_sequence_position(-4827.61, 834.34, 4724.51)
		event.set_camera_sequence_look_at(-4506.58, 801.95, 4143.46)
		event.rotate_object_sequence(8, 0.0, 0.0, 0.06, 90)
		checkpoint = 23
		wait.frames(90)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.set_character_active(1, 21)
		event.set_camera_sequence_position(-2612.44, 131.75, 1201.26)
		event.set_camera_sequence_look_at(-2814.26, 47.07, 1200.05)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 24
		message.show_voiced(3560110)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(7, "通常口パク")
		checkpoint = 25
		message.show_voiced(3560120)
		event.reset_mouth_texture_animations()
		checkpoint = 26
		wait.frames(30)
		event.set_camera_sequence_position(-2737.6, 60.99, 1210.81)
		event.set_camera_sequence_look_at(-2832.46, 47.07, 1205.56)
		event.set_mouth_texture_animations(6, "通常口パク")
		checkpoint = 27
		message.show_voiced(3560130)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 28)
		event.set_object_sequence_motion(6, "ふりかえり", 6)
		checkpoint = 28
		wait.frames(30)
		event.set_character_active(0, 21)
		event.set_character_active(0, 15)
		event.set_character_active(0, 22)
		event.set_object_handle_scale(14, 2.0, 2.0, 2.0)
		event.set_character_active(1, 19)
		event.set_camera_sequence_position(-8070.2, 232.04, 2437.64)
		event.set_camera_sequence_look_at(-3648.73, 198.15, 1794.44)
		event.play_sound_effect(sound_bank, 29)
		event.stop_sound_effect(sound_bank, 14)
		event.stop_sound_effect(sound_bank, 18)
		event.stop_sound_effect(sound_bank, 19)
		event.stop_sound_effect(sound_bank, 25)
		event.stop_sound_effect(sound_bank, 30)
		event.set_character_motion(19, "消える", 2, -1, 1)
		checkpoint = 29
		wait.frames(60)
		event.start_crossfade(60)
		event.set_object_handle_visible(8, 0)
		event.fade_out_music(90)
		checkpoint = 30
		wait.frames(90)
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
		checkpoint = 31
		vm.wait(31)
		checkpoint = 32
		vm.wait(32)
		checkpoint = 33
		vm.wait(33)
		checkpoint = 34
		vm.wait(34)
		event.load_music(52)
		event.play_music(0)
		event.set_character_active(0, 19)
		event.set_object_sequence_position(8, -13191.25, 25.75, 1213.17)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.play_sound_effect(sound_bank, 30, 10)
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
		checkpoint = 35
		message.show_voiced(3560140)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "目をあける")
		event.set_mouth_texture_animations(5, "くるし口パク")
		checkpoint = 36
		message.show_voiced(3560150)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "ひきよせる", 2)
		event.queue_object_sequence_next_motion(4, "ゆする", 4)
		event.set_object_sequence_motion(5, "ひきよせる", 2)
		event.queue_object_sequence_next_motion(5, "ゆする", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 37
		message.show_voiced(3560160)
		event.reset_mouth_texture_animations()
		checkpoint = 38
		object.wait_until_done(4)
		event.queue_object_sequence_next_motion(4, "ひきよせるL")
		event.queue_object_sequence_next_motion(5, "ひきよせるL")
		event.set_mouth_texture_animations(5, "くるし口パク")
		checkpoint = 39
		message.show_voiced(3560170)
		event.reset_mouth_texture_animations()
		checkpoint = 40
		wait.frames(30)
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
		checkpoint = 41
		message.show_voiced(3560180)
		event.reset_mouth_texture_animations()
		checkpoint = 42
		camera.wait_until_done()
		checkpoint = 43
		wait.frames(30)
		event.set_object_sequence_motion(4, "かかえ", 4)
		event.set_object_sequence_motion(5, "かかえ", 4)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "くるし顔")
		event.set_object_sequence_texture_animation(5, 1, "くるし目パチ")
		event.set_camera_sequence_position(-171.94, 29.88, 48.93)
		event.set_camera_sequence_look_at(-139.58, 8.06, 46.52)
		event.set_mouth_texture_animations(5, "くるし口パク")
		checkpoint = 44
		message.show_voiced(3560190)
		event.reset_mouth_texture_animations()
		checkpoint = 45
		wait.frames(30)
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
		checkpoint = 46
		message.show_voiced(3560200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(4, "ひきよせるL")
		event.set_object_sequence_motion(5, "ひきよせるL")
		event.play_sound_effect(sound_bank, 32)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 47
		message.show_voiced(3560210)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "なき目あき～なき目とじ")
		event.set_object_sequence_motion(4, "すりすり", 2)
		event.queue_object_sequence_next_motion(4, "すりすりL", 4)
		event.set_object_sequence_motion(5, "すりすり", 2)
		event.queue_object_sequence_next_motion(5, "すりすりL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 48
		message.show_voiced(3560215)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "なき目とじ～なき目あき")
		event.set_object_sequence_motion(4, "すりすり戻り", 2)
		event.queue_object_sequence_next_motion(4, "ひきよせるL", 4)
		event.set_object_sequence_motion(5, "すりすり戻り", 2)
		event.queue_object_sequence_next_motion(5, "ひきよせるL", 4)
		event.set_mouth_texture_animations(5, "くるし口パク")
		checkpoint = 49
		message.show_voiced(3560220)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "目をとじる")
		event.set_object_sequence_motion(4, "死ぬ", 2)
		event.queue_object_sequence_next_motion(4, "死ぬL", 4)
		event.set_object_sequence_motion(5, "死ぬ", 2)
		event.queue_object_sequence_next_motion(5, "死ぬL", 4)
		checkpoint = 50
		wait.frames(38)
		event.set_object_sequence_motion(4, "先生？", 2)
		event.queue_object_sequence_next_motion(4, "泣く", 2)
		event.queue_object_sequence_next_motion(4, "泣くL", 4)
		event.set_object_sequence_motion(5, "先生？", 2)
		event.queue_object_sequence_next_motion(5, "泣く", 2)
		event.queue_object_sequence_next_motion(5, "泣くL", 4)
		checkpoint = 51
		wait.frames(30)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "ごうきゅう目とじ")
		event.play_sound_effect(sound_bank, 33)
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
		checkpoint = 52
		message.show_voiced_for(3560230, -1)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-2715.35, 28.98, 1572.42, -83.24, 17.19, 9.16)
		event.add_camera_sequence_path_point(-4454.34, 28.98, 2605.23, -83.24, 17.19, 9.16)
		event.start_camera_sequence_path()
		event.fade_out_music(200)
		checkpoint = 53
		wait.frames(170)
		event.fade_out_screen(30)
		checkpoint = 54
		wait.frames(30)
		checkpoint = 55
		camera.wait_until_done()
		event.stop_sound_effect(sound_bank, 30)
		event.stop_music(0)
		checkpoint = 56
		vm.wait(56)
		checkpoint = 57
		vm.wait(57)
		checkpoint = 58
		vm.wait(58)
		checkpoint = 59
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
		event.set_character_active(0, mourning_max_slot)
		event.set_character_active(0, mourning_monica_slot)
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
		checkpoint = 60
		wait.frames(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-207.92, 44.8, 103.93, -142.38, 14.02, 55.1)
		event.add_camera_sequence_path_point(-170.48, 44.8, 76.03, -142.38, 14.02, 55.1)
		event.start_camera_sequence_path()
		checkpoint = 61
		camera.wait_until_done()
		event.set_mouth_texture_animations(4, "わらい口パク")
		checkpoint = 62
		message.show_voiced(3560270)
		event.reset_mouth_texture_animations()
		checkpoint = 63
		wait.frames(60)
		event.set_camera_sequence_position(-27.09, 20.37, 12.51)
		event.set_camera_sequence_look_at(-106.92, 28.16, 40.78)
		event.set_mouth_texture_animations(4, "わらい口パク")
		checkpoint = 64
		message.show_voiced(3560280)
		event.reset_mouth_texture_animations()
		checkpoint = 65
		wait.frames(30)
		event.set_camera_sequence_position(-132.45, 11.9, 87.83)
		event.set_camera_sequence_look_at(-142.38, 10.03, 55.1)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "目あき～かなし目とじ")
		event.set_object_sequence_motion(4, "下向く", 6)
		event.queue_object_sequence_next_motion(4, "下向くL", 4)
		event.set_mouth_texture_animations(4, "わらい口パク")
		checkpoint = 66
		message.show_voiced(3560290)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "わらい口パク")
		checkpoint = 67
		message.show_voiced(3560295)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "わらい口パク")
		checkpoint = 68
		message.show_voiced(3560300)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "かなし目とじ～目あき")
		event.set_object_sequence_motion(4, "下向く戻り", 6)
		event.queue_object_sequence_next_motion(4, "ひざまくら", 4)
		event.set_mouth_texture_animations(4, "わらい口パク")
		checkpoint = 69
		message.show_voiced(3560310)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "涙目あき～目とじ")
		event.set_object_sequence_motion(4, "涙をふく", 6)
		event.queue_object_sequence_next_motion(4, "ひざまくら", 4)
		checkpoint = 70
		wait.frames(60)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 1, "わらい顔")
		event.set_object_sequence_texture_animation(4, 1, "通常目パチ")
		event.set_camera_sequence_position(-27.09, 20.37, 12.51)
		event.set_camera_sequence_look_at(-106.92, 28.16, 40.78)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 71
		message.show_voiced(3560320)
		event.reset_mouth_texture_animations()
		checkpoint = 72
		wait.frames(60)
		event.set_camera_sequence_position(-169.91, 44.8, 75.61)
		event.set_camera_sequence_look_at(-142.38, 14.02, 55.1)
		event.move_camera_sequence_eased(-189.8, 92.55, 87.58, -142.38, 14.02, 55.1, 200, 2, 1.0)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 73
		message.show_voiced(3560330)
		event.reset_mouth_texture_animations()
		checkpoint = 74
		camera.wait_until_done()
		event.set_camera_sequence_position(-1140.72, -772.93, 5162.45)
		event.set_camera_sequence_look_at(-1053.47, -759.54, 4629.56)
		event.move_camera_sequence_eased(-1140.72, -772.93, 5162.45, -1053.47, -306.64, 4629.56, 200, 2, 1.0)
		event.fade_out_music(200)
		checkpoint = 75
		wait.frames(200)
		event.stop_music(0)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			assign_cannon_barrage_slots()
			wait.frames_skipping(4)
		end
		if checkpoint <= 2 then
			message.show_voiced_for_skipping(3560080, -1)
		end
		if checkpoint <= 3 then
			message.show_voiced_for_skipping(3560090, -1)
		end
		if checkpoint <= 4 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 5 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 6 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 7 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 8 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 9 then
			wait.frames_skipping(100)
		end
		if checkpoint <= 10 then
			wait.background_load_skipping()
		end
		if checkpoint <= 11 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 12 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 13 then
			wait.frames_skipping(70)
		end
		if checkpoint <= 14 then
			cutscene.skip_command(5)
		end
		if checkpoint <= 15 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 16 then
			message.show_voiced_skipping(3560100)
		end
		if checkpoint <= 17 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 18 then
			wait.frames_skipping(40)
		end
		if checkpoint <= 19 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 20 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 21 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 22 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 23 then
			message.show_voiced_skipping(3560110)
		end
		if checkpoint <= 24 then
			message.show_voiced_skipping(3560120)
		end
		if checkpoint <= 25 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 26 then
			message.show_voiced_skipping(3560130)
		end
		if checkpoint <= 27 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 28 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 29 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 34 then
			message.show_voiced_skipping(3560140)
		end
		if checkpoint <= 35 then
			message.show_voiced_skipping(3560150)
		end
		if checkpoint <= 36 then
			message.show_voiced_skipping(3560160)
		end
		if checkpoint <= 37 then
			cutscene.skip_command(4)
		end
		if checkpoint <= 38 then
			message.show_voiced_skipping(3560170)
		end
		if checkpoint <= 39 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 40 then
			message.show_voiced_skipping(3560180)
		end
		if checkpoint <= 41 then
			wait.background_load_skipping()
		end
		if checkpoint <= 42 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 43 then
			message.show_voiced_skipping(3560190)
		end
		if checkpoint <= 44 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 45 then
			message.show_voiced_skipping(3560200)
		end
		if checkpoint <= 46 then
			message.show_voiced_skipping(3560210)
		end
		if checkpoint <= 47 then
			message.show_voiced_skipping(3560215)
		end
		if checkpoint <= 48 then
			message.show_voiced_skipping(3560220)
		end
		if checkpoint <= 49 then
			wait.frames_skipping(38)
		end
		if checkpoint <= 50 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 51 then
			message.show_voiced_for_skipping(3560230, -1)
		end
		if checkpoint <= 52 then
			wait.frames_skipping(170)
		end
		if checkpoint <= 53 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 54 then
			wait.background_load_skipping()
		end
		if checkpoint <= 59 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 60 then
			wait.background_load_skipping()
		end
		if checkpoint <= 61 then
			message.show_voiced_skipping(3560270)
		end
		if checkpoint <= 62 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 63 then
			message.show_voiced_skipping(3560280)
		end
		if checkpoint <= 64 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 65 then
			message.show_voiced_skipping(3560290)
		end
		if checkpoint <= 66 then
			message.show_voiced_skipping(3560295)
		end
		if checkpoint <= 67 then
			message.show_voiced_skipping(3560300)
		end
		if checkpoint <= 68 then
			message.show_voiced_skipping(3560310)
		end
		if checkpoint <= 69 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 70 then
			message.show_voiced_skipping(3560320)
		end
		if checkpoint <= 71 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 72 then
			message.show_voiced_skipping(3560330)
		end
		if checkpoint <= 73 then
			wait.background_load_skipping()
		end
		if checkpoint <= 74 then
			wait.frames_skipping(200)
		end
		return true
	end)
	checkpoint = 76
	vm.entry(76)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	checkpoint = 77
	wait.frames(30)
	event.set_event_projection(saved_projection)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	event.stop_port_sound_effects(1)
	event.skip_next_map_sound_load()
	event.skip_next_music_load()
	event.clear_effect_manager()
	event.set_object_handle_visible(9, 1)
	event.set_object_handle_visible(15, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.stop_sound_effect(sound_bank, 14)
	event.stop_sound_effect(sound_bank, 18)
	event.stop_sound_effect(sound_bank, 19)
	event.stop_sound_effect(sound_bank, 25)
	event.stop_sound_effect(sound_bank, 30)
	event.set_motion_blur(0)
	checkpoint = 78
	vm.wait(78)
	checkpoint = 79
	end_mourning()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Swaps between Max and Monica with a sepia transition, saving each character position and facing.
local function switch_playable_character()
	local playable_character: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.init_sepia_effect(5)
	event.start_sepia_effect()
	vm.wait(1)
	vm.wait(2)
	playable_character = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 or playable_character == 3 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			saved_monica_x = out1 or saved_monica_x
			saved_monica_y = out2 or saved_monica_y
			saved_monica_z = out3 or saved_monica_z
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			saved_monica_rotation = out2 or saved_monica_rotation
		end
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.set_character_change_unmasked(0, 1)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(1, 0)
		event.set_character_change_unmasked(3, 0)
		event.set_character_position(0, saved_max_x, saved_max_y, saved_max_z)
		event.set_character_rotation(0, 0.0, saved_max_rotation, 0.0)
		event.load_map_sounds(3690)
	else
		do
			local out1, out2, out3 = event.get_character_position(0)
			saved_max_x = out1 or saved_max_x
			saved_max_y = out2 or saved_max_y
			saved_max_z = out3 or saved_max_z
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			saved_max_rotation = out2 or saved_max_rotation
		end
		event.switch_dungeon_main_character(1)
		event.set_playable_character(1)
		event.set_character_change_unmasked(0, 0)
		event.set_character_change_unmasked(2, 0)
		event.set_character_change_unmasked(1, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_character_position(0, saved_monica_x, saved_monica_y, saved_monica_z)
		event.set_character_rotation(0, 0.0, saved_monica_rotation, 0.0)
		event.load_map_sounds(3691)
	end
	event.reset_dungeon_collision_primitives()
	event.set_character_motion(0, "かまえ立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 20.0)
	do
		local out1, out2, out3 = event.get_previous_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_previous_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.end_sepia_effect()
	event.start_crossfade(1, 1, 20)
	vm.wait(3)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing because the map needs no load-time setup.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.initialize_map = initialize_map
script[99] = script.initialize_map

--- Places the player at the origin and fades the screen in when no event number is given.
function script.default_event()
	event.initialize_event()
	event.set_character_position(0, 0.0, 0.0, 0.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.fade_in_screen(30)
	vm.wait(1)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = cutscene_guiltoni_and_jamming_aboard_ship

--- Stops the music, clears the event monsters and sends the player to the georama editor, returning at event 504.
function script.go_to_georama_edit()
	local playable_character: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_music(10)
	event.fade_out_screen(10)
	wait.frames(10)
	event.stop_music(0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 then
		event.switch_dungeon_main_character(0)
	end
	if playable_character == 3 then
		event.switch_dungeon_main_character(1)
	end
	event.clear_event_battle_monsters(-1)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor = event.get_dungeon_floor() or floor
	event.set_dungeon_floor_info(stage_id, floor, 5, 2)
	vm.wait(2)
	event.go_to_georama_edit(62, 504)
end
script[501] = script.go_to_georama_edit

--- Event 502, which map data, a script or the engine runs by number.
script.cutscene_cannon_barrage = cutscene_cannon_barrage
script[502] = script.cutscene_cannon_barrage

--- Plays the confrontation and duel scenes, then places the player as Monica and spawns the boss monsters for the fight.
function script.start_guiltoni_battle()
	local saved_time_of_day: f32 = 0
	local playable_character: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		initialize_map()
		checkpoint = 1
		cutscene_guiltoni_confrontation()
		checkpoint = 2
		cutscene_duel_with_guiltoni()
		event.attach_object_handle_to_map_part_2(0, "p01_battleship")
		event.set_object_handle_position(0, -2194.9, 487.8, -474.2)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.set_event_saved_time_of_day(saved_time_of_day)
		event.set_time_of_day_advancing(0)
		event.set_time_of_day(18.0)
		checkpoint = 3
		vm.wait(3)
		event.initialize_event()
		checkpoint = 4
		vm.wait(4)
		event.stop_music(0)
		checkpoint = 5
		wait.frames(4)
		event.load_music(190)
		event.play_music(0)
		event.load_map_sounds(3691)
		event.set_function_point_enabled("", "func0", 0)
		event.set_function_point_enabled("", "func2", 1)
		event.set_function_point_enabled("", "func3", 1)
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 1 then
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
		if checkpoint <= 5 then
			if checkpoint <= 1 then
				checkpoint = 2
				cutscene_duel_with_guiltoni()
				return vm.continue_with(function()
					event.attach_object_handle_to_map_part_2(0, "p01_battleship")
					event.set_object_handle_position(0, -2194.9, 487.8, -474.2)
					event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
					saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
					event.set_event_saved_time_of_day(saved_time_of_day)
					event.set_time_of_day_advancing(0)
					event.set_time_of_day(18.0)
					checkpoint = 3
					vm.wait(3)
					event.initialize_event()
					checkpoint = 4
					vm.wait(4)
					event.stop_music(0)
					checkpoint = 5
					wait.frames(4)
					event.load_music(190)
					event.play_music(0)
					event.load_map_sounds(3691)
					event.set_function_point_enabled("", "func0", 0)
					event.set_function_point_enabled("", "func2", 1)
					event.set_function_point_enabled("", "func3", 1)
					playable_character = event.get_playable_character() or playable_character
					if playable_character ~= 1 then
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
			if checkpoint <= 4 then
				wait.frames_skipping(4)
			end
			return 0
		end
		return nil
	end)
end
script[503] = script.start_guiltoni_battle

--- Restores the time of day and plays the barrier and post-battle scenes before returning to the d03b01 map.
function script.cutscene_after_georama_edit()
	local saved_time_of_day: f32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.stop_music(0)
		saved_time_of_day = event.get_event_saved_time_of_day() or saved_time_of_day
		event.set_time_of_day(saved_time_of_day)
		checkpoint = 1
		cutscene_crest_shields_party()
		checkpoint = 2
		cutscene_mourning()
		event.jump_to_map_3(-1, "d03b01", 503)
		checkpoint = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				checkpoint = 2
				cutscene_mourning()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "d03b01", 503)
					checkpoint = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[504] = script.cutscene_after_georama_edit

--- Swaps the playable character and shows the protect-Lin hint the first time.
function script.switch_character_with_hint()
	local hint_shown_flag: s32 = 0
	switch_playable_character()
	hint_shown_flag = event.get_save_flag(64) or hint_shown_flag
	if hint_shown_flag == 0 then
		wait.frames(20)
		event.set_dungeon_pause_flags(3, 1)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "Proteggi Lin dal Fuoco maligno!")
		message.show_and_wait(0, -1, 8, 0, 0)
		event.set_save_flag(64, 1)
		event.set_dungeon_pause_flags(3, 0)
	end
end
script[510] = script.switch_character_with_hint

--- Plays the boss defeat message and game over screen, then waits for a button press and exits the scene.
function script.show_boss_game_over()
	local image_block: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.fade_out_music(30)
	event.start_background_file_loads_3(
		"snd2/bgm/bg_060.sound.json",
		"textures/dungeon/image/gameover/gameover_1.json",
		"event/boss_btl_lose_1.txt"
	)
	event.show_dungeon_status_bar(0, 0.033333335)
	wait.frames(30)
	wait.background_load()
	event.stop_music(0)
	event.load_music_pack(60)
	message.set_window_mode(0, 7)
	event.load_message_file(0, 5, "event/boss_btl_lose_1.txt")
	message.show_voiced_with_button_prompt(3520430, -1, 10)
	wait.frames(10)
	event.load_message_file(0, -1)
	event.play_music(0)
	image_block = event.load_event_image_4(5, "textures/dungeon/image/gameover/gameover_1.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "gameover1", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
	event.set_event_sprite_size(0, 576, 128)
	event.set_event_sprite_position(0, -320, 208)
	event.set_event_sprite_draw_pass(0, 1)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, 288, 208, 0.0, 20)
	wait.frames(30)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "gameover1", image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
	event.set_event_sprite_size(1, 576, 64)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 1)
	event.attach_object_handle_to_sprite(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
	wait.frames(120)
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(7)
		end
	end
	event.fade_out_music(30)
	event.fade_out_screen(30)
	wait.frames(30)
	event.stop_music(0)
	event.set_scene_exit_flag(1)
	event.finish_event()
end
script[520] = script.show_boss_game_over

--- Plays a random voiced defeat line when Monica is playable and a silent defeat sequence otherwise.
function script.show_defeat_dialogue()
	local playable_character: s32 = 0
	local random_roll: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 or playable_character == 3 then
			random_roll = event.get_random_number_int(100) or random_roll
			if vm.imod(random_roll, 2) == 0 then
				checkpoint = 1
				dungeon.handle_defeat_with_dialogue_voiced(0, 8530100)
			else
				checkpoint = 2
				dungeon.handle_defeat_with_dialogue_voiced(0, 8530110)
			end
		else
			checkpoint = 3
			dungeon.handle_defeat_with_dialogue_silent(0)
		end
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8530110)
			end
			if checkpoint <= 2 then
				dungeon.skip_defeat_dialogue_sequence_silent(0)
			end
			return 0
		end
		return nil
	end)
end
script[1200] = script.show_defeat_dialogue

--- Plays the barrier and post-battle scenes, then returns to the d03b01 map.
function script.cutscene_after_battle_replay()
	local checkpoint: number = 0
	return vm.guard(function()
		event.stop_music(0)
		checkpoint = 1
		cutscene_crest_shields_party()
		checkpoint = 2
		cutscene_mourning()
		event.jump_to_map_3(-1, "d03b01", 503)
		checkpoint = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				checkpoint = 2
				cutscene_mourning()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "d03b01", 503)
					checkpoint = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[13560] = script.cutscene_after_battle_replay

--- Sets up the boss fight directly with preset stats, items and equipment, placing the player as Monica.
function script.start_battle_with_preset_party()
	local item_count: s32 = 0
	local playable_character: s32 = 0
	initialize_map()
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
	item_count = event.get_item_count(270) or item_count
	if item_count < 20 then
		event.add_inventory_item(270, vm.i32(20 - item_count))
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
	playable_character = event.get_playable_character() or playable_character
	if playable_character ~= 1 then
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
script[23030] = script.start_battle_with_preset_party

return script
