--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9336672d = require("@lib/event/helper_9336672d")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")

--- Helper function.
local function helper_b1da3dd7()
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_b0211f82(90)
		end
		if at <= 3 then
			local _ = helper_9336672d(0)
		end
		if at <= 4 then
			helper_b0211f82(30)
		end
	end
	event.SetFadeOut(0)
	event.SoundAllStop()
	helper_b0211f82(6)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetMovieCc(0, 0)
	event.SetMovieCc(1, 0, 300, "[UNI00a1]Hurra! [UNI00a1]Hurra!", 150)
	event.SetMovieCc(1, 1, 600, "[UNI00a1]Hip, hip! [UNI00a1]Hurra!", 150)
	event.SetMovieCc(1, 2, 900, "Vale, ya basta.", 150)
	event.SetMovieCc(1, 3, 1200, "[UNI00a1]Hurra! [UNI00a1]Hurra! ", 150)
	event.SetMovieCc(
		1,
		4,
		1500,
		"Hoy, la l[UNI00ed]nea de ferrocarril Blackstone partir[UNI00e1] en un\nnuevo viaje por toda nuestra regi[UNI00f3]n.",
		150
	)
	event.SetMovieCc(
		1,
		5,
		1800,
		"Espero que esto sirva de ejemplo para el resto del mundo y\nque comience de nuevo el desarrollo.",
		150
	)
	event.SetMovieCc(1, 6, 2100, "[UNI00a1]Guau! Ahora s[UNI00ed] que parece un buen alcalde.", 150)
	event.SetMovieCc(1, 7, 2400, "S[UNI00ed], tienes raz[UNI00f3]n.", 150)
	event.SetMovieCc(
		1,
		8,
		2700,
		"[UNI00a1]Aunque a[UNI00fa]n nos queden muchas dificultades que pasar,\nestoy seguro que si trabajamos todos juntos,\nlo conseguiremos!",
		150
	)
	event.SetMovieCc(1, 9, 3000, "[UNI00a1]Viva! [UNI00a1]Hurra!", 150)
	event.SetMovieCc(
		1,
		10,
		3300,
		"[UNI00a1]Vosotros, queridos ciudadanos de Palm Brinks, hab[UNI00e9]is vivido \nmuchas tormentas y hab[UNI00e9]is hecho frente a muchas adversidades,\npor lo que todos os merec[UNI00e9]is esta victoria!",
		150
	)
	event.SetMovieCc(1, 11, 3600, "[UNI00a1]Viva Palm Brinks! [UNI00a1]Viva!", 150)
	event.SetMovieCc(1, 12, 3900, "Hubo un tiempo en el que nuestro mundo estaba asolado por la oscuridad.", 150)
	event.SetMovieCc(1, 13, 4200, "La gente de este tiempo luch[UNI00f3] y reclam[UNI00f3] su futuro.", 150)
	event.SetMovieCc(
		1,
		14,
		4500,
		"Pero la historia de aquella batalla nunca pudo pasar\na las siguientes generaciones.",
		150
	)
	event.SetMovieCc(
		1,
		15,
		4800,
		"[UNI00bf]Pas[UNI00f3] de verdad esta incre[UNI00ed]ble aventura o no?\nNadie lo sabe con certeza.",
		150
	)
	event.SetMovieCc(
		1,
		16,
		5100,
		"Pero...\nPero si pudieseis daros un paseo por el cielo de la noche y hablar con la Luna,\nseguro que os contar[UNI00ed]a todo lo que ocurri[UNI00f3] en esa extra[UNI00f1]a aventura.",
		150
	)
	event.SetMovieCc(0, 1)
	event.LoadMovie(5, "movie/end2.mp4")
	if vm.wait() then
		return skip(2)
	end
	event.SetMovieCc(0, 0)
	block = event.LoadImg_4(5, "textures/event/e700/e736/e73601.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e73601", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.SetFadeIn(60)
	helper_b0211f82(90)
	if vm.skipping() then
		return skip(3)
	end
	while true do
		if helper_9336672d(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(4)
			end
		end
	end
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(5)
	end
end

return helper_b1da3dd7
