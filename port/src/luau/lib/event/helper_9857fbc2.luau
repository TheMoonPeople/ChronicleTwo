--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_55bbf5ca = require("@lib/event/helper_55bbf5ca")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_9857fbc2(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_55bbf5ca(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"Deber[UNI00ed]as imaginarte la respuesta:\n[UNI00a1]ni hablar!<page>[UNI00bf]Por qu[UNI00e9] iba yo a trabajar por\nel bien de otros?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Yo no saco nada y\nadem[UNI00e1]s me da mucho miedo.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Trat[UNI00e1]ndose de ti, supongo\nque me lo puedo pensar mejor.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Pero soy hijo de comerciante:\nno hacemos nada gratis.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Ya sabr[UNI00e1]s que colecciono monedas.<page>Son el s[UNI00ed]mbolo de los negocios. Quiero\nacabar mi colecci[UNI00f3]n."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Pero soy incapaz de conseguir\nla Moneda negra\ny la Moneda indestructible.<page>Si me ayudas,<page>quiz[UNI00e1] te ayude yo a ti."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

return helper_9857fbc2
