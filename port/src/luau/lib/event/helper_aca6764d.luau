--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_aca6764d()
	local time: f32 = 0
	vm.section(function()
		event.set_save_flag(540, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(300.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		vm.wait(1)
		event.change_directory("event/e500/e540/")
		event.attach_object_handle_to_map_part_2(0, "p03_s55")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.change_directory("")
		time = event.get_scene_time_of_day() or time
		event.set_time_of_day(24.0)
		event.set_time_of_day_advancing(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-403.87, 5081.46, 8018.1)
		event.set_camera_sequence_look_at(-207.83, 4340.06, 7830.0)
		event.enable_drama_skip()
		event.fade_in_screen(0)
		wait_frames(60)
		wait_frames(10)
		event.fade_out_screen(0)
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(524.9)
	event.set_object_handle_visible(0, 1)
	event.set_time_of_day(time)
	event.set_time_of_day_advancing(1)
	event.set_character_active(0)
end

return helper_aca6764d
