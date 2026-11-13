--!strict
--- Event script for the Palm Brinks square map m03, with its Starble appearance and Starbre climb cutscenes.

local vm = require("@lib/vm")
local palm_brinks_square = require("@lib/event/palm_brinks_square")
local wait = require("@lib/event/wait")

--- Does nothing.
local function do_nothing() end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.do_nothing = do_nothing
script[99] = script.do_nothing

--- Prints a debug marker on entry.
function script.default_event()
	do_nothing()
	print("e109a kita----------\n")
end

--- Waits for the button press that ends the town walk.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(32)
end

--- Shows the Starble character in a short skippable scene and then restores the player.
function script.cutscene_starble_appearance()
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
		wait.until_button_pressed(32)
		event.cancel_drama_scene_skip()
	end)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.delete_character(32)
	event.set_character_active(1, 0)
	event.fade_in_screen(30)
end
script[501] = script.cutscene_starble_appearance

--- Plays the Starbre climb cutscene and jumps to the interior i03h01a.
function script.cutscene_starbre_climb()
	palm_brinks_square.play_starbre_climb_cutscene()
	event.skip_villager_loading()
	vm.wait(2)
	event.go_to_interior_map(-1, "i03h01a", 500)
	vm.wait(3)
end
script[11091] = script.cutscene_starbre_climb

return script
