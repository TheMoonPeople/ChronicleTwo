--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1840cd09 = require("@lib/event/helper_1840cd09")
local helper_5c123176 = require("@lib/event/helper_5c123176")
local helper_7eebaa1d = require("@lib/event/helper_7eebaa1d")
local helper_b971cedc = require("@lib/event/helper_b971cedc")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")
local helper_c570169b = require("@lib/event/helper_c570169b")
local helper_db98deda = require("@lib/event/helper_db98deda")
local helper_eb354717 = require("@lib/event/helper_eb354717")

--- Helper function.
local function helper_3008716a()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 25 then
			if at <= 1 then
				helper_1840cd09(50005)
			end
			if at <= 2 then
				helper_eb354717(0, -1, 8, 0, 0)
				helper_db98deda()
			end
			if at <= 3 then
				helper_7eebaa1d(0)
			end
			if at <= 4 then
				helper_7eebaa1d(1)
			end
			if at <= 5 then
				helper_bdbefa67(4)
			end
			if at <= 6 then
				helper_7eebaa1d(2)
			end
			if at <= 7 then
				helper_7eebaa1d(3)
			end
			if at <= 8 then
				helper_bdbefa67(20)
			end
			if at <= 9 then
				helper_5c123176(0)
				helper_bdbefa67(94)
			end
			if at <= 10 then
				helper_db98deda()
			end
			if at <= 11 then
				helper_db98deda()
			end
			if at <= 12 then
				var1 = 0
			end
			if at <= 13 then
				var1 = var1 + 1
				helper_bdbefa67(30)
			end
			if at <= 14 then
				helper_b971cedc(1)
			end
			if at <= 15 then
				helper_7eebaa1d(4)
			end
			if at <= 16 then
				helper_bdbefa67(30)
			end
			if at <= 17 then
				helper_bdbefa67(6)
			end
			if at <= 18 then
				helper_eb354717(0, -1, 8, 0, 0)
				helper_bdbefa67(30)
			end
			if at <= 19 then
				helper_bdbefa67(10)
			end
			if at <= 20 then
				helper_c570169b(0, -1)
			end
			if at <= 21 then
				helper_5c123176(0)
				helper_7eebaa1d(5)
			end
			if at <= 22 then
				helper_bdbefa67(10)
			end
			if at <= 23 then
				helper_7eebaa1d(4)
			end
			if at <= 24 then
				helper_db98deda()
			end
			if vm.skip_end() then
				return skip(26)
			end
			return part2()
		end
	end
	function part2()
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
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetTime(24.0)
	event.SetProjection(618.0)
	event.StopBgm(0)
	helper_bdbefa67(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(1219)
	event.PlayEnvBgm(0)
	event.LoadBgm(107)
	event.InitDramaScene()
	var0 = event.SndLoadSound(1219) or var0
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
	helper_1840cd09(50005)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, 50005)
	event.SetMesOkuri(0, 0)
	helper_eb354717(0, -1, 8, 0, 0)
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
	helper_db98deda()
	if vm.skipping() then
		return skip(3)
	end
	helper_7eebaa1d(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(5)
	end
	helper_bdbefa67(4)
	if vm.skipping() then
		return skip(6)
	end
	event.PlayBgm(0, -1)
	helper_7eebaa1d(2)
	if vm.skipping() then
		return skip(7)
	end
	helper_7eebaa1d(3)
	if vm.skipping() then
		return skip(8)
	end
	helper_bdbefa67(20)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	helper_5c123176(0)
	event.SetMesOkuri(0, 1)
	event.SetCrossfade(30)
	event.CmrsSetPos(2200.0, 13.0, 1761.66)
	event.CmrsSetRef(2200.0, 250.08, 3021.4)
	event.CmrsMove(2200.0, 13.0, 1811.66, 2200.0, 250.08, 3021.4, 120)
	helper_bdbefa67(94)
	if vm.skipping() then
		return skip(10)
	end
	event.StreamClose(1)
	event.ObjsSePlay(4, var0, 9)
	helper_db98deda()
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsJump(4, 2200.0, 0.0, 2100.0, -1.2, 60)
	event.ObjsSetMotion(4, "ジャンプ上昇", 6)
	event.ObjsNextMotion(4, "ジャンプ下降")
	event.ObjsChengeStep(4, 0.08)
	event.ObjsMotionDelay(4, 30)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "立ち")
	event.CmrsMove(2200.0, 13.0, 1811.66, 2200.0, 539.39, 2576.05, 30)
	helper_db98deda()
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(1736.02, 386.45, 2011.23)
	var1 = 0
	while var1 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(12)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.CmrsSetRef(var2, var3 + 20.0, var4)
		if vm.wait() then
			return skip(13)
		end
		var1 = var1 + 1
	end
	event.CmrsQuake(0.0, 6.0, 0.0, 25)
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(14)
	end
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
	helper_b971cedc(1)
	if vm.skipping() then
		return skip(15)
	end
	helper_7eebaa1d(4)
	if vm.skipping() then
		return skip(16)
	end
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(2189.74, 124.48, 1971.11)
	event.CmrsSetRef(2182.94, 127.74, 2019.16)
	event.ObjsTexAnime(5, 1, "にやり口")
	event.ObjsSetMotion(5, "帽子直し", 6)
	event.ObjsNextMotion(5, "帽子直しL", 4)
	event.ObjsTexaDelay(5, 40)
	event.ObjsTexAnime(5, 0, "目パチ")
	event.ObjsTexAnime(5, 1, "怒り目（目パチ）")
	helper_bdbefa67(6)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(5, "口パク", "にやり口")
	event.MesMake_2(0, 50010)
	helper_eb354717(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	event.EohSetTexAnim(5, 0, "にやり口")
	event.EohSetTexAnim(5, 1, "口パク")
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(19)
	end
	event.EohSetTexAnim(5, 0, "口パク")
	helper_bdbefa67(10)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetFrameShow(5, "sashi", 1)
	event.EohSetFrameShow(5, "cube61_8", 0)
	helper_c570169b(0, -1)
	if vm.skipping() then
		return skip(21)
	end
	helper_5c123176(0)
	event.SetMesPos(0, 0)
	helper_7eebaa1d(5)
	if vm.skipping() then
		return skip(22)
	end
	event.StreamClose(1)
	event.CmrsSetPos(1903.57, 177.35, 2408.27)
	event.CmrsSetRef(2208.66, 112.3, 1994.07)
	helper_bdbefa67(10)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(4, "歩き")
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsMove(4, 2200.0, 0.0, 1500.0, 60)
	helper_7eebaa1d(4)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_db98deda()
	if vm.skipping() then
		return skip(25)
	end
	return part2()
end

return helper_3008716a
