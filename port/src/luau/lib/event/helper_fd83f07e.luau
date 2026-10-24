--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_2bd56995 = require("@lib/event/helper_2bd56995")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")

--- Helper function.
local function helper_fd83f07e()
	local var0: s32 = 0
	local block: s32 = 0
	local angle: f32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 40 then
			if at <= 1 then
				helper_2bd56995(1)
			end
			if at <= 2 then
				helper_e5dca676()
			end
			if at <= 3 then
				helper_c1c32f84(65)
			end
			if at <= 4 then
				helper_2386f745(0)
			end
			if at <= 5 then
				helper_c1c32f84(10)
			end
			if at <= 6 then
				helper_2386f745(3)
			end
			if at <= 7 then
				angle = 0.0
				var3 = 0
				var4 = vm.f32(vm.f32(vm.sin(angle) * 30.0) + 240.0)
				angle = vm.f32(angle + vm.f32(0.15707964))
				var3 = var3 + 1
			end
			if at <= 8 then
				helper_2386f745(3)
			end
			if at <= 9 then
				helper_c1c32f84(40)
			end
			if at <= 10 then
				var7 = -1000.0
				var8 = 0
				var7 = vm.f32(var7 - 20.0)
				var8 = var8 + 1
				var8 = 0
				var7 = vm.f32(var7 + 20.0)
				var8 = var8 + 1
				var8 = 0
				var7 = vm.f32(var7 - 20.0)
				var8 = var8 + 1
				helper_e5dca676()
			end
			if at <= 11 then
				helper_e5dca676()
			end
			if at <= 12 then
				helper_42c67f56(2040020)
			end
			if at <= 13 then
				helper_42c67f56(2040030)
			end
			if at <= 14 then
				helper_2386f745(0)
			end
			if at <= 15 then
				helper_42c67f56(2040040)
			end
			if at <= 16 then
				helper_2386f745(1)
			end
			if at <= 17 then
				helper_42c67f56(2040050)
			end
			if at <= 18 then
				helper_2386f745(0)
			end
			if at <= 19 then
				helper_c1c32f84(30)
			end
			if at <= 20 then
				helper_c1c32f84(30)
			end
			if at <= 21 then
				helper_2386f745(1)
			end
			if at <= 22 then
				helper_42c67f56(2040060)
			end
			if at <= 23 then
				helper_42c67f56(2040070)
			end
			if at <= 24 then
				helper_2386f745(0)
			end
			if at <= 25 then
				helper_42c67f56(2040080)
			end
			if at <= 26 then
				helper_42c67f56(2040085)
			end
			if at <= 27 then
				helper_2386f745(1)
			end
			if at <= 28 then
				helper_42c67f56(2040090)
			end
			if at <= 29 then
				var7 = -1000.0
				var8 = 0
				var7 = vm.f32(var7 - 20.0)
				var8 = var8 + 1
				var8 = 0
				var7 = vm.f32(var7 + 20.0)
				var8 = var8 + 1
				var8 = 0
				var7 = vm.f32(var7 - 20.0)
				var8 = var8 + 1
				helper_c1c32f84(60)
			end
			if at <= 30 then
				helper_c1c32f84(40)
			end
			if at <= 31 then
				helper_c1c32f84(10)
			end
			if at <= 32 then
				helper_42c67f56(2040100)
			end
			if at <= 33 then
				helper_2386f745(0)
			end
			if at <= 34 then
				helper_42c67f56(2040110)
			end
			if at <= 35 then
				helper_2386f745(1)
			end
			if at <= 36 then
				helper_c1c32f84(10)
			end
			if at <= 37 then
				var3 = 0
				var12 = 6.0
				var13 = 0.0
				var14 = vm.f32(0.01)
				var12 = vm.f32(var12 - var13)
				var13 = vm.f32(var13 + var14)
				var3 = var3 + 1
			end
			if at <= 38 then
				helper_c1c32f84(vm.i32(70 - var3))
			end
			if at <= 39 then
				helper_c1c32f84(10)
			end
			if vm.skip_end() then
				return skip(41)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.PlayBgm(0)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 4)
		event.SndSeStop(var0, 5)
		event.SndSeStop(var0, 9)
		event.SndSeStop(var0, 10)
		event.SpriteSetDraw(0, 0)
		event.FuncPointShow("p01_s03t", "door", 0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DelImg(0)
		event.EsmClear()
		event.LoadMes(0, -1)
		event.CharaActive(0)
	end
	event.SetFadeOut(0)
	event.SetFlag(204, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(191)
	event.LoadSound(2203)
	var0 = event.SndLoadSound(2203) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e200/e204/")
	event.LoadMes(0, 5, "e204_1.txt")
	event.LoadMotion(5, "e204_mints.gltf", "info", 0)
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e204_starbre.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.EohSyncChara(1, 32)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "bomb.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.SetReference(32, "bomb", 33)
	event.LoadChara(5, "e204_buggy.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(3, 34)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e204_polcurse.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.SetReference(34, "polcurse_chair", 35)
	event.LoadChara(5, "e204_macho.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.SetReference(34, "macho_chair", 36)
	event.LoadChara(5, "gun_fire.gltf", "info", 37)
	event.CharaActive(0, 37)
	event.SetReference(34, "dcol00", 37)
	event.LoadChara(5, "gun_hit.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(9, 38)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 9)
	block = event.LoadImg_4(5, "e204telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e204telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 10)
	event.ChangeDir("")
	event.EsmInitialize(5, 1)
	event.EsmLoadBase("バギー砂煙")
	event.EsmInitFix(5)
	event.EohSyncObj(5, "p01_s03t", "s03t01-m", "door01-")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(0, 0.0, 133.53, -321.16)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.EohSetFootSoundId(0, 6)
	event.ObjsSetPos(1, 0.0, 114.0, -303.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(1, "屋根つかまり立ち", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetPos(3, 240.0, 0.0, -1200.0)
	event.ObjsSetMotion(3, "走行", 4)
	event.ObjsSetMotion(4, "走行", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 0, "ニヤリ口")
	event.ObjsTexAnime(4, 1, "わらい口パク")
	event.ObjsSetPos(8, 76.0, 68.0, -1100.0)
	event.ObjsSetRot(8, 0.0, 1.57, 0.0)
	event.EsmCreate_2("バギー砂煙", 34)
	event.StreamOpen3(1, 2040010)
	helper_2bd56995(1)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsInit()
	event.InitDramaScene()
	event.SndSePlay(var0, 0)
	event.CmrsSetPos(380.6, 127.31, 601.72)
	event.CmrsSetRef(243.08, 107.4, 438.53)
	event.CmrsMove(325.48, 121.86, 412.81, 208.11, 101.95, 231.83, 90)
	event.SetFadeIn(30)
	helper_e5dca676()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-160.48, 189.72, -401.22)
	event.CmrsSetRef(-1.58, 128.85, -292.36)
	event.CharaActive(0)
	event.ObjsSetMotion(0, "屋根に登る", 6)
	event.ObjsNextMotion(0, "屋根に登るL", 4)
	event.SndSePlay(var0, 1)
	event.FuncPointShow("p01_s03t", "door", 1)
	helper_c1c32f84(65)
	if vm.skipping() then
		return skip(4)
	end
	event.FuncPointShow("p01_s03t", "door", 0)
	event.CmrsSetPos(0.0, 155.31, -427.57)
	event.CmrsSetRef(0.0, 151.56, -332.61)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-9.82, 215.27, -230.06)
	event.CmrsSetRef(42.69, 136.67, -377.81)
	event.CharaActive(35)
	event.CharaActive(34)
	event.CharaActive(36)
	event.ObjsMove(3, 266.0, 0.0, -800.0, 40)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "下を見る", 6)
	event.ObjsNextMotion(0, "下を見るL", 4)
	event.PlayBgm(0)
	helper_2386f745(3)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsSetPos(240.0, 70.33, -441.97)
	event.CmrsSetRef(240.0, 35.77, -608.94)
	event.StreamPlay(1)
	event.SndSePlay(var0, 2)
	event.SndSePlay(var0, 3)
	event.ObjsAddPos(3, 0.0, 0.0, 5.0, 40)
	event.ObjsRotation2(3, 0.0, -0.46, 0.0, 6, 0, 1.0)
	event.ObjsRotation2(3, 0.0, 0.46, 0.0, 10, 0, 1.0)
	event.ObjsRotation2(3, 0.0, 0.0, 0.0, 10, 0, 1.0)
	angle = 0.0
	var3 = 0
	while var3 < 40 do
		do
			local out1, out2, out3 = event.GetCharaPos(34)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		var4 = vm.f32(vm.f32(vm.sin(angle) * 30.0) + 240.0)
		event.SetCharaPos(34, var4, var5, var6)
		angle = vm.f32(angle + vm.f32(0.15707964))
		angle = event.AngleLimit(angle) or angle
		var3 = var3 + 1
		if vm.wait() then
			return skip(8)
		end
	end
	event.CmrsSetPos(235.72, 76.51, -605.47)
	event.CmrsSetRef(235.07, 76.26, -631.38)
	event.ObjsSetMotion(4, "走行2", 4)
	event.ObjsSetMotion(3, "走行2", 4)
	helper_2386f745(3)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(4, "ニヤリ", 2)
	event.ObjsNextMotion(4, "ニヤリL", 4)
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(210.48, 75.88, -1380.83)
	event.CmrsSetRef(212.75, 63.09, -1231.67)
	event.CmrsMove(210.48, 75.88, -1380.83, 168.48, 63.09, -1255.36, 60)
	event.CharaActive(1, 38)
	event.ObjsResetMotion(8)
	event.ObjsSetMotion(8, "連射", 4)
	var7 = -1000.0
	var8 = 0
	while var8 < 4 do
		var7 = vm.f32(var7 - 20.0)
		event.ObjsSetPos(8, 76.0, 60.0, var7)
		event.ObjsPosDelay(8, 5)
		var8 = var8 + 1
	end
	var8 = 0
	while var8 < 4 do
		var7 = vm.f32(var7 + 20.0)
		event.ObjsSetPos(8, 76.0, 60.0, var7)
		event.ObjsPosDelay(8, 5)
		var8 = var8 + 1
	end
	var8 = 0
	while var8 < 4 do
		var7 = vm.f32(var7 - 20.0)
		event.ObjsSetPos(8, 76.0, 60.0, var7)
		event.ObjsPosDelay(8, 5)
		var8 = var8 + 1
	end
	event.SndSePlay(var0, 4)
	event.CharaActive(1, 37)
	event.ObjsSetPos(3, 240.0, 0.0, -1100.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "攻撃", 4, -1.0, 1)
	event.ObjsSetMotion(4, "攻撃", 4)
	helper_e5dca676()
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 38)
	event.CmrsSetPos(369.35, 68.75, -1068.56)
	event.CmrsSetRef(281.32, 69.68, -1068.4)
	event.CmrsMove(369.27, 68.75, -1111.17, 281.24, 69.68, -1111.0, 90)
	event.ObjsSetMotion(3, "ノリノリ", 4, -1.0, 1)
	event.ObjsSetMotion(4, "ノリノリ", 4)
	helper_e5dca676()
	if vm.skipping() then
		return skip(12)
	end
	event.SndSeStop(var0, 2)
	event.CharaActive(0, 37)
	event.StreamClose(1)
	event.ObjsTexAnime(4, 0, "わらい口パク")
	event.ObjsTexAnime(4, 1, "ニヤリ口")
	event.CmrsSetPos(3.09, 138.1, -353.16)
	event.CmrsSetRef(2.77, 152.0, -320.76)
	event.SndSePlay(var0, 5)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2040020)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsTexAnime(0, 0, "おこり顔")
	event.ObjsTexAnime(0, 1, "きづく顔")
	helper_42c67f56(2040030)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 0, "きづく顔")
	event.CmrsSetPos(11.47, 169.65, -362.8)
	event.CmrsSetRef(-5.1, 143.73, -320.45)
	event.SndSePlay(var0, 6)
	event.CharaActive(32)
	event.ObjsSetPos(0, 0.0, 133.53, -348.54)
	event.ObjsSetMotion(0, "振り返る", 6, 1)
	event.ObjsNextMotion(0, "振り返るL", 4)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(1, "つかまり会話", 2)
	event.ObjsNextMotion(1, "屋根つかまり立ち", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_42c67f56(2040040)
	if vm.skipping() then
		return skip(16)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(0, "振り返る会話", 2)
	event.ObjsNextMotion(0, "振り返るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2040050)
	if vm.skipping() then
		return skip(18)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(0.0, 135.98, -348.92)
	event.CmrsSetRef(0.0, 139.71, -310.0)
	event.ObjsSetPos(0, 0.0, 0.0, -348.54)
	event.ObjsSetMotion(1, "爆弾を取る", 6)
	event.ObjsNextMotion(1, "屋根つかまり立ち", 4)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(20)
	end
	event.SndSePlay(var0, 7)
	event.ObjsTexAnime(1, 0, "おこり顔")
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.CharaActive(33)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(21)
	end
	do
		local out1, out2, out3 = event.EohGetFramePos(1, "bomb")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.DelReference(33)
	event.SetCharaPos(33, pos_x, pos_y, pos_z)
	event.SetCharaRot(33, 0.0, 3.14, 0.0)
	event.SndSePlay(var0, 8)
	helper_2386f745(1)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(2040060)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(60.12, 164.95, -266.6)
	event.CmrsSetRef(-4.48, 133.95, -322.74)
	event.ObjsSetPos(0, 0.0, 133.53, -348.54)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "振り返る会話", 6, -1.0, 1)
	event.ObjsNextMotion(0, "振り返るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2040070)
	if vm.skipping() then
		return skip(24)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(1, "つかまり会話", 2)
	event.ObjsNextMotion(1, "屋根つかまり立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(2040080)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(2040085)
	if vm.skipping() then
		return skip(27)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(28)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2040090)
	if vm.skipping() then
		return skip(29)
	end
	event.SndSeStop(var0, 5)
	event.CmrsSetPos(265.45, 83.77, -902.43)
	event.CmrsSetRef(166.76, 61.63, -1102.39)
	event.SndSePlay(var0, 2)
	event.SndSePlay(var0, 9)
	event.CharaActive(1, 38)
	var7 = -1000.0
	var8 = 0
	while var8 < 4 do
		var7 = vm.f32(var7 - 20.0)
		event.ObjsSetPos(8, 76.0, 60.0, var7)
		event.ObjsPosDelay(8, 5)
		var8 = var8 + 1
	end
	var8 = 0
	while var8 < 4 do
		var7 = vm.f32(var7 + 20.0)
		event.ObjsSetPos(8, 76.0, 60.0, var7)
		event.ObjsPosDelay(8, 5)
		var8 = var8 + 1
	end
	var8 = 0
	while var8 < 4 do
		var7 = vm.f32(var7 - 20.0)
		event.ObjsSetPos(8, 76.0, 60.0, var7)
		event.ObjsPosDelay(8, 5)
		var8 = var8 + 1
	end
	event.CharaActive(1, 37)
	event.ObjsSetMotion(3, "攻撃", 4, -1.0, 1)
	event.ObjsSetMotion(4, "攻撃", 4)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(30)
	end
	event.CharaActive(0, 37)
	event.CharaActive(0, 38)
	event.CmrsSetPos(251.7, 76.66, -1109.07)
	event.CmrsSetRef(237.17, 73.79, -1129.16)
	event.ObjsSetMotion(3, "ニヤリ2", 6, -1.0, 1)
	event.ObjsNextMotion(3, "ニヤリ2L", 4)
	event.ObjsSetMotion(4, "ニヤリ2", 6)
	event.ObjsNextMotion(4, "ニヤリ2L", 4)
	helper_c1c32f84(40)
	if vm.skipping() then
		return skip(31)
	end
	event.SndSeStop(var0, 2)
	event.CmrsSetPos(19.44, 139.93, -287.75)
	event.CmrsSetRef(-8.51, 144.37, -325.96)
	event.SndSePlay(var0, 5)
	event.SndSePlay(var0, 10)
	event.ObjsSetMotion(0, "顔を戻す", 6)
	event.ObjsNextMotion(0, "やってみる！", 6)
	event.ObjsNextMotion(0, "振り返るL", 4)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(32)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2040100)
	if vm.skipping() then
		return skip(33)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(1, "つかまり会話", 2)
	event.ObjsNextMotion(1, "屋根つかまり立ち", 4)
	helper_42c67f56(2040110)
	if vm.skipping() then
		return skip(35)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(36)
	end
	event.SndSeStop(var0, 5)
	event.SndSeStop(var0, 10)
	event.CmrsSetPos(240.0, 37.39, -800.0)
	event.CmrsSetRef(240.0, 42.12, -900.0)
	event.ObjsMove(3, 240.0, 0.0, -860.0, 90)
	event.CharaActive(1, 37)
	event.SndSePlay(var0, 2)
	event.SndSePlay(var0, 11)
	event.SndSePlay(var0, 12)
	event.ObjsSetMotion(3, "攻撃戻り", 6, -1.0, 1)
	event.ObjsNextMotion(3, "走行2", 4)
	event.ObjsSetMotion(4, "攻撃戻り", 6)
	event.ObjsNextMotion(4, "走行2", 4)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(37)
	end
	event.CharaActive(0, 37)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(9, 128, 128, 128, 128, 30)
	var3 = 0
	var12 = 6.0
	var13 = 0.0
	var14 = vm.f32(0.01)
	while true do
		var12 = vm.f32(var12 - var13)
		var13 = vm.f32(var13 + var14)
		if var12 < 1.0 then
			event.ObjsSetScale(9, 1.0, 1.0, 1.0)
			break
		else
			event.ObjsSetScale(9, var12, var12, var12)
			var3 = vm.i32(var3 + 1)
			if vm.wait() then
				return skip(38)
			end
		end
	end
	helper_c1c32f84(vm.i32(70 - var3))
	if vm.skipping() then
		return skip(39)
	end
	event.SetFadeOut(10)
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(40)
	end
	return part2()
end

return helper_fd83f07e
