--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_d78b80d8()
	local language_code: s32 = 0
	local block: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.stop_all_sounds()
		at = 1
		wait_frames(6)
		event.fade_in_screen(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		language_code = event.get_language() or language_code
		print("GET_LANGUAGE=", language_code, "\n")
		if language_code ~= 1 then
			event.set_movie_caption(0, 0)
			event.set_movie_caption(1, 2, vm.ftoi(vm.f32(109.8)), "Vale, ya basta.", vm.ftoi(vm.f32(50.7)))
			event.set_movie_caption(
				1,
				4,
				vm.ftoi(vm.f32(241.80002)),
				"Hoy, la l[UNI00ed]nea de ferrocarril Blackstone partir[UNI00e1] en un\nnuevo viaje por toda nuestra regi[UNI00f3]n.",
				vm.ftoi(vm.f32(160.20001))
			)
			event.set_movie_caption(
				1,
				5,
				vm.ftoi(vm.f32(555.9)),
				"Espero que esto sirva de ejemplo para el resto del mundo y\nque comience de nuevo el desarrollo.",
				vm.ftoi(vm.f32(143.40001))
			)
			event.set_movie_caption(
				1,
				6,
				vm.ftoi(vm.f32(788.4)),
				"[UNI00a1]Guau! Ahora s[UNI00ed] que parece un buen alcalde.",
				vm.ftoi(vm.f32(99.299995))
			)
			event.set_movie_caption(1, 7, vm.ftoi(vm.f32(897.3)), "S[UNI00ed], tienes raz[UNI00f3]n.", vm.ftoi(vm.f32(33.6)))
			event.set_movie_caption(
				1,
				8,
				vm.ftoi(937.5),
				"[UNI00a1]Aunque a[UNI00fa]n nos queden muchas dificultades que pasar,\nestoy seguro que si trabajamos todos juntos,\nlo conseguiremos!",
				vm.ftoi(vm.f32(234.6))
			)
			event.set_movie_caption(
				1,
				10,
				vm.ftoi(1294.5),
				"[UNI00a1]Vosotros, queridos ciudadanos de Palm Brinks, hab[UNI00e9]is vivido \nmuchas tormentas y hab[UNI00e9]is hecho frente a muchas adversidades,\npor lo que todos os merec[UNI00e9]is esta victoria!",
				vm.ftoi(vm.f32(311.1))
			)
			event.set_movie_caption(
				1,
				12,
				vm.ftoi(vm.f32(1611.6001)),
				"Hubo un tiempo en el que nuestro mundo estaba asolado por la oscuridad.",
				vm.ftoi(vm.f32(96.6))
			)
			event.set_movie_caption(
				1,
				13,
				vm.ftoi(vm.f32(1820.7)),
				"La gente de este tiempo luch[UNI00f3] y reclam[UNI00f3] su futuro.",
				vm.ftoi(vm.f32(99.299995))
			)
			event.set_movie_caption(
				1,
				14,
				vm.ftoi(vm.f32(2121.6)),
				"Pero la historia de aquella batalla nunca pudo pasar\na las siguientes generaciones.",
				vm.ftoi(vm.f32(128.40001))
			)
			event.set_movie_caption(
				1,
				15,
				vm.ftoi(vm.f32(2328.6)),
				"[UNI00bf]Pas[UNI00f3] de verdad esta incre[UNI00ed]ble aventura o no?\nNadie lo sabe con certeza.",
				vm.ftoi(vm.f32(209.09999))
			)
			event.set_movie_caption(
				1,
				16,
				vm.ftoi(vm.f32(2623.2002)),
				"Pero...\nPero si pudieseis daros un paseo por el cielo de la noche y hablar con la Luna,\nseguro que os contar[UNI00ed]a todo lo que ocurri[UNI00f3] en esa extra[UNI00f1]a aventura.",
				vm.ftoi(vm.f32(242.70001))
			)
			event.set_movie_caption(0, 1)
		end
		event.play_movie(5, "movie/end2.mp4")
		at = 2
		vm.wait(2)
		if language_code ~= 1 then
			event.set_movie_caption(0, 0)
		end
		event.set_pause_enabled(0)
		block = event.load_event_image_4(5, "textures/event/e800/e824/e82401_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_color(0, 0, 0, 0, 128)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e82401", block)
		event.set_event_sprite_color(1, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.fade_in_screen(60)
		at = 3
		wait_frames(90)
		while true do
			if helper_581cb30c(0) ~= 0 then
				break
			else
				at = 4
				vm.wait(4)
			end
		end
		event.fade_out_screen(30)
		at = 5
		wait_frames(30)
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				print("GET_LANGUAGE=", language_code, "\n")
			end
			if at <= 2 then
				wait_frames_skipping(90)
			end
			if at <= 4 then
				wait_frames_skipping(30)
			end
			local _ = helper_dbff9fb6(0)
			return 0
		end
		return nil
	end)
end

return helper_d78b80d8
