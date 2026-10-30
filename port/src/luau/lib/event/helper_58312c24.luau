--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8b621cc7 = require("@lib/event/helper_8b621cc7")
local helper_b1ec446a = require("@lib/event/helper_b1ec446a")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_58312c24()
	local time: f32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(280, 1)
		event.initialize_event()
		helper_8b621cc7()
		event.enable_drama_skip()
		time = event.get_scene_time_of_day() or time
		if time > 23.0 or time < 3.0 then
			event.set_time_of_day(23.5)
		end
		event.set_character_active(0, 0)
		event.set_camera_sequence_position(-345.15, 101.35, 500.91)
		event.set_camera_sequence_look_at(-187.77, 66.45, 754.48)
		event.set_object_sequence_position(5, 1.3, 8.0, 700.0)
		event.set_object_sequence_position(2, -211.51, 0.0, 580.92)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(3, -179.62, 0.0, 849.1)
		event.set_object_sequence_rotation(3, 0.0, -3.04, 0.0)
		event.set_object_sequence_position(4, -127.36, 0.0, 848.26)
		event.set_object_sequence_rotation(4, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(2, "歩き", 0)
		event.set_object_sequence_motion(3, "会話2", 0)
		event.set_object_sequence_motion(4, "喜び", 0)
		event.start_crossfade(30)
		event.move_object_sequence(2, -178.31, 0.0, 745.86, 240, 1)
		helper_0382f327(2800410, -1)
		wait_objects(2)
		event.set_object_sequence_motion(2, "立ち")
		event.set_camera_speed(0)
		event.move_camera_sequence_eased(-345.15, 101.35, 500.91, -393.5, 319.63, 632.81, 240, 0, 0.4)
		helper_0382f327(2800420, -1)
		wait_camera()
		helper_888ab2a3(60)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	helper_b1ec446a()
	event.set_time_of_day(time)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

return helper_58312c24
