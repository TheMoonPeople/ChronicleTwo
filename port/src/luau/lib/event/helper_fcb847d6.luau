--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_097407fc = require("@lib/event/helper_097407fc")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_5fe8f3bb = require("@lib/event/helper_5fe8f3bb")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_92829c19 = require("@lib/event/helper_92829c19")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_fcb847d6()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				var1 = 0.0
				helper_b0211f82(20)
			end
			if at <= 2 then
				helper_126faf7c(0)
			end
			if at <= 3 then
				helper_b0211f82(12)
			end
			if at <= 4 then
				helper_92829c19(5360060)
			end
			if at <= 5 then
				helper_5fe8f3bb()
			end
			if at <= 6 then
				helper_126faf7c(0)
			end
			if at <= 7 then
				helper_92829c19(5360070)
			end
			if at <= 8 then
				helper_92829c19(5360075)
			end
			if at <= 9 then
				helper_097407fc(1)
			end
			if at <= 10 then
				helper_dc39b923(0, -1, 8, 0, 0)
				helper_b0211f82(80)
			end
			if at <= 11 then
				helper_7e2956fd(0)
				helper_dc39b923(0, -1, 8, 0, 0)
				helper_b0211f82(60)
			end
			if at <= 12 then
				helper_7e2956fd(0)
				helper_dc39b923(0, -1, 5, 0, 0)
				var2 = 0
				var3 = 0.0
				var3 = vm.f32(var3 + vm.f32(4.266667))
				var2 = var2 + 1
			end
			if at <= 13 then
				helper_b0211f82(10)
			end
			if at <= 14 then
				var2 = 0
				var3 = 0.0
				var3 = vm.f32(var3 + vm.f32(4.266667))
				var2 = var2 + 1
			end
			if at <= 15 then
				helper_b0211f82(10)
			end
			if at <= 16 then
				var2 = 0
				var3 = 0.0
				var3 = vm.f32(var3 + vm.f32(4.266667))
				var2 = var2 + 1
			end
			if at <= 17 then
				helper_b0211f82(40)
			end
			if at <= 18 then
				var2 = 0
				var3 = 128.0
				var3 = vm.f32(var3 - vm.f32(4.266667))
				var2 = var2 + 1
			end
			if at <= 19 then
				helper_7e2956fd(0)
				helper_097407fc(1)
			end
			if at <= 20 then
				helper_dc39b923(0, -1, 5, 0, 0)
				var2 = 0
				var3 = 0.0
				var3 = vm.f32(var3 + vm.f32(1.4222223))
				var2 = var2 + 1
			end
			if at <= 21 then
				helper_b0211f82(60)
			end
			if at <= 22 then
				helper_b0211f82(30)
			end
			helper_7e2956fd(0)
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SetTimeStepEnable(1)
		event.SetTime(var1)
		event.SpriteSetDraw(0, 0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.CmrsInit()
		event.SetStatusbarShow(1, 1.0)
		event.CharaActive(0)
	end
	event.SetFlag(536, 1)
	event.LoadSound(5824)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_b0211f82(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(112)
	event.PlayBgm(0)
	event.LoadSound(5824)
	var0 = event.SndLoadSound(5824) or var0
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e536/")
	event.LoadMes(0, 5, "e536_1.txt")
	event.LoadChara(5, "e536_y_guil.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e536_haha.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e536_door.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e536_chair.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncObj(4, "p01_s4901")
	event.EohSetShow(4, 0)
	event.EohSyncObj(5, "p08_ai02a")
	event.EohSetPos(5, 0.0, 0.0, 10.0)
	event.EohSyncObj(5, "p08_ai02a", "ai020801-m")
	event.EohSetShow(5, 0)
	event.SetStatus(1, 10, 64, 1)
	event.SetStatus(1, 11, 64, 1)
	event.EohSetPos(0, -33.0, 0.0, 71.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.EohSetSoundId(0, var0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "わらい顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 15.0, 0.0, -24.400002)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSetMotion(1, "座り", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -33.0, 0.0, 71.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetPos(3, 10.0, 0.0, 4.0)
	event.EohSetRot(3, 0.0, -2.41, 0.0)
	event.InitDramaScene()
	var1 = 0.0
	event.GetTime() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.SetTimeStepEnable(0)
	event.SetTime(12.0)
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(0, "ドア開け", 6)
	event.ObjsNextMotion(0, "ドア開けL", 4)
	event.ObjsSetMotion(2, "ドア開け", 6)
	event.ObjsNextMotion(2, "待機", 4)
	event.CmrsInit()
	event.CmrsSetPos(61.97, 46.56, -61.97)
	event.CmrsSetRef(15.12, 25.71, 12.05)
	event.CmrsMove2(61.97, 46.56, -61.97, -5.06, 25.71, -5.5, 60, 2, 1.0)
	event.SetFadeIn(30)
	helper_b0211f82(20)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "左見る", 2)
	event.ObjsNextMotion(1, "左見るL", 4)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_b0211f82(12)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 8)
	event.SetPakuAnim(0, "わらい口パク")
	helper_92829c19(5360060)
	if vm.skipping() then
		return skip(5)
	end
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-34.76, 39.67, -42.6)
	event.CmrsSetRef(21.19, 24.21, -4.58)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "わらい顔")
	event.EohSetTexAnim(0, 1, "目あき～目とじ")
	event.SndSePlay(var0, 9)
	event.ObjsSetPos(0, 10.0, 0.0, 4.0)
	event.ObjsSetRot(0, 0.0, -2.41, 0.0)
	event.ObjsSetMotion(0, "座る", 6)
	event.ObjsNextMotion(0, "座るL", 4)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "下向く", 2)
	event.ObjsNextMotion(0, "下向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_92829c19(5360070)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_92829c19(5360075)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(34.3, 21.14, 15.6)
	event.CmrsSetRef(11.3, 24.63, -18.3)
	event.CmrsMove2(34.3, 21.14, 15.6, 3.12, 20.97, -11.09, 120, 2, 1.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "わらい顔")
	event.EohSetTexAnim(0, 1, "目とじ～目あき")
	event.ObjsSetMotion(0, "座り会話入り", 2)
	event.ObjsNextMotion(0, "座り会話", 4)
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "わらい口パク")
	event.StreamOpen3(1, 5360080)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(10)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 5360080)
	event.SetMesDrawspeed(0, 0)
	helper_dc39b923(0, -1, 8, 0, 0)
	helper_b0211f82(80)
	if vm.skipping() then
		return skip(11)
	end
	helper_7e2956fd(0)
	event.EohSetTexAnim(0, 1, "わらい口パク")
	event.MesMake_2(0, 5360085)
	event.SetMesDrawspeed(0, 0)
	helper_dc39b923(0, -1, 8, 0, 0)
	event.SetFadeOut(60, 255, 255, 255)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(12)
	end
	helper_7e2956fd(0)
	event.SetMesWindowMode(0, 11)
	event.SetMesOkuri(0, 0)
	event.SetFadeIn(0)
	event.SpriteSetDraw(0, 1)
	event.MesMake_2(0, 5360090)
	event.SetMesDrawspeed(0, 0)
	helper_dc39b923(0, -1, 5, 0, 0)
	var2 = 0
	var3 = 0.0
	while var2 < 30 do
		event.SetMesEtc(0, 6, 0, var3)
		event.SetMesEtc(0, 6, 1, 0)
		event.SetMesEtc(0, 6, 2, 0)
		var3 = vm.f32(var3 + vm.f32(4.266667))
		var2 = var2 + 1
		if vm.wait() then
			return skip(13)
		end
	end
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(14)
	end
	var2 = 0
	var3 = 0.0
	while var2 < 30 do
		event.SetMesEtc(0, 6, 0, 128)
		event.SetMesEtc(0, 6, 1, var3)
		event.SetMesEtc(0, 6, 2, 0)
		var3 = vm.f32(var3 + vm.f32(4.266667))
		var2 = var2 + 1
		if vm.wait() then
			return skip(15)
		end
	end
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(16)
	end
	var2 = 0
	var3 = 0.0
	while var2 < 30 do
		event.SetMesEtc(0, 6, 0, 128)
		event.SetMesEtc(0, 6, 1, 128)
		event.SetMesEtc(0, 6, 2, var3)
		var3 = vm.f32(var3 + vm.f32(4.266667))
		var2 = var2 + 1
		if vm.wait() then
			return skip(17)
		end
	end
	helper_b0211f82(40)
	if vm.skipping() then
		return skip(18)
	end
	var2 = 0
	var3 = 128.0
	while var2 < 30 do
		event.SetMesEtc(0, 6, 0, var3)
		event.SetMesEtc(0, 6, 1, var3)
		event.SetMesEtc(0, 6, 2, var3)
		var3 = vm.f32(var3 - vm.f32(4.266667))
		var2 = var2 + 1
		if vm.wait() then
			return skip(19)
		end
	end
	helper_7e2956fd(0)
	event.StreamClose(1)
	event.StreamOpen3(1, 5360095)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(0, 5360095)
	event.SetMesDrawspeed(0, 0)
	helper_dc39b923(0, -1, 5, 0, 0)
	var2 = 0
	var3 = 0.0
	while var2 < 90 do
		if var2 == 30 then
			event.StreamPlay(1)
		end
		event.SetMesEtc(0, 6, 0, var3)
		var3 = vm.f32(var3 + vm.f32(1.4222223))
		var2 = var2 + 1
		if vm.wait() then
			return skip(21)
		end
	end
	event.SetMesEtc(0, 6, 0, 128)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(22)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30, 255, 255, 255)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(23)
	end
	helper_7e2956fd(0)
	event.SetMesOkuri(0, 1)
	event.StreamClose(1)
	return part2()
end

return helper_fcb847d6
