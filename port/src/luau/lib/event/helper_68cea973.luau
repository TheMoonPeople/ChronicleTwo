--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4bea09db = require("@lib/event/helper_4bea09db")
local helper_699116d4 = require("@lib/event/helper_699116d4")
local helper_890b5665 = require("@lib/event/helper_890b5665")

--- Helper function.
local function helper_68cea973()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_890b5665(66)
			end
			if at <= 2 then
				helper_890b5665(40)
			end
			if at <= 3 then
				helper_699116d4(3)
			end
			if at <= 4 then
				helper_890b5665(40)
			end
			if at <= 5 then
				helper_4bea09db()
			end
			if at <= 6 then
				helper_890b5665(20)
			end
			if at <= 7 then
				helper_699116d4(3)
			end
			if at <= 8 then
				helper_4bea09db()
			end
			if at <= 9 then
				helper_890b5665(20)
			end
			if at <= 10 then
				helper_890b5665(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.SndSeStop(var0, 4)
		event.LoadBgm(38)
		event.PlayBgm(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.DelImg(0)
		event.EsmClear()
		event.CharaActive(1, 0)
		event.Finish()
	end
	event.Initialize()
	event.SetFlag(724, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	event.LoadSound(7830)
	var0 = event.SndLoadSound(7830) or var0
	event.CharaActive(0, 0)
	event.ChangeDir("event/e700/e724/")
	event.LoadChara(5, "e724_boss09a.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e724_boss10a.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
	event.LoadEquip(5, 0, 4, "info", 8)
	event.LoadEquip(5, 0, 3, "info", 8)
	event.LoadEquip(5, 0, 2, "info", 8, 9)
	event.LoadMotion(5, "event/e700/e724/e724_mints.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 10)
	event.LoadEquip(5, 1, 4, "info", 10)
	event.LoadEquip(5, 1, 3, "info", 10)
	event.LoadEquip(5, 1, 2, "info", 10, 11)
	event.LoadMotion(5, "event/e700/e724/e724_monica.gltf", "info", 10)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.EohSyncChara(1, 10)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EsmInitialize(5)
	event.EsmLoadBase("グリ炎")
	event.EsmInitFix(5)
	event.EohSetPos(0, -15.0, 0.0, -100.0)
	event.EohSetRot(0, 0.0, 0.24, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 15.0, 0.0, -100.0)
	event.EohSetRot(1, 0.0, -0.24, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 3.14, 0.0)
	event.InitDramaScene()
	event.ObjsSetMotion(2, "ドスン", 6)
	event.ObjsNextMotion(2, "ドスンＬ", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 9.34, -123.04)
	event.CmrsSetRef(0.0, 27.06, -41.89)
	event.SetFadeIn(30)
	helper_890b5665(4)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var0, 0)
	helper_890b5665(66)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-27.3, 38.14, -3.46)
	event.CmrsSetRef(2.7, 38.14, -3.48)
	event.CharaActive(0, 12)
	event.CharaActive(1, 13)
	event.ObjsSetMotion(3, "ブルブル", 4)
	helper_890b5665(40)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsMove2(-28.75, 59.94, -54.17, -0.03, 57.31, -6.26, 40, 0, 0.1)
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(3, "ガバッ！", 2)
	event.ObjsNextMotion(3, "ガバッ！Ｌ", 4)
	helper_699116d4(3)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsMove2(-28.74, 34.61, -53.85, -0.01, 38.28, -6.24, 40, 0, 1.0)
	helper_890b5665(40)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 2)
	event.EsmCreate_2("グリ炎", 13)
	helper_4bea09db()
	if vm.skipping() then
		return skip(6)
	end
	helper_890b5665(20)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-10.62, 51.43, -49.36)
	event.CmrsSetRef(-0.01, 57.74, -6.24)
	event.ObjsSetMotion(3, "顔向ける", 2)
	event.ObjsNextMotion(3, "顔向けるＬ", 4)
	event.ObjsSeDelay(3, 10)
	event.ObjsSePlay(3, var0, 3)
	helper_699116d4(3)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(0.0, 34.11, -66.77)
	event.CmrsSetRef(0.0, 38.24, -8.51)
	event.CmrsMove2(0.0, 13.84, -155.54, 0.0, 34.07, -8.51, 40, 2, 0.2)
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	event.CharaActive(1, 10)
	event.CharaActive(1, 11)
	event.ObjsSetMotion(3, "構え", 2)
	event.ObjsNextMotion(3, "構えＬ", 4)
	event.ObjsSeDelay(3, 16)
	event.ObjsSePlay(3, var0, 4)
	helper_4bea09db()
	if vm.skipping() then
		return skip(9)
	end
	helper_890b5665(20)
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeOut(30)
	helper_890b5665(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

return helper_68cea973
