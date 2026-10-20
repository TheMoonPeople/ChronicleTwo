--!strict
-- map/i/i02/h03/i02h03_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_044fd257 = require("@lib/event/helper_044fd257")
local helper_05124d17 = require("@lib/event/helper_05124d17")
local helper_06ced885 = require("@lib/event/helper_06ced885")
local helper_0a65605d = require("@lib/event/helper_0a65605d")
local helper_0bf1ae31 = require("@lib/event/helper_0bf1ae31")
local helper_13fb948c = require("@lib/event/helper_13fb948c")
local helper_14c603be = require("@lib/event/helper_14c603be")
local helper_17f6013d = require("@lib/event/helper_17f6013d")
local helper_1993eb91 = require("@lib/event/helper_1993eb91")
local helper_1e26b26a = require("@lib/event/helper_1e26b26a")
local helper_1e7bfebe = require("@lib/event/helper_1e7bfebe")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_1f514f60 = require("@lib/event/helper_1f514f60")
local helper_21410453 = require("@lib/event/helper_21410453")
local helper_223a6c9b = require("@lib/event/helper_223a6c9b")
local helper_26edd796 = require("@lib/event/helper_26edd796")
local helper_2737ad20 = require("@lib/event/helper_2737ad20")
local helper_2a7ca4d6 = require("@lib/event/helper_2a7ca4d6")
local helper_301cc268 = require("@lib/event/helper_301cc268")
local helper_35963413 = require("@lib/event/helper_35963413")
local helper_3daa96be = require("@lib/event/helper_3daa96be")
local helper_3f6dc8d5 = require("@lib/event/helper_3f6dc8d5")
local helper_4111b872 = require("@lib/event/helper_4111b872")
local helper_47171f2d = require("@lib/event/helper_47171f2d")
local helper_49ecb44b = require("@lib/event/helper_49ecb44b")
local helper_5072f1ea = require("@lib/event/helper_5072f1ea")
local helper_51055bf8 = require("@lib/event/helper_51055bf8")
local helper_51dafb2f = require("@lib/event/helper_51dafb2f")
local helper_5515f51f = require("@lib/event/helper_5515f51f")
local helper_570fb977 = require("@lib/event/helper_570fb977")
local helper_57b5870c = require("@lib/event/helper_57b5870c")
local helper_65a46639 = require("@lib/event/helper_65a46639")
local helper_667d4346 = require("@lib/event/helper_667d4346")
local helper_67360d22 = require("@lib/event/helper_67360d22")
local helper_6e6d58da = require("@lib/event/helper_6e6d58da")
local helper_6f891cfe = require("@lib/event/helper_6f891cfe")
local helper_79472a56 = require("@lib/event/helper_79472a56")
local helper_7d091696 = require("@lib/event/helper_7d091696")
local helper_7e0167b5 = require("@lib/event/helper_7e0167b5")
local helper_82fb1428 = require("@lib/event/helper_82fb1428")
local helper_9e15e4bf = require("@lib/event/helper_9e15e4bf")
local helper_9f5da53c = require("@lib/event/helper_9f5da53c")
local helper_a6f8c0d6 = require("@lib/event/helper_a6f8c0d6")
local helper_abdb8009 = require("@lib/event/helper_abdb8009")
local helper_acfd40a3 = require("@lib/event/helper_acfd40a3")
local helper_b03eb2e1 = require("@lib/event/helper_b03eb2e1")
local helper_b1529faf = require("@lib/event/helper_b1529faf")
local helper_b3288bdf = require("@lib/event/helper_b3288bdf")
local helper_b4d2c2e6 = require("@lib/event/helper_b4d2c2e6")
local helper_b5826b0b = require("@lib/event/helper_b5826b0b")
local helper_b73fcc0e = require("@lib/event/helper_b73fcc0e")
local helper_bb0e2de8 = require("@lib/event/helper_bb0e2de8")
local helper_bd4ec2c7 = require("@lib/event/helper_bd4ec2c7")
local helper_c29e3999 = require("@lib/event/helper_c29e3999")
local helper_c3547a0e = require("@lib/event/helper_c3547a0e")
local helper_c3fc8101 = require("@lib/event/helper_c3fc8101")
local helper_c524548b = require("@lib/event/helper_c524548b")
local helper_c52e9159 = require("@lib/event/helper_c52e9159")
local helper_c60a8e40 = require("@lib/event/helper_c60a8e40")
local helper_cc7603b9 = require("@lib/event/helper_cc7603b9")
local helper_cebfd01a = require("@lib/event/helper_cebfd01a")
local helper_cecbde9f = require("@lib/event/helper_cecbde9f")
local helper_d1e65749 = require("@lib/event/helper_d1e65749")
local helper_d91a9d4e = require("@lib/event/helper_d91a9d4e")
local helper_d9cdd3a3 = require("@lib/event/helper_d9cdd3a3")
local helper_de64e465 = require("@lib/event/helper_de64e465")
local helper_dfe5e894 = require("@lib/event/helper_dfe5e894")
local helper_e143ba08 = require("@lib/event/helper_e143ba08")
local helper_e1a643b1 = require("@lib/event/helper_e1a643b1")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_e498de46 = require("@lib/event/helper_e498de46")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_e720c6d4 = require("@lib/event/helper_e720c6d4")
local helper_e83cea40 = require("@lib/event/helper_e83cea40")
local helper_e88f05ef = require("@lib/event/helper_e88f05ef")
local helper_e9affa6d = require("@lib/event/helper_e9affa6d")
local helper_e9b69603 = require("@lib/event/helper_e9b69603")
local helper_eb560126 = require("@lib/event/helper_eb560126")
local helper_f39cfbfe = require("@lib/event/helper_f39cfbfe")
local helper_f9e179e1 = require("@lib/event/helper_f9e179e1")

--- Helper function.
local function helper_eae4(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b03eb2e1(1, 4)
			var1 = 50
			var1 = 51
			helper_cc7603b9(1, var1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_b03eb2e1(1, 4)
	event.MesSetBuff(1, 1, 1)
	var2 = event.GetPartyCharaMesNo_3(arg0, 0) or var2
	event.SetMesItemDirect(1, 1, var2)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if true then
		var1 = 50
	else
		var4 = event.GetPartyCharaMesNo_3(now_party_chara_id, 0) or var4
		event.SetMesItemDirect(1, 2, var4)
		var1 = 51
	end
	helper_cc7603b9(1, var1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesSetBuff(1, 1, 0)
end

--- Helper function.
local function helper_11de0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eae4(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_eae4(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_18428(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11de0()
		end
		if at <= 8 then
			helper_eae4(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Te he estado esperando.<page>R[UNI00e1]pido, dame la Pintura para\ndar vida a mi cuadro.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(376)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 376 then
		event.MesMake_2(
			0,
			"[UNI00a1]Est[UNI00e1]s de broma!<page>Lo que necesito es Pintura dorada.\n[UNI00a1]No te equivoques!"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "O sea que esta es la Pintura dorada...\nLa probar[UNI00e9] ahora mismo.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Es... Es real...<page>[UNI00a1]Incre[UNI00ed]ble, es perfecta!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Gracias, Max.\nNo he olvidado mi promesa. Usa mi\nnuevo poder cuando quieras.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_eae4(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_18e58(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_26edd796(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_26edd796(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_49ecb44b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_18428(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_82fb1428(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_bf78()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("IN go_shop_up()\n")
			print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
			helper_47171f2d(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_65a46639(15)
		end
		if at <= 3 then
			helper_65a46639(1)
		end
		if at <= 4 then
			helper_65a46639(6)
		end
		if at <= 5 then
			helper_65a46639(0)
		end
		if at <= 6 then
			helper_65a46639(4)
		end
		if at <= 7 then
			helper_65a46639(31)
		end
		if at <= 8 then
			helper_65a46639(35)
		end
		if at <= 9 then
			helper_65a46639(36)
		end
		if at <= 10 then
			helper_65a46639(37)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bienvenido.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Trabajando duro, [UNI00bf]no?\n[UNI00bf]Necesit[UNI00e1]is algo?<page>Pero por la cara, nada.\nNi siquiera para ti, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"[UNI00bf]Necesitas m[UNI00e1]s elementos\nde Georama?<page>Si no tienes tiempo\npara conseguirlos t[UNI00fa] mismo, a lo mejor\npuedes solucionar tus problemas con un poco de dinero."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Hola. Soy un aprendiz de panadero.\nMe encargo de la panader[UNI00ed]a mientras\nPolly est[UNI00e1] fuera.<page>Estoy un poco nervioso, pero es\nparte de mi formaci[UNI00f3]n, supongo.\n[UNI00a1]Har[UNI00e9] lo que pueda!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"No nos parecemos mucho...\nPero soy la hermana peque[UNI00f1]a de Milane.<page>Me pidi[UNI00f3] que cuidara de la tienda mientras ella no est[UNI00e1].\n[UNI00a1]Yo no s[UNI00e9] nada de armas!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]Te he sorprendido, a que s[UNI00ed]? Cualquiera se sorprender[UNI00ed]a\nal ver a alguien\nvestido de esta manera aqu[UNI00ed].<page>Soy un buen amigo del Padre Bruno. Estoy\npara informar a la gente mientras [UNI00e9]l est[UNI00e1] de viaje.\nBueno, [UNI00bf]te puedo ayudar en algo?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
			)
		end
	end
	if var1 ~= -1 then
		helper_47171f2d(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_65a46639(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_65a46639(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_65a46639(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_65a46639(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_65a46639(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_65a46639(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_65a46639(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_65a46639(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_65a46639(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_19be0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_11de0()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_17f6013d(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(201) or argc
	argc_2 = event.GetItemNum(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9]? Ah, un coleccionista de monedas.<page>Estoy buscando la Moneda negra\ny la Moneda indestructible.<page>No se ven en ninguna parte. Las he buscado\npor todos lados pero no hay quien las encuentre."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Eh? [UNI00bf]Las tienes? [UNI00a1]Incre[UNI00ed]ble!<page>[UNI00a1]No te quedes ah[UNI00ed]! [UNI00a1]Dame, dame, dame!"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Vale.\n[UNI00bf]Qu[UNI00e9] tengo que hacer?")
	var5 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "[UNI00a1]Agh! Si vas a cabrearme,\npaso de ayudarte.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(201)
	event.SubItem(202)
	event.MesMake_2(
		0,
		"[UNI00a1]Guau! [UNI00a1]Ya las tengo todas!\nCre[UNI00ed]a que era imposible...<page>Bueno, ahora creo que no tengo alternativa.\nSer[UNI00e1] mejor que vaya contigo."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_1aa20(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_044fd257(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_4111b872(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_19be0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_e143ba08(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_1ba98(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "[UNI00bf]Has conseguido alguna Casta[UNI00f1]a?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(301)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 301 then
		event.MesMake_2(0, "No puedes...<page>En fin, tendr[UNI00e9] que dejar\nel Castagnaccio.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Muy bien. Muchas gracias.<page>Intentar[UNI00e9] preparar algo de Castagnaccio.<page>Te lo dar[UNI00e9] a probar en cuanto termine."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Puedo devolverte el favor de alguna manera?<page>[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e en tu aventura?<page>[UNI00a1]Ja, ja! Eso est[UNI00e1] hecho.<page>[UNI00bf]Por qu[UNI00e9] no me has preguntado antes?"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1c408(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5072f1ea(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_5072f1ea(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_21410453(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_301cc268(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1ba98(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_b3288bdf(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1d400(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11de0()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_6f891cfe(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	photo = event.CheckInventPhoto(2009) or photo
	photo_2 = event.CheckInventPhoto(52, 3) or photo_2
	photo_3 = event.CheckInventPhoto(53, 3) or photo_3
	photo_4 = event.CheckInventPhoto(54, 3) or photo_4
	photo_5 = event.CheckInventPhoto(55, 3) or photo_5
	if vm.i32(vm.i32(vm.i32(vm.i32(photo + photo_2) + photo_3) + photo_4) + photo_5) <= 0 then
		event.MesMake_2(
			0,
			"[UNI00bf]Tienes fotos de flores raras?<page>S[UNI00e9] mucho de flores, as[UNI00ed] que si\nno es algo especial, no me va a interesar."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00bf]Tienes fotos de flores raras?\n[UNI00a1]A ver, a ver!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "[UNI00a1]Guau! [UNI00a1]Alucinante!\nAs[UNI00ed] que estas son las flores que se ven fuera.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Umm... [UNI00bf]Qu[UNI00e9] hago?<page>Bueno, venga. Me voy con vosotros.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1df60(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b73fcc0e(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_b73fcc0e(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_667d4346(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1d400(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_de64e465(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1f158(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_e2203e72(30)
			end
			return
		end
		if at <= 13 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"Ese dinero no\nme vale para la subasta.<page>Necesito 1000 Gildas.\nNo s[UNI00e9] si est[UNI00e1] claro."
			)
			helper_e5219064(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(0, "[UNI00a1]No te lo vas a creer!<page>El precio ha subido a\n1200 Gildas.")
			helper_e5219064(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(0, "Lo siento mucho, pero [UNI00bf]podr[UNI00ed]as\nconseguir 1500 Gildas?")
			helper_e5219064(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetCnt(9, 1)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.MesMake_2(
				0,
				"No podemos perder el tiempo,\nsi no, se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 1500 Gildas cuanto antes!"
			)
			helper_e5219064(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"[UNI00a1]Es terrible!\nAlguien ofrece 1800 Gildas.<page>Si no doy m[UNI00e1]s de 2000,\nno me lo llevar[UNI00e9] ni en broma."
			)
			helper_e5219064(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetCnt(9, 2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.MesMake_2(
				0,
				"No podemos perder el tiempo,\nsi no se lo vender[UNI00e1]n a otro.<page>[UNI00a1]Cons[UNI00ed]gueme 2000 Gildas cuanto antes!"
			)
			helper_e5219064(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Sonny, [UNI00bf]has conseguido reunir\nlas 2000 Gildas?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] hago? Es tuyo.\nHa sido un despilfarro.")
		var4 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"Ya... Bueno, 2000 Gildas es mucho dinero.\nDebe de ser duro gast[UNI00e1]rselo.\nIncluso para un joven bien acomodado como t[UNI00fa]... <page>Bueno, no importa.\nPero la subasta a[UNI00fa]n no ha terminado.\nEsperar[UNI00e9] lo que haga falta..."
			)
			helper_e5219064(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Gracias por todo.<page>[UNI00a1]Me largo corriendo a la subasta!")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_e2203e72(30)
		if vm.skipping() then
			return skip(12)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		event.Finish()
		return
	end
	event.MesMake_2(0, "Muchas gracias.\nHe conseguido ganar la subasta.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"Puj[UNI00e9] mucho y los dem[UNI00e1]s desistieron\nr[UNI00e1]pidamente. [UNI00a1]Me lo he llevado por 1400 Gildas!"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Tengo que devolverte 600.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(0, "Y trabajar[UNI00e9] para devolverte\nel resto del dinero que te debo.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"S[UNI00e9] que te he causado muchas molestias.\nTe devolver[UNI00e9] el favor en cualquier momento."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_20aa8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_0a65605d(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_0a65605d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_d91a9d4e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_e498de46(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1f158(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_6e6d58da(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_f8b8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b03eb2e1(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_b03eb2e1(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_cc7603b9(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2293c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb560126(arg0, 0, 0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			var2 = 259
			var2 = 258
			var2 = 260
			helper_f8b8(var2, 1)
		end
		if at <= 6 then
			helper_13fb948c(1)
		end
		if at <= 7 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_11de0()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "[UNI00a1]Ah, Max! Ya he acabado una prenda.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"No quer[UNI00ed]a dejar\nque desecharan los materiales que me trajiste\ny gracias a eso llegu[UNI00e9] hasta el final."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "No me he quedado completamente satisfecha,\n[UNI00bf]pero te lo pondr[UNI00ed]as igualmente?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	var2 = 259
	argc = event.GetItemNum(258) or argc
	if argc <= 0 then
		var2 = 258
	else
		argc = event.GetItemNum(260) or argc
		if argc <= 0 then
			var2 = 260
		end
	end
	event.AddItem(var2)
	helper_f8b8(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_13fb948c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ah, qu[UNI00e9] bien sienta\nterminar algo.<page>Ahora siento mucha\nm[UNI00e1]s confianza.<page>Har[UNI00e9] todo lo que pueda.\nLlevadme con vosotros."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_23290(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b5826b0b(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_c524548b(arg0, arg1)
			end
			if at <= 6 then
				helper_2293c(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_b5826b0b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_57b5870c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_e88f05ef(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_bb0e2de8(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_c524548b(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_2293c(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_b1529faf(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_24b60(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_f8b8(300, 20)
		end
		if at <= 5 then
			helper_13fb948c(1)
		end
		if at <= 6 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Quieres que\nte acompa[UNI00f1]e?<page>S[UNI00f3]lo soy una mujer que hace Pan,\npero si crees que puedo ser [UNI00fa]til,\nir[UNI00e9] encantada."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Ah, pero antes tengo\nque hacer un env[UNI00ed]o a Morton.<page>[UNI00bf]Te importar[UNI00ed]a llevarle 20 barras\nde Pan a Morton a su tienda?"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Mientras vas y vienes,\nhar[UNI00e9] las maletas.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_f8b8(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_13fb948c(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] querr[UNI00e1] hacer\ncon 20 barras?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_25140(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"Lo siento, todav[UNI00ed]a\nno estoy lista.<page>[UNI00bf]Puedes darme un poco m[UNI00e1]s de tiempo?"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Por cierto: [UNI00bf]has ido ya\na ver a Morton de mi parte?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Qu[UNI00e9]? [UNI00bf]C[UNI00f3]mo puede ser tan\ndesconsiderado?<page>En fin,\npuedes qued[UNI00e1]rtelas."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "No importa.\nEn marcha.<page>[UNI00bf]A d[UNI00f3]nde\nvamos?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_11de0()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_259a8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1993eb91(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1993eb91(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_d9cdd3a3(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_24b60(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_25140(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_a6f8c0d6(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_159e8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7e0167b5(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_7e0167b5(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_7e0167b5(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_7e0167b5(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_11de0()
		end
	end
	do
		local out1, out2, out3, out4 = event.Stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(0, "Hola, Max.\n[UNI00bf]Quieres probar otra vez?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_7e0167b5(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(
			0,
			"Eh. No has ido hasta la barca,\n[UNI00bf]no? Quer[UNI00ed]as enga[UNI00f1]arme.\n[UNI00a1]No seas tramposo!"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_7e0167b5(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "[UNI00a1]Eh, no hagas trampas!")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_7e0167b5(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "Has llegado.\nBien,<page>vamos a ver\ntu tiempo.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "[UNI00a1]Vaya por Dios!\n[数値２] minutos.[数値３] segundos.\nDemasiado lento.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(0, "[UNI00bf]Quieres probar otra vez?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_7e0167b5(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(0, "[UNI00a1]Oh!\n[数値１] minutos [数値２] segundos[数値３].\nNo est[UNI00e1] mal.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(
		0,
		"Eres m[UNI00e1]s r[UNI00e1]pido de lo que parece. Vale,\nvamos a pelear contra los malos juntos."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_168e0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_06ced885(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_06ced885(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_e720c6d4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_570fb977(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_cecbde9f(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_159e8(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_51dafb2f(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_2618c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_f8b8(44, 1)
		end
		if at <= 6 then
			helper_13fb948c(1)
		end
		if at <= 7 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "T[UNI00fa] eres M[UNI00f3]nica,\n[UNI00bf]no?<page>Me han dicho que no\nmanejas mal la espada.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pero las espadas no\nson ning[UNI00fa]n juguete.<page>Tienes que darte cuenta de lo que tienes enfrente."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Si puedes mejorar dos niveles una espada,\nadmitir[UNI00e9] que tienes aptitudes.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Empieza con este\nGladius.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_f8b8(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_13fb948c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Si quieres que Milane te acepte, deber[UNI00e1]s\nmejorar el Gladius\ndos niveles.")
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tambi[UNI00e9]n se pueden comprar o recoger armas.\n Consigue un arma fuerte y\n Milane te ayudar[UNI00e1]."
	)
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

--- Helper function.
local function helper_26940(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(67) or argc
	argc_2 = event.GetItemNum(69) or argc_2
	if argc <= 0 and argc_2 <= 0 then
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] clase de espada es esa?\n[UNI00bf]Hablabas por hablar?<page>[UNI00a1]Fuera de aqu[UNI00ed]!\nMe est[UNI00e1]s estorbando."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Guau, vaya espada\nm[UNI00e1]s bonita.<page>Siento haber\ntenido que ponerte a prueba.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Es que si lucho contra\nun aficionado me pongo yo tambi[UNI00e9]n en peligro.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Aunque me parece que\ncontigo no hay de qu[UNI00e9] preocuparse.<page>Venga, vamos\na luchar.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_273d4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b4d2c2e6(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_b4d2c2e6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_f9e179e1(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_2618c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_26940(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_abdb8009(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_27b48(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_f8b8(24, 1)
		end
		if at <= 6 then
			helper_13fb948c(1)
		end
		if at <= 7 then
			helper_cc7603b9(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Seg[UNI00fa]n Cedric,\nhas estado fuera\npor ciertos asuntos.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Eres bueno en muchas cosas,\npero luego\nnunca terminas nada.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Por eso cuando me pides\nayuda me resulta dif[UNI00ed]cil tomarte\nen serio a la primera.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Ya. [UNI00bf]Por qu[UNI00e9] no mejoras esta Pistola Trompeta y la conviertes en Pistola Campana?<page>[UNI00bf]Ser[UNI00e1]s capaz?"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_f8b8(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_13fb948c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Para conseguir que Gerald te acepte,\n tendr[UNI00e1]s que\nconseguirle una Pistola Trompeta.<page>[(!)]Puedes mejorar el arma\n que te han dado, comprar una\n o conseguir una en las Mazmorras."
	)
	helper_cc7603b9(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

--- Helper function.
local function helper_2828c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] pasa?\n[UNI00bf]Te rindes otra vez?<page>Me decepcionas.\n[UNI00bf]Es eso todo lo que sabes\nhacer despu[UNI00e9]s de pasarte toda la vida entre m[UNI00e1]quinas?"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00a1]Vaya! Parece que te\nhas acostumbrado a manejar armas.<page>No me hace falta ni verte disparar.\nBasta con ver c[UNI00f3]mo la coges."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Vale, te ayudar[UNI00e9].\nPero no lo hago por ti.<page>No me puedo\nquedar aqu[UNI00ed] parado si\nla ciudad est[UNI00e1] en peligro."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_28ac4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e1a643b1(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_e1a643b1(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c52e9159(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_27b48(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2828c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2a7ca4d6(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_29cf0(arg0: s32, arg1: s32)
	local var2: any = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				var2 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_e2203e72(30)
			end
			if at <= 11 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_e2203e72(15)
			end
			return
		end
		if at <= 14 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_e83cea40(0)
		end
		if at <= 16 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_e2203e72(15)
		end
		if at <= 18 then
			helper_e2203e72(15)
		end
		if at <= 19 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 20 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 21 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(0, "Hace mucho le di un broche\ncon su signo del zodiaco.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Holly se encarg[UNI00f3] de todo,\nas[UNI00ed] que no me acuerdo exactamente,\npero estoy seguro de que era un animal de 4 patas..."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"[UNI00bf]Que qu[UNI00e9] clase de\nregalos de cumplea[UNI00f1]os le he hecho?<page>Umm... Muchos abrigos\ny pa[UNI00f1]uelos, supongo.<page>Nunca s[UNI00e9] qu[UNI00e9] comprarle.\nTodos los a[UNI00f1]os es la misma historia."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"[UNI00a1]Y tanto! El cumplea[UNI00f1]os de Claire siempre es un sufrimiento.\nCae siempre en el d[UNI00ed]a que recogen la basura\nque se puede quemar y la que no.<page>A m[UNI00ed] me toca sacar\nla basura de casa."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"La basura que no se puede quemar\nse recoge los d[UNI00ed]as divisibles por 7<page>y la que s[UNI00ed] se puede quemar\nlos divisibles por tres."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "[UNI00bf]A que t[UNI00fa] tampoco te olvidar[UNI00ed]as\nde eso, eh?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"[UNI00a1]Ya est[UNI00e1]! [UNI00a1]Misterio resuelto!\nLa combinaci[UNI00f3]n es... <page>No s[UNI00e9]... Vamos a escuchar un poco m[UNI00e1]s."
		)
		var2 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(8)
		end
		if var2 == 0 then
			break
		else
			if var2 == -1 then
				event.Finish()
				return
			end
			event.SetMotion(arg0, "会話")
		end
	end
	event.SetMenuEtc(0, "Introduce el c[UNI00f3]digo secreto.", "1221", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(9)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var3 = out1 or var3
	end
	if var3 == -1 then
		event.Finish()
		return
	end
	event.SetFadeOut(15)
	helper_e2203e72(15)
	if vm.skipping() then
		return skip(10)
	end
	var7 = event.GetSndId(2) or var7
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaRot(arg0)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	event.SetCharaPos(arg0, -100.0, 0.0, -110.0)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = event.Atan2f(-100.0 - var14, -110.0 - var16) or var20
	event.SetCharaRot(0, 0.0, var20, 0.0)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraPos(64.64, 46.9, 92.64)
	event.SetCameraRef(-100.0, 20.0, -110.0)
	event.SetFadeIn(15)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(11)
	end
	if var3 == 0 then
		event.SetMotion(arg0, "会話")
		event.MesMake_2(0, "Vaya, no se abre. Cachis la mar... <page>Dentro tengo documentos\nmuy importantes...")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		event.SetMotion(arg0, "立ち")
		event.SetFadeOut(15)
		helper_e2203e72(15)
		if vm.skipping() then
			return skip(13)
		end
		event.SetCharaRot(0, var17, var18, var19)
		event.SetCharaPos(arg0, var8, var9, var10)
		event.SetCharaRot(arg0, var11, var12, var13)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.SetFadeIn(15)
		event.Finish()
		return
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "Esto... Um...\n1,<page>2,<page>2,<page>1...")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "[UNI00a1]Yujuuuu!<page>Bien,\n[UNI00a1]ha funcionado!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0, arg0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, var14, var15, var16, 30)
	helper_e83cea40(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"[UNI00a1]Genial! Ahora podr[UNI00e9]\nsacar los documentos que necesito.<page>[UNI00a1]Muchas gracias!"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetFadeOut(15)
	helper_e2203e72(15)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaRot(0, var17, var18, var19)
	event.SetCharaPos(arg0, var8, var9, var10)
	event.SetCharaRot(arg0, var11, var12, var13)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetFadeIn(15)
	helper_e2203e72(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"[UNI00bf]Qu[UNI00e9] documentos?<page>Unos que ayudar[UNI00e1]n al Teniente Alcalde Morton\na sustituirme mientras estoy fuera.<page>Me preocupa un poco,\npero no creo que pase nada."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(0, "Ahora ya estoy listo para marcharme.<page>Cedric me lo ha contado todo.<page>Venga, vamos.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_2c008(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e9affa6d(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e9affa6d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_05124d17(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_29cf0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_dfe5e894(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2d70c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_1f514f60()
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_1f514f60()
	if 0 < var2 then
		event.MesMake_2(0, "Al parecer, todav[UNI00ed]a\nte queda mucho por aprender.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Tengo depositada una gran confianza en ti,\npero me temo que por el momento\nno podr[UNI00e9] ayudarte."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Muy bien hecho.\nEspl[UNI00e9]ndido.<page>Estoy convencido de que cumplir[UNI00e1]s con creces mis expectativas.<page>[UNI00bf]Lo he prometido, no?\nTe acompa[UNI00f1]ar[UNI00e9]."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2dce4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c60a8e40(arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_c60a8e40(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_3daa96be(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2d70c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_d1e65749(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2e800(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"Pens[UNI00e9] que t[UNI00fa] eras diferente,\npero no, los humanos son humanos.<page>Da igual, estoy acostumbrado\na o[UNI00ed]r mentiras vuestras."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00a1]Guau! Es alucinante. Hay una luna en la foto.<page>Ahora podr[UNI00e9] verla cuando sea y donde sea."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "[UNI00bf]Ir contigo?<page>Pues claro que s[UNI00ed].\nNo tengo otro sitio adonde ir.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2efa8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_35963413(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_35963413(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_c3547a0e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2e800(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_e9b69603(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2fb38(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"Apostar[UNI00ed]a a que nunca has\npescado un Nonky, [UNI00bf]eh?<page>Ja, ja. [UNI00a1]Tienes que ser p[UNI00e9]simo pescando!"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 < vm.f32(0.6) then
		var3 = vm.ftoi(vm.f32(var2 * 100.0))
		event.SetMesValue(0, 1, var3)
		event.MesMake_2(0, "[UNI00a1]Ja, ja! S[UNI00f3]lo has cogido\nun pezque[UNI00f1][UNI00ed]n de [数値１] cm.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"[UNI00a1]No me llegas ni a la altura del bet[UNI00fa]n!<page>Te recomiendo que empieces de nuevo."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "... Vaya, te he subestimado.")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"En fin, soy un hombre de palabra.\nNo tienes que record[UNI00e1]rmelo.<page>Escuchar[UNI00e9] lo que tengas que decirme."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "[UNI00a1]Habla cuanto quieras!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_306a8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9f5da53c(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_9f5da53c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_1e26b26a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2fb38(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_9e15e4bf(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_31138(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "Se dice que los peces se parecen a sus amos.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "No le voy a dirigir la palabra al\ndue[UNI00f1]o de una birria de pez.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"La he visto.\nHa sido una carrera muy emocionante.<page>No creo que yo hubiera\npodido criar un pez tan bueno.<page>Ll[UNI00e9]vame contigo, por favor.\nEns[UNI00e9][UNI00f1]ame c[UNI00f3]mo lo haces."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_318b4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_acfd40a3(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_acfd40a3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_0bf1ae31(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_31138(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_7d091696(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_32b94(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "Todav[UNI00ed]a no me siento demasiado bien.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"A lo mejor es\nque me pasa algo de verdad.<page>Quiz[UNI00e1] ni siquiera\nel Dr. Dell pueda ayudarme..."
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00a1]Hola!<page>[UNI00bf]Que c[UNI00f3]mo me siento? [UNI00a1]Como nunca!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"No me creo lo bien que me encuentro estos d[UNI00ed]as.<page>El mundo vuelve a estar como antes."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Ah, s[UNI00ed], me hab[UNI00ed]as pedido un favor.<page>Te ayudar[UNI00e9] en lo que pueda.<page>T[UNI00fa] me has ayudado,\nas[UNI00ed] que te debo una."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_335fc(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c29e3999(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_c29e3999(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_cebfd01a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_32b94(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_c3fc8101(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_34ed0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_e2203e72(30)
			end
			return
		end
		if at <= 4 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(
			0,
			"[UNI00a1]Eh! [UNI00a1]Me has encontrado!<page>[UNI00bf]Podr[UNI00e1]s tambi[UNI00e9]n la pr[UNI00f3]xima vez?"
		)
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_e2203e72(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		return
	end
	event.MesMake_2(
		0,
		"[UNI00a1]Vaya! [UNI00a1]Me has encontrado!<page>Me estoy hartando.<page>Esconderse es\nmuy aburrido.<page>[UNI00a1]Bueno! V[UNI00e1]monos\nde aventura."
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_356f0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3f6dc8d5(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_3f6dc8d5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_2737ad20(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_34ed0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_67360d22(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_35b74(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_11de0()
		end
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "[UNI00bf]C[UNI00f3]mo?<page>[UNI00bf]No puedes hablar m[UNI00e1]s despacio?")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(0, 'Escribe: "Vamos juntos."', "Vamos juntos.", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var2 = out1 or var2
	end
	if var2 == -1 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 0 then
		event.MesMake_2(0, "[UNI00bf]De qu[UNI00e9] me est[UNI00e1]s hablando?\nNo tengo ni idea...")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"[UNI00bf]Una aventura?\nEso estar[UNI00ed]a bien.<page>Pero, [UNI00bf]de qu[UNI00e9] te servir[UNI00ed]a una\nvieja como yo?"
	)
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11de0()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_36278(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_35b74(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3656c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_bd4ec2c7(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_bd4ec2c7(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_35b74(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_36278(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_51055bf8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_36850(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_18e58(arg0, arg1)
			end
			if at <= 2 then
				var7 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_e2203e72(30)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				var8 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 11 then
			if at <= 9 then
				helper_e2203e72(30)
			end
			return
		end
		if at <= 17 then
			if at <= 12 then
				helper_1c408(arg0, arg1)
			end
			if at <= 13 then
				helper_1df60(arg0, arg1)
			end
			if at <= 14 then
				helper_20aa8(arg0, arg1)
			end
			if at <= 15 then
				helper_23290(arg0, arg1)
			end
			if at <= 16 then
				var11 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 18 then
			return
		end
		if at <= 22 then
			if at <= 19 then
				helper_259a8(arg0, arg1)
			end
			if at <= 20 then
				helper_168e0(arg0, arg1)
			end
			if at <= 21 then
				var14 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 23 then
			return
		end
		if at <= 28 then
			if at <= 24 then
				helper_273d4(arg0, arg1)
			end
			if at <= 25 then
				helper_28ac4(arg0, arg1)
			end
			if at <= 26 then
				helper_2c008(arg0, arg1)
			end
			if at <= 27 then
				var17 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 29 then
			return
		end
		if at <= 38 then
			if at <= 30 then
				helper_2dce4(arg0, arg1)
			end
			if at <= 31 then
				helper_2efa8(arg0, arg1)
			end
			if at <= 32 then
				helper_306a8(arg0, arg1)
			end
			if at <= 33 then
				helper_318b4(arg0, arg1)
			end
			if at <= 34 then
				helper_335fc(arg0, arg1)
			end
			if at <= 35 then
				helper_356f0(arg0, arg1)
			end
			if at <= 36 then
				helper_3656c(arg0, arg1)
			end
			if at <= 37 then
				var20 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 39 then
			return
		end
		if at <= 40 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
		if at <= 41 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_5515f51f(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_18e58(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nCavar buscando logros")
			var7 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_1e7bfebe(0)
				if vm.skipping() then
					return skip(4)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_e2203e72(30)
					if vm.skipping() then
						return skip(5)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(6)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_bf78()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "Hazte amigo m[UNI00ed]o\nCavar buscando logros")
			var8 = helper_79472a56(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_1e7bfebe(0)
				if vm.skipping() then
					return skip(9)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_e2203e72(30)
					if vm.skipping() then
						return skip(10)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(11)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_1aa20(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_1c408(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_1df60(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_20aa8(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_23290(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var11 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_259a8(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_bf78()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_259a8(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_168e0(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var14 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_273d4(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_bf78()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_273d4(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_28ac4(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_2c008(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hola\nHazte amigo m[UNI00ed]o.")
			var17 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_2dce4(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_bf78()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_2dce4(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_2efa8(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_306a8(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_318b4(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_335fc(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_356f0(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_3656c(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "D[UNI00e9]jame comprar\nHola")
			var20 = helper_f39cfbfe(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_223a6c9b(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_bf78()
		if vm.skipping() then
			return skip(40)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00da]ltimamente lo he pasado\nmal viendo todas las peque[UNI00f1]as piezas.<page>Supongo que\nme estoy haciendo viejo..."
			)
		else
			event.MesMake_2(
				0,
				"Ver en funcionamiento el\nFerrocarril Blackstone por todo el continente es un\nsue[UNI00f1]o com[UNI00fa]n de Need y m[UNI00ed]o.<page>Podemos contar con tu ayuda, [UNI00bf]no?"
			)
		end
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Si no estoy ocupado\nen algo,\nme pongo de mal humor.")
		else
			event.MesMake_2(
				0,
				"Si descubren Zelmite me\nllegar[UNI00e1] el agua al cuello. S[UNI00ed].\n[UNI00a1][UNI00a1]Tendr[UNI00e9] que excavar y excavar sin parar!!"
			)
		end
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"No s[UNI00e9] por qu[UNI00e9], tengo tantos\nbichos en las plumas [UNI00fa]ltimamente\nque me pica todo."
			)
		else
			event.MesMake_2(
				0,
				"Est[UNI00e1] bien que pases el tiempo\nintentando encontrar Zelmite, pero\ntampoco exageres."
			)
		end
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00a1]Me encanta el olor de la p[UNI00f3]lvora!\nEste trabajo est[UNI00e1] hecho para m[UNI00ed].<page>Aunque mi jefe\nes un cabez[UNI00f3]n anticuado.\nEn fin..."
			)
		else
			event.MesMake_2(0, "Te encanta toda esta\naventura, [UNI00bf]verdad?")
		end
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Aparte del hecho de que\nmi vida empez[UNI00f3] como cuadro, no soy diferente\na cualquier otra persona."
			)
		else
			event.MesMake_2(0, "La Mina de Zelmite me da mala espina.\nTen cuidado, [UNI00bf]vale?")
		end
		helper_47171f2d(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_ceb0()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
				var5 = 2
				var5 = 1
				helper_bf78()
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.GetMesEtc(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_bf78()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "[UNI00a1]Eh! Prohibido\nel paso.")
		helper_47171f2d(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Mira. Cualquiera se cree\nque este trasto iba por ah[UNI00ed]\nzumbando, [UNI00bf]eh?<page>Pues as[UNI00ed] era... Hace mucho tiempo.<page>Mi sue[UNI00f1]o es volver a viajar\nen [UNI00e9]l. Por eso\nme preocupo de mantenerlo a punto.<page>As[UNI00ed], si alg[UNI00fa]n d[UNI00ed]a llega la ocasi[UNI00f3]n,\n lo pondr[UNI00e9] a funcionar\nen un periquete."
				)
			else
				event.MesMake_2(
					0,
					"[UNI00bf]No ves que si\nno haces ejercicio todos los d[UNI00ed]as te quedas\nanquilosado? Pues igual les pasa a las m[UNI00e1]quinas."
				)
			end
			helper_47171f2d(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"[UNI00a1]Max, hola!\nHace ya mucho\nque no circula el tren,<page>pero yo sigo vigilando\nla estaci[UNI00f3]n todos los d[UNI00ed]as."
				)
			else
				event.MesMake_2(
					0,
					"El alcalde levant[UNI00f3] por fin el trasero\nde la silla y puso en marcha los trenes otra vez. Pero\ntodav[UNI00ed]a no est[UNI00e1]n listos.<page>Ni te imaginas las ganas que tengo\nde que se monten los de la ciudad..."
				)
			end
			helper_47171f2d(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Hola, Max. [UNI00bf]Sab[UNI00ed]as que el jefe de la estaci[UNI00f3]n\nes mi padre? Vigilamos\njuntos la estaci[UNI00f3]n.<page>Hasta que el tren vuelva\na funcionar como antes..."
				)
			else
				event.MesMake_2(
					0,
					"[UNI00a1]El tren ya funciona!\nPero todav[UNI00ed]a queda tiempo para\nque la estaci[UNI00f3]n vuelva a la normalidad..."
				)
			end
			helper_47171f2d(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetAi(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.GetFlag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"He sido admirador secreto de\nM[UNI00f3]nica durante a[UNI00f1]os, pero\nno la hab[UNI00ed]a visto [UNI00fa]ltimamente.<page>Por eso no me\npuedo concentrar en el trabajo."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(
						0,
						"[UNI00a1]Oye, Max!\nParece ser que M[UNI00f3]nica ha vuelto.\n[UNI00a1]Se va alegrar todo el mundo!"
					)
				else
					event.MesMake_2(
						0,
						"[UNI00a1]M[UNI00f3]nica! [UNI00bf]C[UNI00f3]mo te ha ido?\nTe he echado de menos."
					)
				end
			end
			helper_47171f2d(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Estaba hablando\ncon ella  como siempre,\ny va y desaparece.<page>Max, dime:\n[UNI00bf]d[UNI00f3]nde est[UNI00e1]?"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Ha vuelto M[UNI00f3]nica.\n[UNI00bf]C[UNI00f3]mo puede ser?")
				else
					event.MesMake_2(0, "M[UNI00f3]nica, has vuelto.\n[UNI00bf]C[UNI00f3]mo es posible?")
				end
			end
			helper_47171f2d(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_47171f2d(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_e5f8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ceb0()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_ceb0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_39318()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e5f8()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_36850(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_e5f8()
		if vm.skipping() then
			return skip(2)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.SetCharaPos(0, 5.0, -0.54, 25.0)
	event.SetCharaRot(0, 0, 3.14, 0)
	event.ResetCamera(1, 0.0, 10.0)
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_14c603be()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39318()
	if vm.skipping() then
		return skip(1)
	end
end

return script
