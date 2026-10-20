--!strict
-- map/g/g00/g00_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
			"Need und ich tr[UNI00e4]umen davon, dass\ndie Blackstone-Bahn den ganzen\nKontinent bef[UNI00e4]hrt.<page>Du hilft uns doch, oder?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"Wenn sie Zelmit finden, bin ich\nauch besch[UNI00e4]ftigt. Dann w[UNI00fc]rde\nich buddeln, buddeln, buddeln!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Es muss so viele Pflanzen geben,\ndie wir noch nie gesehen haben.")
	end
	if arg1 == 4 then
		event.MesMake_2(arg0, "He! Wie l[UNI00e4]uft die Zelmit-Suche?\nWenn ich helfen kann,\nsag einfach Bescheid.")
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"Die Welt der Bilder ist gro[UNI00df].\nMalen zu lernen mag ein Leben\ndauern, doch es ist die Zeit wert."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"Wenn du Zelmit suchen willst,\nmach das ruhig. Aber\n[UNI00fc]beranstrenge dich nicht, Kleiner."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Ich werde der beste Koch\nder Welt, und wenn's soweit ist,\nisst du immer gratis bei mir."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "Endlich f[UNI00e4]hrt die Blackstone-\nBahn auf der ganzen Welt.\nDas ist so aufregend!")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "Hey, wie l[UNI00e4]uft's?\nBei mir l[UNI00e4]uft's super!")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "Die Zelmit-Mine ist unheimlich.\nDort musst du immer\nwachsam bleiben.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Ich bete f[UNI00fc]r deine Sicherheit ...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Wenn du Lust auf Brot hast,\nwei[UNI00df]t du ja, wo ich bin.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "Diese Abenteuer machen dir\neinen Riesenspa[UNI00df], was?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Falls ich dir irgendwie helfen\nkann, frag mich ruhig.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"Ab jetzt helfe ich Need und Cedric,\ndie Welt wieder aufzubauen.\nDabei m[UNI00fc]ssen wir zusammenarbeiten."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Nur so zwischen dir und mir - die\nZelmit-Mine ist nicht ungef[UNI00e4]hrlich.\nMach keine Dummheiten."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Ich bete, dass die Welt ab\nheute ewigen Frieden genie[UNI00df]t.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, k[UNI00f6]nnen wir\nlauter coole neue Orte besuchen."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"Ich bin schon ganz gespannt auf\ndie neuen Angelpl[UNI00e4]tze in der\nganzen Welt. Das wird so toll!"
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"Ich w[UNI00fc]nschte nur, Fabio w[UNI00fc]rde\nsich auch f[UNI00fc]r andere Dinge\nals Angeln interessieren."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "Ich hab ein dummes Gef[UNI00fc]hl bei der\nZelmit-Mine. Sei vorsichtig, ja?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, muss\nich vielleicht auch mal hier raus."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"Mir machst du nichts vor. Ich\nwei[UNI00df], dass du alle m[UNI00f6]glichen tollen\nSachen gemacht hast. Erz[UNI00e4]hl mal!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Wenn die Blackstone-Bahn fertig\nist, w[UNI00fc]rde ich gern mal\nzu den "Enden der Erde" fahren.'
		)
	end
end

--- Helper function.
local function helper_20788(arg0: s32, arg1: s32, sp: number)
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
					"Ich wohne jetzt hier,\naber ich mache mir mehr Sorgen\num Blackstone Eins.<page>Ich werde mich darum k[UNI00fc]mmern,\ndass der Zug f[UNI00e4]hrt - wie\nin den alten Zeiten."
				)
				var4 = event.GetEventData_2(13) or var4
				helper_bf8a16c2(var4, -1, 0, 0, sp + junk + 5)
				if vm.skipping() then
					return skip(2)
				end
				event.MesMake_2(
					arg0,
					"Borneo ist etwas ungeschickt,\nund Erik ist blo[UNI00df] ein Kind.<page>Nichts als Schlafen, Arbeiten,\nSchlafen und wieder Arbeiten\nf[UNI00fc]r Leute wie mich.<page>Aber so ist das Leben, was ...?"
				)
			else
				event.MesMake_2(arg0, "Wie geht's Steve?")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "Ich schaff's nicht, blo[UNI00df]\nD[UNI00e4]umchen zu drehen.")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"Pflanzen und Blumen wachsen\nnur, wenn man sie pflegt. Ich\nk[UNI00f6]nnte meine Kleinen nie verlassen."
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"Ob der geheime St[UNI00fc]tzpunkt wohl in\nOrdnung ist? Ich kann niemand hin-\nschicken, er ist ja geheim, nicht?"
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"Lila ist eine tolle Farbe.\nEs hat so eine warme K[UNI00e4]lte,\nund eine helle Dunkelheit."
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "Wenn jemand krank ist, komme\nich [UNI00fc]berall hin, um zu helfen.")
		end
		if arg1 == 7 then
			event.MesMake_2(arg0, "Nur ein Spitzenkoch kann\njederzeit und [UNI00fc]berall\ntolles Essen machen.")
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "Bei H[UNI00e4]usern gilt: Je\nrobuster, desto besser, stimmt's?")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"N[UNI00fc]sse sind nicht schlecht, aber\ndiese roten Dinger waren super.\nK[UNI00f6]nntest du noch welche holen?"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"Feuchte Luft ist Gift f[UNI00fc]r\nB[UNI00fc]cher. Ich k[UNI00f6]nnte es nie\nertragen, am Wasser zu wohnen."
			)
		end
		if arg1 == 11 then
			event.MesMake_2(
				arg0,
				"Sie sind weder s[UNI00fc][UNI00df] noch\nmodern, aber meine Kleider\nkann sonst niemand machen."
			)
		end
		if arg1 == 12 then
			event.MesMake_2(
				arg0,
				"Ein neues Haus, ein neues Ich.\nIch f[UNI00fc]hl mich wieder wie\nein junger B[UNI00e4]cker."
			)
		end
		if arg1 == 13 then
			event.MesMake_2(
				arg0,
				"Mir ist egal, was es ist,\naber ich will irgendetwas in\neine Million Teile zerschlagen!"
			)
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "Wenn du ein neues Monster findest,\nberichte sofort davon.")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"Manche sagen, das ist nichts f[UNI00fc]r\nFrauen, aber dem Schwert ist das\negal. M[UNI00f6]ge der Bessere gewinnen."
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "In diesem H[UNI00e4]uschen k[UNI00f6]nnte man\ngut eine Familie gr[UNI00fc]nden.")
		end
		if arg1 == 17 then
			event.MesMake_2(arg0, "Ob Morton wohl am Ball bleibt?\nIch mach mir Sorgen um ihn ...")
		end
		if arg1 == 18 then
			event.MesMake_2(
				arg0,
				"Falls du eine Stadt wei[UNI00df]t, die\neine Kirche braucht, bin ich\ndein Priester. Sag nur Bescheid."
			)
		end
		if arg1 == 19 then
			event.MesMake_2(
				arg0,
				"Ich denke in letzter Zeit nicht\nmehr oft an den Mond. Das muss\nan meinen neuen Freunden liegen."
			)
		end
		if arg1 == 20 then
			event.MesMake_2(arg0, "Anderer Ort, andere Fische.\nMan muss sein Denken immer\nan den Ort anpassen.")
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "Hier muss ein toller\nFischgrund sein.")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"Parn hat ein neues Frauen-\nportr[UNI00e4]t angefangen. Er sagt,\nsie wird noch h[UNI00fc]bscher als ich."
			)
		end
		if arg1 == 23 then
			event.MesMake_2(arg0, "Warum sieht Ungeziefer\nblo[UNI00df] so widerlich aus?")
		end
		if arg1 == 24 then
			event.MesMake_2(
				arg0,
				"Kannst du mein Haus noch\ns[UNI00fc][UNI00df]er machen? Ein Haus kann\nnie s[UNI00fc][UNI00df] genug sein!"
			)
		end
		if arg1 == 25 then
			event.MesMake_2(arg0, "H[UNI00e4]tte nie gedacht, dass ich in\ndem Alter umziehen w[UNI00fc]rde.")
		end
	else
		helper_be7c(arg0, arg1)
	end
end

--- Helper function.
local function helper_21e14(sp: number)
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
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	helper_20788(0, var2, sp + 3)
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
local function helper_22118()
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
local function helper_222c4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		helper_22118()
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
	helper_22118()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e534(arg0: s32)
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
		event.MesMake_2(arg0, "Wenn du mir keine Kn[UNI00fc]ller lieferst,\nkann ich dir nichts geben!")
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
			"Deine Fotografie-Stufe h[UNI00e4]ngt ab\nvon der Anzahl Ideen und Kn[UNI00fc]ller,\ndie du hast.<page>Je weiter deine Stufe steigt, umso\nmehr coole Belohnungen kriegst du."
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
local function helper_ebac(arg0: s32)
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
			return helper_e534(arg0)
		end
		if at <= 5 then
			helper_4005e7b5(arg0, 1)
			helper_b8950300(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_d1353c5b(arg0, -1, 3, 256, 208)
		end
		return helper_e534(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_4005e7b5(arg0, 1)
		event.MesMake_2(arg0, "Bring mir mal ein paar\nKn[UNI00fc]ller-Notizen, ja?")
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
		event.MesMake_2(arg0, "Sieht aus, als g[UNI00e4]be es\nkeine weiteren Kn[UNI00fc]ller mehr.")
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
		return helper_e534(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_4005e7b5(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ich hab noch [Number1] Kn[UNI00fc]ller\nherausgefunden.")
		event.SetMesDrawspeed(arg0, 0)
		helper_d1353c5b(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_4005e7b5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(
			arg0,
			"Komm schon, Mann! H[UNI00e4]ng nicht nur rum!\nWo bleiben deine neuen\nInsider-Kn[UNI00fc]ller?"
		)
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Juhu! Du hast [Number1] neue(n) Kn[UNI00fc]ller!\nIch wusste, dass du's schaffst!")
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
	return helper_e534(arg0)
end

--- Helper function.
local function helper_d1c4()
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
		event.MesMake_2(3, "Tolle Arbeit! Menschen\nsind doch nicht so nutzlos!<page>Ich hatte Unrecht!")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Das ist es. Es ist fast zu Ende.\nWir m[UNI00fc]ssen ihn nur besiegen.<page>Dann kann die Welt wieder\naufleben."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Ich glaube, ich wei[UNI00df], wie es Griffon\ngeht, aber trotzdem kann ich ihm nie\nverzeihen, was er getan hat."
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Bringe den Garten wieder in seinen\nalten Zustand und enth[UNI00fc]lle Griffons -\nich meine Sirus' - Geheimnis."
		)
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			'Was meint sie mit "Sirus\' Erinnerungen"?\nWir m[UNI00fc]ssen wohl in den Palast,\num es herauszufinden.'
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Griffon kommt davon, wenn wir nur\nherumstehen. Schnell, zum Mondblumen-Palast!")
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(
			3,
			"Wir haben wohl alle Edelsteine.\nJetzt m[UNI00fc]ssen wir schnell nach\nKazarov Stonehenge."
		)
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Egal, was hier los ist - wir brauchen\ndie Edelsteine, bevor es\nzu sp[UNI00e4]t ist.")
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "In diesem Palast fing alles an, was?\nNa egal - auf in den Garten.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Wir sollten lieber bald zum Mond-\nlabor zur[UNI00fc]ckkehren. Sie k[UNI00f6]nnten den\nIxion schon fertig gestellt haben."
		)
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Wir m[UNI00fc]ssen uns endlich gegen\nGriffon wehren. Auf zum\nPaznos-St[UNI00fc]tzpunkt.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Steh nicht nur rum!\nWir m[UNI00fc]ssen Monica retten, schnell!")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Wei[UNI00df]t du noch? Galen Agaris hat gesagt, wenn\nman das Feuerhorn bl[UNI00e4]st, [UNI00f6]ffnet\nsich der Weg."
		)
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Steh nicht nur rum!\nWir m[UNI00fc]ssen Monica retten, schnell!")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Muss diese Feuer-B[UNI00f6]e erledigen.<page>Sie ist also am Gipfel des\nGundorbergs, ja?")
		return
	end
	event.MesMake_2(
		3,
		"Wenn wir nur warten,\n[UNI00e4]ndert sich nichts.<page>Es muss Orte geben, an\ndenen wir noch nicht waren."
	)
end

--- Helper function.
local function helper_223e0(sp: number)
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
				helper_20788(3, var2, sp + junk + 34)
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
			helper_22118()
			return
		end
		if at <= 6 then
			helper_22118()
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
				helper_22118()
				helper_222c4(6)
				junk += 1
			end
			if at <= 10 then
				helper_222c4(23)
				junk += 2
			end
			return
		end
		if at <= 13 then
			if at <= 12 then
				helper_222c4(33)
			end
			return
		end
		if at <= 14 then
			helper_222c4(1)
			junk += 1
		end
		if at <= 15 then
			helper_222c4(2)
			junk += 1
		end
		if at <= 16 then
			helper_222c4(3)
			junk += 1
		end
		if at <= 17 then
			helper_222c4(7)
			junk += 1
		end
		if at <= 18 then
			helper_222c4(8)
			junk += 1
		end
		if at <= 19 then
			helper_222c4(9)
			junk += 1
		end
		if at <= 20 then
			helper_222c4(10)
			junk += 1
		end
		if at <= 21 then
			helper_222c4(11)
			junk += 1
		end
		if at <= 22 then
			helper_222c4(12)
			junk += 1
		end
		if at <= 23 then
			helper_222c4(13)
			junk += 1
		end
		if at <= 24 then
			helper_222c4(14)
			junk += 1
		end
		if at <= 25 then
			helper_222c4(15)
			junk += 1
		end
		if at <= 26 then
			helper_222c4(16)
			junk += 1
		end
		if at <= 27 then
			helper_222c4(17)
			junk += 1
		end
		if at <= 28 then
			helper_222c4(18)
			junk += 1
		end
		if at <= 29 then
			helper_222c4(19)
			junk += 1
		end
		if at <= 30 then
			helper_222c4(20)
			junk += 1
		end
		if at <= 31 then
			helper_222c4(21)
			junk += 1
		end
		if at <= 32 then
			helper_222c4(22)
			junk += 1
		end
		if at <= 33 then
			helper_222c4(32)
			junk += 1
		end
		if at <= 34 then
			helper_d1c4()
			helper_d1353c5b(3, -1, 3, 256, 208)
			junk += 1
		end
		if at <= 35 then
			helper_22118()
			helper_b0211f82(30)
			junk += 1
		end
		helper_22118()
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
		helper_20788(3, var2, sp + junk + 33)
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
				helper_22118()
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
				helper_22118()
				event.SetFadeIn(30)
				return
			end
			helper_4005e7b5(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Das geht jetzt nicht. Du musst\nerst Lin zum Leuchtturm bringen!")
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
						event.MesMake_2(3, "Na gut, die Reparaturen\nsind abgeschlossen!")
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(9)
						end
						helper_22118()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_222c4(6)
					if vm.skipping() then
						return skip(10)
					end
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_222c4(23)
						if vm.skipping() then
							return skip(11)
						end
						return
					end
					if var2 == 4 then
						local t0 = helper_ebac(3)
						if vm.skipping() then
							junk += 1
							return skip(12)
						end
						if t0 ~= 0 then
							helper_222c4(33)
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
						helper_222c4(0)
						if vm.skipping() then
							return skip(14)
						end
					end
					if var2 == 12 then
						helper_222c4(1)
						if vm.skipping() then
							return skip(15)
						end
					end
					if var2 == 6 then
						helper_222c4(2)
						if vm.skipping() then
							return skip(16)
						end
					end
					if var2 == 7 then
						helper_222c4(3)
						if vm.skipping() then
							return skip(17)
						end
					end
					if var2 == 2 then
						helper_222c4(7)
						if vm.skipping() then
							return skip(18)
						end
					end
					if var2 == 3 then
						helper_222c4(8)
						if vm.skipping() then
							return skip(19)
						end
					end
					if var2 == 5 then
						helper_222c4(9)
						if vm.skipping() then
							return skip(20)
						end
					end
					if var2 == 8 then
						helper_222c4(10)
						if vm.skipping() then
							return skip(21)
						end
					end
					if var2 == 10 then
						helper_222c4(11)
						if vm.skipping() then
							return skip(22)
						end
					end
					if var2 == 11 then
						helper_222c4(12)
						if vm.skipping() then
							return skip(23)
						end
					end
					if var2 == 13 then
						helper_222c4(13)
						if vm.skipping() then
							return skip(24)
						end
					end
					if var2 == 16 then
						helper_222c4(14)
						if vm.skipping() then
							return skip(25)
						end
					end
					if var2 == 18 then
						helper_222c4(15)
						if vm.skipping() then
							return skip(26)
						end
					end
					if var2 == 19 then
						helper_222c4(16)
						if vm.skipping() then
							return skip(27)
						end
					end
					if var2 == 20 then
						helper_222c4(17)
						if vm.skipping() then
							return skip(28)
						end
					end
					if var2 == 21 then
						helper_222c4(18)
						if vm.skipping() then
							return skip(29)
						end
					end
					if var2 == 22 then
						helper_222c4(19)
						if vm.skipping() then
							return skip(30)
						end
					end
					if var2 == 23 then
						helper_222c4(20)
						if vm.skipping() then
							return skip(31)
						end
					end
					if var2 == 24 then
						helper_222c4(21)
						if vm.skipping() then
							return skip(32)
						end
					end
					if var2 == 25 then
						helper_222c4(22)
						if vm.skipping() then
							return skip(33)
						end
					end
					if var2 == 17 then
						helper_222c4(32)
						if vm.skipping() then
							return skip(34)
						end
					end
					if var2 == 9 then
						helper_d1c4()
						helper_d1353c5b(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(35)
						end
						helper_22118()
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
						helper_22118()
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
	helper_22118()
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
			helper_223e0(sp + 0)
		end
	end
	helper_21e14(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
	helper_223e0(sp + 0)
	if vm.skipping() then
		return skip(2)
	end
end

return script
