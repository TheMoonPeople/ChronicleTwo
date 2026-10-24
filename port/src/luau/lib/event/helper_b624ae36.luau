--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_b624ae36()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_42c67f56(6400460)
			end
			if at <= 2 then
				helper_2386f745(1)
			end
			if at <= 3 then
				helper_42c67f56(6400470)
			end
			if at <= 4 then
				helper_2386f745(0)
			end
			if at <= 5 then
				helper_42c67f56(6400480)
			end
			if at <= 6 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.StopBgm(0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
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
	event.EohSyncObj(2, "p01_s98")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
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
	event.EohSetPos(0, 12.52, -7.06, 206.03)
	event.EohSetRot(0, 0.0, 2.9, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 35.37, -7.06, 202.4)
	event.EohSetRot(1, 0.0, -2.9, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetShow(2, 0)
	event.SetTime(0)
	event.InitDramaScene()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CmrsInit()
	event.CmrsSetPos(-6.36, 3.35, 161.53)
	event.CmrsSetRef(27.9, 14.07, 208.34)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目～おこり目")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "すごい", 6)
	event.ObjsNextMotion(0, "すごいL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(6400460)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "上から左", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	helper_2386f745(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(6400470)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "すごい戻り", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(6400480)
	if vm.skipping() then
		return skip(6)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

return helper_b624ae36
