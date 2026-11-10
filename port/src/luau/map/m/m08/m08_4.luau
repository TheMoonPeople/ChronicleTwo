--!strict
-- map/m/m08/m08_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_32d84646 = require("@lib/event/helper_32d84646")
local helper_e80a7a24 = require("@lib/event/helper_e80a7a24")
local helper_f9ed45d9 = require("@lib/event/helper_f9ed45d9")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_1ef0d4b2

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_32d84646

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_f9ed45d9

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	local argc: s32 = 0
	event.set_local_event_flag(0, 0)
	helper_e80a7a24()
	event.set_sound_reverb_enabled(0)
	argc = event.get_local_event_flag(0) or argc
	if argc == 1 then
		event.start_crossfade(60)
	else
		event.fade_in_screen(60)
	end
	vm.wait(2)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_background_color(0, 0, 0)
	event.set_movie_caption(0, 0)
	event.set_movie_caption(1, 0, 105.0, "Ho avuto una paura!", 90)
	event.set_movie_caption(1, 1, 210.0, "Beh, [UNI00e8] stato davvero divertente!", 90)
	event.set_movie_caption(1, 2, 390, "Le mie giornate erano una tale noia!", 90)
	event.set_movie_caption(1, 3, 540, "Ma... [UNI00e8] stato l’inizio di un’avventura!", 150)
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

return script
