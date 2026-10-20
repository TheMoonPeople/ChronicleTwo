--!strict
-- map/s/s56/s56_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19c9cbe6 = require("@lib/event/helper_19c9cbe6")
local helper_3e77b5b1 = require("@lib/event/helper_3e77b5b1")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_75ba8459 = require("@lib/event/helper_75ba8459")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_b09f6907 = require("@lib/event/helper_b09f6907")
local helper_b5303866 = require("@lib/event/helper_b5303866")
local helper_ce016066 = require("@lib/event/helper_ce016066")
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
local function helper_16e20()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a8b5d854(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 1858.52, -189.52, 1308.84)
	event.ObjsSetRot(0, 0.0, -2.22, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(1910.24, -159.5, 1350.91)
	event.CmrsSetRef(1816.64, -159.5, 1274.78)
	event.ObjsMove(0, 1816.64, -189.5, 1274.78, 60)
	event.SetFadeIn(30)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, -1)
	event.ResetCamera(0)
	event.Finish()
end

--- Helper function.
local function helper_166d0()
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
			"Se potessimo tornare nel passato da\nqui, saremmo in grado di salvare\nCrest! Ma come possiamo fare?"
		)
		helper_3e77b5b1(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]C'[UNI00e8] davvero un modo per tornare nel\npassato? Forse con uno strumento\nspeciale o qualcos'altro..."
		)
		helper_3e77b5b1(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"[(!)]Adesso che ci penso, al Tempio\nStella dovrebbe esserci un negozio\nche vende oggetti rari.<page>Potresti trovarci qualcosa di utile."
		)
		helper_3e77b5b1(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	else
		event.MesMake_2(0, "Ora dovremmo poter aiutare Crest!\nTorniamo nel passato!\n(Premi (#) per accedere al Menu)")
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
local function helper_13520()
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
local function helper_12fcc()
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
local function helper_1499c()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 18 then
			if at <= 5 then
				helper_13520()
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
			helper_12fcc()
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
		helper_12fcc()
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
	helper_13520()
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

--- Helper function.
local function helper_182a8()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_40ca6466(0)
		end
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(1)
		end
		event.Finish()
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_40ca6466(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_40ca6466(0)
	if vm.skipping() then
		return skip(3)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_17240()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3e77b5b1(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				helper_a8b5d854(10)
			end
			return 0
		end
		if at <= 6 then
			if at <= 4 then
				helper_a8b5d854(30)
			end
			if at <= 5 then
				helper_a8b5d854(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_3e77b5b1(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_3e77b5b1(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetFadeOut(10)
		helper_a8b5d854(10)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaPos(0, 1804.36, -189.51, 1279.76)
		event.SetCharaRot(0, 0.0, -2.47, 0.0)
		event.SetCameraPos(1889.79, -158.65, 1386.92)
		event.SetCameraRef(1804.36, -159.51, 1279.76)
		event.ResetCamera(0)
		event.SetFadeIn(10)
		event.Finish()
		return 0
	end
	var1 = helper_b09f6907(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.CmrsSetPos(1776.49, -106.69, 1400.79)
		event.CmrsSetRef(1951.33, -163.61, 1351.42)
		event.ObjsSetPos(0, 1943.88, -189.72, 1357.17)
		event.ObjsSetRot(0, 0.0, 1.21, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, 1943.88, -189.72, 1357.17)
		event.ObjsAddPas(0, 2022.78, -189.88, 1386.95)
		event.ObjsAddPas(0, 2104.45, -195.47, 1399.2)
		event.ObjsAddPas(0, 2155.72, -202.4, 1401.26)
		event.ObjsStartPas(0)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, -1)
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(-2.14)) * 30.0) + var2)
		var6 = var3
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(-2.14)) * 30.0) + var4)
		event.ObjsMove(0, var5, var6, var7, 30, 1)
		event.ObjsReference(0, var5, var6, var7, 10)
		event.ObjsSetMotion(0, "歩き")
		var8 = 0
		while var8 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			var3 = vm.f32(var3 + 30.0)
			event.SetCameraRef(var2, var3, var4)
			var8 = var8 + 1
			if vm.wait() then
				return skip(7)
			end
		end
		event.EohSetFootSoundId(0, -1)
		event.ResetCamera(0)
		event.Finish()
	end
	return 0
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
			helper_16e20()
		end
	end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_16e20()
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
				helper_1499c()
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
		local t0 = helper_166d0()
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
			helper_1499c()
			if vm.skipping() then
				return skip(5)
			end
			event.LoadDungeonMapFile("d03b02")
			event.LoadScript("d03b02/d03b02.stb", 502)
			return
		elseif var1 > 0 then
			helper_182a8()
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
			helper_ce016066()
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
	helper_ce016066()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_17240()
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
	helper_b5303866(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13480.
script[13480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ce016066()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13520.
script[13520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DngSetupMainUnit(0)
	helper_1499c()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d03b02")
	event.LoadScript("d03b02/d03b02.stb", 502)
end

return script
