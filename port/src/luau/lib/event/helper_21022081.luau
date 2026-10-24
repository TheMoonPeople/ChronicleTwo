--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c3ce9c48 = require("@lib/event/helper_c3ce9c48")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_f9fe2856 = require("@lib/event/helper_f9fe2856")

--- Helper function.
local function helper_21022081()
	local var0: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				helper_ed0a80b8(14)
			end
			if at <= 2 then
				helper_e2d04ed9(1)
			end
			if at <= 3 then
				helper_c3ce9c48(4060030)
			end
			if at <= 4 then
				helper_e2d04ed9(0)
			end
			if at <= 5 then
				helper_e2d04ed9(2)
			end
			if at <= 6 then
				helper_c3ce9c48(4060040)
			end
			if at <= 7 then
				helper_c3ce9c48(4060044)
			end
			if at <= 8 then
				helper_c3ce9c48(4060048)
			end
			if at <= 9 then
				helper_e2d04ed9(1)
			end
			if at <= 10 then
				helper_c3ce9c48(4060050)
			end
			if at <= 11 then
				helper_e2d04ed9(0)
			end
			if at <= 12 then
				helper_e2d04ed9(2)
			end
			if at <= 13 then
				helper_c3ce9c48(4060055)
			end
			if at <= 14 then
				helper_c3ce9c48(4060060)
			end
			if at <= 15 then
				helper_c3ce9c48(4060070)
			end
			if at <= 16 then
				helper_e2d04ed9(0)
			end
			if at <= 17 then
				helper_e2d04ed9(2)
			end
			if at <= 18 then
				helper_f9fe2856()
			end
			if at <= 19 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetTimeStepEnable(1)
		event.SetTime(time)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.StopBgm(0)
		if vm.wait() then
			return skip(22)
		end
	end
	event.SetFlag(406, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.SoundAllStop()
	event.LoadBgm(58)
	event.PlayBgm(0)
	event.LoadSound(4801)
	var0 = event.SndLoadSound(4801) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e400/e406/")
	event.LoadMes(0, 5, "e406_1.txt")
	event.LoadChara(5, "e406_minchu.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e406_eina.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e406_bed.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "寝てる", 4)
	event.SetReference(10, "minchu", 8)
	event.EohSetSoundId(0, var0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 64.33, 13.21, 70.24)
	event.EohSetRot(1, 0.0, -1.48, 0.0)
	event.EohSetMotion(1, "本読む", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "目パチ")
	event.SetCharaPos(10, 58.0, 13.0, 108.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.SetMotion(10, "寝てる", 4)
	time = event.GetTime() or time
	event.SetTime(22.0)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetPos(-25.28, 87.45, 28.6)
	event.CmrsSetRef(68.06, 28.91, 95.45)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.SetPakuAnim(1, "口パク")
	helper_c3ce9c48(4060020)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(1, "本閉じる", 2)
	event.ObjsNextMotion(1, "ユリス見るL", 4)
	helper_ed0a80b8(14)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 0)
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(62.04, 40.15, 70.68)
	event.CmrsSetRef(59.03, 34.16, 100.4)
	event.ObjsSetMotion(0, "エイナを見る", 6)
	event.ObjsNextMotion(0, "エイナを見るL", 4)
	event.ObjsSetMotion(2, "エイナを見る", 6)
	event.ObjsNextMotion(2, "エイナを見るL", 4)
	event.SndSePlay(var0, 1)
	event.SetPakuAnim(0, "しんけん口パク")
	helper_c3ce9c48(4060030)
	if vm.skipping() then
		return skip(4)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(43.31, 40.29, 81.27)
	event.CmrsSetRef(72.59, 39.24, 71.2)
	event.SetPakuAnim(1, "口パク")
	helper_c3ce9c48(4060040)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(3.77, 60.04, 42.87)
	event.CmrsSetRef(71.41, 28.24, 86.89)
	event.ObjsSetMotion(1, "上を見る", 6)
	event.ObjsNextMotion(1, "上を見るL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_c3ce9c48(4060044)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "口パク")
	helper_c3ce9c48(4060048)
	if vm.skipping() then
		return skip(9)
	end
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(62.04, 40.15, 70.68)
	event.CmrsSetRef(59.03, 35.79, 100.4)
	event.SetPakuAnim(0, "しんけん口パク")
	helper_c3ce9c48(4060050)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "起きる", 6)
	event.ObjsNextMotion(0, "起きるL", 4)
	event.ObjsSetMotion(2, "起きる", 6)
	event.ObjsNextMotion(2, "起きるL", 4)
	event.SndSePlay(var0, 2)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(12)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(0, "しんけん口パク")
	helper_c3ce9c48(4060055)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(48.78, 37.2, 87.09)
	event.CmrsSetRef(65.24, 40.1, 73.06)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "わらい目")
	event.ObjsSetMotion(1, "ユリス見るL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_c3ce9c48(4060060)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(61.65, 38.17, 78.76)
	event.CmrsSetRef(58.54, 38.63, 100.33)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "起きる会話", 6)
	event.ObjsNextMotion(0, "起きるL", 4)
	event.ObjsSetMotion(2, "起きる会話", 6)
	event.ObjsNextMotion(2, "起きるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(4060070)
	if vm.skipping() then
		return skip(16)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(17)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目あき～目とじ")
	event.CmrsMove2(60.7, 40.1, 85.35, 58.54, 40.56, 100.33, 40, 0, 0.2)
	helper_f9fe2856()
	if vm.skipping() then
		return skip(19)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

return helper_21022081
