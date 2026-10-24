--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_ec8c350b = require("@lib/event/helper_ec8c350b")

--- Helper function.
local function helper_71bd88ba()
	local language_code: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a0e17f3c(6)
		end
		if at <= 2 then
			print("GET_LANGUAGE=", language_code, "\n")
		end
		if at <= 3 then
			helper_a0e17f3c(90)
		end
		if at <= 4 then
			local _ = helper_ec8c350b(0)
		end
		if at <= 5 then
			helper_a0e17f3c(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	event.SoundAllStop()
	helper_a0e17f3c(6)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(0)
	event.AssignStack(5)
	event.ClearStack(5)
	language_code = event.GetLanguage() or language_code
	print("GET_LANGUAGE=", language_code, "\n")
	if language_code ~= 1 then
		event.SetMovieCc(0, 0)
		event.SetMovieCc(1, 2, vm.ftoi(vm.f32(109.8)), "Vale, ya basta.", vm.ftoi(vm.f32(50.7)))
		event.SetMovieCc(
			1,
			4,
			vm.ftoi(vm.f32(241.80002)),
			"Hoy, la l[UNI00ed]nea de ferrocarril Blackstone partir[UNI00e1] en un\nnuevo viaje por toda nuestra regi[UNI00f3]n.",
			vm.ftoi(vm.f32(160.20001))
		)
		event.SetMovieCc(
			1,
			5,
			vm.ftoi(vm.f32(555.9)),
			"Espero que esto sirva de ejemplo para el resto del mundo y\nque comience de nuevo el desarrollo.",
			vm.ftoi(vm.f32(143.40001))
		)
		event.SetMovieCc(
			1,
			6,
			vm.ftoi(vm.f32(788.4)),
			"[UNI00a1]Guau! Ahora s[UNI00ed] que parece un buen alcalde.",
			vm.ftoi(vm.f32(99.299995))
		)
		event.SetMovieCc(1, 7, vm.ftoi(vm.f32(897.3)), "S[UNI00ed], tienes raz[UNI00f3]n.", vm.ftoi(vm.f32(33.6)))
		event.SetMovieCc(
			1,
			8,
			vm.ftoi(937.5),
			"[UNI00a1]Aunque a[UNI00fa]n nos queden muchas dificultades que pasar,\nestoy seguro que si trabajamos todos juntos,\nlo conseguiremos!",
			vm.ftoi(vm.f32(234.6))
		)
		event.SetMovieCc(
			1,
			10,
			vm.ftoi(1294.5),
			"[UNI00a1]Vosotros, queridos ciudadanos de Palm Brinks, hab[UNI00e9]is vivido \nmuchas tormentas y hab[UNI00e9]is hecho frente a muchas adversidades,\npor lo que todos os merec[UNI00e9]is esta victoria!",
			vm.ftoi(vm.f32(311.1))
		)
		event.SetMovieCc(
			1,
			12,
			vm.ftoi(vm.f32(1611.6001)),
			"Hubo un tiempo en el que nuestro mundo estaba asolado por la oscuridad.",
			vm.ftoi(vm.f32(96.6))
		)
		event.SetMovieCc(
			1,
			13,
			vm.ftoi(vm.f32(1820.7)),
			"La gente de este tiempo luch[UNI00f3] y reclam[UNI00f3] su futuro.",
			vm.ftoi(vm.f32(99.299995))
		)
		event.SetMovieCc(
			1,
			14,
			vm.ftoi(vm.f32(2121.6)),
			"Pero la historia de aquella batalla nunca pudo pasar\na las siguientes generaciones.",
			vm.ftoi(vm.f32(128.40001))
		)
		event.SetMovieCc(
			1,
			15,
			vm.ftoi(vm.f32(2328.6)),
			"[UNI00bf]Pas[UNI00f3] de verdad esta incre[UNI00ed]ble aventura o no?\nNadie lo sabe con certeza.",
			vm.ftoi(vm.f32(209.09999))
		)
		event.SetMovieCc(
			1,
			16,
			vm.ftoi(vm.f32(2623.2002)),
			"Pero...\nPero si pudieseis daros un paseo por el cielo de la noche y hablar con la Luna,\nseguro que os contar[UNI00ed]a todo lo que ocurri[UNI00f3] en esa extra[UNI00f1]a aventura.",
			vm.ftoi(vm.f32(242.70001))
		)
		event.SetMovieCc(0, 1)
	end
	event.LoadMovie(5, "movie/end2.mp4")
	if vm.wait() then
		return skip(3)
	end
	if language_code ~= 1 then
		event.SetMovieCc(0, 0)
	end
	event.PauseEnableFlag(0)
	block = event.LoadImg_4(5, "textures/event/e800/e824/e82401_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e82401", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.SetFadeIn(60)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(4)
	end
	while true do
		if helper_ec8c350b(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(5)
			end
		end
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(6)
	end
end

return helper_71bd88ba
