--!strict
-- map/m/m01/m01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ea412f7 = require("@lib/event/helper_0ea412f7")
local helper_10b1a515 = require("@lib/event/helper_10b1a515")
local helper_1b70c11d = require("@lib/event/helper_1b70c11d")
local helper_350ad86a = require("@lib/event/helper_350ad86a")
local helper_40a937cf = require("@lib/event/helper_40a937cf")
local helper_52147ee2 = require("@lib/event/helper_52147ee2")
local helper_64e99d3d = require("@lib/event/helper_64e99d3d")
local helper_68685f02 = require("@lib/event/helper_68685f02")
local helper_76581321 = require("@lib/event/helper_76581321")
local helper_7bee1eba = require("@lib/event/helper_7bee1eba")
local helper_8c611fc6 = require("@lib/event/helper_8c611fc6")
local helper_93837a70 = require("@lib/event/helper_93837a70")
local helper_b8d9d9d0 = require("@lib/event/helper_b8d9d9d0")
local helper_c97a57e6 = require("@lib/event/helper_c97a57e6")
local helper_dd7074b2 = require("@lib/event/helper_dd7074b2")
local helper_e003ea38 = require("@lib/event/helper_e003ea38")
local helper_e04ca1ac = require("@lib/event/helper_e04ca1ac")
local helper_e0d08ee1 = require("@lib/event/helper_e0d08ee1")
local helper_e1f412dd = require("@lib/event/helper_e1f412dd")
local helper_fcd1ed12 = require("@lib/event/helper_fcd1ed12")
local helper_fe5a2f04 = require("@lib/event/helper_fe5a2f04")
local helper_ff193881 = require("@lib/event/helper_ff193881")

--- Helper function.
local function helper_406bc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_64e99d3d(180)
			end
			if at <= 2 then
				helper_c97a57e6()
			end
			if at <= 3 then
				helper_64e99d3d(30)
			end
			if at <= 4 then
				helper_e1f412dd(0)
			end
			if at <= 5 then
				helper_64e99d3d(30)
			end
			if at <= 6 then
				helper_0ea412f7(8000010)
			end
			if at <= 7 then
				helper_0ea412f7(8000020)
			end
			if at <= 8 then
				helper_0ea412f7(8000030)
			end
			if at <= 9 then
				helper_e1f412dd(2)
			end
			if at <= 10 then
				helper_0ea412f7(8000035)
			end
			if at <= 11 then
				helper_0ea412f7(8000040)
			end
			if at <= 12 then
				helper_0ea412f7(8000050)
			end
			if at <= 13 then
				helper_0ea412f7(8000060)
			end
			if at <= 14 then
				helper_0ea412f7(8000065)
			end
			if at <= 15 then
				helper_0ea412f7(8000070)
			end
			if at <= 16 then
				helper_0ea412f7(8000080)
			end
			if at <= 17 then
				helper_0ea412f7(8000090)
			end
			if at <= 18 then
				helper_0ea412f7(8000100)
			end
			if at <= 19 then
				helper_0ea412f7(8000110)
			end
			if at <= 20 then
				helper_0ea412f7(8000120)
			end
			if at <= 21 then
				helper_0ea412f7(8000130)
			end
			if at <= 22 then
				helper_64e99d3d(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(35)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, 1678.13, -48.85, -1729.46)
		event.SetCharaRot(0, 0.0, 2.95, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(800, 1)
	event.SetCameraPos(1863.34, -57.23, -1093.45)
	event.SetCameraRef(1673.6, -34.95, -1596.24)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_64e99d3d(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(193)
	event.PlayBgm(0)
	var0 = event.SndLoadSound(1261) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e800/e800/")
	event.LoadMes(0, 5, "e800_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e800_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	event.LoadChara(5, "e800_need.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	block = event.LoadImg_4(5, "e800.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e80001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e80002", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(4, 1)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	event.EohSetPos(0, 1471.93, -90.0, -1214.38)
	event.EohSetRot(0, 0.0, 2.95, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, 1693.4, -48.85, -1747.04)
	event.EohSetRot(2, 0.0, -3.09, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1863.34, -57.23, -1093.45)
	event.CmrsSetRef(1673.6, -34.95, -1596.24)
	event.CharaActive(0)
	event.CmrsMove(1419.0, -57.23, -1121.53, 1673.6, -34.95, -1596.24, 300)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	helper_64e99d3d(180)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 1616.06, -90.0, -1552.76, 120, 1)
	helper_c97a57e6()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(1819.9, 101.8, -1573.08)
	event.CmrsSetRef(1698.78, -1.69, -1732.94)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 1607.13, -77.8, -1633.37)
	event.ObjsSetRot(0, 0.0, 2.95, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsMove(0, 1657.71, -48.85, -1704.67, 60, 1)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_64e99d3d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "振り向き", 6)
	event.ObjsRotation(2, 0.0, -0.33, 0.0, 20)
	event.ObjsMotionDelay(2, 20)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_e1f412dd(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_64e99d3d(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000010)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_0ea412f7(8000020)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(1680.47, -37.85, -1706.19)
	event.CmrsSetRef(1694.26, -26.32, -1748.64)
	event.EohSetFrameShow(2, "te_l", 0)
	event.EohSetFrameShow(2, "te_r", 0)
	event.EohSetFrameShow(2, "te_gl--v0", 1)
	event.EohSetFrameShow(2, "te_gr--v0", 1)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "しんけん顔")
	event.ObjsTexAnime(2, 1, "しんけん目パチ")
	event.SetStatus(1, 0, 256, 1)
	event.ObjsSetMotion(2, "エキサイト", 6)
	event.ObjsNextMotion(2, "エキサイト戻り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000030)
	if vm.skipping() then
		return skip(9)
	end
	helper_e1f412dd(2)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000035)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(1819.9, 101.8, -1573.08)
	event.CmrsSetRef(1698.78, -1.69, -1732.94)
	event.EohSetFrameShow(2, "te_l", 1)
	event.EohSetFrameShow(2, "te_r", 1)
	event.EohSetFrameShow(2, "te_gl--v0", 0)
	event.EohSetFrameShow(2, "te_gr--v0", 0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000040)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_0ea412f7(8000050)
	if vm.skipping() then
		return skip(13)
	end
	event.SetStatus(1, 0, 256, 0)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000060)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000065)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_0ea412f7(8000070)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000080)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000090)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000100)
	if vm.skipping() then
		return skip(19)
	end
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_0ea412f7(8000110)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000120)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	event.CmrsSetPos(1704.99, -31.99, -1684.63)
	event.CmrsSetRef(1684.93, -26.32, -1741.26)
	event.ObjsSetPos(0, 1678.13, -48.85, -1729.46)
	event.ObjsSetRot(0, 0.0, 2.95, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetPakuAnim(2, "通常口パク")
	helper_0ea412f7(8000130)
	if vm.skipping() then
		return skip(22)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_64e99d3d(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_442f0()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetCameraRef(225.0, 30.0, 280.0)
	event.SetCameraPos(225.0, 30.0, 160.0)
	event.SetCharaPos(0, 225.0, 0.0, 280.0)
	event.SetCharaRot(0, 0.0, -3.14, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Helper function.
local function helper_44554()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetCameraRef(225.0, 30.0, 280.0)
	event.SetCameraPos(225.0, 30.0, 160.0)
	event.SetCharaPos(0, 200.0, 0.0, -20.8)
	event.SetCharaRot(0, 0.0, 1.89, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Helper function.
local function helper_3d888()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_7bee1eba(64)
		end
	end
	event.Initialize()
	event.SetTime(22.0)
	event.SetTimeStepEnable(0)
	while var0 < 30 do
		event.DeleteVillager(8 + var0)
		event.DeleteChara(8 + var0)
		var0 = var0 + 1
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetCharaShow(122, 0)
	event.SetCharaShow(123, 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -3191.87, 295.72, -1655.31)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.LoadChara(5, "event/lm/p01_11a.gltf", "info", 23)
	event.CharaActive(23)
	event.EohSyncChara(1, 23)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -3632.46, 359.4, -1676.62)
	event.ObjsSetRot(1, 0.0, 1.33, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsSetPos(-2984.99, 368.7, -1657.07)
	event.CmrsSetRef(-3149.01, 368.64, -1657.54)
	helper_64e99d3d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -3260.27, 309.45, -1657.5, 90)
	event.ObjsMotionDelay(0, 80)
	event.ObjsPosDelay(0, 80)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -3299.08, 319.36, -1657.5, 20)
	event.ObjsMove(0, -3497.2, 319.45, -1657.5, 60)
	event.ObjsMove(0, -3559.21, 344.26, -1657.5, 20)
	event.ObjsMotionDelay(1, 70)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.CmrsInitPas()
	event.CmrsSetPasFrm(450)
	event.CmrsAddPas(-2984.99, 368.7, -1657.07, -3149.01, 368.64, -1657.54)
	event.CmrsAddPas(-3041.88, 368.7, -1657.23, -3205.9, 368.64, -1657.7)
	event.CmrsAddPas(-3079.68, 368.7, -1657.34, -3243.7, 368.99, -1657.57)
	event.CmrsAddPas(-3104.5, 368.7, -1657.37, -3268.51, 370.24, -1656.16)
	event.CmrsAddPas(-3138.38, 368.7, -1656.56, -3293.87, 379.2, -1645.98)
	event.CmrsAddPas(-3185.18, 368.7, -1650.32, -3318.89, 410.8, -1605.08)
	event.CmrsAddPas(-3249.8, 375.19, -1632.22, -3332.04, 457.09, -1579.83)
	event.CmrsAddPas(-3299.32, 424.82, -1601.37, -3378.0, 518.77, -1543.76)
	event.CmrsStartPas()
	event.CmrsMove(-3356.12, 493.4, -1559.76, -3378.0, 518.77, -1543.76, 120)
	if vm.wait() then
		return skip(2)
	end
	helper_7bee1eba(64)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCharaShow(122, 1)
	event.SetCharaShow(123, 1)
end

--- Program 248.
local function program_248()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
end

--- Helper function.
local function helper_4604c()
	local var0: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_64e99d3d(15)
			end
			if at <= 2 then
				helper_64e99d3d(30)
			end
			return 1
		end
		if at <= 4 then
			helper_64e99d3d(45)
		end
		return 0
	end
	print("00000000000000000000000000\n")
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetMesWindowMode(0, 5)
	var0 = event.GetMenuEtc_2(1) or var0
	if var0 == 1 then
		event.MesMake_2(0, "Aller au Tournoi de p[UNI00ea]che ?")
	else
		event.MesMake_2(0, "Aller aux Meilleures nageoires ?")
	end
	print("11111111111111111111111111111111\n")
	var1 = helper_e04ca1ac(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 0 then
		event.CmrsSetPos(1332.56, 67.86, 1494.1)
		event.CmrsSetRef(1508.0, 12.6, 1425.04)
		event.CmrsMove2(1332.56, 97.86, 1494.1, 1508.0, 42.6, 1425.04, 48, 2, 0.4)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		do
			local out1, out2, _ = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
		end
		event.ObjsSetPos(0, var2, var3, 1415.0)
		event.ObjsSetRot(0, 0.0, 1.57, 0.0)
		event.ObjsMove(0, 1800.0, var3, 1415.0, 90)
		helper_64e99d3d(15)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_64e99d3d(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, -1.57, 0.0, 15)
	helper_64e99d3d(15)
	if vm.skipping() then
		return skip(4)
	end
	do
		local _, out2, out3 = event.GetCharaPos(0)
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.ObjsMove(0, 1480.0, var6, var7, 45)
	helper_64e99d3d(45)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	return 0
end

--- Helper function.
local function helper_23b80()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e0d08ee1(0, vm.f32(-1.57))
		end
		if at <= 2 then
			helper_10b1a515(0, 1)
			helper_93837a70(0, -1, 5, 256, 208)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetQuestEtc(0, 8) or var0
	if var0 == 1 then
		var1 = event.GetCnt(12) or var1
		if 0 < var1 then
			if var1 == 1 then
				event.SetCnt(12, 2)
			end
			helper_e0d08ee1(0, vm.f32(-1.57))
			if vm.skipping() then
				return skip(2)
			end
			helper_10b1a515(0, 1)
			event.MesMake_2(
				0,
				'Il y a un petit mot :<page>"La soir[UNI00e9]e est annul[UNI00e9]e parce\n que le fromage n\'est pas assez [UNI00e9]pais.\n                          Ferdinand"'
			)
			helper_93837a70(0, -1, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
			event.SetFuncEtc(1)
			if vm.wait() then
				return skip(4)
			end
		end
	end
end

--- Helper function.
local function helper_447b8()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_64e99d3d(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_1b70c11d(5, 160)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_64e99d3d(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_39b34()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_64e99d3d(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_64e99d3d(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_64e99d3d(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_44074()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_1b70c11d(5, 55)
		end
		if at <= 2 then
			helper_64e99d3d(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	if vm.wait() then
		return skip(1)
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_1b70c11d(5, 55)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_64e99d3d(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_3f908()
	local var0: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 6.5
			var0 = vm.f32(var0 + vm.f32(0.004))
		end
		if at <= 2 then
			helper_c97a57e6()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(396.92, 146.86, -175.05)
	event.CmrsSetRef(744.44, 257.9, -23.8)
	event.SetTime(6.5)
	var0 = 6.5
	while true do
		var0 = vm.f32(var0 + vm.f32(0.004))
		event.SetTime(var0)
		if vm.wait() then
			return skip(2)
		end
		if var0 > vm.f32(6.8) then
			break
		end
	end
	event.CmrsFadeInit()
	event.CmrsFadeDelay(190)
	event.CmrsFadeOut(60, 0.0, 0.0, 0.0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(250)
	event.CmrsAddPas(396.92, 146.86, -175.05, 744.44, 257.9, -23.8)
	event.CmrsAddPas(104.88, 122.77, 6.77, 326.18, 70.53, 147.12)
	event.CmrsStartPas()
	helper_c97a57e6()
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_3fd24()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3f908()
			end
			if vm.skip_end() then
				return skip(3)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.SetFlag(56, 0)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.CmrsInit()
	if vm.wait() then
		return skip(1)
	end
	event.SetCameraPos(0.0, 0.0, 0.0)
	event.SetCameraRef(1.0, 0.0, 0.0)
	event.CharaActive(0, 0)
	helper_3f908()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 530.
local function program_530()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.FuncPointShow("p01_e01g01-0", "invent_36-0", 1)
	helper_3fd24()
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraPos(345.12, 84.74, -31.95)
	event.SetCameraRef(351.66, 70.52, 137.18)
	event.SetCharaPos(0, 350.13, 52.0, 148.02)
	event.SetCharaRot(0, 0.0, -3.12, 0.0)
	event.BgmPlayCancel()
	if vm.wait() then
		return skip(2)
	end
	event.GotoInterior(-1, "i01h01", 500, 1)
	if vm.wait() then
		return skip(3)
	end
end

--- Helper function.
local function helper_3ff60()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			if vm.skip_end() then
				return skip(2)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.DeleteChara(32)
		event.CharaActive(1, 0)
	end
	helper_8c611fc6(1798.0, 0.0, vm.f32(2611.2), vm.f32(1.23))
	event.ResetCamera(1, 0.0, 10.0)
	event.Initialize()
	event.LoadSound(1240)
	event.SndLoadSound(1240)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 32)
	event.CharaActive(1, 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.EohSyncObj(1, "p01_e03h03-0")
	event.EohSetShow(1, 0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.CmrsSetPos(1992.97, 34.74, 2905.51)
	event.CmrsSetRef(2030.46, 40.14, 2965.77)
	event.ObjsSetPos(0, 2129.53, 0.0, 3073.66)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.CmrsMove2(1713.52, 39.48, 2489.48, 1730.42, 46.55, 2524.75, 150, 2, 0.4)
	event.ObjsSetMotion(0, "歩き２", 4)
	event.ObjsMove(0, 2128.59, 26.83, 3265.59, 150, 1)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(120)
	event.CmrsFadeOut(30)
	helper_c97a57e6()
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInit()
	return part2()
end

--- Helper function.
local function helper_122c4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max ! Tu m'as fait peur.\nJ'[UNI00e9]tais en train de traiter\ncet arbre contre les insectes.<page>Certains arbres poussent mal, tu\nsais. Il y en a, comme lui, qui\nont vraiment besoin de soins."
		)
		helper_40a937cf(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_11f70(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Apparemment il faut parler [UNI00e0]\n   Gordon pour attirer son attention.")
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_1261c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_11f70(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, Max ! Tu as l'air de tra[UNI00ee]ner\npas mal en ce moment. Tu te\nportes bien ?<page>Je peux faire quelque chose ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ah bon ! Tu veux que je\nt'accompagne dans tes aventures ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Mmm... J'aimerais bien venir avec\ntoi... Mais ce pauvre arbre ne va\npas tr[UNI00e8]s bien.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Soigner les arbres et les fleurs\nde cette propri[UNI00e9]t[UNI00e9] est ma grande\npriorit[UNI00e9], tu sais.<page>Si je pars me balader maintenant,\nje pourrais perdre mon travail."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Je parie que l'eau sacr[UNI00e9]e vendue [UNI00e0]\nl'[UNI00e9]glise soignerait cet arbre !<page>Mais, comme tu le sais, ton p[UNI00e8]re et\nP[UNI00e8]re Bruno ne s'entendent pas...<page>Ton p[UNI00e8]re ne me donnera jamais de\nsous pour acheter de l'eau sacr[UNI00e9]e !<page>J'ai un vrai probl[UNI00e8]me l[UNI00e0]."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Pour que Gordon aille [UNI00e0] Sindain,\n   tu dois le convaincre de venir\n   avec toi.")
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]R[UNI00e9]alise la mission de Gordon\n   et il montera dans le train pour\n   t'accompagner."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Tu peux consulter tes missions\n   en lisant ton carnet de notes,\n   situ[UNI00e9] dans le menu Objets."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)]Oh, tu n'as pas de carnet.\n   Il y en a un sur la table\n   chez C[UNI00e9]dric, le r[UNI00e9]parateur."
		)
		helper_93837a70(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]Il y en a un autre dans la\n   base secr[UNI00e8]te de Donny. Ils se valent.\n   R[UNI00e9]cup[UNI00e8]re l'un d'eux !"
		)
		helper_93837a70(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

--- Helper function.
local function helper_133cc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_11f70(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Max, soigner cet arbre est ma\ngrande priorit[UNI00e9].<page>Mais pour cela, il me\nfaudrait..."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.GotoUseItem(276)
	do
		local skipped = vm.wait()
		var3 = event.DeferredOutput() or var3
		if skipped then
			return skip(4)
		end
	end
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 276 then
		event.MesMake_2(
			0,
			"Max, [UNI00e7]a ne marchera pas.<page>Ce qu'il me faut, c'est de l'Eau\nsacr[UNI00e9]e du P[UNI00e8]re Bruno."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ouais ! Max tu as r[UNI00e9]ussi ! Je vais\npouvoir soigner cet arbre !<page>Merci, Max.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"J'ai fait tout ce que je devais\nfaire pour un bon moment.<page>Je peux donc t'accompagner dans\nton aventure !<page>Oh, et ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon s'est joint [UNI00e0] ton aventure.")
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tu peux utiliser ses talents\n   [UNI00e0] partir de la commande Statut, dans\n   Personnages (Menu principal).<page>[(!)]Si tu recrutes une autre\n   personne pour tes aventures,\n   celle-ci montera dans le train."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Parle [UNI00e0] cette personne dans le\n   train pour en faire le 3e\n   membre de ton groupe.<page>[(!)]Pour d[UNI00e9]placer un ami du train\n   vers une maison, choisis Installer\n   quelqu'un (menu de la porte)."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]Il est possible que d'autres personnes\n   souhaitent participer [UNI00e0] l'aventure.\n   Surtout, ne les manque pas !"
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	var4 = event.GetEventData_2(14) or var4
	event.SetNpcStatus(var4, 130)
	event.Finish()
	event.SetQuestEtc(1, 0, 1)
end

--- Helper function.
local function helper_1411c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, bonjour jeune dame.\nQue puis-je faire pour vous ?")
		else
			event.MesMake_2(
				0,
				"Max, ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
			)
		end
	else
		event.MesMake_2(0, "Il doit y avoir tant de plantes\nqu'on ne conna[UNI00ee]t pas encore.")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1445c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
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
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_122c4(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_1261c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_133cc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_1411c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_16ff4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_350ad86a(arg0, 0, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_350ad86a(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "H[UNI00e9], Max.<page>Comment tu fais pour toujours\navoir l'air en forme ?!")
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_17400(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_68685f02(0, -1, arg1, arg0, 0)
			end
			if at <= 5 then
				helper_93837a70(0, -1, 8, 0, 0)
			end
			return
		end
		if at <= 7 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_68685f02(0, -1, arg1, arg0, 0)
		end
		if at <= 10 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 13 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_350ad86a(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, "...")
		helper_68685f02(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]Monica n'aime pas trop ce genre de \n   situation. Elle n'est pas s[UNI00fb]re d'arriver\n   [UNI00e0] ses fins. Essaie plut[UNI00f4]t avec Max."
		)
		helper_93837a70(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesPreset(0, 0)
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "H[UNI00e9] Max.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "...")
	helper_68685f02(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Ouais, [UNI00e7]a te fait rire, hein ?\nJe sais que c'est bizarre !<page>Qui irait tomber amoureux d'une\nfille en gouache ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"Mais je suis un artiste magique. Je\npeux donner l'existence [UNI00e0] ce que je<page>dessine. L'existence, mais pas la\nvie, c'est vrai..."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "Personne ne peut dessiner la vie.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "Mais j'ai entendu parler d'un [UNI0153]uf\ndor[UNI00e9] dans un grand arbre ancien.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Il para[UNI00ee]t qu'avec sa couleur dor[UNI00e9]e,\non peut donner vie aux dessins.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"Max, tu quittes la ville, non ?\nTu crois que tu pourrais m'avoir<page>de la peinture dor[UNI00e9]e ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Je te le revaudrai bien entendu.<page>Si tu m'aides, j'utiliserai mes\nnouveaux pouvoirs pour t'assister."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Un vieil arbre, immense...\n   Avec un [UNI0153]uf dor[UNI00e9] ! Mais o[UNI00f9] trouver\n   un arbre comme celui-ci ?!"
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_11e90()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff193881(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_ff193881(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_18568(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11e90()
		end
		if at <= 8 then
			helper_ff193881(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Je t'attendais. Vite, donne-moi<page>la peinture, que je puisse enfin\ndonner vie [UNI00e0] mon portrait."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
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
			"C'est une blague !?<page>Ce qu'il me faut, c'est de la\npeinture dor[UNI00e9]e. Et rien d'autre !"
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "Ah, la fameuse peinture dor[UNI00e9]e...\nJe vais l'essayer imm[UNI00e9]diatement.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "E-elle... Elle est r[UNI00e9]elle...<page>[UNI00c9]tonnant, elle est parfaite !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Merci, Max. Je n'ai pas oubli[UNI00e9] ma\npromesse. Tu pourras utiliser mes\nnouveaux pouvoirs quand tu veux."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_ff193881(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_18d90(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "N'h[UNI00e9]site pas [UNI00e0] utiliser mes\nnouveaux pouvoirs quand tu le\nvoudras.")
	else
		event.MesMake_2(
			0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_19018(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_16ff4(arg0, arg1)
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
		helper_16ff4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_17400(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_18568(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_18d90(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_10d4c(arg0: s32)
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
			helper_93837a70(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_10b1a515(arg0, 1)
			helper_68685f02(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_93837a70(arg0, -1, 3, 256, 208)
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
		helper_10b1a515(arg0, 1)
		event.MesMake_2(arg0, "Ram[UNI00e8]ne-moi plus de scoops ou je ne\npourrai rien te donner !")
		if now_map_no == 22 then
			helper_68685f02(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_93837a70(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_10b1a515(arg0, 1)
		event.MesMake_2(
			arg0,
			"Ton niveau de photographie est\nd[UNI00e9]termin[UNI00e9] par le nombre d'id[UNI00e9]es et\nde scoops que tu as.<page>[UNI00c0] mesure que ton niveau s'am[UNI00e9]liore,\ntu gagnes des trucs supers."
		)
		if now_map_no == 22 then
			helper_68685f02(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_93837a70(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_113d4(arg0: s32)
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
				helper_93837a70(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_93837a70(arg0, -1, 3, 256, 208)
			end
			return helper_10d4c(arg0)
		end
		if at <= 5 then
			helper_10b1a515(arg0, 1)
			helper_68685f02(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_93837a70(arg0, -1, 3, 256, 208)
		end
		return helper_10d4c(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_10b1a515(arg0, 1)
		event.MesMake_2(arg0, "Va me chercher un\nM[UNI00e9]mo de scoops, tu veux bien ?")
		if now_map_no == 22 then
			helper_68685f02(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_93837a70(arg0, -1, 3, 256, 208)
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
		helper_10b1a515(arg0, 1)
		event.MesMake_2(arg0, "On dirait qu'il n'y\na plus de scoops.")
		if now_map_no == 22 then
			helper_68685f02(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_93837a70(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_10d4c(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_10b1a515(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "J'ai trouv[UNI00e9] [Number1] nouveau(x) scoop(s).")
		event.SetMesDrawspeed(arg0, 0)
		helper_93837a70(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_10b1a515(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Allez ! Arr[UNI00ea]te de lambiner !\nIls sont o[UNI00f9] tes super scoops ?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ouah ! Tu as [Number1] nouveau(x)\nscoop(s) ! Je savais que tu y\narriverais.")
	end
	if now_map_no == 22 then
		helper_68685f02(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_93837a70(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_10d4c(arg0)
end

--- Helper function.
local function helper_e5c8()
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
			helper_40a937cf(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_e003ea38(15)
		end
		if at <= 3 then
			helper_e003ea38(1)
		end
		if at <= 4 then
			helper_e003ea38(6)
		end
		if at <= 5 then
			helper_e003ea38(0)
		end
		if at <= 6 then
			helper_e003ea38(4)
		end
		if at <= 7 then
			helper_e003ea38(31)
		end
		if at <= 8 then
			helper_e003ea38(35)
		end
		if at <= 9 then
			helper_e003ea38(36)
		end
		if at <= 10 then
			helper_e003ea38(37)
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
		helper_40a937cf(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_e003ea38(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_e003ea38(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_e003ea38(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_e003ea38(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_e003ea38(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_e003ea38(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_e003ea38(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_e003ea38(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_e003ea38(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_194ac(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Le magasin est ferm[UNI00e9]. Tu dois donc\naller au magasin de mon p[UNI00e8]re. Cherche<page>les citrouilles, tu ne peux pas les\nrater. C'est en haut de la colline."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_192fc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Depuis ton arriv[UNI00e9]e, j'ai\n[UNI00e0] peine vu Max. Je ne sais pas\n[UNI00e0] quoi tu t'amuses, mais j'esp[UNI00e8]re<page>que tu ne te sers pas de lui."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1966c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_192fc(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Tu devrais conna[UNI00ee]tre ma r[UNI00e9]ponse [UNI00e0]\n[UNI00e7]a : PAS QUESTION !<page>C'est pas mon genre de travailler\npour le compte des autres !"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "[UNI00c7]a ne m'apporte pas grand-chose et\nen plus, c'est trop dangereux.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Mais puisque c'est toi, je pense\nque je vais y r[UNI00e9]fl[UNI00e9]chir.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Mais bon, je suis fils de\ncommer[UNI00e7]ant et chez nous, rien\nn'est gratuit.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Je collectionne les pi[UNI00e8]ces de<page>monnaie, le symbole du commerce. Et\nje r[UNI00ea]ve de compl[UNI00e9]ter ma collection."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Mais je n'arrive pas [UNI00e0] mettre la\nmain sur la Pi[UNI00e8]ce de sacrifice et\nla Pi[UNI00e8]ce de Solidit[UNI00e9].<page>Si tu les trouves pour moi, je\nt'aiderai peut-[UNI00ea]tre [UNI00e0] mon tour."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_19e60(arg0: s32, arg1: s32)
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
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_11e90()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_192fc(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(201) or argc
	argc_2 = event.GetItemNum(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.MesMake_2(
			0,
			"Quoi ? Ah, les pi[UNI00e8]ces de monnaie ?<page>Je cherche la Pi[UNI00e8]ce de sacrifice\net la Pi[UNI00e8]ce de solidit[UNI00e9].<page>Tu ne les trouveras jamais, j'ai\nd[UNI00e9]j[UNI00e0] cherch[UNI00e9] partout."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Quoi ? Tu les as ? Incroyable !<page>Allez vite, donne-les-moi !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Bon.\nQu'est-ce que je dois faire ?")
	var5 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Aaah ! Si tu me casses les pieds,\nje ne t'aiderai certainement pas.")
		helper_68685f02(0, -1, arg0, arg1, 0)
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
		"Ouaah, je les ai toutes !\nJe n'y croyais plus...<page>Bon, je n'ai plus le choix hein ?\nJe vais venir avec toi !"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_1a8f0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_192fc(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"Je n'y crois pas. Je n'ai jamais\nvraiment cru que tu les trouverais.<page>T'as fait tr[UNI00e8]s fort Max !"
		)
	else
		event.MesMake_2(
			0,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1ac30(arg0: s32, arg1: s32)
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
		helper_194ac(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_1966c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_19e60(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_1a8f0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_1af14(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_350ad86a(arg0, 0, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Bonjour. Quels types de plats\naimes-tu, Monica ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"Oui, j'aime les plats classiques,\nmais je m'int[UNI00e9]resse aussi aux\nsaveurs plus... inhabituelles."
		)
	else
		event.MesMake_2(
			0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1b2fc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Alors, tu as fait des trouvailles ?<page>Tu sais, pendant que tu d[UNI00e9]couvres\nles rouages des machines,\nmoi, je d[UNI00e9]couvre la cuisine.<page>Chaque jour, je me perfectionne\ndans l'art de faire des plats\nd[UNI00e9]licieux et totalement in[UNI00e9]dits."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1b51c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ah, tu arrives bien !\nJe voulais te parler de quelque\nchose.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Tu sais s[UNI00fb]rement que je cherche\ntoujours [UNI00e0] d[UNI00e9]couvrir de nouvelles\np[UNI00e2]tisseries venues du monde entier.\n"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "On m'a parl[UNI00e9] d'un g[UNI00e2]teau appel[UNI00e9]\ncastagnaccio...")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Confectionn[UNI00e9] [UNI00e0] base de castarnas.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"J'ai appris que ces castarnas\npoussaient sur des arbres de la\nfamille des ch[UNI00e2]taigniers."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Alors j'ai pens[UNI00e9] essayer la recette\navec des marrons, mais bizarrement,\nil n'y a plus un marron en ville."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Il para[UNI00ee]t que le Maire les a tous\nachet[UNI00e9]s... Tu ne pourrais pas\nm'aider ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_1bcc8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Tu as trouv[UNI00e9] des marrons ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
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
		event.MesMake_2(
			0,
			"Alors, tu ne peux pas m'aider...<page>Tant pis, je ne ferai pas\nde castagnaccio, voil[UNI00e0] tout."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Oui, c'est [UNI00e7]a ! Merci beaucoup ! Je<page>vais pouvoir faire un castagnaccio.<page>Je te ferai go[UNI00fb]ter si tu veux."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Comment te remercier... ?<page>Quoi, te suivre dans une aventure ?<page>Ha ha ! Mais bien s[UNI00fb]r...<page>Il fallait le dire tout de suite."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1c390(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Moi, je ne pourrais jamais\nrien te refuser.")
	else
		event.MesMake_2(
			0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1c5e8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1af14(arg0, arg1)
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
		helper_1af14(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1b2fc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1b51c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1bcc8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1c390(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1c974(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_350ad86a(arg0, 0, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Salut ! Tu es la copine de\nMax ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Tes cheveux ont une couleur tr[UNI00e8]s\noriginale. Je les trouve<page>magnifiques, ils brillent\ncomme des bijoux."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1cc44(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c974(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c974(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Tu as quitt[UNI00e9] la ville r[UNI00e9]cemment,\nnon, Max ?<page>Ne dis pas le contraire.\nJe le sais."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1ce6c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c974(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"J'aimerais bien t'aider, mais j'ai\ntr[UNI00e8]s peur de me battre et je\nrisquerais de me salir."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Et j'ai horreur d'[UNI00ea]tre un poids\npour les autres. D[UNI00e9]sol[UNI00e9]e, mais...\nje vais devoir dire non."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Il y a plein de trucs bizarres\nhors de la ville, je parie !<page>Je me demande comment sont les\narbres, et quelles fleurs il y a."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Si tu vois une fleur [UNI00e9]trange, tu\npeux la prendre en photo pour moi\nMax ? J'aimerais tant en voir une."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Elle a dit non cette fois-ci, mais\n   si tu lui montres une photo qui\n   l'int[UNI00e9]resse, elle capitulera s[UNI00fb]rement."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 4, 1)
end

--- Helper function.
local function helper_1d610(arg0: s32, arg1: s32)
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
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11e90()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c974(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
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
			"As-tu photographi[UNI00e9] une fleur ?<page>J'en connais plein alors elle devra\n[UNI00ea]tre tr[UNI00e8]s sp[UNI00e9]ciale pour m'int[UNI00e9]resser."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "As-tu photographi[UNI00e9] une fleur\ninhabituelle ?\nMontre-moi, montre-moi vite !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Ouaah ! [UNI00c9]tonnant ! Voici donc le\ngenre de fleur qu'on trouve [UNI00e0]\nl'ext[UNI00e9]rieur."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Humm... Que dois-je faire ?<page>Bon d'accord ! Emm[UNI00e8]ne-moi avec toi !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1dea0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_1c974(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "[UNI00c9]vite les endroits\ntrop dangereux.")
	else
		event.MesMake_2(
			0,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1e190(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1cc44(arg0, arg1)
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
		helper_1cc44(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1ce6c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1d610(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1dea0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1e474(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Je suis peut-[UNI00ea]tre le seul [UNI00e0] le\npenser, quelque chose en toi me<page>rappelle H[UNI00e9]l[UNI00e8]ne. Un je-ne-sais-\nquoi qui te distingue des autres."
		)
	else
		event.MesMake_2(0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1e72c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Quel que soit ton probl[UNI00e8]me,\nn'h[UNI00e9]site pas [UNI00e0] venir me voir\nen premier.")
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1e89c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Je ferai de mon mieux pour t'aider\nsi tu as besoin de quoi que ce<page>soit. Pas de probl[UNI00e8]me."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Je ne sais pas si tu peux<page>m'aider... Mais [UNI00e9]coute bien [UNI00e7]a.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Je travaille dur depuis pr[UNI00e8]s de 30\nans dans cette maison.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Je consacre tout mon temps libre\n[UNI00e0] mon seul et unique passe-temps,\nla lecture.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Un livre extr[UNI00ea]mement rare et\npr[UNI00e9]cieux est [UNI00e0] vendre aux ench[UNI00e8]res\nen ce moment."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Tout le monde se bat pour l'avoir.\nJe pense qu'une somme d'environ\n1000 Gildas devrait suffire."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Mais je n'ai pas une telle somme,\net mon ma[UNI00ee]tre serait outr[UNI00e9] si je\nlui demandais de me la pr[UNI00ea]ter."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Alors tu es mon seul espoir.<page>[UNI00c7]a ne veut pas dire que si tu ne\npeux pas m'aider, je ne ferai rien pour toi."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Malgr[UNI00e9] ses dires, Stewart ne t'aidera\n   s[UNI00fb]rement pas, sauf pour 1000 Gildas.\n   Bref, il va falloir trouver de l'argent."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

--- Helper function.
local function helper_1f3c8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_64e99d3d(30)
			end
			return
		end
		if at <= 13 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"[UNI00c7]a n'est pas assez pour que je\npuisse remporter les ench[UNI00e8]res.<page>Il me faut 1000 Gildas. Je t'en\nprie, trouve-les !"
			)
			helper_68685f02(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(
				0,
				"Tu ne vas pas le croire !<page>L'ench[UNI00e8]re est mont[UNI00e9]e [UNI00e0]\n1200 Gildas."
			)
			helper_68685f02(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(
				0,
				"Je suis vraiment d[UNI00e9]sol[UNI00e9], mais tu\nne pourrais pas te procurer\n1500 Gildas ?"
			)
			helper_68685f02(0, -1, arg0, arg1, 0)
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
				"Il faut faire vite, sinon il va\n[UNI00ea]tre vendu [UNI00e0] quelqu'un d'autre.<page>Vite, trouve-moi 1500 Gildas !"
			)
			helper_68685f02(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"C'est terrible ! Quelqu'un est\npr[UNI00ea]t [UNI00e0] payer 1800 Gildas !<page>Si je ne surench[UNI00e9]ris pas avec 2000\nGildas, je n'aurai pas le livre."
			)
			helper_68685f02(0, -1, arg0, arg1, 0)
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
				"Il faut faire vite, sinon il va\n[UNI00ea]tre vendu [UNI00e0] quelqu'un d'autre.<page>Vite, trouve-moi 2000 Gildas !"
			)
			helper_68685f02(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Fiston, tu as r[UNI00e9]ussi [UNI00e0] rassembler\nmes 2000 Gildas ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(
			0,
			"Ben oui. Ils sont [UNI00e0] toi.\nM[UNI00ea]me si j'ai l'impression que\nc'est du g[UNI00e2]chis."
		)
		var4 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"Mmm... 2000 Gildas, c'est beaucoup.\n[UNI00c7]a doit [UNI00ea]tre dur de s'en s[UNI00e9]parer.\nM[UNI00ea]me pour un gar[UNI00e7]on ais[UNI00e9] comme toi.<page>Tr[UNI00e8]s bien, tant pis ! Mais l'ench[UNI00e8]re\nn'est pas encore termin[UNI00e9]e.\nJ'attendrai le temps qu'il faudra."
			)
			helper_68685f02(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Merci de tout c[UNI0153]ur.<page>Je file aux ench[UNI00e8]res !")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_64e99d3d(30)
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
	event.MesMake_2(0, "Merci de tout c[UNI0153]ur.\nMa surench[UNI00e8]re a r[UNI00e9]ussi.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"Les autres acheteurs potentiels ont\nvite abandonn[UNI00e9] et j'ai eu le livre\npour 1400 Gildas !"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Je peux donc t'en rendre 600.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(
		0,
		"Et maintenant, je vais travailler\ndur pour rembourser le reste de\nla somme que je t'ai emprunt[UNI00e9]e."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Je sais que tu t'es d[UNI00e9]men[UNI00e9] pour\nmoi. Je te rendrai la pareille\nquand tu voudras."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_20b50(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Le livre que j'ai achet[UNI00e9] ?\nEn fait, je ne l'ai pas encore lu.<page>Le poss[UNI00e9]der suffit [UNI00e0] mon\nbonheur."
		)
	else
		event.MesMake_2(0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_20dd8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1e474(arg0, arg1)
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
		helper_1e474(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1e72c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1e89c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1f3c8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_20b50(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_21164(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_350ad86a(arg0, 0, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Je t'en prie, arr[UNI00ea]te de mettre Max\ndans des situations dangereuses.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "S'il a ne serait-ce qu'une\n[UNI00e9]gratignure, jamais je ne te\nle pardonnerai !")
	else
		event.MesMake_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2150c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Je travaille ici comme\ngouvernante, mais je r[UNI00ea]ve depuis\nl'enfance de devenir couturi[UNI00e8]re."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Mais les r[UNI00ea]ves ne se r[UNI00e9]alisent\npas, c'est pourquoi ils restent\ndes r[UNI00ea]ves."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2180c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Je vois... J'aimerais vraiment\npouvoir t'aider.\nTu le sais.<page>Mais je n'ai vraiment pas\nassez confiance en moi."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"J'abandonne toujours tout [UNI00e0] mi-\nchemin, je n'ai jamais rien fini.<page>J'ai toujours voulu devenir\ncouturi[UNI00e8]re, mais je n'ai jamais\ntermin[UNI00e9] un seul v[UNI00ea]tement."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si je venais avec toi,\nje ne ferais que t'emb[UNI00ea]ter.<page>Alors, d[UNI00e9]sol[UNI00e9]e, mais c'est non."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Oh non, Ad[UNI00e8]le a perdu toute\n   confiance en elle. C'est un probl[UNI00e8]me.\n   Faisons-lui faire de nouveaux habits."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

--- Helper function.
local function helper_21e58(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Oui, si j'essaie [UNI00e0] nouveau et je\ntermine quelque chose, peut-[UNI00ea]tre\nretrouverai-je confiance en moi."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Mais j'ai pas les mat[UNI00e9]riaux<page>n[UNI00e9]cessaires. Pourrais-tu te les\nprocurer pour moi ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Il me faut du tissu r[UNI00e9]sistant,\ndu cuir [UNI00e9]pais et un morceau\nde cuivre.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_22288(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_350ad86a(arg0, 0, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 4 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			helper_64e99d3d(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(214) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	if argc <= 0 or argc_2 <= 0 or argc_3 <= 0 then
		event.MesMake_2(
			0,
			"Sans mat[UNI00e9]riaux, je ne\npeux rien faire. Il me faut du<page>tissu r[UNI00e9]sistant, du cuir [UNI00e9]pais\net un morceau de cuivre.<page>Je suis d[UNI00e9]sol[UNI00e9]e de te cr[UNI00e9]er\ntant de soucis."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Tiens, prends [UNI00e7]a !\n[UNI00c7]a sera perdu autrement.")
	var5 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Sans mat[UNI00e9]riaux,\nje ne peux rien faire.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(214)
	event.SubItem(245)
	event.SubItem(227)
	event.SetCnt(8, 2)
	event.MesMake_2(
		0,
		"Merci ! Maintenant, je vais\nessayer de coudre des v[UNI00ea]tements !<page>Rien de tout cela ne sera jet[UNI00e9]."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_64e99d3d(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.Finish()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_22cfc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_350ad86a(arg0, 0, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			var2 = 259
			var2 = 258
			var2 = 260
			helper_dd7074b2(var2, 1)
		end
		if at <= 6 then
			helper_76581321(1)
		end
		if at <= 7 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_11e90()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ah, Max ! J'ai enfin fini un\nv[UNI00ea]tement !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Je ne voulais pas que tes mat[UNI00e9]riaux\nsoient jet[UNI00e9]s, et c'est [UNI00e7]a qui\nm'a oblig[UNI00e9]e [UNI00e0] le terminer."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Je ne suis pas tr[UNI00e8]s satisfaite\nde cette tenue, mais... voudrais-tu\nla porter ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
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
	helper_dd7074b2(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_76581321(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ah, c'est vraiment super d'avoir\nenfin pu terminer quelque chose.<page>Je me sens beaucoup plus s[UNI00fb]re\nde moi, maintenant.<page>Je ferai de mon mieux, je\nt'en prie, emm[UNI00e8]ne-moi avec toi."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_23478(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Qu'est-ce que [UNI00e7]a donne ?<page>Sois honn[UNI00ea]te avec moi !")
	else
		event.MesMake_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_236b0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_21164(arg0, arg1)
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
				helper_22288(arg0, arg1)
			end
			if at <= 6 then
				helper_22cfc(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_21164(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2150c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_2180c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_21e58(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_22288(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_22cfc(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_23478(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_249f8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_350ad86a(arg0, 0, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"C'est toi la fille qui tra[UNI00ee]ne\navec Max depuis quelque temps.<page>Je sais reconna[UNI00ee]tre une personne de\nvaleur quand j'en rencontre une."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Si j'[UNI00e9]tais un peu plus jeune, je\nne le laisserais pas partir.")
	else
		event.MesMake_2(0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_24e00(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"En affaires, il est essentiel de\ngagner la confiance de tes clients.<page>C'est quelque chose qu'il ne faut\njamais consid[UNI00e9]rer comme acquis."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_24fb0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_dd7074b2(300, 20)
		end
		if at <= 5 then
			helper_76581321(1)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Tu veux que je\nvienne avec toi ?<page>Je ne suis qu'une femme qui fait\ndu pain, mais si je peux t'aider,\nje le ferai avec plaisir."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, mais d'abord, j'ai quelque chose\n[UNI00e0] faire livrer [UNI00e0] Morton.<page>[UNI00c7]a t'emb[UNI00ea]terait d'emporter pour moi\n20 pains [UNI00e0] son magasin ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Pendant ce temps-l[UNI00e0], je vais\nfaire mes bagages pour le voyage.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_dd7074b2(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_76581321(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Je me demande ce qu'il peut bien\nvouloir faire avec 20 pains ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_255b0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"D[UNI00e9]sol[UNI00e9]e, je ne suis\ntoujours pas pr[UNI00ea]te.<page>Tu peux me laisser\nun peu plus de temps ?"
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Mais au fait, tu es all[UNI00e9]\nchez Morton faire ma livraison ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Quoi ? Ce n'est vraiment\npas correct de sa part !<page>Bon, tr[UNI00e8]s bien,\ntu n'as qu'[UNI00e0] les garder."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Peu importe,\nallons-y.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_11e90()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_25bf0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Allez Max,\non y va.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
	else
		event.MesMake_2(0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_25e28(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_249f8(arg0, arg1)
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
		helper_249f8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_24e00(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_24fb0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_255b0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_25bf0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_14728(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Je n'aime pas trop voir les femmes\nmanier des [UNI00e9]p[UNI00e9]es. Pour moi, une<page>femme doit [UNI00ea]tre plus f[UNI00e9]minine.\nComme Ad[UNI00e8]le, par exemple."
		)
	else
		event.MesMake_2(0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_149e0(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Cette ville est tr[UNI00e8]s calme, du coup\nje n'ai pas de travail du tout.<page>[UNI00c9]videmment, je sais que c'est une\nbonne chose, mais quand m[UNI00ea]me..."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14ba0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Salut, Max.\nExcuse-moi, mais je suis\nun peu pris pour l'instant.<page>Je suis en train de r[UNI00e9]cup[UNI00e9]rer des\nmat[UNI00e9]riaux importants qui aideront [UNI00e0]\npr[UNI00e9]server la s[UNI00e9]curit[UNI00e9] de la ville."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Si [UNI00e7]a n'est pas urgent,\n[UNI00e7]a peut attendre jusqu'[UNI00e0] demain ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_14f10(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Oui, je vais essayer.\nJe n'en suis pas capable.")
	var2 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(0, "OK...<page>OK, si tu veux r[UNI00e9]essayer plus tard,\nfais-le moi savoir. Je serai ici.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "[UNI00c0] vos marques, pr[UNI00ea]t,\npartez !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

--- Helper function.
local function helper_154c4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_14f10(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "H[UNI00e9] Max, tu es venu me chercher ?<page>Je t'attendais.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Gr[UNI00e2]ce aux remparts, cette ville\nest bien prot[UNI00e9]g[UNI00e9]e. Nous devrions<page>maintenant en sortir."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"C'est bien de passer son temps\n[UNI00e0] bricoler comme tu le fais,\nmais fais-tu assez d'exercice ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Au combat, tout est dans la\nrapidit[UNI00e9] et le jeu de jambes.<page>Si tu es plus lent que moi, c'est\nm[UNI00ea]me pas la peine d'insister."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Tiens, on va voir ! Cours jusqu'au\nbateau sur le lac et reviens. Mon<page>record est de 2 minutes 1 seconde.\nSi tu es plus lent que [UNI00e7]a,\npas la peine d'insister."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "Alors, tu veux essayer ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_14f10(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_15bc8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_14f10(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_14f10(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_14f10(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_14f10(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_11e90()
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
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(0, "Tiens salut Max.\nTu es venu r[UNI00e9]essayer ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_14f10(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(
			0,
			"H[UNI00e9] ! Tu n'es pas all[UNI00e9] jusqu'au\nbateau, hein ? Tu as essay[UNI00e9] de\nm'avoir. Ne triche pas !"
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_14f10(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "H[UNI00e9], on ne triche pas !")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_14f10(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "Oh, te voil[UNI00e0] de retour !\nBon,<page>regardons tes\ntemps !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(
			0,
			"Oh la la !\n[数値１] minutes [数値２].[数値３] secondes,\nc'est beaucoup trop lent."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_14f10(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(0, "Oh !\n[数値１] minutes [数値２] secondes [数値３]\nc'est pas mauvais, [UNI00e7]a !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Tu es bien plus rapide que tu\nen as l'air. Bon, allons affronter\nl'ennemi ensemble !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_16858(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Tu es bien plus rapide\nque tu en as l'air.\nTu m'as surpris !")
	else
		event.MesMake_2(0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_16ab0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14728(arg0, arg1)
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
		helper_14728(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_149e0(arg0, arg1)
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
		helper_14ba0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_154c4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_15bc8(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_16858(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_261b4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Alors tu m'as vue au cirque ?\nC'[UNI00e9]tait pas mal, non ?<page>Mais ce n'est pas vraiment un\nboulot, plut[UNI00f4]t un passe-temps."
		)
	else
		event.MesMake_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2643c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mon magasin est sp[UNI00e9]cialis[UNI00e9] en\narmes blanches.<page>J'ai quelques armes [UNI00e0] feu,\nmais [UNI00e7]a n'est pas\nvraiment mon truc."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_265ec(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_dd7074b2(44, 1)
		end
		if at <= 6 then
			helper_76581321(1)
		end
		if at <= 7 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Tu es Monica,\nc'est [UNI00e7]a ?<page>J'ai entendu dire que tu te\nd[UNI00e9]brouillais plut[UNI00f4]t bien [UNI00e0] l'[UNI00e9]p[UNI00e9]e."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Mais les [UNI00e9]p[UNI00e9]es ne sont\npas des jouets, tu sais.<page>Il faut faire preuve de jugeote\nface [UNI00e0] l'ennemi."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] faire [UNI00e9]voluer\nune [UNI00e9]p[UNI00e9]e de 2 niveaux, tu\nm'auras convaincue de ton talent."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Pourquoi ne pas commencer\navec ce Gladius ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_dd7074b2(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_76581321(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Pour que Milane t'aide, il va\n   falloir faire [UNI00e9]voluer le\n   Gladius de 2 niveaux."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tu peux aussi acheter ou r[UNI00e9]cup[UNI00e9]rer des\n   armes. Il te suffit de te procurer une\n   arme puissante et Milane t'aidera."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

--- Helper function.
local function helper_26e50(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(67) or argc
	argc_2 = event.GetItemNum(69) or argc_2
	if argc <= 0 and argc_2 <= 0 then
		event.MesMake_2(
			0,
			"Qu'est-ce que c'est que [UNI00e7]a ?\nAlors c'[UNI00e9]tait juste du pipeau ?<page>Sors d'ici !\nTu g[UNI00ea]nes [UNI00e0] tra[UNI00ee]ner dans le coin."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Ouaah, c'est une [UNI00e9]p[UNI00e9]e\nplut[UNI00f4]t impressionnante.<page>Je m'excuse, mais\nje devais te tester."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Car tu sais, se battre avec un\namateur, c'est dangereux pour moi\naussi.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Mais j'ai l'impression que je n'ai\npas [UNI00e0] m'inqui[UNI00e9]ter de [UNI00e7]a avec toi.<page>Tr[UNI00e8]s bien, allons\ncombattre ensemble."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_2754c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"L'[UNI00e9]clat d'une [UNI00e9]p[UNI00e9]e forg[UNI00e9]e\npar un ma[UNI00ee]tre est magnifique.<page>[UNI00c0] couper le souffle."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Je n'arrive pas [UNI00e0] comprendre\ncomment on peut [UNI00ea]tre heureux [UNI00e0]\npolir des cailloux."
		)
	else
		event.MesMake_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_27954(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_261b4(arg0, arg1)
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
		helper_261b4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2643c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_265ec(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_26e50(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2754c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_27ce0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Tu es une amie de Max ?<page>Alors, tiens-toi bien.")
	else
		event.MesMake_2(
			0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_27f58(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Tu es dou[UNI00e9] avec les machines, mais\nil serait temps d'apprendre le b.a.\n-ba de l'exploitation mini[UNI00e8]re..."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_280e8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_dd7074b2(24, 1)
		end
		if at <= 6 then
			helper_76581321(1)
		end
		if at <= 7 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "D'apr[UNI00e8]s C[UNI00e9]dric,\ntu es toujours tr[UNI00e8]s\nactif en ce moment.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Tu es dou[UNI00e9] dans plein de domaines,<page>mais d'un autre c[UNI00f4]t[UNI00e9], tu ne\ntermines jamais rien."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Alors quand tu demandes de\nl'aide, j'ai un peu de mal [UNI00e0]\nte prendre au s[UNI00e9]rieux."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Je sais ! Essaie de transformer ce\npistolet trompette en pistolet cloche !<page>Tu crois que tu peux y arriver ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_dd7074b2(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_76581321(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Pour que G[UNI00e9]rald t'aide,\n   tu vas devoir lui rapporter\n   un pistolet cloche.<page>[(!)]Tu peux d[UNI00e9]velopper l'arme qu'il t'a\n   donn[UNI00e9]e, en acheter une ou en rapporter\n   une trouv[UNI00e9]e dans les d[UNI00e9]dales."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

--- Helper function.
local function helper_2889c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"Qu'est-ce qui se passe ?\nTu baisses encore les bras ?<page>Tu me d[UNI00e9][UNI00e7]ois.\nC'est [UNI00e0] [UNI00e7]a que [UNI00e7]a m[UNI00e8]ne de bricoler\ndes machines [UNI00e0] longueur de journ[UNI00e9]e ?"
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Oh ! On dirait que tu commences\n[UNI00e0] t'y conna[UNI00ee]tre en armes aussi !<page>Il suffit de voir comment tu les\ntiens pour s'en rendre compte..."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"OK, je vais t'aider.\nMais je ne le fais pas pour toi.<page>Si cette ville est en danger,\nje ne peux pas rester assis\nici [UNI00e0] me tourner les pouces."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_28e8c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Les armes ne sont pas des jouets.<page>Sois prudent quand tu t'en sers,\nou tu pourrais te blesser."
		)
	else
		event.MesMake_2(
			0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_29134(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_27ce0(arg0, arg1)
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
		helper_27ce0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_27f58(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_280e8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2889c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_28e8c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_294c0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fcd1ed12(arg0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Ronchonnements...")
	helper_fcd1ed12(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"...1212,<page>Mais non, c'[UNI00e9]tait 2211, c'est certain.<page>Ou peut-[UNI00ea]tre bien 1010."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ronchonnements...")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]S'il ne te remarque m[UNI00ea]me pas quand \n   tu dis \"Bonjour\", c'est qu'il \n   doit avoir de gros, gros probl[UNI00e8]mes.<page>[(!)]Pourquoi ne pas r[UNI00e9]essayer plus tard\n   Tu pourras peut-[UNI00ea]tre l'aider, ou\n   l'[UNI00e9]couter se plaindre, au pire !"
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_29980(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_fe5a2f04(arg0, arg1)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_fe5a2f04(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ronchonnements...")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Comment [UNI00e7]a, qu'est-ce que\nj'ai [UNI00e0] marmonner ?<page>J'essaie de me souvenir de la\ncombinaison du coffre."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Comment [UNI00e7]a,\nquel coffre ? Celui<page>qui est cach[UNI00e9] derri[UNI00e8]re le tableau\ndans mon bureau, bien s[UNI00fb]r..."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_fe5a2f04(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"Ah, tu m'as fait peur !<page>Oh, fl[UNI00fb]te !<page>Je viens de l[UNI00e2]cher\nmon plus gros secret !<page>Bon, tant pis !<page>Tu peux peut-[UNI00ea]tre m'aider\n[UNI00e0] l'ouvrir maintenant."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"J'ai un gros probl[UNI00e8]me, je\nn'arrive plus [UNI00e0] me souvenir\nde la combinaison du coffre."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Il y a 4 chiffres alors j'ai choisi\nla date de naissance de Claire\npour [UNI00ea]tre s[UNI00fb]r de pas l'oublier."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Comment ai-je pu oublier [UNI00e7]a...<page>Quel mauvais p[UNI00e8]re je fais !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Le Maire para[UNI00ee]t tr[UNI00e8]s ennuy[UNI00e9].\n   [UNI00c9]coute ses propos sur l'anniversaire\n   de Claire pour trouver la combinaison."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

--- Helper function.
local function helper_2a3d0(arg0: s32, arg1: s32)
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
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				var2 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_64e99d3d(30)
			end
			if at <= 11 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_64e99d3d(15)
			end
			return
		end
		if at <= 14 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_e1f412dd(0)
		end
		if at <= 16 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_64e99d3d(15)
		end
		if at <= 18 then
			helper_64e99d3d(15)
		end
		if at <= 19 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 20 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 21 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(0, "Une fois, je lui ai offert une\nbroche avec son signe astrologique.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"C'est Holly qui l'avait achet[UNI00e9]e\npour moi, mais je crois me souvenir\nque c'[UNI00e9]tait un animal [UNI00e0] 4 pattes..."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"Quel genre de cadeaux\nd'anniversaire je lui offre ?<page>Humm... beaucoup de manteaux et\nd'[UNI00e9]charpes il me semble.<page>Je ne sais jamais quoi lui offrir.\nEt tous les ans, c'est pire."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"Ah [UNI00e7]a ! Son anniversaire, c'est\ntoujours p[UNI00e9]nible. C'est un jour de\nramassage des d[UNI00e9]chets combustibles<page>et non-combustibles. C'est moi qui\nsort les poubelles chez nous."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"Les d[UNI00e9]chets non-combustibles sont\nramass[UNI00e9]s les jours divisibles par 7<page>et les d[UNI00e9]chets combustibles, les\njours divisibles par 3."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "Tu n'oublierais quand m[UNI00ea]me pas [UNI00e7]a,\nhein ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"J'ai compris ! Myst[UNI00e8]re r[UNI00e9]solu !\nLa combinaison est...<page>Je ne sais pas... Attends un peu."
		)
		var2 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
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
	event.SetMenuEtc(0, "Saisis le num[UNI00e9]ro du code secret.", "2112", 0)
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
	helper_64e99d3d(15)
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
	helper_64e99d3d(30)
	if vm.skipping() then
		return skip(11)
	end
	if var3 == 0 then
		event.SetMotion(arg0, "会話")
		event.MesMake_2(
			0,
			"Humm, [UNI00e7]a s'ouvre pas. Oh la la...<page>Il y a des documents vraiment\nimportants l[UNI00e0]-dedans..."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		event.SetMotion(arg0, "立ち")
		event.SetFadeOut(15)
		helper_64e99d3d(15)
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
	event.MesMake_2(0, "Euh... Mmm...\n2,<page>1,<page>1,<page>2...")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "Ouaaaaouh !<page>Formidable,\n[UNI00e7]a a march[UNI00e9] !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0, arg0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, var14, var15, var16, 30)
	helper_e1f412dd(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "Formidable ! Je peux enfin\nsortir mes documents importants !<page>Oh, merci !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetFadeOut(15)
	helper_64e99d3d(15)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaRot(0, var17, var18, var19)
	event.SetCharaPos(arg0, var8, var9, var10)
	event.SetCharaRot(arg0, var11, var12, var13)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetFadeIn(15)
	helper_64e99d3d(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"Quels documents ? Des dossiers<page>qui aideront Morton, mon adjoint,\n[UNI00e0] me remplacer en mon absence.<page>[UNI00c7]a m'inqui[UNI00e8]te un peu,\nmais je suis s[UNI00fb]r que [UNI00e7]a ira."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"Je suis pr[UNI00ea]t [UNI00e0] quitter la ville.<page>C[UNI00e9]dric m'a tout expliqu[UNI00e9].<page>Allez, on y va."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_2c430(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Pense [UNI00e0] bien trier tes d[UNI00e9]chets et\n[UNI00e0] les jeter les bons jours, OK ?"
		)
	else
		event.MesMake_2(
			0,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2c6b8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_294c0(arg0, arg1)
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
		helper_294c0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_29980(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2a3d0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2c430(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2d374(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var3 = event.GetChapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.MesMake_2(0, "Je prie pour que le monde vive\nenfin en paix.")
	else
		event.MesMake_2(0, "Quand tu travailles dur pour une\nbonne cause, tu dois savoir\nr[UNI00e9]fl[UNI00e9]chir.")
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2d5e0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Vraiment ? Tu as besoin de mon<page>aide ? Alors laisse-moi t'exposer\nun petit probl[UNI00e8]me."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Les bougies de cette [UNI00e9]glise sont\ncontr[UNI00f4]l[UNI00e9]es par un petit m[UNI00e9]canisme.<page>Il [UNI00e9]teint les bougies allum[UNI00e9]es,\net allume les bougies [UNI00e9]teintes.<page>Si l'une d'entre elles change, les\nbougies adjacentes changent aussi."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] [UNI00e9]teindre toutes\nles bougies, je viendrai.<page>J'en serais tr[UNI00e8]s content ! Sinon,\nje ne viendrai pas."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Une petite [UNI00e9]nigme. Essaie une ou\n   deux fois, et sers-toi de ce que ces\n   petites exp[UNI00e9]riences t'auront appris."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Si tu rentres [UNI00e0] nouveau dans l'[UNI00e9]glise,\n   les bougies seront r[UNI00e9]initialis[UNI00e9]es.\n   Alors n'aie pas peur de te tromper.\n   La r[UNI00e9]ponse peut [UNI00ea]tre tr[UNI00e8]s simple."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

--- Helper function.
local function helper_2c99c()
	local var0: { s32 } = table.create(14, 0)
	local var14: s32 = 0
	local var15: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var14 = 0
		var15 = 0
		var14 = var14 + 1
		var15 = var15 + 1
		return var14
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m7")
	event.EohSyncObj(1, "p08_i01h07", "i01h07_13-m21")
	event.EohSyncObj(2, "p08_i01h07", "i01h07_13-m8")
	event.EohSyncObj(3, "p08_i01h07", "i01h07_13-m20")
	event.EohSyncObj(4, "p08_i01h07", "i01h07_13-m9")
	event.EohSyncObj(5, "p08_i01h07", "i01h07_13-m19")
	event.EohSyncObj(6, "p08_i01h07", "i01h07_13-m10")
	event.EohSyncObj(7, "p08_i01h07", "i01h07_13-m18")
	event.EohSyncObj(8, "p08_i01h07", "i01h07_13-m11")
	event.EohSyncObj(9, "p08_i01h07", "i01h07_13-m17")
	event.EohSyncObj(10, "p08_i01h07", "i01h07_13-m12")
	event.EohSyncObj(11, "p08_i01h07", "i01h07_13-m16")
	event.EohSyncObj(12, "p08_i01h07", "i01h07_13-m14")
	event.EohSyncObj(13, "p08_i01h07", "i01h07_13-m15")
	var0[1] = event.EohGetShow(0) or var0[1]
	var0[2] = event.EohGetShow(1) or var0[2]
	var0[3] = event.EohGetShow(2) or var0[3]
	var0[4] = event.EohGetShow(3) or var0[4]
	var0[5] = event.EohGetShow(4) or var0[5]
	var0[6] = event.EohGetShow(5) or var0[6]
	var0[7] = event.EohGetShow(6) or var0[7]
	var0[8] = event.EohGetShow(7) or var0[8]
	var0[9] = event.EohGetShow(8) or var0[9]
	var0[10] = event.EohGetShow(9) or var0[10]
	var0[11] = event.EohGetShow(10) or var0[11]
	var0[12] = event.EohGetShow(11) or var0[12]
	var0[13] = event.EohGetShow(12) or var0[13]
	var0[14] = event.EohGetShow(13) or var0[14]
	var14 = 0
	var15 = 0
	while var15 < 14 do
		if var0[var15 + 1] ~= 0 then
			var14 = vm.i32(var14 + 1)
		end
		var15 = var15 + 1
	end
	return var14
end

--- Helper function.
local function helper_2ddfc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_2c99c()
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_2c99c()
	if 0 < var2 then
		event.MesMake_2(0, "On dirait que tu n'es pas tout\n[UNI00e0] fait assez bon pour l'instant.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Je suis s[UNI00fb]r que tu vas progresser,\nmais en attendant, j'ai bien peur\nde ne pouvoir coop[UNI00e9]rer avec toi."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Tu t'es bien d[UNI00e9]brouill[UNI00e9].\nMagnifique.<page>Je suis s[UNI00fb]r que tu sauras\nr[UNI00e9]pondre [UNI00e0] mes attentes.<page>Je t'ai fait une promesse...\nJe viens avec toi."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2e36c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2d374(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2e404(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2d374(arg0, arg1, 0)
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
		helper_2d374(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2d5e0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2ddfc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2e36c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2e6f4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Pourquoi la lune me manque-t-elle<page>tant ? Je me demande si je ne\nviendrais pas de l[UNI00e0]-bas des fois..."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2e884(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Je veux bien venir avec toi,\nmais y aura-t-il une lune l[UNI00e0]-bas ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "C'est vrai ? Dois-je te croire sur\nparole. Les hommes mentent parfois.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "En fait, j'ai chang[UNI00e9] d'avis. Je\nvais attendre que la lune se\nmontre ici.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]C'est peut-[UNI00ea]tre li[UNI00e9] [UNI00e0] son histoire\n   pass[UNI00e9]e... Quoi qu'il en soit, Rufio\n   ne fait pas confiance aux hommes."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Il faut que Rufio te croie.\n   Si tu lui donnes une photo\n   de la lune, [UNI00e7]a marchera peut-[UNI00ea]tre."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 14, 1)
end

--- Helper function.
local function helper_2ef20(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"Je te croyais diff[UNI00e9]rent, mais non,\nles hommes sont les hommes.<page>Peu importe, je suis habitu[UNI00e9] [UNI00e0] ce\nqu'on me raconte des mensonges."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Il y a une lune sur cette photo !<page>Je pourrai la voir quand je veux !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Venir avec toi ?<page>Mais oui, bien s[UNI00fb]r.\nJe n'ai nulle part ailleurs o[UNI00f9]\naller."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2f460(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Tu m'as donn[UNI00e9] cette photo de la\nlune. Tu es g[UNI00e9]n[UNI00e9]reux.")
	else
		event.MesMake_2(
			0,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2f6e8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2e6f4(arg0, arg1)
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
		helper_2e6f4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2e884(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2ef20(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2f460(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2f9cc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mon hobby [UNI00e0] moi, c'est la p[UNI00ea]che.<page>Je r[UNI00ea]ve de p[UNI00ea]cher un Mardan Garayan.<page>Il faut p[UNI00ea]cher gros pour m'[UNI00e9]pater."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2fb8c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Tu veux que je te rende service ?<page>Alors, [UNI00e9]coute-moi.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pour cela, tu devras gagner mon<page>respect. Et je ne respecte que\nceux qui ont d[UNI00e9]j[UNI00e0] attrap[UNI00e9] de\nplus gros poissons que moi."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Le plus gros poisson que j'aie\nattrap[UNI00e9] [UNI00e9]tait un Nonky de 60 cm.<page>[UNI00c7]a t'impressionne ?\nSi le d[UNI00e9]fi te tente, je t'offre de\nte mesurer [UNI00e0] moi quand tu veux !"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Il semble que le seul moyen de le\n   faire venir soit de p[UNI00ea]cher un Nonky\n   de plus de 60 cm. Tu peux y arriver !"
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]Enfin, essaie d'aller p[UNI00ea]cher\n   dans le lac de Palm Brinks.")
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_302a8(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"H[UNI00e9], je parie que tu n'as jamais\nattrap[UNI00e9] un Nonky ?<page>Ah ah. Tu dois [UNI00ea]tre vraiment\nnul en p[UNI00ea]che !"
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
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
		event.MesMake_2(0, "Ah ah ! Tu n'as attrap[UNI00e9] qu'un tout\npetit poisson de [数値１] cm !")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Tu ne m[UNI00e9]rites pas mon aide !<page>Tu ferais mieux de recommencer.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "...Oh, je t'avais sous-estim[UNI00e9].")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Un homme, [UNI00e7]a n'a qu'une parole.<page>Je vais [UNI00e9]couter ce que t'as [UNI00e0] dire."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Parle autant que tu veux !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_30b40(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Um, [UNI00e7]a peut attendre bien s[UNI00fb]r,\nmais un jour, j'aimerais que tu\nm'expliques ta technique de p[UNI00ea]che."
		)
	else
		event.MesMake_2(
			0,
			"J'ai h[UNI00e2]te de d[UNI00e9]couvrir les nouveaux\nhauts-lieux de la p[UNI00ea]che qu'a [UNI00e0]\noffrir le monde. [UNI00c7]a sera trop top."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_30e08(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2f9cc(arg0, arg1)
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
		helper_2f9cc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2fb8c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_302a8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_30b40(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_310ec(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3125c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Personnellement, je m'y connais\nen poissons.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"J'ai entendu dire que des hommes\norganisaient un concours o[UNI00f9]\ns'affrontaient leurs poissons.<page>Si tu en as un, pourquoi ne pas\nessayer de finir premier ?<page>Si tu [UNI00e9]choues, je saurais que tu \nne m[UNI00e9]rites pas mon aide."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Il doit s'agir de la Course de poissons.\n   Pourquoi ne pas tenter la cat[UNI00e9]gorie\n   D[UNI00e9]butants ? Elle t'aidera peut-[UNI00ea]tre."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

--- Helper function.
local function helper_31888(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "Tel poisson, tel ma[UNI00ee]tre, para[UNI00ee]t-il.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Pas question que je parle au \npropri[UNI00e9]taire d'un poisson si nul.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"J'ai bien regard[UNI00e9], tu sais.\nC'[UNI00e9]tait une course superbe.<page>Je ne pense pas que j'aurais pu\ndresser un aussi bon poisson.<page>Tu peux m'emmener avec toi et\nm'apprendre tout ce que tu sais ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_31dbc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "J'esp[UNI00e8]re un jour pouvoir moi\naussi occuper la plus haute\nmarche du podium.")
	else
		event.MesMake_2(
			0,
			"J'aimerais tant que Fabio\ns'int[UNI00e9]resse un peu [UNI00e0] autre chose\nque la p[UNI00ea]che."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_32034(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_310ec(arg0, arg1)
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
		helper_310ec(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_3125c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_31888(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_31dbc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_32378(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_350ad86a(arg0, 0, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Je ne suis pas tr[UNI00e8]s en forme.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Le Dr Dell est venu me voir\nmais selon lui tout va bien.<page>Je me demande ce que j'ai ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_32638(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_68685f02(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_68685f02(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_68685f02(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Je ne suis pas tr[UNI00e8]s en forme.<page>Je ne peux pas partir en voyage.<page>Le Dr Dell est venu me voir, mais\nil m'a dit que tout allait bien."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pourtant, quand je suis debout, j'ai\nl'impression que je vais tomber.<page>C'est dur [UNI00e0] expliquer. C'est un peu\ncomme si le monde avait [UNI00e9]t[UNI00e9] d[UNI00e9]form[UNI00e9]."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"Mmm... Si le Dr Dell ne sait pas ce\nqui ne va pas, je ne vois pas bien\nce que je peux faire moi-m[UNI00ea]me..."
		)
		helper_68685f02(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00c7]a me rappelle quelque chose.")
	helper_68685f02(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00c0] l'[UNI00e9]poque o[UNI00f9] je suis n[UNI00e9], le\nmonde [UNI00e9]tait dans un [UNI00e9]tat d[UNI00e9]plorable,\navec un nombre incalculable de\ndistorsions temporelles."
	)
	helper_68685f02(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Cela avait un impact sur les gens\n[UNI00e0] la sant[UNI00e9] fragile.<page>Les plus l[UNI00e9]gers avaient le tournis\net les plus lourds ne tenaient\nplus debout."
	)
	helper_68685f02(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Tu es peut-[UNI00ea]tre particuli[UNI00e8]rement\nsensible [UNI00e0] ce genre de chose.<page>M[UNI00ea]me les rares distorsions qu'on\na ici suffisent [UNI00e0] t'affecter."
	)
	helper_68685f02(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Si on pouvait [UNI00e9]liminer les plus\nproches d'entre elles, tu te\nsentirais peut-[UNI00ea]tre mieux."
	)
	helper_68685f02(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Comment [UNI00e9]liminer une distorsion...\n   Le Spheda ! Termine environ 10 niveaux\n   et Mena ira peut-[UNI00ea]tre mieux."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

--- Helper function.
local function helper_33324(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "Je me sens toujours aussi mal.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"J'ai peut-[UNI00ea]tre quelque\nchose de tr[UNI00e8]s grave ?<page>Peut-[UNI00ea]tre que m[UNI00ea]me le Dr Dell ne\npeut plus rien faire pour moi..."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Bonjour !<page>Comment je vais ? Super bien !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Je me sens tellement mieux !<page>Le monde semble [UNI00e0] nouveau normal.")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Ah oui. Tu voulais un service.<page>Je ferai tout pour t'aider.<page>Tu l'as fait pour moi, alors je\ndois aussi te venir en aide."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_33ab4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Tu m'as aid[UNI00e9]e, je le ferai donc\naussi, mais piti[UNI00e9], ne m'emm[UNI00e8]ne pas\ndans un endroit plein d'insectes !"
		)
	else
		event.MesMake_2(
			0,
			"Si la Voie ferr[UNI00e9]e Noirpierre\ns'[UNI00e9]tend au monde entier, j'irai\npeut-[UNI00ea]tre aussi voyager."
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_33d5c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_32378(arg0, arg1)
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
		helper_32378(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_32638(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_33324(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_33ab4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_34028(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_350ad86a(arg0, 0, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Ooh, Max ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	else
		event.MesMake_2(0, "Ooh, Monica ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	end
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "C'est g[UNI00e9]nial ! Pourquoi ne\nm'emm[UNI00e8]nerais-tu pas avec toi ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_343f0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_64e99d3d(30)
		end
		if at <= 13 then
			helper_64e99d3d(30)
		end
		if at <= 14 then
			helper_64e99d3d(60)
		end
		if at <= 15 then
			helper_93837a70(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Ooh, Max ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	else
		event.MesMake_2(0, "Ooh, Monica ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	end
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "C'est g[UNI00e9]nial ! Pourquoi ne\nm'emm[UNI00e8]nerais-tu pas avec toi ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Je parie que tu crois que je serai\ninutile parce que je suis une fille<page>alors qu'en fait, je porte chance\naux gens que je c[UNI00f4]toie."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Il ne pleut jamais quand je sors,\net je n'ai jamais vu un billet de\nloterie perdant.<page>Qu'est-ce que tu en penses ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "D'accord.\nNon merci.")
	var3 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "Pourquoi ? C'est injuste !\nT'es horrible !")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "T'es naze !<page>Imb[UNI00e9]cile !<page>Stupide !")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Tu m'emm[UNI00e8]neras avec toi ?<page>Je croyais pas que tu le ferais !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Mais pourquoi je suis la seule qui\ndoive te le demander, alors que tu\nl'as demand[UNI00e9] [UNI00e0] tous les autres ?<page>Il suffisait de le demander pour\nque je vienne."
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Je sais, si tu arrives [UNI00e0] me\ntrouver, je t'aiderai. D'accord ?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Bref, on va jouer [UNI00e0] cache-cache !<page>Allez, on y va !")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_64e99d3d(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_64e99d3d(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_64e99d3d(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Bien... on dirait qu'il va falloir\n   retrouver Corinne. Elle se cache\n   s[UNI00fb]rement quelque part [UNI00e0] Palm Brinks."
	)
	helper_93837a70(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

--- Helper function.
local function helper_35570(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_64e99d3d(30)
			end
			return
		end
		if at <= 4 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "Oh ! Tu m'as trouv[UNI00e9]e !<page>Mais y arriveras-tu encore ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_64e99d3d(30)
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
		"Oh ! Tu m'as trouv[UNI00e9]e...<page>Je commence [UNI00e0] en avoir assez.<page>Se cacher, en fait, c'est\nplut[UNI00f4]t ennuyeux.<page>Bon ! Allez, on part [UNI00e0]\nl'aventure !"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_35af8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Le jeu de cache-cache, c'est\npour les petits.")
	else
		event.MesMake_2(
			0,
			"Ne dis pas le contraire. Je sais\nque tu as fait plein de trucs hyper\ncool. Viens m'en parler un jour !"
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_35d50(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_34028(arg0, arg1)
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
		helper_34028(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_343f0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_35570(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_35af8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_36034(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"...<page>Ah ! Bonjour !\nJe suis un peu dure d'oreille.<page>Je ne comprends pas ce qu'on me\ndit, sauf quand on parle lentement."
	)
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_361c4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_68685f02(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_11e90()
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Qu'est-ce que tu as dit ?<page>Peux-tu parler plus lentement?")
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(0, 'Saisis : "Partons ensemble."', "Partons ensemble.", 0)
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
		event.MesMake_2(0, "Que veux-tu dire par l[UNI00e0] ?\nJe n'y comprends rien...")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Une aventure ?\n[UNI00c7]a me tenterait bien...<page>Mais [UNI00e0] quoi pourrait servir\nune vieille femme comme moi ?"
	)
	helper_68685f02(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e90()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_368a8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_361c4(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_36934(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "[UNI00c0] quoi pourrait servir une\ngrand-m[UNI00e8]re comme moi ?")
	else
		event.MesMake_2(
			0,
			'Quand la voie ferr[UNI00e9]e Noirpierre\nsera termin[UNI00e9]e, j\'adorerais aller \naux "Confins de la Terre".'
		)
	end
	helper_40a937cf(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_36b9c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_36034(arg0, arg1)
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
		helper_36034(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_361c4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_368a8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_36934(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_23f28(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_68685f02(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_350ad86a(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "Oh, tu aides\nPolly ?<page>Super.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Ce que je vais faire\navec ces 20 pains ?<page>Eh bien, j'ai organis[UNI00e9] une soir[UNI00e9]e\nfondue savoyarde pour ce soir."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"Pour l'\"inventeur\" que tu es,\nc'est une combinaison culinaire<page>de fromage, de pain et de vin !"
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"C'est super bon. On en mange tant\nqu'il faut des tonnes de pain.<page>Mais je ne voulais pas\nqu'il soit livr[UNI00e9] ici."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"D[UNI00e9]sol[UNI00e9] Max, mais tu pourrais\nl'emporter chez moi ?<page>Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles."
		)
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles.")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "Annul[UNI00e9]e ?!\nComme c'est dommage !")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(0, "Dans ce cas, je n'ai plus besoin\nde pain. Tu pourrais le rapporter\n[UNI00e0] Polly ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "D[UNI00e9]sol[UNI00e9], mais tu peux rapporter\nle pain [UNI00e0] Polly pour moi ?")
		helper_68685f02(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_36e80(arg0: s32, arg1: s32)
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
				helper_19018(arg0, arg1)
			end
			if at <= 2 then
				var7 = helper_52147ee2(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_64e99d3d(30)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				var8 = helper_52147ee2(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 11 then
			if at <= 9 then
				helper_64e99d3d(30)
			end
			return
		end
		if at <= 17 then
			if at <= 12 then
				helper_1c5e8(arg0, arg1)
			end
			if at <= 13 then
				helper_1e190(arg0, arg1)
			end
			if at <= 14 then
				helper_20dd8(arg0, arg1)
			end
			if at <= 15 then
				helper_236b0(arg0, arg1)
			end
			if at <= 16 then
				var11 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 18 then
			return
		end
		if at <= 22 then
			if at <= 19 then
				helper_25e28(arg0, arg1)
			end
			if at <= 20 then
				helper_16ab0(arg0, arg1)
			end
			if at <= 21 then
				var14 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 23 then
			return
		end
		if at <= 28 then
			if at <= 24 then
				helper_27954(arg0, arg1)
			end
			if at <= 25 then
				helper_29134(arg0, arg1)
			end
			if at <= 26 then
				helper_2c6b8(arg0, arg1)
			end
			if at <= 27 then
				var17 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 29 then
			return
		end
		if at <= 38 then
			if at <= 30 then
				helper_2e404(arg0, arg1)
			end
			if at <= 31 then
				helper_2f6e8(arg0, arg1)
			end
			if at <= 32 then
				helper_30e08(arg0, arg1)
			end
			if at <= 33 then
				helper_32034(arg0, arg1)
			end
			if at <= 34 then
				helper_33d5c(arg0, arg1)
			end
			if at <= 35 then
				helper_35d50(arg0, arg1)
			end
			if at <= 36 then
				helper_36b9c(arg0, arg1)
			end
			if at <= 37 then
				var20 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 39 then
			return
		end
		if at <= 40 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
		if at <= 41 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_40a937cf(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_40a937cf(arg0, -1, 0, 0)
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
		helper_1445c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_19018(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Je veux faire des achats\nC'est parti pour un scoop")
			var7 = helper_52147ee2(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_113d4(0)
				if vm.skipping() then
					return skip(4)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_64e99d3d(30)
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
				helper_e5c8()
				if vm.skipping() then
					return skip(7)
				end
			end
		else
			event.MesMake_2(0, "En route pour l'aventure ?\nC'est parti pour un scoop")
			var8 = helper_52147ee2(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_113d4(0)
				if vm.skipping() then
					return skip(9)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_64e99d3d(30)
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
				helper_1ac30(arg0, arg1)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	if var3 == 7 then
		helper_1c5e8(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 8 then
		helper_1e190(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 10 then
		helper_20dd8(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 11 then
		helper_236b0(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var11 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(17)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_25e28(arg0, arg1)
				if vm.skipping() then
					return skip(18)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_e5c8()
			if vm.skipping() then
				return skip(19)
			end
		else
			helper_25e28(arg0, arg1)
			if vm.skipping() then
				return skip(20)
			end
		end
	end
	if var3 == 14 then
		helper_16ab0(arg0, arg1)
		if vm.skipping() then
			return skip(21)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var14 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(22)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_27954(arg0, arg1)
				if vm.skipping() then
					return skip(23)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_e5c8()
			if vm.skipping() then
				return skip(24)
			end
		else
			helper_27954(arg0, arg1)
			if vm.skipping() then
				return skip(25)
			end
		end
	end
	if var3 == 16 then
		helper_29134(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 17 then
		helper_2c6b8(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var17 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(28)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_2e404(arg0, arg1)
				if vm.skipping() then
					return skip(29)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_e5c8()
			if vm.skipping() then
				return skip(30)
			end
		else
			helper_2e404(arg0, arg1)
			if vm.skipping() then
				return skip(31)
			end
		end
	end
	if var3 == 19 then
		helper_2f6e8(arg0, arg1)
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 20 then
		helper_30e08(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 21 then
		helper_32034(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 23 then
		helper_33d5c(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 24 then
		helper_35d50(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 25 then
		helper_36b9c(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Je veux faire des achats\nBonjour")
			var20 = helper_e04ca1ac(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(38)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_23f28(arg0, arg1)
				if vm.skipping() then
					return skip(39)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_e5c8()
		if vm.skipping() then
			return skip(40)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"J'ai du mal depuis quelque temps [UNI00e0]\nvoir les toutes petites pi[UNI00e8]ces.<page>Je dois commencer [UNI00e0] me\nfaire un peu vieux..."
			)
		else
			event.MesMake_2(
				0,
				"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
			)
		end
		helper_40a937cf(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		else
			event.MesMake_2(
				0,
				"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
			)
		end
		helper_40a937cf(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Tu sais, j'ai plein de bestioles\ndans les plumes en ce moment,\net [UNI00e7]a me gratte terriblement."
			)
		else
			event.MesMake_2(
				0,
				"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
			)
		end
		helper_40a937cf(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
			)
		else
			event.MesMake_2(0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
		end
		helper_40a937cf(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"[UNI00c0] part le fait que j'ai d[UNI00e9]but[UNI00e9]\nma vie sur une toile, je ne\nsuis pas diff[UNI00e9]rente des autres."
			)
		else
			event.MesMake_2(0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
		end
		helper_40a937cf(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_f4d0()
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
				helper_e5c8()
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
		helper_e5c8()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "H[UNI00e9] ! Il est interdit d'avancer\nau-del[UNI00e0] de la limite.")
		helper_40a937cf(var1, -1, 0, 0)
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
					"Regarde-moi [UNI00e7]a. Difficile de croire\nqu'autrefois cet engin avan[UNI00e7]ait [UNI00e0]\ntoute vitesse, hein ?<page>Ah mais si, si... Il y a longtemps.<page>Je r[UNI00ea]ve de faire un autre\nvoyage dans ce truc. C'est pour\n[UNI00e7]a que je le bichonne. Comme [UNI00e7]a,<page>si un jour on me "
				)
			else
				event.MesMake_2(
					0,
					"Il faut faire de l'exercice souvent\npour [UNI00e9]viter les courbatures. Pour\nles machines c'est pareil..."
				)
			end
			helper_40a937cf(var1, -1, 0, 0)
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
					"H[UNI00e9], salut Max !\nIl y a une [UNI00e9]ternit[UNI00e9] que la\nvoie ferr[UNI00e9]e ne fonctionne plus.<page>Mais je continue [UNI00e0] surveiller\nla gare jour apr[UNI00e8]s jour."
				)
			else
				event.MesMake_2(
					0,
					"Le Maire s'est enfin boug[UNI00e9] un peu\net les trains ont repris du service\nmais pas encore pour le public.<page>Ah [UNI00e7]a, je meurs d'envie d'y faire\nmonter les gens de la ville..."
				)
			end
			helper_40a937cf(var1, -1, 0, 0)
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
					"Salut, Max. Tu savais que mon p[UNI00e8]re\nest le chef de gare ? On surveille\nla gare tous les deux.<page>Jusqu'au jour o[UNI00f9] les trains\nseront remis en service..."
				)
			else
				event.MesMake_2(
					0,
					"Le train marche ! Mais il va\nfalloir un moment avant que la\ngare ne fonctionne [UNI00e0] nouveau normalement..."
				)
			end
			helper_40a937cf(var1, -1, 0, 0)
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
					"J'admire secr[UNI00e8]tement Monica depuis\ntoujours, mais je ne l'ai pas vue\ndans le coin derni[UNI00e8]rement.<page>C'est pour [UNI00e7]a que je n'arrive pas\n[UNI00e0] me concentrer sur mon travail."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(
						0,
						"H[UNI00e9], Max !\nMonica est de retour, on dirait.\nTout le monde va [UNI00ea]tre enchant[UNI00e9] !"
					)
				else
					event.MesMake_2(0, "Monica ! Comment [UNI00e7]a va ?\nTu m'as vraiment manqu[UNI00e9].")
				end
			end
			helper_40a937cf(var1, -1, 0, 0)
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
					"Je commen[UNI00e7]ais tout juste [UNI00e0] pouvoir\ndiscuter normalement avec\nMonica quand elle a disparu.<page>Allez Max,\ndis-moi o[UNI00f9] elle est, s'te pla[UNI00ee]t ?"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica est revenue.\nComment elle a fait ?")
				else
					event.MesMake_2(0, "Monica, tu es revenue !\nComment t'as fait ?")
				end
			end
			helper_40a937cf(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_40a937cf(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_10c18()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f4d0()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_f4d0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_399b8()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10c18()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_36e80(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_10c18()
		if vm.skipping() then
			return skip(2)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_b8d9d9d0

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local var8: s32 = 0
	local old_map_no: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local flag_6: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		helper_8c611fc6(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
		var12 = 1
		var12 = 0
		var12 = 0
		helper_442f0()
		var12 = 0
		var12 = 0
		helper_44554()
	end
	helper_b8d9d9d0()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		flag = event.GetFlag(736) or flag
		flag_2 = event.GetFlag(800) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.SetFadeOut(0)
			helper_406bc()
			if vm.skipping() then
				return skip(1)
			end
			event.SetSavedataEtc(0, 10)
			event.SoundAllStop()
			event.SndInReverb(0)
			event.GotoDrawChapter(8)
			if vm.wait() then
				return skip(2)
			end
			event.SndInReverb(1)
			event.LoadSound(1000)
			var3 = event.GetDefBgmNo(10) or var3
			event.LoadBgm(var3)
			event.PlayBgm(0)
			event.AutoChengeBgmVol(1)
			event.SetCharaPos(0, 1640.0, -48.8, -1700.0)
			event.SetCharaRot(0, 0.0, 0.0, 0.0)
			event.ResetCamera(1, 0.0, 10.0)
			event.SetFadeIn(30)
			return
		end
		var4 = event.GetCnt(4) or var4
		if var4 == 0 then
			event.SetCharaPos(0, 560.0, 4.1, 120.0)
			event.SetCharaRot(0, 0.0, 3.14, 0.0)
		end
		if var4 == 1 then
			event.SetCharaPos(0, 2095.0, 0.0, 2100.0)
			event.SetCharaRot(0, 0.0, 0.0, 0.0)
		end
		if var4 == 2 then
			event.SetCharaPos(0, -4260.0, 350.0, 2810.0)
			event.SetCharaRot(0, 0.0, 2.86, 0.0)
		end
		if var4 == 3 then
			event.SetCharaPos(0, -3770.0, 359.4, -1640.0)
			event.SetCharaRot(0, 0.0, 1.57, 0.0)
		end
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		flag_3 = event.GetFlag(105) or flag_3
		flag_4 = event.GetFlag(109) or flag_4
		flag_5 = event.GetFlag(56) or flag_5
		if flag_3 ~= 0 and flag_4 == 0 and flag_5 == 0 then
			event.GetBgmNo() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
			event.GetMasterVol()
			if var8 ~= 10 then
				event.SetFadeOut(0)
				event.LoadSound(1000)
				var8 = event.GetDefBgmNo(10) or var8
				event.StopBgm(0)
				helper_64e99d3d(4)
				if vm.skipping() then
					return skip(3)
				end
				event.LoadBgm(var8)
				event.PlayBgm(0)
				event.SetFlag(56, 1)
				event.AutoChengeBgmVol(1)
				event.SetFadeIn(30)
			end
		end
		old_map_no = event.GetOldMapNo() or old_map_no
		var11 = event.GetMapType(old_map_no) or var11
		if var11 ~= -1 then
			if var11 == 7 or var11 == 8 then
				helper_8c611fc6(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
				event.ResetCamera(1, 0.0, 10.0)
			else
				var12 = 1
				flag_6 = event.GetFlag(40) or flag_6
				if flag_6 == 1 then
					if old_map_no == 34 then
						var12 = 0
						event.SetCharaPos(0, 1645.1, -41.3, -1812.6)
						event.SetCharaRot(0, 0.0, -0.09, 0.0)
						event.ResetCamera(1)
					end
					if old_map_no == 22 then
						var12 = 0
						helper_442f0()
					end
				end
				get_old_interior_map_no = event.GetOldInteriorMapNo() or get_old_interior_map_no
				if 0 <= get_old_interior_map_no then
					var12 = 0
				elseif old_map_no == 121 then
					var12 = 0
					event.SetCharaPos(0, 1450.0, 0.0, 1420.0)
					event.SetCharaRot(0, 0.0, -1.57, 0.0)
					event.ResetCamera(1, 3.1415927)
				end
				if var12 ~= 0 then
					helper_44554()
				end
			end
		end
	end
	event.SetFlag(40, 0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3d888()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
		return
	end
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(3)
	end
	event.GotoInterior(-1, "i01h01", 100, 1)
	if vm.wait() then
		return skip(4)
	end
end

--- Program 201.
script[201] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
		end
	end
	print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n")
	local t0 = helper_4604c()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
		event.SetFadeOut(0)
		if vm.wait() then
			return skip(2)
		end
		event.MapJump(-1, "s45")
		return
	end
	print("ccccccccccccccccccccccccccc\n")
end

--- Program 204.
script[204] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
		return
	end
	event.MapJump(-1, "i02h01")
	if vm.wait() then
		return skip(3)
	end
end

--- Program 210.
script[210] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 211.
-- Defined empty, so the engine runs this instead of its default.
script[211] = function() end

--- Program 212.
-- Defined empty, so the engine runs this instead of its default.
script[212] = function() end

--- Program 213.
-- Defined empty, so the engine runs this instead of its default.
script[213] = function() end

--- Program 214.
script[214] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 215.
script[215] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 216.
script[216] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 217.
-- Defined empty, so the engine runs this instead of its default.
script[217] = function() end

--- Program 218.
script[218] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 219.
script[219] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 220.
script[220] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 221.
script[221] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 222.
script[222] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_23b80()
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	else
		helper_23b80()
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 223.
script[223] = function()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
	flag = event.GetFlag(304) or flag
	flag_2 = event.GetFlag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.BgmLoadCancel()
	end
end

script[248] = program_248

--- Program 290.
script[290] = function()
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(800) or flag
	if flag == 0 then
		return
	end
	local t0 = helper_447b8()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.DngSetStageId(6)
		event.GotoMenu(3, 6)
		if vm.wait() then
			return skip(2)
		end
		do
			local _, _, out3, _ = event.GetMenuParam_4()
			var3 = out3 or var3
		end
		if var3 == 0 then
			event.SetFadeIn(30)
			return
		else
			if var3 == 37 then
				event.BgmLoadCancel()
			end
			event.GotoDng(6, var3, 1010)
		end
	end
end

--- Program 400.
script[400] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(15) or var0
	event.SetCnt(4, var0)
	helper_39b34()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 401.
script[401] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	var1 = event.GetCnt(7) or var1
	if active_chr_no == 0 and var1 == 1 then
		event.SetCnt(7, 2)
		event.MesMake_2(0, "OK ! Retourne vite voir\nle Sh[UNI00e9]rif Blinkhorn.")
	else
		event.MesMake_2(0, "Si je monte dedans sans permission,\nje me demande si j'aurai des\nprobl[UNI00e8]mes ?")
	end
	helper_93837a70(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesShippo(0, 1)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_44074()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "d01e01", 100)
	end
end

script[530] = program_530

--- Program 531.
script[531] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		print("じゃんぷ------------------\n")
	end
	event.SetFadeOut(0)
	event.SetCameraPos(345.12, 84.74, -31.95)
	event.SetCameraRef(351.66, 70.52, 137.18)
	event.SetCharaPos(0, 350.13, 52.0, 148.02)
	event.SetCharaRot(0, 0.0, -3.12, 0.0)
	print("ぞうにまけた---------------------\n")
	if vm.wait() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 510, 1)
	if vm.wait() then
		return skip(2)
	end
	print("じゃんぷ------------------\n")
end

--- Program 540.
script[540] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3ff60()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelLoadVillager()
	event.BgmLoadCancel()
	event.MapJump(-1, "i03h01a", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 550.
script[550] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40a937cf(var2, -1, 0, 0)
		end
		if at <= 2 then
			helper_64e99d3d(20)
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		return
	end
	event.SetCameraPos(1300.0, 50.0, 763.0)
	event.SetCameraRef(1300.0, 30.0, 968.18)
	event.SetMotion(0, "立ち")
	var1 = event.SearchCharaNo(50) or var1
	var2 = vm.i32(var1 + 1)
	event.SetAi(0, var2)
	event.SetAi(0, var1)
	event.MesMake_2(0, "H[UNI00e9] ! Il est interdit d'avancer\nau-del[UNI00e0] de la limite.")
	helper_40a937cf(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Si tu ne veux pas avoir d'ennuis,\ntu ferais mieux de faire demi-tour.")
	helper_40a937cf(var2, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(20)
	helper_64e99d3d(20)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCharaPos(0, 1302, 0, 951)
	event.SetCharaRot(0, 0, 3.14, 0)
	event.SetAi(1, var2)
	event.SetAi(1, var1)
	event.SetFadeIn(20)
end

--- Program 560.
script[560] = helper_b8d9d9d0

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		return
	end
	helper_399b8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11051.
script[11051] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_530()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11052.
script[11052] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(105, 0)
	event.SetSavedataEtc(0, 3)
	if vm.wait() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 11052, 1)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11053.
script[11053] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(105, 0)
	event.SetSavedataEtc(0, 3)
	if vm.wait() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 11053, 1)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11060.
script[11060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(103, 1)
	event.SetFlag(106, 0)
	event.SetFlag(107, 0)
	event.SetSavedataEtc(0, 3)
	if vm.wait() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 11060, 1)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11091.
script[11091] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3ff60()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelLoadVillager()
	if vm.wait() then
		return skip(2)
	end
	event.MapJump(-1, "i03h01a", 500)
	if vm.wait() then
		return skip(3)
	end
end

--- Program 18000.
script[18000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_406bc()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(0, 10)
	event.SoundAllStop()
	event.SndInReverb(0)
	event.GotoDrawChapter(8)
	if vm.wait() then
		return skip(2)
	end
	event.SndInReverb(1)
	event.LoadBgm(0)
	event.LoadSound(1000)
	event.PlayBgm(0)
	event.SetCharaPos(0, 1640.0, -48.8, -1700.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

return script
