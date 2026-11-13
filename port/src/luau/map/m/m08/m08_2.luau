--!strict
--- Event script for map m08, with the opening chase and the opening movie.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local palm_brinks_m08 = require("@lib/event/palm_brinks_m08")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = cutscene.noop

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = palm_brinks_m08.play_rooftop_camera_sweep

--- Event 151, which map data, a script or the engine runs by number.
script[151] = palm_brinks_m08.play_run_to_exit_cutscene

--- Plays the opening chase, the captioned opening movie and jumps to dungeon d01e01.
function script.cutscene_opening_movie()
	local crossfade_flag: s32 = 0
	event.set_local_event_flag(0, 0)
	palm_brinks_m08.play_opening_chase_cutscene()
	event.set_sound_reverb_enabled(0)
	crossfade_flag = event.get_local_event_flag(0) or crossfade_flag
	if crossfade_flag == 1 then
		event.start_crossfade(60)
	else
		event.fade_in_screen(60)
	end
	vm.wait(2)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_background_color(0, 0, 0)
	event.set_movie_caption(0, 0)
	event.set_movie_caption(1, 0, 105.0, "J'avais eu si peur [UNI00e0] ce moment-l[UNI00e0].", 90)
	event.set_movie_caption(1, 1, 210.0, "Mais dans un sens, c'[UNI00e9]tait super.", 90)
	event.set_movie_caption(1, 2, 390, "Bref, pour moi, tous les jours se\nressemblaient.", 90)
	event.set_movie_caption(
		1,
		3,
		540,
		"Mais [UNI00e7]a... [UNI00c7]a c'[UNI00e9]tait le d[UNI00e9]but\nd'une vraie aventure.",
		150
	)
	event.set_movie_caption(0, 1)
	event.play_movie(5, "movie/open1.mp4")
	event.fade_out_screen(0)
	vm.wait(3)
	vm.wait(4)
	event.set_movie_caption(0, 0)
	event.set_sound_reverb_enabled(1)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	event.jump_to_map_3(-1, "d01e01", 151)
end
script[152] = script.cutscene_opening_movie

return script
