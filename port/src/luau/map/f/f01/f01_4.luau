--!strict
-- map/f/f01/f01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_145322be = require("@lib/event/helper_145322be")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_342a37b0 = require("@lib/event/helper_342a37b0")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_4ffd117f = require("@lib/event/helper_4ffd117f")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_59a16271 = require("@lib/event/helper_59a16271")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_66ac1f76 = require("@lib/event/helper_66ac1f76")
local helper_81875e60 = require("@lib/event/helper_81875e60")
local helper_81af0537 = require("@lib/event/helper_81af0537")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_927b384d = require("@lib/event/helper_927b384d")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_b84429a4 = require("@lib/event/helper_b84429a4")
local helper_bbae31fd = require("@lib/event/helper_bbae31fd")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c5ea1698 = require("@lib/event/helper_c5ea1698")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_cfca3481 = require("@lib/event/helper_cfca3481")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_e538a72d = require("@lib/event/helper_e538a72d")
local helper_e62603eb = require("@lib/event/helper_e62603eb")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")
local helper_ee09935e = require("@lib/event/helper_ee09935e")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0
local global4: s32 = 0
local global5: s32 = 0
local global6: s32 = 0
local global7: s32 = 0
local global8: any = 0
local global9: any = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local var0: s32 = 0
	local var2: s32 = 0
	event.FuncPointShow("", "e277", 0)
	var0 = 0
	var2 = event.GetAnalyze(104) or var2
	if var2 ~= 0 then
		var0 = 1
	end
	var2 = event.GetAnalyze(105) or var2
	if var2 ~= 0 then
		var0 = 1
	end
	var2 = event.GetAnalyze(106) or var2
	if var0 ~= 0 then
		event.EohSyncObj_2(1, "p11_f0101")
		event.EohSetShow(1, 0)
	end
	helper_66ac1f76()
	event.SetCharaPos(0, 205.1, -6.0, 894.1)
end

--- Helper function.
local function helper_1c6d8()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/e200/e270/e270_1.txt")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 33
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e200/e270/e270_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 37)
		event.LoadMotion(5, "event/e200/e270/e270_monica.gltf", "info", global3)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global2 = 33
		global3 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global2)
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e200/e270/e270_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e200/e270/e270_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.CharaActive(0, global3)
	end
end

--- Helper function.
local function helper_21d00000()
	global2 = 0
	global3 = 33
	global2 = 33
	global3 = 0
end

--- Helper function.
local function helper_1c400()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global2)
		event.CharaActive(0, global3)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global3)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global3)
		event.CharaActive(0, global2)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global2)
		event.DeleteChara(37)
	end
end

--- Helper function.
local function helper_1d334()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(270, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		event.SetFadeOut(30)
		at = 1
		helper_25abe6d2(45)
		event.LoadSound(2500)
		var4 = event.SndLoadSound_2(2500) or var4
		helper_1c6d8()
		event.InitDramaScene()
		event.CharaActive(1, global2)
		event.CharaActive(1, global3)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.CmrsSetPos(174.76, 389.28, 1785.94)
		event.CmrsSetRef(34.41, 90.8, 382.81)
		event.SetCharaPos(0, -297.56, 0.0, -373.68)
		event.SetCharaRot(0, 0.0, 2.57, 0.0)
		event.EohSetFootSoundId(0, 1)
		event.EohSetFootSoundId(1, 1)
		event.ObjsSetPos(0, 68.8, 23.7, 1491.8)
		event.ObjsSetRot(0, 0.0, 3.05, 0.0)
		event.ObjsSetPos(1, 93.9, 23.7, 1438.4)
		event.ObjsSetRot(1, 0.0, 3.05, 0.0)
		event.SetFadeIn(30)
		event.SndSePlay(var4, 2)
		event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
		event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
		at = 2
		helper_25abe6d2(15)
		event.ObjsMove(0, 37.43, 14.75, 561.52, 600, 1)
		event.ObjsMove(1, 58.59, 15.55, 560.22, 600, 1)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(660)
		event.CmrsAddPas(174.76, 389.28, 1785.94, 34.41, 90.8, 382.81)
		event.CmrsAddPas(171.97, 318.75, 1758.0, 34.41, 90.8, 382.81)
		event.CmrsAddPas(161.43, 215.48, 1652.69, 34.41, 90.8, 382.81)
		event.CmrsAddPas(142.06, 138.98, 1459.02, 34.41, 90.8, 382.81)
		event.CmrsAddPas(64.19, 10.12, 750.23, 30.64, 90.8, 392.13)
		event.CmrsStartPas()
		at = 3
		helper_0958ca60(1)
		event.ObjsRotation(1, 0.0, -2.75, 0.0, 5)
		at = 4
		helper_25abe6d2(5)
		event.ObjsSetMotion(1, "立ち", 0)
		at = 5
		helper_0958ca60(0)
		event.ObjsRotation(0, 0.0, 3.05, 0.0, 5)
		at = 6
		helper_25abe6d2(5)
		event.ObjsSetMotion(0, "立ち", 0)
		event.SndSeStop(var4, 2)
		at = 7
		helper_25abe6d2(60)
		at = 8
		helper_e34416e2(2700010)
		at = 9
		helper_e34416e2(2700020)
		at = 10
		helper_25abe6d2(30)
		event.CmrsSetPos(25.23, 45.67, 520.07)
		event.CmrsSetRef(56.48, 39.42, 567.84)
		event.ObjsMove(1, 58.3, 15.55, 557.33, 10, 1)
		event.ObjsSetMotion(1, "歩き", 2)
		at = 11
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "立ち", 2)
		event.ObjsNextMotion(1, "上向く", 6)
		at = 12
		helper_0958ca60(1)
		event.ObjsNextMotion(1, "上向く会話", 2)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		event.ObjsSetMotion(0, "右向く", 6)
		event.ObjsNextMotion(0, "右向くL", 0)
		at = 13
		helper_e34416e2(2700030)
		event.ResetPakuAnim()
		event.ObjsNextMotion(1, "上向くL", 4)
		at = 14
		helper_25abe6d2(30)
		event.CmrsSetPos(64.19, 10.12, 750.23)
		event.CmrsSetRef(30.64, 90.8, 392.13)
		at = 15
		helper_25abe6d2(15)
		event.ObjsSetMotion(0, "右向く戻り")
		event.ObjsNextMotion(0, "上向く", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		at = 16
		helper_e34416e2(2700040)
		event.ObjsSetMotion(1, "上向く会話", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		at = 17
		helper_e34416e2(2700050)
		event.ObjsSetMotion(1, "上向く会話", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		at = 18
		helper_e34416e2(2700055)
		event.ObjsNextMotion(1, "上向くL", 4)
		at = 19
		helper_25abe6d2(60)
		event.ObjsSetMotion(0, "風", 6)
		event.ObjsNextMotion(0, "風Ｌ", 4)
		event.ObjsSetMotion(1, "風", 6)
		event.ObjsNextMotion(1, "風Ｌ", 4)
		event.SndSePlay(var4, 3)
		event.SetWind(40.0, 34.48, 48.5, 396.61)
		at = 20
		helper_c28d4a31(2700060, -1)
		event.SetWind(-1)
		event.ObjsSetMotion(0, "風戻り", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "風戻り", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		at = 21
		helper_25abe6d2(30)
		event.CmrsSetPos(25.23, 45.67, 520.07)
		event.CmrsSetRef(56.48, 39.42, 567.84)
		at = 22
		helper_25abe6d2(15)
		event.ObjsSetMotion(1, "あいつは～専用", 6)
		event.ObjsNextMotion(1, "あいつは～専用Ｌ", 4)
		event.ObjsMotionDelay(1, 90)
		event.ObjsSetMotion(1, "時の～専用上～見立ちに", 6)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "おこり目")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "おこり目とじ")
		event.ObjsTexaDelay(1, 60)
		event.ObjsTexAnime(1, 1, "おこり目とじ～目あき")
		at = 23
		vm.wait(23)
		event.SetPakuAnim(1, "通常口パク")
		at = 24
		helper_e34416e2(2700070)
		at = 25
		helper_0958ca60(1)
		event.ObjsMotionWait(1)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "上向くL", 6)
		event.ObjsNextMotion(1, "上向く会話", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 26
		helper_e34416e2(2700080)
		at = 27
		helper_0958ca60(1)
		event.ObjsMotionWait(1)
		event.ResetPakuAnim()
		event.ObjsNextMotion(1, "上向くL", 4)
		at = 28
		helper_25abe6d2(30)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(930)
		event.CmrsAddPas(132.27, 70.71, 488.53, 58.05, 36.97, 556.81)
		event.CmrsAddPas(159.15, 70.71, 562.03, 58.05, 36.97, 556.81)
		event.CmrsAddPas(132.93, 70.71, 625.44, 58.05, 36.97, 556.81)
		event.CmrsAddPas(77.3, 70.71, 656.87, 58.05, 36.97, 556.81)
		event.CmrsAddPas(28.82, 70.71, 654.67, 58.05, 36.97, 556.81)
		event.CmrsAddPas(-9.49, 70.71, 633.72, 58.05, 36.97, 556.81)
		event.CmrsAddPas(-37.15, 70.71, 595.03, 58.05, 36.97, 556.81)
		event.CmrsAddPas(-44.53, 70.71, 550.01, 58.05, 36.97, 556.81)
		event.CmrsAddPas(-32.67, 70.71, 507.99, 58.05, 36.97, 556.81)
		event.CmrsAddPas(-6.04, 70.71, 475.89, 58.05, 36.97, 556.81)
		event.CmrsStartPas()
		at = 29
		helper_25abe6d2(15)
		event.ObjsSetMotion(1, "上向く会話", 2)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 30
		helper_c28d4a31(2700090, 120)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "上向く会話", 2)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 31
		helper_c28d4a31(2700095, 120)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "上向く会話", 2)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 32
		helper_c28d4a31(2700100, 230)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "上向く会話", 2)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 33
		helper_c28d4a31(2700110, 200)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "上向く会話", 2)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 34
		helper_c28d4a31(2700120, -1)
		event.ResetPakuAnim()
		event.CmrsSetPos(40.68, 60.8, 523.12)
		event.CmrsSetRef(50.29, 32.81, 569.09)
		event.ObjsSetMotion(1, "上向くL", 4)
		event.ObjsMotionDelay(1, 110)
		event.ObjsSetMotion(1, "上向き会話2", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 35
		helper_e34416e2(2700130)
		at = 36
		helper_0958ca60(1)
		event.ObjsMotionWait(1)
		event.ResetPakuAnim()
		event.ObjsNextMotion(1, "上向くL", 4)
		at = 37
		helper_25abe6d2(30)
		event.CmrsSetPos(64.19, 10.12, 750.23)
		event.CmrsSetRef(30.64, 90.8, 392.13)
		at = 38
		helper_25abe6d2(15)
		at = 39
		helper_e34416e2(2700140)
		at = 40
		helper_e34416e2(2700150)
		at = 41
		helper_e34416e2(2700153)
		at = 42
		helper_25abe6d2(30)
		event.CmrsSetPos(19.5, 49.85, 518.46)
		event.CmrsSetRef(52.88, 36.97, 566.51)
		at = 43
		helper_25abe6d2(15)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目～がっかり目")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "力こめ目とじ")
		event.ObjsTexAnime(1, 1, "口閉じ～口くいしばり")
		event.SndSePlay(var4, 5)
		event.ObjsSetMotion(1, "悔しがりラスト", 6)
		event.ObjsNextMotion(1, "悔しがりラストＬ", 4)
		event.ObjsSetMotion(0, "上向く戻り", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.CmrsMove2(26.54, 49.85, 528.59, 52.88, 36.97, 566.51, 60, 2, 1.0)
		at = 44
		helper_c28d4a31(2700155, -1)
		at = 45
		helper_25abe6d2(30)
		event.SetFadeOut(30)
		at = 46
		helper_25abe6d2(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_21d00000()
			helper_d3f20302(15)
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			helper_d3f20302(5)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_d3f20302(5)
		end
		if at <= 6 then
			helper_d3f20302(60)
		end
		if at <= 7 then
			helper_8cd371d7(2700010)
		end
		if at <= 8 then
			helper_8cd371d7(2700020)
		end
		if at <= 9 then
			helper_d3f20302(30)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_8cd371d7(2700030)
		end
		if at <= 13 then
			helper_d3f20302(30)
		end
		if at <= 14 then
			helper_d3f20302(15)
		end
		if at <= 15 then
			helper_8cd371d7(2700040)
		end
		if at <= 16 then
			helper_8cd371d7(2700050)
		end
		if at <= 17 then
			helper_8cd371d7(2700055)
		end
		if at <= 18 then
			helper_d3f20302(60)
		end
		if at <= 19 then
			helper_52aadc70(2700060, -1)
		end
		if at <= 20 then
			helper_d3f20302(30)
		end
		if at <= 21 then
			helper_d3f20302(15)
		end
		if at <= 23 then
			helper_8cd371d7(2700070)
		end
		if at <= 24 then
			helper_238b5abc(1)
		end
		if at <= 25 then
			helper_8cd371d7(2700080)
		end
		if at <= 26 then
			helper_238b5abc(1)
		end
		if at <= 27 then
			helper_d3f20302(30)
		end
		if at <= 28 then
			helper_d3f20302(15)
		end
		if at <= 29 then
			helper_52aadc70(2700090, 120)
		end
		if at <= 30 then
			helper_52aadc70(2700095, 120)
		end
		if at <= 31 then
			helper_52aadc70(2700100, 230)
		end
		if at <= 32 then
			helper_52aadc70(2700110, 200)
		end
		if at <= 33 then
			helper_52aadc70(2700120, -1)
		end
		if at <= 34 then
			helper_8cd371d7(2700130)
		end
		if at <= 35 then
			helper_238b5abc(1)
		end
		if at <= 36 then
			helper_d3f20302(30)
		end
		if at <= 37 then
			helper_d3f20302(15)
		end
		if at <= 38 then
			helper_8cd371d7(2700140)
		end
		if at <= 39 then
			helper_8cd371d7(2700150)
		end
		if at <= 40 then
			helper_8cd371d7(2700153)
		end
		if at <= 41 then
			helper_d3f20302(30)
		end
		if at <= 42 then
			helper_d3f20302(15)
		end
		if at <= 43 then
			helper_52aadc70(2700155, -1)
		end
		if at <= 44 then
			helper_d3f20302(30)
		end
		if at <= 45 then
			helper_d3f20302(35)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SetWind(-1)
	event.SndSeStop(var4, 2)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	helper_1c400()
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_20a74()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global4 = 0
		global5 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global4)
		event.LoadMotion(5, "event/e200/e272/e272_mints.gltf", "info", global4)
		event.EohSyncChara(0, global4)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global4)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global5)
		event.LoadEquip(5, 1, 4, "info", global5)
		event.LoadEquip(5, 1, 3, "info", global5)
		event.LoadEquip(5, 1, 2, "info", global5, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global5)
		event.LoadMotion(5, "event/e200/e272/e272_monica.gltf", "info", global5)
		event.EohSyncChara(1, global5)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global5)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global4 = 32
		global5 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global4)
		event.LoadEquip(5, 0, 4, "info", global4)
		event.LoadEquip(5, 0, 3, "info", global4)
		event.LoadEquip(5, 0, 2, "info", global4, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global4)
		event.LoadMotion(5, "event/e200/e272/e272_mints.gltf", "info", global4)
		event.EohSyncChara(0, global4)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global4)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global5)
		event.LoadMotion(5, "event/e200/e272/e272_monica.gltf", "info", global5)
		event.EohSyncChara(1, global5)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global5)
	end
	event.LoadChara(5, "event/e200/e255/e255_rafu_tane.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(3, 35)
	event.ObjsSyncObj(3, 2)
	event.LoadChara(5, "event/e200/e272/e272_hanabaku.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.LoadChara(5, "event/e200/e272/e272_kirakira.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(4, 39)
	event.ObjsInit(5, 39)
	event.ObjsSyncObj(5, 4)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.EohSyncChara(5, 40)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 5)
	event.CharaActive(0, 40)
	event.LoadMes(0, 5, "event/e200/e272/e272_1.txt")
end

--- Helper function.
local function helper_22600000()
	global4 = 0
	global5 = 32
	global4 = 32
	global5 = 0
end

--- Helper function.
local function helper_20620()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global4)
		event.CharaActive(0, global5)
		event.DelExtMotion(global4)
		event.DelExtMotion(global5)
		event.DelExtMotion(36)
		event.DeleteChara(global5)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global5)
		event.CharaActive(0, global4)
		event.DelExtMotion(global4)
		event.DelExtMotion(global5)
		event.DelExtMotion(36)
		event.DeleteChara(global4)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	event.DeleteChara(35)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
end

--- Helper function.
local function helper_21af4()
	local var10: s32 = 0
	local var11: s32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetFadeOut(30)
		at = 1
		helper_25abe6d2(45)
		event.SetFlag(272, 1)
		event.LoadSound(2503)
		var10 = event.SndLoadSound_2(2503) or var10
		var11 = event.SndLoadSound_3(8, "snd2/sp/sp_006.sound.json") or var11
		helper_20a74()
		event.InitDramaScene()
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.CharaActive(1, global4)
		event.CharaActive(1, global5)
		event.CharaActive(0, 35)
		event.CmrsSetPos(104.47, 46.8, 1479.26)
		event.CmrsSetRef(86.03, 73.72, 1247.28)
		event.SetCharaPos(0, -297.56, 0.0, -373.68)
		event.SetCharaRot(0, 0.0, 2.57, 0.0)
		event.EohSetFootSoundId(0, 1)
		event.EohSetFootSoundId(1, 1)
		event.SetCharaPos(38, -96.86, 52.75, 388.46)
		event.SetCharaRot(38, 0.0, 0.0, 0.0)
		event.SetCharaPos(39, 37.43, 34.75, 561.52)
		event.SetCharaRot(39, 0.0, 0.0, 0.0)
		event.ObjsSetPos(0, 47.14, -8.67, 849.46)
		event.ObjsSetRot(0, 0.0, 3.05, 0.0)
		event.ObjsSetPos(1, 70.25, -10.75, 900.05)
		event.ObjsSetRot(1, 0.0, 3.05, 0.0)
		event.SetFadeIn(30)
		event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
		event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
		event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
		at = 2
		helper_25abe6d2(15)
		event.ObjsMove(0, 37.43, 14.75, 561.52, 240, 1)
		event.ObjsMove(1, 58.59, 15.55, 560.22, 270, 1)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(104.47, 46.8, 1479.26, 86.03, 73.72, 1247.28)
		event.CmrsAddPas(65.3, 46.8, 986.65, 46.86, 73.72, 754.67)
		event.CmrsStartPas()
		at = 3
		helper_0958ca60(0)
		event.ObjsRotation(0, 0.0, -3.11, 0.0, 5)
		at = 4
		helper_25abe6d2(5)
		event.ObjsSetMotion(0, "立ち", 0)
		at = 5
		helper_0958ca60(1)
		event.ObjsRotation(1, 0.0, -2.87, 0.0, 5)
		at = 6
		helper_25abe6d2(5)
		event.ObjsSetMotion(1, "上向くL", 0)
		at = 7
		helper_25abe6d2(60)
		event.ObjsSetMotion(0, "上向く", 2)
		event.ObjsNextMotion(0, "上向く会話", 2)
		event.ObjsNextMotion(0, "上向くL", 4)
		at = 8
		helper_e34416e2(2720010)
		at = 9
		helper_0958ca60(0)
		event.ObjsNextMotion(0, "上向くL", 4)
		at = 10
		helper_e34416e2(2720020)
		at = 11
		helper_e34416e2(2720030)
		at = 12
		helper_e34416e2(2720035)
		at = 13
		helper_25abe6d2(30)
		event.CmrsSetPos(62.05, 41.42, 524.15)
		event.CmrsSetRef(28.43, 35.31, 613.0)
		event.ObjsSetMotion(0, "上向く会話", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 14
		helper_e34416e2(2720040)
		event.ResetPakuAnim()
		event.ObjsMotionWait(0)
		event.ObjsSetMotion(0, "上向くL", 4)
		at = 15
		helper_25abe6d2(30)
		event.CmrsSetPos(65.3, 46.8, 986.65)
		event.CmrsSetRef(46.86, 73.72, 754.67)
		at = 16
		helper_e34416e2(2720050)
		event.ObjsSetMotion(0, "上向く会話", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		at = 17
		helper_e34416e2(2720060)
		at = 18
		helper_0958ca60(0)
		at = 19
		helper_e34416e2(2720070)
		at = 20
		helper_25abe6d2(30)
		event.CmrsSetPos(35.55, 36.73, 529.53)
		event.CmrsSetRef(46.86, 52.13, 754.67)
		event.ObjsSetMotion(0, "考える", 4)
		at = 21
		helper_25abe6d2(15)
		event.CmrsMove2(35.81, 36.73, 534.67, 46.86, 52.13, 754.67, 30, 2, 1.0)
		event.SetPakuAnim(0, "通常口パク")
		at = 22
		helper_e34416e2(2720080)
		event.ResetPakuAnim()
		at = 23
		helper_25abe6d2(30)
		event.CmrsSetPos(283.52, 88.96, 846.8)
		event.CmrsSetRef(90.35, 78.53, 545.4)
		at = 24
		helper_25abe6d2(15)
		at = 25
		helper_e34416e2(2720090)
		event.SetMpcharaMotion("jyuraku", "jyuraku", "もごもご")
		at = 26
		helper_25abe6d2(30)
		event.SetMpcharaMotion("jyuraku", "jyuraku", "ふんっ")
		at = 27
		helper_25abe6d2(30)
		event.CharaActive(1, 38)
		event.SetMotion(38, "鼻爆発", 2, -1, 1)
		event.SndSePlay(var10, 4)
		event.SetWind(40.0, -96.86, 52.75, 388.46)
		at = 28
		helper_25abe6d2(15)
		event.SetWind(-1)
		event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
		event.ObjsSetMotion(0, "驚く", 6)
		event.ObjsSetMotion(1, "おどろき", 6)
		event.ObjsNextMotion(0, "驚くL", 4)
		event.ObjsNextMotion(1, "おどろきL", 4)
		at = 29
		helper_25abe6d2(90)
		event.CharaActive(0, 38)
		event.CmrsSetPos(64.11, 33.73, 495.58)
		event.CmrsSetRef(35.93, 39.28, 614.27)
		event.ObjsSetRot(1, 0.0, -2.03, 0.0)
		event.CharaActive(1, 39)
		event.SetMotion(39, "キラキラ（ループ）", 4, -1, 1)
		event.ObjsInitPas(5)
		event.ObjsSetPasFrm(5, 120)
		event.ObjsAddPas(5, 39.0, 68.91, 553.15)
		event.ObjsAddPas(5, 39.0, 42.39, 553.15)
		event.ObjsStartPas(5)
		event.SndSePlay(var10, 5)
		event.ObjsSetMotion(0, "キラキラ見る", 2)
		event.ObjsSetMotion(1, "おどろきＬから上向き立ち", 2)
		event.ObjsNextMotion(0, "取る", 6)
		event.ObjsNextMotion(1, "上向く戻り", 6, 0.025)
		event.ObjsNextMotion(0, "取るL", 4)
		event.ObjsNextMotion(1, "立ち", 4)
		at = 30
		helper_25abe6d2(120)
		event.SetMotion(39, "消える", 2, -1, 1)
		at = 31
		helper_25abe6d2(30)
		event.CharaActive(0, 39)
		event.CmrsSetPos(32.21, 52.0, 529.74)
		event.CmrsSetRef(38.35, 42.39, 562.99)
		event.ObjsSetPos(6, 44.55, 45.78, 564.88)
		event.ObjsSetRot(6, 0.0, -3.11, 0.0)
		event.SndPauseBgm()
		event.CharaActive(1, 40)
		event.SndSePlay(var10, 6)
		event.SndSePlay(var11, 0)
		event.ObjsSetMotion(6, "発動", 6)
		event.SetReference(global4, "item", 35)
		event.CharaActive(1, 35)
		event.ObjsSetMotion(0, "種ゲット", 4)
		at = 32
		helper_e8257c69(361, 1)
		event.PlayBgm(0)
		event.DelReference(35)
		event.CharaActive(0, 40)
		event.CmrsSetPos(65.3, 46.8, 986.65)
		event.CmrsSetRef(46.86, 73.72, 754.67)
		event.ObjsSetRot(1, 0.0, -2.87, 0.0)
		event.ObjsSetMotion(0, "上向くL", 0)
		event.ObjsSetMotion(1, "上向くL", 0)
		at = 33
		helper_e34416e2(2720100)
		at = 34
		helper_e34416e2(2720110)
		event.CmrsSetPos(40.41, 53.02, 519.29)
		event.CmrsSetRef(64.94, -1.06, 669.16)
		at = 35
		helper_25abe6d2(15)
		event.SetPakuAnim(0, "通常口パク")
		at = 36
		helper_e34416e2(2720120)
		event.ResetPakuAnim()
		event.CmrsSetPos(65.3, 46.8, 986.65)
		event.CmrsSetRef(46.86, 73.72, 754.67)
		at = 37
		helper_25abe6d2(15)
		at = 38
		helper_e34416e2(2720130)
		event.ObjsSetMotion(0, "上向く会話", 2)
		event.ObjsNextMotion(0, "上向くL", 4)
		at = 39
		helper_e34416e2(2720140)
		event.ObjsNextMotion(0, "上向くL", 4)
		at = 40
		helper_e34416e2(2720150)
		at = 41
		helper_25abe6d2(30)
		event.CmrsSetPos(40.41, 53.02, 519.29)
		event.CmrsSetRef(64.94, -1.06, 669.16)
		event.ObjsSetMotion(0, "あせり会話", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.SetPakuAnim(0, "大口パク")
		at = 42
		helper_e34416e2(2720160)
		event.ResetPakuAnim()
		event.SetPakuAnim(0, "大口パク")
		event.ObjsSetMotion(0, "あせり会話", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		at = 43
		helper_e34416e2(2720165)
		event.ResetPakuAnim()
		event.CmrsSetPos(65.3, 46.8, 986.65)
		event.CmrsSetRef(46.86, 73.72, 754.67)
		event.ObjsSetMotion(0, "立ち", 4)
		at = 44
		helper_e34416e2(2720170)
		at = 45
		helper_e8257c69(308, 1)
		event.CmrsSetPos(40.41, 53.02, 519.29)
		event.CmrsSetRef(64.94, -1.06, 669.16)
		event.ObjsSetMotion(0, "右向く", 6)
		event.ObjsNextMotion(0, "右向くL", 6)
		event.ObjsSetMotion(1, "左向く", 6)
		event.ObjsNextMotion(1, "左向く戻り", 6)
		event.ObjsNextMotion(1, "だめだめ", 6)
		event.ObjsNextMotion(1, "立ち", 6)
		at = 46
		helper_25abe6d2(120)
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)] Per prendere una Goccia del\nSole, ti serve qualcosa che ti\npermetta di parlare all'Himarra.<page>Ottenere questo oggetto dipende anche\ndallo sviluppo del Diorama. Lavoraci\nsu e controlla il mondo futuro di Jurak."
		)
		at = 47
		helper_a3cc6850(0, -1, 8, 0, 0)
		event.SetMesPreset(0, 0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22600000()
			helper_d3f20302(15)
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			helper_d3f20302(5)
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			helper_d3f20302(5)
		end
		if at <= 6 then
			helper_d3f20302(60)
		end
		if at <= 7 then
			helper_8cd371d7(2720010)
		end
		if at <= 8 then
			helper_238b5abc(0)
		end
		if at <= 9 then
			helper_8cd371d7(2720020)
		end
		if at <= 10 then
			helper_8cd371d7(2720030)
		end
		if at <= 11 then
			helper_8cd371d7(2720035)
		end
		if at <= 12 then
			helper_d3f20302(30)
		end
		if at <= 13 then
			helper_8cd371d7(2720040)
		end
		if at <= 14 then
			helper_d3f20302(30)
		end
		if at <= 15 then
			helper_8cd371d7(2720050)
		end
		if at <= 16 then
			helper_8cd371d7(2720060)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_8cd371d7(2720070)
		end
		if at <= 19 then
			helper_d3f20302(30)
		end
		if at <= 20 then
			helper_d3f20302(15)
		end
		if at <= 21 then
			helper_8cd371d7(2720080)
		end
		if at <= 22 then
			helper_d3f20302(30)
		end
		if at <= 23 then
			helper_d3f20302(15)
		end
		if at <= 24 then
			helper_8cd371d7(2720090)
		end
		if at <= 25 then
			helper_d3f20302(30)
		end
		if at <= 26 then
			helper_d3f20302(30)
		end
		if at <= 27 then
			helper_d3f20302(15)
		end
		if at <= 28 then
			helper_d3f20302(90)
		end
		if at <= 29 then
			helper_d3f20302(120)
		end
		if at <= 30 then
			helper_d3f20302(30)
		end
		if at <= 31 then
			helper_5c12934f(361, 1)
		end
		if at <= 32 then
			helper_8cd371d7(2720100)
		end
		if at <= 33 then
			helper_8cd371d7(2720110)
		end
		if at <= 34 then
			helper_d3f20302(15)
		end
		if at <= 35 then
			helper_8cd371d7(2720120)
		end
		if at <= 36 then
			helper_d3f20302(15)
		end
		if at <= 37 then
			helper_8cd371d7(2720130)
		end
		if at <= 38 then
			helper_8cd371d7(2720140)
		end
		if at <= 39 then
			helper_8cd371d7(2720150)
		end
		if at <= 40 then
			helper_d3f20302(30)
		end
		if at <= 41 then
			helper_8cd371d7(2720160)
		end
		if at <= 42 then
			helper_8cd371d7(2720165)
		end
		if at <= 43 then
			helper_8cd371d7(2720170)
		end
		if at <= 44 then
			helper_5c12934f(308, 1)
		end
		if at <= 45 then
			helper_d3f20302(120)
		end
		if at <= 46 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SetFadeOut(30)
	at = 48
	helper_25abe6d2(30)
	event.SetWind(-1)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	helper_20620()
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_24f40()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadMes(0, 5, "event/e200/e275/e275_1.txt")
end

--- Helper function.
local function helper_22b00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_24c68()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
end

--- Helper function.
local function helper_259cc()
	local var4: s32 = 0
	local var5: s32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(275, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetFadeOut(30)
		at = 1
		helper_25abe6d2(45)
		helper_24f40()
		event.LoadSound(2506)
		event.InitDramaScene()
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CmrsSetPos(-4.27, 55.7, 754.91)
		event.CmrsSetRef(14.71, 53.79, 698.03)
		event.SetCharaPos(0, -297.56, 0.0, -373.68)
		event.SetCharaRot(0, 0.0, 2.57, 0.0)
		var4 = event.GetAnalyze(106) or var4
		var5 = event.GetAnalyze(105) or var5
		if var5 ~= 0 then
			event.CmrsSetPos(13.7, 24.83, 757.8)
			event.CmrsSetRef(14.71, 53.79, 698.03)
		end
		if var4 ~= 0 then
			event.CmrsSetPos(49.24, 24.83, 746.5)
			event.CmrsSetRef(14.71, 53.79, 698.03)
		end
		event.ObjsSetPos(0, 13.4, 6.52, 613.7)
		event.ObjsSetRot(0, 0.0, -2.92, 0.0)
		event.ObjsSetPos(1, 47.24, 7.54, 600.38)
		event.ObjsSetRot(1, 0.0, -2.92, 0.0)
		event.SetFadeIn(30)
		event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		at = 2
		helper_25abe6d2(15)
		if (if var4 ~= 0 then 1 else var5) ~= 0 then
			event.CmrsInitPas()
			if (if var4 ~= 0 then var5 else 0) ~= 0 then
				event.CmrsSetPasFrm(480)
			end
			if (if var4 ~= 0 then 1 else var5) ~= 0 then
				event.CmrsSetPasFrm(240)
			end
			if var4 ~= 0 then
				event.CmrsAddPas(49.24, 24.83, 746.5, 14.71, 53.79, 698.03)
			end
			if var5 ~= 0 then
				event.CmrsAddPas(13.7, 24.83, 757.8, 14.71, 53.79, 698.03)
			end
			event.CmrsAddPas(-4.27, 55.7, 754.91, 14.71, 53.79, 698.03)
			event.CmrsStartPas()
		else
			at = 3
			helper_25abe6d2(60)
		end
		at = 4
		helper_e34416e2(2750010)
		at = 5
		helper_c624bc16()
		at = 6
		helper_25abe6d2(30)
		event.CmrsSetPos(17.1, 20.28, 879.05)
		event.CmrsSetRef(14.71, 53.79, 698.03)
		at = 7
		helper_25abe6d2(15)
		at = 8
		helper_e34416e2(2750020)
		at = 9
		helper_e34416e2(2750030)
		at = 10
		helper_25abe6d2(60)
		event.SetFadeOut(30)
		at = 11
		helper_25abe6d2(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22b00000()
			helper_d3f20302(15)
		end
		if at <= 2 then
			helper_d3f20302(60)
		end
		if at <= 3 then
			helper_8cd371d7(2750010)
		end
		if at <= 4 then
			helper_344d6cd8()
		end
		if at <= 5 then
			helper_d3f20302(30)
		end
		if at <= 6 then
			helper_d3f20302(15)
		end
		if at <= 7 then
			helper_8cd371d7(2750020)
		end
		if at <= 8 then
			helper_8cd371d7(2750030)
		end
		if at <= 9 then
			helper_d3f20302(60)
		end
		if at <= 10 then
			helper_d3f20302(35)
		end
		return true
	end)
	event.CancelDramaScene()
	helper_24c68()
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_2912c()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global6 = 0
		global7 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global6)
		event.LoadMotion(5, "event/e200/e280/e280_mints.gltf", "info", global6)
		event.EohSyncChara(0, global6)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global6)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global7)
		event.LoadEquip(5, 1, 4, "info", global7)
		event.LoadEquip(5, 1, 3, "info", global7)
		event.LoadEquip(5, 1, 2, "info", global7, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global7)
		event.LoadMotion(5, "event/e200/e280/e280_monica.gltf", "info", global7)
		event.EohSyncChara(1, global7)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global7)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global6 = 32
		global7 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global6)
		event.LoadEquip(5, 0, 4, "info", global6)
		event.LoadEquip(5, 0, 3, "info", global6)
		event.LoadEquip(5, 0, 2, "info", global6, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global6)
		event.LoadMotion(5, "event/e200/e280/e280_mints.gltf", "info", global6)
		event.EohSyncChara(0, global6)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global6)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global7)
		event.LoadMotion(5, "event/e200/e280/e280_monica.gltf", "info", global7)
		event.EohSyncChara(1, global7)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global7)
	end
	event.LoadMes(0, 5, "event/e200/e280/e280a_1.txt")
end

--- Helper function.
local function helper_22f00000()
	global6 = 0
	global7 = 32
	global6 = 32
	global7 = 0
end

--- Helper function.
local function helper_28dfc()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global6)
		event.CharaActive(0, global7)
		event.DelExtMotion(global6)
		event.DelExtMotion(global7)
		event.DeleteChara(global7)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global7)
		event.CharaActive(0, global6)
		event.DelExtMotion(global6)
		event.DelExtMotion(global7)
		event.DeleteChara(global6)
		event.DeleteChara(37)
	end
	event.MapJump_3(-1, "s26", 700)
end

--- Helper function.
local function helper_29d88()
	local var6: s32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(280, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetFadeOut(30)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(45)
		event.LoadBgm(59)
		event.LoadSound(2511)
		event.PlayBgm(0, 36)
		var6 = event.SndLoadSound_2(2511) or var6
		helper_2912c()
		event.InitDramaScene()
		event.EohSetFootSoundId(0, 1)
		event.EohSetFootSoundId(1, 1)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.CharaActive(1, global6)
		event.CharaActive(1, global7)
		event.CmrsSetPos(34.43, 5.8, 741.1)
		event.CmrsSetRef(26.93, 51.37, 586.27)
		event.ObjsSetPos(1, 38.74, 7.54, 600.65)
		event.ObjsSetRot(1, 0.0, -2.68, 0.0)
		event.ObjsSetPos(0, 20.1, 6.52, 613.49)
		event.ObjsSetRot(0, 0.0, 3.12, 0.0)
		event.SetFadeIn(30)
		event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		at = 2
		helper_e34416e2(2800010)
		at = 3
		helper_e34416e2(2800015)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(0, 1, "わらい口ひらき")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.CmrsSetPos(-1.53, 38.93, 576.75)
		event.CmrsSetRef(47.63, 28.44, 622.59)
		event.ObjsSetMotion(1, "上向く会話", 2)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "わらい口パク")
		at = 4
		helper_e34416e2(2800020)
		event.ResetPakuAnim()
		at = 5
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "上向くL", 4)
		at = 6
		helper_25abe6d2(30)
		event.CmrsSetPos(38.84, 15.89, 762.06)
		event.CmrsSetRef(30.81, 47.05, 622.71)
		at = 7
		helper_25abe6d2(15)
		at = 8
		helper_e34416e2(2800030)
		at = 9
		helper_e34416e2(2800040)
		at = 10
		helper_25abe6d2(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(0, 1, "半口")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "不満目パチ")
		event.CmrsSetPos(17.72, 36.99, 568.83)
		event.CmrsSetRef(35.34, 28.44, 619.23)
		at = 11
		helper_25abe6d2(15)
		event.ObjsSetMotion(1, "はぁ？", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.SetPakuAnim(1, "あきれ口パク")
		at = 12
		helper_e34416e2(2800050)
		event.ResetPakuAnim()
		at = 13
		helper_0958ca60(1)
		at = 14
		helper_25abe6d2(30)
		event.CmrsSetPos(38.84, 15.89, 762.06)
		event.CmrsSetRef(30.81, 47.05, 622.71)
		at = 15
		helper_25abe6d2(15)
		at = 16
		helper_e34416e2(2800060)
		event.CmrsSetPos(54.46, 37.12, 558.59)
		event.CmrsSetRef(20.97, 30.6, 620.45)
		at = 17
		helper_e34416e2(2800065)
		event.CmrsSetPos(38.84, 15.89, 762.06)
		event.CmrsSetRef(30.81, 47.05, 622.71)
		at = 18
		helper_e34416e2(2800070)
		at = 19
		helper_25abe6d2(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "不満顔")
		event.ObjsTexAnime(1, 1, "不満目パチ")
		event.CmrsSetPos(42.96, 39.99, 563.11)
		event.CmrsSetRef(28.37, 28.44, 607.63)
		event.ObjsSetRot(0, 0.0, -2.56, 0.0)
		at = 20
		helper_25abe6d2(15)
		event.SetPakuAnim(0, "通常口パク")
		at = 21
		helper_e34416e2(2800080)
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "上見から右見", 6)
		event.ObjsNextMotion(0, "右向く会話", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 22
		helper_e34416e2(2800085)
		event.ResetPakuAnim()
		at = 23
		helper_0958ca60(0)
		at = 24
		helper_25abe6d2(30)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		event.ObjsSetRot(0, 0.0, 3.12, 0.0)
		event.CmrsSetPos(-23.31, 28.11, 596.86)
		event.CmrsSetRef(26.9, 28.44, 606.75)
		at = 25
		helper_25abe6d2(15)
		event.ObjsSetMotion(1, "上向きから左向き", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.ObjsMotionDelay(1, 60)
		event.ObjsSetMotion(1, "左向きから上向き", 6)
		event.ObjsNextMotion(1, "上向く会話", 2)
		event.ObjsNextMotion(1, "上向くL", 4)
		event.ObjsMotionDelay(0, 60)
		event.ObjsSetMotion(0, "右見から上見", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 26
		helper_e34416e2(2800090)
		event.ResetPakuAnim()
		at = 27
		helper_0958ca60(1)
		at = 28
		helper_25abe6d2(30)
		event.CmrsSetPos(60.85, 50.28, 994.5)
		event.CmrsSetRef(37.15, 90.96, 620.83)
		at = 29
		helper_25abe6d2(15)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(60.85, 50.28, 994.5, 37.15, 90.96, 620.83)
		event.CmrsAddPas(53.55, 50.28, 879.42, 29.85, 90.96, 505.75)
		event.CmrsStartPas()
		at = 30
		helper_c28d4a31(2800100, -1)
		event.SndSePlay(var6, 8)
		at = 31
		helper_c624bc16()
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "うれし目パチ")
		event.CmrsSetPos(15.67, 33.06, 545.55)
		event.CmrsSetRef(37.65, 31.67, 641.15)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(15.67, 33.06, 545.55, 37.65, 31.67, 641.15)
		event.CmrsAddPas(21.77, 33.06, 572.11, 37.65, 31.67, 641.15)
		event.CmrsStartPas()
		at = 32
		helper_c624bc16()
		event.CmrsSetPos(38.84, 15.89, 762.06)
		event.CmrsSetRef(30.81, 47.05, 622.71)
		event.SndSeStop(var6, 8)
		at = 33
		helper_c28d4a31(2800110, 120)
		event.SndSePlay(var6, 9)
		event.ObjsSetMotion(1, "がっかり肩落とし", 6)
		event.ObjsNextMotion(1, "がっかり肩落としＬ", 4)
		event.ObjsSetMotion(0, "がっかり", 6)
		event.ObjsNextMotion(0, "がっかりＬ", 4)
		at = 34
		helper_25abe6d2(60)
		event.ObjsSetMotion(1, "頭抱えるＬ", 4, -1.0, 1)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "こまり顔")
		event.ObjsTexAnime(0, 1, "こまり目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目とじ")
		event.CmrsSetPos(-23.31, 28.11, 596.86)
		event.CmrsSetRef(26.9, 28.44, 606.75)
		at = 35
		helper_25abe6d2(15)
		at = 36
		helper_e34416e2(2800120)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "こまり顔")
		event.ObjsTexAnime(0, 1, "こまり目～通常目")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目とじ～おこり目あき")
		event.ObjsTexaDelay(1, 30)
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		event.SndSePlay(var6, 10)
		event.ObjsSetMotion(0, "がっかり→上", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 37
		helper_e34416e2(2800130)
		event.ResetPakuAnim()
		at = 38
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "上見から右見", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		event.ObjsSetMotion(1, "手をおろす", 6)
		event.ObjsNextMotion(1, "下向き立ちＬ", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 39
		helper_e34416e2(2800140)
		event.ResetPakuAnim()
		at = 40
		helper_0958ca60(1)
		event.SetPakuAnim(1, "通常口パク")
		at = 41
		helper_e34416e2(2800145)
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "右向く会話", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		at = 42
		helper_e34416e2(2800150)
		at = 43
		helper_0958ca60(0)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexaDelay(1, 30)
		event.ObjsTexAnime(1, 1, "さみし顔")
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		event.ObjsTexaDelay(1, 30)
		event.ObjsTexAnime(1, 1, "おこり目～さみし目")
		event.ObjsSetMotion(1, "下向き立ちＬ", 4)
		event.ObjsMotionDelay(1, 30)
		event.ObjsSetMotion(1, "下向きから左向き", 6)
		event.ObjsNextMotion(1, "左向く会話", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.SetPakuAnim(1, "さみし口パク")
		at = 44
		helper_e34416e2(2800160)
		event.ResetPakuAnim()
		at = 45
		helper_0958ca60(1)
		at = 46
		helper_25abe6d2(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "さみし顔")
		event.ObjsTexAnime(1, 1, "さみし目パチ")
		event.CmrsSetPos(42.73, 39.99, 562.51)
		event.CmrsSetRef(25.56, 28.44, 606.38)
		event.ObjsSetRot(0, 0.0, -2.56, 0.0)
		at = 47
		helper_25abe6d2(15)
		event.SetPakuAnim(0, "通常口パク")
		at = 48
		helper_e34416e2(2800170)
		event.ResetPakuAnim()
		event.ObjsSetMotion(1, "左向きから下向き", 6)
		event.ObjsNextMotion(1, "下向き立ちＬ", 4)
		event.SetPakuAnim(1, "さみし口パク")
		at = 49
		helper_e34416e2(2800180)
		event.ResetPakuAnim()
		at = 50
		helper_25abe6d2(30)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "さみし目～通常目")
		event.ObjsTexaDelay(1, 60)
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.CmrsSetPos(28.25, 31.54, 674.64)
		event.CmrsSetRef(28.22, 28.44, 600.45)
		event.ObjsSetMotion(0, "右回転90度（ＰＧ）", 6)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		event.ObjsRotation(0, 0.0, 2.4, 0.0, 20)
		at = 51
		helper_0958ca60(0)
		at = 52
		helper_0958ca60(0)
		event.SndSePlay(var6, 11)
		event.ObjsSetMotion(0, "がっつ", 6)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		event.SetPakuAnim(0, "わらい口パク")
		at = 53
		helper_e34416e2(2800190)
		event.ResetPakuAnim()
		at = 54
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "モニカ見立ちうなづき", 2)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		at = 55
		helper_e34416e2(2800195)
		at = 56
		helper_0958ca60(0)
		event.SndSePlay(var6, 12)
		event.ObjsRotation(1, 0.0, -1.0, 0.0, 30)
		event.ObjsSetMotion(1, "左回転90度（ＰＧ）", 6)
		at = 57
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "会話", 6)
		event.ObjsNextMotion(1, "立ち", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 58
		helper_e34416e2(2800200)
		event.ResetPakuAnim()
		at = 59
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "会話", 2)
		event.ObjsNextMotion(1, "立ち", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 60
		helper_e34416e2(2800205)
		event.ResetPakuAnim()
		at = 61
		helper_0958ca60(1)
		event.SndSePlay(var6, 13)
		event.ObjsSetMotion(0, "がっつ", 6)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		event.SetPakuAnim(0, "わらい口パク")
		at = 62
		helper_e34416e2(2800210)
		event.ResetPakuAnim()
		at = 63
		helper_0958ca60(0)
		event.SndSePlay(var6, 14)
		event.SndSePlay(var6, 15)
		event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		event.ObjsSetMotion(1, "うなづく", 6)
		event.ObjsNextMotion(1, "立ち", 4)
		at = 64
		helper_0958ca60(0)
		at = 65
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsSetMotion(0, "歩き")
		event.ObjsRotation(0, 0.0, 0.0, 0.0, 20)
		event.ObjsRotation(1, 0.0, 0.0, 0.0, 20)
		at = 66
		helper_0958ca60(0)
		at = 67
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "走り")
		event.ObjsSetMotion(0, "走り")
		event.ObjsMove(0, 20.44, 6.52, 1490.12, 390, 1)
		event.ObjsMove(1, 39.08, 7.54, 1478.94, 390, 1)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(240)
		event.CmrsAddPas(28.25, 31.54, 674.64, 28.22, 28.44, 600.45)
		event.CmrsAddPas(28.59, 31.54, 1526.51, 28.22, 28.44, 600.45)
		event.CmrsStartPas()
		at = 68
		helper_25abe6d2(15)
		at = 69
		helper_25abe6d2(200)
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		at = 70
		helper_25abe6d2(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22f00000()
			helper_8cd371d7(2800010)
		end
		if at <= 2 then
			helper_8cd371d7(2800015)
		end
		if at <= 3 then
			helper_8cd371d7(2800020)
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			helper_d3f20302(30)
		end
		if at <= 6 then
			helper_d3f20302(15)
		end
		if at <= 7 then
			helper_8cd371d7(2800030)
		end
		if at <= 8 then
			helper_8cd371d7(2800040)
		end
		if at <= 9 then
			helper_d3f20302(30)
		end
		if at <= 10 then
			helper_d3f20302(15)
		end
		if at <= 11 then
			helper_8cd371d7(2800050)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_d3f20302(30)
		end
		if at <= 14 then
			helper_d3f20302(15)
		end
		if at <= 15 then
			helper_8cd371d7(2800060)
		end
		if at <= 16 then
			helper_8cd371d7(2800065)
		end
		if at <= 17 then
			helper_8cd371d7(2800070)
		end
		if at <= 18 then
			helper_d3f20302(30)
		end
		if at <= 19 then
			helper_d3f20302(15)
		end
		if at <= 20 then
			helper_8cd371d7(2800080)
		end
		if at <= 21 then
			helper_8cd371d7(2800085)
		end
		if at <= 22 then
			helper_238b5abc(0)
		end
		if at <= 23 then
			helper_d3f20302(30)
		end
		if at <= 24 then
			helper_d3f20302(15)
		end
		if at <= 25 then
			helper_8cd371d7(2800090)
		end
		if at <= 26 then
			helper_238b5abc(1)
		end
		if at <= 27 then
			helper_d3f20302(30)
		end
		if at <= 28 then
			helper_d3f20302(15)
		end
		if at <= 29 then
			helper_52aadc70(2800100, -1)
		end
		if at <= 30 then
			helper_344d6cd8()
		end
		if at <= 31 then
			helper_344d6cd8()
		end
		if at <= 32 then
			helper_52aadc70(2800110, 120)
		end
		if at <= 33 then
			helper_d3f20302(60)
		end
		if at <= 34 then
			helper_d3f20302(15)
		end
		if at <= 35 then
			helper_8cd371d7(2800120)
		end
		if at <= 36 then
			helper_8cd371d7(2800130)
		end
		if at <= 37 then
			helper_238b5abc(0)
		end
		if at <= 38 then
			helper_8cd371d7(2800140)
		end
		if at <= 39 then
			helper_238b5abc(1)
		end
		if at <= 40 then
			helper_8cd371d7(2800145)
		end
		if at <= 41 then
			helper_8cd371d7(2800150)
		end
		if at <= 42 then
			helper_238b5abc(0)
		end
		if at <= 43 then
			helper_8cd371d7(2800160)
		end
		if at <= 44 then
			helper_238b5abc(1)
		end
		if at <= 45 then
			helper_d3f20302(30)
		end
		if at <= 46 then
			helper_d3f20302(15)
		end
		if at <= 47 then
			helper_8cd371d7(2800170)
		end
		if at <= 48 then
			helper_8cd371d7(2800180)
		end
		if at <= 49 then
			helper_d3f20302(30)
		end
		if at <= 50 then
			helper_238b5abc(0)
		end
		if at <= 51 then
			helper_238b5abc(0)
		end
		if at <= 52 then
			helper_8cd371d7(2800190)
		end
		if at <= 53 then
			helper_238b5abc(0)
		end
		if at <= 54 then
			helper_8cd371d7(2800195)
		end
		if at <= 55 then
			helper_238b5abc(0)
		end
		if at <= 56 then
			helper_238b5abc(1)
		end
		if at <= 57 then
			helper_8cd371d7(2800200)
		end
		if at <= 58 then
			helper_238b5abc(1)
		end
		if at <= 59 then
			helper_8cd371d7(2800205)
		end
		if at <= 60 then
			helper_238b5abc(1)
		end
		if at <= 61 then
			helper_8cd371d7(2800210)
		end
		if at <= 62 then
			helper_238b5abc(0)
		end
		if at <= 63 then
			helper_238b5abc(0)
		end
		if at <= 64 then
			helper_238b5abc(1)
		end
		if at <= 65 then
			helper_238b5abc(0)
		end
		if at <= 66 then
			helper_238b5abc(1)
		end
		if at <= 67 then
			helper_d3f20302(15)
		end
		if at <= 68 then
			helper_d3f20302(200)
		end
		if at <= 69 then
			helper_d3f20302(35)
		end
		return true
	end)
	event.CancelDramaScene()
	event.StopBgm(0)
	event.SndSeStop(var6, 8)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	helper_28dfc()
	event.ResetCamera(0)
end

--- Helper function.
local function helper_2fed4()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e285/e285_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e285/e285_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e285/e285_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e285/e285_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadItem(5, 31, "info", 36)
	event.CharaActive(0, 36)
	event.LoadChara(5, "event/e200/e272/e272_hanabaku.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.LoadChara(5, "event/e200/e272/e272_kirakira.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(4, 39)
	event.ObjsInit(5, 39)
	event.ObjsSyncObj(5, 4)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.EohSyncChara(5, 40)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 5)
	event.CharaActive(0, 40)
	event.LoadMes(0, 5, "event/e200/e285/e285_1.txt")
end

--- Helper function.
local function helper_2e378()
	event.SetFadeIn(30)
	event.SndSePlay(global8, 0)
	event.CmrsMove(111.21, 97.1, 1515.22, 354.23, 94.23, 1247.17, 540)
	helper_25abe6d2(50)
	helper_c28d4a31(2850010, -1)
	helper_c624bc16()
	helper_25abe6d2(30)
	event.SndSeStop(global8, 0)
end

--- Helper function.
local function helper_2e560()
	event.ObjsSetMotion(0, "立ち", 0)
	event.ObjsSetMotion(1, "立ち", 0)
	helper_25abe6d2(15)
	helper_e34416e2(2850020)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "もごもご")
	helper_25abe6d2(30)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "ふんっ")
	helper_25abe6d2(30)
	event.CharaActive(1, 38)
	event.SetWind(40.0, -96.86, 52.75, 388.46)
	event.SetMotion(38, "鼻爆発", 2, -1, 1)
	event.SndSePlay(global8, 1)
	helper_25abe6d2(15)
	event.SetWind(-1)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsSetMotion(1, "おどろき", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.ObjsNextMotion(1, "おどろきL", 4)
	helper_25abe6d2(90)
	event.CharaActive(1, 39)
	event.SetMotion(39, "キラキラ（ループ）", 4, -1, 1)
	event.SndSePlay(global8, 2)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 150)
	event.ObjsAddPas(5, 12.99, 142.28, 609.6)
	event.ObjsAddPas(5, 12.99, 35.2, 609.6)
	event.ObjsStartPas(5)
	event.ObjsSetMotion(0, "キラキラ見る", 2)
	event.ObjsSetMotion(1, "おどろきＬから上向き立ち", 2)
	helper_25abe6d2(150)
	event.ObjsNextMotion(0, "取る", 6)
	event.ObjsNextMotion(1, "上向く戻り", 6, 0.025)
	event.ObjsNextMotion(0, "取るL", 4)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_25abe6d2(20)
	event.SetMotion(39, "消える", 2, -1, 1)
	helper_25abe6d2(30)
	helper_0958ca60(0)
	event.CharaActive(0, 39)
end

--- Helper function.
local function helper_2ef80()
	event.ObjsSetPos(6, 5.99, 36.82, 613.24)
	event.ObjsSetRot(6, 0.0, -2.92, 0.0)
	event.CharaActive(1, 36)
	event.CharaActive(1, 40)
	event.SndSePlay(global8, 3)
	event.SndSePlay(global8, 4)
	event.SndPauseBgm()
	event.SndSePlay(global9, 0)
	event.ObjsSetMotion(6, "発動", 6)
	event.SetReference(global0, "gun_hand", 36)
	event.ObjsSetMotion(0, "銃ゲット", 4)
	helper_25abe6d2(15)
	helper_e8257c69(31, 1)
	event.DelReference(36)
	event.CharaActive(0, 40)
	event.SndSeStop(global9, 0)
	event.PlayBgm(0)
end

--- Helper function.
local function helper_2fac8()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
	event.DeleteChara(36)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
end

--- Helper function.
local function helper_30ea4()
	vm.section(function()
		event.SetFlag(285, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.LoadSound(2517)
		global8 = event.SndLoadSound_2(2517) or global8
		global9 = event.SndLoadSound_3(8, "snd2/sp/sp_006.sound.json") or global9
		helper_2fed4()
		event.InitDramaScene()
		event.EohSetFootSoundId(0, 1)
		event.EohSetFootSoundId(1, 1)
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.SetCharaPos(38, -96.86, 52.75, 388.46)
		event.SetCharaRot(38, 0.0, 0.0, 0.0)
		event.SetCharaPos(39, 37.43, 34.75, 561.52)
		event.SetCharaRot(39, 0.0, 0.0, 0.0)
		event.CmrsSetPos(111.21, 97.1, 1515.22)
		event.CmrsSetRef(-186.27, 94.23, 1323.31)
		event.ObjsSetPos(0, 13.4, 6.52, 613.7)
		event.ObjsSetRot(0, 0.0, -2.92, 0.0)
		event.ObjsSetPos(1, 47.24, 7.54, 600.38)
		event.ObjsSetRot(1, 0.0, -2.2, 0.0)
		helper_2e378()
		event.CmrsSetPos(46.15, 36.68, 848.41)
		event.CmrsSetRef(38.64, 44.8, 724.85)
		helper_2e560()
		event.CmrsSetPos(3.9, 53.24, 586.95)
		event.CmrsSetRef(8.68, 32.62, 613.94)
		helper_2ef80()
		event.CmrsSetPos(46.15, 36.68, 848.41)
		event.CmrsSetRef(38.64, 44.8, 724.85)
		helper_81875e60()
	end)
	event.CancelDramaScene()
	event.SndSeStop(global8, 0)
	event.SetWind(-1)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	helper_2fac8()
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_17c30(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var17: s32 = 0
	local active_chr_no_2: s32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetMotion(0, "立ち")
		if arg4 == 0 then
			event.SetLoadbgFile_2("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
		else
			event.SetLoadbgFile_2("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
		end
		event.CmrsInit()
		event.CmrsFadeInit()
		event.CmrsFadeOut(30)
		at = 1
		helper_c624bc16()
		event.InitDramaScene()
		event.SetSkipBotton(20)
		event.SetSkipFcol(255.0, 255.0, 255.0)
		event.SetCharaShow(120, 0)
		event.SetCharaShow(121, 0)
		event.AssignStack(5)
		event.ClearStack(5)
		event.SetWorldCoord(arg0, arg1, arg2, arg3)
		at = 2
		helper_479dc9e9()
		if arg4 == 0 then
			event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
			event.CharaActive(35)
			event.SetCharaType(35, 4)
			event.EohSyncChara(3, 35)
			event.ObjsInit(3)
			event.ObjsSyncObj(3, 3)
			event.ObjsSetPos(3, 0.0, 70.0, 0.0)
			event.ObjsSetRot(3, 0.0, 0.0, 0.0)
			event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
			event.CharaActive(36)
			event.SetCharaType(36, 4)
			event.EohSyncChara(4, 36)
			event.ObjsInit(4)
			event.ObjsSyncObj(4, 4)
			event.ObjsSetPos(4, 0.0, 0.88, 0.0)
			event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		else
			event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
			event.CharaActive(35)
			event.SetCharaType(35, 4)
			event.EohSyncChara(3, 35)
			event.ObjsInit(3)
			event.ObjsSyncObj(3, 3)
			event.ObjsSetPos(3, 0.0, 70.0, 0.0)
			event.ObjsSetRot(3, 0.0, 0.0, 0.0)
			event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
			event.CharaActive(36)
			event.SetCharaType(36, 4)
			event.EohSyncChara(4, 36)
			event.ObjsInit(4)
			event.ObjsSyncObj(4, 4)
			event.ObjsSetPos(4, 0.0, 0.88, 0.0)
			event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
			event.CharaActive(34)
			event.EohSyncChara(2, 34)
			event.EohSetPos(2, 23.24, 0.0, -46.31)
			event.EohSetRot(2, 0.0, -0.44, 0.0)
			event.EohSetTexAnim(2, 0)
		end
		if arg5 ~= 0 then
			active_chr_no = event.GetActiveChrNo() or active_chr_no
			if active_chr_no == 1 then
				event.GetEquipItemno(0, 2)
				event.GetEquipItemno(0, 3)
				event.GetEquipItemno(0, 4)
			end
			if active_chr_no == 0 then
				event.GetEquipItemno(1, 2)
				event.GetEquipItemno(1, 3)
				event.GetEquipItemno(1, 4)
			end
			if active_chr_no == 1 then
				event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
				event.CharaActive(0)
				event.EohSyncChara(0, 0)
				event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
				event.CharaActive(33)
				event.EohSyncChara(1, 33)
				event.LoadEquip(5, 0, 4, "info", 33)
				event.LoadEquip(5, 0, 3, "info", 33)
				event.LoadEquip(5, 0, 2, "info", 33, 37)
				event.CharaActive(37)
				event.EohSyncChara(5, 37)
			end
			if active_chr_no == 0 then
				event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
				event.CharaActive(32)
				event.EohSyncChara(0, 32)
				event.LoadEquip(5, 1, 4, "info", 32)
				event.LoadEquip(5, 1, 3, "info", 32)
				event.LoadEquip(5, 1, 2, "info", 32, 37)
				event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 32)
				event.CharaActive(37)
				event.EohSyncChara(5, 37)
				event.CharaActive(0)
				event.EohSyncChara(1, 0)
			end
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
			event.ObjsSetPos(0, 3.19, 0.0, -55.28)
			event.ObjsSetRot(0, 0.0, 0.0, 0.0)
			event.ObjsSetMotion(0, "立ち", 4, 0.02)
			event.ObjsResetDaPosition(0)
			event.ObjsTexAnime(0, 0)
			event.EohSetPos(1, -23.79, 0.0, -39.77)
			event.EohSetRot(1, 0.0, 0.64, 0.0)
			event.EohSetMotion(1, "立ち", 0.02)
		else
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
			event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
			event.ObjsSetPos(0, 3.19, 0.0, -55.28)
			event.ObjsSetRot(0, 0.0, 0.0, 0.0)
			event.ObjsSetMotion(0, "立ち", 4, 0.02)
			event.ObjsResetDaPosition(0)
			event.ObjsTexAnime(0, 0)
		end
		flag = event.GetFlag(612) or flag
		if flag ~= 0 then
			var12 = event.SndLoadSound_3(8, "snd2/sp/sp_043.sound.json") or var12
		else
			var13 = event.SndLoadSound_3(8, "snd2/sp/sp_013.sound.json") or var13
		end
		if arg4 == 0 then
			event.SetLoadbgFile_2("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
		else
			event.SetLoadbgFile_2("event/time_gate/red/atora_shine2.chr", "event/time_gate/red/atora_glare2.chr")
		end
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsSetPos(0, 0.0, 0.0, 0.0)
		event.ObjsResetDaPosition(0)
		if flag ~= 0 then
			event.SndSePlay(var12, 0)
		else
			event.SndSePlay(var13, 0)
			at = 3
			helper_25abe6d2(20)
		end
		event.SetFadeIn(30)
		if flag ~= 0 then
			event.CmrsSetPos(21.59, 19.4, 49.13)
			event.CmrsSetRef(3.27, 21.44, 1.91)
		else
			event.CmrsSetPos(-1.62, 25.82, 35.3)
			event.CmrsSetRef(-0.26, 22.33, -0.02)
		end
		event.ObjsSetMotion(0, "タイムワープ", 6)
		event.ObjsNextMotion(0, "タイムワープL", 5)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "目を閉じる")
		event.ObjsTexAnime(0, 1, "すまし口")
		at = 4
		helper_0958ca60(0)
		at = 5
		helper_479dc9e9()
		if arg4 == 0 then
			event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
		else
			event.LoadChara(5, "event/time_gate/red/atora_shine2.chr", "info", 38)
		end
		if flag ~= 0 then
			event.CharaActive(0, 38)
		else
			event.CharaActive(1, 38)
		end
		event.SetCharaType(38, 4)
		event.EohSyncChara(6, 38)
		event.ObjsInit(6)
		event.ObjsSyncObj(6, 6)
		do
			local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.ObjsSetPos(6, pos_x + vm.f32(0.18), pos_y + vm.f32(0.02), pos_z + vm.f32(0.3))
		event.ObjsSetRot(6, 0.0, 0.0, 0.0)
		var17 = event.GetEquipItemno(1, 4) or var17
		if var17 == 263 then
			print("pumpkin---------------------------\n")
			event.ObjsSetPos(6, -0.35, 22.68, 1.67)
			event.ObjsSetRot(6, 0.0, -6.33, 0.0)
		end
		if var17 == 264 then
			print("stripte -----------------------------\n")
			event.ObjsSetPos(6, -0.48, 22.78, 2.07)
			event.ObjsSetRot(6, 0.0, -6.4, 0.0)
		end
		if var17 == 265 then
			event.ObjsSetPos(6, -0.33, 22.73, 1.95)
			event.ObjsSetRot(6, 0.0, -6.4, 0.0)
		end
		if var17 == 266 then
			print("princess-----------------------------\n")
			event.ObjsSetPos(6, -0.42, 22.89, 1.99)
			event.ObjsSetRot(6, 0.0, -6.4, 0.0)
		end
		if var17 == 267 then
			print("separate----------------------------\n")
			event.ObjsSetPos(6, -0.23, 23.26, 2.52)
			event.ObjsSetRot(6, 0.0, -6.4, 0.0)
		end
		event.ObjsSetMotion(0, "タイムワープL", 5)
		event.ObjsSetMotion(6, "発動", 6)
		event.ObjsNextMotion(6, "発動L", 4)
		event.ObjsTexAnime(0, 0, "目を閉じる")
		event.ObjsTexAnime(0, 1, "閉じたまま")
		event.ObjsTexAnime(0, 1, "すまし口")
		if flag ~= 0 then
			event.SndSePlay(var12, 2)
		end
		at = 6
		helper_0958ca60(6)
		if arg4 == 0 then
			event.LoadChara(5, "event/time_gate/blue/atora_glare2.gltf", "info", 39)
		else
			event.LoadChara(5, "event/time_gate/red/atora_glare2.chr", "info", 39)
		end
		event.CharaActive(39)
		event.SetCharaType(39, 4)
		event.EohSyncChara(7, 39)
		event.ObjsInit(7)
		event.ObjsSyncObj(7, 7)
		event.ObjsSetPos(7, 0.0, 0.88, 0.0)
		event.ObjsSetRot(7, 0.0, 0.0, 0.0)
		event.CmrsSetPos(-2.99, 25.82, 71.15)
		event.CmrsSetRef(-0.26, 22.33, 0.02)
		event.CmrsMove2(-7.1, 25.8, 178.24, -0.26, 45.36, 0.02, 90, 0, 0.4)
		event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
		event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
		event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
		at = 7
		helper_25abe6d2(60)
		event.SetFadeOut(60, 255.0, 255.0, 255.0)
		at = 8
		helper_25abe6d2(60)
		at = 9
		helper_e62603eb(0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			helper_d3f20302(20)
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			helper_344d6cd8()
		end
		if at <= 5 then
			print("pumpkin---------------------------\n")
			print("stripte -----------------------------\n")
			print("princess-----------------------------\n")
			print("separate----------------------------\n")
			helper_238b5abc(6)
		end
		if at <= 6 then
			helper_d3f20302(60)
		end
		if at <= 7 then
			helper_d3f20302(60)
		end
		if at <= 8 then
			helper_bbae31fd(0)
		end
		return true
	end)
	event.CancelDramaScene()
	if flag ~= 0 then
		event.SndSeStop(var12, 0)
	end
	event.FadeOutBgm(30)
	event.SndSeStop(var13, 0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
	event.DeleteChara(37)
	if active_chr_no_2 == 1 then
		event.DelExtMotion(0)
		event.DeleteChara(33)
	end
	if active_chr_no_2 == 0 then
		event.DeleteChara(32)
	end
	if now_party_chara_id ~= -1 then
		event.DeleteChara(34)
	end
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(38)
	event.DeleteChara(39)
end

--- Helper function.
local function helper_1b510(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	var4 = event.JoinPartyMember(1) or var4
	if var4 == 1 then
		helper_17c30(arg0, arg1, arg2, arg3, 0, 1)
	else
		flag = event.GetFlag(520) or flag
		flag_2 = event.GetFlag(532) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			flag_3 = event.GetFlag(522) or flag_3
			if flag_3 == 0 then
				helper_4ffd117f(arg0, arg1, arg2, arg3)
			end
		end
		helper_145322be(arg0, arg1, arg2, arg3, 0, 0)
	end
	event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
end

--- Helper function.
local function helper_268e0()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e277/e277_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e277/e277_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e277/e277_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e277/e277_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e277/e277_hima_b.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2, 35)
	event.ObjsSyncObj(2, 2)
	event.LoadMes(0, 5, "event/e200/e277/e277_1.txt")
end

--- Helper function.
local function helper_22d00000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_265e4()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(35)
end

--- Helper function.
local function helper_27664()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(277, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetFadeOut(30)
		at = 1
		helper_25abe6d2(45)
		event.LoadSound(2509)
		var4 = event.SndLoadSound_2(2509) or var4
		helper_268e0()
		event.InitDramaScene()
		event.EohSetFootSoundId(0, 1)
		event.EohSetFootSoundId(1, 1)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CmrsSetPos(-117.43, 40.09, 1220.9)
		event.CmrsSetRef(-24.54, 60.52, 1410.11)
		event.SetCharaPos(0, -297.56, 0.0, -373.68)
		event.SetCharaRot(0, 0.0, 2.57, 0.0)
		event.ObjsSetPos(0, -130.99, 21.7, 1253.92)
		event.ObjsSetRot(0, 0.0, 0.77, 0.0)
		event.ObjsSetPos(1, -113.36, 16.04, 1218.2)
		event.ObjsSetRot(1, 0.0, 0.17, 0.0)
		event.SetFadeIn(30)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsSetMotion(1, "歩き")
		at = 2
		helper_25abe6d2(15)
		event.ObjsMove(0, -76.57, 22.37, 1326.65, 90, 1)
		event.ObjsMove(1, -99.28, 16.04, 1239.49, 30, 1)
		at = 3
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "立ち")
		at = 4
		helper_c28d4a31(2770010, -1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsRotation(0, 0.0, -2.87, 0.0, 20)
		at = 5
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "立ち")
		at = 6
		helper_c28d4a31(2770020, 60)
		event.CmrsSetPos(-88.03, 39.16, 1280.67)
		event.CmrsSetRef(-98.45, 39.74, 1240.52)
		event.SetReference(global1, "item", 35)
		event.CharaActive(1, 35)
		event.SndSePlay(var4, 0)
		event.ObjsSetMotion(1, "バッチ持ち立ち", 4)
		at = 7
		helper_25abe6d2(15)
		event.ObjsSetMotion(1, "バッチ持ち会話", 2)
		event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 8
		helper_e34416e2(2770030)
		event.ResetPakuAnim()
		at = 9
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "バッチ持ち会話", 2)
		event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 10
		helper_e34416e2(2770040)
		event.ResetPakuAnim()
		at = 11
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "バッチ持ち会話", 2)
		event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 12
		helper_e34416e2(2770050)
		event.ResetPakuAnim()
		at = 13
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "バッチ持ち立ち")
		at = 14
		helper_25abe6d2(30)
		event.CharaActive(0, 35)
		event.DelReference(35)
		event.CmrsSetPos(-117.43, 40.09, 1220.9)
		event.CmrsSetRef(-24.54, 60.52, 1410.11)
		event.ObjsSetMotion(0, "やったね", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.SetPakuAnim(0, "わらい口パク")
		at = 15
		helper_e34416e2(2770060)
		event.ResetPakuAnim()
		at = 16
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "会話", 2)
		event.ObjsNextMotion(0, "立ち", 4)
		event.SetPakuAnim(0, "わらい口パク")
		at = 17
		helper_e34416e2(2770065)
		event.ResetPakuAnim()
		at = 18
		helper_0958ca60(0)
		at = 19
		helper_c28d4a31(2770070, 150)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMove(1, -60.53, 20.6, 1300.47, 60, 1)
		event.CmrsMove(-133.69, 30.07, 1231.38, -2.07, 60.52, 1392.67, 150)
		event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		at = 20
		helper_c28d4a31(2770080, -1)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsRotation(0, 0.0, 0.89, 0.0, 30)
		at = 21
		helper_0958ca60(0)
		event.ObjsMove(0, -42.89, 22.37, 1361.14, 60, 1)
		event.ObjsMove(1, -28.2, 20.64, 1346.17, 60, 1)
		at = 22
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22d00000()
			helper_d3f20302(15)
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			helper_52aadc70(2770010, -1)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_52aadc70(2770020, 60)
		end
		if at <= 6 then
			helper_d3f20302(15)
		end
		if at <= 7 then
			helper_8cd371d7(2770030)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			helper_8cd371d7(2770040)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_8cd371d7(2770050)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_d3f20302(30)
		end
		if at <= 14 then
			helper_8cd371d7(2770060)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_8cd371d7(2770065)
		end
		if at <= 17 then
			helper_238b5abc(0)
		end
		if at <= 18 then
			helper_52aadc70(2770070, 150)
		end
		if at <= 19 then
			helper_52aadc70(2770080, -1)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			helper_d3f20302(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SetFadeOut(30)
	at = 23
	helper_25abe6d2(30)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	helper_265e4()
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_10a9c()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
	var3 = 0
	if var2 == 100 then
		var4 = event.GetAnalyze(103) or var4
		if var4 == 0 then
			event.MesMake_2(
				0,
				"Ultimamente [UNI00e8] stato un po'\ntriste. Sembra che manchi\nqualcosa, sai? Comunque..."
			)
		else
			flag = event.GetFlag(280) or flag
			if flag == 0 then
				event.MesMake_2(
					0,
					"Jurak [UNI00e8] stato riportato in vita!\nStrano che non abbia pensato\na Jurak per tutto questo tempo."
				)
			else
				event.MesMake_2(
					0,
					"Meraviglioso! Anche la foresta [UNI00e8]\ntornata come prima. Jurak [UNI00e8] di\nbuon umore. Niente da ridire!"
				)
			end
		end
	end
	if var2 == 101 then
		flag_2 = event.GetFlag(280) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Ho un buon assortimento, sai?\nE ti offro un vero affare per\nfesteggiare il risveglio di Jurak."
			)
		else
			event.MesMake_2(0, "Grazie a voi, Jurak e l'intera\nforesta ora sono come prima.\nTornate quando volete!")
		end
	end
	if var2 == 104 then
		flag_3 = event.GetFlag(280) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Mmh... Quel Grifone l'ha proprio\nfatta grossa. Difficile credere\nche Jurak fosse scomparso davvero!"
			)
		else
			event.MesMake_2(
				0,
				"Jurak [UNI00e8] tornato, quindi [UNI00e8] il\nmomento di contrattaccare Grifone.\nSe rimaniamo uniti, vinceremo!"
			)
		end
	end
	if var2 == 102 then
		flag_4 = event.GetFlag(280) or flag_4
		if flag_4 == 0 then
			var9 = event.GetSavedataEtc(1, 52) or var9
			if var9 == 0 then
				event.MesMake_2(
					0,
					"Abbiamo ottenuto degli Stemmi\nMutazione in Mostro! Prendetene\nsubito uno, prima che sia tardi!"
				)
			else
				event.MesMake_2(
					0,
					"Questo era l'ultimo stemma. Meno\nmale che l'avete preso, non so\nquando riusciremo ad averne altri."
				)
			end
		else
			event.MesMake_2(0, "Stai usando lo Stemma Mutazione in\nMostro? Ce ne sono molti altri\ntipi, sai?")
			helper_927b384d(player_chara, var1, 0)
			helper_b5a98ffa(0, -1, var1, player_chara, 0)
			var3 = 1
			event.MesMake_2(
				0,
				"A volte, se dai ad un mostro tre\noggetti di suo interesse, sar[UNI00e0]\ncos[UNI00ec] felice da lasciar cadere uno<page>stemma, quando lo uccidi. Certo,\nti servir[UNI00e0] uno dei miei speciali\nporta-doni. Allora, che ne dici?"
			)
		end
	end
	if var2 == 103 then
		flag_5 = event.GetFlag(280) or flag_5
		if flag_5 == 0 then
			event.MesMake_2(0, "Salve! Mangi abbastanza?\nNon diventerai mai grande se\nnon mangi. Mangia, d'accordo?")
		else
			event.MesMake_2(0, "Jurak [UNI00e8] felice e gli affari\nvanno di bene in meglio.")
		end
	end
	if var2 == 105 then
		flag_6 = event.GetFlag(640) or flag_6
		if flag_6 == 0 then
			flag_7 = event.GetFlag(280) or flag_7
			if flag_7 == 0 then
				event.MesMake_2(
					0,
					"Mi chiedo cos'abbia fatto tutto\nquesto tempo! Non riesco proprio\na ricordare.<page>Ehi, se posso permettermi, hai\nproprio una bella tenuta l[UNI00ec]!"
				)
			else
				event.MesMake_2(
					0,
					"Allora stai per partire per nuove\nterre finalmente, eh? Bene, buona\nfortuna e buon viaggio!"
				)
			end
		else
			event.MesMake_2(
				0,
				"Sconfiggete l'Imperatore Grifone\ne riportate questi tempi oscuri\nalla normalit[UNI00e0]. Ci contiamo!"
			)
		end
	end
	if var3 == 0 then
		helper_907fd9a8(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_b5a98ffa(0, -1, var1, player_chara, 0)
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.GetRotLookPos(var17 - var14, var19 - var16) or var20
		helper_cfca3481(player_chara_2, var20)
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b5a98ffa(0, -1, var1, player_chara_2, 0)
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 101 then
		helper_59a16271(25)
	end
	if var2 == 102 then
		helper_59a16271(24)
	end
	if var2 == 103 then
		helper_59a16271(26)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local var8: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	event_99()
	old_map_no = event.GetOldMapNo() or old_map_no
	if old_map_no == 0 then
		event.SetCameraPos(39.03, 111.84, 77.64)
		event.SetCameraRef(36.78, 22.33, 74.62)
		event.SetFadeOut(0, 255, 255, 255)
		vm.wait(1)
		event.SetCameraPos(102.4, 73.47, 1368.2)
		event.SetCameraRef(102.4, 53.47, 1488.2)
		event.SetCharaPos(0, 110.0, 23.7, 1533.0)
		event.SetCharaRot(0, 0.0, -3.1415927, 0.0)
		event.ResetCamera(1, 3.14, 2.0)
	end
	event.SetFadeIn(30)
	event.GetFlag(250)
	event.GetFlag(260)
	event.GetFlag(270)
	event.GetFlag(272)
	event.GetFlag(275)
	event.GetFlag(280)
	event.GetFlag(285)
	var8 = event.GetAnalyze(103) or var8
	event.GetAnalyze(104)
	event.GetDioramaPercent(0)
	if var8 == 0 then
		return
	end
	if helper_e538a72d() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(270, 1)
		helper_1d334()
		event.SetCharaPos(0, 169.8, 23.7, 1378.8)
		return
	end
	if helper_342a37b0() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(272, 1)
		helper_21af4()
		event.AddItem(361)
		event.AddItem(308)
		argc = event.CheckGetItemLimit() or argc
		argc_2 = event.CheckItemOver() or argc_2
		if argc >= 1 or argc_2 >= 1 then
			event.SetFadeOut(10)
			helper_25abe6d2(10)
			event.GotoMenu(16)
			vm.wait(5)
			event.SetFadeIn(10)
		end
		return
	end
	if helper_ee09935e() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(275, 1)
		helper_66ac1f76()
		helper_259cc()
		return
	end
	if helper_b84429a4() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(280, 1)
		helper_29d88()
		return
	end
	if helper_c5ea1698() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(285, 1)
		helper_30ea4()
		event.AddItem(31)
		helper_a87eb945(1)
		return
	end
	event.SetCharaPos(0, 110.0, 23.7, 1533.0)
	event.SetCharaRot(0, 0.0, -3.1415927, 0.0)
	event.ResetCamera(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_21af4

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_1b510(100.0, vm.f32(23.67), 1500.0, 0.0)
	event.MapJump_2(-1, "g01")
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	event.FuncPointShow("", "e277", 0)
	event.SetFlag(277, 1)
	helper_27664()
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local player_chara: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local argc: s32 = 0
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
	event.SetCameraNextPos(-140.41, 35.58, 1026.08)
	event.SetCameraNextRef(23.01, 135.7, 535.77)
	player_chara = event.GetControlChrid() or player_chara
	helper_81af0537(player_chara, 0.0, 300.0)
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 0)
	flag = event.GetFlag(640) or flag
	if flag == 0 then
		flag_2 = event.GetFlag(372) or flag_2
		if flag_2 == 0 then
			flag_3 = event.GetFlag(280) or flag_3
			if flag_3 == 0 then
				flag_4 = event.GetFlag(275) or flag_4
				if flag_4 == 0 then
					flag_5 = event.GetFlag(272) or flag_5
					if flag_5 == 0 then
						event.MesMake_2(
							0,
							"Seeembra proprio che non rieeesca\na ricordare nuuulla. Immaggino\nmi seerva solo dell'altro teeempo."
						)
					else
						event.MesMake_2(
							0,
							"Il seeeeme [UNI00e8] stato piaaaantato?\nE sta iniziando a geeeermogliare?<page>Era un reeeegalo, quindi faaatene\nbuon uso, caaaapito?"
						)
					end
				else
					argc = event.GetItemNum(356) or argc
					if argc <= 0 then
						event.MesMake_2(
							0,
							"Per avere una Goccia del Sole\nparlate con un mostro Himarra.\nPer farlo, usate lo stemma."
						)
						helper_a3cc6850(0, -1, 3, 0, 416)
						event.MesMake_2(
							0,
							"Per diventare una Himarraaaa, ti\nserve uno Steeeemma di Himarra.<page>A volte li vendono\nnei neeeegozi di veeeestiti.<page>Oh, s[UNI00ec][UNI00ec][UNI00ec][UNI00ec]! C'[UNI00e8] un neeeegozio\ndi veeeestiti nel mio naaaaso."
						)
						helper_a3cc6850(0, -1, 3, 0, 416)
						event.MesMake_2(0, "La narice destra [UNI00e8] ancora vuoota.\nSto cercando un inquiiilino.")
					else
						event.MesMake_2(
							0,
							"Avete trovato la Goccia del Sole!\nOra, usate la Goccia del Sole dove\navete piantato la Lafrescia, OK?<page>Spero proprio che troviate\nla Farfalla Arcobaleno. Pregher[UNI00f2]\nper voi in battaglia, d'accordo?"
						)
					end
				end
			else
				event.MesMake_2(
					0,
					"Chiedete maggiori dettagli a\nCrest, il Grande Saggio nel tempio\ndella Valle dell'Equilibrio, OK?<page>Vi dir[UNI00e0] tutto quello che dovete\nsapere... molto\nrassicurante!"
				)
			end
		else
			event.MesMake_2(
				0,
				"Bene, bene, a quanto pare siete\nandati da Crest. Vero?\nBen fatto.<page>Ma avete ancora molta strada\nda fare. Non arrendetevi\nproprio ora, d'accordo?"
			)
		end
	else
		event.MesMake_2(
			0,
			"Allora, state andando a combattere\nGrifone, vero? Ma c'[UNI00e8] qualcosa\nche ancora mi turba.<page>Percepisco anche uno spirito\ngentile racchiuso in\nGrifone. Strano, no?"
		)
	end
	helper_a3cc6850(0, -1, 3, 0, 416)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetCrossfade(10)
end

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	local flag: s32 = 0
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(36) or flag
	if flag == 0 then
		event.SetFlag(36, 1)
		event.AddItem(376)
		helper_e8257c69(376, 1)
		helper_a87eb945(1)
	else
		helper_125385ee(0, 1)
		event.MesMake_2(0, "Mi chiedo cosa uscir[UNI00e0] da questo\nuovo?")
		helper_a3cc6850(0, -1, 5, 256, 208)
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_30ea4()
	event.SetFadeIn(30)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_10a9c

--- Event 12700, which map data, a script or the engine runs by number.
function script.event_12700()
	event.DbgSetAnalyzeFlag(0, 4, 0)
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.SetFlag(270, 0)
	event.SetFlag(272, 1)
	event.SetFlag(275, 1)
	event.SetFlag(277, 1)
	event.SetFlag(280, 1)
	event.SetFlag(285, 1)
	event.MapJump_3(-1, 25, 100)
	vm.wait(1)
end

--- Event 12720, which map data, a script or the engine runs by number.
function script.event_12720()
	event.DbgSetAnalyzeFlag(0, 4, 0)
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 0)
	event.SetFlag(275, 1)
	event.SetFlag(277, 1)
	event.SetFlag(280, 1)
	event.SetFlag(285, 1)
	event.MapJump_3(-1, 25, 100)
	vm.wait(1)
end

--- Event 12750, which map data, a script or the engine runs by number.
function script.event_12750()
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.DbgSetAnalyzeFlag(0, 4, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 1)
	event.SetFlag(275, 0)
	event.SetFlag(277, 1)
	event.SetFlag(280, 1)
	event.SetFlag(285, 1)
	event.MapJump_3(-1, 25, 100)
	vm.wait(1)
end

--- Event 12770, which map data, a script or the engine runs by number.
function script.event_12770()
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.DbgSetAnalyzeFlag(0, 4, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 1)
	event.SetFlag(275, 1)
	event.SetFlag(277, 0)
	event.SetFlag(280, 1)
	event.SetFlag(285, 1)
	event.SetSavedataEtc(1, 52, 1)
	event.MapJump_3(-1, 25, 400)
	vm.wait(1)
end

--- Event 12800, which map data, a script or the engine runs by number.
function script.event_12800()
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.DbgSetAnalyzeFlag(0, 4, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 1)
	event.SetFlag(275, 1)
	event.SetFlag(277, 1)
	event.SetFlag(280, 0)
	event.SetFlag(285, 1)
	event.SetFlag(260, 1)
	event.MapJump_3(-1, 25, 100)
	vm.wait(1)
end

--- Event 12850, which map data, a script or the engine runs by number.
function script.event_12850()
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.DbgSetAnalyzeFlag(0, 4, 1)
	event.DbgSetAnalyzeFlag(0, 5, 1)
	event.DbgSetAnalyzeFlag(0, 6, 1)
	event.DbgSetAnalyzeFlag(0, 7, 1)
	event.DbgSetAnalyzeFlag(0, 8, 1)
	event.DbgSetAnalyzeFlag(0, 9, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 1)
	event.SetFlag(275, 1)
	event.SetFlag(277, 1)
	event.SetFlag(280, 1)
	event.SetFlag(285, 0)
	event.MapJump_3(-1, 25, 100)
	vm.wait(1)
end

return script
