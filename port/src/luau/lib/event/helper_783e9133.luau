--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_783e9133()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 19 then
			if at <= 1 then
				helper_6c719c99(7000140)
			end
			if at <= 2 then
				helper_6c719c99(7000150)
			end
			if at <= 3 then
				helper_8f31f334(2)
			end
			if at <= 4 then
				helper_6c719c99(7000160)
			end
			if at <= 5 then
				helper_6c719c99(7000165)
			end
			if at <= 6 then
				helper_6c719c99(7000170)
			end
			if at <= 7 then
				helper_aafd6a80(30)
			end
			if at <= 8 then
				helper_184013af()
			end
			if at <= 9 then
				helper_aafd6a80(20)
			end
			if at <= 10 then
				helper_aafd6a80(90)
			end
			if at <= 11 then
				helper_aafd6a80(40)
			end
			if at <= 12 then
				helper_6c719c99(7000180)
			end
			if at <= 13 then
				helper_8f31f334(1)
			end
			if at <= 14 then
				helper_6c719c99(7000190)
			end
			if at <= 15 then
				helper_aafd6a80(10)
			end
			if at <= 16 then
				helper_aafd6a80(10)
			end
			if at <= 17 then
				helper_aafd6a80(30)
			end
			if at <= 18 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(20)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
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
	event.SetFlag(700, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.LoadSound(7204)
	var1 = event.SndLoadSound(7204) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e700/")
	event.LoadMes(0, 5, "e700_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e700_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e700_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e700_andrea.gltf", "info", 34)
	event.SetStatus(1, 34, 8, 1)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e700_a_hikari.gltf", "info", 35)
	event.SetCharaType(35, 4)
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
		event.LoadMotion(5, "event/e700/e700/e700_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e700/e700/e700_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 7.0, 0.0, 200.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "上向くL", 4)
	event.EohSetFootSoundId(0, 7)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -7.0, 0.0, 198.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "上向くL", 4)
	event.EohSetFootSoundId(1, 7)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 0.0, 20.0, 160.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetMotion(2, "両手開くＬ", 4)
	event.EohSetPos(3, 11.0, 40.0, 160.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "後光", 4)
	event.InitDramaScene()
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.CmrsInit()
	event.CmrsSetPos(24.65, 49.97, 163.5)
	event.CmrsSetRef(-24.72, 49.99, 159.92)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目あけ～目とじ２")
	event.ObjsSetMotion(2, "両手開いて深呼吸", 2)
	event.ObjsNextMotion(2, "両手開いて深呼吸Ｌ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(7000140)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(0.0, 17.98, 252.41)
	event.CmrsSetRef(0.0, 26.48, 201.7)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ３")
	event.ObjsSetPos(3, 0.0, 40.0, 160.0)
	event.ObjsSetMotion(2, "両手開く戻り", 6)
	event.ObjsNextMotion(2, "浮遊立ち", 4)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000150)
	if vm.skipping() then
		return skip(3)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(0.0, 48.71, 192.39)
	event.CmrsSetRef(0.0, 48.68, 135.78)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000160)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000165)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目あき～さみし目とじ")
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000170)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(0.0, 39.02, 371.19)
	event.CmrsSetRef(0.0, 38.99, 314.58)
	event.SndSePlay(var1, 2)
	event.SetCharaShow(34, 0, 1, 0.033333335)
	event.ObjsSetMotion(3, "消失", 2)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsMove2(0.0, 39.02, 371.19, 0.0, 61.67, 314.58, 60, 0, 0.2)
	helper_184013af()
	if vm.skipping() then
		return skip(9)
	end
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(10)
	end
	event.SetTime(time)
	event.SetCrossfade(60)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(23.26, 26.93, 164.88)
	event.CmrsSetRef(-0.0, 18.34, 203.74)
	helper_aafd6a80(40)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "上→左", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 3)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "上から右", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSeDelay(1, 30)
	event.ObjsSePlay(1, var1, 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(7000180)
	if vm.skipping() then
		return skip(13)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(7000190)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(1, "右向く戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var1, 6)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 5)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(16)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(17)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目～おこり目")
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(18)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(19)
	end
	return part2()
end

return helper_783e9133
