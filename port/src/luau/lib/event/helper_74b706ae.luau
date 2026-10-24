--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_74b706ae(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "Ah, [UNI00bf]est[UNI00e1]s ayudando\na Polly?<page>Muy bien.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"[UNI00bf]Para qu[UNI00e9] se\nnecesitan 20 barras?<page>Pues para hacer\nuna fondue de queso hoy mismo."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			'Hablando en t[UNI00e9]rminos de tus famosas "invenciones",\nes una combinaci[UNI00f3]n culinaria de queso,<page>pan y vino.'
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"Est[UNI00e1] de muerte. Todo el mundo repite,\npor eso me hace falta tanto pan.<page>Pero no quer[UNI00ed]a que me\nlo trajeran aqu[UNI00ed], en realidad."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"[UNI00bf]No podr[UNI00ed]as llev[UNI00e1]rmelo\na casa, no Max?<page>Ya sabes donde est[UNI00e1], [UNI00bf]no?\nCerca del campo de calabazas."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "Ya sabes donde est[UNI00e1], [UNI00bf]no?\nCerca del campo de calabazas.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.MesMake_2(0, "[UNI00bf]Cancelado?\n[UNI00a1]Qu[UNI00e9] pena!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"En tal caso, no necesito el pan.\n[UNI00bf]Puedes devolv[UNI00e9]rselo a Polly por m[UNI00ed]?"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "Lo siento. [UNI00bf]Podr[UNI00ed]as devolverle el pan\na Polly por m[UNI00ed]?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_74b706ae
