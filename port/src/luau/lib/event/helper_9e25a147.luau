--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4896c0c7 = require("@lib/event/helper_4896c0c7")
local helper_51491a96 = require("@lib/event/helper_51491a96")
local helper_9eb03a14 = require("@lib/event/helper_9eb03a14")
local helper_ab9c465c = require("@lib/event/helper_ab9c465c")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_b1f7144b = require("@lib/event/helper_b1f7144b")

--- Helper function.
local function helper_9e25a147()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_adea7ba0(30)
			end
			if at <= 2 then
				helper_4896c0c7(6240010)
			end
			if at <= 3 then
				helper_4896c0c7(6240020)
			end
			if at <= 4 then
				helper_adea7ba0(2)
			end
			if at <= 5 then
				helper_adea7ba0(120)
			end
			if at <= 6 then
				helper_9eb03a14(366, 1)
			end
			if at <= 7 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 9 then
			helper_b1f7144b()
			helper_ab9c465c(0.0, 4.0, -920.0, 0.0)
			helper_51491a96(0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.SndSeStop(var1, 0)
		event.SndSeStop(var0, 0)
		event.PlayBgm(0)
		event.EohSetShow(2, 1)
		event.EohSetShow(3, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		helper_b1f7144b()
		helper_ab9c465c(0.0, 4.0, -920.0, 0.0)
		event.SetCameraRef(0.0, 34.0, -920.0)
		event.SetCameraPos(0.0, 44.0, -800.0)
		event.ResetCamera(0)
		helper_51491a96(0)
		if vm.skipping() then
			return skip(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(632, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var0
	var1 = event.SndLoadSound(4831) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatusbarShow(0, 1.0)
	event.ChangeDir("event/e600/e624/")
	event.LoadMes(0, 5, "e624_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e624_mints.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e624_monica.gltf", "info", 0)
	end
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e632_lapis_mizu.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetEohFramePos(1, 0, "item", 0.0, 0.0, 0.0, -1)
	event.ChangeDir("")
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(2, 0)
	event.EohSetShow(3, 0)
	event.EohSetPos(0, 0.0, 4.0, -920.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-40.26, 20.64, -866.67)
	event.CmrsSetRef(-1.7, 36.27, -951.09)
	event.CmrsMove2(-29.36, 23.4, -890.54, -1.7, 36.27, -951.09, 90, 2, 1.0)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(2)
	end
	if active_chr_no == 0 then
		helper_4896c0c7(6240010)
		if vm.skipping() then
			return skip(3)
		end
	else
		helper_4896c0c7(6240020)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.CmrsInit()
	event.SndSeStop(var1, 0)
	event.SndPauseBgm()
	event.EohSyncObj(30, "p01_s1301-m-m", "s1301_3-m0")
	event.EohSetShow(30, 0)
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	if active_chr_no == 0 then
		event.CmrsSetPos(0.0, 51.31, -963.58)
		event.CmrsSetRef(0.0, 28.64, -917.36)
		event.CmrsMove2(0.0, 46.94, -952.38, 0.0, 28.64, -917.36, 120, 2, 0.4)
		event.SetCharaPos(9, 7.74, 35.0, -918.0)
		event.SetCharaRot(9, 0.2, 0.24, 0.0)
	else
		event.CmrsSetPos(0.0, 53.31, -963.58)
		event.CmrsSetRef(0.0, 30.64, -917.36)
		event.CmrsMove2(0.0, 48.94, -952.38, 0.0, 30.64, -917.36, 120, 2, 0.4)
		event.SetCharaPos(9, -4.45, 37.0, -918.0)
		event.SetCharaRot(9, 0.2, -0.24, 0.0)
	end
	event.SetMotion(9, "発動", 6)
	event.ObjsSetMotion(0, "ラピスゲット", 4, -1.0, 1)
	helper_adea7ba0(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 0)
	helper_adea7ba0(120)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var1, 1)
	helper_9eb03a14(366, 1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

return helper_9e25a147
