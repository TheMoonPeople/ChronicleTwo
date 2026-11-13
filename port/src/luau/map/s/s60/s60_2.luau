--!strict
--- Plays the evening speech scene and the ending movie with captions.

local vm = require("@lib/vm")
local palm_brinks_s60 = require("@lib/event/palm_brinks_s60")
local wait = require("@lib/event/wait")

--- Plays the ending movie with captions, then shows a still image until a button is pressed and fades out.
local function play_ending_movie_with_captions()
	local image_block: s32 = 0
	event.fade_out_screen(0)
	event.stop_all_sounds()
	wait.frames(6)
	event.fade_in_screen(0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_movie_caption(0, 0)
	event.set_movie_caption(1, 0, 300, "Hourra, hourra !!!", 150)
	event.set_movie_caption(1, 1, 600, "Bravo bravo !!! Hourra !!!", 150)
	event.set_movie_caption(1, 2, 900, "Mes amis, mes amis...", 150)
	event.set_movie_caption(1, 3, 1200, "Hourra, hourra !!! ", 150)
	event.set_movie_caption(
		1,
		4,
		1500,
		"Aujourd'hui, le train Noirpierre va partir pour un \nnouveau voyage dans toute notre r[UNI00e9]gion.",
		150
	)
	event.set_movie_caption(
		1,
		5,
		1800,
		"J'esp[UNI011d]re que le monde va suivre cet exemple et\nrecommencer [UNI0155] se d[UNI00e9]velopper.",
		150
	)
	event.set_movie_caption(1, 6, 2100, "Eh bien, le maire a retrouv[UNI00e9] de l'aplomb.", 150)
	event.set_movie_caption(1, 7, 2400, "Oui, c'est vrai.", 150)
	event.set_movie_caption(
		1,
		8,
		2700,
		"Nous serons s[UNI0171]rement confront[UNI00e9]s [UNI0155] des difficult[UNI00e9]s,\nmais je suis certain qu'en travaillant ensemble,\nnous les r[UNI00e9]glerons sans probl[UNI011d]me !",
		150
	)
	event.set_movie_caption(1, 9, 3000, "Trois fois hourra !!! Bravo !!!", 150)
	event.set_movie_caption(
		1,
		10,
		3300,
		"Vous, habitants de Palm Brinks, vous avez surmont[UNI00e9] tant\nde temp[UNI0129]tes et su faire face [UNI0155] l'adversit[UNI00e9]...\nCette victoire est enti[UNI011d]rement la v[UNI00f4]tre !!!",
		150
	)
	event.set_movie_caption(1, 11, 3600, "Hourra pour Palm Brinks !!! Hourra !!!", 150)
	event.set_movie_caption(
		1,
		12,
		3900,
		"Il fut un temps o[UNI017f] notre monde [UNI00e9]tait plong[UNI00e9] dans les t[UNI00e9]n[UNI011d]bres.",
		150
	)
	event.set_movie_caption(
		1,
		13,
		4200,
		"Les hommes de cette [UNI00e9]poque ont r[UNI00e9]sist[UNI00e9] et ont reconquis leur avenir.",
		150
	)
	event.set_movie_caption(
		1,
		14,
		4500,
		"Mais le r[UNI00e9]cit de leur combat n'a jamais pu [UNI0129]tre transmis\naux g[UNI00e9]n[UNI00e9]rations futures.",
		150
	)
	event.set_movie_caption(
		1,
		15,
		4800,
		"Cette [UNI00e9]tonnante aventure [UNI00e9]tait-elle r[UNI00e9]elle ou non ?\nPersonne ne le sait.",
		150
	)
	event.set_movie_caption(
		1,
		16,
		5100,
		"Mais...\nQuand vous vous prom[UNI011d]nerez la nuit, parlez-en [UNI0155] la lune...\nIl est bien possible qu'elle vous raconte notre [UNI00e9]trange histoire.",
		150
	)
	event.set_movie_caption(0, 1)
	event.play_movie(5, "movie/end2.mp4")
	vm.wait(2)
	event.set_movie_caption(0, 0)
	image_block = event.load_event_image_4(5, "textures/event/e700/e736/e73601.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_color(0, 0, 0, 0, 128)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e73601", image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
	event.set_event_sprite_size(1, 512, 448)
	event.set_event_sprite_position(1, 256, 224)
	event.set_event_sprite_draw_pass(1, 1)
	event.fade_in_screen(60)
	wait.frames(90)
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(4)
		end
	end
	event.fade_out_screen(30)
	wait.frames(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the engine runs it in place of its default.
function script.do_nothing() end
script[99] = script.do_nothing

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine runs it in place of its default.
function script.default_event() end

--- Sets the evening time of day and plays the speech scene.
function script.key_open()
	local checkpoint: number = 0
	return vm.guard(function()
		event.set_time_of_day(22.0)
		event.set_time_of_day_advancing(0)
		checkpoint = 1
		wait.frames(30)
		checkpoint = 2
		palm_brinks_s60.play_e824_speech_scene()
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				checkpoint = 2
				palm_brinks_s60.play_e824_speech_scene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the ending movie with captions and flags the scene to exit.
function script.cutscene_ending_movie()
	play_ending_movie_with_captions()
	event.set_scene_exit_flag(1)
end
script[500] = script.cutscene_ending_movie

return script
