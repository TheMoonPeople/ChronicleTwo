--!strict
-- map/f/f01/f01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_063cfcfb = require("@lib/event/helper_063cfcfb")
local helper_09b3df30 = require("@lib/event/helper_09b3df30")
local helper_199cf264 = require("@lib/event/helper_199cf264")
local helper_1d80d1e0 = require("@lib/event/helper_1d80d1e0")
local helper_2a30e517 = require("@lib/event/helper_2a30e517")
local helper_342a37b0 = require("@lib/event/helper_342a37b0")
local helper_66ac1f76 = require("@lib/event/helper_66ac1f76")
local helper_7f11d45e = require("@lib/event/helper_7f11d45e")
local helper_9e5786f5 = require("@lib/event/helper_9e5786f5")
local helper_a0f05df8 = require("@lib/event/helper_a0f05df8")
local helper_b84429a4 = require("@lib/event/helper_b84429a4")
local helper_c5ea1698 = require("@lib/event/helper_c5ea1698")
local helper_d1db54d2 = require("@lib/event/helper_d1db54d2")
local helper_d4a58ede = require("@lib/event/helper_d4a58ede")
local helper_d991b5ca = require("@lib/event/helper_d991b5ca")
local helper_d9cceed5 = require("@lib/event/helper_d9cceed5")
local helper_da7f7ffe = require("@lib/event/helper_da7f7ffe")
local helper_dc33e260 = require("@lib/event/helper_dc33e260")
local helper_e1b436d6 = require("@lib/event/helper_e1b436d6")
local helper_e538a72d = require("@lib/event/helper_e538a72d")
local helper_ee09935e = require("@lib/event/helper_ee09935e")
local helper_f914cb3a = require("@lib/event/helper_f914cb3a")

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

--- Program 99.
local function program_99()
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
		event.EohSyncObj(1, "p11_f0101")
		event.EohSetShow(1, 0)
	end
	helper_66ac1f76()
	event.SetCharaPos(0, 205.1, -6.0, 894.1)
end

--- Helper function.
local function helper_1c6d8()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global2 = 0
		global3 = 33
		global2 = 33
		global3 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_1c400()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
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
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 46 then
			if at <= 1 then
				helper_1c6d8()
				helper_2a30e517(15)
			end
			if at <= 2 then
				helper_d1db54d2(1)
			end
			if at <= 3 then
				helper_2a30e517(5)
			end
			if at <= 4 then
				helper_d1db54d2(0)
			end
			if at <= 5 then
				helper_2a30e517(5)
			end
			if at <= 6 then
				helper_2a30e517(60)
			end
			if at <= 7 then
				helper_1d80d1e0(2700010)
			end
			if at <= 8 then
				helper_1d80d1e0(2700020)
			end
			if at <= 9 then
				helper_2a30e517(30)
			end
			if at <= 10 then
				helper_d1db54d2(1)
			end
			if at <= 11 then
				helper_d1db54d2(1)
			end
			if at <= 12 then
				helper_1d80d1e0(2700030)
			end
			if at <= 13 then
				helper_2a30e517(30)
			end
			if at <= 14 then
				helper_2a30e517(15)
			end
			if at <= 15 then
				helper_1d80d1e0(2700040)
			end
			if at <= 16 then
				helper_1d80d1e0(2700050)
			end
			if at <= 17 then
				helper_1d80d1e0(2700055)
			end
			if at <= 18 then
				helper_2a30e517(60)
			end
			if at <= 19 then
				helper_dc33e260(2700060, -1)
			end
			if at <= 20 then
				helper_2a30e517(30)
			end
			if at <= 21 then
				helper_2a30e517(15)
			end
			if at <= 23 then
				helper_1d80d1e0(2700070)
			end
			if at <= 24 then
				helper_d1db54d2(1)
			end
			if at <= 25 then
				helper_1d80d1e0(2700080)
			end
			if at <= 26 then
				helper_d1db54d2(1)
			end
			if at <= 27 then
				helper_2a30e517(30)
			end
			if at <= 28 then
				helper_2a30e517(15)
			end
			if at <= 29 then
				helper_dc33e260(2700090, 120)
			end
			if at <= 30 then
				helper_dc33e260(2700095, 120)
			end
			if at <= 31 then
				helper_dc33e260(2700100, 230)
			end
			if at <= 32 then
				helper_dc33e260(2700110, 200)
			end
			if at <= 33 then
				helper_dc33e260(2700120, -1)
			end
			if at <= 34 then
				helper_1d80d1e0(2700130)
			end
			if at <= 35 then
				helper_d1db54d2(1)
			end
			if at <= 36 then
				helper_2a30e517(30)
			end
			if at <= 37 then
				helper_2a30e517(15)
			end
			if at <= 38 then
				helper_1d80d1e0(2700140)
			end
			if at <= 39 then
				helper_1d80d1e0(2700150)
			end
			if at <= 40 then
				helper_1d80d1e0(2700153)
			end
			if at <= 41 then
				helper_2a30e517(30)
			end
			if at <= 42 then
				helper_2a30e517(15)
			end
			if at <= 43 then
				helper_dc33e260(2700155, -1)
			end
			if at <= 44 then
				helper_2a30e517(30)
			end
			if at <= 45 then
				helper_2a30e517(35)
			end
			if vm.skip_end() then
				return skip(47)
			end
			return part2()
		end
		helper_1c400()
	end
	function part2()
		event.CancelDramaScene()
		event.SetWind(-1)
		event.SndSeStop(var4, 2)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_1c400()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(270, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.SetFadeOut(30)
	helper_2a30e517(45)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(2500)
	var4 = event.SndLoadSound(2500) or var4
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
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(2)
	end
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
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsRotation(1, 0.0, -2.75, 0.0, 5)
	helper_2a30e517(5)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "立ち", 0)
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsRotation(0, 0.0, 3.05, 0.0, 5)
	helper_2a30e517(5)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち", 0)
	event.SndSeStop(var4, 2)
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(7)
	end
	helper_1d80d1e0(2700010)
	if vm.skipping() then
		return skip(8)
	end
	helper_1d80d1e0(2700020)
	if vm.skipping() then
		return skip(9)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(25.23, 45.67, 520.07)
	event.CmrsSetRef(56.48, 39.42, 567.84)
	event.ObjsMove(1, 58.3, 15.55, 557.33, 10, 1)
	event.ObjsSetMotion(1, "歩き", 2)
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "立ち", 2)
	event.ObjsNextMotion(1, "上向く", 6)
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsNextMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 0)
	helper_1d80d1e0(2700030)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(64.19, 10.12, 750.23)
	event.CmrsSetRef(30.64, 90.8, 392.13)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "右向く戻り")
	event.ObjsNextMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_1d80d1e0(2700040)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_1d80d1e0(2700050)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_1d80d1e0(2700055)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "風", 6)
	event.ObjsNextMotion(0, "風Ｌ", 4)
	event.ObjsSetMotion(1, "風", 6)
	event.ObjsNextMotion(1, "風Ｌ", 4)
	event.SndSePlay(var4, 3)
	event.SetWind(40.0, 34.48, 48.5, 396.61)
	helper_dc33e260(2700060, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.SetWind(-1)
	event.ObjsSetMotion(0, "風戻り", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "風戻り", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(25.23, 45.67, 520.07)
	event.CmrsSetRef(56.48, 39.42, 567.84)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(22)
	end
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
	if vm.wait() then
		return skip(23)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2700070)
	if vm.skipping() then
		return skip(24)
	end
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionWait(1)
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向くL", 6)
	event.ObjsNextMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2700080)
	if vm.skipping() then
		return skip(26)
	end
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsMotionWait(1)
	event.ResetPakuAnim()
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(28)
	end
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
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_dc33e260(2700090, 120)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_dc33e260(2700095, 120)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_dc33e260(2700100, 230)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_dc33e260(2700110, 200)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_dc33e260(2700120, -1)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(40.68, 60.8, 523.12)
	event.CmrsSetRef(50.29, 32.81, 569.09)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.ObjsMotionDelay(1, 110)
	event.ObjsSetMotion(1, "上向き会話2", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2700130)
	if vm.skipping() then
		return skip(35)
	end
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsMotionWait(1)
	event.ResetPakuAnim()
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(64.19, 10.12, 750.23)
	event.CmrsSetRef(30.64, 90.8, 392.13)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(38)
	end
	helper_1d80d1e0(2700140)
	if vm.skipping() then
		return skip(39)
	end
	helper_1d80d1e0(2700150)
	if vm.skipping() then
		return skip(40)
	end
	helper_1d80d1e0(2700153)
	if vm.skipping() then
		return skip(41)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(42)
	end
	event.CmrsSetPos(19.5, 49.85, 518.46)
	event.CmrsSetRef(52.88, 36.97, 566.51)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(43)
	end
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
	helper_dc33e260(2700155, -1)
	if vm.skipping() then
		return skip(44)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(45)
	end
	event.SetFadeOut(30)
	helper_2a30e517(35)
	if vm.skipping() then
		return skip(46)
	end
	return part2()
end

--- Helper function.
local function helper_20a74()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global4 = 0
		global5 = 32
		global4 = 32
		global5 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_20620()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
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
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 47 then
			if at <= 1 then
				helper_20a74()
				helper_2a30e517(15)
			end
			if at <= 2 then
				helper_d1db54d2(0)
			end
			if at <= 3 then
				helper_2a30e517(5)
			end
			if at <= 4 then
				helper_d1db54d2(1)
			end
			if at <= 5 then
				helper_2a30e517(5)
			end
			if at <= 6 then
				helper_2a30e517(60)
			end
			if at <= 7 then
				helper_1d80d1e0(2720010)
			end
			if at <= 8 then
				helper_d1db54d2(0)
			end
			if at <= 9 then
				helper_1d80d1e0(2720020)
			end
			if at <= 10 then
				helper_1d80d1e0(2720030)
			end
			if at <= 11 then
				helper_1d80d1e0(2720035)
			end
			if at <= 12 then
				helper_2a30e517(30)
			end
			if at <= 13 then
				helper_1d80d1e0(2720040)
			end
			if at <= 14 then
				helper_2a30e517(30)
			end
			if at <= 15 then
				helper_1d80d1e0(2720050)
			end
			if at <= 16 then
				helper_1d80d1e0(2720060)
			end
			if at <= 17 then
				helper_d1db54d2(0)
			end
			if at <= 18 then
				helper_1d80d1e0(2720070)
			end
			if at <= 19 then
				helper_2a30e517(30)
			end
			if at <= 20 then
				helper_2a30e517(15)
			end
			if at <= 21 then
				helper_1d80d1e0(2720080)
			end
			if at <= 22 then
				helper_2a30e517(30)
			end
			if at <= 23 then
				helper_2a30e517(15)
			end
			if at <= 24 then
				helper_1d80d1e0(2720090)
			end
			if at <= 25 then
				helper_2a30e517(30)
			end
			if at <= 26 then
				helper_2a30e517(30)
			end
			if at <= 27 then
				helper_2a30e517(15)
			end
			if at <= 28 then
				helper_2a30e517(90)
			end
			if at <= 29 then
				helper_2a30e517(120)
			end
			if at <= 30 then
				helper_2a30e517(30)
			end
			if at <= 31 then
				helper_9e5786f5(361, 1)
			end
			if at <= 32 then
				helper_1d80d1e0(2720100)
			end
			if at <= 33 then
				helper_1d80d1e0(2720110)
			end
			if at <= 34 then
				helper_2a30e517(15)
			end
			if at <= 35 then
				helper_1d80d1e0(2720120)
			end
			if at <= 36 then
				helper_2a30e517(15)
			end
			if at <= 37 then
				helper_1d80d1e0(2720130)
			end
			if at <= 38 then
				helper_1d80d1e0(2720140)
			end
			if at <= 39 then
				helper_1d80d1e0(2720150)
			end
			if at <= 40 then
				helper_2a30e517(30)
			end
			if at <= 41 then
				helper_1d80d1e0(2720160)
			end
			if at <= 42 then
				helper_1d80d1e0(2720165)
			end
			if at <= 43 then
				helper_1d80d1e0(2720170)
			end
			if at <= 44 then
				helper_9e5786f5(308, 1)
			end
			if at <= 45 then
				helper_2a30e517(120)
			end
			if at <= 46 then
				helper_e1b436d6(0, -1, 8, 0, 0)
			end
			if vm.skip_end() then
				return skip(48)
			end
			return part2()
		end
		if at <= 48 then
			helper_2a30e517(30)
		end
		helper_20620()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_2a30e517(30)
		if vm.skipping() then
			return skip(49)
		end
		event.SetWind(-1)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_20620()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_2a30e517(45)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(272, 1)
	event.LoadSound(2503)
	var10 = event.SndLoadSound(2503) or var10
	var11 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var11
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
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(0, 37.43, 14.75, 561.52, 240, 1)
	event.ObjsMove(1, 58.59, 15.55, 560.22, 270, 1)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(104.47, 46.8, 1479.26, 86.03, 73.72, 1247.28)
	event.CmrsAddPas(65.3, 46.8, 986.65, 46.86, 73.72, 754.67)
	event.CmrsStartPas()
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsRotation(0, 0.0, -3.11, 0.0, 5)
	helper_2a30e517(5)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "立ち", 0)
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsRotation(1, 0.0, -2.87, 0.0, 5)
	helper_2a30e517(5)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "上向くL", 0)
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "上向く", 2)
	event.ObjsNextMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_1d80d1e0(2720010)
	if vm.skipping() then
		return skip(8)
	end
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_1d80d1e0(2720020)
	if vm.skipping() then
		return skip(10)
	end
	helper_1d80d1e0(2720030)
	if vm.skipping() then
		return skip(11)
	end
	helper_1d80d1e0(2720035)
	if vm.skipping() then
		return skip(12)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(62.05, 41.42, 524.15)
	event.CmrsSetRef(28.43, 35.31, 613.0)
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d80d1e0(2720040)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(0, "上向くL", 4)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(65.3, 46.8, 986.65)
	event.CmrsSetRef(46.86, 73.72, 754.67)
	helper_1d80d1e0(2720050)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_1d80d1e0(2720060)
	if vm.skipping() then
		return skip(17)
	end
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(18)
	end
	helper_1d80d1e0(2720070)
	if vm.skipping() then
		return skip(19)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(35.55, 36.73, 529.53)
	event.CmrsSetRef(46.86, 52.13, 754.67)
	event.ObjsSetMotion(0, "考える", 4)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsMove2(35.81, 36.73, 534.67, 46.86, 52.13, 754.67, 30, 2, 1.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d80d1e0(2720080)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(283.52, 88.96, 846.8)
	event.CmrsSetRef(90.35, 78.53, 545.4)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(24)
	end
	helper_1d80d1e0(2720090)
	if vm.skipping() then
		return skip(25)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "もごもご")
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(26)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "ふんっ")
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(27)
	end
	event.CharaActive(1, 38)
	event.SetMotion(38, "鼻爆発", 2, -1, 1)
	event.SndSePlay(var10, 4)
	event.SetWind(40.0, -96.86, 52.75, 388.46)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(28)
	end
	event.SetWind(-1)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsSetMotion(1, "おどろき", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.ObjsNextMotion(1, "おどろきL", 4)
	helper_2a30e517(90)
	if vm.skipping() then
		return skip(29)
	end
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
	helper_2a30e517(120)
	if vm.skipping() then
		return skip(30)
	end
	event.SetMotion(39, "消える", 2, -1, 1)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(31)
	end
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
	helper_9e5786f5(361, 1)
	if vm.skipping() then
		return skip(32)
	end
	event.PlayBgm(0)
	event.DelReference(35)
	event.CharaActive(0, 40)
	event.CmrsSetPos(65.3, 46.8, 986.65)
	event.CmrsSetRef(46.86, 73.72, 754.67)
	event.ObjsSetRot(1, 0.0, -2.87, 0.0)
	event.ObjsSetMotion(0, "上向くL", 0)
	event.ObjsSetMotion(1, "上向くL", 0)
	helper_1d80d1e0(2720100)
	if vm.skipping() then
		return skip(33)
	end
	helper_1d80d1e0(2720110)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(40.41, 53.02, 519.29)
	event.CmrsSetRef(64.94, -1.06, 669.16)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(35)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1d80d1e0(2720120)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(65.3, 46.8, 986.65)
	event.CmrsSetRef(46.86, 73.72, 754.67)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(37)
	end
	helper_1d80d1e0(2720130)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_1d80d1e0(2720140)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_1d80d1e0(2720150)
	if vm.skipping() then
		return skip(40)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(40.41, 53.02, 519.29)
	event.CmrsSetRef(64.94, -1.06, 669.16)
	event.ObjsSetMotion(0, "あせり会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_1d80d1e0(2720160)
	if vm.skipping() then
		return skip(42)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "大口パク")
	event.ObjsSetMotion(0, "あせり会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_1d80d1e0(2720165)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(65.3, 46.8, 986.65)
	event.CmrsSetRef(46.86, 73.72, 754.67)
	event.ObjsSetMotion(0, "立ち", 4)
	helper_1d80d1e0(2720170)
	if vm.skipping() then
		return skip(44)
	end
	helper_9e5786f5(308, 1)
	if vm.skipping() then
		return skip(45)
	end
	event.CmrsSetPos(40.41, 53.02, 519.29)
	event.CmrsSetRef(64.94, -1.06, 669.16)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 6)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向く戻り", 6)
	event.ObjsNextMotion(1, "だめだめ", 6)
	event.ObjsNextMotion(1, "立ち", 6)
	helper_2a30e517(120)
	if vm.skipping() then
		return skip(46)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)] Per prendere una Goccia del\nSole, ti serve qualcosa che ti\npermetta di parlare all'Himarra.<page>Ottenere questo oggetto dipende anche\ndallo sviluppo del Diorama. Lavoraci\nsu e controlla il mondo futuro di Jurak."
	)
	helper_e1b436d6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(47)
	end
	event.SetMesPreset(0, 0)
	return part2()
end

--- Helper function.
local function helper_24f40()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_24c68()
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
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_24f40()
				helper_2a30e517(15)
			end
			if at <= 2 then
				helper_2a30e517(60)
			end
			if at <= 3 then
				helper_1d80d1e0(2750010)
			end
			if at <= 4 then
				helper_d991b5ca()
			end
			if at <= 5 then
				helper_2a30e517(30)
			end
			if at <= 6 then
				helper_2a30e517(15)
			end
			if at <= 7 then
				helper_1d80d1e0(2750020)
			end
			if at <= 8 then
				helper_1d80d1e0(2750030)
			end
			if at <= 9 then
				helper_2a30e517(60)
			end
			if at <= 10 then
				helper_2a30e517(35)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
		helper_24c68()
	end
	function part2()
		event.CancelDramaScene()
		helper_24c68()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(275, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_2a30e517(45)
	if vm.skipping() then
		return skip(1)
	end
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
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(2)
	end
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
		helper_2a30e517(60)
		if vm.skipping() then
			return skip(3)
		end
	end
	helper_1d80d1e0(2750010)
	if vm.skipping() then
		return skip(4)
	end
	helper_d991b5ca()
	if vm.skipping() then
		return skip(5)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(17.1, 20.28, 879.05)
	event.CmrsSetRef(14.71, 53.79, 698.03)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(7)
	end
	helper_1d80d1e0(2750020)
	if vm.skipping() then
		return skip(8)
	end
	helper_1d80d1e0(2750030)
	if vm.skipping() then
		return skip(9)
	end
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeOut(30)
	helper_2a30e517(35)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_2912c()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global6 = 0
		global7 = 32
		global6 = 32
		global7 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_28dfc()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
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
	event.MapJump(-1, "s26", 700)
end

--- Helper function.
local function helper_29d88()
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 70 then
			if at <= 1 then
				helper_2912c()
				helper_1d80d1e0(2800010)
			end
			if at <= 2 then
				helper_1d80d1e0(2800015)
			end
			if at <= 3 then
				helper_1d80d1e0(2800020)
			end
			if at <= 4 then
				helper_d1db54d2(1)
			end
			if at <= 5 then
				helper_2a30e517(30)
			end
			if at <= 6 then
				helper_2a30e517(15)
			end
			if at <= 7 then
				helper_1d80d1e0(2800030)
			end
			if at <= 8 then
				helper_1d80d1e0(2800040)
			end
			if at <= 9 then
				helper_2a30e517(30)
			end
			if at <= 10 then
				helper_2a30e517(15)
			end
			if at <= 11 then
				helper_1d80d1e0(2800050)
			end
			if at <= 12 then
				helper_d1db54d2(1)
			end
			if at <= 13 then
				helper_2a30e517(30)
			end
			if at <= 14 then
				helper_2a30e517(15)
			end
			if at <= 15 then
				helper_1d80d1e0(2800060)
			end
			if at <= 16 then
				helper_1d80d1e0(2800065)
			end
			if at <= 17 then
				helper_1d80d1e0(2800070)
			end
			if at <= 18 then
				helper_2a30e517(30)
			end
			if at <= 19 then
				helper_2a30e517(15)
			end
			if at <= 20 then
				helper_1d80d1e0(2800080)
			end
			if at <= 21 then
				helper_1d80d1e0(2800085)
			end
			if at <= 22 then
				helper_d1db54d2(0)
			end
			if at <= 23 then
				helper_2a30e517(30)
			end
			if at <= 24 then
				helper_2a30e517(15)
			end
			if at <= 25 then
				helper_1d80d1e0(2800090)
			end
			if at <= 26 then
				helper_d1db54d2(1)
			end
			if at <= 27 then
				helper_2a30e517(30)
			end
			if at <= 28 then
				helper_2a30e517(15)
			end
			if at <= 29 then
				helper_dc33e260(2800100, -1)
			end
			if at <= 30 then
				helper_d991b5ca()
			end
			if at <= 31 then
				helper_d991b5ca()
			end
			if at <= 32 then
				helper_dc33e260(2800110, 120)
			end
			if at <= 33 then
				helper_2a30e517(60)
			end
			if at <= 34 then
				helper_2a30e517(15)
			end
			if at <= 35 then
				helper_1d80d1e0(2800120)
			end
			if at <= 36 then
				helper_1d80d1e0(2800130)
			end
			if at <= 37 then
				helper_d1db54d2(0)
			end
			if at <= 38 then
				helper_1d80d1e0(2800140)
			end
			if at <= 39 then
				helper_d1db54d2(1)
			end
			if at <= 40 then
				helper_1d80d1e0(2800145)
			end
			if at <= 41 then
				helper_1d80d1e0(2800150)
			end
			if at <= 42 then
				helper_d1db54d2(0)
			end
			if at <= 43 then
				helper_1d80d1e0(2800160)
			end
			if at <= 44 then
				helper_d1db54d2(1)
			end
			if at <= 45 then
				helper_2a30e517(30)
			end
			if at <= 46 then
				helper_2a30e517(15)
			end
			if at <= 47 then
				helper_1d80d1e0(2800170)
			end
			if at <= 48 then
				helper_1d80d1e0(2800180)
			end
			if at <= 49 then
				helper_2a30e517(30)
			end
			if at <= 50 then
				helper_d1db54d2(0)
			end
			if at <= 51 then
				helper_d1db54d2(0)
			end
			if at <= 52 then
				helper_1d80d1e0(2800190)
			end
			if at <= 53 then
				helper_d1db54d2(0)
			end
			if at <= 54 then
				helper_1d80d1e0(2800195)
			end
			if at <= 55 then
				helper_d1db54d2(0)
			end
			if at <= 56 then
				helper_d1db54d2(1)
			end
			if at <= 57 then
				helper_1d80d1e0(2800200)
			end
			if at <= 58 then
				helper_d1db54d2(1)
			end
			if at <= 59 then
				helper_1d80d1e0(2800205)
			end
			if at <= 60 then
				helper_d1db54d2(1)
			end
			if at <= 61 then
				helper_1d80d1e0(2800210)
			end
			if at <= 62 then
				helper_d1db54d2(0)
			end
			if at <= 63 then
				helper_d1db54d2(0)
			end
			if at <= 64 then
				helper_d1db54d2(1)
			end
			if at <= 65 then
				helper_d1db54d2(0)
			end
			if at <= 66 then
				helper_d1db54d2(1)
			end
			if at <= 67 then
				helper_2a30e517(15)
			end
			if at <= 68 then
				helper_2a30e517(200)
			end
			if at <= 69 then
				helper_2a30e517(35)
			end
			if vm.skip_end() then
				return skip(71)
			end
			return part2()
		end
		helper_28dfc()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SndSeStop(var6, 8)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_28dfc()
		event.ResetCamera(0)
	end
	event.SetFlag(280, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	event.StopBgm(0)
	helper_2a30e517(45)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(59)
	event.LoadSound(2511)
	event.PlayBgm(0, 36)
	var6 = event.SndLoadSound(2511) or var6
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
	helper_1d80d1e0(2800010)
	if vm.skipping() then
		return skip(2)
	end
	helper_1d80d1e0(2800015)
	if vm.skipping() then
		return skip(3)
	end
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
	helper_1d80d1e0(2800020)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "上向くL", 4)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(38.84, 15.89, 762.06)
	event.CmrsSetRef(30.81, 47.05, 622.71)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(7)
	end
	helper_1d80d1e0(2800030)
	if vm.skipping() then
		return skip(8)
	end
	helper_1d80d1e0(2800040)
	if vm.skipping() then
		return skip(9)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "不満目パチ")
	event.CmrsSetPos(17.72, 36.99, 568.83)
	event.CmrsSetRef(35.34, 28.44, 619.23)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "はぁ？", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "あきれ口パク")
	helper_1d80d1e0(2800050)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(13)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(38.84, 15.89, 762.06)
	event.CmrsSetRef(30.81, 47.05, 622.71)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(15)
	end
	helper_1d80d1e0(2800060)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(54.46, 37.12, 558.59)
	event.CmrsSetRef(20.97, 30.6, 620.45)
	helper_1d80d1e0(2800065)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(38.84, 15.89, 762.06)
	event.CmrsSetRef(30.81, 47.05, 622.71)
	helper_1d80d1e0(2800070)
	if vm.skipping() then
		return skip(18)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "不満顔")
	event.ObjsTexAnime(1, 1, "不満目パチ")
	event.CmrsSetPos(42.96, 39.99, 563.11)
	event.CmrsSetRef(28.37, 28.44, 607.63)
	event.ObjsSetRot(0, 0.0, -2.56, 0.0)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1d80d1e0(2800080)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "上見から右見", 6)
	event.ObjsNextMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d80d1e0(2800085)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(23)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetRot(0, 0.0, 3.12, 0.0)
	event.CmrsSetPos(-23.31, 28.11, 596.86)
	event.CmrsSetRef(26.9, 28.44, 606.75)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(25)
	end
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
	helper_1d80d1e0(2800090)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(27)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(60.85, 50.28, 994.5)
	event.CmrsSetRef(37.15, 90.96, 620.83)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(60.85, 50.28, 994.5, 37.15, 90.96, 620.83)
	event.CmrsAddPas(53.55, 50.28, 879.42, 29.85, 90.96, 505.75)
	event.CmrsStartPas()
	helper_dc33e260(2800100, -1)
	if vm.skipping() then
		return skip(30)
	end
	event.SndSePlay(var6, 8)
	helper_d991b5ca()
	if vm.skipping() then
		return skip(31)
	end
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
	helper_d991b5ca()
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(38.84, 15.89, 762.06)
	event.CmrsSetRef(30.81, 47.05, 622.71)
	event.SndSeStop(var6, 8)
	helper_dc33e260(2800110, 120)
	if vm.skipping() then
		return skip(33)
	end
	event.SndSePlay(var6, 9)
	event.ObjsSetMotion(1, "がっかり肩落とし", 6)
	event.ObjsNextMotion(1, "がっかり肩落としＬ", 4)
	event.ObjsSetMotion(0, "がっかり", 6)
	event.ObjsNextMotion(0, "がっかりＬ", 4)
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(1, "頭抱えるＬ", 4, -1.0, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "こまり顔")
	event.ObjsTexAnime(0, 1, "こまり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目とじ")
	event.CmrsSetPos(-23.31, 28.11, 596.86)
	event.CmrsSetRef(26.9, 28.44, 606.75)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(35)
	end
	helper_1d80d1e0(2800120)
	if vm.skipping() then
		return skip(36)
	end
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
	helper_1d80d1e0(2800130)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(0, "上見から右見", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSetMotion(1, "手をおろす", 6)
	event.ObjsNextMotion(1, "下向き立ちＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2800140)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(40)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2800145)
	if vm.skipping() then
		return skip(41)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	helper_1d80d1e0(2800150)
	if vm.skipping() then
		return skip(42)
	end
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(43)
	end
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
	helper_1d80d1e0(2800160)
	if vm.skipping() then
		return skip(44)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(45)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "さみし顔")
	event.ObjsTexAnime(1, 1, "さみし目パチ")
	event.CmrsSetPos(42.73, 39.99, 562.51)
	event.CmrsSetRef(25.56, 28.44, 606.38)
	event.ObjsSetRot(0, 0.0, -2.56, 0.0)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(47)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1d80d1e0(2800170)
	if vm.skipping() then
		return skip(48)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向きから下向き", 6)
	event.ObjsNextMotion(1, "下向き立ちＬ", 4)
	event.SetPakuAnim(1, "さみし口パク")
	helper_1d80d1e0(2800180)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(50)
	end
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
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(51)
	end
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(52)
	end
	event.SndSePlay(var6, 11)
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1d80d1e0(2800190)
	if vm.skipping() then
		return skip(53)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetMotion(0, "モニカ見立ちうなづき", 2)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	helper_1d80d1e0(2800195)
	if vm.skipping() then
		return skip(55)
	end
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(56)
	end
	event.SndSePlay(var6, 12)
	event.ObjsRotation(1, 0.0, -1.0, 0.0, 30)
	event.ObjsSetMotion(1, "左回転90度（ＰＧ）", 6)
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2800200)
	if vm.skipping() then
		return skip(58)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2800205)
	if vm.skipping() then
		return skip(60)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(61)
	end
	event.SndSePlay(var6, 13)
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1d80d1e0(2800210)
	if vm.skipping() then
		return skip(62)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(63)
	end
	event.SndSePlay(var6, 14)
	event.SndSePlay(var6, 15)
	event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(64)
	end
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(65)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 20)
	event.ObjsRotation(1, 0.0, 0.0, 0.0, 20)
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(66)
	end
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(67)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 20.44, 6.52, 1490.12, 390, 1)
	event.ObjsMove(1, 39.08, 7.54, 1478.94, 390, 1)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(240)
	event.CmrsAddPas(28.25, 31.54, 674.64, 28.22, 28.44, 600.45)
	event.CmrsAddPas(28.59, 31.54, 1526.51, 28.22, 28.44, 600.45)
	event.CmrsStartPas()
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(68)
	end
	helper_2a30e517(200)
	if vm.skipping() then
		return skip(69)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_2a30e517(35)
	if vm.skipping() then
		return skip(70)
	end
	return part2()
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dc33e260(2850010, -1)
		end
		if at <= 2 then
			helper_d991b5ca()
		end
		if at <= 3 then
			helper_2a30e517(30)
		end
	end
	event.SetFadeIn(30)
	event.SndSePlay(global8, 0)
	event.CmrsMove(111.21, 97.1, 1515.22, 354.23, 94.23, 1247.17, 540)
	helper_2a30e517(50)
	if vm.skipping() then
		return skip(1)
	end
	helper_dc33e260(2850010, -1)
	if vm.skipping() then
		return skip(2)
	end
	helper_d991b5ca()
	if vm.skipping() then
		return skip(3)
	end
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSeStop(global8, 0)
end

--- Helper function.
local function helper_2e560()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2a30e517(15)
		end
		if at <= 2 then
			helper_1d80d1e0(2850020)
		end
		if at <= 3 then
			helper_2a30e517(30)
		end
		if at <= 4 then
			helper_2a30e517(30)
		end
		if at <= 5 then
			helper_2a30e517(15)
		end
		if at <= 6 then
			helper_2a30e517(90)
		end
		if at <= 7 then
			helper_2a30e517(150)
		end
		if at <= 8 then
			helper_2a30e517(20)
		end
		if at <= 9 then
			helper_2a30e517(30)
		end
		if at <= 10 then
			helper_d1db54d2(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち", 0)
	event.ObjsSetMotion(1, "立ち", 0)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(2)
	end
	helper_1d80d1e0(2850020)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "もごもご")
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "ふんっ")
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CharaActive(1, 38)
	event.SetWind(40.0, -96.86, 52.75, 388.46)
	event.SetMotion(38, "鼻爆発", 2, -1, 1)
	event.SndSePlay(global8, 1)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(6)
	end
	event.SetWind(-1)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsSetMotion(1, "おどろき", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.ObjsNextMotion(1, "おどろきL", 4)
	helper_2a30e517(90)
	if vm.skipping() then
		return skip(7)
	end
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
	helper_2a30e517(150)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsNextMotion(0, "取る", 6)
	event.ObjsNextMotion(1, "上向く戻り", 6, 0.025)
	event.ObjsNextMotion(0, "取るL", 4)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_2a30e517(20)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(39, "消える", 2, -1, 1)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(10)
	end
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 39)
end

--- Helper function.
local function helper_2ef80()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2a30e517(15)
		end
		if at <= 2 then
			helper_9e5786f5(31, 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
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
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(2)
	end
	helper_9e5786f5(31, 1)
	if vm.skipping() then
		return skip(3)
	end
	event.DelReference(36)
	event.CharaActive(0, 40)
	event.SndSeStop(global9, 0)
	event.PlayBgm(0)
end

--- Helper function.
local function helper_2f368()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d80d1e0(2850030)
		end
		if at <= 2 then
			helper_2a30e517(15)
		end
		if at <= 3 then
			helper_2a30e517(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_1d80d1e0(2850030)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsRotation(0, 0.0, 0.2, 0.0, 15)
	event.ObjsRotation(1, 0.0, 0.0, 0.0, 15)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsFadeInit()
	event.CmrsFadeDelay(30)
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, 13.4, 6.52, 613.7)
	event.ObjsAddPas(0, 16.54, 2.3, 632.93)
	event.ObjsAddPas(0, 19.85, -3.85, 662.84)
	event.ObjsAddPas(0, 22.02, -8.04, 684.68)
	event.ObjsAddPas(0, 24.22, -12.54, 709.74)
	event.ObjsAddPas(0, 26.96, -12.32, 737.33)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, 47.24, 7.54, 600.38)
	event.ObjsAddPas(1, 49.86, 2.84, 624.2)
	event.ObjsAddPas(1, 51.55, -2.15, 651.95)
	event.ObjsAddPas(1, 52.91, -6.17, 674.31)
	event.ObjsAddPas(1, 55.85, -12.79, 722.8)
	event.ObjsStartPas(1)
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_2fac8()
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
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_2e560()
			end
			if at <= 2 then
				helper_2ef80()
			end
			if at <= 3 then
				helper_2f368()
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		helper_2fac8()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(global8, 0)
		event.SetWind(-1)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_2fac8()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(285, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(2517)
	global8 = event.SndLoadSound(2517) or global8
	global9 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or global9
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
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(46.15, 36.68, 848.41)
	event.CmrsSetRef(38.64, 44.8, 724.85)
	helper_2e560()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(3.9, 53.24, 586.95)
	event.CmrsSetRef(8.68, 32.62, 613.94)
	helper_2ef80()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(46.15, 36.68, 848.41)
	event.CmrsSetRef(38.64, 44.8, 724.85)
	helper_2f368()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_14228()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetDraw(0, 0)
end

--- Helper function.
local function helper_142b4(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_e1b436d6(0, -1, 5, 0, 0)
		end
		helper_14228()
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(612) or flag
	if flag == 0 then
		return
	end
	event.SetMesWindowMode(0, 12)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	if vm.wait() then
		return skip(2)
	end
	if arg0 ~= 0 then
		event.MesMake_2(0, "Siamo andati nel futuro con un\nviaggio temporale dell'Ixion.")
	else
		event.MesMake_2(0, "Siamo tornati al presente con un\nviaggio temporale dell'Ixion.")
	end
	if vm.wait() then
		return skip(3)
	end
	helper_e1b436d6(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(6)
	end
	helper_14228()
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
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_199cf264()
			end
			if at <= 2 then
				helper_2a30e517(20)
			end
			if at <= 3 then
				helper_d1db54d2(0)
			end
			if at <= 4 then
				helper_199cf264()
			end
			if at <= 5 then
				print("pumpkin---------------------------\n")
				print("stripte -----------------------------\n")
				print("princess-----------------------------\n")
				print("separate----------------------------\n")
				helper_d1db54d2(6)
			end
			if at <= 6 then
				helper_2a30e517(60)
			end
			if at <= 7 then
				helper_2a30e517(60)
			end
			if at <= 8 then
				helper_142b4(0)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
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
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotion(0, "立ち")
	if arg4 == 0 then
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	else
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_d991b5ca()
	if vm.skipping() then
		return skip(1)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	helper_199cf264()
	if vm.skipping() then
		return skip(2)
	end
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
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 == 0 then
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	else
		event.SetLoadbgFile("event/time_gate/red/atora_shine2.chr", "event/time_gate/red/atora_glare2.chr")
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_2a30e517(20)
		if vm.skipping() then
			return skip(3)
		end
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
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_199cf264()
	if vm.skipping() then
		return skip(5)
	end
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
	helper_d1db54d2(6)
	if vm.skipping() then
		return skip(6)
	end
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
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(8)
	end
	helper_142b4(0)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_13034(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var7: s32 = 0
	local now_party_chara_id: s32 = 0
	local language_code: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_2a30e517(30)
			end
			if at <= 2 then
				helper_d991b5ca()
			end
			if at <= 3 then
				helper_d1db54d2(0)
			end
			if at <= 4 then
				helper_1d80d1e0(5220010)
			end
			if at <= 5 then
				helper_1d80d1e0(5220015)
			end
			if at <= 6 then
				helper_2a30e517(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var7, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(522, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var7 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var7
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	event.LoadMotion(5, "event/e500/e522/e522_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 33)
		event.CharaActive(0, 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.SetCharaType(34, 4)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.LoadMes(0, 5, "event/e500/e522/e522.txt")
	else
		event.LoadMes(0, 5, "event/e500/e522/e522_1.txt")
	end
	event.SetFadeOut(30)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.SndSePlay(var7, 0)
	event.InitDramaScene()
	event.CharaActive(1, 33)
	event.CmrsSetPos(5.32, 62.92, -97.07)
	event.CmrsSetRef(11.48, 61.6, -39.43)
	event.ObjsSetPos(0, 39.64, -0.0, 9.33)
	event.ObjsSetRot(0, 0.0, -2.33, 0.0)
	event.ObjsSetPos(1, 34.65, 0.0, 29.92)
	event.ObjsSetRot(1, 0.0, -2.36, 0.0)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 0)
	event.CmrsMove2(5.32, 24.78, -97.07, 11.48, 29.98, -39.43, 90, 2, 0.4)
	helper_d991b5ca()
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(0, 33)
	event.CmrsSetPos(25.53, 21.33, -15.17)
	event.CmrsSetRef(32.72, 21.29, -3.29)
	event.ObjsSetRot(0, 0.0, -2.69, 0.0)
	event.CharaDaEnable(0, 0)
	event.CharaActive(1, 34)
	event.EohGetFramePos(0, "atoramiria")
	event.SetReference(0, "atoramiria", 34)
	event.SetCharaPos(34, 0.04, -1.42988, 0.89)
	event.ObjsSeDelay(2, 25)
	event.ObjsSePlay(2, var7, 1)
	event.ObjsSetMotion(2, "発動", 6)
	event.ObjsNextMotion(2, "発動L", 0)
	event.ObjsSetMotion(0, "アトラ見る", 6)
	event.ObjsNextMotion(0, "アトラ見るL", 0)
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "アトラさわる", 6)
	event.ObjsNextMotion(0, "アトラさわるL", 6)
	helper_1d80d1e0(5220010)
	if vm.skipping() then
		return skip(5)
	end
	helper_1d80d1e0(5220015)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_1481c(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_d991b5ca()
			end
			if at <= 2 then
				helper_199cf264()
			end
			if at <= 3 then
				helper_2a30e517(30)
			end
			if at <= 4 then
				helper_d1db54d2(0)
			end
			if at <= 5 then
				helper_199cf264()
			end
			if at <= 6 then
				helper_d1db54d2(6)
			end
			if at <= 7 then
				helper_2a30e517(60)
			end
			if at <= 8 then
				helper_2a30e517(60)
			end
			if at <= 9 then
				helper_142b4(1)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		else
			event.SndSeStop(var13, 0)
		end
		event.FadeOutBgm(30)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no == 1 then
			event.DeleteChara(32)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	flag = event.GetFlag(612) or flag
	event.SetMotion(0, "立ち")
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_d991b5ca()
	if vm.skipping() then
		return skip(2)
	end
	helper_199cf264()
	if vm.skipping() then
		return skip(3)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
	else
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
	end
	event.CharaActive(35)
	event.SetCharaType(35, 4)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 70.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(36)
	event.SetCharaType(36, 4)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 49.73999, 0.0, 8.969971)
		event.EohSetRot(2, 0.0, -1.76, 0.0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 0)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			end
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 1, 4, "info", 33)
			event.LoadEquip(5, 1, 3, "info", 33)
			event.LoadEquip(5, 1, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
		end
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 32)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
			end
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, 18.619995, 0.0, 35.179993)
		event.EohSetRot(1, 0.0, -2.48, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
		event.EohResetDaPosition(1)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
		event.LoadMotion(5, "event/e500/e523/e523_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
	end
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	end
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_2a30e517(30)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(-56.29, 15.74, 3.56)
		event.CmrsSetRef(-12.65, 16.48, 2.06)
	else
		event.CmrsSetPos(-48.179993, 19.61, -28.70996)
		event.CmrsSetRef(-0.789978, 16.48, -0.05999756)
	end
	if arg5 == 0 and arg4 == 0 and flag == 0 then
		event.CmrsSetPos(-30.09, 19.5, 4.41)
		event.CmrsSetRef(-14.63, 21.71, 1.0)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6, 0.45)
	event.ObjsNextMotion(0, "タイムワープL", 4)
	event.ObjsTexAnime(0, 1, "開閉口")
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_199cf264()
	if vm.skipping() then
		return skip(6)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg4 ~= 0 then
		event.ObjsSetPos(6, pos_x, pos_y, pos_z)
	else
		event.ObjsSetPos(6, -3.54, 17.04, -1.46)
	end
	event.ObjsSetRot(6, -0.45, -2.12, 0.0)
	event.CmrsSetPos(-21.5, 23.92, -12.580017)
	event.CmrsSetRef(-0.789978, 16.17, -0.05999756)
	event.ObjsTexAnime(0, 0, "開閉口")
	event.ObjsTexAnime(0, 1, "開き口")
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	if flag == 0 then
		helper_d1db54d2(6)
		if vm.skipping() then
			return skip(7)
		end
	else
		event.SndSePlay(var12, 2)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	end
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, -2.12, 0.0)
	event.CmrsSetPos(-40.590027, 19.47, -24.339966)
	event.CmrsSetRef(13.950012, 15.23, 9.190002)
	event.CmrsMove2(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_2a30e517(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_142b4(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1b510(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13034(arg0, arg1, arg2, arg3)
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_1481c(arg0, arg1, arg2, arg3, 0, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	function landing1()
		helper_1481c(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		return part2()
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_17c30(arg0, arg1, arg2, arg3, 0, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		flag = event.GetFlag(520) or flag
		flag_2 = event.GetFlag(532) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			flag_3 = event.GetFlag(522) or flag_3
			if flag_3 == 0 then
				helper_13034(arg0, arg1, arg2, arg3)
				if vm.skipping() then
					return skip(2)
				end
			end
		end
		helper_1481c(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	return part2()
end

--- Helper function.
local function helper_268e0()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_265e4()
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
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 22 then
			if at <= 1 then
				helper_268e0()
				helper_2a30e517(15)
			end
			if at <= 2 then
				helper_d1db54d2(1)
			end
			if at <= 3 then
				helper_dc33e260(2770010, -1)
			end
			if at <= 4 then
				helper_d1db54d2(0)
			end
			if at <= 5 then
				helper_dc33e260(2770020, 60)
			end
			if at <= 6 then
				helper_2a30e517(15)
			end
			if at <= 7 then
				helper_1d80d1e0(2770030)
			end
			if at <= 8 then
				helper_d1db54d2(1)
			end
			if at <= 9 then
				helper_1d80d1e0(2770040)
			end
			if at <= 10 then
				helper_d1db54d2(1)
			end
			if at <= 11 then
				helper_1d80d1e0(2770050)
			end
			if at <= 12 then
				helper_d1db54d2(1)
			end
			if at <= 13 then
				helper_2a30e517(30)
			end
			if at <= 14 then
				helper_1d80d1e0(2770060)
			end
			if at <= 15 then
				helper_d1db54d2(0)
			end
			if at <= 16 then
				helper_1d80d1e0(2770065)
			end
			if at <= 17 then
				helper_d1db54d2(0)
			end
			if at <= 18 then
				helper_dc33e260(2770070, 150)
			end
			if at <= 19 then
				helper_dc33e260(2770080, -1)
			end
			if at <= 20 then
				helper_d1db54d2(0)
			end
			if at <= 21 then
				helper_2a30e517(30)
			end
			if vm.skip_end() then
				return skip(23)
			end
			return part2()
		end
		if at <= 23 then
			helper_2a30e517(30)
		end
		helper_265e4()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_2a30e517(30)
		if vm.skipping() then
			return skip(24)
		end
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_265e4()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(277, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_2a30e517(45)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(2509)
	var4 = event.SndLoadSound(2509) or var4
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
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(0, -76.57, 22.37, 1326.65, 90, 1)
	event.ObjsMove(1, -99.28, 16.04, 1239.49, 30, 1)
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_dc33e260(2770010, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsRotation(0, 0.0, -2.87, 0.0, 20)
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_dc33e260(2770020, 60)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-88.03, 39.16, 1280.67)
	event.CmrsSetRef(-98.45, 39.74, 1240.52)
	event.SetReference(global1, "item", 35)
	event.CharaActive(1, 35)
	event.SndSePlay(var4, 0)
	event.ObjsSetMotion(1, "バッチ持ち立ち", 4)
	helper_2a30e517(15)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "バッチ持ち会話", 2)
	event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2770030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "バッチ持ち会話", 2)
	event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2770040)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "バッチ持ち会話", 2)
	event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d80d1e0(2770050)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(1)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "バッチ持ち立ち")
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CharaActive(0, 35)
	event.DelReference(35)
	event.CmrsSetPos(-117.43, 40.09, 1220.9)
	event.CmrsSetRef(-24.54, 60.52, 1410.11)
	event.ObjsSetMotion(0, "やったね", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1d80d1e0(2770060)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1d80d1e0(2770065)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(18)
	end
	helper_dc33e260(2770070, 150)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -60.53, 20.6, 1300.47, 60, 1)
	event.CmrsMove(-133.69, 30.07, 1231.38, -2.07, 60.52, 1392.67, 150)
	event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_dc33e260(2770080, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 0.89, 0.0, 30)
	helper_d1db54d2(0)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsMove(0, -42.89, 22.37, 1361.14, 60, 1)
	event.ObjsMove(1, -28.2, 20.64, 1346.17, 60, 1)
	helper_2a30e517(30)
	if vm.skipping() then
		return skip(22)
	end
	return part2()
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f914cb3a(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_da7f7ffe(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_f914cb3a(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_063cfcfb(player_chara_2, var20)
		end
		if at <= 5 then
			helper_f914cb3a(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_09b3df30(25)
		end
		if at <= 7 then
			helper_09b3df30(24)
		end
		if at <= 8 then
			helper_09b3df30(26)
		end
	end
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
			helper_d9cceed5(player_chara, var1, 0)
			if vm.skipping() then
				return skip(1)
			end
			helper_f914cb3a(0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
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
		helper_da7f7ffe(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_f914cb3a(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
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
		helper_063cfcfb(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_f914cb3a(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 101 then
		helper_09b3df30(25)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 102 then
		helper_09b3df30(24)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 103 then
		helper_09b3df30(26)
		if vm.skipping() then
			return skip(9)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local old_map_no: s32 = 0
	local var8: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 5 then
			if at <= 3 then
				helper_2a30e517(10)
			end
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			helper_7f11d45e(1)
		end
	end
	program_99()
	old_map_no = event.GetOldMapNo() or old_map_no
	if old_map_no == 0 then
		event.SetCameraPos(39.03, 111.84, 77.64)
		event.SetCameraRef(36.78, 22.33, 74.62)
		event.SetFadeOut(0, 255, 255, 255)
		if vm.wait() then
			return skip(1)
		end
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
		if vm.skipping() then
			return skip(2)
		end
		event.SetCharaPos(0, 169.8, 23.7, 1378.8)
		return
	end
	if helper_342a37b0() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(272, 1)
		helper_21af4()
		if vm.skipping() then
			return skip(3)
		end
		event.AddItem(361)
		event.AddItem(308)
		argc = event.CheckGetItemLimit() or argc
		argc_2 = event.CheckItemOver() or argc_2
		if argc >= 1 or argc_2 >= 1 then
			event.SetFadeOut(10)
			helper_2a30e517(10)
			if vm.skipping() then
				return skip(4)
			end
			event.GotoMenu(16)
			if vm.wait() then
				return skip(5)
			end
			event.SetFadeIn(10)
		end
		return
	end
	if helper_ee09935e() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(275, 1)
		helper_66ac1f76()
		helper_259cc()
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if helper_b84429a4() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(280, 1)
		helper_29d88()
		if vm.skipping() then
			return skip(7)
		end
		return
	end
	if helper_c5ea1698() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(285, 1)
		helper_30ea4()
		if vm.skipping() then
			return skip(8)
		end
		event.AddItem(31)
		helper_7f11d45e(1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.SetCharaPos(0, 110.0, 23.7, 1533.0)
	event.SetCharaRot(0, 0.0, -3.1415927, 0.0)
	event.ResetCamera(1)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_21af4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1b510(100.0, vm.f32(23.67), 1500.0, 0.0)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g01")
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.FuncPointShow("", "e277", 0)
	event.SetFlag(277, 1)
	helper_27664()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 401.
script[401] = function()
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e1b436d6(0, -1, 3, 0, 416)
		end
		if at <= 2 then
			helper_e1b436d6(0, -1, 3, 0, 416)
		end
		if at <= 3 then
			helper_e1b436d6(0, -1, 3, 0, 416)
		end
	end
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
	helper_a0f05df8(player_chara, 0.0, 300.0)
	if vm.skipping() then
		return skip(1)
	end
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
						helper_e1b436d6(0, -1, 3, 0, 416)
						if vm.skipping() then
							return skip(2)
						end
						event.MesMake_2(
							0,
							"Per diventare una Himarraaaa, ti\nserve uno Steeeemma di Himarra.<page>A volte li vendono\nnei neeeegozi di veeeestiti.<page>Oh, s[UNI00ec][UNI00ec][UNI00ec][UNI00ec]! C'[UNI00e8] un neeeegozio\ndi veeeestiti nel mio naaaaso."
						)
						helper_e1b436d6(0, -1, 3, 0, 416)
						if vm.skipping() then
							return skip(3)
						end
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
	helper_e1b436d6(0, -1, 3, 0, 416)
	if vm.skipping() then
		return skip(4)
	end
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetCrossfade(10)
end

--- Program 402.
script[402] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f11d45e(1)
		end
		if at <= 2 then
			helper_d4a58ede(0, 1)
			helper_e1b436d6(0, -1, 5, 256, 208)
		end
	end
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(36) or flag
	if flag == 0 then
		event.SetFlag(36, 1)
		event.AddItem(376)
		helper_9e5786f5(376, 1)
		if vm.skipping() then
			return skip(1)
		end
		helper_7f11d45e(1)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_d4a58ede(0, 1)
		event.MesMake_2(0, "Mi chiedo cosa uscir[UNI00e0] da questo\nuovo?")
		helper_e1b436d6(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_30ea4()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10a9c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12700.
script[12700] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
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
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12720.
script[12720] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
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
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12750.
script[12750] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
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
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12770.
script[12770] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
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
	event.MapJump(-1, 25, 400)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12800.
script[12800] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
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
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12850.
script[12850] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
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
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

return script
