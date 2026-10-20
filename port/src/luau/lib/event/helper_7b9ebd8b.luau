--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")

--- Helper function.
local function helper_7b9ebd8b()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				active_chr_no = 0
				helper_c1c32f84(80)
			end
			if at <= 2 then
				helper_07cf3e45(3480010, 120)
			end
			if at <= 3 then
				helper_e5dca676()
			end
			if at <= 4 then
				helper_c1c32f84(10)
			end
			if at <= 5 then
				helper_e5dca676()
			end
			if at <= 6 then
				helper_c1c32f84(10)
			end
			if at <= 7 then
				helper_42c67f56(3480020)
			end
			if at <= 8 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSyncChara(0, 1)
		event.EohSetShow(0, 1)
		event.EohSyncChara(0, 2)
		event.EohSetShow(0, 1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaPos(0, 1390.73, -76.07, 523.09)
		event.SetCharaRot(0, 0.0, -2.28, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(348, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(524.9)
	var0 = event.SndLoadSound(3829) or var0
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 or active_chr_no ~= 1 then
		event.DngSetupMainUnit(0)
		event.SetActiveChrNo(0)
		active_chr_no = 0
	end
	event.ChangeDir("event/e300/e348/")
	event.LoadMes(0, 5, "e348.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e348_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e348_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e348_lin.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 9)
		event.LoadEquip(5, 0, 4, "info", 9)
		event.LoadEquip(5, 0, 3, "info", 9)
		event.LoadEquip(5, 0, 2, "info", 9, 10)
		event.LoadMotion(5, "event/e300/e348/e348_mints.gltf", "info", 10)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 9)
		event.EohSyncChara(0, 9)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 9)
		event.LoadEquip(5, 1, 4, "info", 9)
		event.LoadEquip(5, 1, 3, "info", 9)
		event.LoadEquip(5, 1, 2, "info", 9, 10)
		event.LoadMotion(5, "event/e300/e348/e348_monica.gltf", "info", 9)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 9)
		event.EohSyncChara(1, 9)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(9)
	event.CharaActive(10)
	event.EohSyncChara(3, 1)
	event.EohSetShow(3, 0)
	event.EohSyncChara(4, 2)
	event.EohSetShow(4, 0)
	event.EohSetPos(0, 1521.47, -107.28, 771.74)
	event.EohSetRot(0, 0.0, -2.88, 0.0)
	event.EohSetMotion(0, "歩き", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 1505.66, -106.53, 783.49)
	event.EohSetRot(1, 0.0, 3.04, 0.0)
	event.EohSetMotion(1, "歩き", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, 1506.3, -108.37, 803.96)
	event.EohSetRot(2, 0.0, -3.12, 0.0)
	event.EohSetMotion(2, "歩き", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "無表情")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.EohSetTexAnim(2, 1, "半口")
	event.ObjsMove(0, 1521.47, -107.28, 731.74, 80)
	event.ObjsMove(1, 1505.66, -106.53, 743.49, 80)
	event.ObjsMove(2, 1506.3, -108.37, 763.96, 80)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1478.0, -94.44, 748.45)
	event.CmrsSetRef(1526.09, -83.38, 795.48)
	event.CmrsMove(1478.0, -94.44, 708.45, 1526.09, -83.38, 755.48, 80)
	event.SetFadeIn(30)
	helper_c1c32f84(80)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(1635.22, -45.35, 898.95)
	event.CmrsSetRef(1509.85, -91.47, 744.47)
	event.CmrsMove2(1635.22, -45.35, 898.95, 1509.85, 36.75, 744.47, 60, 0, 1.0)
	event.ObjsSetPos(0, 1522.58, -104.86, 733.22)
	event.ObjsSetRot(0, 0.0, -2.52, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 1508.09, -104.9, 755.07)
	event.ObjsSetRot(1, 0.0, -2.76, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(2, 1536.72, -109.15, 777.79)
	event.ObjsSetRot(2, 0.0, -2.68, 0.0)
	event.ObjsMove(0, 1491.96, -99.81, 672.57, 90)
	event.ObjsMove(1, 1473.85, -100.1, 691.32, 90)
	event.ObjsMove(2, 1493.11, -100.84, 700.12, 90)
	helper_07cf3e45(3480010, 120)
	if vm.skipping() then
		return skip(3)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(4)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1459.8, -32.33, 632.79)
	event.CmrsSetRef(1494.99, -96.61, 704.05)
	event.CmrsMove2(1475.8, -54.94, 665.2, 1494.99, -84.52, 704.05, 60, 0, 1.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "上見立ち", 4)
	helper_e5dca676()
	if vm.skipping() then
		return skip(6)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(1518.17, -76.49, 671.12)
	event.CmrsSetRef(1493.05, -78.0, 693.7)
	event.ObjsSetPos(2, 1501.04, -100.84, 688.87)
	event.ObjsSetRot(2, 0.0, -2.68, 0.0)
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(1, "右向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_42c67f56(3480020)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

return helper_7b9ebd8b
