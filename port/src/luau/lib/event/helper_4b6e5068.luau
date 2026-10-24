--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_92829c19 = require("@lib/event/helper_92829c19")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")

--- Helper function.
local function helper_4b6e5068()
	local time: f32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 31 then
			if at <= 1 then
				helper_b0211f82(30)
			end
			if at <= 2 then
				helper_92829c19(5320280)
			end
			if at <= 3 then
				helper_92829c19(5320290)
			end
			if at <= 4 then
				helper_126faf7c(0)
			end
			if at <= 5 then
				helper_92829c19(5320295)
			end
			if at <= 6 then
				helper_126faf7c(0)
			end
			if at <= 7 then
				helper_92829c19(5320300)
			end
			if at <= 8 then
				helper_92829c19(5320305)
			end
			if at <= 9 then
				helper_92829c19(5320310)
			end
			if at <= 10 then
				helper_126faf7c(1)
			end
			if at <= 11 then
				helper_92829c19(5320315)
			end
			if at <= 12 then
				helper_126faf7c(1)
			end
			if at <= 13 then
				helper_92829c19(5320320)
			end
			if at <= 14 then
				helper_126faf7c(1)
			end
			if at <= 15 then
				helper_92829c19(5320323)
			end
			if at <= 16 then
				helper_92829c19(5320325)
			end
			if at <= 17 then
				helper_126faf7c(1)
			end
			if at <= 18 then
				helper_92829c19(5320330)
			end
			if at <= 19 then
				helper_92829c19(5320335)
			end
			if at <= 20 then
				helper_92829c19(5320340)
			end
			if at <= 21 then
				helper_92829c19(5320345)
			end
			if at <= 22 then
				helper_126faf7c(0)
			end
			if at <= 23 then
				helper_92829c19(5320350)
			end
			if at <= 24 then
				helper_92829c19(5320360)
			end
			if at <= 25 then
				helper_126faf7c(1)
			end
			if at <= 26 then
				helper_92829c19(5320370)
			end
			if at <= 27 then
				helper_126faf7c(0)
			end
			if at <= 28 then
				helper_92829c19(5320375)
			end
			if vm.skip_end() then
				return skip(32)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCrossfade(60)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.LoadMes(0, -1)
		event.CmrsInit()
		event.SetStatusbarShow(1, 1.0)
		event.CharaActive(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(532, 1)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.LoadSound(5821)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadSound(5821)
	var1 = event.SndLoadSound(5821) or var1
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e532/")
	event.LoadMes(0, 5, "e532_1.txt")
	event.LoadChara(5, "e532_y_guil.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e532_haha.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e532_bed.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetReference(10, "haha", 9)
	event.ChangeDir("")
	event.EohSetPos(0, 70.0, 0.0, 10.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "寝てる", 4)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "寝てる", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "わらい顔")
	event.EohSetTexAnim(1, 1, "くるし目パチ")
	event.EohSetPos(2, 70.0, 0.0, 10.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "寝てる", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(39.84, 60.52, -60.15)
	event.CmrsSetRef(66.03, 22.1, 15.31)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320280)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "寝てる会話", 2)
	event.ObjsNextMotion(0, "寝てる", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(5320290)
	if vm.skipping() then
		return skip(4)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "目あき～目とじ")
	event.ObjsSetMotion(0, "首ふる", 2)
	event.ObjsNextMotion(0, "寝てる", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(5320295)
	if vm.skipping() then
		return skip(6)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(44.6, 20.65, 33.29)
	event.CmrsSetRef(64.25, 16.57, 22.61)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "苦しい", 2)
	event.ObjsNextMotion(1, "寝てる", 4)
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "くるし目パチ２")
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "くるし目パチ")
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "苦しい", 2)
	event.ObjsNextMotion(2, "寝てる", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320300)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320305)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320310)
	if vm.skipping() then
		return skip(10)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "苦しい", 2)
	event.ObjsNextMotion(1, "寝てる", 4)
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "くるし目パチ２")
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "くるし目パチ")
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "苦しい", 2)
	event.ObjsNextMotion(2, "寝てる", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320315)
	if vm.skipping() then
		return skip(12)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "上向く", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsSetMotion(2, "上向く", 2)
	event.ObjsNextMotion(2, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320320)
	if vm.skipping() then
		return skip(14)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320323)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "上向く戻り", 2)
	event.ObjsNextMotion(1, "寝てる", 4)
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "前向き～左向き")
	event.ObjsTexAnime(1, 1, "前向き～左向き")
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "上向く戻り", 2)
	event.ObjsNextMotion(2, "寝てる", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320325)
	if vm.skipping() then
		return skip(17)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(93.32, 20.1, 22.37)
	event.CmrsSetRef(63.34, 19.1, 24.49)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "わらい顔")
	event.EohSetTexAnim(1, 1, "くるし目パチ")
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320330)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320335)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(5320340)
	if vm.skipping() then
		return skip(21)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "目あき～目とじ")
	event.ObjsSetMotion(0, "首ふる", 2)
	event.ObjsNextMotion(0, "寝てる", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(5320345)
	if vm.skipping() then
		return skip(22)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(44.6, 20.65, 33.29)
	event.CmrsSetRef(64.25, 16.57, 22.61)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(5320350)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(1, "死", 2)
	event.ObjsNextMotion(1, "死L", 4)
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "ゆっくり目とじ")
	event.ObjsSetMotion(2, "死", 2)
	event.ObjsNextMotion(2, "死L", 4)
	event.SetPakuAnim(1, "わらい口パク２")
	helper_92829c19(5320360)
	if vm.skipping() then
		return skip(25)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(93.32, 20.1, 22.37)
	event.CmrsSetRef(63.34, 19.1, 24.49)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "死に")
	event.SndSePlay(var1, 11)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目～おどろき目")
	event.ObjsSetMotion(0, "母さん！！", 6)
	event.ObjsNextMotion(0, "母さん！！L", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(5320370)
	if vm.skipping() then
		return skip(27)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSePlay(var1, 12)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.ObjsSetMotion(0, "目を開けて", 2)
	event.ObjsNextMotion(0, "目を開けてL", 4)
	event.ObjsSetMotion(1, "目を開けて", 2)
	event.ObjsNextMotion(1, "目を開けてL", 4)
	event.ObjsSetMotion(2, "目を開けて", 2)
	event.ObjsNextMotion(2, "目を開けてL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(5320375)
	if vm.skipping() then
		return skip(29)
	end
	if vm.wait() then
		return skip(30)
	end
	if vm.wait() then
		return skip(31)
	end
	return part2()
end

return helper_4b6e5068
