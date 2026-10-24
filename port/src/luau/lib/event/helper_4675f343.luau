--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_46f8aa3e = require("@lib/event/helper_46f8aa3e")
local helper_48d33e71 = require("@lib/event/helper_48d33e71")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_705b02bc = require("@lib/event/helper_705b02bc")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_d743ebd8 = require("@lib/event/helper_d743ebd8")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

--- Helper function.
local function helper_4675f343()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetTime(24.0)
		event.SetProjection(618.0)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadSound(1219)
		event.PlayEnvBgm(0)
		event.LoadBgm(107)
		event.InitDramaScene()
		var0 = event.SndLoadSound_2(1219) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		event.ChangeDir("event/opening/p5/")
		event.LoadMes(0, 5, "op5_1.txt")
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.EohSetFootSoundId(0, 2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 2198.2, 0.0, 2227.47)
		event.ObjsSetRot(0, 0.0, 3.14, 0.0)
		event.LoadChara(5, "p5_pierrot.gltf", "info", 9)
		event.CharaActive(9)
		event.EohSyncChara(1, 9)
		event.EohSetFootSoundId(1, 2)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetPos(1, 2195.08, 0.0, 2575.62)
		event.ObjsSetRot(1, 0.0, 3.14, 0.0)
		event.CopyChara(5, 9, 10)
		event.CharaActive(10)
		event.EohSyncChara(2, 10)
		event.EohSetFootSoundId(2, 0)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetPos(2, 2229.28, 0.0, 2598.0)
		event.ObjsSetRot(2, 0.0, 3.14, 0.0)
		event.CopyChara(5, 9, 11)
		event.CharaActive(11)
		event.EohSyncChara(3, 11)
		event.EohSetFootSoundId(3, 0)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetPos(3, 2173.22, 0.0, 2657.79)
		event.ObjsSetRot(3, 0.0, 3.14, 0.0)
		event.LoadChara(5, "p5_halloween.gltf", "p00_10a", 12)
		event.CharaActive(12)
		event.EohSyncChara(4, 12)
		event.EohSetSoundId(4, var0)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetPos(4, 2200.0, 0.0, 3021.4)
		event.ObjsSetRot(4, 0.0, 3.14, 0.0)
		event.LoadChara(5, "p5_polcurse.gltf", "info", 13)
		event.CharaActive(13)
		event.EohSyncChara(5, 13)
		event.EohSetFrameShow(5, "sashi", 0)
		event.EohSetFrameShow(5, "cube61_8", 1)
		event.ObjsInit(5)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetPos(5, 0.0, 0.0, 0.0)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(5, "立ち", 4)
		event.SetReference(12, "polcurse", 13)
		event.ObjsTexAnime(5, 0, "口パク")
		event.ChangeDir("")
		event.EohSyncChrobj(6, 12, "cube39")
		event.ObjsInit(6)
		event.ObjsSyncObj(6, 6)
		event.ObjsRotation(6, 0.0, -0.02, 0.0, -1)
		at = 2
		helper_d743ebd8(50005)
		event.MesMake_2(0, 50005)
		event.SetMesOkuri(0, 0)
		helper_82705ce2(0, -1, 8, 0, 0)
		event.ObjsSetMotion(0, "走り", 4)
		event.ObjsMove(0, 2198.2, 0.0, 1839.29, 90)
		event.ObjsSetMotion(1, "走り", 4)
		event.ObjsMove(1, 2195.08, 0.0, 1839.62, 140)
		event.ObjsSetMotion(2, "走り", 4, 0.9)
		event.ObjsSetMotionNowTime(2, 4.5)
		event.ObjsMove(2, 2229.28, 0.0, 1839.62, 150)
		event.ObjsSetMotion(3, "走り", 4, 0.9)
		event.ObjsSetMotionNowTime(3, 9.9)
		event.ObjsMove(3, 2173.22, 0.0, 1839.62, 160)
		event.CmrsInit()
		event.CmrsSetPos(1834.01, 105.83, 2170.98)
		event.CmrsSetRef(2138.28, 60.96, 2221.1)
		event.CmrsMove(1833.59, 105.83, 2170.07, 2114.57, 60.96, 2042.3, 90)
		event.CmrsFadeInit()
		event.CmrsFadeIn(30)
		at = 3
		helper_c624bc16()
		at = 4
		helper_0958ca60(0)
		at = 5
		helper_0958ca60(1)
		at = 6
		helper_25abe6d2(4)
		event.PlayBgm(0, -1)
		at = 7
		helper_0958ca60(2)
		at = 8
		helper_0958ca60(3)
		at = 9
		helper_25abe6d2(20)
		event.CharaActive(0, 0)
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
		event.CharaActive(0, 11)
		helper_6992f518(0)
		event.SetMesOkuri(0, 1)
		event.SetCrossfade(30)
		event.CmrsSetPos(2200.0, 13.0, 1761.66)
		event.CmrsSetRef(2200.0, 250.08, 3021.4)
		event.CmrsMove(2200.0, 13.0, 1811.66, 2200.0, 250.08, 3021.4, 120)
		at = 10
		helper_25abe6d2(94)
		event.StreamClose(1)
		event.ObjsSePlay(4, var0, 9)
		at = 11
		helper_c624bc16()
		event.ObjsJump(4, 2200.0, 0.0, 2100.0, -1.2, 60)
		event.ObjsSetMotion(4, "ジャンプ上昇", 6)
		event.ObjsNextMotion(4, "ジャンプ下降")
		event.ObjsChengeStep(4, 0.08)
		event.ObjsMotionDelay(4, 30)
		event.ObjsSetMotion(4, "着地", 6)
		event.ObjsNextMotion(4, "立ち")
		event.CmrsMove(2200.0, 13.0, 1811.66, 2200.0, 539.39, 2576.05, 30)
		at = 12
		helper_c624bc16()
		event.CmrsSetPos(1736.02, 386.45, 2011.23)
		for var1_i = 0, 29 do
			do
				local out1, out2, out3 = event.GetCharaPos(12)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			event.CmrsSetRef(var2, var3 + 20.0, var4)
			at = 13
			vm.wait(13)
		end
		event.CmrsQuake(0.0, 6.0, 0.0, 25)
		at = 14
		helper_25abe6d2(30)
		event.CmrsSetPos(2201.44, 61.26, 1712.51)
		event.CmrsSetRef(2201.87, 89.26, 2115.81)
		event.ObjsSetMotion(4, "きょろきょろカメラ目線", 6)
		event.ObjsNextMotion(4, "ポル持ち立ち", 4)
		event.ObjsSePlay(4, var0, 10)
		event.ObjsSeDelay(4, 20)
		event.ObjsSePlay(4, var0, 10)
		event.ObjsSeDelay(4, 22)
		event.ObjsSePlay(4, var0, 10)
		event.StreamOpen3(1, 50010)
		at = 15
		helper_9cbdc640(1)
		at = 16
		helper_0958ca60(4)
		at = 17
		helper_25abe6d2(30)
		event.CmrsSetPos(2189.74, 124.48, 1971.11)
		event.CmrsSetRef(2182.94, 127.74, 2019.16)
		event.ObjsTexAnime(5, 1, "にやり口")
		event.ObjsSetMotion(5, "帽子直し", 6)
		event.ObjsNextMotion(5, "帽子直しL", 4)
		event.ObjsTexaDelay(5, 40)
		event.ObjsTexAnime(5, 0, "目パチ")
		event.ObjsTexAnime(5, 1, "怒り目（目パチ）")
		at = 18
		helper_25abe6d2(6)
		event.SetPakuAnim(5, "口パク", "にやり口")
		event.MesMake_2(0, 50010)
		helper_82705ce2(0, -1, 8, 0, 0)
		event.StreamPlay(1)
		event.EohSetTexAnim(5, 0, "にやり口")
		event.EohSetTexAnim(5, 1, "口パク")
		at = 19
		helper_25abe6d2(30)
		event.EohSetTexAnim(5, 0, "口パク")
		at = 20
		helper_25abe6d2(10)
		event.EohSetFrameShow(5, "sashi", 1)
		event.EohSetFrameShow(5, "cube61_8", 0)
		at = 21
		helper_46f8aa3e(0, -1)
		helper_6992f518(0)
		event.SetMesPos(0, 0)
		at = 22
		helper_0958ca60(5)
		event.StreamClose(1)
		event.CmrsSetPos(1903.57, 177.35, 2408.27)
		event.CmrsSetRef(2208.66, 112.3, 1994.07)
		at = 23
		helper_25abe6d2(10)
		event.ObjsSetMotion(4, "歩き")
		event.ObjsSetMotion(5, "立ち", 4)
		event.ObjsMove(4, 2200.0, 0.0, 1500.0, 60)
		at = 24
		helper_0958ca60(4)
		event.CmrsFadeInit()
		event.CmrsFadeOut(30)
		at = 25
		helper_c624bc16()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_48d33e71(50005)
		end
		if at <= 2 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			helper_d3f20302(4)
		end
		if at <= 6 then
			helper_238b5abc(2)
		end
		if at <= 7 then
			helper_238b5abc(3)
		end
		if at <= 8 then
			helper_d3f20302(20)
		end
		if at <= 9 then
			helper_d16eef1e(0)
			helper_d3f20302(94)
		end
		if at <= 10 then
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_344d6cd8()
		end
		if at <= 12 then
			var1 = 0
		end
		if at <= 13 then
			local _ = var1 < 30
			var1 = var1 + 1
			helper_d3f20302(30)
		end
		if at <= 14 then
			helper_238b5abc(1)
		end
		if at <= 15 then
			helper_238b5abc(4)
		end
		if at <= 16 then
			helper_d3f20302(30)
		end
		if at <= 17 then
			helper_d3f20302(6)
		end
		if at <= 18 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_d3f20302(30)
		end
		if at <= 19 then
			helper_d3f20302(10)
		end
		if at <= 20 then
			helper_705b02bc(0, -1)
		end
		if at <= 21 then
			helper_d16eef1e(0)
			helper_238b5abc(5)
		end
		if at <= 22 then
			helper_d3f20302(10)
		end
		if at <= 23 then
			helper_238b5abc(4)
		end
		if at <= 24 then
			helper_344d6cd8()
		end
		return true
	end)
	event.CancelDramaScene()
	event.StreamClose(1)
	event.PlayBgm(0, -1)
	event.DelExtMotion(0)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.LoadMes(0, -1)
	event.CharaActive(1, 0)
	event.ObjsInit(6)
	event.BgmLoadCancel()
	event.SoundLoadCancel()
end

return helper_4675f343
