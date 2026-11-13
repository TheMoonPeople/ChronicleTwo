--!strict
--- Moon Flower Palace field with the dungeon entrance and the exit to the train stop.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local moon_flower_palace_field = require("@lib/event/moon_flower_palace_field")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Plays the cutscene or places the player depending on saved flags.
function script.default_event()
	local flag_600: s32 = 0
	local flag_604: s32 = 0
	flag_600 = event.get_save_flag(600) or flag_600
	flag_604 = event.get_save_flag(604) or flag_604
	if flag_600 == 1 and flag_604 == 0 then
		moon_flower_palace_field.play_e604_cutscene()
	else
		if flag_604 == 1 then
			event.attach_object_handle_to_map_part_3(0, "p01_s3302-0", "s330208-m0")
			event.attach_object_handle_to_map_part_3(1, "p01_s3302-0", "s330208-m1")
			event.set_object_handle_rotation(0, 0.0, 0.61, 0.0)
			event.set_object_handle_rotation(1, 0.0, -0.61, 0.0)
		end
		character.place_standing_and_reset_cloth(0.0, 0.0, 2300.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = moon_flower_palace_field.play_red_time_gate_departure

--- Confirms and enters the dungeon.
function script.enter_dungeon()
	if moon_flower_palace_field.confirm_and_walk_forward() ~= 0 then
		event.skip_next_music_load()
		event.go_to_dungeon(5, -1, 500)
	end
end
script[200] = script.enter_dungeon

--- Confirms and returns to s31.
function script.leave_for_s31()
	if dungeon.confirm_exit_variant() ~= 0 then
		event.jump_to_map_2(-1, "s31")
	end
end
script[210] = script.leave_for_s31

--- Plays the e372 cutscene and jumps to f02.
function script.cutscene_e372()
	moon_flower_palace_field.play_e372_cutscene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "f02", 510)
	vm.wait(2)
end
script[510] = script.cutscene_e372

--- Event 16040, which map data, a script or the engine runs by number.
script[16040] = moon_flower_palace_field.play_e604_cutscene

return script
