--!strict
-- map/s/s60/s60_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_c3ae7eec = require("@lib/event/helper_c3ae7eec")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_be7c()
	local block: s32 = 0
	event.fade_out_screen(0)
	event.stop_all_sounds()
	wait_frames(6)
	event.fade_in_screen(0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_movie_caption(0, 0)
	event.set_movie_caption(1, 0, 300, "Hurra, hurra!!", 150)
	event.set_movie_caption(1, 1, 600, "Juchhuuu!! Hurra!!", 150)
	event.set_movie_caption(1, 2, 900, "Gut, das reicht jetzt.", 150)
	event.set_movie_caption(1, 3, 1200, "Hurra!! Hurra!! ", 150)
	event.set_movie_caption(1, 4, 1500, "Heute startet die Blackstone-Bahn \neine Reise durch die gesamte Region.", 150)
	event.set_movie_caption(1, 5, 1800, "Ich hoffe, die Welt folgt diesem Beispiel\nund strebt nach neuem Fortschritt.", 150)
	event.set_movie_caption(1, 6, 2100, "Mann, der B[UNI00fc]rgermeister zeigt W[UNI00fc]rde.", 150)
	event.set_movie_caption(1, 7, 2400, "Ja, stimmt.", 150)
	event.set_movie_caption(
		1,
		8,
		2700,
		"Es liegen schwere Zeiten vor uns,\naber wenn wir zusammenhalten,\nstehen wir das durch!",
		150
	)
	event.set_movie_caption(1, 9, 3000, "Juchhuuu!! Hurra!!", 150)
	event.set_movie_caption(
		1,
		10,
		3300,
		"Ihr, die B[UNI00fc]rger von Palm Brinks, habt so \nviel durchgemacht, euch allen geh[UNI00f6]rt\nder heutige Jubeltag!!",
		150
	)
	event.set_movie_caption(1, 11, 3600, "Es lebe Palm Brinks!! Hurra!!", 150)
	event.set_movie_caption(1, 12, 3900, "Einst lag unsere ganze Welt im Dunkeln.", 150)
	event.set_movie_caption(1, 13, 4200, "Doch die Menschen wehrten sich und erk[UNI00e4]mpften sich\nihre Zukunft.", 150)
	event.set_movie_caption(
		1,
		14,
		4500,
		"Leider durften die folgenden Generationen nie \nvon der Geschichte ihres Kampfes erfahren.",
		150
	)
	event.set_movie_caption(1, 15, 4800, "Ist diese unglaubliche Geschichte wirklich passiert?\nMan wird es nie wissen.", 150)
	event.set_movie_caption(
		1,
		16,
		5100,
		"Aber ...\nWenn ihr den Mond fragen k[UNI00f6]nntet, der [UNI00fc]ber allem wacht,\nh[UNI00e4]tte er euch einiges von unserem seltsamen\nAbenteuer zu erz[UNI00e4]hlen.",
		150
	)
	event.set_movie_caption(0, 1)
	event.play_movie(5, "movie/end2.mp4")
	vm.wait(2)
	event.set_movie_caption(0, 0)
	block = event.load_event_image_4(5, "textures/event/e700/e736/e73601.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_color(0, 0, 0, 0, 128)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e73601", block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
	event.set_event_sprite_size(1, 512, 448)
	event.set_event_sprite_position(1, 256, 224)
	event.set_event_sprite_draw_pass(1, 1)
	event.fade_in_screen(60)
	wait_frames(90)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(4)
		end
	end
	event.fade_out_screen(30)
	wait_frames(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local at: number = 0
	return vm.guard(function()
		event.set_time_of_day(22.0)
		event.set_time_of_day_advancing(0)
		at = 1
		wait_frames(30)
		at = 2
		helper_c3ae7eec()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_c3ae7eec()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_be7c()
	event.set_scene_exit_flag(1)
end

return script
