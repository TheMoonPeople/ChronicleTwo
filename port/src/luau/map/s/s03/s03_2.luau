--!strict
-- map/s/s03/s03_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_12dbcc1c = require("@lib/event/helper_12dbcc1c")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_2bd56995 = require("@lib/event/helper_2bd56995")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_482d9cfc = require("@lib/event/helper_482d9cfc")
local helper_81254767 = require("@lib/event/helper_81254767")
local helper_83f868da = require("@lib/event/helper_83f868da")
local helper_84adb214 = require("@lib/event/helper_84adb214")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_ce448fa2 = require("@lib/event/helper_ce448fa2")
local helper_deb7b054 = require("@lib/event/helper_deb7b054")
local helper_e03e89ed = require("@lib/event/helper_e03e89ed")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")
local helper_fd83f07e = require("@lib/event/helper_fd83f07e")

--- Helper function.
local function helper_1716c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "jimen1", arg0)
	event.FuncPointShow("", "jimen2", arg0)
	event.FuncPointShow("", "jimen3", arg0)
	event.FuncPointShow("", "jimen4", arg0)
	event.FuncPointShow("", "jimen5", arg0)
	event.FuncPointShow("", "jimen6", arg0)
	event.FuncPointShow("", "jimen7", arg0)
	event.FuncPointShow("", "jimen9", arg0)
	event.FuncPointShow("", "jimen10", arg0)
end

--- Helper function.
local function helper_17434()
	local var0: s32 = 0
	local result: s32 = 0
	local var2: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 85 then
			if at <= 1 then
				helper_42c67f56(2060010)
			end
			if at <= 2 then
				helper_2bd56995(1)
			end
			if at <= 3 then
				helper_c1c32f84(50)
			end
			if at <= 4 then
				helper_c1c32f84(8)
			end
			if at <= 5 then
				helper_c1c32f84(34)
			end
			if at <= 6 then
				helper_c1c32f84(40)
			end
			if at <= 7 then
				helper_c1c32f84(48)
			end
			if at <= 8 then
				helper_42c67f56(2060020)
			end
			if at <= 9 then
				helper_42c67f56(2060030)
			end
			if at <= 10 then
				helper_c1c32f84(14)
			end
			if at <= 11 then
				helper_c1c32f84(20)
			end
			if at <= 12 then
				helper_c1c32f84(16)
			end
			if at <= 13 then
				helper_e5dca676()
			end
			if at <= 14 then
				helper_c1c32f84(4)
			end
			if at <= 15 then
				helper_c1c32f84(70)
			end
			if at <= 16 then
				helper_42c67f56(2060040)
			end
			if at <= 17 then
				helper_42c67f56(2060050)
			end
			if at <= 18 then
				helper_07cf3e45(2060060, 150)
			end
			if at <= 19 then
				helper_07cf3e45(2060070, 120)
			end
			if at <= 20 then
				helper_2386f745(5)
			end
			if at <= 21 then
				helper_42c67f56(2060080)
			end
			if at <= 22 then
				helper_deb7b054()
			end
			if at <= 23 then
				helper_42c67f56(2060090)
			end
			if at <= 24 then
				helper_2386f745(5)
			end
			if at <= 25 then
				helper_c1c32f84(4)
			end
			if at <= 26 then
				helper_e5dca676()
			end
			if at <= 27 then
				helper_c1c32f84(20)
			end
			if at <= 28 then
				helper_42c67f56(2060100)
			end
			if at <= 29 then
				helper_42c67f56(2060110)
			end
			if at <= 30 then
				helper_42c67f56(2060120)
			end
			if at <= 31 then
				helper_2386f745(5)
			end
			if at <= 32 then
				helper_c1c32f84(24)
			end
			if at <= 33 then
				helper_c1c32f84(8)
			end
			if at <= 34 then
				helper_c1c32f84(8)
			end
			if at <= 35 then
				helper_c1c32f84(8)
			end
			if at <= 36 then
				helper_2386f745(5)
			end
			if at <= 37 then
				helper_07cf3e45(2060130, 120)
			end
			if at <= 38 then
				helper_2386f745(5)
			end
			if at <= 39 then
				helper_c1c32f84(40)
			end
			if at <= 40 then
				helper_c1c32f84(10)
			end
			if at <= 41 then
				helper_c1c32f84(10)
			end
			if at <= 42 then
				helper_c1c32f84(20)
			end
			if at <= 43 then
				helper_c1c32f84(30)
			end
			if at <= 44 then
				helper_deb7b054()
			end
			if at <= 45 then
				helper_42c67f56(2060140)
			end
			if at <= 46 then
				helper_c1c32f84(48)
			end
			if at <= 47 then
				helper_c1c32f84(48)
			end
			if at <= 48 then
				helper_c1c32f84(40)
			end
			if at <= 49 then
				helper_c1c32f84(20)
			end
			if at <= 50 then
				helper_42c67f56(2060150)
			end
			if at <= 51 then
				helper_c1c32f84(4)
			end
			if at <= 52 then
				helper_c1c32f84(8)
			end
			if at <= 53 then
				helper_c1c32f84(108)
			end
			if at <= 54 then
				helper_c1c32f84(20)
			end
			if at <= 55 then
				helper_07cf3e45(2060160, 30)
			end
			if at <= 56 then
				helper_2386f745(1)
			end
			if at <= 57 then
				helper_c1c32f84(10)
			end
			if at <= 58 then
				helper_c1c32f84(20)
			end
			if at <= 59 then
				helper_c1c32f84(30)
			end
			if at <= 60 then
				helper_c1c32f84(2)
			end
			if at <= 61 then
				var2 = 0
			end
			if at <= 62 then
				helper_c1c32f84(12)
			end
			if at <= 63 then
				var2 = var2 + 1
				var2 = 0
			end
			if at <= 64 then
				helper_c1c32f84(12)
			end
			if at <= 65 then
				var2 = var2 + 1
				helper_c1c32f84(20)
			end
			if at <= 66 then
				helper_c1c32f84(20)
			end
			if at <= 67 then
				helper_c1c32f84(48)
			end
			if at <= 68 then
				helper_c1c32f84(32)
			end
			if at <= 69 then
				helper_1716c(0)
				helper_c1c32f84(40)
			end
			if at <= 70 then
				helper_deb7b054()
			end
			if at <= 71 then
				helper_1716c(1)
				helper_c1c32f84(30)
			end
			if at <= 72 then
				helper_c1c32f84(10)
			end
			if at <= 73 then
				helper_c1c32f84(10)
			end
			if at <= 74 then
				helper_c1c32f84(40)
			end
			if at <= 75 then
				helper_c1c32f84(40)
			end
			if at <= 76 then
				helper_07cf3e45(2060170, 120)
			end
			if at <= 77 then
				helper_2bd56995(1)
			end
			if at <= 78 then
				helper_e03e89ed(0, -1, 8, 0, 0)
				helper_e5dca676()
			end
			if at <= 79 then
				helper_84adb214(0, 150)
			end
			if at <= 80 then
				helper_81254767(0)
				helper_e5dca676()
			end
			if at <= 81 then
				helper_07cf3e45(2060190, 160)
			end
			if at <= 82 then
				helper_e5dca676()
			end
			if at <= 83 then
				helper_c1c32f84(30)
			end
			if at <= 84 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(86)
			end
			return part2()
		end
		helper_1716c(1)
	end
	function part2()
		event.CancelDramaScene()
		event.SetWind(0)
		event.StopBgm(0)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.SndSeStop(var0, 15)
		event.SndSeStop(var0, 16)
		event.ScrEffStopRaster(0.0, 0.0, 0.0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.DeleteChara(40)
		event.DeleteChara(41)
		event.DeleteChara(42)
		event.DeleteChara(43)
		event.DeleteChara(44)
		event.DeleteChara(45)
		event.DeleteChara(46)
		event.DeleteChara(47)
		event.DeleteChara(48)
		event.DeleteChara(49)
		event.DeleteChara(50)
		event.DeleteChara(51)
		event.DeleteChara(52)
		event.DeleteChara(53)
		event.LoadMes(0, -1)
		event.EsmClear()
		event.CharaActive(0)
		helper_1716c(1)
		event.StopBgm(0)
	end
	event.SetFlag(206, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(524.9)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(30)
	event.LoadSound(2209)
	var0 = event.SndLoadSound(2209) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e200/e206/")
	event.LoadMes(0, 5, "e206_1.txt")
	event.LoadMotion(5, "e206_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "p00_08a.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(2, 33)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e206_starbre.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(3, 34)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e206_polcurse.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e206_h_polcurse.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "b01a_buggy.gltf", "b01a_buggy", 37)
	event.CharaActive(37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "b01a_macho.gltf", "b01a_macho", 38)
	event.CharaActive(38)
	event.SetReference(37, "macho_chair", 38)
	event.LoadChara(5, "e206_bbaku.gltf", "info", 42)
	event.LoadChara(5, "e206_bfire.gltf", "info", 43)
	event.LoadChara(5, "e206_cloth.gltf", "info", 44)
	event.LoadChara(5, "e206_dfire.gltf", "info", 45)
	event.LoadChara(5, "e206_dfire.gltf", "info", 46)
	event.LoadChara(5, "e206_dfire_f.gltf", "info", 47)
	event.LoadChara(5, "e206_dfire_f.gltf", "info", 48)
	event.LoadChara(5, "e206_hikari.gltf", "info", 49)
	event.LoadChara(5, "e206_dynagiri.gltf", "info", 50)
	event.EohSyncChara(7, 50)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "e206_hyakugiri.gltf", "info", 51)
	event.LoadChara(5, "e206_pbaku.gltf", "info", 52)
	event.CharaActive(0, 52)
	event.LoadChara(5, "e206_polcurse00.gltf", "info", 53)
	event.CharaActive(1, 53)
	event.ChangeDir("")
	event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
	event.LoadEquip(5, 1, 4, "info", 32)
	event.LoadEquip(5, 1, 3, "info", 32)
	event.LoadEquip(5, 1, 2, "info", 32, 39)
	event.LoadEquip(5, 1, 1, "info", 32, 40)
	event.LoadEquip(5, 1, 0, "info", 32, 41)
	event.LoadMotion(5, "event/e200/e206/e206_monica.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.CharaActive(0, 39)
	event.CharaActive(0, 40)
	event.CharaActive(0, 41)
	event.EohSyncChara(1, 32)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EsmInitialize(5)
	event.EsmLoadBase("EVモニカ魔法－火")
	event.EsmLoadBase("EVモニカ魔法－火ヒット")
	event.EsmLoadBase("モニカ魔法－溜め")
	event.EsmInitFix(5, 6000)
	event.ObjsSetPos(0, 8.0, 134.45, -334.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "びびる", 6, -1.0, 1)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "半口")
	event.ObjsSetPos(3, -8.0, 114.0, -303.0)
	event.ObjsSetRot(3, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(3, "屋根つかまり立ち", 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "デフォルト顔")
	event.EohSetTexAnim(3, 1, "通常目パチ")
	event.ObjsSetPos(4, 220.0, 0.0, -580.0)
	event.ObjsSetMotion(4, "じたばた", 4)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "おこり顔")
	event.EohSetTexAnim(4, 1, "おこり目パチ")
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "激怒わらい顔2")
	event.EohSetTexAnim(5, 1, "激怒目パチ")
	event.EohSetSoundId(5, var0)
	event.ObjsTexAnime(2, 0)
	event.ObjsSetPos(6, 220.0, 0.0, -580.0)
	event.ObjsSetMotion(6, "走行", 4)
	event.CharaActive(0, 42)
	event.SetCharaPos(42, 225.0, 34.0, -486.0)
	event.CharaActive(43)
	event.SetCharaPos(43, 220.0, 0.0, -580.0)
	event.CharaActive(0, 44)
	event.SetCharaPos(44, 0.0, 139.18, -620.0)
	event.SetReference(36, "f1", 45)
	event.SetCharaPos(45, 0.0, 0.0, 0.0)
	event.SetReference(36, "f2", 46)
	event.SetCharaPos(46, 0.0, 0.0, 0.0)
	event.SetReference(36, "f1", 47)
	event.SetCharaPos(47, 0.0, 2.0, 0.0)
	event.SetReference(36, "f2", 48)
	event.SetCharaPos(48, 0.0, 2.0, 0.0)
	event.CharaActive(0, 49)
	event.SetCharaPos(49, 0.0, 139.18, -712.0)
	event.SetCharaPos(50, 0.0, 139.18, -460.0)
	event.SetCharaRot(50, 0.0, 3.14, 0.0)
	event.SetCharaPos(51, 0.0, 139.18, -490.0)
	event.SetCharaRot(51, 0.0, 0.0, 0.0)
	event.SetCharaPos(53, 220.0, 0.0, -580.0)
	event.SetCharaRot(53, 0.0, 0.0, 0.0)
	event.SetMotion(53, "じたばた", 4)
	event.InitDramaScene()
	event.SetWind(10, 0.0, 0.0, -1.0)
	event.CmrsInit()
	event.CmrsSetPos(361.41, 48.91, -580.59)
	event.CmrsSetRef(233.41, 52.06, -580.59)
	event.SndSePlay(var0, 2)
	event.SndSePlay(var0, 3)
	event.SetFadeIn(30)
	event.SetPakuAnim(4, "おこり顔口パク")
	helper_42c67f56(2060010)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamOpen3(1, 2060015)
	helper_2bd56995(1)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(220.0, 60.0, -420.0)
	event.CmrsSetRef(220.0, 60.0, -580.0)
	event.SndSeStop(var0, 2)
	event.SndSeStop(var0, 3)
	event.SndSePlay(var0, 4)
	event.CharaActive(0, 53)
	event.CharaActive(1, 35)
	event.CmrsMove2(256.05, 60.0, -351.07, 160.79, 130.27, -549.21, 30, 2, 1.0)
	event.ObjsSetMotion(4, "ふっとび", 6)
	event.ObjsMove(4, 14.0, 0.0, -610.0, 50)
	event.ObjsSetMotion(6, "左側でダメージ", 6)
	event.ObjsNextMotion(6, "右側でダメージ", 6)
	event.ObjsMove2(6, 220.0, 0.0, -1000.0, 40, 1, 1.0)
	event.CharaActive(0, 43)
	event.CharaActive(42)
	event.SetMotion(42, "ｴﾌｪｸﾄ_バギー爆発", 6)
	event.StreamPlay(1)
	helper_c1c32f84(50)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(0, 38)
	event.CharaActive(0, 37)
	event.CmrsSetPos(0.0, 167.16, -367.46)
	event.CmrsSetRef(0.0, 129.42, -609.2)
	event.ObjsSetPos(4, 0.0, 139.18, -620.0)
	event.ObjsSetMotion(4, "どさっと落ちた", 6)
	helper_c1c32f84(8)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 5)
	helper_c1c32f84(34)
	if vm.skipping() then
		return skip(6)
	end
	event.StreamClose(1)
	event.CmrsSetPos(19.88, 150.6, -361.7)
	event.CmrsSetRef(8.1, 156.22, -333.48)
	event.EohSetTexAnim(0, 1, "まばたき目パチ")
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(60.03, 148.42, -606.42)
	event.CmrsSetRef(0.0, 151.12, -606.2)
	event.CmrsMove(60.03, 148.42, -614.42, 0.0, 151.12, -614.2, 48)
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(4, "起きあがり", 6)
	helper_c1c32f84(48)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(0.0, 161.43, -576.15)
	event.CmrsSetRef(0.0, 167.01, -624.67)
	event.SndSePlay(var0, 8)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "激怒顔")
	event.EohSetTexAnim(4, 1, "激怒目パチ")
	event.ObjsSetMotion(4, "顔上げ", 6)
	event.ObjsNextMotion(4, "ワナワナ", 4)
	helper_42c67f56(2060020)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(10.4, 144.62, -387.58)
	event.CmrsSetRef(8.88, 150.2, -322.21)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "びびる", 6, -1.0, 1)
	event.SetPakuAnim(0, "通常口パク", "半口")
	helper_42c67f56(2060030)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(0.0, 156.37, -537.41)
	event.CmrsSetRef(0.0, 159.13, -624.67)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "激怒わらい顔")
	event.EohSetTexAnim(4, 1, "激怒目パチ")
	event.ObjsSetMotion(4, "脱ぎ構え", 6)
	helper_c1c32f84(14)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var0, 9)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(49.82, 158.45, -577.41)
	event.CmrsSetRef(28.49, 183.1, -641.57)
	event.SndSePlay(var0, 10)
	event.CharaActive(0, 35)
	event.CharaActive(36)
	event.ObjsSetPos(5, 0.0, 139.18, -620.0)
	event.ObjsSetMotion(5, "脱ぐ", 6)
	event.ObjsNextMotion(5, "脱ぐＬ", 4)
	event.CharaActive(44)
	event.SetMotion(44, "ｴﾌｪｸﾄ_脱衣", 6)
	helper_c1c32f84(16)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsMove2(49.82, 158.45, -577.41, 1.0, 162.91, -620.29, 20, 0, 0.4)
	helper_e5dca676()
	if vm.skipping() then
		return skip(14)
	end
	event.PlayBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(15)
	end
	event.CharaActive(0, 44)
	event.SetCrossfade(30)
	event.CmrsSetPos(0.0, 153.08, -533.86)
	event.CmrsSetRef(0.0, 158.5, -620.41)
	helper_c1c32f84(70)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-16.28, 155.87, -380.81)
	event.CmrsSetRef(12.48, 144.4, -292.95)
	event.EohSetTexAnim(0, 1, "前向き～左向き")
	event.ObjsSetMotion(3, "つかまり会話", 6)
	event.ObjsNextMotion(3, "屋根つかまり立ち", 4)
	event.ObjsSetMotion(0, "振り向く", 6)
	event.ObjsNextMotion(0, "振り向くL", 4)
	event.SetPakuAnim(3, "通常口パク", "大口")
	helper_42c67f56(2060040)
	if vm.skipping() then
		return skip(17)
	end
	event.EohSetTexAnim(0, 1, "左向き～前向き")
	event.EohSetTexAnim(0, 1, "半口～大口")
	event.ObjsSetMotion(0, "振り向く戻り", 6)
	event.ObjsNextMotion(0, "びびる", 4)
	helper_42c67f56(2060050)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCrossfade(30)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "激怒わらい顔")
	event.EohSetTexAnim(5, 1, "激怒目パチ")
	event.CmrsSyncObj(5, 0.0, 23.0, 0.0, 0.0, 9.8, 80.0)
	event.CmrsMoveAhd2(0.0, 9.8, 40.0, 100, 2, 1.0)
	event.ObjsSetPos(5, 0.0, 139.18, -800.0)
	event.ObjsSetMotion(5, "脱ぎ歩き", 4)
	event.ObjsMove(5, 0.0, 139.18, -640.0, 150)
	event.SetPakuAnim(5, "激怒わらい口パク")
	helper_07cf3e45(2060060, 150)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(5, "さあさあＬ")
	event.ObjsChengeStep(5, 0.1)
	event.ObjsMotionDelay(5, 40)
	event.ObjsSetMotion(5, "ごらあ", 2)
	event.ObjsNextMotion(5, "ごらあＬ", 4)
	event.SetPakuAnim(5, "激怒わらい口パク")
	helper_07cf3e45(2060070, 120)
	if vm.skipping() then
		return skip(20)
	end
	helper_2386f745(5)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsReleaseObj()
	event.ObjsSetMotion(5, "後ろに気がつく", 5)
	event.CmrsSetPos(17.47, 148.06, -359.89)
	event.CmrsSetRef(7.59, 155.6, -333.8)
	event.SndSePlay(var0, 11)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目～ひき目")
	event.ObjsSetMotion(0, "ひく", 6)
	event.ObjsNextMotion(0, "ひくL", 4)
	event.SetPakuAnim(0, "ひき口パク")
	helper_42c67f56(2060080)
	if vm.skipping() then
		return skip(22)
	end
	event.SetLoadbgFile("snd2/bgm/bg_104.sound.json")
	helper_deb7b054()
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSyncObj(5, 0.0, 23.0, 0.0, 0.0, 9.8, 38.0)
	event.FadeOutBgm(30)
	event.SndSePlay(var0, 12)
	event.ObjsSetPos(5, 0.0, 139.18, -468.0)
	event.ObjsMove(5, 0.0, 139.18, -450.0, 30)
	event.ObjsSetMotion(5, "後ろに気がつく", 6)
	event.ObjsNextMotion(5, "後ろに気がつくＬ", 4)
	event.ObjsTexaDelay(5, 26)
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "きづく顔")
	helper_42c67f56(2060090)
	if vm.skipping() then
		return skip(24)
	end
	helper_2386f745(5)
	if vm.skipping() then
		return skip(25)
	end
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(26)
	end
	event.LoadBgmPack(104)
	event.PlayBgm(0)
	event.CmrsReleaseObj()
	event.CharaActive(33)
	event.ObjsSetPos(2, 0.0, 139.18, -712.0)
	event.ObjsSetMotion(5, "振りかえり", 6)
	event.ObjsNextMotion(5, "振りかえりＬ", 4)
	event.CmrsMove2(0.0, 198.49, -396.69, 0.0, 175.46, -468.0, 20, 0, 0.4)
	helper_e5dca676()
	if vm.skipping() then
		return skip(27)
	end
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(-0.0, 161.25, -679.19)
	event.CmrsSetRef(-0.0, 158.97, -713.45)
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(2060100)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(0.0, 166.31, -519.59)
	event.CmrsSetRef(0.0, 164.03, -473.3)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "激怒顔")
	event.EohSetTexAnim(5, 1, "激怒目パチ")
	event.ObjsSetRot(5, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(5, "会話", 6)
	event.ObjsNextMotion(5, "会話用立ち", 4)
	event.SetPakuAnim(5, "激怒口パク")
	helper_42c67f56(2060110)
	if vm.skipping() then
		return skip(30)
	end
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "激怒わらい顔2")
	event.EohSetTexAnim(5, 1, "激怒目パチ")
	event.SetPakuAnim(5, "激怒わらい口パク")
	helper_42c67f56(2060120)
	if vm.skipping() then
		return skip(31)
	end
	helper_2386f745(5)
	if vm.skipping() then
		return skip(32)
	end
	event.SndSePlay(var0, 13)
	event.ObjsSetMotion(5, "爆弾取り出し", 6)
	event.ObjsNextMotion(5, "火付け", 6)
	event.ObjsMotionWait(5)
	helper_c1c32f84(24)
	if vm.skipping() then
		return skip(33)
	end
	event.SndSePlay(var0, 14)
	event.EohSetTexAnim(5, 1, "火ふき口")
	event.CharaActive(48)
	event.SetMotion(48, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ着火", 6)
	helper_c1c32f84(8)
	if vm.skipping() then
		return skip(34)
	end
	event.CharaActive(46)
	event.SetMotion(46, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ炎", 4)
	helper_c1c32f84(8)
	if vm.skipping() then
		return skip(35)
	end
	event.SndSePlay(var0, 14)
	event.EohSetTexAnim(5, 0, "火ふき口")
	event.EohSetTexAnim(5, 1, "火ふき口")
	event.CharaActive(47)
	event.SetMotion(47, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ着火", 6)
	helper_c1c32f84(8)
	if vm.skipping() then
		return skip(36)
	end
	event.CharaActive(45)
	event.SetMotion(45, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ炎", 4)
	helper_2386f745(5)
	if vm.skipping() then
		return skip(37)
	end
	event.SndSePlay(var0, 15)
	event.CharaActive(0, 47)
	event.CharaActive(0, 48)
	event.ObjsSetMotion(5, "爆弾歩き")
	event.ObjsMove(5, 0.0, 139.18, -490.0, 130)
	event.EohSetTexAnim(5, 0, "火ふき口")
	event.SetPakuAnim(5, "激怒わらい口パク")
	helper_07cf3e45(2060130, 120)
	if vm.skipping() then
		return skip(38)
	end
	helper_2386f745(5)
	if vm.skipping() then
		return skip(39)
	end
	event.SndSeStop(var0, 15)
	event.ObjsSetMotion(5, "構え2", 4)
	event.CmrsSetPos(23.2, 152.06, -685.78)
	event.CmrsSetRef(-0.59, 157.87, -710.51)
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsSetPos(0.49, 160.57, -693.45)
	event.CmrsSetRef(-0.32, 160.57, -710.52)
	event.FadeOutBgm(30)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(41)
	end
	event.SndSePlay(var0, 16)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(42)
	end
	event.CharaActive(49)
	event.SetMotion(49, "光る", 6)
	event.ScrEffInitRaster(0.0, 0.0, 0.15707964)
	event.ScrEffStartRaster(60.0, 0.3926991, -1.0, 50)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(43)
	end
	event.StopBgm(0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(44)
	end
	event.SetLoadbgFile("snd2/bgm/bg_190.sound.json")
	helper_deb7b054()
	if vm.skipping() then
		return skip(45)
	end
	event.CmrsSetPos(0.0, 162.13, -550.88)
	event.CmrsSetRef(0.0, 160.57, -488.42)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "おこり顔")
	event.EohSetTexAnim(5, 1, "おこり目パチ")
	event.ScrEffStopRaster(0.0, 0.0, 0.0, 0)
	event.LoadBgmPack(190)
	event.PlayBgm(0)
	event.SetPakuAnim(5, "おこり口パク")
	helper_42c67f56(2060140)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(21.57, 145.5, -694.43)
	event.CmrsSetRef(0.0, 145.5, -710.52)
	event.CmrsMove(21.57, 150.5, -694.43, 0.0, 150.5, -710.52, 48)
	event.SndSePlay(var0, 17)
	event.SetMotion(49, "消える", 6)
	event.ScrEffInitRaster(60.0, 0.3926991, 0.15707964)
	event.ScrEffStartRaster(-1.0, -1.0, -1.0, 0)
	event.ScrEffStopRaster(0.0, -1.0, -1.0, 40)
	event.CharaActive(0, 33)
	event.CharaActive(32)
	event.CharaActive(39)
	event.CharaActive(40)
	event.CharaActive(41)
	event.ObjsSetPos(1, 0.0, 139.18, -712.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "目とじ")
	helper_c1c32f84(48)
	if vm.skipping() then
		return skip(47)
	end
	event.CmrsSetPos(16.18, 155.0, -733.35)
	event.CmrsSetRef(0.0, 155.0, -714.81)
	event.CmrsMove(16.18, 160.0, -733.35, 0.0, 160.0, -714.81, 48)
	event.SndSePlay(var0, 18)
	event.ObjsSetMotion(1, "髪の毛バサッ", 6)
	event.ObjsNextMotion(1, "髪の毛バサッＬ", 4)
	helper_c1c32f84(48)
	if vm.skipping() then
		return skip(48)
	end
	event.CharaActive(0, 49)
	event.CmrsSetPos(0.0, 160.11, -684.49)
	event.CmrsSetRef(0.0, 160.11, -710.52)
	event.SndSePlay(var0, 19)
	event.ObjsSetMotion(1, "うつむき～構え", 6)
	event.ObjsNextMotion(1, "構えＬ", 4)
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 1, "目とじ～目あき")
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 1, "目にらみ目")
	event.ObjsTexAnime(1, 1, "口とじ～にらみ口")
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(49)
	end
	event.SndSePlay(var0, 22)
	event.SndSeStop(var0, 16)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(50)
	end
	event.CmrsSetPos(22.15, 166.63, -756.1)
	event.CmrsSetRef(1.09, 150.66, -651.12)
	event.ObjsSetPos(5, 0.0, 139.18, -460.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "おどろき顔")
	event.EohSetTexAnim(5, 1, "おこり目パチ")
	event.SetPakuAnim(5, "おこり口パク")
	helper_42c67f56(2060150)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSetMotion(1, "ジャンプ", 2)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(52)
	end
	event.SndSePlay(var0, 23)
	helper_c1c32f84(8)
	if vm.skipping() then
		return skip(53)
	end
	event.CmrsSetPos(74.99, 148.72, -384.25)
	event.CmrsSetRef(-4.53, 162.4, -478.25)
	event.CmrsMove2(44.68, 149.84, -420.08, -4.53, 162.4, -478.25, 90, 2, 0.4)
	event.ObjsSetPos(1, 0.0, 139.18, -490.0)
	event.ObjsSetMotion(1, "斬り一連", 6, -1.0, 1)
	event.ObjsSeDelay(1, 13)
	event.ObjsSePlay(1, var0, 25)
	event.ObjsSeDelay(1, 14)
	event.ObjsSePlay(1, var0, 25)
	event.ObjsSeDelay(1, 7)
	event.ObjsSePlay(1, var0, 25)
	event.ObjsSeDelay(1, 13)
	event.ObjsSePlay(1, var0, 25)
	event.ObjsSeDelay(1, 11)
	event.ObjsSePlay(1, var0, 25)
	event.ObjsSeDelay(1, 19)
	event.ObjsSePlay(1, var0, 25)
	event.ObjsSeDelay(1, 12)
	event.ObjsSePlay(1, var0, 25)
	event.ObjsSeDelay(1, 7)
	event.ObjsSePlay(1, var0, 25)
	event.ObjsPosDelay(5, 13)
	event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(5, 10)
	event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(5, 3)
	event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(5, 9)
	event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(5, 7)
	event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(5, 15)
	event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(5, 8)
	event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(5, 3)
	event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(7, 13)
	event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(7, 10)
	event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(7, 3)
	event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(7, 9)
	event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(7, 7)
	event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(7, 15)
	event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(7, 8)
	event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsPosDelay(7, 3)
	event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
	event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
	event.EohSetFrameStatus(5, "dm01", 0)
	event.EohSetFrameStatus(5, "dm02", 0)
	event.EohSetFrameStatus(5, "dm03", 0)
	event.EohSetFrameStatus(5, "dm04", 0)
	event.EohSetFrameStatus(5, "dm05", 0)
	event.EohSetFrameStatus(5, "dm06", 0)
	event.EohSetFrameStatus(5, "dm07", 0)
	event.EohSetFrameStatus(5, "dm08", 0)
	event.CharaActive(0, 45)
	event.CharaActive(0, 46)
	event.CharaActive(50)
	event.SetMotion(50, "構え2", 6)
	event.CharaActive(51)
	event.SetMotion(51, "百烈斬り", 6)
	helper_c1c32f84(108)
	if vm.skipping() then
		return skip(54)
	end
	event.SndSePlay(var0, 26)
	event.ObjsSetMotion(5, "構え2から上向く", 2)
	event.ObjsNextMotion(5, "構え2から上向くＬ", 4)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(55)
	end
	event.CharaActive(0, 50)
	event.CharaActive(0, 51)
	event.CmrsSetPos(17.12, 167.45, -472.74)
	event.CmrsSetRef(2.04, 165.02, -453.77)
	event.ObjsSetPos(1, 0.0, 242.0, -432.79)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(1, "着地2", 1, -1.0, 1)
	event.ObjsPosDelay(1, 14)
	event.ObjsSetPos(1, 0.0, 142.0, -432.79)
	event.ObjsMotionDelay(1, 14)
	event.ObjsSetMotion(1, "着地2", 6)
	event.ObjsMotionWait(1)
	event.SetPakuAnim(5, "おこり口パク")
	helper_07cf3e45(2060160, 30)
	if vm.skipping() then
		return skip(56)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(57)
	end
	event.CmrsSetPos(37.04, 163.18, -414.0)
	event.CmrsSetRef(-0.44, 155.57, -479.81)
	event.ObjsSetPos(1, 0.0, 139.18, -466.39)
	event.ObjsSetPos(5, 0.0, 139.18, -482.06)
	event.ObjsSetMotion(1, "着地から蹴り", 6, -1.0, 1)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(58)
	end
	event.SndSePlay(var0, 27)
	event.ObjsSetMotion(5, "蹴られ", 6)
	event.ObjsMove(5, 0.0, 139.18, -582.06, 20)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(59)
	end
	event.CmrsSetPos(102.08, 207.93, -668.58)
	event.CmrsSetRef(0.9, 248.52, -781.38)
	event.ObjsSetMotion(5, "回転", 4)
	event.ObjsSetPos(5, 0.0, 170.0, -700.0)
	event.ObjsJump(5, 0.0, 270.0, -810.0, -0.2, 30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(60)
	end
	event.CmrsSetPos(31.63, 178.14, -506.91)
	event.CmrsSetRef(-4.76, 161.36, -465.13)
	event.ObjsSetMotion(1, "魔法構えＬ", 4, -1.0, 1)
	helper_c1c32f84(2)
	if vm.skipping() then
		return skip(61)
	end
	do
		local out1, out2, out3 = event.EohGetFramePos(1, "item")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var2 = 0
	while var2 < 2 do
		event.SndSePlay(var0, 28)
		event.ObjsResetMotion(1)
		event.ObjsSetMotion(1, "魔法発射", 6)
		result = event.EsmCreate_3("モニカ魔法－溜め", 32) or result
		event.EsmSetVect1(pos_x, pos_y, pos_z)
		event.EsmSetVect2(128, 64, 64)
		event.EsmCreate_2("EVモニカ魔法－火", 32)
		event.EsmSetVect1(pos_x, pos_y, pos_z)
		event.EsmSetTargetId(36)
		if vm.wait() then
			return skip(62)
		end
		event.EsmFinish(32, result)
		helper_c1c32f84(12)
		if vm.skipping() then
			return skip(63)
		end
		var2 = var2 + 1
	end
	event.CmrsSetPos(2.63, 168.94, -402.89)
	event.CmrsSetRef(2.53, 174.18, -467.22)
	var2 = 0
	while var2 < 2 do
		event.SndSePlay(var0, 28)
		event.ObjsResetMotion(1)
		event.ObjsSetMotion(1, "魔法発射", 6)
		result = event.EsmCreate_3("モニカ魔法－溜め", 32) or result
		event.EsmSetVect1(pos_x, pos_y, pos_z)
		event.EsmSetVect2(128, 64, 64)
		event.EsmCreate_2("EVモニカ魔法－火", 32)
		event.EsmSetVect1(pos_x, pos_y, pos_z)
		event.EsmSetTargetId(36)
		if vm.wait() then
			return skip(64)
		end
		event.EsmFinish(32, result)
		helper_c1c32f84(12)
		if vm.skipping() then
			return skip(65)
		end
		event.SndSePlay(var0, 29)
		var2 = var2 + 1
	end
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(66)
	end
	event.SndSePlay(var0, 29)
	event.CharaActive(1, 52)
	event.SetCharaPos(52, 0.0, 270.0, -810.0)
	event.SetCharaRot(52, 0.0, 0.0, 0.0)
	event.SetMotion(52, "ｴﾌｪｸﾄ_ポルカス爆発", 6)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(67)
	end
	event.CmrsSetPos(384.95, 97.71, -2219.0)
	event.CmrsSetRef(49.63, 140.83, -1923.14)
	event.SndSePlay(var0, 30)
	event.CmrsMove(384.95, 97.71, -2219.0, -38.17, 25.4, -2159.44, 80)
	event.SetCharaPos(52, 0.0, 260.0, -1700.0)
	event.SetCharaRot(52, 0.0, 0.0, 0.0)
	event.ObjsSetPos(5, 0.0, 0.0, -1700.0)
	event.ObjsSetRot(5, 0.0, 1.57, 0.0)
	event.ObjsMove2(5, 0.0, 0.0, -2200.0, 40, 2, 1.0)
	event.ObjsSetMotion(5, "バウンド", 6)
	helper_c1c32f84(48)
	if vm.skipping() then
		return skip(68)
	end
	event.SndSePlay(var0, 31)
	helper_c1c32f84(32)
	if vm.skipping() then
		return skip(69)
	end
	event.CmrsSetPos(-63.62, 7.53, -2200.15)
	event.CmrsSetRef(-100.22, 4.78, -2200.62)
	event.ObjsSetPos(5, -100.0, 0.0, -2200.0)
	event.ObjsSetMotion(5, "落ちるアップ用", 6)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "激怒顔")
	event.EohSetTexAnim(5, 1, "激怒目パチ")
	helper_1716c(0)
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(70)
	end
	event.SetLoadbgFile("snd2/bgm/bg_112.sound.json")
	helper_deb7b054()
	if vm.skipping() then
		return skip(71)
	end
	event.CmrsSetPos(0.0, 163.99, -340.4)
	event.CmrsSetRef(0.0, 161.92, -451.52)
	event.FadeOutBgm(40)
	helper_1716c(1)
	event.SndSePlay(var0, 32)
	event.ObjsSetMotion(1, "魔法構え～立ち", 6)
	event.ObjsNextMotion(1, "振りかえり", 6)
	event.ObjsNextMotion(1, "振りかえりＬ", 4)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(72)
	end
	event.SetCrossfade(60)
	event.SndSePlay(var0, 33)
	event.CmrsSetPos(-3.0, 160.0, -430.4)
	event.CmrsSetRef(-3.0, 160.0, -467.48)
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目～通常目")
	event.ObjsTexAnime(1, 1, "にらみ口～口とじ")
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(73)
	end
	event.StopBgm(0)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(74)
	end
	event.LoadBgmPack(112)
	event.PlayBgm(0)
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(75)
	end
	event.CmrsSetPos(21.75, 147.46, -348.38)
	event.CmrsSetRef(-0.97, 155.45, -337.06)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.ObjsSetPos(0, 0.0, 134.45, -334.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(76)
	end
	event.SetCrossfade(60)
	event.CmrsSetRef(0.0, 154.0, -400.0)
	event.CmrsSetAhd(1.11, 18.0, 175.0)
	event.CmrsMoveAhd(2.03, 18.0, 175.0, 160)
	helper_07cf3e45(2060170, 120)
	if vm.skipping() then
		return skip(77)
	end
	event.StreamOpen3(1, 2060180)
	helper_2bd56995(1)
	if vm.skipping() then
		return skip(78)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 2060180)
	helper_e03e89ed(0, -1, 8, 0, 0)
	helper_e5dca676()
	if vm.skipping() then
		return skip(79)
	end
	event.SetCrossfade(30)
	event.CmrsSyncObj(1, 0.0, 23.0, 0.0, 0.57, 0.0, 30.0)
	event.CmrsMoveAhd2(1.57, 0.0, 30.0, 90, 2, 0.3)
	helper_84adb214(0, 150)
	if vm.skipping() then
		return skip(80)
	end
	helper_81254767(0)
	event.StreamClose(1)
	helper_e5dca676()
	if vm.skipping() then
		return skip(81)
	end
	event.CmrsReleaseObj()
	event.SetCrossfade(30)
	event.CmrsSyncObj(0, 0.0, 20.0, 0.0, -2.0, 0.0, 30.0)
	event.CmrsMoveAhd2(3.14, 0.0, 30.0, 90, 2, 1.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	helper_07cf3e45(2060190, 160)
	if vm.skipping() then
		return skip(82)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(83)
	end
	event.CmrsReleaseObj()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(84)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(85)
	end
	return part2()
end

--- Helper function.
local function helper_1645c()
	local var0: s32 = 0
	local var1: any = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(45)
		end
		if at <= 2 then
			helper_c1c32f84(30)
		end
		if at <= 3 then
			helper_ce448fa2()
			helper_c1c32f84(4)
		end
		if at <= 4 then
			var1 = helper_83f868da(0, -1, 8, 0, 0, 2, 0)
		end
		return var1
	end
	event.SetFlag(205, 1)
	event.Initialize()
	event.LoadSound(2206)
	var0 = event.SndLoadSound(2206) or var0
	helper_482d9cfc()
	event.StopBgm(0)
	if vm.wait() then
		return skip(1)
	end
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.CharaActive(1, 36)
	event.SndSePlay(var0, 5)
	event.SetCharaPos(36, 102.27, 0.0, -305.63)
	event.SetCharaRot(36, 0.0, 0.0, 0.0)
	event.SetCharaPos(35, 44.05, 0.0, 60.82)
	event.SetScale(35, 2.0, 2.0, 2.0)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 0, 0, 0, 0)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(11, 0)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.SndSePlay(var0, 1)
	event.EohSyncObj(10, "p01_s03t")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	do
		local out1, out2, out3 = event.EohGetPos(10)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.ObjsMove(10, 0.0, 51.92, 0.0, 60)
	event.ObjsRotation(10, 0.0, 0.0, -0.785, 60)
	event.CmrsSetPos(67.41, 107.89, 704.3)
	event.CmrsSetRef(59.64, 108.51, 271.98)
	event.CmrsMove2(58.28, 107.89, 196.59, 57.34, 108.51, 144.64, 50, 1, 0.4)
	helper_c1c32f84(45)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetColor(11, 0, 0, 0, 255, 30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "停止")
	event.EsmClear()
	helper_ce448fa2()
	event.ObjsSetPos(10, pos_x, pos_y, pos_z)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.SoundAllStop()
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(4)
	end
	event.LoadBgm(60)
	event.PlayBgm(1)
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(0, "R[UNI00e9]essayer.\nRetourner [UNI00e0] l'[UNI00e9]cran de titre.")
	var1 = helper_83f868da(0, -1, 8, 0, 0, 2, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.CharaActive(1, 0)
	event.SetFadeOut(0)
	event.SpriteSetDraw(0, 0)
	return var1
end

--- Helper function.
local function helper_242a0(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if arg0 == 0 then
		event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
		event.SetFadeIn(30)
		event.GotoSubgame(3)
	else
		event.SetExitFlag(1)
		event.SetFadeIn(30)
		return
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_1ef0d4b2

--- Program 100.
script[100] = function()
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	event.SetCharaPos(0, 0.0, 140.0, -420.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraPos(0.0, 200.0, -260.0)
	event.SetCameraRef(0.0, 170.0, -420.0)
	event.ResetCamera(0)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_12dbcc1c()
		end
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_12dbcc1c()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	helper_fd83f07e()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(15)
	event.GotoSubgame(3)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.BgmLoadCancel()
	event.MapJump(-1, "s08", 502)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	helper_17434()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmPlayCancel()
	event.MapJump(-1, "s02")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 512.
script[512] = function()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_242a0(var0)
	end
	var0 = helper_1645c()
	if vm.skipping() then
		return skip(1)
	end
	helper_242a0(var0)
end

--- Program 12040.
script[12040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fd83f07e()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(15)
	event.GotoSubgame(3)
end

--- Program 12050.
script[12050] = function()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_242a0(var0)
	end
	var0 = helper_1645c()
	if vm.skipping() then
		return skip(1)
	end
	helper_242a0(var0)
end

--- Program 12060.
script[12060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_17434()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 22010.
script[22010] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, 0.0, 140.0, -420.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.GotoSubgame(3)
end

return script
