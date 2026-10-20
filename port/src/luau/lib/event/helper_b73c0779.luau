--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4bea09db = require("@lib/event/helper_4bea09db")
local helper_699116d4 = require("@lib/event/helper_699116d4")
local helper_890b5665 = require("@lib/event/helper_890b5665")

--- Helper function.
local function helper_b73c0779()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 14 then
			if at <= 1 then
				helper_890b5665(60)
			end
			if at <= 2 then
				helper_4bea09db()
			end
			if at <= 3 then
				helper_890b5665(6)
			end
			if at <= 4 then
				helper_699116d4(2)
			end
			if at <= 5 then
				helper_699116d4(2)
			end
			if at <= 6 then
				helper_699116d4(2)
			end
			if at <= 7 then
				helper_890b5665(20)
			end
			if at <= 8 then
				helper_4bea09db()
			end
			if at <= 9 then
				helper_890b5665(60)
			end
			if at <= 10 then
				helper_890b5665(240)
			end
			if at <= 11 then
				helper_699116d4(3)
			end
			if at <= 12 then
				helper_890b5665(40)
			end
			if at <= 13 then
				helper_890b5665(30)
			end
			if vm.skip_end() then
				return skip(15)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.PlayBgm(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.Finish()
	end
	event.Initialize()
	event.SetFlag(720, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_890b5665(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(38)
	event.LoadSound(7827)
	var0 = event.SndLoadSound(7827) or var0
	event.CharaActive(0, 0)
	event.ChangeDir("event/e700/e720/")
	event.LoadChara(5, "e720_boss08a.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e720_boss09a.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e720_eye.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.LoadChara(5, "e720_hane.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.LoadChara(5, "e720_hane2.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.ChangeDir("")
	event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
	event.LoadEquip(5, 0, 4, "info", 8)
	event.LoadEquip(5, 0, 3, "info", 8)
	event.LoadEquip(5, 0, 2, "info", 8, 9)
	event.LoadMotion(5, "event/e700/e720/e720_mints.gltf", "info", 8)
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 10)
	event.LoadEquip(5, 1, 4, "info", 10)
	event.LoadEquip(5, 1, 3, "info", 10)
	event.LoadEquip(5, 1, 2, "info", 10, 11)
	event.LoadMotion(5, "event/e700/e720/e720_monica.gltf", "info", 10)
	event.CharaActive(10)
	event.CharaActive(11)
	event.EohSyncChara(1, 10)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSetPos(0, -8.0, 0.0, -300.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 8.0, 0.0, -300.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 3.14, 0.0)
	event.SetCharaPos(14, 0.0, 54.23, -19.48)
	event.SetCharaRot(14, 0.0, 3.14, 0.0)
	event.SetCharaPos(15, 0.0, 0.0, 0.0)
	event.SetCharaRot(15, 0.0, 3.14, 0.0)
	event.SetCharaPos(16, 0.0, 0.0, -300.0)
	event.SetCharaRot(16, 0.0, -0.3, 0.0)
	event.InitDramaScene()
	event.ObjsSetMotion(2, "落ち立つ", 6)
	event.ObjsNextMotion(2, "落ち立つＬ", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 47.27, -59.93)
	event.CmrsSetRef(0.0, 54.56, 0.0)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_890b5665(60)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 1)
	event.CmrsMove2(0.0, 13.39, -110.66, 0.0, 40.47, 0.0, 40, 0, 0.2)
	helper_4bea09db()
	if vm.skipping() then
		return skip(3)
	end
	helper_890b5665(6)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-10.28, 38.76, -46.62)
	event.CmrsSetRef(-43.29, 78.66, 15.21)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "羽広げ", 6)
	event.ObjsMotionWait(2)
	helper_699116d4(2)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(10.28, 38.76, -46.62)
	event.CmrsSetRef(43.29, 78.66, 15.21)
	event.SndSePlay(var0, 2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "羽広げ", 6)
	event.ObjsMotionWait(2)
	helper_699116d4(2)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(0.0, 24.76, -90.76)
	event.CmrsSetRef(0.0, 52.6, 0.0)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "掴む", 6)
	event.ObjsNextMotion(2, "掴むＬ", 4)
	helper_699116d4(2)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(0.0, 48.79, -25.5)
	event.CmrsSetRef(0.0, 58.19, -16.62)
	event.SndSePlay(var0, 4)
	event.CharaActive(0, 12)
	event.CharaActive(1, 13)
	event.CharaActive(1, 14)
	event.SetMotion(14, "光る", 6)
	helper_890b5665(20)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-29.82, 47.88, -38.26)
	event.CmrsSetRef(-0.06, 56.08, -3.93)
	event.CmrsMove2(-115.99, 6.24, -137.7, -0.06, 47.97, -3.93, 40, 2, 1.0)
	event.SndSePlay(var0, 5)
	event.CharaActive(0, 14)
	event.CharaActive(1, 15)
	event.ObjsSetMotion(3, "バサ", 6)
	event.ObjsNextMotion(3, "バサＬ", 4)
	event.SetMotion(15, "バサ", 6)
	helper_4bea09db()
	if vm.skipping() then
		return skip(9)
	end
	helper_890b5665(60)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-30.14, 11.81, -262.23)
	event.CmrsSetRef(0.94, 19.52, -298.52)
	event.CharaActive(0, 15)
	event.CharaActive(1, 16)
	event.SetMotion(16, "舞う羽根", 6)
	helper_890b5665(240)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(0.0, 34.0, -110.0)
	event.CmrsSetRef(0.0, 34.0, -20.0)
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(3, "構え", 6)
	event.ObjsNextMotion(3, "構えＬ", 4)
	helper_699116d4(3)
	if vm.skipping() then
		return skip(12)
	end
	helper_890b5665(40)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_890b5665(30)
	if vm.skipping() then
		return skip(14)
	end
	return part2()
end

return helper_b73c0779
