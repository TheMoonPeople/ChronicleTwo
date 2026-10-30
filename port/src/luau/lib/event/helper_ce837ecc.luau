--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_ce837ecc()
	event.initialize_event()
	vm.wait(1)
	event.fade_in_screen(15)
	event.set_camera_sequence_position(-564.69, 162.76, -362.47)
	event.set_camera_sequence_look_at(-556.95, 162.37, -243.12)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -558.43, 132.37, -264.95)
	event.set_object_sequence_rotation(0, 0.0, 0.13, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.move_object_sequence(0, -556.95, 132.37, -243.12, 30)
	wait_frames(30)
	event.reset_follow_camera(0)
end

return helper_ce837ecc
