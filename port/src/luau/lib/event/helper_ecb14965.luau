--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_ecb14965()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_6c719c99(8120010)
			end
			if at <= 2 then
				helper_6c719c99(8120020)
			end
			if at <= 3 then
				helper_8f31f334(1)
			end
			if at <= 4 then
				helper_6c719c99(8120030)
			end
			if at <= 5 then
				helper_8f31f334(0)
			end
			if at <= 6 then
				helper_6c719c99(8120040)
			end
			if at <= 7 then
				helper_6c719c99(8120045)
			end
			if at <= 8 then
				helper_8f31f334(2)
			end
			if at <= 9 then
				helper_184013af()
			end
			if at <= 10 then
				helper_aafd6a80(10)
			end
			if at <= 11 then
				helper_aafd6a80(30)
			end
			if at <= 12 then
				helper_6c719c99(8120050)
			end
			if at <= 13 then
				helper_6c719c99(8120060)
			end
			if at <= 14 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(812, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.LoadSound(8806)
	var1 = event.SndLoadSound(8806) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e812/")
	event.LoadMes(0, 5, "e812_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e812_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e812_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e812_m_polcurse.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e812_mp_bakuha.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.LoadChara(5, "e812_mp_biribiri.gltf", "info", 12)
	event.CharaActive(12)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e812/e812_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e800/e812/e812_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, 8.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -8.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "あきれ顔")
	event.EohSetTexAnim(1, 1, "あきれ目パチ")
	event.EohSetPos(2, 0.0, 0.0, 400.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "ガクガク", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くやし顔")
	event.EohSetTexAnim(2, 1, "やられ目パチ")
	event.SetCharaPos(12, 0.0, 0.0, 400.0)
	event.SetCharaRot(12, 0.0, 3.14, 0.0)
	event.SetCharaPos(11, 0.0, 0.0, 400.0)
	event.SetCharaRot(11, 0.0, 3.14, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.0, 20.91, 290.09)
	event.CmrsSetRef(0.0, 17.6, 396.09)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	event.SetPakuAnim(2, "やられ口パク")
	helper_6c719c99(8120010)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-21.92, 23.66, 134.75)
	event.CmrsSetRef(-4.36, 20.87, 105.83)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(8120020)
	if vm.skipping() then
		return skip(3)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(8120030)
	if vm.skipping() then
		return skip(5)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-27.34, 30.34, 365.86)
	event.CmrsSetRef(-0.39, 25.21, 399.29)
	event.ObjsSetMotion(2, "きっと・・・", 4)
	event.SetPakuAnim(2, "やられ口パク")
	helper_6c719c99(8120040)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.CmrsMove2(-125.62, 18.68, 243.92, -0.39, 25.21, 399.29, 60, 0, 0.2)
	event.ObjsSetMotion(2, "ポーズ", 6)
	event.ObjsNextMotion(2, "ポーズＬ", 4)
	event.SetPakuAnim(2, "やられ口パク")
	helper_6c719c99(8120045)
	if vm.skipping() then
		return skip(8)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(9)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(10)
	end
	event.SndSeStop(var1, 0)
	event.SndSePlay(var1, 1)
	event.CharaActive(1, 11)
	event.SetMotion(11, "MP爆発", 6)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(11)
	end
	event.SetCharaShow(10, 0, 1, 0.1)
	event.SetCharaShow(12, 0, 1, 0.1)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-91.42, 22.7, -33.42)
	event.CmrsSetRef(-1.04, 13.67, 105.35)
	event.SetCharaPos(11, -105.44, 0.0, 185.46)
	event.SetCharaRot(11, 0.0, -2.78, 0.0)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(8120050)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(8120060)
	if vm.skipping() then
		return skip(14)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

return helper_ecb14965
