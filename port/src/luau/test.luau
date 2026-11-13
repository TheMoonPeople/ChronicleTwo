--!strict
--- A debugging script with message tests, a camera and character walk demo, and shortcuts into interior maps.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local wait = require("@lib/event/wait")

--- Issues a test command and opens the given message in the message window.
local function show_test_message(command_argument: s32, message_index: s32)
	event.call_command(800, 0, command_argument, message_index) -- retail: command 800 is not registered
	event.open_message_window_2(0, message_index)
	vm.wait(1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Shows test message 0.
function script.show_test_message_0()
	show_test_message(2, 0)
end
script[0] = script.show_test_message_0

--- Shows test message 1.
function script.show_test_message_1()
	show_test_message(3, 1)
end
script[1] = script.show_test_message_1

--- Shows test message 2.
function script.show_test_message_2()
	show_test_message(4, 2)
end
script[2] = script.show_test_message_2

--- Shows test message 3.
function script.show_test_message_3()
	show_test_message(5, 3)
end
script[3] = script.show_test_message_3

--- Shows test message 4.
function script.show_test_message_4()
	show_test_message(6, 4)
end
script[4] = script.show_test_message_4

--- Shows test message 5.
function script.show_test_message_5()
	show_test_message(7, 5)
end
script[5] = script.show_test_message_5

--- Holds the camera still, walks a character to a point, then pans the camera look-at between two positions.
function script.default_event()
	local progress: f32 = 0
	local duration: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local end_x: f32 = 0
	local end_y: f32 = 0
	local end_z: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	vm.wait(1)
	progress = 0.0
	duration = 300.0
	while progress <= duration do
		event.set_camera_position(168.64, 58.93, -170.8)
		event.set_camera_look_at(134.38, 0.0, 16.4)
		progress = vm.f32(progress + 1.0)
		vm.wait(2)
	end
	event.asq_initialize(0)
	event.asq_sync_character(0, 3)
	event.asq_set_position(0, 203.3, 0, -51.0)
	event.asq_set_rotation(0, 0.0)
	event.asq_motion_play(0, "歩き")
	event.asq_motion_trigger(0)
	event.asq_rotate_toward_position(0, 71.9, 0, 58.4, 0.1)
	event.asq_move(0, 71.9, 0, 58.4, 100)
	event.asq_motion_play(0, "立ち")
	event.asq_motion_trigger(0)
	start_x = vm.f32(203.3)
	end_x = vm.f32(71.9)
	start_y = vm.f32(97.4)
	end_y = vm.f32(146.2)
	start_z = -51.0
	end_z = vm.f32(58.4)
	progress = 0.0
	duration = 300.0
	while progress <= duration do
		pos_x = calc.interpolate(start_x, end_x, progress, duration)
		local _ = calc.interpolate(start_y, end_y, progress, duration)
		pos_z = calc.interpolate(start_z, end_z, progress, duration)
		event.set_camera_look_at(pos_x, 0, pos_z)
		progress = vm.f32(progress + 1.0)
		vm.wait(3)
	end
end

--- Waits briefly and jumps to interior map i01h01.
function script.enter_interior_i01h01()
	wait.for_frame_count(10)
	event.go_to_interior_map(-1, "i01h01", 123)
end
script[200] = script.enter_interior_i01h01

--- Waits briefly and jumps to interior map i02h01.
function script.enter_interior_i02h01()
	wait.for_frame_count(10)
	event.go_to_interior_map(-1, "i02h01", 123)
end
script[201] = script.enter_interior_i02h01

return script
