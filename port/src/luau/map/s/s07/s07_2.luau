--!strict
-- map/s/s07/s07_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_336304d9 = require("@lib/event/helper_336304d9")
local helper_8d6f315a = require("@lib/event/helper_8d6f315a")
local helper_951d9474 = require("@lib/event/helper_951d9474")
local helper_bdbf25ac = require("@lib/event/helper_bdbf25ac")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_c66636ad = require("@lib/event/helper_c66636ad")
local helper_df4094fb = require("@lib/event/helper_df4094fb")

--- Helper function.
local function helper_29008()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 8
		var2 = 1
		var2 = var2 + 1
		var2 = var2 + 1
		var2 = var2 + 1
		var2 = var2 + 1
		var2 = var2 + 1
		helper_c66636ad(var1, var2)
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
		var3 = event.GetChapter() or var3
		if var2 == 1 then
			var4 = event.GetCnt(1) or var4
			if var3 ~= 8 or var4 ~= 1 then
				var2 = var2 + 1
				continue
			end
		end
		if var3 < 5 then
			if var2 == 2 or var2 == 13 then
				var2 = var2 + 1
				continue
			end
		end
		var5 = event.GetNpcStatus(var2) or var5
		if var5 == 0 then
			var2 = var2 + 1
			continue
		end
		if bit32.band(var5, 4) ~= 0 then
			var2 = var2 + 1
			continue
		end
		var6 = event.GetNpcTrainEtc(0, var2) or var6
		if var0 ~= var6 then
			var2 = var2 + 1
			continue
		end
		event.LoadCharaNpc(1, 5, var2, var1)
		helper_c66636ad(var1, var2)
		event.SetLocalCnt(var1, var2)
		event.SetCharaNo(var1, var2)
		if bit32.band(var5, 1) ~= 0 then
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
		event.SetCharaPos(var1, 0.0, 56.0, -200.0)
		event.SetCharaRot(var1, 0.0, 0.0, 0.0)
		event.SetMotion(var1, "立ち", 4)
		event.SetLocalCnt(var1, 34)
		event.SetCharaNo(var1, 34)
		event.CharaActive(var1)
	end
end

--- Helper function.
local function helper_29ae4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = 8
	while var0 < 20 do
		event.DeleteChara(var0)
		event.DeleteVillager(var0)
		var0 = var0 + 1
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Helper function.
local function helper_261c8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_c1c32f84(15)
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
local function helper_262cc()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_261c8(15)
		end
		if at <= 2 then
			helper_261c8(1)
		end
		if at <= 3 then
			helper_261c8(6)
		end
		if at <= 4 then
			helper_261c8(0)
		end
		if at <= 5 then
			helper_261c8(4)
		end
		if at <= 6 then
			helper_261c8(31)
		end
		if at <= 7 then
			helper_261c8(35)
		end
		if at <= 8 then
			helper_261c8(36)
		end
		if at <= 9 then
			helper_261c8(37)
		end
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bienvenue.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"[UNI00c7]a travaille dur, je vois ?\nIl te faut quelque chose ?<page>Ah mais, rien n'est gratuit.\nPas m[UNI00ea]me pour toi, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"Il te faut plus d'[UNI00e9]l[UNI00e9]ments de\nG[UNI00e9]orama ?<page>Si tu n'as pas le temps d'aller en\nchercher toi-m[UNI00ea]me, peut-[UNI00ea]tre que\nl'argent r[UNI00e9]soudra tes probl[UNI00e8]mes."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Bonjour, je suis apprentie boulang[UNI00e8]re\net je m'occupe de la boulangerie\npendant l'absence de Polly.<page>Je suis un peu nerveuse, mais [UNI00e7]a\npassera avec l'exp[UNI00e9]rience, je\nsuppose. Je ferai de mon mieux !"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"On se ressemble peu mais...\nJe suis la petite s[UNI0153]ur de Milane.<page>Je tiens le magasin pendant son absence.\nEt je suis archi-nulle en armes !"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Tu ne t'y attendais pas ? N'importe\nqui serait surpris de voir ici un\nindividu habill[UNI00e9] de cette mani[UNI00e8]re.<page>Je suis bon ami avec le P[UNI00e8]re Bruno.\nJe le remplace pendant son voyage.\nAlors, que puis-je faire pour toi ?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
			)
		end
	end
	if var1 ~= -1 then
		helper_8d6f315a(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_261c8(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_261c8(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_261c8(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_261c8(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_261c8(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_261c8(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_261c8(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_261c8(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_261c8(37)
		if vm.skipping() then
			return skip(10)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.Initialize()
	print("##IN_START_EVENT################################\n")
	helper_29008()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(1, 3)
	event.ResetCamera(1)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "キ(O)ター[l1]ー[r1]ー[l2]ー[r2]ー")
	helper_951d9474(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_336304d9()
		end
	end
	print("--------------------------event200-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.SetCnt(15, 1)
		event.SetFadeOut(0)
		helper_29ae4()
		if vm.skipping() then
			return skip(1)
		end
		event.StopBgm(0)
		helper_336304d9()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_336304d9()
		end
	end
	print("--------------------------event201-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.SetCnt(15, 0)
		event.SetFadeOut(0)
		helper_29ae4()
		if vm.skipping() then
			return skip(1)
		end
		event.StopBgm(0)
		helper_336304d9()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 202.
script[202] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = var0 - 1
		helper_29008()
	end
	print("--------------------------event202-------------------------\n")
	event.SetFadeOut(0)
	helper_29ae4()
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(0) or var0
	if var0 == 1 then
		event.SetCnt(0, 0)
		event.SetCharaPos(0, 0.0, 36.0, -100.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.MapJump(-1, "s08")
	else
		var0 = vm.i32(var0 - 1)
		event.SetCnt(0, var0)
		helper_29008()
		event.SetCharaPos(0, 0.0, 36.0, -235.0)
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
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = vm.i32(var0 + 1)
		helper_29008()
	end
	print("--------------------------event203-------------------------\n")
	var0 = event.GetCnt(0) or var0
	if var0 ~= 3 then
		event.SetFadeOut(0)
		helper_29ae4()
		if vm.skipping() then
			return skip(1)
		end
		var0 = vm.i32(var0 + 1)
		event.SetCnt(0, var0)
		helper_29008()
		event.SetCharaPos(0, 0.0, 36.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- Program 205.
script[205] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 206.
script[206] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 207.
script[207] = function()
	print("--------------------------event207-------------------------\n")
end

--- Program 208.
script[208] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event208-------------------------\n")
	var0 = event.GetCnt(0) or var0
	if var0 == 3 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
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
			helper_bdbf25ac(var0, 0)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	argc = event.GetLocalCnt(var0) or argc
	if argc == 34 then
		event.SetMesEtc(1, 10, 0)
		helper_262cc()
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesEtc(1, 10, 128)
	else
		helper_bdbf25ac(var0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
