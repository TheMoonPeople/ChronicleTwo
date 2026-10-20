--!strict
-- map/s/s07/s07_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1dfd3375 = require("@lib/event/helper_1dfd3375")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_732fca27 = require("@lib/event/helper_732fca27")
local helper_8d6f315a = require("@lib/event/helper_8d6f315a")
local helper_951d9474 = require("@lib/event/helper_951d9474")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local helper_f21eb500 = require("@lib/event/helper_f21eb500")

--- Helper function.
local function helper_28b98()
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
		helper_732fca27(var1, var2)
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
		helper_732fca27(var1, var2)
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
local function helper_29674()
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
local function helper_25f48(arg0: s32)
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
local function helper_2604c()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_25f48(15)
		end
		if at <= 2 then
			helper_25f48(1)
		end
		if at <= 3 then
			helper_25f48(6)
		end
		if at <= 4 then
			helper_25f48(0)
		end
		if at <= 5 then
			helper_25f48(4)
		end
		if at <= 6 then
			helper_25f48(31)
		end
		if at <= 7 then
			helper_25f48(35)
		end
		if at <= 8 then
			helper_25f48(36)
		end
		if at <= 9 then
			helper_25f48(37)
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
		helper_8d6f315a(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_25f48(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_25f48(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_25f48(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_25f48(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_25f48(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_25f48(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_25f48(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_25f48(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_25f48(37)
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
	helper_28b98()
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
			helper_1dfd3375()
		end
	end
	print("--------------------------event200-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.SetCnt(15, 1)
		event.SetFadeOut(0)
		helper_29674()
		if vm.skipping() then
			return skip(1)
		end
		event.StopBgm(0)
		helper_1dfd3375()
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
			helper_1dfd3375()
		end
	end
	print("--------------------------event201-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.SetCnt(15, 0)
		event.SetFadeOut(0)
		helper_29674()
		if vm.skipping() then
			return skip(1)
		end
		event.StopBgm(0)
		helper_1dfd3375()
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
		helper_28b98()
	end
	print("--------------------------event202-------------------------\n")
	event.SetFadeOut(0)
	helper_29674()
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
		helper_28b98()
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
		helper_28b98()
	end
	print("--------------------------event203-------------------------\n")
	var0 = event.GetCnt(0) or var0
	if var0 ~= 3 then
		event.SetFadeOut(0)
		helper_29674()
		if vm.skipping() then
			return skip(1)
		end
		var0 = vm.i32(var0 + 1)
		event.SetCnt(0, var0)
		helper_28b98()
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
			helper_f21eb500(var0, 0)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	argc = event.GetLocalCnt(var0) or argc
	if argc == 34 then
		event.SetMesEtc(1, 10, 0)
		helper_2604c()
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesEtc(1, 10, 128)
	else
		helper_f21eb500(var0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
