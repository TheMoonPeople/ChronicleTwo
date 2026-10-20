--!strict
-- map/s/s56/s56_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19c9cbe6 = require("@lib/event/helper_19c9cbe6")
local helper_28043d11 = require("@lib/event/helper_28043d11")
local helper_3e77b5b1 = require("@lib/event/helper_3e77b5b1")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_45cad085 = require("@lib/event/helper_45cad085")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_56e347e4 = require("@lib/event/helper_56e347e4")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_75ba8459 = require("@lib/event/helper_75ba8459")
local helper_7cd6d4b5 = require("@lib/event/helper_7cd6d4b5")
local helper_99ace723 = require("@lib/event/helper_99ace723")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_f0f50717 = require("@lib/event/helper_f0f50717")

local global0: s32 = 0
local global1: s32 = 0

--- Program 99.
local function program_99()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetBgmNo() or var0
	if var0 ~= 17 then
		event.StopBgm(0)
		helper_a8b5d854(6)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(17)
	end
	event.PlayBgm(0)
	event.LoadSound(3682)
	flag = event.GetFlag(348) or flag
	if flag == 1 then
		event.FuncPointShow("", "e348", 0)
		event.EohSyncObj(0, "p07_d03b01")
		event.EohSetShow(0, 0)
	end
	flag_2 = event.GetFlag(352) or flag_2
	if flag_2 == 1 then
		event.FuncPointShow("", "event", 0)
	end
end

--- Helper function.
local function helper_166e0()
	local argc: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3e77b5b1(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_3e77b5b1(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			var1 = helper_75ba8459(0, -1, 5, 256, 208, var1)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 0)
	argc = event.GetItemNum(371) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"Si pudi[UNI00e9]ramos retroceder al pasado,\n[UNI00a1]podr[UNI00ed]amos salvar a Crest!\n[UNI00bf]Pero c[UNI00f3]mo lo hacemos?"
		)
		helper_3e77b5b1(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)][UNI00bf]Existe alguna forma de volver\nal pasado? A lo mejor con alg[UNI00fa]n\nchisme especial o yo qu[UNI00e9] s[UNI00e9]..."
		)
		helper_3e77b5b1(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"[(!)]Por cierto: al parecer hay una\ntienda de equipamiento en el Templo Estelar\nque vende art[UNI00ed]culos ex[UNI00f3]ticos y otras mercanc[UNI00ed]as.<page>Qui[UNI00e9]n sabe, a lo mejor hay algo\n[UNI00fa]til."
		)
		helper_3e77b5b1(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	else
		event.MesMake_2(
			0,
			"[UNI00a1]Ahora ya podemos ayudar\na Crest! [UNI00a1]Volvamos al pasado!\n(Pulsa el bot[UNI00f3]n (#) para abrir el men[UNI00fa].)"
		)
		var1 = helper_75ba8459(0, -1, 5, 256, 208, var1)
		if vm.skipping() then
			return skip(4)
		end
		if var1 == 1 then
			event.SetMesShippo(0, 1)
			return 1
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	return 0
end

--- Helper function.
local function helper_13530()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("GET_ACTIVE_CHR_NO-------", active_chr_no, "\n")
		global0 = 0
		global1 = 8
		global0 = 8
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	print("GET_ACTIVE_CHR_NO-------", active_chr_no, "\n")
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 17)
		event.LoadEquip(5, 1, 0, "info", global1, 18)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 1, "info", global0, 17)
		event.LoadEquip(5, 0, 0, "info", global0, 18)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e352/e352_lin.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e300/e352/e352_tokei_h.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.LoadChara(5, "event/e300/e352/e352_monica_tokei.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.LoadChara(5, "event/e300/e352/e352_sdokei.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.LoadChara(5, "event/e300/e352/e352_mabu.gltf", "info", 21)
	event.CharaActive(0, 21)
	event.LoadChara(5, "event/e300/e352/e352_hikari.gltf", "info", 22)
	event.CharaActive(0, 22)
	event.SetCharaType(22, 4)
	event.LoadMes(0, 5, "event/e300/e352/e352_1.txt")
end

--- Helper function.
local function helper_12fdc()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.DeleteChara(19)
	event.DeleteChara(13)
	event.DeleteChara(20)
	event.DeleteChara(21)
	event.DeleteChara(22)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_149ac()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 18 then
			if at <= 5 then
				helper_13530()
				helper_6018bc39()
			end
			if at <= 6 then
				helper_a8b5d854(30)
			end
			if at <= 7 then
				helper_19c9cbe6(3520010)
			end
			if at <= 8 then
				helper_19c9cbe6(3520020)
			end
			if at <= 9 then
				helper_40ca6466(2)
			end
			if at <= 10 then
				helper_a8b5d854(27)
			end
			if at <= 11 then
				helper_a8b5d854(60)
			end
			if at <= 12 then
				helper_a8b5d854(60)
			end
			if at <= 13 then
				helper_a8b5d854(60)
			end
			if at <= 14 then
				helper_a8b5d854(30)
			end
			if at <= 15 then
				helper_a8b5d854(60)
			end
			if at <= 16 then
				helper_a8b5d854(75)
			end
			if at <= 17 then
				helper_a8b5d854(75)
			end
			if vm.skip_end() then
				return skip(19)
			end
			return part2()
		end
		if at <= 19 then
			helper_a8b5d854(30)
		end
		if at <= 21 then
			helper_12fdc()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsFadeOut(30, 255.0, 255.0, 255.0)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(20)
		end
		event.ScrEffStopRaster(0.0, 0.0, 0.0, 0)
		event.SndSeAllStop(4)
		event.BgmLoadCancel()
		if vm.wait() then
			return skip(21)
		end
		helper_12fdc()
		if vm.skipping() then
			return skip(22)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(352, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.LoadSound(3831)
	var4 = event.SndLoadSound(3831) or var4
	helper_13530()
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "半口")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "上見立ち", 4)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 9)
	event.CmrsSetPos(496.47, 169.37, -809.35)
	event.CmrsSetRef(508.77, 169.14, -850.82)
	event.ObjsSetPos(2, 543.2, 144.04, -840.61)
	event.ObjsSetRot(2, 0.0, -1.99, 0.0)
	event.ObjsSetPos(0, 538.49, 145.86, -872.44)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 567.83, 142.65, -858.12)
	event.ObjsSetRot(1, 0.0, -0.92, 0.0)
	event.CmrsMove2(530.44, 169.37, -799.27, 542.75, 169.14, -840.74, 120, 2, 1.0)
	event.SetFadeIn(30)
	helper_6018bc39()
	if vm.skipping() then
		return skip(6)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_19c9cbe6(3520010)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "うなづく", 6)
	event.ObjsNextMotion(2, "上見立ち", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_19c9cbe6(3520020)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(10)
	end
	event.SetReference(global1, "sword_hand", 13)
	event.CharaActive(1, 13)
	event.ObjsSetPos(1, 519.39, 147.4, -861.34)
	event.ObjsSetRot(1, 0.0, -0.2, 0.0)
	event.ObjsSetRot(0, 0.0, -0.6, 0.0)
	event.ObjsSetMotion(2, "下見立ち", 4)
	event.SndSePlay(var4, 0)
	event.ObjsSetMotion(1, "置く～下見", 6)
	event.ObjsNextMotion(1, "下見", 4)
	event.CmrsSetPos(485.69, 161.28, -803.81)
	event.CmrsSetRef(535.39, 163.79, -859.0)
	helper_a8b5d854(27)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var4, 1)
	event.DelReference(13)
	event.CharaActive(0, 13)
	event.CharaActive(1, 19)
	event.SetCharaPos(19, 516.77, 149.74, -850.63)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(499.2, 155.53, -839.73)
	event.CmrsSetRef(516.77, 149.74, -850.63)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(13)
	end
	event.CharaActive(1, 20)
	event.SetCharaPos(20, 516.77, 149.74, -850.63)
	event.SetMotion(20, "砂時計光る", 2, -1, 1)
	event.SndSePlay(var4, 2)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目とじ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "目とじ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "目とじ")
	event.ObjsTexAnime(2, 1, "半口")
	event.ObjsSetMotion(2, "まぶしい", 6)
	event.ObjsSetMotion(0, "まぶしい", 6)
	event.ObjsSetMotion(1, "まぶしい", 6)
	event.ObjsNextMotion(2, "まぶしいＬ", 4)
	event.ObjsNextMotion(0, "まぶしいＬ", 4)
	event.ObjsNextMotion(1, "まぶしいＬ", 4)
	event.ObjsSetPos(0, 539.17, 145.1, -856.52)
	event.ObjsSetRot(0, 0.0, -1.99, 0.0)
	event.ObjsSetPos(1, 538.92, 143.03, -823.0)
	event.ObjsSetRot(1, 0.0, -2.24, 0.0)
	event.CmrsSetPos(494.78, 152.75, -815.47)
	event.CmrsSetRef(543.94, 165.9, -843.48)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CharaActive(1, 21)
	event.SetCharaPos(21, 547.24, 149.74, -859.21)
	event.SetMotion(21, "まぶしい", 2, -1, 1)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(16)
	end
	event.CharaActive(0, 21)
	event.CmrsSetPos(1717.19, 225.79, 121.59)
	event.CmrsSetRef(543.94, 165.9, -843.48)
	event.SndSePlay(var4, 3)
	event.CharaActive(1, 22)
	event.SetCharaPos(22, 516.77, 149.74, -850.63)
	event.SetMotion(22, "光る光る", 2, -1, 1)
	helper_a8b5d854(75)
	if vm.skipping() then
		return skip(17)
	end
	event.ScrEffInitRaster(0.0, 0.0, 0.15707964)
	event.ScrEffStartRaster(60.0, 0.3926991, -1.0, 60)
	helper_a8b5d854(75)
	if vm.skipping() then
		return skip(18)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7cd6d4b5()
		end
	end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_7cd6d4b5()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f0f50717(64)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	helper_f0f50717(64)
	if vm.skipping() then
		return skip(2)
	end
	event.Finish()
end

--- Program 500.
script[500] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				var0 = 2
				helper_a8b5d854(6)
			end
			if at <= 3 then
				helper_a8b5d854(20)
			end
			if at <= 4 then
				helper_149ac()
				if not vm.skipping() then
					return landing1()
				end
			end
			return
		end
		if at <= 6 then
			helper_a8b5d854(6)
		end
	end
	function part2()
		helper_a8b5d854(6)
		if vm.skipping() then
			return skip(7)
		end
		event.Finish()
	end
	function landing1()
		event.LoadDungeonMapFile("d03b02")
		event.LoadScript("d03b02/d03b02.stb", 502)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		local t0 = helper_166e0()
		if vm.skipping() then
			return skip(1)
		end
		if t0 ~= 0 then
			var0 = 2
		end
	end
	if var0 == 2 then
		event.SetStatusbarShow(0, 0.16666667)
		helper_a8b5d854(6)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoUseItem(371)
		do
			local skipped = vm.wait()
			var1 = event.DeferredOutput() or var1
			if skipped then
				return skip(3)
			end
		end
		if var1 == 371 then
			event.FuncPointShow("", "event", 0)
			event.SetFadeOut(20)
			helper_a8b5d854(20)
			if vm.skipping() then
				return skip(4)
			end
			event.DngSetupMainUnit(0)
			helper_149ac()
			if vm.skipping() then
				return skip(5)
			end
			event.LoadDungeonMapFile("d03b02")
			event.LoadScript("d03b02/d03b02.stb", 502)
			return
		elseif var1 > 0 then
			helper_56e347e4()
			if vm.skipping() then
				return skip(6)
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_99ace723()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	event.FuncPointShow("", "e348", 0)
	event.EohSyncObj(0, "p07_d03b01")
	event.EohSetShow(0, 0)
	helper_52115bbf()
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_99ace723()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_45cad085()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.LoadScript("d03/d03.stb", 1000)
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_28043d11(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13480.
script[13480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_99ace723()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13520.
script[13520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DngSetupMainUnit(0)
	helper_149ac()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d03b02")
	event.LoadScript("d03b02/d03b02.stb", 502)
end

return script
