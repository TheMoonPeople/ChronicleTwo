--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_d5e73dab()
	local block: s32 = 0
	event.fade_out_screen(0)
	event.stop_all_sounds()
	wait_frames(6)
	event.fade_in_screen(0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_movie_caption(0, 0)
	event.set_movie_caption(1, 0, 300, "[UNI00a1]Hurra! [UNI00a1]Hurra!", 150)
	event.set_movie_caption(1, 1, 600, "[UNI00a1]Hip, hip! [UNI00a1]Hurra!", 150)
	event.set_movie_caption(1, 2, 900, "Vale, ya basta.", 150)
	event.set_movie_caption(1, 3, 1200, "[UNI00a1]Hurra! [UNI00a1]Hurra! ", 150)
	event.set_movie_caption(
		1,
		4,
		1500,
		"Hoy, la l[UNI00ed]nea de ferrocarril Blackstone partir[UNI00e1] en un\nnuevo viaje por toda nuestra regi[UNI00f3]n.",
		150
	)
	event.set_movie_caption(
		1,
		5,
		1800,
		"Espero que esto sirva de ejemplo para el resto del mundo y\nque comience de nuevo el desarrollo.",
		150
	)
	event.set_movie_caption(1, 6, 2100, "[UNI00a1]Guau! Ahora s[UNI00ed] que parece un buen alcalde.", 150)
	event.set_movie_caption(1, 7, 2400, "S[UNI00ed], tienes raz[UNI00f3]n.", 150)
	event.set_movie_caption(
		1,
		8,
		2700,
		"[UNI00a1]Aunque a[UNI00fa]n nos queden muchas dificultades que pasar,\nestoy seguro que si trabajamos todos juntos,\nlo conseguiremos!",
		150
	)
	event.set_movie_caption(1, 9, 3000, "[UNI00a1]Viva! [UNI00a1]Hurra!", 150)
	event.set_movie_caption(
		1,
		10,
		3300,
		"[UNI00a1]Vosotros, queridos ciudadanos de Palm Brinks, hab[UNI00e9]is vivido \nmuchas tormentas y hab[UNI00e9]is hecho frente a muchas adversidades,\npor lo que todos os merec[UNI00e9]is esta victoria!",
		150
	)
	event.set_movie_caption(1, 11, 3600, "[UNI00a1]Viva Palm Brinks! [UNI00a1]Viva!", 150)
	event.set_movie_caption(1, 12, 3900, "Hubo un tiempo en el que nuestro mundo estaba asolado por la oscuridad.", 150)
	event.set_movie_caption(1, 13, 4200, "La gente de este tiempo luch[UNI00f3] y reclam[UNI00f3] su futuro.", 150)
	event.set_movie_caption(
		1,
		14,
		4500,
		"Pero la historia de aquella batalla nunca pudo pasar\na las siguientes generaciones.",
		150
	)
	event.set_movie_caption(
		1,
		15,
		4800,
		"[UNI00bf]Pas[UNI00f3] de verdad esta incre[UNI00ed]ble aventura o no?\nNadie lo sabe con certeza.",
		150
	)
	event.set_movie_caption(
		1,
		16,
		5100,
		"Pero...\nPero si pudieseis daros un paseo por el cielo de la noche y hablar con la Luna,\nseguro que os contar[UNI00ed]a todo lo que ocurri[UNI00f3] en esa extra[UNI00f1]a aventura.",
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

return helper_d5e73dab
