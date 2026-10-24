--!strict
-- map/s/s98/s98_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10d80545 = require("@lib/event/helper_10d80545")
local helper_93d5f4e9 = require("@lib/event/helper_93d5f4e9")
local helper_a1c34b66 = require("@lib/event/helper_a1c34b66")
local helper_a348cd1a = require("@lib/event/helper_a348cd1a")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_2688c()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/e700/e736/e736.txt")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 33
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e736/e736_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/e700/e736/e736_monica.gltf", "info", global1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 33
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e736/e736_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e700/e736/e736_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e700/e736/e736_eina.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(4, 38)
	event.ObjsInit(4, 38)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "event/e700/e736/p00_05a.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(5, 39)
	event.ObjsInit(5, 39)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "event/e700/e736/p00_31a.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(6, 40)
	event.ObjsInit(6, 40)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e700/e736/e736_tom.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(7, 41)
	event.ObjsInit(7, 41)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "event/e700/e736/e736_vorneo.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.EohSyncChara(8, 42)
	event.ObjsInit(8, 42)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "event/e700/e736/e736_starbre.gltf", "info", 43)
	event.CharaActive(0, 43)
	event.EohSyncChara(9, 43)
	event.ObjsInit(9, 43)
	event.ObjsSyncObj(9, 9)
	event.LoadChara(5, "event/e700/e736/e736_c_union.gltf", "info", 44)
	event.CharaActive(0, 44)
	event.LoadChara(5, "event/e700/e736/e736_kieru_hikari.gltf", "info", 45)
	event.CharaActive(0, 45)
	event.CopyChara(5, 45, 46)
	event.CharaActive(0, 46)
	event.CopyChara(5, 45, 47)
	event.CharaActive(0, 47)
	event.CopyChara(5, 45, 48)
	event.CharaActive(0, 48)
	event.LoadChara(5, "event/e700/e736/e736_noboru_hikari.gltf", "info", 49)
	event.CharaActive(0, 49)
	event.EohSyncChara(10, 49)
	event.ObjsInit(10, 49)
	event.ObjsSyncObj(10, 10)
	event.CopyChara(5, 49, 50)
	event.CharaActive(0, 50)
	event.EohSyncChara(11, 50)
	event.ObjsInit(11, 50)
	event.ObjsSyncObj(11, 11)
	event.CopyChara(5, 49, 51)
	event.CharaActive(0, 51)
	event.EohSyncChara(12, 51)
	event.ObjsInit(12, 51)
	event.ObjsSyncObj(12, 12)
	event.CopyChara(5, 49, 52)
	event.CharaActive(0, 52)
	event.EohSyncChara(13, 52)
	event.ObjsInit(13, 52)
	event.ObjsSyncObj(13, 13)
	event.EohSyncObj(14, "p01_s98")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSetShow(14, 1)
	event.ObjsSetPos(14, -2000.0, 9000.0, -9000.0)
	event.ObjsSetRot(14, 0.0, 0.0, 0.0)
end

--- Helper function.
local function helper_26368()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.DeleteChara(45)
	event.DeleteChara(46)
	event.DeleteChara(47)
	event.DeleteChara(48)
	event.DeleteChara(49)
	event.DeleteChara(50)
	event.DeleteChara(51)
	event.DeleteChara(52)
	event.EohSetShow(14, 0)
end

--- Helper function.
local function helper_28414()
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 77 then
			if at <= 1 then
				helper_efffcfbb(15)
			end
			if at <= 2 then
				helper_10d80545()
			end
			if at <= 3 then
				helper_efffcfbb(30)
			end
			if at <= 4 then
				helper_a348cd1a(7360010, -1)
			end
			if at <= 5 then
				helper_a348cd1a(7360015, -1)
			end
			if at <= 6 then
				helper_a348cd1a(7360020, -1)
			end
			if at <= 7 then
				helper_efffcfbb(30)
			end
			if at <= 8 then
				helper_93d5f4e9(7360030)
			end
			if at <= 9 then
				helper_93d5f4e9(7360035)
			end
			if at <= 10 then
				helper_93d5f4e9(7360040)
			end
			if at <= 11 then
				helper_efffcfbb(60)
			end
			if at <= 12 then
				helper_93d5f4e9(7360050)
			end
			if at <= 13 then
				helper_93d5f4e9(7360060)
			end
			if at <= 14 then
				helper_10d80545()
			end
			if at <= 15 then
				helper_efffcfbb(60)
			end
			if at <= 16 then
				helper_efffcfbb(60)
			end
			if at <= 17 then
				helper_93d5f4e9(7360070)
			end
			if at <= 18 then
				helper_93d5f4e9(7360080)
			end
			if at <= 19 then
				helper_93d5f4e9(7360090)
			end
			if at <= 20 then
				helper_93d5f4e9(7360100)
			end
			if at <= 21 then
				helper_a1c34b66(0)
			end
			if at <= 22 then
				helper_93d5f4e9(7360110)
			end
			if at <= 23 then
				helper_a1c34b66(0)
			end
			if at <= 24 then
				helper_93d5f4e9(7360120)
			end
			if at <= 25 then
				helper_93d5f4e9(7360130)
			end
			if at <= 26 then
				helper_93d5f4e9(7360140)
			end
			if at <= 27 then
				helper_a1c34b66(0)
			end
			if at <= 28 then
				helper_93d5f4e9(7360145)
			end
			if at <= 29 then
				helper_a1c34b66(0)
			end
			if at <= 30 then
				helper_93d5f4e9(7360150)
			end
			if at <= 31 then
				helper_a1c34b66(0)
			end
			if at <= 32 then
				helper_93d5f4e9(7360155)
			end
			if at <= 33 then
				helper_efffcfbb(30)
			end
			if at <= 34 then
				helper_a1c34b66(0)
			end
			if at <= 35 then
				helper_efffcfbb(30)
			end
			if at <= 36 then
				helper_93d5f4e9(7360160)
			end
			if at <= 37 then
				helper_a1c34b66(0)
			end
			if at <= 38 then
				helper_93d5f4e9(7360170)
			end
			if at <= 39 then
				helper_93d5f4e9(7360180)
			end
			if at <= 40 then
				helper_a1c34b66(0)
			end
			if at <= 41 then
				helper_a1c34b66(4)
			end
			if at <= 42 then
				helper_93d5f4e9(7360190)
			end
			if at <= 43 then
				helper_a1c34b66(0)
			end
			if at <= 44 then
				helper_efffcfbb(10)
			end
			if at <= 45 then
				helper_efffcfbb(10)
			end
			if at <= 46 then
				helper_efffcfbb(10)
			end
			if at <= 47 then
				helper_efffcfbb(120)
			end
			if at <= 48 then
				helper_efffcfbb(150)
			end
			if at <= 49 then
				helper_efffcfbb(10)
			end
			if at <= 50 then
				helper_efffcfbb(10)
			end
			if at <= 51 then
				helper_efffcfbb(10)
			end
			if at <= 52 then
				helper_efffcfbb(200)
			end
			if at <= 53 then
				helper_efffcfbb(10)
			end
			if at <= 54 then
				helper_efffcfbb(10)
			end
			if at <= 55 then
				helper_efffcfbb(10)
			end
			if at <= 56 then
				helper_a1c34b66(10)
			end
			if at <= 57 then
				helper_a1c34b66(11)
			end
			if at <= 58 then
				helper_a1c34b66(12)
			end
			if at <= 59 then
				helper_a1c34b66(13)
			end
			if at <= 60 then
				helper_a348cd1a(7360200, -1)
			end
			if at <= 61 then
				helper_10d80545()
			end
			if at <= 62 then
				helper_a348cd1a(7360210, -1)
			end
			if at <= 63 then
				helper_a348cd1a(7360215, -1)
			end
			if at <= 64 then
				helper_10d80545()
			end
			if at <= 65 then
				helper_efffcfbb(30)
			end
			if at <= 66 then
				helper_a348cd1a(7360220, -1)
			end
			if at <= 67 then
				helper_a348cd1a(7360230, -1)
			end
			if at <= 68 then
				helper_a348cd1a(7360240, -1)
			end
			if at <= 69 then
				helper_10d80545()
			end
			if at <= 70 then
				helper_efffcfbb(30)
			end
			if at <= 71 then
				helper_a348cd1a(7360250, -1)
			end
			if at <= 72 then
				helper_a348cd1a(7360255, -1)
			end
			if at <= 73 then
				helper_a348cd1a(7360260, -1)
			end
			if at <= 74 then
				helper_10d80545()
			end
			if at <= 75 then
				helper_efffcfbb(60)
			end
			if at <= 76 then
				helper_efffcfbb(35)
			end
			if vm.skip_end() then
				return skip(78)
			end
			return part2()
		end
		helper_26368()
	end
	function part2()
		event.CancelDramaScene()
		helper_26368()
		event.SetTime(time)
		event.ResetCamera(0)
	end
	event.SetFlag(736, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	helper_2688c()
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(21.5)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "泣き顔")
	event.ObjsTexAnime(0, 1, "泣き目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "かなし目パチ")
	event.CmrsSetPos(6.53, 80.05, 766.11)
	event.CmrsSetRef(4.76, 541.47, 211.05)
	helper_efffcfbb(90)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(240)
	event.CmrsAddPas(6.53, 80.05, 766.11, 4.76, 541.47, 211.05)
	event.CmrsAddPas(6.53, 80.05, 766.11, 4.76, 64.48, 211.05)
	event.CmrsStartPas()
	event.ObjsSetPos(0, 6.03, -7.06, 200.37)
	event.ObjsSetRot(0, 0.0, 2.33, 0.0)
	event.ObjsSetPos(1, 24.67, -7.06, 178.01)
	event.ObjsSetRot(1, 0.0, -0.67, 0.0)
	event.ObjsSetPos(4, -39.08, -7.06, 139.45)
	event.ObjsSetRot(4, 0.0, 0.65, 0.0)
	event.ObjsSetPos(5, -63.71, -7.06, 154.12)
	event.ObjsSetRot(5, 0.0, 1.01, 0.0)
	event.ObjsSetPos(6, -79.03, -7.06, 188.9)
	event.ObjsSetRot(6, 0.0, 1.01, 0.0)
	event.SetCharaPos(44, 0.0, 5000.0, 0.0)
	event.SetScale(44, 30.0, 30.0, 30.0)
	event.SetMotion(44, "ループ", 4, -1, 1)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.CharaActive(1, 40)
	event.CharaActive(1, 44)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "モニカ見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(2)
	end
	helper_10d80545()
	if vm.skipping() then
		return skip(3)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetShow(14, 0)
	event.CmrsSetPos(22.59, 30.78, 266.06)
	event.CmrsSetRef(13.28, 16.71, 190.69)
	event.SetPakuAnim(1, "通常口パク")
	helper_a348cd1a(7360010, -1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsSetMotion(1, "うつむき", 6)
	event.ObjsNextMotion(1, "うつむきL", 4)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_a348cd1a(7360015, -1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "目とじ～目あき")
	event.ObjsSetMotion(1, "もどり", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_a348cd1a(7360020, -1)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "うる目")
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(56.0, 15.49, 205.01)
	event.CmrsSetRef(14.11, 16.71, 188.58)
	event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(7360030)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "泣き顔")
	event.ObjsTexAnime(1, 1, "泣き目パチ")
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(7360035)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "泣き顔")
	event.ObjsTexAnime(1, 1, "泣き目あき～目とじ")
	event.ObjsSetMotion(1, "うなづき", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "口わらい")
	helper_93d5f4e9(7360040)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "泣き顔")
	event.ObjsTexAnime(0, 1, "泣き目～通常目")
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(40.36, 16.65, 283.36, 10.43, 16.71, 186.62)
	event.CmrsAddPas(2.3, 16.65, 295.13, -27.63, 16.71, 198.39)
	event.CmrsStartPas()
	event.ObjsSetMotion(0, "左", 6)
	event.ObjsNextMotion(0, "左L", 4)
	helper_93d5f4e9(7360050)
	if vm.skipping() then
		return skip(13)
	end
	helper_93d5f4e9(7360060)
	if vm.skipping() then
		return skip(14)
	end
	helper_10d80545()
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "泣き顔")
	event.ObjsTexAnime(0, 1, "通常目～かなし目")
	event.ObjsSetMotion(4, "歩き")
	event.ObjsMove(4, -8.93, -7.06, 177.8, 120)
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetPos(1, -118.41, -7.06, 31.17)
	event.ObjsSetRot(1, 0.0, 0.53, 0.0)
	event.ObjsSetPos(0, -8.93, -7.06, 177.8)
	event.ObjsSetRot(0, 0.0, 0.65, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "かなし目パチ")
	event.CmrsSetPos(-45.34, 17.5, 214.87)
	event.CmrsSetRef(37.61, 23.19, 150.26)
	event.ObjsSetMotion(0, "エイナ見立ち", 4, -1, 1)
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(4, "立ち")
	event.SetPakuAnim(4, "通常口パク")
	helper_93d5f4e9(7360070)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7360080)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "通常口パク")
	helper_93d5f4e9(7360090)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目あき～目とじ")
	event.ObjsSetMotion(0, "下見る", 6)
	event.ObjsNextMotion(0, "下見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7360100)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき")
	event.ObjsSetMotion(0, "下見る戻り", 6)
	event.ObjsNextMotion(0, "エイナ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7360110)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(24)
	end
	event.SetPakuAnim(4, "通常口パク")
	helper_93d5f4e9(7360120)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "うる目")
	event.ObjsTexAnime(0, 1, "半口")
	event.SetPakuAnim(4, "通常口パク")
	helper_93d5f4e9(7360130)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "うる目～目とじ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetMotion(0, "涙をふく", 6)
	event.ObjsNextMotion(0, "エイナ見立ち", 4)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき２")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7360140)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(0, "手を広げる", 6)
	event.ObjsNextMotion(0, "手を広げるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7360145)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "前向き～下向き")
	event.ObjsSetMotion(0, "手を広げる戻り", 6)
	event.ObjsNextMotion(0, "エイナ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7360150)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "下向き～目とじ")
	event.ObjsSetMotion(0, "下見る", 6)
	event.ObjsNextMotion(0, "下見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7360155)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(34)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(0, "下見る戻り", 6)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき～目とじ")
	event.ObjsTexAnime(0, 1, "口とじ～半口～口とじ")
	event.ObjsSetMotion(0, "抱く", 6)
	event.ObjsNextMotion(0, "抱くL", 4)
	event.ObjsSetMotion(4, "抱く", 6)
	event.ObjsNextMotion(4, "抱くL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_93d5f4e9(7360160)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(38)
	end
	event.SetPakuAnim(4, "通常口パク")
	helper_93d5f4e9(7360170)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "目とじ～目あき３")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetMotion(0, "抱く戻り", 6)
	event.ObjsNextMotion(0, "抱く戻りL", 4)
	event.ObjsSetMotion(4, "抱く戻り", 6)
	event.ObjsNextMotion(4, "抱く戻りL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_93d5f4e9(7360180)
	if vm.skipping() then
		return skip(40)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "うる目２")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetMotion(4, "後ずさり", 2)
	event.ObjsNextMotion(4, "後ずさりL", 4)
	event.ObjsMove(4, -24.91, -7.06, 157.36, 60)
	helper_a1c34b66(4)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "泣き顔")
	event.ObjsTexAnime(1, 1, "泣き目パチ")
	event.ObjsTexAnime(1, 1, "口わらい")
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(34.99, 37.57, 229.69, -39.55, 3.5, 143.97)
	event.CmrsAddPas(-14.43, 37.57, 171.71, -89.76, 3.5, 90.67)
	event.CmrsStartPas()
	event.ObjsSetRot(0, 0.0, -2.35, 0.0)
	event.ObjsSetPos(4, -68.67, -7.06, 112.54)
	event.ObjsSetRot(4, 0.0, 0.77, 0.0)
	event.ObjsSetPos(5, -139.47, -7.06, 60.43)
	event.ObjsSetRot(5, 0.0, 0.65, 0.0)
	event.ObjsSetPos(6, -144.0, -7.06, 85.39)
	event.ObjsSetRot(6, 0.0, 0.89, 0.0)
	event.SetCharaPos(45, -118.41, -7.06, 31.17)
	event.SetCharaPos(46, -68.67, -7.06, 112.54)
	event.SetCharaPos(47, -139.47, -7.06, 60.43)
	event.SetCharaPos(48, -144.0, -7.06, 85.39)
	event.ObjsSetMotion(0, "母さん！！", 6)
	event.ObjsNextMotion(0, "母さん！！L", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(7360190)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(44)
	end
	event.SetMotion(47, "発動", 6, -1, 1)
	event.CharaActive(1, 47)
	event.SetCharaShow(39, 0, 1, 0.025)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(45)
	end
	event.SetMotion(48, "発動", 6, -1, 1)
	event.CharaActive(1, 48)
	event.SetCharaShow(40, 0, 1, 0.025)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(46)
	end
	event.SetMotion(45, "発動", 6, -1, 1)
	event.CharaActive(1, 45)
	event.SetCharaShow(global1, 0, 1, 0.025)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(47)
	end
	event.SetMotion(46, "発動", 6, -1, 1)
	event.CharaActive(1, 46)
	event.SetCharaShow(38, 0, 1, 0.025)
	helper_efffcfbb(120)
	if vm.skipping() then
		return skip(48)
	end
	event.CharaActive(0, global1)
	event.CharaActive(0, 38)
	event.CharaActive(0, 39)
	event.CharaActive(0, 40)
	event.CharaActive(0, 45)
	event.CharaActive(0, 46)
	event.CharaActive(0, 47)
	event.CharaActive(0, 48)
	event.SetCharaPos(44, 0.0, 5000.0, 0.0)
	event.SetScale(44, 30.0, 30.0, 30.0)
	event.SetMotion(44, "閉じる", 6, -1, 1)
	event.CharaActive(1, 49)
	event.CharaActive(1, 50)
	event.CharaActive(1, 51)
	event.CharaActive(1, 52)
	event.SetScale(49, 4.0, 4.0, 4.0)
	event.SetScale(50, 4.0, 4.0, 4.0)
	event.SetScale(51, 4.0, 4.0, 4.0)
	event.SetScale(52, 4.0, 4.0, 4.0)
	event.SetCharaPos(49, -150.0, -7.06, 150.0)
	event.SetCharaPos(50, -150.0, -7.06, -150.0)
	event.SetCharaPos(51, 150.0, -7.06, -150.0)
	event.SetCharaPos(52, 150.0, -7.06, 150.0)
	event.CharaActive(0, global0)
	event.CharaActive(1, 41)
	event.CharaActive(1, 42)
	event.CharaActive(1, 43)
	event.ObjsSetPos(7, -66.45, -268.37, 2735.73)
	event.ObjsSetRot(7, 0.0, -3.12, 0.0)
	event.ObjsSetPos(8, -36.27, -268.37, 2730.68)
	event.ObjsSetRot(8, 0.0, 3.04, 0.0)
	event.ObjsSetPos(9, -11.81, -268.37, 2711.11)
	event.ObjsSetRot(9, 0.0, -3.0, 0.0)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetMotion(8, "立ち", 4)
	event.ObjsSetMotion(9, "立ち", 4)
	event.CmrsSetPos(-26.29, -233.08, 2912.11)
	event.CmrsSetRef(-24.95, 6.64, 2652.48)
	helper_efffcfbb(150)
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(480)
	event.CmrsAddPas(-26.29, -233.08, 2912.11, -24.95, 6.64, 2652.48)
	event.CmrsAddPas(-26.29, -233.08, 2912.11, -24.95, -215.15, 2652.48)
	event.CmrsStartPas()
	event.ObjsMove(10, 0.0, 3000.0, 0.0, 240)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsMove(11, 0.0, 3000.0, 0.0, 240)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsMove(12, 0.0, 3000.0, 0.0, 240)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsMove(13, 0.0, 3000.0, 0.0, 240)
	helper_efffcfbb(200)
	if vm.skipping() then
		return skip(53)
	end
	event.SetCharaShow(49, 0, 1, 0.025)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(54)
	end
	event.SetCharaShow(50, 0, 1, 0.025)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(55)
	end
	event.SetCharaShow(51, 0, 1, 0.025)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(56)
	end
	event.SetCharaShow(52, 0, 1, 0.025)
	helper_a1c34b66(10)
	if vm.skipping() then
		return skip(57)
	end
	helper_a1c34b66(11)
	if vm.skipping() then
		return skip(58)
	end
	helper_a1c34b66(12)
	if vm.skipping() then
		return skip(59)
	end
	helper_a1c34b66(13)
	if vm.skipping() then
		return skip(60)
	end
	event.CharaActive(0, 49)
	event.CharaActive(0, 50)
	event.CharaActive(0, 51)
	event.CharaActive(0, 52)
	event.SetPakuAnim(9, "通常口パク")
	helper_a348cd1a(7360200, -1)
	if vm.skipping() then
		return skip(61)
	end
	event.ResetPakuAnim()
	helper_10d80545()
	if vm.skipping() then
		return skip(62)
	end
	event.SetPakuAnim(8, "通常口パク")
	helper_a348cd1a(7360210, -1)
	if vm.skipping() then
		return skip(63)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(8, "通常口パク")
	helper_a348cd1a(7360215, -1)
	if vm.skipping() then
		return skip(64)
	end
	event.ResetPakuAnim()
	helper_10d80545()
	if vm.skipping() then
		return skip(65)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(66)
	end
	event.CharaActive(0, 44)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(300)
	event.CmrsAddPas(-54.18, -186.41, 2598.29, -52.05, -235.11, 2730.18)
	event.CmrsAddPas(-33.03, -186.41, 2617.0, -52.05, -235.11, 2730.18)
	event.CmrsAddPas(-22.8, -186.41, 2647.26, -52.05, -235.11, 2730.18)
	event.CmrsAddPas(-25.71, -186.41, 2687.16, -52.05, -235.11, 2730.18)
	event.CmrsStartPas()
	event.SetPakuAnim(7, "通常口パク")
	helper_a348cd1a(7360220, -1)
	if vm.skipping() then
		return skip(67)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(9, "通常口パク")
	helper_a348cd1a(7360230, -1)
	if vm.skipping() then
		return skip(68)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(7, "えっ？", 6)
	event.ObjsNextMotion(7, "えっ？Ｌ", 4)
	event.SetPakuAnim(7, "通常口パク")
	helper_a348cd1a(7360240, -1)
	if vm.skipping() then
		return skip(69)
	end
	event.ResetPakuAnim()
	helper_10d80545()
	if vm.skipping() then
		return skip(70)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(71)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(280)
	event.CmrsAddPas(-28.5, -232.67, 2897.33, -26.73, -219.56, 2660.25)
	event.CmrsAddPas(-28.5, -232.67, 2897.33, -26.73, 111.73, 2660.25)
	event.CmrsStartPas()
	event.SetPakuAnim(9, "通常口パク")
	helper_a348cd1a(7360250, -1)
	if vm.skipping() then
		return skip(72)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(9, "通常口パク")
	helper_a348cd1a(7360255, -1)
	if vm.skipping() then
		return skip(73)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(7, "通常口パク")
	helper_a348cd1a(7360260, -1)
	if vm.skipping() then
		return skip(74)
	end
	event.ResetPakuAnim()
	helper_10d80545()
	if vm.skipping() then
		return skip(75)
	end
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(76)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(35)
	if vm.skipping() then
		return skip(77)
	end
	return part2()
end

--- Helper function.
local function helper_2e200()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_a1c34b66(0)
			end
			if at <= 2 then
				helper_efffcfbb(30)
			end
			if at <= 3 then
				helper_93d5f4e9(6400010)
			end
			if at <= 4 then
				helper_93d5f4e9(6400020)
			end
			if at <= 5 then
				helper_efffcfbb(60)
			end
			if at <= 6 then
				helper_efffcfbb(60)
			end
			if at <= 7 then
				helper_a1c34b66(3)
			end
			if at <= 8 then
				helper_efffcfbb(90)
			end
			if at <= 9 then
				helper_93d5f4e9(6400030)
			end
			if at <= 10 then
				helper_93d5f4e9(6400040)
			end
			if at <= 11 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
		if at <= 13 then
			helper_efffcfbb(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_efffcfbb(4)
		if vm.skipping() then
			return skip(14)
		end
		event.LoadBgm(22)
		event.PlayBgm(0)
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
	helper_efffcfbb(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(111)
	event.PlayBgm(0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640.txt")
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
	event.LoadChara(5, "e640_hajike.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_hajike1.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_s98")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
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
	event.EohSetPos(0, 10.0, -7.1, 300.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -10.0, -7.1, 300.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -2.85, 23.99, 5.49)
	event.EohSetPos(3, 32.74, 3570.25, -47.05)
	event.EohSetPos(4, 32.74, 3270.25, -47.05)
	event.EohSetShow(4, 0)
	event.InitDramaScene()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.CmrsInit()
	event.CmrsSetPos(464.69, 792.55, 769.26)
	event.CmrsSetRef(-8.98, 22.94, 15.83)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 13.62, -7.06, 180.22, 120, 1)
	event.ObjsMotionDelay(0, 120)
	event.ObjsNextMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -17.18, -7.06, 176.73, 120, 1)
	event.ObjsMotionDelay(1, 120)
	event.ObjsNextMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.CmrsSetPos(-6.27, -6.79, 122.45)
	event.CmrsSetRef(-6.44, 20.36, 185.12)
	event.ObjsSetPos(0, 3.4, -7.06, 176.16)
	event.ObjsResetDaPosition(0)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsQuake(0.0, 0.2, 0.0, -1)
	event.ObjsSetMotion(0, "キョロキョロ")
	event.ObjsSetMotion(1, "きょろきょろ")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(6400010)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(6400020)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsInit()
	event.CmrsSetPos(731.98, 1651.1, -1178.87)
	event.CmrsSetRef(572.56, 1335.85, -926.68)
	event.CharaActive(34)
	event.ObjsSetMotion(2, "ラピスビームのみ", 6)
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 34)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(0, 1.12, -7.06, 174.14)
	event.ObjsSetRot(0, 0.0, -2.66, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.CmrsSetPos(121.14, 121.97, -135.88)
	event.CmrsSetRef(76.13, 1369.74, -73.12)
	event.CharaActive(35)
	event.ObjsSetMotion(3, "ラピスビームのみ", 6)
	event.ObjsMotionWait(3)
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(2449.15, 2287.63, -2318.7)
	event.CmrsSetRef(2089.73, 2465.83, -1980.84)
	helper_a1c34b66(3)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetShow(3, 0)
	event.EohSetShow(4, 1)
	event.ObjsSetScale(4, 0.5, 0.5, 0.5)
	helper_efffcfbb(90)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-19.79, 61.27, 135.82)
	event.CmrsSetRef(-6.87, 2.39, 183.45)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しL", 4)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(6400030)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "もどり", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsSetMotion(0, "やった！！", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(6400040)
	if vm.skipping() then
		return skip(11)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_30ae4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_93d5f4e9(6400140)
			end
			if at <= 2 then
				helper_93d5f4e9(6400150)
			end
			if at <= 3 then
				helper_a1c34b66(0)
			end
			if at <= 4 then
				helper_93d5f4e9(6400160)
			end
			if at <= 5 then
				helper_a1c34b66(1)
			end
			if at <= 6 then
				helper_93d5f4e9(6400170)
			end
			if at <= 7 then
				helper_93d5f4e9(6400180)
			end
			if at <= 8 then
				helper_93d5f4e9(6400190)
			end
			if at <= 9 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
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
	event.LoadMes(0, 5, "e640.txt")
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
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 35.37, -7.06, 202.4)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetShow(2, 0)
	event.InitDramaScene()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CmrsInit()
	event.CmrsSetPos(46.73, 6.1, 159.48)
	event.CmrsSetRef(23.33, 14.34, 206.91)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(6400140)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(6400150)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "上→右", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(6400160)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "上から左", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(6400170)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "右→上", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "左から上", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(6400180)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(6400190)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_3248c()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_93d5f4e9(6400220)
			end
			if at <= 2 then
				helper_a1c34b66(0)
			end
			if at <= 3 then
				helper_93d5f4e9(6400230)
			end
			if at <= 4 then
				helper_efffcfbb(4)
			end
			if at <= 5 then
				helper_93d5f4e9(6400240)
			end
			if at <= 6 then
				helper_a1c34b66(0)
			end
			if at <= 7 then
				helper_93d5f4e9(6400250)
			end
			if at <= 8 then
				helper_a1c34b66(1)
			end
			if at <= 9 then
				helper_a1c34b66(0)
			end
			if at <= 10 then
				helper_93d5f4e9(6400253)
			end
			if at <= 11 then
				helper_93d5f4e9(6400257)
			end
			if at <= 12 then
				helper_a1c34b66(1)
			end
			if at <= 13 then
				helper_93d5f4e9(6400260)
			end
			if at <= 14 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
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
	event.LoadMes(0, 5, "e640.txt")
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
	event.ObjsMove(2, -8095.4, 4770.2, -11356.4, 1200)
	event.ObjsRotation(2, 0.5235988, 0.0, 0.17453292, 300)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "やった！！", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(6400220)
	if vm.skipping() then
		return skip(2)
	end
	event.FadeOutBgm(30)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(6400230)
	if vm.skipping() then
		return skip(4)
	end
	event.StopBgm(0)
	helper_efffcfbb(4)
	if vm.skipping() then
		return skip(5)
	end
	event.LoadBgm(114)
	event.PlayBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目～こまり目")
	event.ObjsSetMotion(0, "上→右", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(6400240)
	if vm.skipping() then
		return skip(6)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(6400250)
	if vm.skipping() then
		return skip(8)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "右→上", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(6400253)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "もどり", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(6400257)
	if vm.skipping() then
		return skip(12)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(6400260)
	if vm.skipping() then
		return skip(14)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

--- Helper function.
local function helper_342b0()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_93d5f4e9(6400420)
			end
			if at <= 2 then
				helper_93d5f4e9(6400430)
			end
			if at <= 3 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
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
	event.LoadMes(0, 5, "e640.txt")
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
	event.InitDramaScene()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CmrsInit()
	event.CmrsSetPos(21.14, 60.19, 163.18)
	event.CmrsSetRef(24.82, 14.07, 201.88)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(6400420)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(6400430)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_28414()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
-- Defined empty, so the engine runs this instead of its default.
script[500] = function() end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_28414()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s46", 530)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2e200()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 610)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_30ae4()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 630)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 620.
script[620] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3248c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 640)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 630.
script[630] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_342b0()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s30", 650)
	if vm.wait() then
		return skip(2)
	end
end

return script
