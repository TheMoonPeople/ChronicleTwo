--!strict
-- map/s/s38/s38_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_04a254d6 = require("@lib/event/helper_04a254d6")
local helper_1844fc9c = require("@lib/event/helper_1844fc9c")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_2ba4066f = require("@lib/event/helper_2ba4066f")
local helper_470f8a56 = require("@lib/event/helper_470f8a56")
local helper_4dcf7026 = require("@lib/event/helper_4dcf7026")
local helper_52c8e591 = require("@lib/event/helper_52c8e591")
local helper_854d8da2 = require("@lib/event/helper_854d8da2")
local helper_a1c34b66 = require("@lib/event/helper_a1c34b66")
local helper_e84a97e1 = require("@lib/event/helper_e84a97e1")
local helper_e85df3b0 = require("@lib/event/helper_e85df3b0")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_1f47c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = vm.f32(var7 * -1.0)
		var3 = var7
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetNpcTrainEtc(1, arg1) or var2
	do
		local out1, out2, out3, _ = event.GetTrainNpcPos(var2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var7 = event.GetNpcTrainEtc(2, arg1) or var7
	if var3 < 0 then
		var3 = vm.f32(var7 * -1.0)
	else
		var3 = var7
	end
	event.SetCharaPos(arg0, var3, var4, var5)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "待機", 4)
end

--- Helper function.
local function helper_28678()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 8
		var2 = 1
		var2 = var2 + 1
		var2 = var2 + 1
		var2 = var2 + 1
		helper_1f47c(var1, var2)
		var1 = var1 + 1
		var2 = var2 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(0) or var0
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	var1 = 8
	event.InitLocalCnt()
	var2 = 1
	while var2 <= 25 do
		var3 = event.GetNpcStatus(var2) or var3
		if var3 == 0 then
			var2 = var2 + 1
			continue
		end
		if bit32.band(var3, 4) ~= 0 then
			var2 = var2 + 1
			continue
		end
		var4 = event.GetNpcTrainEtc(0, var2) or var4
		if var0 ~= var4 then
			var2 = var2 + 1
			continue
		end
		event.LoadCharaNpc(1, 5, var2, var1)
		helper_1f47c(var1, var2)
		event.SetLocalCnt(var1, var2)
		event.SetCharaNo(var1, var2)
		if bit32.band(var3, 1) ~= 0 then
			event.CharaActive(0, var1)
		else
			event.CharaActive(var1)
		end
		var1 = vm.i32(var1 + 1)
		var2 = var2 + 1
	end
	flag = event.GetFlag(254) or flag
	if flag ~= 0 and var0 == 3 then
		event.LoadChara(5, "event/train/tp02_01a.gltf", "info", var1)
		event.SetCharaPos(var1, 0.0, 0.0, -200.0)
		event.SetCharaRot(var1, 0.0, 0.0, 0.0)
		event.SetMotion(var1, "立ち", 4)
		event.SetLocalCnt(var1, 34)
		event.SetCharaNo(var1, 34)
		event.CharaActive(var1)
	end
end

--- Helper function.
local function helper_29084(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var2 = out2 or var2
	end
	var4 = vm.f32(arg0 + vm.f32(6.2831855))
	var5 = vm.f32(var2 + vm.f32(6.2831855))
	var6 = vm.f32(var4 - var5)
	if var6 < 0 then
		var6 = vm.f32(var6 * -1.0)
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, arg0, 0.0, vm.ftoi(vm.f32(var6 * 10.0)))
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_28ef0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 8
			var0 = var0 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = 8
	while var0 < 20 do
		event.DeleteChara(var0)
		event.DeleteVillager(var0)
		var0 = var0 + 1
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_29588()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 86
			var1 = 64
			helper_a1c34b66(0)
		end
		if at <= 2 then
			helper_a1c34b66(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 1 then
		var1 = 86
	else
		var1 = 64
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotDelay(0, var1)
	event.ObjsRotation(0, rot_x, rot_y, rot_z, 6)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(3)
	end
	event.Finish()
end

--- Helper function.
local function helper_25f28(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_2602c()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_25f28(15)
		end
		if at <= 2 then
			helper_25f28(1)
		end
		if at <= 3 then
			helper_25f28(6)
		end
		if at <= 4 then
			helper_25f28(0)
		end
		if at <= 5 then
			helper_25f28(4)
		end
		if at <= 6 then
			helper_25f28(31)
		end
		if at <= 7 then
			helper_25f28(35)
		end
		if at <= 8 then
			helper_25f28(36)
		end
		if at <= 9 then
			helper_25f28(37)
		end
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Benvenuti.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Si lavora sodo, vedo!\nTi serve qualcosa?<page>Per[UNI00f2], niente omaggi.\nNeanche per te, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"Vi servono altri elementi\nDiorama?<page>Se non avete tempo di cercarli\nda soli, i soldi potrebbero\nrisolvere i vostri problemi."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Salve. Sono apprendista fornaia.\nSostituisco Polly al forno\nquando non c'[UNI00e8].<page>Sono un po' nervosa, ma fa parte\nanche questo dell'apprendistato.\nFar[UNI00f2] del mio meglio!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Forse non ci somigliamo molto...\nMa sono la sorellina di Milane.<page>Mi ha lasciata qui a badare al\nnegozio, ma non mi intendo d'armi!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Sorpreso, vero? Immagino chiunque\nrimarrebbe meravigliato nel vedere\nqualcuno vestito cos[UNI00ec].<page>Sostituisco il mio amico Don Bruno\nche [UNI00e8] in viaggio. Allora, posso\nesserti d'aiuto in qualche modo?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
			)
		end
	end
	if var1 ~= -1 then
		helper_52c8e591(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_25f28(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_25f28(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_25f28(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_25f28(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_25f28(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_25f28(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_25f28(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_25f28(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_25f28(37)
		if vm.skipping() then
			return skip(10)
		end
	end
end

--- Helper function.
local function helper_1d1e8(arg0: s32, arg1: s32)
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
local function helper_20844(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_854d8da2(1)
		helper_1f47c(arg0, argc)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_854d8da2(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_1f47c(arg0, argc)
	end
end

--- Helper function.
local function helper_20aec(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		helper_20844(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_20844(arg0, arg1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1f770(arg0: s32)
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
			helper_04a254d6(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_470f8a56(arg0, 1)
			helper_e84a97e1(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_04a254d6(arg0, -1, 3, 256, 208)
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
		helper_470f8a56(arg0, 1)
		event.MesMake_2(arg0, "Se non mi porti altri scoop,\nnon posso darti nulla!")
		if now_map_no == 22 then
			helper_e84a97e1(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_04a254d6(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_470f8a56(arg0, 1)
		event.MesMake_2(
			arg0,
			"Il numero di idee e di scoop\ndetermineranno il tuo Livello\nfotografico.<page>Salendo di livello, riceverai\nin premio altri oggetti magnifici."
		)
		if now_map_no == 22 then
			helper_e84a97e1(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_04a254d6(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_1fdb8(arg0: s32)
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
				helper_04a254d6(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_04a254d6(arg0, -1, 3, 256, 208)
			end
			return helper_1f770(arg0)
		end
		if at <= 5 then
			helper_470f8a56(arg0, 1)
			helper_e84a97e1(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_04a254d6(arg0, -1, 3, 256, 208)
		end
		return helper_1f770(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_470f8a56(arg0, 1)
		event.MesMake_2(arg0, "Andresti a prendermi\nun Blocchetto Scoop?")
		if now_map_no == 22 then
			helper_e84a97e1(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_04a254d6(arg0, -1, 3, 256, 208)
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
		helper_470f8a56(arg0, 1)
		event.MesMake_2(arg0, "Sembra non ci siano\naltri scoop.")
		if now_map_no == 22 then
			helper_e84a97e1(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_04a254d6(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_1f770(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_470f8a56(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ho trovato ancora [Numero1] scoop.")
		event.SetMesDrawspeed(arg0, 0)
		helper_04a254d6(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_470f8a56(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Allora, amico! Non startene\nimpalato! Dove sono i tuoi scoop?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Wow! Hai ottenuto [Number1] scoop!\nSapevo che ce l'avevi nel sangue!")
	end
	if now_map_no == 22 then
		helper_e84a97e1(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_04a254d6(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_1f770(arg0)
end

--- Helper function.
local function helper_1e520()
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
local function helper_20c20(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: any = 0
	local var25: s32 = 0
	local var26: s32 = 0
	local var27: s32 = 0
	local var28: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			argc = 1
			argc = 2
			argc = 13
			return
		end
		if at <= 5 then
			if at <= 2 then
				var24 = 0
				helper_470f8a56(3, 1)
				helper_1d1e8(3, argc)
				var25 = -1
				helper_e85df3b0(3, var25, 3, 256, 208)
				helper_470f8a56(1, 8)
				helper_e85df3b0(1, 1, 1, 0, 0)
				helper_470f8a56(2, 2)
				var25 = 30
				var25 = 31
				var25 = 32
				var24 = helper_1844fc9c(2, var25, 7, 0, 0, var28, var28 - 1)
			end
			if at <= 3 then
				helper_854d8da2(3)
				helper_efffcfbb(30)
			end
			helper_20844(arg0, arg1)
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_470f8a56(3, 8)
				helper_04a254d6(3, var25, 9, 0, 0)
			end
			if at <= 7 then
				helper_04a254d6(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_20844(arg0, arg1)
				helper_20aec(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_20aec(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_20aec(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_20aec(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_20aec(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_20aec(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_20aec(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_20aec(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_20aec(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_20aec(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_20aec(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_20aec(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_20aec(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_20aec(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_20aec(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_20aec(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_20aec(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_20aec(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_20aec(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_20aec(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_20aec(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_20aec(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_20aec(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_1e520()
			helper_04a254d6(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_20844(arg0, arg1)
			helper_efffcfbb(30)
		end
		helper_20844(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		argc = 1
	elseif arg1 == 2 then
		argc = 2
	elseif arg1 == 3 then
		argc = 13
	else
		argc = event.GetLocalCnt(arg0) or argc
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if argc == now_party_chara_id then
		return
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if argc == 18 then
		var4 = 20
	end
	if argc == 25 then
		var4 = 24
	end
	if argc == 12 or argc == 17 then
		var4 = 28
	end
	if argc == 7 then
		var4 = 32
	end
	if argc == 10 or argc == 6 or argc == 24 then
		var4 = 40
	end
	if argc == 8 or argc == 1 or argc == 2 or argc == 3 or argc == 15 or argc == 16 or argc == 21 then
		var4 = 44
	end
	if argc == 4 or argc == 19 or argc == 20 or argc == 22 then
		var4 = 48
	end
	if argc == 5 or argc == 11 or argc == 23 or argc == 13 then
		var4 = 52
	end
	if argc == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	event.EyeViewDrawOnOff(1)
	if arg1 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local out1, out2, out3 = event.EohGetPos(0)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local _, out2, _ = event.EohGetRot(0)
			var9 = out2 or var9
		end
	else
		var11 = event.GetNpcTrainEtc(1, argc) or var11
		do
			local out1, out2, out3, out4 = event.GetTrainNpcPos(var11)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
			var9 = out4 or var9
		end
		event.EohSyncChara(0, arg0)
		event.EohSetPos(0, var5, var6, var7)
		event.EohSetRot(0, 0.0, var9, 0.0)
		event.SetMotion(arg0, "立ち", 4)
	end
	var12 = vm.f32(vm.sin(var9) * 75.0)
	var12 = vm.f32(var12 + var5)
	var13 = vm.f32(var6 + 45.0)
	var14 = vm.f32(vm.cos(var9) * 75.0)
	var14 = vm.f32(var14 + var7)
	event.SetCameraPos(var12, var13, var14)
	var15 = var5
	var16 = vm.f32(var6 + 30.0)
	var17 = var7
	event.SetCameraRef(var15, var16, var17)
	var18 = vm.f32(vm.sin(var9) * 30.0)
	var18 = vm.f32(var18 + var5)
	var19 = var6
	var20 = vm.f32(vm.cos(var9) * 30.0)
	var20 = vm.f32(var20 + var7)
	event.SetCharaPos(0, var18, var19, var20)
	var21 = 0
	var22 = vm.f32(var9 + vm.f32(3.1415927))
	if var22 > vm.f32(3.1415927) then
		var22 = vm.f32(var22 - vm.f32(6.2831855))
	end
	var23 = 0
	event.SetCharaRot(0, var21, var22, var23)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var24 = 0
	while true do
		helper_470f8a56(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_1d1e8(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_e85df3b0(3, var25, 3, 256, 208)
		helper_470f8a56(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_e85df3b0(1, 1, 1, 0, 0)
		helper_470f8a56(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(argc, 4)
			var25 = out1 or var25
			var28 = out2 or var28
		end
		if var28 == 3 then
			var25 = 30
		end
		if var28 == 4 then
			event.SetMesItemDirect(2, 1, var25)
			var25 = 31
		end
		if var28 == 5 then
			event.SetMesItemDirect(2, 1, var25)
			event.SetMesItemDirect(2, 2, vm.i32(var25 + 1))
			var25 = 32
		end
		var24 = helper_1844fc9c(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		if vm.skipping() then
			return skip(3)
		end
		helper_854d8da2(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_efffcfbb(30)
				if vm.skipping() then
					return skip(4)
				end
				if arg1 == 0 then
					event.CharaActive(0, arg0)
					argc_2 = event.GetLocalCnt2(now_party_chara_id) or argc_2
					if 0 <= argc_2 then
						event.CharaActive(argc_2)
					end
				end
				event.SetNpcStatus(argc, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(5)
				end
				helper_20844(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_470f8a56(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Non puoi farlo ora. Devi prima\nportare Lin al faro!")
			helper_04a254d6(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_470f8a56(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_04a254d6(3, var25, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var28 then
			if var28 == 5 then
				if var24 == 2 then
					if argc == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "Benone, con le riparazioni\nabbiamo finito!")
						helper_04a254d6(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_20844(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_20aec(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_20aec(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_1fdb8(3)
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_20aec(arg0, arg1, 33)
							if vm.skipping() then
								return skip(12)
							end
							return
						end
					end
				end
				if var24 == 4 then
					break
				end
				if var24 == -1 then
					break
				end
			else
				if var24 == 2 then
					if argc == 15 then
						helper_20aec(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_20aec(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_20aec(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_20aec(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_20aec(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_20aec(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_20aec(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_20aec(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_20aec(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_20aec(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_20aec(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_20aec(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_20aec(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_20aec(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_20aec(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_20aec(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_20aec(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_20aec(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_20aec(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_20aec(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_20aec(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_1e520()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_04a254d6(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_20844(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_efffcfbb(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_20844(arg0, arg1)
						event.SetFadeIn(30)
					end
					return
				end
				if var24 == 3 then
					break
				end
				if var24 == -1 then
					break
				end
			end
		else
			if var24 == 2 then
				break
			end
			if var24 == -1 then
				break
			end
		end
	end
	helper_20844(arg0, arg1)
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.Initialize()
	print("##IN_START_EVENT################################\n")
	helper_28678()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(1, 3)
	event.ResetCamera(1)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_2ba4066f(1)
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_28ef0()
		end
		if at <= 3 then
			helper_4dcf7026()
		end
		if at <= 4 then
			helper_29588()
		end
	end
	print("--------------------------event200-------------------------\n")
	helper_29084(vm.f32(-1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_2ba4066f(1)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_efffcfbb(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 1)
		helper_28ef0()
		if vm.skipping() then
			return skip(3)
		end
		event.StopBgm(0)
		helper_4dcf7026()
		if vm.skipping() then
			return skip(4)
		end
	else
		helper_29588()
		if vm.skipping() then
			return skip(5)
		end
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_2ba4066f(0)
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_28ef0()
		end
		if at <= 3 then
			helper_4dcf7026()
		end
		if at <= 4 then
			helper_29588()
		end
	end
	print("--------------------------event201-------------------------\n")
	helper_29084(vm.f32(1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_2ba4066f(0)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_efffcfbb(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 0)
		helper_28ef0()
		if vm.skipping() then
			return skip(3)
		end
		event.StopBgm(0)
		helper_4dcf7026()
		if vm.skipping() then
			return skip(4)
		end
	else
		helper_29588()
		if vm.skipping() then
			return skip(5)
		end
	end
end

--- Program 202.
script[202] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_28ef0()
		end
		var1 = var1 - 1
		helper_28678()
	end
	print("--------------------------event202-------------------------\n")
	helper_29084(0.0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_28ef0()
	if vm.skipping() then
		return skip(3)
	end
	var1 = event.GetCnt(0) or var1
	if var1 == 1 then
		event.SetCnt(0, 0)
		event.SetCharaPos(0, 0.0, -22.4, -207.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.MapJump(-1, "s37")
	else
		var1 = vm.i32(var1 - 1)
		event.SetCnt(0, var1)
		helper_28678()
		event.SetCharaPos(0, 0.0, -14.0, -235.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- Program 203.
script[203] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_28ef0()
		end
		if at <= 3 then
			var1 = vm.i32(var1 + 1)
			helper_28678()
			helper_29588()
		end
	end
	print("--------------------------event203-------------------------\n")
	helper_29084(vm.f32(3.1415927))
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	var1 = event.GetCnt(0) or var1
	if var1 ~= 3 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_efffcfbb(30)
		if vm.skipping() then
			return skip(2)
		end
		helper_28ef0()
		if vm.skipping() then
			return skip(3)
		end
		var1 = vm.i32(var1 + 1)
		event.SetCnt(0, var1)
		helper_28678()
		event.SetCharaPos(0, 0.0, -14.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	else
		helper_29588()
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_20c20(var0, 0)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	argc = event.GetLocalCnt(var0) or argc
	if argc == 34 then
		event.SetMesEtc(1, 10, 0)
		helper_2602c()
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesEtc(1, 10, 128)
	else
		helper_20c20(var0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
