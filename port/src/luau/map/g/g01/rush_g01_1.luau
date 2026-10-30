--!strict
-- map/g/g01/rush_g01_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ca202fe = require("@lib/event/helper_1ca202fe")
local helper_4a3f6e53 = require("@lib/event/helper_4a3f6e53")
local helper_58984813 = require("@lib/event/helper_58984813")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_938babbf = require("@lib/event/helper_938babbf")
local helper_9ca592a1 = require("@lib/event/helper_9ca592a1")
local helper_c72a3649 = require("@lib/event/helper_c72a3649")
local helper_d1cc53b1 = require("@lib/event/helper_d1cc53b1")
local helper_fa983e23 = require("@lib/event/helper_fa983e23")

local global2: s32 = 0
local global3: s32 = 0

--- Helper function.
local function helper_1a6c4()
	local active_chr_no: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.clear_camera_sequence()
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 9
		event.load_character_motion_pack(5, "event/e200/e208/e208_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, global2)
		event.load_character(5, "chara/c02_base.gltf", "info", global3)
		event.load_character_motion_pack(5, "event/e200/e208/e208_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_equipment_model(5, 1, 4, "info", global3)
		event.load_equipment_model(5, 1, 3, "info", global3)
		event.load_equipment_model(5, 1, 2, "info", global3, 37)
		event.set_character_active(0, global3)
		event.set_character_active(1, 37)
	end
	if active_chr_no == 1 then
		global2 = 8
		global3 = 0
		event.load_character(5, "chara/c01_base.gltf", "info", global2)
		event.load_character_motion_pack(5, "event/e200/e208/e208_mints.gltf", "info", global2)
		event.attach_object_handle_to_character(0, global2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_equipment_model(5, 0, 4, "info", global2)
		event.load_equipment_model(5, 0, 3, "info", global2)
		event.load_equipment_model(5, 0, 2, "info", global2, 37)
		event.set_character_active(0, global2)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/e200/e208/e208_monica.gltf", "info", global3)
		event.attach_object_handle_to_character(1, global3)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, global3)
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

--- Helper function.
local function helper_186e8()
	event.set_object_sequence_motion(0, "小人見立ち", 4, -1.0, 1)
	event.set_object_sequence_motion(1, "小人見立ち", 4, -1.0, 1)
	helper_888ab2a3(15)
	event.set_object_sequence_motion(1, "のぞきこむ", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "のぞきこむL", 0)
	helper_888ab2a3(9)
	helper_888ab2a3(30)
	event.set_character_active(1, global2)
	event.set_camera_sequence_position(-9.46, 11.43, 119.95)
	event.set_camera_sequence_look_at(-13.26, 17.25, 155.84)
	event.set_object_sequence_position(0, -5.92, 0.0, 176.73)
	event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
	event.set_object_sequence_position(1, -22.63, 0.0, 162.64)
	event.set_object_sequence_rotation(1, 0.0, 2.2, 0.0)
	event.set_object_sequence_position(2, -4.1, 0.0, 153.36)
	event.set_object_sequence_rotation(2, 0.0, -0.96, 0.0)
	event.set_character_active(1, global2)
	event.set_camera_sequence_position(42.75, 27.67, 174.35)
	event.set_camera_sequence_look_at(-9.0, 19.49, 158.24)
	event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
	event.set_object_sequence_position(2, -22.63, 0.0, 162.64)
	event.set_object_sequence_rotation(2, 0.0, 2.2, 0.0)
	event.set_object_sequence_motion(1, "ひげを引っ張る", 6, -1.0, 1)
	event.queue_object_sequence_next_motion(1, "ひげを引っ張るL", 0)
	event.set_object_sequence_motion(2, "ひげを引っ張る", 6)
	event.queue_object_sequence_next_motion(2, "ひげを引っ張るL", 0)
	helper_888ab2a3(30)
	event.set_object_sequence_position(0, -5.92, 0.0, 176.73)
	event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
	event.set_character_active(1, global2)
end

--- Helper function.
local function helper_1a344()
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.set_character_active(1, global2)
		event.set_character_active(0, global3)
		event.set_character_active(0, 39)
		event.delete_character_extension_packs(global2)
		event.delete_character_extension_packs(global3)
		event.delete_character(global3)
		event.delete_character(39)
		event.delete_character(37)
	end
	if active_chr_no == 1 then
		event.set_character_active(1, global3)
		event.set_character_active(0, global2)
		event.set_character_active(0, 39)
		event.delete_character_extension_packs(global2)
		event.delete_character_extension_packs(global3)
		event.delete_character(global2)
		event.delete_character(39)
		event.delete_character(37)
	end
end

--- Helper function.
local function helper_1b56c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	vm.section(function()
		event.set_save_flag(208, 1)
		event.initialize_event()
		helper_1a6c4()
		do
			local out1, out2, out3, out4 = event.get_georama_part_position("p01_g010701")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
			rot_y = out4 or rot_y
		end
		event.set_event_world_coordinate(pos_x, pos_y, pos_z, rot_y)
		event.fade_in_screen(15)
		event.enable_drama_skip()
		event.set_character_active(1, global2)
		event.set_character_active(1, global3)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-26.67, 133.42, 142.95)
		event.set_camera_sequence_look_at(-0.63, 135.46, 70.07)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		helper_4a3f6e53()
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-252.25, 55.22, 51.91)
		event.set_camera_sequence_look_at(-123.33, 64.43, 84.03)
		event.set_object_sequence_position(0, -27.16, 0.0, 167.75)
		event.set_object_sequence_rotation(0, 0.0, 2.56, 0.0)
		event.set_object_sequence_position(1, 6.29, 0.0, 191.97)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		helper_c72a3649()
		event.set_camera_sequence_position(-30.99, 21.79, 154.87)
		event.set_camera_sequence_look_at(3.56, 19.83, 178.37)
		event.set_object_sequence_position(0, -1.67, 0.0, 172.28)
		event.set_object_sequence_rotation(0, 0.0, -2.76, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -10.54, 0.0, 179.7)
		event.set_object_sequence_rotation(1, 0.0, -3.0, 0.0)
		helper_d1cc53b1()
		event.set_character_active(0, global2)
		event.set_character_active(0, global3)
		event.set_camera_sequence_position(-5.73, 21.1, 190.37)
		event.set_camera_sequence_look_at(5.68, 14.14, 150.47)
		event.set_object_sequence_position(2, 4.08, 0.0, 144.54)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		helper_58984813()
		event.set_character_active(1, global2)
		event.set_character_active(1, global3)
		event.set_character_active(1, 39)
		event.set_camera_sequence_position(-14.34, 22.74, 112.18)
		event.set_camera_sequence_look_at(-13.7, 20.99, 152.2)
		event.set_object_sequence_position(0, -5.92, 0.0, 176.73)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(1, -22.63, 0.0, 162.64)
		event.set_object_sequence_rotation(1, 0.0, 2.2, 0.0)
		event.set_object_sequence_position(2, -4.1, 0.0, 153.36)
		event.set_object_sequence_rotation(2, 0.0, -0.96, 0.0)
		helper_186e8()
		event.set_character_active(0, global3)
		event.set_character_active(0, 37)
		event.set_camera_sequence_position(-24.6, 25.86, 163.37)
		event.set_camera_sequence_look_at(-10.01, 18.7, 153.1)
		helper_1ca202fe()
		event.set_character_active(1, global3)
		event.set_character_active(1, 37)
		event.set_camera_sequence_position(-10.38, 27.34, 107.56)
		event.set_camera_sequence_look_at(-17.84, 21.69, 164.18)
		event.set_object_sequence_position(1, -24.14, 0.0, 161.49)
		event.set_object_sequence_rotation(1, 0.0, 2.44, 0.0)
		helper_9ca592a1()
		event.set_character_active(0, global2)
		event.set_camera_sequence_position(3.85, 19.27, 183.67)
		event.set_camera_sequence_look_at(2.04, 14.46, 113.61)
		event.set_object_sequence_position(2, 4.08, 0.0, 144.54)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		helper_938babbf()
		event.set_character_active(1, global2)
		event.set_camera_sequence_position(10.38, 30.2, 209.13)
		event.set_camera_sequence_look_at(20.26, 6.47, 120.39)
		event.set_object_sequence_position(0, 33.4, 0.0, 163.7)
		event.set_object_sequence_rotation(0, 0.0, -2.52, 0.0)
		event.set_object_sequence_position(1, 19.36, 0.0, 168.87)
		event.set_object_sequence_rotation(1, 0.0, -2.76, 0.0)
		event.set_object_sequence_position(2, 4.08, 0.0, 144.54)
		event.set_object_sequence_rotation(2, 0.0, 0.36, 0.0)
		helper_fa983e23()
		event.cancel_drama_scene_skip()
	end)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.set_character_position(0, pos_x + vm.f32(21.55), pos_y + 0.0, pos_z + vm.f32(189.06))
	event.set_character_rotation(0, 0.0, -3.0 + rot_y, 0.0)
	vm.wait(11)
	helper_1a344()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event.fade_in_screen(30)
	helper_1b56c()
	event.load_event_script("g01/g01.stb", -1)
end

return script
