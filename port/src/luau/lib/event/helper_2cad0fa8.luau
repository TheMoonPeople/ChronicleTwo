--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_75ac2061 = require("@lib/event/helper_75ac2061")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_2cad0fa8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_75ac2061(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"[UNI00a1]Max! Has estado limpiando mucho\n[UNI00fa]ltimamente. [UNI00bf]Seguro que cuidas\nde ti?<page>[UNI00bf]Puedo hacer algo por ti?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e\nen tu aventura?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Umm... Me gustar[UNI00ed]a ir contigo,\npero este [UNI00e1]rbol necesita\natenci[UNI00f3]n.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Ver[UNI00e1]s, mi prioridad consiste en cuidar las\nplantas y los [UNI00e1]rboles de este\nterreno.<page>Si me voy a dar vueltas por ah[UNI00ed], podr[UNI00ed]a\nperder el trabajo."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Seguro que este [UNI00e1]rbol se repondr[UNI00ed]a con un poco del Agua bendita que el Padre Bruno\nvende en la iglesia.<page>Pero ya sabes que tu padre\ny el cura no se llevan bien...<page>Tu padre no me dar[UNI00ed]a ni loco dinero\npara comparle Agua bendita al cura.<page>[UNI00a1]Vaya berenjenal!"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Para que Gordon vaya a Sindain, primero debes\nconseguir que se apunte a\ntu viaje.")
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.MesMake_2(0, "[(!)]Si ayudas a Gordon,\nse apuntar[UNI00e1] al viaje y\nsubir[UNI00e1] al tren.")
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.MesMake_2(0, "[(!)]Puedes consultar tus misiones\nleyendo la Libreta\nque hay en el men[UNI00fa] Objetos.")
	helper_a3cc6850(0, -1, 8, 0, 0)
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)][UNI00a1]Pero si no tienes Libreta!\nHay una sobre la mesa\ndel Taller de Mantenimiento."
		)
		helper_a3cc6850(0, -1, 8, 0, 0)
		event.MesMake_2(
			0,
			"[(!)]Hay otra en el escondrijo\nde Donny. Cualquiera valdr[UNI00e1].\n [UNI00a1]Pero coge una r[UNI00e1]pido!"
		)
		helper_a3cc6850(0, -1, 8, 0, 0)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

return helper_2cad0fa8
