--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_743dd247()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 22 then
			if at <= 1 then
				helper_07cf3e45(6400220, -1)
			end
			if at <= 2 then
				helper_c1c32f84(60)
			end
			if at <= 3 then
				helper_2386f745(0)
			end
			if at <= 4 then
				helper_07cf3e45(6400230, -1)
			end
			if at <= 5 then
				helper_c1c32f84(4)
			end
			if at <= 6 then
				helper_c1c32f84(30)
			end
			if at <= 7 then
				helper_07cf3e45(6400240, -1)
			end
			if at <= 8 then
				helper_2386f745(0)
			end
			if at <= 9 then
				helper_c1c32f84(30)
			end
			if at <= 10 then
				helper_c1c32f84(30)
			end
			if at <= 11 then
				helper_07cf3e45(6400250, -1)
			end
			if at <= 12 then
				helper_2386f745(1)
			end
			if at <= 13 then
				helper_2386f745(0)
			end
			if at <= 14 then
				helper_07cf3e45(6400253, -1)
			end
			if at <= 15 then
				helper_c1c32f84(15)
			end
			if at <= 16 then
				helper_07cf3e45(6400257, -1)
			end
			if at <= 17 then
				helper_2386f745(1)
			end
			if at <= 18 then
				helper_c1c32f84(30)
			end
			if at <= 19 then
				helper_07cf3e45(6400260, -1)
			end
			if at <= 20 then
				helper_c1c32f84(60)
			end
			if at <= 21 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(23)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.EohSetShow(2, 0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(6215)
	var0 = event.SndLoadSound(6215) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
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
	event.EohSyncObj(2, "p01_gekka")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e520_dsmoke.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(3, 34)
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
	event.EohSetPos(0, 26.1, -13.06, 439.65)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 46.14, -13.05, 435.43)
	event.EohSetRot(1, 0.0, -2.9, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -1611.8, 5821.6, -10655.5)
	event.EohSetRot(2, 0.5235988, 0.0, 0.0)
	event.EohSetShow(2, 1)
	event.ObjsSetScale(2, 0.5, 0.5, 0.5)
	event.EohSetPos(3, -1611.8, 5821.6, -10655.5)
	event.EohSetRot(3, 0.0, -0.8, 0.0)
	event.ObjsSetScale(3, 0.3, 0.3, 0.3)
	event.EohSetShow(3, 1)
	event.SetTime(0)
	event.InitDramaScene()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CmrsInit()
	event.CmrsSetPos(48.43, -8.6, 485.28)
	event.CmrsSetRef(27.26, 28.52, 399.92)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.SetFadeIn(30)
	event.ObjsMove(2, -8095.4, 4770.2, -11356.4, 3000)
	event.ObjsRotation(2, 0.5235988, 0.0, 0.17453292, 1200)
	event.ObjsMove(3, -8095.4, 4770.2, -11356.4, 3000)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(0, "やった！！", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_07cf3e45(6400220, -1)
	if vm.skipping() then
		return skip(2)
	end
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(3)
	end
	event.FadeOutBgm(30)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(6400230, -1)
	if vm.skipping() then
		return skip(5)
	end
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(6)
	end
	event.LoadBgm(117)
	event.PlayBgm(0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目～こまり目")
	event.ObjsSetMotion(0, "上→右", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(6400240, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(9)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しL", 4)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(6400250, -1)
	if vm.skipping() then
		return skip(12)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "右→上", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(6400253, -1)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(1, "もどり", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(6400257, -1)
	if vm.skipping() then
		return skip(17)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(18)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_07cf3e45(6400260, -1)
	if vm.skipping() then
		return skip(20)
	end
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(21)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(22)
	end
	return part2()
end

return helper_743dd247
