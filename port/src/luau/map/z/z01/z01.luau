--!strict
-- map/z/z01/z01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

--- Helper function.
local function helper_aac8()
	event.initialize_event()
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_active(0, 0)
	event.load_character(5, "event/lm/p00_01ev.gltf", "info", 8)
	event.set_character_active(1, 8)
	event.set_character_position(8, 0.0, 0.0, 0.0)
	event.set_character_rotation(8, 0.0, 0.0, 0.0)
	event.set_character_motion(8, "羽開き", 5)
	event.load_character(5, "event/lm/ef00.gltf", "info", 9)
	event.set_character_active(1, 9)
	event.set_character_position(9, 0.0, 0.0, 0.0)
	event.set_character_rotation(9, 0.0, 0.0, 0.0)
	event.load_character(5, "event/lm/2moon.gltf", "info", 10)
	event.set_character_active(1, 10)
	event.set_character_position(10, 0.0, 394.94, -1119.58)
	event.set_character_rotation(10, 0.0, 0.6, 0.0)
	event.set_character_scale(10, 40.0, 40.0, 40.0)
	event.load_character(5, "event/lm/hotaru_gg.gltf", "info", 11)
	event.set_character_active(11)
	event.load_character(5, "event/lm/hotaru_gg.gltf", "info", 12)
	event.set_character_active(12)
	event.load_character(5, "event/lm/hotaru_gg.gltf", "info", 13)
	event.set_character_active(13)
	event.load_character(5, "event/lm/hotaru_gg.gltf", "info", 14)
	event.set_character_active(14)
	event.set_character_position(11, 0.0, 0.0, 0.0)
	event.set_character_rotation(11, 0.0, 0.0, 0.0)
	event.set_character_position(12, 0.0, 0.0, 0.0)
	event.set_character_rotation(12, 0.0, 1.57, 0.0)
	event.set_character_position(13, 0.0, 0.0, 0.0)
	event.set_character_rotation(13, 0.0, -3.14, 0.0)
	event.set_character_position(14, 0.0, 0.0, 0.0)
	event.set_character_rotation(14, 0.0, 3.14, 0.0)
	event.attach_object_handle_to_character(0, 8)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(2, 10)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.rotate_object_sequence(2, 0.0, -0.002, 0.0, -1)
	event.set_camera_position(0.0, -10.44, 138.29)
	event.set_camera_look_at(0.0, 42.51, 0.0)
	helper_888ab2a3(30)
	event.clear_camera_sequence()
	event.move_camera_sequence_eased(0.0, 11.62, 87.3, 0.0, 42.51, 0.0, 120, 2, 1.0)
	event.move_object_sequence(2, -256.22, -5.2, -666.44, 300)
	event.set_character_motion(8, "羽開き", 2)
	vm.wait(2)
	helper_c956b4a2(32)
	event.set_character_active(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_aac8

return script
