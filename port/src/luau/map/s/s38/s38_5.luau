--!strict
-- map/s/s38/s38_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_04a254d6 = require("@lib/event/helper_04a254d6")
local helper_0da8c4c7 = require("@lib/event/helper_0da8c4c7")
local helper_1844fc9c = require("@lib/event/helper_1844fc9c")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_470f8a56 = require("@lib/event/helper_470f8a56")
local helper_52c8e591 = require("@lib/event/helper_52c8e591")
local helper_854d8da2 = require("@lib/event/helper_854d8da2")
local helper_96cea96b = require("@lib/event/helper_96cea96b")
local helper_a1c34b66 = require("@lib/event/helper_a1c34b66")
local helper_e84a97e1 = require("@lib/event/helper_e84a97e1")
local helper_e85df3b0 = require("@lib/event/helper_e85df3b0")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_1f78c(arg0: s32, arg1: s32)
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
local function helper_28cd8()
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
		helper_1f78c(var1, var2)
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
		helper_1f78c(var1, var2)
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
local function helper_296e4(arg0: f32)
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
local function helper_29550()
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
local function helper_29be8()
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
local function helper_26368(arg0: s32)
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
local function helper_2646c()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_26368(15)
		end
		if at <= 2 then
			helper_26368(1)
		end
		if at <= 3 then
			helper_26368(6)
		end
		if at <= 4 then
			helper_26368(0)
		end
		if at <= 5 then
			helper_26368(4)
		end
		if at <= 6 then
			helper_26368(31)
		end
		if at <= 7 then
			helper_26368(35)
		end
		if at <= 8 then
			helper_26368(36)
		end
		if at <= 9 then
			helper_26368(37)
		end
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
		helper_52c8e591(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_26368(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_26368(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_26368(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_26368(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_26368(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_26368(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_26368(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_26368(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_26368(37)
		if vm.skipping() then
			return skip(10)
		end
	end
end

--- Helper function.
local function helper_1d1f8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Ver en funcionamiento el\nFerrocarril Blackstone por todo el continente es un\nsue[UNI00f1]o com[UNI00fa]n de Need y m[UNI00ed]o.<page>Podemos contar con tu ayuda, [UNI00bf]no?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"Si descubren Zelmite me\nllegar[UNI00e1] el agua al cuello. S[UNI00ed].\n[UNI00a1][UNI00a1]Tendr[UNI00e9] que excavar y excavar sin parar!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Tiene que haber much[UNI00ed]simas plantas\npor ah[UNI00ed] que ni siquiera conozcamos.")
	end
	if arg1 == 4 then
		event.MesMake_2(
			arg0,
			"[UNI00a1]Eh! [UNI00bf]C[UNI00f3]mo va la b[UNI00fa]squeda de Zelmite?\nSi puedo ayudar,\ndame una voz."
		)
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"El mundo de la pintura es muy profundo.\nPuede que me lleve toda una vida dominarlo,\npero el trayecto bien vale la pena."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"Est[UNI00e1] bien que pases el tiempo\nintentando encontrar Zelmite, pero\ntampoco exageres."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Alg[UNI00fa]n d[UNI00ed]a ser[UNI00e9] el mejor chef\ndel mundo y entonces\npodr[UNI00e1]s comer gratis cuando quieras."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(
			arg0,
			"Por fin, el Ferrocarril\nBlackstone conquista el mundo.\n[UNI00a1]Qu[UNI00e9] emoci[UNI00f3]n!"
		)
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "[UNI00a1]Eh! [UNI00bf]Qu[UNI00e9] tal? [UNI00a1]Por aqu[UNI00ed] genial!")
	end
	if arg1 == 10 then
		event.MesMake_2(
			arg0,
			"La Mina de Zelmite es un lugar terror[UNI00ed]fico.\nNo se puede bajar\nla guardia ni un momento."
		)
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Rezar[UNI00e9] por ti...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Cuando te apetezca\npan, ya sabes d[UNI00f3]nde encontrarme.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "Te encanta toda esta\naventura, [UNI00bf]verdad?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Si hay algo en lo que pueda ayudarte\n, no tienes m[UNI00e1]s que ped[UNI00ed]rmelo.")
	end
	if arg1 == 15 then
		event.MesMake_2(
			arg0,
			"[UNI00bf]Qu[UNI00e9] hay de los logros? [UNI00bf]Te has encontrado\ncon alg[UNI00fa]n bicho raro en la mina?"
		)
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"A partir de ahora voy a ayudar\na Need y Cedric a reconstruir el mundo.\nTenemos que trabajar juntos."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"F[UNI00ed]jate bien en lo que te digo:\ns[UNI00e9] que la Mina de Zelmite es un lugar\npeligroso. No hagas tonter[UNI00ed]as."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Rezo por que haya paz\nen el mundo a partir de hoy y para siempre.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Si el Ferrocarril Blackstone recorre\ntodo el mundo, podremos visitar\nun mont[UNI00f3]n de sitios nuevos."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"Tengo unas ganas de\nver todos los lugares para pescar\ndel mundo... S[UNI00ed] que va a ser divertido."
		)
	end
	if arg1 == 21 then
		event.MesMake_2(arg0, "Me gustar[UNI00ed]a que Fabio se interesase\npor algo m[UNI00e1]s aparte\nde la pesca.")
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "La Mina de Zelmite me da mala espina.\nTen cuidado, [UNI00bf]vale?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Si el Ferrocarril Blackstone se extiende\npor todo el mundo, quiz[UNI00e1]\nyo deba recorrer todo el mundo tambi[UNI00e9]n."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"A m[UNI00ed] no me enga[UNI00f1]as. T[UNI00fa] has\nestado por ah[UNI00ed] pas[UNI00e1]ndotelo\nbomba. [UNI00a1]Tienes que contarme tus andanzas alg[UNI00fa]n d[UNI00ed]a!"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Cuando est[UNI00e9] terminado el Ferrocarril Blackstone\nme gustar[UNI00ed]a\nir al "Fin del mundo".'
		)
	end
end

--- Helper function.
local function helper_20bf4(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_854d8da2(1)
		helper_1f78c(arg0, argc)
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
		helper_1f78c(arg0, argc)
	end
end

--- Helper function.
local function helper_20e9c(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		helper_20bf4(arg0, arg1)
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
	helper_20bf4(arg0, arg1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1fa80(arg0: s32)
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
		event.MesMake_2(arg0, "Si no me traes m[UNI00e1]s logros\nno puedo darte nada.")
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
			"El nivel de tu Fotograf[UNI00ed]a est[UNI00e1] determinado\npor el n[UNI00fa]mero de ideas y logros\nque tengas.<page>Conforme vayas aumentando de nivel, conseguir[UNI00e1]s\nm[UNI00e1]s objetos como recompensa."
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
local function helper_20108(arg0: s32)
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
			return helper_1fa80(arg0)
		end
		if at <= 5 then
			helper_470f8a56(arg0, 1)
			helper_e84a97e1(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_04a254d6(arg0, -1, 3, 256, 208)
		end
		return helper_1fa80(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_470f8a56(arg0, 1)
		event.MesMake_2(arg0, "Tr[UNI00e1]eme una\nNota de Logros, anda.")
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
		event.MesMake_2(arg0, "Parece que no quedan\nlogros.")
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
		return helper_1fa80(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_470f8a56(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Yo calculo [Number1] logros m[UNI00e1]s.")
		event.SetMesDrawspeed(arg0, 0)
		helper_04a254d6(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_470f8a56(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(
			arg0,
			"[UNI00a1]Oye, t[UNI00ed]o! [UNI00a1]No te relajes!\n[UNI00bf]D[UNI00f3]nde est[UNI00e1]n todas tus nuevos logros Interiores?"
		)
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(
			arg0,
			"[UNI00a1]Guau! [UNI00a1]Ya tienes [Number 1] nuevos logros!\n[UNI00a1]Sab[UNI00ed]a que lo llevabas dentro de ti!"
		)
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
	return helper_1fa80(arg0)
end

--- Helper function.
local function helper_1e680()
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
		event.MesMake_2(
			3,
			"[UNI00a1]Genial! Al fin y al cabo, los humanos\nno son tan malos.<page>[UNI00a1]Estaba equivocado!"
		)
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Ya est[UNI00e1]. Esto es lo [UNI00fa]ltimo.\nTenemos que derrotarle.<page>Despu[UNI00e9]s, el mundo revivir[UNI00e1]."
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Creo que s[UNI00e9] c[UNI00f3]mo se siente Griffon, pero no\npodr[UNI00e9] perdonarle nunca lo que ha hecho."
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Devuelve el jard[UNI00ed]n a su estado anterior y\ndescubre el secreto de Griffon... O sea, de Sirus."
		)
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			'[UNI00bf]Qu[UNI00e9] querr[UNI00e1] de decir con "los recuerdos de Sirus"?\nMe temo que tendremos que entrar en el palacio para averiguarlo.'
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Griffon se escapar[UNI00e1] si seguimos perdiendo el\ntiempo. R[UNI00e1]pido, vamos al Palacio Moon Flower."
		)
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(3, "Ya tenemos todas las gemas. Ahora\ntenemos que ir deprisa al Stonehenge de Kazarov.")
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Sea lo que sea, ser[UNI00e1] mejor que demos con las gemas\nantes de que sea demasiado tarde."
		)
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Todo empez[UNI00f3] en este palacio.\nDa igual; entremos en el jard[UNI00ed]n.")
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Ser[UNI00e1] mejor que volvamos al Laboratorio Lunar.\nPuede que ya hayan acabado con el Ixion."
		)
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "Va siendo hora de arreglar cuentas\ncon Griffon. Vamos a la base de Paznos.")
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00a1]No te quedes ah[UNI00ed] parado!\n[UNI00a1]Tenemos que rescatar a M[UNI00f3]nica, r[UNI00e1]pido!"
		)
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00bf]Te acuerdas? Galen Agaris dijo que\ntocando el Cuerno de fuego se abrir[UNI00ed]a el camino."
		)
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"[UNI00a1]No te quedes ah[UNI00ed] parado!\n[UNI00a1]Tenemos que rescatar a M[UNI00f3]nica, r[UNI00e1]pido!"
		)
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"Voy a terminar con esa Tromba de fuego.<page>As[UNI00ed] que est[UNI00e1] en la cima del Monte Gundor, [UNI00bf]verdad? "
		)
		return
	end
	event.MesMake_2(
		3,
		"Aqu[UNI00ed] parados no vamos a hacer nada.<page>Todav[UNI00ed]a tienen que quedarnos sitios por ver."
	)
end

--- Helper function.
local function helper_20fd0(arg0: s32, arg1: s32)
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
				helper_1d1f8(3, argc)
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
			helper_20bf4(arg0, arg1)
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
				helper_20bf4(arg0, arg1)
				helper_20e9c(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_20e9c(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_20e9c(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_20e9c(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_20e9c(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_20e9c(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_20e9c(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_20e9c(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_20e9c(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_20e9c(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_20e9c(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_20e9c(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_20e9c(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_20e9c(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_20e9c(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_20e9c(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_20e9c(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_20e9c(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_20e9c(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_20e9c(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_20e9c(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_20e9c(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_20e9c(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_1e680()
			helper_04a254d6(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_20bf4(arg0, arg1)
			helper_efffcfbb(30)
		end
		helper_20bf4(arg0, arg1)
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
			helper_1d1f8(3, argc)
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
				helper_20bf4(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_470f8a56(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Ahora no puedes hacer eso. [UNI00a1]Antes tienes que\nllevar a Lin al faro!")
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
						event.MesMake_2(3, "Perfecto, [UNI00a1]hemos terminado las reparaciones!")
						helper_04a254d6(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_20bf4(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_20e9c(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_20e9c(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_20108(3)
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_20e9c(arg0, arg1, 33)
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
						helper_20e9c(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_20e9c(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_20e9c(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_20e9c(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_20e9c(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_20e9c(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_20e9c(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_20e9c(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_20e9c(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_20e9c(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_20e9c(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_20e9c(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_20e9c(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_20e9c(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_20e9c(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_20e9c(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_20e9c(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_20e9c(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_20e9c(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_20e9c(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_20e9c(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_1e680()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_04a254d6(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_20bf4(arg0, arg1)
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
						helper_20bf4(arg0, arg1)
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
	helper_20bf4(arg0, arg1)
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
	helper_28cd8()
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
			var1 = helper_96cea96b(1)
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_29550()
		end
		if at <= 3 then
			helper_0da8c4c7()
		end
		if at <= 4 then
			helper_29be8()
		end
	end
	print("--------------------------event200-------------------------\n")
	helper_296e4(vm.f32(-1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_96cea96b(1)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_efffcfbb(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 1)
		helper_29550()
		if vm.skipping() then
			return skip(3)
		end
		event.StopBgm(0)
		helper_0da8c4c7()
		if vm.skipping() then
			return skip(4)
		end
	else
		helper_29be8()
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
			var1 = helper_96cea96b(0)
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_29550()
		end
		if at <= 3 then
			helper_0da8c4c7()
		end
		if at <= 4 then
			helper_29be8()
		end
	end
	print("--------------------------event201-------------------------\n")
	helper_296e4(vm.f32(1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_96cea96b(0)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_efffcfbb(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 0)
		helper_29550()
		if vm.skipping() then
			return skip(3)
		end
		event.StopBgm(0)
		helper_0da8c4c7()
		if vm.skipping() then
			return skip(4)
		end
	else
		helper_29be8()
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
			helper_29550()
		end
		var1 = var1 - 1
		helper_28cd8()
	end
	print("--------------------------event202-------------------------\n")
	helper_296e4(0.0)
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
	helper_29550()
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
		helper_28cd8()
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
			helper_29550()
		end
		if at <= 3 then
			var1 = vm.i32(var1 + 1)
			helper_28cd8()
			helper_29be8()
		end
	end
	print("--------------------------event203-------------------------\n")
	helper_296e4(vm.f32(3.1415927))
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
		helper_29550()
		if vm.skipping() then
			return skip(3)
		end
		var1 = vm.i32(var1 + 1)
		event.SetCnt(0, var1)
		helper_28cd8()
		event.SetCharaPos(0, 0.0, -14.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	else
		helper_29be8()
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
			helper_20fd0(var0, 0)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	argc = event.GetLocalCnt(var0) or argc
	if argc == 34 then
		event.SetMesEtc(1, 10, 0)
		helper_2646c()
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesEtc(1, 10, 128)
	else
		helper_20fd0(var0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
