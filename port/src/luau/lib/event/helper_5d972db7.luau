--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_5d972db7()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 14 then
			if at <= 1 then
				helper_6c719c99(6160450)
			end
			if at <= 2 then
				helper_184013af()
			end
			if at <= 3 then
				helper_6c719c99(6160460)
			end
			if at <= 4 then
				helper_184013af()
			end
			if at <= 5 then
				helper_6c719c99(6160470)
			end
			if at <= 6 then
				helper_6c719c99(6160480)
			end
			if at <= 7 then
				helper_6c719c99(6160490)
			end
			if at <= 8 then
				helper_6c719c99(6160500)
			end
			if at <= 9 then
				helper_aafd6a80(30)
			end
			if at <= 10 then
				helper_6c719c99(6160510)
			end
			if at <= 11 then
				helper_6c719c99(6160520)
			end
			if at <= 12 then
				helper_6c719c99(6160530)
			end
			if at <= 13 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(15)
			end
			return part2()
		end
		if at <= 15 then
			helper_aafd6a80(30)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(16)
		end
		event.SndSeAllStop(4)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	var0 = event.SndLoadSound(6203) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e616/")
	event.LoadMes(0, 5, "e616_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e616_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e616_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e616_osmond.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e616/e616/e616_mints.chr", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e616/e616/e616_monica.chr", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.ObjsSetPos(1, 16.0, 2.56, 91.59)
	event.ObjsSetRot(1, 0.0, -0.36, 0.0)
	event.ObjsSetPos(0, -16.0, 2.56, 91.59)
	event.ObjsSetRot(0, 0.0, 0.4, 0.0)
	event.ObjsSetPos(2, -0.02, 0.4, 133.89)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(0, "下見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "下見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "立ち2")
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-0.25, 46.07, -202.38, 0.0, 0.7, 166.5)
	event.CmrsAddPas(-0.12, 46.07, -7.83, 0.0, 0.7, 166.5)
	event.CmrsStartPas()
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_6c719c99(6160440)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_6c719c99(6160450)
	if vm.skipping() then
		return skip(2)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(60)
	event.CmrsAddPas(-0.12, 46.07, -7.83, 0.0, 0.7, 166.5)
	event.CmrsAddPas(-0.09, 46.07, 32.22, 0.0, 0.7, 166.5)
	event.CmrsStartPas()
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_6c719c99(6160460)
	if vm.skipping() then
		return skip(4)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "現在から未来", 2)
	event.ObjsNextMotion(2, "立ち2")
	helper_6c719c99(6160470)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_6c719c99(6160480)
	if vm.skipping() then
		return skip(7)
	end
	helper_6c719c99(6160490)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(2, "うなづく", 2)
	event.ObjsNextMotion(2, "えっへん", 2)
	event.ObjsNextMotion(2, "えっへんループ", 4)
	event.SndSePlay(var0, 8)
	helper_6c719c99(6160500)
	if vm.skipping() then
		return skip(9)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetPos(2, 0.01, 2.56, 119.48)
	event.ObjsSetMotion(2, "立ち2", 4)
	event.CmrsSetPos(-0.08, 42.18, 169.74)
	event.CmrsSetRef(0.06, 16.11, 104.69)
	event.ObjsSetMotion(1, "右向く", 2)
	event.ObjsNextMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(6160510)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "右向く会話", 2)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(6160520)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "下→左", 6)
	event.ObjsNextMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_6c719c99(6160530)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "右向くうなづき", 2)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSetMotion(2, "うなづく", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	event.ObjsSetMotion(0, "左向くうなづき", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SndSePlay(var0, 9)
	event.SndSePlay(var0, 10)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(14)
	end
	return part2()
end

return helper_5d972db7
