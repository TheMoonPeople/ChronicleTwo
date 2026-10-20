--!strict
-- map/g/g00/g00_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4005e7b5 = require("@lib/event/helper_4005e7b5")
local helper_62059bfe = require("@lib/event/helper_62059bfe")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_bf8a16c2 = require("@lib/event/helper_bf8a16c2")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_be7c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Vedere la Ferrovia Carbonero\noperativa su tutto il continente\n[UNI00e8] il sogno mio e di Need.<page>Possiamo contare su di te, vero?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"Se trovano la Zelmite sar[UNI00f2]\nproprio impegnato. Gi[UNI00e0]!\nScavare, scavare e solo scavare!!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Chiss[UNI00e0] quante piante l[UNI00e0] fuori,\nche non abbiamo ancora visto!")
	end
	if arg1 == 4 then
		event.MesMake_2(
			arg0,
			"Ehi! Come procede la ricerca di\nZelmite? Se c'[UNI00e8] qualcosa che\nposso fare, fammi un fischio."
		)
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"Il mondo della pittura [UNI00e8] sconfinato.\nPotrebbe volerci tutta la vita per\nconoscerlo ma ne varrebbe la pena!"
		)
	end
	if arg1 == 6 then
		event.MesMake_2(arg0, "Va bene passare il tempo\ncercando Zelmite, ma vedi di\nnon stancarti troppo, ragazzo!")
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Un giorno diventer[UNI00f2] il miglior\ncuoco del mondo e allora potrai\nmangiare gratis quanto vorrai."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "Finalmente la Ferrovia Carbonero\n[UNI00e8] operativa in tutto il mondo.\nChe emozione!")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "Ehi, come va? Io sto d'incanto!")
	end
	if arg1 == 10 then
		event.MesMake_2(
			arg0,
			"La Miniera di Zelmite [UNI00e8] un posto\nmolto pericoloso. Non si deve\nmai abbassare la guardia."
		)
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Pregher[UNI00f2] per la tua incolumit[UNI00e0]...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Se mai ti venisse voglia\ndi pane, sai dove trovarmi.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "Ti piace proprio\nl'avventura, eh?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Se posso aiutarti in qualche\nmodo, non esitare a chiedere.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "Allora, novit[UNI00e0]? Hai gi[UNI00e0] incontrato\nqualche osso duro nella miniera?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"D'ora in poi aiuter[UNI00f2] Need e Cedric\na ricostruire il mondo. Dobbiamo\ntutti darci da fare."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Detto tra noi, [UNI00e8] bene che tu\nsappia che la Miniera di Zelmite [UNI00e8]\npericolosa. Non fare sciocchezze."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Prego che ci sia sempre\nla pace nel mondo.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Se la Ferrovia Carbonero viagger[UNI00e0]\nper tutto il mondo, potremo\nvisitare un sacco di bei posti."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"Non vedo l'ora di scovare i luoghi\nmigliori per pescare in giro\nper il mondo. Sar[UNI00e0] divertente!"
		)
	end
	if arg1 == 21 then
		event.MesMake_2(arg0, "Vorrei solo che Fabio\ns'interessasse a qualcos'altro,\noltre che alla pesca.")
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "Ho un brutto presentimento sulla\nMiniera di Zelmite. Stai all'erta!")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Se la Ferrovia Carbonero si\nespander[UNI00e0] in tutto il mondo, forse\npotr[UNI00f2] girare il mondo anch'io."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"Non mi freghi! Lo so che sei\nstato in giro a divertirti. Quando\nhai tempo, raccontami tutto!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Quando la Ferrovia Carbonero sar[UNI00e0]\nterminata, mi piacerebbe tanto\nandare ai "Confini della Terra".'
		)
	end
end

--- Helper function.
local function helper_205d8(arg0: s32, arg1: s32, sp: number)
	local junk = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 8)
			junk += 3
		end
		helper_be7c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.GetFlag(57) or flag
			if flag == 0 then
				event.SetFlag(57, 1)
				event.MesMake_2(
					arg0,
					"Ora vivo qui,\nma sono preoccupato\nper Carbonero Uno.<page>Sar[UNI00f2] io a far funzionare\nil treno, proprio come\nai vecchi tempi."
				)
				var4 = event.GetEventData_2(13) or var4
				helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 5)
				if vm.skipping() then
					return skip(2)
				end
				event.MesMake_2(
					arg0,
					"Borneo [UNI00e8] un po' dispotico,\nmentre Erik [UNI00e8] solo un ragazzo.<page>Per quelli come me, non c'[UNI00e8] altro\nche casa, lavoro, casa e ancora\nlavoro, tutti i giorni.<page>Ma cos[UNI00ec] [UNI00e8] la vita, eh..."
				)
			else
				event.MesMake_2(arg0, "Come procede con Steve?")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "Non sopporto di restare in\ncasa a rigirarmi i pollici!")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"Fiori e piante crescono solo\nse ti prendi cura di loro. Non\ntrascurerei mai le mie piccole!"
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"Chiss[UNI00e0] se [UNI00e8] tutto a posto alla\nbase segreta. Vorrei chiedere\ndi controllare ma, sai, [UNI00e8] segreta."
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"Il viola [UNI00e8] un bel colore.\nHa un suo fascino avvolgente\ne un'oscurit[UNI00e0] brillante."
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "Andrei ovunque per\naiutare chi soffre!")
		end
		if arg1 == 7 then
			event.MesMake_2(arg0, "Solo un vero chef riesce a\npreparare qualcosa di delizioso\novunque si trovi.")
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "Quando si tratta di case: pi[UNI00f9]\nsolide sono, meglio [UNI00e8], vero?")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"Le noci non sono niente male, ma\nquelle cose rosse erano ottime.\nMe ne porteresti ancora?"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"L'umidit[UNI00e0] [UNI00e8] il peggior nemico dei\nlibri. Non potrei sopportare di\nvivere vicino all'acqua."
			)
		end
		if arg1 == 11 then
			event.MesMake_2(
				arg0,
				"Non sono n[UNI00e9] belli n[UNI00e9] alla moda,\nma confeziono vestiti come\nnessun altro al mondo."
			)
		end
		if arg1 == 12 then
			event.MesMake_2(arg0, "Posto nuovo, vita nuova.\nMi sento ringiovanita!")
		end
		if arg1 == 13 then
			event.MesMake_2(arg0, "Voglio rompere in mille\npezzi qualcosa...\nnon importa cosa!")
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "Se trovi un nuovo mostro,\nvedi di riferirlo immediatamente.")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"Alcuni dicono che non [UNI00e8] cosa da\ndonne, ma alla spada non importa\nchi la impugna. Vinca il migliore!"
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "Questa casetta non [UNI00e8] niente male\nper tirar su una famiglia.")
		end
		if arg1 == 17 then
			event.MesMake_2(arg0, "Mi chiedo se Morton sia in gamba.\nMi fa stare sulle spine...")
		end
		if arg1 == 18 then
			event.MesMake_2(
				arg0,
				"Se c'[UNI00e8] una citt[UNI00e0] a cui serve una\nchiesa, sono il prete che fa per\nte. Devi solo farmelo sapere!"
			)
		end
		if arg1 == 19 then
			event.MesMake_2(arg0, "Grazie ai miei nuovi amici,\nnon ho pi[UNI00f9] pensato alla\nluna ultimamente.")
		end
		if arg1 == 20 then
			event.MesMake_2(
				arg0,
				"Altro luogo, altro pesce.\nDevi cambiare il tuo modo di\npensare per adattarti alla zona."
			)
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "Qui sembra perfetto per pescare.")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"Parn ha iniziato un altro ritratto\ndi donna. Dice che sar[UNI00e0]\nancora pi[UNI00f9] bella di me."
			)
		end
		if arg1 == 23 then
			event.MesMake_2(
				arg0,
				"Chiss[UNI00e0] perch[UNI00e9] gli insetti hanno\nun aspetto cos[UNI00ec] rivoltante..."
			)
		end
		if arg1 == 24 then
			event.MesMake_2(
				arg0,
				"Puoi rendere la mia casa pi[UNI00f9]\ncarina? Sai, una casa non [UNI00e8] mai\nabbastanza carina!"
			)
		end
		if arg1 == 25 then
			event.MesMake_2(arg0, "Non avrei mai immaginato di dover\ntraslocare alla mia et[UNI00e0]!")
		end
	else
		helper_be7c(arg0, arg1)
	end
end

--- Helper function.
local function helper_21bf4(sp: number)
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bf8a16c2(var1, -1, 0, 0, sp + 3)
		end
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
	helper_205d8(0, var2, sp + 3)
	if vm.skipping() then
		return skip(1)
	end
	helper_bf8a16c2(var1, -1, 0, 0, sp + 3)
	if vm.skipping() then
		return skip(2)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_21ee8()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_7e2956fd(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	helper_7e2956fd(1)
	event.Finish()
end

--- Helper function.
local function helper_22094(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		helper_21ee8()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	helper_21ee8()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e404(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Se non mi porti altri scoop,\nnon posso darti nulla!")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(
			arg0,
			"Il numero di idee e di scoop\ndetermineranno il tuo Livello\nfotografico.<page>Salendo di livello, riceverai\nin premio altri oggetti magnifici."
		)
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_ea4c(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d1353c5b(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_d1353c5b(arg0, -1, 3, 256, 208)
			end
			return helper_e404(arg0)
		end
		if at <= 5 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return helper_e404(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Andresti a prendermi\nun Blocchetto Scoop?")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Sembra non ci siano\naltri scoop.")
		if now_map_no == 22 then
			helper_b8950300(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_d1353c5b(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_e404(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_4005e7b5(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ho trovato ancora [Numero1] scoop.")
		event.SetMesDrawspeed(arg0, 0)
		helper_d1353c5b(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_4005e7b5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Allora, amico! Non startene\nimpalato! Dove sono i tuoi scoop?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Wow! Hai ottenuto [Number1] scoop!\nSapevo che ce l'avevi nel sangue!")
	end
	if now_map_no == 22 then
		helper_b8950300(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_d1353c5b(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_e404(arg0)
end

--- Helper function.
local function helper_d1b4()
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

--- Helper function.
local function helper_221b0(sp: number)
	local junk = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var4 = 0
				var4 = 20
				var4 = 24
				var4 = 28
				var4 = 32
				var4 = 40
				var4 = 44
				var4 = 48
				var4 = 52
				var4 = 56
				var23 = vm.f32(vm.sin(var18) * 30.0)
				var23 = vm.f32(var23 + var5)
				var24 = vm.f32(var6 + 33.0)
				var25 = vm.f32(vm.cos(var18) * 30.0)
				var25 = vm.f32(var25 + var7)
				var26 = var5
				var27 = vm.f32(var6 + 30.0)
				var28 = var7
				junk += 25
			end
			if at <= 2 then
				var29 = 0
				helper_4005e7b5(3, 1)
				helper_205d8(3, var2, sp + junk + 34)
				junk += 1
			end
			if at <= 3 then
				var30 = -1
				helper_4005e7b5(1, 8)
				helper_dc39b923(1, 1, 1, 0, 0)
				helper_4005e7b5(2, 2)
				var30 = 30
				var30 = 31
				var30 = 32
				var29 = helper_62059bfe(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
				junk += 3
			end
			helper_21ee8()
			return
		end
		if at <= 6 then
			helper_21ee8()
			return
		end
		if at <= 11 then
			if at <= 7 then
				helper_4005e7b5(3, 8)
				helper_d1353c5b(3, var30, 9, 0, 0)
				junk += 1
			end
			if at <= 8 then
				helper_d1353c5b(3, -1, 3, 256, 208)
				junk += 4
			end
			if at <= 9 then
				helper_21ee8()
				helper_22094(6)
				junk += 1
			end
			if at <= 10 then
				helper_22094(23)
				junk += 2
			end
			return
		end
		if at <= 13 then
			if at <= 12 then
				helper_22094(33)
			end
			return
		end
		if at <= 14 then
			helper_22094(1)
			junk += 1
		end
		if at <= 15 then
			helper_22094(2)
			junk += 1
		end
		if at <= 16 then
			helper_22094(3)
			junk += 1
		end
		if at <= 17 then
			helper_22094(7)
			junk += 1
		end
		if at <= 18 then
			helper_22094(8)
			junk += 1
		end
		if at <= 19 then
			helper_22094(9)
			junk += 1
		end
		if at <= 20 then
			helper_22094(10)
			junk += 1
		end
		if at <= 21 then
			helper_22094(11)
			junk += 1
		end
		if at <= 22 then
			helper_22094(12)
			junk += 1
		end
		if at <= 23 then
			helper_22094(13)
			junk += 1
		end
		if at <= 24 then
			helper_22094(14)
			junk += 1
		end
		if at <= 25 then
			helper_22094(15)
			junk += 1
		end
		if at <= 26 then
			helper_22094(16)
			junk += 1
		end
		if at <= 27 then
			helper_22094(17)
			junk += 1
		end
		if at <= 28 then
			helper_22094(18)
			junk += 1
		end
		if at <= 29 then
			helper_22094(19)
			junk += 1
		end
		if at <= 30 then
			helper_22094(20)
			junk += 1
		end
		if at <= 31 then
			helper_22094(21)
			junk += 1
		end
		if at <= 32 then
			helper_22094(22)
			junk += 1
		end
		if at <= 33 then
			helper_22094(32)
			junk += 1
		end
		if at <= 34 then
			helper_d1b4()
			helper_d1353c5b(3, -1, 3, 256, 208)
			junk += 1
		end
		if at <= 35 then
			helper_21ee8()
			helper_b0211f82(30)
			junk += 1
		end
		helper_21ee8()
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.SetMotion(0, "立ち")
	event.SetMotion(var1, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if var2 == 18 then
		var4 = 20
	end
	if var2 == 25 then
		var4 = 24
	end
	if var2 == 12 or var2 == 17 then
		var4 = 28
	end
	if var2 == 7 then
		var4 = 32
	end
	if var2 == 10 or var2 == 6 or var2 == 24 then
		var4 = 40
	end
	if var2 == 8 or var2 == 1 or var2 == 2 or var2 == 3 or var2 == 15 or var2 == 16 or var2 == 21 then
		var4 = 44
	end
	if var2 == 4 or var2 == 19 or var2 == 20 or var2 == 22 then
		var4 = 48
	end
	if var2 == 5 or var2 == 11 or var2 == 23 or var2 == 13 then
		var4 = 52
	end
	if var2 == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.GetCharaPos(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.GetCharaRot(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.GetCharaRot(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.GetRotLookPos(var5 - var11, var7 - var13) or var17
	event.SetCharaRot(0, var14, var17, var16)
	var18 = event.GetRotLookPos(var11 - var5, var13 - var7) or var18
	event.SetCharaRot(var1, var8, var18, var10)
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.FuncPointGetPos("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.SetCameraPos(var20, var21, var22)
		event.SetCameraRef(var5, var6 + 30.0, var7)
		var18 = event.GetRotLookPos(var20 - var5, var22 - var7) or var18
		event.SetCharaRot(var1, var8, var18, var10)
	else
		var23 = vm.f32(vm.sin(var18) * 30.0)
		var23 = vm.f32(var23 + var5)
		var24 = vm.f32(var6 + 33.0)
		var25 = vm.f32(vm.cos(var18) * 30.0)
		var25 = vm.f32(var25 + var7)
		event.SetCameraPos(var23, var24, var25)
		var26 = var5
		var27 = vm.f32(var6 + 30.0)
		var28 = var7
		event.SetCameraRef(var26, var27, var28)
	end
	event.CharaActive(0, 0)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var29 = 0
	while true do
		helper_4005e7b5(3, 1)
		helper_205d8(3, var2, sp + junk + 33)
		if vm.skipping() then
			return skip(3)
		end
		var30 = -1
		event.SetMesDrawspeed(3, 0, 0)
		helper_4005e7b5(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var31 = event.GetPartyCharaMesNo_3(var2, 0) or var31
		event.SetMesItemDirect(1, 1, var31)
		helper_dc39b923(1, 1, 1, 0, 0)
		helper_4005e7b5(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.SetMesItemDirect(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.SetMesItemDirect(2, 1, var30)
			event.SetMesItemDirect(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_62059bfe(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if vm.skipping() then
			return skip(4)
		end
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_21ee8()
				event.SetCrossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_b0211f82(30)
				if vm.skipping() then
					return skip(5)
				end
				event.SetNpcStatus(var2, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(6)
				end
				helper_21ee8()
				event.SetFadeIn(30)
				return
			end
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Non puoi farlo ora. Devi prima\nportare Lin al faro!")
			helper_d1353c5b(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var29 == 1 then
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var30 = event.GetPartyCharaMesNo_3(var2, 3) or var30
			helper_d1353c5b(3, var30, 9, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Benone, con le riparazioni\nabbiamo finito!")
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(9)
						end
						helper_21ee8()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_22094(6)
					if vm.skipping() then
						return skip(10)
					end
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_22094(23)
						if vm.skipping() then
							return skip(11)
						end
						return
					end
					if var2 == 4 then
						local t0 = helper_ea4c(3)
						if vm.skipping() then
							junk += 1
							return skip(12)
						end
						if t0 ~= 0 then
							helper_22094(33)
							if vm.skipping() then
								return skip(13)
							end
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_22094(0)
						if vm.skipping() then
							return skip(14)
						end
					end
					if var2 == 12 then
						helper_22094(1)
						if vm.skipping() then
							return skip(15)
						end
					end
					if var2 == 6 then
						helper_22094(2)
						if vm.skipping() then
							return skip(16)
						end
					end
					if var2 == 7 then
						helper_22094(3)
						if vm.skipping() then
							return skip(17)
						end
					end
					if var2 == 2 then
						helper_22094(7)
						if vm.skipping() then
							return skip(18)
						end
					end
					if var2 == 3 then
						helper_22094(8)
						if vm.skipping() then
							return skip(19)
						end
					end
					if var2 == 5 then
						helper_22094(9)
						if vm.skipping() then
							return skip(20)
						end
					end
					if var2 == 8 then
						helper_22094(10)
						if vm.skipping() then
							return skip(21)
						end
					end
					if var2 == 10 then
						helper_22094(11)
						if vm.skipping() then
							return skip(22)
						end
					end
					if var2 == 11 then
						helper_22094(12)
						if vm.skipping() then
							return skip(23)
						end
					end
					if var2 == 13 then
						helper_22094(13)
						if vm.skipping() then
							return skip(24)
						end
					end
					if var2 == 16 then
						helper_22094(14)
						if vm.skipping() then
							return skip(25)
						end
					end
					if var2 == 18 then
						helper_22094(15)
						if vm.skipping() then
							return skip(26)
						end
					end
					if var2 == 19 then
						helper_22094(16)
						if vm.skipping() then
							return skip(27)
						end
					end
					if var2 == 20 then
						helper_22094(17)
						if vm.skipping() then
							return skip(28)
						end
					end
					if var2 == 21 then
						helper_22094(18)
						if vm.skipping() then
							return skip(29)
						end
					end
					if var2 == 22 then
						helper_22094(19)
						if vm.skipping() then
							return skip(30)
						end
					end
					if var2 == 23 then
						helper_22094(20)
						if vm.skipping() then
							return skip(31)
						end
					end
					if var2 == 24 then
						helper_22094(21)
						if vm.skipping() then
							return skip(32)
						end
					end
					if var2 == 25 then
						helper_22094(22)
						if vm.skipping() then
							return skip(33)
						end
					end
					if var2 == 17 then
						helper_22094(32)
						if vm.skipping() then
							return skip(34)
						end
					end
					if var2 == 9 then
						helper_d1b4()
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(35)
						end
						helper_21ee8()
						event.SetCrossfade(10)
					end
					if var2 == 14 then
						event.SetFadeOut(25)
						helper_b0211f82(30)
						if vm.skipping() then
							return skip(36)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(37)
						end
						helper_21ee8()
						event.SetFadeIn(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_21ee8()
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_c6c63376

--- Program 100.
script[100] = function()
	helper_c6c63376()
	event.ResetCamera(1, 0.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "お洒落")
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_221b0(sp + 0)
		end
	end
	helper_21bf4(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	helper_221b0(sp + 0)
	if vm.skipping() then
		return skip(2)
	end
end

return script
