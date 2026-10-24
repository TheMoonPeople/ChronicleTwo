--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_12e48d20 = require("@lib/event/helper_12e48d20")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_8893edb6 = require("@lib/event/helper_8893edb6")

--- Helper function.
local function helper_4156933d()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 24 then
			if at <= 1 then
				var2 = helper_8893edb6(1)
			end
			if at <= 2 then
				helper_474c5bc8(vm.i32(10 - var2))
			end
			if at <= 3 then
				helper_474c5bc8(vm.i32(30 - var2))
			end
			if at <= 4 then
				helper_41c448af(3)
			end
			if at <= 5 then
				helper_474c5bc8(80)
			end
			if at <= 6 then
				helper_12e48d20(4200020)
			end
			if at <= 7 then
				helper_41c448af(2)
			end
			if at <= 8 then
				helper_474c5bc8(60)
			end
			if at <= 9 then
				helper_41c448af(3)
			end
			if at <= 10 then
				helper_474c5bc8(25)
			end
			if at <= 11 then
				helper_12e48d20(4200030)
			end
			if at <= 12 then
				helper_12e48d20(4200040)
			end
			if at <= 13 then
				helper_41c448af(2)
			end
			if at <= 14 then
				helper_12e48d20(4200050)
			end
			if at <= 15 then
				helper_12e48d20(4200060)
			end
			if at <= 16 then
				helper_474c5bc8(8)
			end
			if at <= 17 then
				helper_474c5bc8(30)
			end
			if at <= 18 then
				helper_41c448af(1)
			end
			if at <= 19 then
				helper_12e48d20(4200070)
			end
			if at <= 20 then
				helper_12e48d20(4200080)
			end
			if at <= 21 then
				helper_12e48d20(4200090)
			end
			if at <= 22 then
				helper_12e48d20(4200100)
			end
			if at <= 23 then
				helper_474c5bc8(30)
			end
			if vm.skip_end() then
				return skip(25)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.FuncPointShow("", "e420_lg", 0)
		event.SndSeStop(var0, 4)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetMotion(1, "立ち", 4)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(4, 1)
		event.EohSetShow(5, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(420, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	event.LoadSound(4811)
	var0 = event.SndLoadSound(4811) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e420/")
	event.LoadMes(0, 5, "e420_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e420_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e420_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e420_paw.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e420_shigu.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "mariometto_a.gltf", "info", 12)
	event.CharaActive(12)
	event.SetReference(11, "metto_null", 12)
	event.EohSyncChara(6, 12)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "e420_kanden.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e420/e420_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e420/e420_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetPos(0, -50.18, 3.08, 671.54)
	event.EohSetRot(0, 0.0, -2.9, 0.0)
	event.EohSetMotion(0, "上向くL", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -96.49, 3.79, 674.91)
	event.EohSetRot(1, 0.0, 2.78, 0.0)
	event.EohSetMotion(1, "上向くL", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -72.89, 2.34, 770.75)
	event.EohSetRot(2, 0.0, -3.02, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 16)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.EohSetPos(3, -78.16, -9.08, 455.31)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "立ち2", 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "赤目パチ")
	event.SetCharaPos(13, -78.16, -9.08, 455.31)
	event.SetCharaRot(13, 0.0, 0.0, 0.0)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.InitDramaScene()
	event.CmrsSetPos(-91.15, 8.06, 663.16)
	event.CmrsSetRef(-79.05, 47.63, 524.91)
	event.ObjsSetMotion(3, "感電", 6)
	event.ObjsNextMotion(3, "感電L", 4)
	event.SetFadeIn(30)
	event.SetMesOkuri(0, 0)
	event.StreamOpen3(1, 4200010)
	var2 = helper_8893edb6(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_474c5bc8(vm.i32(10 - var2))
	if vm.skipping() then
		return skip(3)
	end
	event.StreamPlay(1)
	helper_474c5bc8(vm.i32(30 - var2))
	if vm.skipping() then
		return skip(4)
	end
	helper_41c448af(3)
	if vm.skipping() then
		return skip(5)
	end
	event.FuncPointShow("", "e420_lg", 1)
	event.SndSePlay(var0, 4)
	event.CharaActive(1, 13)
	helper_474c5bc8(80)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 13)
	event.StreamClose(1)
	event.SetMesOkuri(0, 1)
	event.FuncPointShow("", "e420_lg", 0)
	event.CmrsSetPos(-39.38, 84.75, 556.88)
	event.CmrsSetRef(-82.55, -1.03, 671.45)
	event.ObjsMove(2, -72.44, 3.87, 634.26, 40, 1)
	event.ObjsSetMotion(2, "上見走り", 4)
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "上見立ち")
	helper_12e48d20(4200020)
	if vm.skipping() then
		return skip(7)
	end
	helper_41c448af(2)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-81.13, -20.11, 556.35)
	event.CmrsSetRef(-83.71, 9.43, 543.03)
	event.SndSeStop(var0, 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "赤目～赤目とじ")
	event.ObjsSetMotion(3, "メット落ちる", 6)
	event.ObjsNextMotion(3, "倒れる", 6)
	event.ObjsMotionWait(3)
	event.ObjsSeDelay(3, 60)
	event.ObjsSePlay(3, var0, 6)
	event.ObjsMove2(6, -75.71, -140.18, 221.57, 30, 1, 1.0)
	event.ObjsRotation2(6, 0.0, 0.0, 1.8, 30, 0, 1.0)
	event.ObjsSeDelay(6, 50)
	event.ObjsSePlay(6, var0, 5)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	helper_474c5bc8(60)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 12)
	helper_41c448af(3)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-266.34, 202.78, 745.86)
	event.CmrsSetRef(-86.65, 17.8, 537.9)
	event.CmrsSetPos(-77.85, 7.32, 623.69)
	event.CmrsSetRef(-79.23, 12.59, 599.39)
	event.CmrsQuake(0.0, 2.0, 0.0, 25)
	helper_474c5bc8(25)
	if vm.skipping() then
		return skip(11)
	end
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "苦痛目とじ")
	event.ObjsSetMotion(3, "ぐったり", 6)
	event.CmrsSetPos(-266.34, 202.78, 745.86)
	event.CmrsSetRef(-86.65, 17.8, 537.9)
	helper_12e48d20(4200030)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsMove(2, -49.93, 4.12, 578.82, 30, 1)
	event.ObjsRotation(2, 0.0, 2.78, 0.0, 10)
	event.ObjsSetMotion(2, "走り")
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "立ち")
	helper_12e48d20(4200040)
	if vm.skipping() then
		return skip(13)
	end
	helper_41c448af(2)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsInit()
	event.CmrsSetPos(-126.48, 23.27, 645.95)
	event.CmrsSetRef(-48.09, 21.64, 692.16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "わらい口パク")
	helper_12e48d20(4200050)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_12e48d20(4200060)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsMove(0, -73.29, 4.2, 606.39, 40, 1)
	event.ObjsRotDelay(0, 30)
	event.ObjsRotation(0, 0.0, 2.9, 0.0, 10)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	helper_474c5bc8(8)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsMove(1, -89.41, 4.65, 588.63, 40, 1)
	event.ObjsRotDelay(1, 30)
	event.ObjsRotation(1, 0.0, 2.18, 0.0, 10)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-23.86, 87.25, 654.66)
	event.CmrsSetRef(-59.69, 21.64, 584.77)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "半目パチ")
	helper_41c448af(1)
	if vm.skipping() then
		return skip(19)
	end
	helper_12e48d20(4200070)
	if vm.skipping() then
		return skip(20)
	end
	helper_12e48d20(4200080)
	if vm.skipping() then
		return skip(21)
	end
	helper_12e48d20(4200090)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_12e48d20(4200100)
	if vm.skipping() then
		return skip(23)
	end
	event.SetFadeOut(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(24)
	end
	return part2()
end

return helper_4156933d
