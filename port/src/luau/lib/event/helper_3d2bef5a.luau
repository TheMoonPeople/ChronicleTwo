--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_3d2bef5a()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(732) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Bel lavoro! Gli Umani\nnon sono poi cos[UNI00ec] male!<page>Mi sbagliavo!")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Questo [UNI00e8] tutto. [UNI00c8] quasi finita.\nOra dobbiamo solo sconfiggerlo.<page>Cos[UNI00ec] il mondo torner[UNI00e0] a vivere."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "So come si senta Grifone,\nma non lo perdoner[UNI00f2] mai!")
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Ripristinate il giardino e svelate\nl'arcano su Grifone... su Sirus!")
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(3, 'Chiss[UNI00e0] cosa significa "I ricordi\ndi Sirus?" Entriamo nel palazzo per scoprirlo!')
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Grifone fuggir[UNI00e0], se non ci muoviamo.\nPresto! Al Palazzo Fiordiluna!")
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(3, "Pare che abbiamo tutte le gemme.\nCorriamo a Stonehenge Kazarov!")
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Comunque, faremmo meglio a trovare\nle gemme prima che sia troppo tardi.")
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Tutto ha avuto inizio qui, eh?\nBene, andiamo nel giardino.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Torniamo al Lab-Lunatica. L'Ixion\npotrebbe essere gi[UNI00e0] pronto.")
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "[UNI00c8] ora di contrattaccare Grifone.\nTorniamo al Paznos!")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Non stare l[UNI00ec] impalato!\nDobbiamo salvare Monica, muoviti!")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Ricordi? Secondo Galen Agaris, suonando\nil Corno del Fuoco, la strada si aprir[UNI00e0].")
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Non stare l[UNI00ec] impalato!\nDobbiamo salvare Monica, muoviti!")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Bisogna eliminare la Sputa Fuoco.<page>[UNI00c8] lass[UNI00f9] sul Monte Gundor, eh?")
		return
	end
	event.MesMake_2(3, "Aspettare qui non serve a nulla.<page>Non siamo ancora stati ovunque.")
end

return helper_3d2bef5a
