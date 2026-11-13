--!strict
--- Cutscene in Sindain in which Mints and Monica meet Rococo and pull his beard.

local vm = require("@lib/vm")
local sindain = require("@lib/event/sindain")
local wait = require("@lib/event/wait")

local mints_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the playable characters, Rococo and the georama parts used by the scene.
local function load_scene_characters()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.clear_camera_sequence()
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_slot = 0
		monica_slot = 9
		event.load_character_motion_pack(5, "event/e200/e208/e208_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e208/e208_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_slot)
		event.load_character_motion_pack(5, "event/e200/e208/e208_mints.gltf", "info", mints_slot)
		event.attach_object_handle_to_character(0, mints_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_equipment_model(5, 0, 4, "info", mints_slot)
		event.load_equipment_model(5, 0, 3, "info", mints_slot)
		event.load_equipment_model(5, 0, 2, "info", mints_slot, 37)
		event.set_character_active(0, mints_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e208/e208_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e208/e208_rococo.gltf", "info", 39)
	event.attach_object_handle_to_character(2, 39)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_edit_map_part(6, "p01_g010701", "g010707-m")
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 6)
	event.set_object_sequence_position(10, 1.0461, 59.1891, 78.8974)
	event.set_object_sequence_rotation(10, 0.0, -1.5707964, 0.0)
	event.attach_object_handle_to_edit_map_part(7, "p01_g010701", "g010708-m")
	event.clear_object_sequence(11)
	event.set_object_sequence_object(11, 7)
	event.set_object_sequence_position(11, 1.0461, 59.1891, 78.8974)
	event.set_object_sequence_rotation(11, 0.0, -1.5707964, 0.0)
	event.load_message_file(0, 5, "event/e200/e208/e208.txt")
end

--- Plays the motions of the party watching and Rococo having his beard pulled.
local function play_beard_pulling_motions()
	event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "小人見立ち", 4, -1.0, 1)
	wait.for_frame_count(15)
	event.set_object_sequence_motion(1, "のぞきこむ", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "のぞきこむL", 0)
	wait.for_frame_count(9)
	wait.for_frame_count(30)
	event.set_character_active(1, mints_slot)
	event.set_camera_sequence_position(-9.46, 11.43, 119.95)
	event.set_camera_sequence_look_at(-13.26, 17.25, 155.84)
	event.set_object_sequence_position(0, -5.92, 0.0, 176.73)
	event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
	event.set_object_sequence_position(1, -22.63, 0.0, 162.64)
	event.set_object_sequence_rotation(1, 0.0, 2.2, 0.0)
	event.set_object_sequence_position(2, -4.1, 0.0, 153.36)
	event.set_object_sequence_rotation(2, 0.0, -0.96, 0.0)
	event.set_character_active(1, mints_slot)
	event.set_camera_sequence_position(42.75, 27.67, 174.35)
	event.set_camera_sequence_look_at(-9.0, 19.49, 158.24)
	event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
	event.set_object_sequence_position(2, -22.63, 0.0, 162.64)
	event.set_object_sequence_rotation(2, 0.0, 2.2, 0.0)
	event.set_object_sequence_motion(1, "ひげを引っ張る", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "ひげを引っ張るL", 0)
	event.set_object_sequence_motion(2, "ひげを引っ張る", 6)
	event.queue_object_sequence_next_motion(2, "ひげを引っ張るL", 0)
	wait.for_frame_count(30)
	event.set_object_sequence_position(0, -5.92, 0.0, 176.73)
	event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
	event.set_character_active(1, mints_slot)
end

--- Deletes the characters loaded for the scene.
local function unload_scene_characters()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 39)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(39)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, 39)
		event.delete_character_extension_packs(mints_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(mints_slot)
		event.delete_character(39)
		event.delete_character(37)
	end
end

--- Plays the whole scene of the party finding Rococo in Sindain and pulling his beard.
local function play_rococo_beard_scene()
	local part_x: f32 = 0
	local part_y: f32 = 0
	local part_z: f32 = 0
	local part_rotation_y: f32 = 0
	vm.section(function()
		event.set_save_flag(208, 1)
		event.initialize_event()
		load_scene_characters()
		do
			local out1, out2, out3, out4 = event.get_georama_part_position("p01_g010701")
			part_x = out1 or part_x
			part_y = out2 or part_y
			part_z = out3 or part_z
			part_rotation_y = out4 or part_rotation_y
		end
		event.set_event_world_coordinate(part_x, part_y, part_z, part_rotation_y)
		event.fade_in_screen(15)
		event.enable_drama_skip()
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-26.67, 133.42, 142.95)
		event.set_camera_sequence_look_at(-0.63, 135.46, 70.07)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		sindain.play_get_up_motion()
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-252.25, 55.22, 51.91)
		event.set_camera_sequence_look_at(-123.33, 64.43, 84.03)
		event.set_object_sequence_position(0, -27.16, 0.0, 167.75)
		event.set_object_sequence_rotation(0, 0.0, 2.56, 0.0)
		event.set_object_sequence_position(1, 6.29, 0.0, 191.97)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		sindain.play_look_down_and_jump_motion()
		event.set_camera_sequence_position(-30.99, 21.79, 154.87)
		event.set_camera_sequence_look_at(3.56, 19.83, 178.37)
		event.set_object_sequence_position(0, -1.67, 0.0, 172.28)
		event.set_object_sequence_rotation(0, 0.0, -2.76, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -10.54, 0.0, 179.7)
		event.set_object_sequence_rotation(1, 0.0, -3.0, 0.0)
		sindain.wait_31_frames()
		event.set_character_active(0, mints_slot)
		event.set_character_active(0, monica_slot)
		event.set_camera_sequence_position(-5.73, 21.1, 190.37)
		event.set_camera_sequence_look_at(5.68, 14.14, 150.47)
		event.set_object_sequence_position(2, 4.08, 0.0, 144.54)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		sindain.play_stand_motion_and_wait()
		event.set_character_active(1, mints_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-14.34, 22.74, 112.18)
		event.set_camera_sequence_look_at(-13.7, 20.99, 152.2)
		event.set_object_sequence_position(0, -5.92, 0.0, 176.73)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(1, -22.63, 0.0, 162.64)
		event.set_object_sequence_rotation(1, 0.0, 2.2, 0.0)
		event.set_object_sequence_position(2, -4.1, 0.0, 153.36)
		event.set_object_sequence_rotation(2, 0.0, -0.96, 0.0)
		play_beard_pulling_motions()
		event.set_character_active(0, monica_slot)
		event.set_character_active(0, 37)
		event.set_camera_sequence_position(-24.6, 25.86, 163.37)
		event.set_camera_sequence_look_at(-10.01, 18.7, 153.1)
		sindain.wait_47_frames()
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 37)
		event.set_camera_sequence_position(-10.38, 27.34, 107.56)
		event.set_camera_sequence_look_at(-17.84, 21.69, 164.18)
		event.set_object_sequence_position(1, -24.14, 0.0, 161.49)
		event.set_object_sequence_rotation(1, 0.0, 2.44, 0.0)
		sindain.play_release_hands_motion()
		event.set_character_active(0, mints_slot)
		event.set_camera_sequence_position(3.85, 19.27, 183.67)
		event.set_camera_sequence_look_at(2.04, 14.46, 113.61)
		event.set_object_sequence_position(2, 4.08, 0.0, 144.54)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		sindain.play_stand_up_and_tremble_motion()
		event.set_character_active(1, mints_slot)
		event.set_camera_sequence_position(10.38, 30.2, 209.13)
		event.set_camera_sequence_look_at(20.26, 6.47, 120.39)
		event.set_object_sequence_position(0, 33.4, 0.0, 163.7)
		event.set_object_sequence_rotation(0, 0.0, -2.52, 0.0)
		event.set_object_sequence_position(1, 19.36, 0.0, 168.87)
		event.set_object_sequence_rotation(1, 0.0, -2.76, 0.0)
		event.set_object_sequence_position(2, 4.08, 0.0, 144.54)
		event.set_object_sequence_rotation(2, 0.0, 0.36, 0.0)
		sindain.play_peek_and_run_away_motion()
		event.cancel_drama_scene_skip()
	end)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_character_position(0, part_x + vm.f32(21.55), part_y + 0.0, part_z + vm.f32(189.06))
	event.set_character_rotation(0, 0.0, -3.0 + part_rotation_y, 0.0)
	vm.wait(11)
	unload_scene_characters()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Plays the Rococo beard scene and loads the Sindain event script.
function script.start_rococo_beard_scene()
	event.fade_in_screen(30)
	play_rococo_beard_scene()
	event.load_event_script("g01/g01.stb", -1)
end
script[500] = script.start_rococo_beard_scene

return script
