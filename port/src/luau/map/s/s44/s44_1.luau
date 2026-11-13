--!strict
--- Moon Flower Palace flashback scenes.

local vm = require("@lib/vm")
local moon_flower_palace_flashback = require("@lib/event/moon_flower_palace_flashback")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Waits for a button press.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	event.set_camera_sequence_position(31.07, 49.02, 53.789978)
	event.set_camera_sequence_look_at(-33.5, 41.8, 200.70001)
	vm.wait(2)
	wait.until_button_pressed(64)
	event.clear_effect_manager()
	event.finish_event()
end

--- Plays the embrace scene and jumps to d06b03.
function script.cutscene_sun_andrea_embrace()
	moon_flower_palace_flashback.play_sun_andrea_embrace()
	event.jump_to_map_3(-1, "d06b03", 510)
end
script[500] = script.cutscene_sun_andrea_embrace

--- Plays the dialogue scene and loads d06b01.
function script.cutscene_sun_andrea_dialogue()
	moon_flower_palace_flashback.play_sun_andrea_dialogue()
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	vm.wait(2)
	event.load_dungeon_map("d06b01")
	event.load_event_script("d06b01/d06b01.stb", 512)
end
script[510] = script.cutscene_sun_andrea_dialogue

--- Plays the hide and seek scene and jumps to g05.
function script.cutscene_sun_andrea_hide_and_seek()
	moon_flower_palace_flashback.play_sun_andrea_hide_and_seek()
	event.jump_to_map_3(-1, "g05", 550)
	vm.wait(2)
end
script[550] = script.cutscene_sun_andrea_hide_and_seek

--- Plays the soldier escort scene and jumps to g05.
function script.cutscene_sun_soldier_escort()
	moon_flower_palace_flashback.play_sun_soldier_escort_scene()
	event.jump_to_map_3(-1, "g05", 560)
	vm.wait(2)
end
script[560] = script.cutscene_sun_soldier_escort

--- Plays the hide and seek and escort scenes in order.
function script.cutscene_hide_and_seek_then_soldier_escort()
	local resume_step: number = 0
	return vm.guard(function()
		resume_step = 1
		moon_flower_palace_flashback.play_sun_andrea_hide_and_seek()
		resume_step = 2
		moon_flower_palace_flashback.play_sun_soldier_escort_scene()
		event.jump_to_map_3(-1, "g05", 560)
		resume_step = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				resume_step = 2
				moon_flower_palace_flashback.play_sun_soldier_escort_scene()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "g05", 560)
					resume_step = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[570] = script.cutscene_hide_and_seek_then_soldier_escort

--- Event 17440, which map data, a script or the engine runs by number.
script[17440] = moon_flower_palace_flashback.play_sun_andrea_hide_and_seek

--- Replays the soldier escort scene and jumps to g05.
function script.replay_sun_soldier_escort()
	moon_flower_palace_flashback.play_sun_soldier_escort_scene()
	event.jump_to_map_3(-1, "g05", 560)
	vm.wait(2)
end
script[17480] = script.replay_sun_soldier_escort

return script
