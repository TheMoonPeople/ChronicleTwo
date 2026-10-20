--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f8e2df2 = require("@lib/event/helper_1f8e2df2")
local helper_4bea09db = require("@lib/event/helper_4bea09db")
local helper_699116d4 = require("@lib/event/helper_699116d4")
local helper_890b5665 = require("@lib/event/helper_890b5665")

--- Helper function.
local function helper_9a07ee86()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_4bea09db()
			end
			if at <= 2 then
				helper_1f8e2df2(6400090, -1)
			end
			if at <= 3 then
				helper_699116d4(2)
			end
			if at <= 4 then
				helper_890b5665(20)
			end
			if at <= 5 then
				helper_1f8e2df2(6400095, -1)
			end
			if at <= 6 then
				helper_699116d4(2)
			end
			if at <= 7 then
				helper_890b5665(30)
			end
			if at <= 8 then
				helper_699116d4(2)
			end
			if at <= 9 then
				helper_1f8e2df2(6400100, -1)
			end
			if at <= 10 then
				helper_890b5665(60)
			end
			if at <= 11 then
				helper_699116d4(2)
			end
			if at <= 12 then
				helper_890b5665(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SetMotionBlur(0)
		event.BgmLoadCancel()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_890b5665(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(33)
	event.PlayBgm(0)
	event.LoadSound(6208)
	var0 = event.SndLoadSound(6208) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e640_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e640_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e640_griffon.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_grigokou.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -12.69, 210.91, 31.92)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, -12.69, 210.91, 31.92)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CharaActive(0, 35)
	event.CmrsInit()
	event.CmrsSetPos(-16.84, 208.3, 357.29)
	event.CmrsSetRef(-12.28, 234.47, 95.52)
	event.SetFadeIn(30)
	event.SetMotionBlur(100)
	event.CmrsMove2(-13.43, 263.98, 96.05, -12.81, 265.44, 61.96, 60, 2, 1.0)
	helper_4bea09db()
	if vm.skipping() then
		return skip(2)
	end
	event.SetCrossfade(30)
	event.SetMotionBlur(0)
	event.CmrsMove2(-13.21, 262.59, 85.71, -12.24, 265.7, 32.15, 300, 2, 1.0)
	event.ObjsSetMotion(2, "会話翼閉じ")
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "立ち翼閉じ", 4)
	helper_1f8e2df2(6400090, -1)
	if vm.skipping() then
		return skip(3)
	end
	helper_699116d4(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_890b5665(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "会話翼閉じ")
	helper_1f8e2df2(6400095, -1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsNextMotion(2, "立ち翼閉じ", 4)
	helper_699116d4(2)
	if vm.skipping() then
		return skip(7)
	end
	helper_890b5665(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsInit()
	event.CmrsSetPos(17.28, 279.9, 82.24)
	event.CmrsSetRef(-12.04, 265.49, 33.59)
	helper_699116d4(2)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(2, "会話翼閉じ")
	event.ObjsMotionDelay(2, 120)
	event.ObjsNextMotion(2, "広げ", 6)
	event.ObjsNextMotion(2, "広げＬ", 4)
	event.CmrsPrdelay(110)
	event.CmrsSetPos(-12.04, 271.55, 72.44)
	event.CmrsSetRef(-12.55, 264.36, 33.58)
	event.CmrsMove2(-13.58, 244.64, 142.02, -12.47, 253.04, 34.41, 60, 0, 0.5)
	event.ObjsSeDelay(2, 110)
	event.ObjsSePlay(2, var0, 0)
	event.ObjsMotionDelay(2, 110)
	helper_1f8e2df2(6400100, -1)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(35)
	event.SetCharaShow(35, 1, 1, 0.033333335)
	helper_890b5665(60)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(2, "コントロール", 6)
	event.ObjsNextMotion(2, "コントロールＬ", 4)
	helper_699116d4(2)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeOut(30)
	helper_890b5665(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

return helper_9a07ee86
