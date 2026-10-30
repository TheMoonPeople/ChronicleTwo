--!strict
-- map/m/m03/m03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7dfaaca0 = require("@lib/event/helper_7dfaaca0")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event_99()
	print("e109a kita----------\n")
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	vm.section(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/e100/e109/e109_starble.chr", "info", 32)
		event.attach_object_handle_to_character(0, 32)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		print("m03-e109a---------------------------------\n")
		event.enable_drama_skip()
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.set_camera_sequence_position(1984.9, 50.0, 3002.6)
		event.set_camera_sequence_look_at(1984.9, 30.0, 2882.6)
		event.set_object_sequence_position(0, 1984.9, 0.0, 2882.6)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		vm.wait(1)
		helper_c956b4a2(32)
		event.cancel_drama_scene_skip()
	end)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.delete_character(32)
	event.set_character_active(1, 0)
	event.fade_in_screen(30)
end

--- Event 11091, which map data, a script or the engine runs by number.
function script.event_11091()
	helper_7dfaaca0()
	event.skip_villager_loading()
	vm.wait(2)
	event.go_to_interior_map(-1, "i03h01a", 500)
	vm.wait(3)
end

return script
