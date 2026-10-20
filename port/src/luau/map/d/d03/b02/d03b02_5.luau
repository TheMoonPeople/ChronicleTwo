--!strict
-- map/d/d03/b02/d03b02_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09b5edc9 = require("@lib/event/helper_09b5edc9")
local helper_29dc3834 = require("@lib/event/helper_29dc3834")
local helper_500caf86 = require("@lib/event/helper_500caf86")
local helper_7a92069b = require("@lib/event/helper_7a92069b")
local helper_82700276 = require("@lib/event/helper_82700276")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_b35e85eb = require("@lib/event/helper_b35e85eb")
local helper_ec8c350b = require("@lib/event/helper_ec8c350b")
local helper_ed303a24 = require("@lib/event/helper_ed303a24")
local helper_f1cdfb4a = require("@lib/event/helper_f1cdfb4a")
local helper_fa57afea = require("@lib/event/helper_fa57afea")

local global0: f32 = 0
local global1: f32 = 0
local global2: f32 = 0
local global3: f32 = 0
local global4: f32 = 0
local global5: f32 = 0
local global6: f32 = 0
local global7: f32 = 0
local global8: s32 = 0
local global9: s32 = 0
local global10: s32 = 0
local global11: s32 = 0
local global12: s32 = 0
local global13: s32 = 0
local global14: s32 = 0
local global15: s32 = 0
local global16: s32 = 0
local global17: s32 = 0
local global18: s32 = 0
local global19: s32 = 0

--- Helper function.
local function helper_108fc()
	local flag: s32 = 0
	flag = event.GetFlag(348) or flag
	if flag == 1 then
		event.FuncPointShow("", "e348", 0)
	end
	do
		local out1, out2, out3 = event.ZeroVector()
		global0 = out1 or global0
		global1 = out2 or global1
		global2 = out3 or global2
	end
	global2 = 30.0
	do
		local out1, out2, out3 = event.ZeroVector()
		global4 = out1 or global4
		global5 = out2 or global5
		global6 = out3 or global6
	end
end

--- Helper function.
local function helper_3b538()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global18 = 0
		global19 = 32
		global18 = 32
		global19 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global18 = 0
		global19 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global18)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global18)
		event.EohSyncChara(0, global18)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global18)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global19)
		event.LoadEquip(5, 1, 1, "info", global19, 17)
		event.LoadEquip(5, 1, 0, "info", global19, 18)
		event.LoadEquip(5, 1, 4, "info", global19)
		event.LoadEquip(5, 1, 3, "info", global19)
		event.LoadEquip(5, 1, 2, "info", global19, 36)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global19)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global19)
		event.EohSyncChara(1, global19)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global19)
		event.CharaActive(0, 36)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global18 = 32
		global19 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global18)
		event.LoadEquip(5, 0, 1, "info", global18, 17)
		event.LoadEquip(5, 0, 0, "info", global18, 18)
		event.LoadEquip(5, 0, 4, "info", global18)
		event.LoadEquip(5, 0, 3, "info", global18)
		event.LoadEquip(5, 0, 2, "info", global18, 36)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global18)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global18)
		event.EohSyncChara(0, global18)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global18)
		event.CharaActive(0, 36)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global19)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global19)
		event.EohSyncChara(1, global19)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global19)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e356/e356_guiltoni.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(6, 39)
	event.ObjsInit(6, 39)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e300/e356/e356_jamming.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(7, 40)
	event.ObjsInit(7, 40)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "event/e300/e356/e356_dsmoke.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncObj(8, "p01_battleship")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(10, "p01_d03b01", "d03b01_12-m0")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSyncObj(11, "p02_d03b01", "d03b01_3-m0")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(12, "p02_d03b01", "d03b01_15-m0")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(18, "p01_battleship", "tbig-m0")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 18)
	event.LoadMes(0, 5, "event/e300/e356/e356.txt")
end

--- Helper function.
local function helper_3aea4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global18)
		event.CharaActive(0, global19)
		event.DelExtMotion(global18)
		event.DelExtMotion(global19)
		event.DeleteChara(global19)
		event.DeleteChara(36)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global19)
		event.CharaActive(0, global18)
		event.DelExtMotion(global18)
		event.DelExtMotion(global19)
		event.DeleteChara(global18)
		event.DeleteChara(36)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.FuncPointShow("", "func", 1)
	event.FuncPointShow("", "func4", 1)
	event.EohSetShow(12, 1)
	event.EohSetScale(8, 1.0, 1.0, 1.0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	event.MapJump(-1, "d03b01", 503)
end

--- Helper function.
local function helper_3cba4()
	local projection: f32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_3b538()
				helper_a0e17f3c(90)
			end
			if at <= 2 then
				helper_a0e17f3c(90)
			end
			if at <= 3 then
				helper_a0e17f3c(240)
			end
			if at <= 4 then
				helper_a0e17f3c(3000)
			end
			if at <= 5 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
		helper_3aea4()
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(projection)
		event.SetTime(time)
		if vm.wait() then
			return skip(8)
		end
		helper_3aea4()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	helper_a0e17f3c(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(152)
	helper_3b538()
	projection = event.GetProjection() or projection
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(21.0)
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "デフォルト顔")
	event.ObjsTexAnime(6, 1, "通常目パチ")
	event.ObjsTexAnime(7, 0)
	event.ObjsTexAnime(7, 1, "デフォルト顔")
	event.ObjsTexAnime(7, 1, "目パチ")
	event.FuncPointShow("", "func", 0)
	event.FuncPointShow("", "func4", 0)
	event.ObjsSetRot(11, 0.0, 1.57, 0.0)
	event.ObjsSetRot(12, 0.0, 1.57, 0.0)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.EohSetShow(12, 0)
	event.ObjsSetRot(13, -0.4, 1.9, 0.0)
	event.CharaActive(1, 36)
	event.CharaActive(0, global18)
	event.CharaActive(1, 39)
	event.CharaActive(0, 40)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetPos(8, -3191.25, 25.75, 1213.17)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.CharaActive(1, 41)
	event.SetCharaPos(41, -3714.57, 453.25, 1349.41)
	event.SetCharaRot(41, 0.0, 1.9, 0.0)
	event.ObjsSetPos(7, -2784.72, 25.75, 1175.72)
	event.ObjsSetRot(7, 0.0, 1.41, 0.0)
	event.SetFadeIn(30)
	event.SetProjection(1502.9)
	event.CharaActive(0, global19)
	event.SetProjection(projection)
	event.ObjsRotation(8, 0.0, 0.0, 0.06, 90)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.CharaActive(1, 40)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetRef(-2045.72, -1258.82, 1215.53)
	event.CmrsSetAhd(-1.19, -17.66, 32.97)
	event.ObjsSetPos(6, -2040.96, -1287.62, 1214.97)
	event.ObjsSetRot(6, 0.0, 2.0, 0.0)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsMoveAhd(-0.71, -17.66, 32.97, 300)
	helper_a0e17f3c(240)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(6, "ふりかえり", 6)
	helper_a0e17f3c(3000)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_11b54()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global8 = 0
		global9 = 8
		global8 = 8
		global9 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global8 = 0
		global9 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global8)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global8)
		event.EohSyncChara(0, global8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global8)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global9)
		event.LoadEquip(5, 1, 1, "info", global9, 17)
		event.LoadEquip(5, 1, 0, "info", global9, 18)
		event.LoadEquip(5, 1, 4, "info", global9)
		event.LoadEquip(5, 1, 3, "info", global9)
		event.LoadEquip(5, 1, 2, "info", global9, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global9)
		event.LoadMotion(5, "event/e300/e352/e352_monica.chr", "info", global9)
		event.EohSyncChara(1, global9)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global9)
		event.CharaActive(0, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global8 = 8
		global9 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global8)
		event.LoadEquip(5, 0, 1, "info", global8, 17)
		event.LoadEquip(5, 0, 0, "info", global8, 18)
		event.LoadEquip(5, 0, 4, "info", global8)
		event.LoadEquip(5, 0, 3, "info", global8)
		event.LoadEquip(5, 0, 2, "info", global8, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global8)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global8)
		event.EohSyncChara(0, global8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global8)
		event.CharaActive(0, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global9)
		event.LoadMotion(5, "event/e300/e352/e352_monica.chr", "info", global9)
		event.EohSyncChara(1, global9)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global9)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e352/e352_crest.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(5, 11)
	event.ObjsInit(5, 11)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "event/e300/e352/e352_lin2.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(4, 9)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "event/e300/e352/e352_guiltoni.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(6, 19)
	event.ObjsInit(6, 19)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e300/e352/e352_jamming.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(7, 20)
	event.ObjsInit(7, 20)
	event.ObjsSyncObj(7, 7)
	event.EohSyncObj(8, "p01_battleship")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(11, "p01_battleship", "t01-m0")
	event.LoadChara(5, "event/e300/e352/e352_houdai.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.EohSyncChara(10, 15)
	event.ObjsInit(10, 15)
	event.ObjsSyncObj(10, 10)
	event.LoadChara(5, "event/e300/e352/e352_gun_f.gltf", "info", 21)
	event.CharaActive(0, 21)
	event.LoadChara(5, "event/e300/e352/e352_gun_l.gltf", "info", 22)
	event.CharaActive(0, 22)
	event.EohSyncChara(12, 22)
	event.ObjsInit(11, 22)
	event.ObjsSyncObj(11, 12)
	event.LoadChara(5, "event/e300/e352/e352_gun_h.gltf", "info", 23)
	event.CharaActive(0, 23)
	event.CopyChara(5, 23, 16)
	event.CharaActive(0, 16)
	event.LoadChara(5, "event/e300/e356/e356_dwarp.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(14, 13)
	event.ObjsInit(14, 13)
	event.ObjsSyncObj(14, 14)
	event.LoadMes(0, 5, "event/e300/e352/e352_1.txt")
end

--- Helper function.
local function helper_11424()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global8)
		event.CharaActive(0, global9)
		event.DelExtMotion(global8)
		event.DelExtMotion(global9)
		event.DeleteChara(global9)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global9)
		event.CharaActive(0, global8)
		event.DelExtMotion(global8)
		event.DelExtMotion(global9)
		event.DeleteChara(global8)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.DeleteChara(11)
	event.DeleteChara(19)
	event.DeleteChara(20)
	event.DeleteChara(21)
	event.DeleteChara(22)
	event.DeleteChara(23)
	event.DeleteChara(16)
	event.DeleteChara(15)
	event.DeleteChara(13)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetScale(8, 1.0, 1.0, 1.0)
	event.EohSetShow(11, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
	event.LoadDungeonMapFile("d03b01")
	event.LoadScript("d03b01/d03b01.stb", 504)
end

--- Helper function.
local function helper_13678()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 56 then
			if at <= 4 then
				helper_11b54()
				helper_a0e17f3c(1)
			end
			if at <= 5 then
				helper_b35e85eb()
			end
			if at <= 6 then
				helper_b35e85eb()
			end
			if at <= 7 then
				helper_fa57afea(3520030)
			end
			if at <= 8 then
				helper_fa57afea(3520040)
			end
			if at <= 9 then
				helper_fa57afea(3520050)
			end
			if at <= 10 then
				helper_fa57afea(3520060)
			end
			if at <= 11 then
				helper_a0e17f3c(30)
			end
			if at <= 12 then
				helper_fa57afea(3520070)
			end
			if at <= 13 then
				helper_a0e17f3c(30)
			end
			if at <= 14 then
				helper_a0e17f3c(30)
			end
			if at <= 15 then
				helper_fa57afea(3520080)
			end
			if at <= 16 then
				helper_a0e17f3c(30)
			end
			if at <= 17 then
				helper_a0e17f3c(30)
			end
			if at <= 18 then
				helper_a0e17f3c(60)
			end
			if at <= 19 then
				helper_a0e17f3c(1)
			end
			if at <= 20 then
				helper_a19c5ee3(8)
			end
			if at <= 21 then
				helper_a0e17f3c(60)
			end
			if at <= 22 then
				helper_a0e17f3c(60)
			end
			if at <= 23 then
				helper_a0e17f3c(120)
			end
			if at <= 24 then
				helper_fa57afea(3520090)
			end
			if at <= 25 then
				helper_a0e17f3c(60)
			end
			if at <= 26 then
				helper_b35e85eb()
			end
			if at <= 27 then
				helper_a0e17f3c(120)
			end
			if at <= 28 then
				helper_fa57afea(3520100)
			end
			if at <= 29 then
				helper_fa57afea(3520110)
			end
			if at <= 30 then
				helper_fa57afea(3520120)
			end
			if at <= 31 then
				helper_fa57afea(3520130)
			end
			if at <= 32 then
				helper_fa57afea(3520140)
			end
			if at <= 33 then
				helper_fa57afea(3520150)
			end
			if at <= 34 then
				helper_a19c5ee3(6)
			end
			if at <= 35 then
				helper_fa57afea(3520160)
			end
			if at <= 36 then
				helper_a19c5ee3(7)
			end
			if at <= 37 then
				helper_a0e17f3c(10)
			end
			if at <= 38 then
				helper_a0e17f3c(120)
			end
			if at <= 39 then
				helper_a19c5ee3(10)
			end
			if at <= 40 then
				helper_a0e17f3c(30)
			end
			if at <= 41 then
				helper_a0e17f3c(5)
			end
			if at <= 42 then
				helper_a0e17f3c(60)
			end
			if at <= 43 then
				helper_a0e17f3c(5)
			end
			if at <= 44 then
				helper_a0e17f3c(60)
			end
			if at <= 45 then
				helper_a0e17f3c(5)
			end
			if at <= 46 then
				helper_a0e17f3c(60)
			end
			if at <= 47 then
				helper_a0e17f3c(60)
			end
			if at <= 48 then
				helper_a0e17f3c(60)
			end
			if at <= 49 then
				helper_a0e17f3c(60)
			end
			if at <= 50 then
				helper_a0e17f3c(30)
			end
			if at <= 51 then
				helper_a0e17f3c(15)
			end
			if at <= 52 then
				helper_a0e17f3c(120)
			end
			if at <= 53 then
				helper_a0e17f3c(60)
			end
			if at <= 54 then
				helper_a0e17f3c(120)
			end
			if at <= 55 then
				helper_b35e85eb()
			end
			if vm.skip_end() then
				return skip(57)
			end
			return part2()
		end
		if at <= 57 then
			helper_a0e17f3c(30)
		end
		if at <= 59 then
			helper_11424()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_a0e17f3c(30)
		if vm.skipping() then
			return skip(58)
		end
		event.SndSeAllStop(4)
		event.SetProjection(projection)
		event.SetMotionBlur(0)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SoundLoadCancel()
		event.BgmLoadCancel()
		if vm.wait() then
			return skip(59)
		end
		helper_11424()
		if vm.skipping() then
			return skip(60)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	event.LoadBgm(53)
	event.LoadSound(3833)
	var4 = event.SndLoadSound(3833) or var4
	event.PlayBgm(0)
	helper_11b54()
	projection = event.GetProjection() or projection
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(18.0)
	event.SetTimeStepEnable(0)
	event.SpriteInit(5)
	event.SpriteSetType(5, 0)
	event.SpriteSetUvsize(5, 0, 0, 512, 128)
	event.SpriteSetPutsize(5, 512, 128)
	event.SpriteSetPos(5, 320, 334)
	event.SpriteSetColor(5, 128, 128, 128, 128)
	event.SpriteSetScale(5, 1.0, 1.0)
	event.SpriteSetDraw(5, 0)
	event.EohSyncSprite(15, 5)
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.SpriteSetDraw(5, 1)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "無表情")
	event.ObjsTexAnime(4, 1, "左向き目パチ")
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "わらい顔")
	event.ObjsTexAnime(5, 1, "わらい目パチ")
	event.ObjsTexAnime(7, 0)
	event.ObjsTexAnime(7, 1, "目パチ")
	event.ObjsSetPos(8, -3191.25, 25.75, -1213.17)
	event.SetCharaPos(13, -3191.25, 25.75, 213.17)
	event.SetCharaRot(13, 0.0, 0.0, 0.0)
	event.ObjsSetPos(7, -2749.5, 25.75, 1190.29)
	event.ObjsSetRot(7, 0.0, 2.16, 0.0)
	event.ObjsSetPos(6, -2755.39, 25.75, 1165.67)
	event.ObjsSetRot(6, 0.0, 2.0, 0.0)
	event.EohSetFrameShow(4, "houki", 1)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetMotion(10, "立ち", 4)
	event.EohSetShow(8, 0)
	event.EohSetShow(9, 0)
	event.CmrsSetPos(-541.54, -501.71, -4164.15)
	event.CmrsSetRef(29.42, 66.85, -125.36)
	event.CharaActive(0, 12)
	event.CharaActive(0, global8)
	event.CharaActive(0, global9)
	event.CharaActive(1, 9)
	event.CharaActive(1, 11)
	event.CmrsMove(-375.99, -501.71, -2993.11, 194.93, 66.85, 1045.42, 90)
	event.ObjsSetMotion(4, "手すり立ち", 4)
	event.ObjsSetMotion(5, "手すり上見立ち", 4)
	event.ObjsSetPos(5, -277.63, 0.0, 112.11)
	event.ObjsSetRot(5, 0.0, -1.2, 0.0)
	event.ObjsSetPos(4, -284.8, 0.0, 93.56)
	event.ObjsSetRot(4, 0.0, -1.12, 0.0)
	helper_a0e17f3c(1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(30)
	event.ObjsSetColor(15, 128, 128, 128, 0, 0)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(559.2, 635.48, -195.62)
	event.CmrsSetRef(-204.68, 598.78, 74.08)
	event.SetCrossfade(30)
	event.CmrsMove2(559.2, 143.2, -195.62, -204.68, 106.5, 74.08, 200, 2, 1.0)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetShadow(5, 0)
	event.EohSetShadow(4, 0)
	event.CmrsSetPos(-367.55, 25.75, 136.21)
	event.CmrsSetRef(-204.68, 29.95, 74.08)
	event.SetCrossfade(30)
	event.SetPakuAnim(5, "わらい口パク")
	helper_fa57afea(3520030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(4, "左を見る", 6)
	event.ObjsNextMotion(4, "左を見るL", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "無表情")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.CmrsSetPos(-291.37, 30.93, 159.38)
	event.CmrsSetRef(-284.82, 29.95, 71.35)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3520040)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(5, "わらい口パク")
	helper_fa57afea(3520050)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "右を見る", 6)
	event.ObjsNextMotion(5, "右を見るL", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.SetPakuAnim(4, "わらい口パク")
	helper_fa57afea(3520060)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "大わらい顔")
	event.ObjsTexAnime(5, 1, "わらい目パチ")
	event.CmrsSetPos(-316.38, 25.02, 113.48)
	event.CmrsSetRef(-254.42, 29.95, 91.23)
	event.SetPakuAnim(5, "わらい口パク")
	helper_fa57afea(3520070)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(4, "左を見る戻り", 6)
	event.ObjsNextMotion(4, "手すり立ち", 4)
	event.CmrsMove2(-339.97, 25.02, 121.96, -254.42, 29.95, 91.23, 30, 2, 1.0)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "無表情")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3520080)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.FadeOutBgm(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(17)
	end
	event.StopBgm(0)
	event.ObjsSetMotion(5, "右を見る戻り", 6)
	event.ObjsNextMotion(5, "手すり立ち", 4)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "おこり顔")
	event.ObjsTexAnime(5, 1, "おこり目パチ")
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(19)
	end
	event.EohSetShadow(5, 1)
	event.EohSetShadow(4, 1)
	event.LoadBgm(32)
	event.PlayBgm(0)
	event.CmrsSetPos(-175.49, 25.02, 56.65)
	event.CmrsSetRef(-360.31, 29.95, 136.99)
	helper_a0e17f3c(1)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetScale(14, 2.0, 2.0, 2.0)
	event.CharaActive(1, 13)
	event.SetMotion(13, "消える", 2, -1, 1)
	event.SetMotionBlur(80)
	event.EohSetShow(8, 1)
	event.SetCrossfade(40)
	event.SndSePlay(var4, 4)
	event.ObjsMove(8, -3191.25, 25.75, 1000.17, 10)
	event.ObjsMove(14, -3191.25, 25.75, 2000.17, 10)
	helper_a19c5ee3(8)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsMove2(8, -3191.25, 25.75, 1213.17, 15, 2, 1.0)
	event.ObjsMove2(14, -3191.25, 25.75, 2213.17, 15, 2, 1.0)
	event.CharaActive(1, 19)
	event.CharaActive(1, 20)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(22)
	end
	event.SndSePlay(var4, 5)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(23)
	end
	event.SetMotionBlur(0)
	event.ObjsSetPos(8, -3191.25, 25.75, 1213.17)
	event.CmrsSetPos(2029.74, 25.02, 5512.95)
	event.CmrsSetRef(-250.33, 29.95, 2458.27)
	helper_a0e17f3c(120)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "無表情")
	event.ObjsTexAnime(5, 1, "通常目パチ")
	event.ObjsSetMotion(5, "身を乗りだす", 6)
	event.ObjsNextMotion(5, "身を乗りだすL", 4)
	event.CmrsSetPos(-279.45, 29.47, 165.03)
	event.CmrsSetRef(-304.59, 29.95, 74.61)
	event.SndSePlay(var4, 6)
	event.SetPakuAnim(5, "通常口パク")
	helper_fa57afea(3520090)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 7)
	event.ObjsSetMotion(4, "身を乗りだす", 6)
	event.ObjsNextMotion(4, "身を乗りだすL", 4)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(-322.93, 29.47, 119.9, -410.56, 29.95, 157.34)
	event.CmrsAddPas(-1822.73, 29.47, 760.68, -1910.36, 29.95, 798.12)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(-2644.48, 43.74, 1174.79)
	event.CmrsSetRef(-2727.12, 58.9, 1167.6)
	event.SetCrossfade(30)
	helper_a0e17f3c(120)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSePlay(var4, 8)
	event.CmrsSetPos(-2700.02, 51.13, 1176.52)
	event.CmrsSetRef(-2753.54, 58.9, 1178.03)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3520100)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(7, "うなづき", 6)
	event.ObjsNextMotion(7, "立ち", 4)
	event.SetPakuAnim(7, "通常口パク")
	helper_fa57afea(3520110)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3520120)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	event.ObjsSetPos(6, -2777.54, 25.75, 1176.5)
	event.ObjsSetRot(6, 0.0, 2.4, 0.0)
	event.SetProjection(584.9)
	event.CmrsSetPos(-2817.33, 55.98, 1202.06)
	event.CmrsSetRef(-2734.28, 58.9, 1166.34)
	event.SetCrossfade(30)
	event.SndSePlay(var4, 9)
	event.ObjsRotation(6, 0.0, -1.0, 0.0, 30)
	event.ObjsSetMotion(6, "振り返り（ＰＧ）左", 6)
	event.ObjsNextMotion(6, "振り返り（ＰＧ）左Ｌ", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3520130)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(7, "右見る", 6)
	event.ObjsNextMotion(7, "右見るＬ", 4)
	event.SetPakuAnim(7, "通常口パク")
	helper_fa57afea(3520140)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(6, "そのまま左向き", 6)
	event.ObjsNextMotion(6, "そのまま左向きＬ", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3520150)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(6)
	if vm.skipping() then
		return skip(35)
	end
	event.SndSePlay(var4, 10)
	event.ObjsSetMotion(7, "右からはっ", 6)
	event.ObjsNextMotion(7, "戻り", 6)
	event.ObjsNextMotion(7, "立ち", 4)
	event.SetPakuAnim(7, "通常口パク")
	helper_fa57afea(3520160)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(7)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsSetMotion(6, "戻り", 6)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(38)
	end
	event.SndSeStop(var4, 8)
	event.SetProjection(projection)
	event.ObjsSetRot(10, 0.0, 1.92, 0.0)
	event.CharaActive(1, 15)
	event.EohSetShow(11, 0)
	event.ObjsSetPos(10, -2458.92, 167.76, 852.48)
	event.CmrsSetPos(-1958.78, 43.74, 1048.53)
	event.CmrsSetRef(-2036.51, 58.9, 1019.15)
	event.SndSePlay(var4, 11)
	event.ObjsSetMotion(10, "横から縦移動", 6)
	event.ObjsNextMotion(10, "狙う", 6)
	event.ObjsNextMotion(10, "狙い立ち", 6)
	helper_a0e17f3c(120)
	if vm.skipping() then
		return skip(39)
	end
	event.SndSePlay(var4, 12)
	event.SetProjection(222.0)
	event.CmrsSetPos(-2502.08, 289.28, 872.69)
	event.CmrsSetRef(-2429.52, 237.57, 840.94)
	helper_a19c5ee3(10)
	if vm.skipping() then
		return skip(40)
	end
	event.SndSeStop(var4, 12)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(41)
	end
	event.SetProjection(projection)
	event.CmrsSetPos(-1862.68, 19.26, 1357.68)
	event.CmrsSetRef(-2351.83, 177.35, 866.18)
	event.SetCharaPos(21, -2279.73, 181.5, 788.22)
	event.SetCharaRot(21, 0.0, 1.9, 0.0)
	event.SetCharaPos(22, -2279.73, 181.5, 788.22)
	event.SetCharaRot(22, 0.0, 1.9, 0.0)
	event.CharaActive(1, 21)
	event.SndSePlay(var4, 13)
	event.SetMotion(21, "発射", 6, -1, 1)
	event.ObjsSetMotion(10, "発射", 6)
	event.ObjsNextMotion(10, "狙い立ち", 6)
	event.CmrsQuake(0.0, 1.3, 0.0, 60)
	helper_a0e17f3c(5)
	if vm.skipping() then
		return skip(42)
	end
	event.CharaActive(1, 22)
	event.ObjsMove(11, -1846.06, 191.5, 633.95, 10)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(43)
	end
	event.CharaActive(0, 22)
	event.SndSePlay(var4, 13)
	event.SetMotion(21, "発射", 6, -1, 1)
	event.ObjsSetMotion(10, "発射", 6)
	event.ObjsNextMotion(10, "狙い立ち", 6)
	event.CmrsQuake(0.0, 1.3, 0.0, 60)
	helper_a0e17f3c(5)
	if vm.skipping() then
		return skip(44)
	end
	event.CharaActive(1, 22)
	event.SetCharaPos(22, -2279.73, 181.5, 788.22)
	event.SetCharaRot(22, 0.0, 1.9, 0.0)
	event.ObjsMove(11, -1846.06, 191.5, 633.95, 10)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(45)
	end
	event.CharaActive(0, 22)
	event.SndSePlay(var4, 13)
	event.SetMotion(21, "発射", 2, -1, 1)
	event.ObjsSetMotion(10, "発射", 6)
	event.ObjsNextMotion(10, "狙い立ち", 6)
	event.CmrsQuake(0.0, 1.3, 0.0, 60)
	helper_a0e17f3c(5)
	if vm.skipping() then
		return skip(46)
	end
	event.CharaActive(1, 22)
	event.SetCharaPos(22, -2279.73, 181.5, 788.22)
	event.SetCharaRot(22, 0.0, 1.9, 0.0)
	event.ObjsMove(11, -1846.06, 191.5, 633.95, 10)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(47)
	end
	event.CharaActive(0, 21)
	event.CharaActive(0, 22)
	event.EohSetFrameShow(4, "houki", 0)
	event.ObjsSetMotion(5, "倒れ", 6)
	event.ObjsSetMotion(4, "倒れ", 6)
	event.ObjsSetPos(5, -190.72, 0.0, 61.97)
	event.ObjsSetRot(5, 0.0, 0.72, 0.0)
	event.ObjsSetPos(4, -193.0, 0.0, 66.79)
	event.ObjsSetRot(4, 0.0, 1.04, 0.0)
	event.CmrsSetPos(1488.6, 102.72, 416.88)
	event.CmrsSetRef(842.64, 111.52, 481.71)
	event.SetScale(23, 1.5, 1.5, 1.5)
	event.SetScale(16, 1.5, 1.5, 1.5)
	event.SetCharaPos(23, -171.72, -180.78, 261.44)
	event.SetCharaRot(23, 0.0, 0.0, 0.0)
	event.SetCharaPos(16, -228.91, 218.2, 212.99)
	event.SetCharaRot(16, 0.0, 0.0, 0.0)
	event.CharaActive(1, 23)
	event.SetMotion(23, "ヒット", 6, -1, 1)
	event.SndSePlay(var4, 14)
	event.CmrsQuake(0.0, 1.6, 0.0, 60)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(48)
	end
	event.CharaActive(0, 23)
	event.CmrsSetPos(228.78, 144.09, 1023.49)
	event.CmrsSetRef(-311.5, -61.26, 184.25)
	event.CmrsQuake(0.0, 1.6, 0.0, 120)
	event.CharaActive(1, 16)
	event.SetMotion(16, "ヒット", 6, -1, 1)
	event.SndSePlay(var4, 14)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(49)
	end
	event.CharaActive(1, 23)
	event.SetMotion(23, "ヒット", 6, -1, 1)
	event.SndSePlay(var4, 14)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(50)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(51)
	end
	helper_a0e17f3c(15)
	if vm.skipping() then
		return skip(52)
	end
	event.FuncPointShow("", "func2", 1)
	event.FuncPointShow("", "func3", 1)
	event.FuncPointShow("", "func0", 0)
	event.EohSetShow(9, 1)
	event.SndSePlay(var4, 15)
	event.CmrsQuake(0.0, 0.6, 0.0, 90)
	event.CmrsSetPos(26.69, 78.26, -14.0)
	event.CmrsSetRef(-133.35, 46.81, 45.49)
	event.SetFadeIn(30)
	helper_a0e17f3c(120)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsSetMotion(5, "身を起こす", 6)
	event.ObjsSetMotion(4, "身を起こす", 6)
	event.SndSePlay(var4, 16)
	event.CmrsSetPos(-140.11, 17.78, 75.17)
	event.CmrsSetRef(-196.15, 7.54, 67.76)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(54)
	end
	event.SndSePlay(var4, 17)
	event.ObjsSetMotion(5, "起きあがる", 6)
	event.ObjsNextMotion(5, "起きあがるL", 4)
	event.ObjsSetMotion(4, "起きあがる", 6)
	event.ObjsNextMotion(4, "起きあがるL", 4)
	event.ObjsSetPos(5, -203.17, 0.0, 74.79)
	event.ObjsSetRot(5, 0.0, -1.02, 0.0)
	event.ObjsSetPos(4, -181.97, 0.0, 71.68)
	event.ObjsSetRot(4, 0.0, -2.0, 0.0)
	event.CmrsSetPos(-26.74, 52.18, 5.97)
	event.CmrsSetRef(-138.01, 41.95, 46.59)
	helper_a0e17f3c(120)
	if vm.skipping() then
		return skip(55)
	end
	event.CharaActive(0, 23)
	event.CharaActive(0, 16)
	event.CmrsSetPos(-214.82, 16.87, 105.28)
	event.CmrsSetRef(-206.28, 22.54, 81.27)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-219.67, 16.87, 118.95, -206.28, 22.54, 81.27)
	event.CmrsAddPas(-214.82, 16.87, 105.28, -206.28, 22.54, 81.27)
	event.CmrsStartPas()
	event.FadeOutBgm(200)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(56)
	end
	event.StopBgm(0)
	event.SndSeStop(var4, 5)
	return part2()
end

--- Helper function.
local function helper_19870()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global10 = 0
		global11 = 8
		global10 = 8
		global11 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global10 = 0
		global11 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global10)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global10)
		event.EohSyncChara(0, global10)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global10)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global11)
		event.LoadEquip(5, 1, 1, "info", global11, 17)
		event.LoadEquip(5, 1, 0, "info", global11, 18)
		event.LoadEquip(5, 1, 4, "info", global11)
		event.LoadEquip(5, 1, 3, "info", global11)
		event.LoadEquip(5, 1, 2, "info", global11, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global11)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global11)
		event.EohSyncChara(1, global11)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global11)
		event.CharaActive(0, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global10 = 8
		global11 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global10)
		event.LoadEquip(5, 0, 1, "info", global10, 17)
		event.LoadEquip(5, 0, 0, "info", global10, 18)
		event.LoadEquip(5, 0, 4, "info", global10)
		event.LoadEquip(5, 0, 3, "info", global10)
		event.LoadEquip(5, 0, 2, "info", global10, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global10)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global10)
		event.EohSyncChara(0, global10)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global10)
		event.CharaActive(0, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global11)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global11)
		event.EohSyncChara(1, global11)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global11)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e352/e352_lin2.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(4, 9)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(8, "p01_battleship")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(10, "p01_d03b01", "d03b01_12-m0")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSyncObj(11, "p02_d03b01", "d03b01_3-m0")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(18, "p02_d03b01", "d03b01_15-m0")
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 18)
	event.LoadMes(0, 5, "event/e300/e352/e352_1.txt")
	event.AssignStack(6)
	event.ClearStack(6)
	event.LoadChara(6, "event/e300/e352/e352_crest.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(5, 11)
	event.ObjsInit(5, 11)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(6, "event/e300/e352/e352_guiltoni.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(6, 19)
	event.ObjsInit(6, 19)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(6, "event/e300/e352/e352_jamming.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(7, 20)
	event.ObjsInit(7, 20)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(6, "event/e300/e352/e352_warp.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.SetScale(16, 1.1, 1.1, 1.1)
	event.LoadChara(6, "event/e300/e352/e352_monica_hi.gltf", "info", 15)
	event.CharaActive(0, 15)
end

--- Helper function.
local function helper_190c8()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global10)
		event.CharaActive(0, global11)
		event.DelExtMotion(global10)
		event.DelExtMotion(global11)
		event.DeleteChara(global11)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global11)
		event.CharaActive(0, global10)
		event.DelExtMotion(global10)
		event.DelExtMotion(global11)
		event.DeleteChara(global10)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.DeleteChara(11)
	event.DeleteChara(19)
	event.DeleteChara(20)
	event.DeleteChara(21)
	event.DeleteChara(22)
	event.DeleteChara(23)
	event.DeleteChara(13)
	event.DeleteChara(14)
	event.DeleteChara(15)
	event.DeleteChara(16)
	event.FuncPointShow("", "func", 1)
	event.FuncPointShow("", "func4", 1)
	event.FuncPointShow("", "func2", 0)
	event.FuncPointShow("", "func3", 0)
	event.EohSetShow(18, 1)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.SetStatusbarShow(1, 1.0)
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Helper function.
local function helper_1b1c4()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 107 then
			if at <= 1 then
				helper_19870()
				helper_b35e85eb()
			end
			if at <= 2 then
				helper_a0e17f3c(30)
			end
			if at <= 3 then
				helper_a0e17f3c(60)
			end
			if at <= 4 then
				helper_09b5edc9(3520190, -1)
			end
			if at <= 5 then
				helper_a0e17f3c(30)
			end
			if at <= 6 then
				helper_09b5edc9(3520200, 60)
			end
			if at <= 7 then
				helper_a0e17f3c(60)
			end
			if at <= 8 then
				helper_a19c5ee3(1)
			end
			if at <= 9 then
				helper_a0e17f3c(60)
			end
			if at <= 10 then
				helper_a0e17f3c(45)
			end
			if at <= 11 then
				helper_a0e17f3c(45)
			end
			if at <= 12 then
				helper_a0e17f3c(45)
			end
			if at <= 13 then
				helper_fa57afea(3520203)
			end
			if at <= 14 then
				helper_a0e17f3c(30)
			end
			if at <= 15 then
				helper_a0e17f3c(30)
			end
			if at <= 16 then
				helper_09b5edc9(3520205, -1)
			end
			if at <= 17 then
				helper_a0e17f3c(15)
			end
			if at <= 18 then
				helper_a0e17f3c(30)
			end
			if at <= 23 then
				helper_fa57afea(3520210)
			end
			if at <= 24 then
				helper_fa57afea(3520220)
			end
			if at <= 25 then
				helper_a0e17f3c(30)
			end
			if at <= 26 then
				helper_fa57afea(3520230)
			end
			if at <= 27 then
				helper_a0e17f3c(90)
			end
			if at <= 28 then
				helper_a0e17f3c(60)
			end
			if at <= 29 then
				helper_fa57afea(3520240)
			end
			if at <= 30 then
				helper_a0e17f3c(60)
			end
			if at <= 31 then
				helper_fa57afea(3520250)
			end
			if at <= 32 then
				helper_b35e85eb()
			end
			if at <= 33 then
				helper_a0e17f3c(30)
			end
			if at <= 34 then
				helper_fa57afea(3520260)
			end
			if at <= 35 then
				helper_a0e17f3c(20)
			end
			if at <= 36 then
				helper_a0e17f3c(15)
			end
			if at <= 37 then
				helper_b35e85eb()
			end
			if at <= 38 then
				helper_a0e17f3c(25)
			end
			if at <= 39 then
				helper_a19c5ee3(5)
			end
			if at <= 40 then
				helper_a19c5ee3(5)
			end
			if at <= 41 then
				helper_a0e17f3c(30)
			end
			if at <= 42 then
				helper_a19c5ee3(5)
			end
			if at <= 43 then
				helper_a19c5ee3(5)
			end
			if at <= 44 then
				helper_a0e17f3c(50)
			end
			if at <= 45 then
				helper_b35e85eb()
			end
			if at <= 46 then
				helper_a0e17f3c(60)
			end
			if at <= 47 then
				helper_a0e17f3c(150)
			end
			if at <= 48 then
				helper_b35e85eb()
			end
			if at <= 49 then
				helper_a0e17f3c(90)
			end
			if at <= 50 then
				helper_a0e17f3c(90)
			end
			if at <= 51 then
				helper_a0e17f3c(90)
			end
			if at <= 52 then
				helper_a0e17f3c(60)
			end
			if at <= 53 then
				helper_b35e85eb()
			end
			if at <= 54 then
				helper_a0e17f3c(90)
			end
			if at <= 55 then
				helper_a19c5ee3(1)
			end
			if at <= 56 then
				helper_a0e17f3c(30)
			end
			if at <= 57 then
				helper_a0e17f3c(20)
			end
			if at <= 58 then
				helper_a0e17f3c(10)
			end
			if at <= 59 then
				helper_a0e17f3c(50)
			end
			if at <= 60 then
				helper_09b5edc9(3520280, -1)
			end
			if at <= 61 then
				helper_b35e85eb()
			end
			if at <= 62 then
				helper_a0e17f3c(90)
			end
			if at <= 63 then
				helper_b35e85eb()
			end
			if at <= 64 then
				helper_a0e17f3c(120)
			end
			if at <= 65 then
				helper_09b5edc9(3520290, -1)
			end
			if at <= 66 then
				helper_09b5edc9(3520295, -1)
			end
			if at <= 67 then
				helper_09b5edc9(3520300, -1)
			end
			if at <= 68 then
				helper_a0e17f3c(30)
			end
			if at <= 69 then
				helper_b35e85eb()
			end
			if at <= 70 then
				helper_a0e17f3c(30)
			end
			if at <= 71 then
				helper_09b5edc9(3520310, -1)
			end
			if at <= 72 then
				helper_09b5edc9(3520320, -1)
			end
			if at <= 73 then
				helper_09b5edc9(3520325, -1)
			end
			if at <= 74 then
				helper_b35e85eb()
			end
			if at <= 75 then
				helper_09b5edc9(3520330, -1)
			end
			if at <= 76 then
				helper_b35e85eb()
			end
			if at <= 77 then
				helper_a0e17f3c(30)
			end
			if at <= 78 then
				helper_fa57afea(3520340)
			end
			if at <= 79 then
				helper_a19c5ee3(6)
			end
			if at <= 80 then
				helper_09b5edc9(3520350, -1)
			end
			if at <= 81 then
				helper_a0e17f3c(30)
			end
			if at <= 82 then
				helper_09b5edc9(3520355, -1)
			end
			if at <= 83 then
				helper_b35e85eb()
			end
			if at <= 84 then
				helper_fa57afea(3520360)
			end
			if at <= 85 then
				helper_fa57afea(3520365)
			end
			if at <= 86 then
				helper_fa57afea(3520370)
			end
			if at <= 87 then
				helper_fa57afea(3520380)
			end
			if at <= 88 then
				helper_fa57afea(3520390)
			end
			if at <= 89 then
				helper_a0e17f3c(30)
			end
			if at <= 90 then
				helper_a0e17f3c(30)
			end
			if at <= 91 then
				helper_a0e17f3c(90)
			end
			if at <= 92 then
				helper_fa57afea(3520400)
			end
			if at <= 93 then
				helper_fa57afea(3520410)
			end
			if at <= 94 then
				helper_fa57afea(3520420)
			end
			if at <= 95 then
				helper_a0e17f3c(20)
			end
			if at <= 96 then
				helper_a19c5ee3(12)
			end
			if at <= 97 then
				helper_a0e17f3c(20)
			end
			if at <= 98 then
				helper_a19c5ee3(13)
			end
			if at <= 99 then
				helper_a0e17f3c(30)
			end
			if at <= 100 then
				helper_a0e17f3c(20)
			end
			if at <= 101 then
				helper_a19c5ee3(15)
			end
			if at <= 102 then
				helper_a0e17f3c(20)
			end
			if at <= 103 then
				helper_a19c5ee3(16)
			end
			if at <= 104 then
				helper_a0e17f3c(30)
			end
			if at <= 105 then
				helper_a0e17f3c(30)
			end
			if at <= 106 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(108)
			end
			return part2()
		end
		if at <= 109 then
			helper_190c8()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.ObjsSetPos(10, 0.0, 0.0, 0.0)
		event.SetProjection(projection)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SndSeAllStop(4)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		if vm.wait() then
			return skip(109)
		end
		helper_190c8()
		if vm.skipping() then
			return skip(110)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	helper_a0e17f3c(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(51)
	event.LoadSound(3839)
	var4 = event.SndLoadSound(3839) or var4
	event.PlayBgm(0)
	helper_19870()
	projection = event.GetProjection() or projection
	time = event.GetTime() or time
	event.SetTime(18.0)
	event.SetTimeStepEnable(0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "無表情")
	event.ObjsTexAnime(5, 1, "通常目パチ")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "無表情")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.ObjsTexAnime(4, 1, "半口")
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "デフォルト顔")
	event.ObjsTexAnime(6, 1, "通常目パチ")
	event.ObjsTexAnime(7, 0)
	event.ObjsTexAnime(7, 1, "デフォルト顔")
	event.ObjsTexAnime(7, 1, "目パチ")
	event.EohSetShow(9, 1)
	event.FuncPointShow("", "func2", 1)
	event.FuncPointShow("", "func3", 1)
	event.FuncPointShow("", "func0", 0)
	event.FuncPointShow("", "func", 0)
	event.FuncPointShow("", "func4", 0)
	event.ObjsSetRot(11, 0.0, 1.57, 0.0)
	event.ObjsSetRot(17, 0.0, 1.57, 0.0)
	event.EohSetShow(8, 1)
	event.EohSetShow(18, 0)
	event.SndSePlay(var4, 4)
	event.SndSePlay(var4, 5)
	event.CmrsSetPos(-104.47, 123.32, -554.46)
	event.CmrsSetRef(123.37, 22.54, -57.61)
	event.CharaActive(1, 12)
	event.CharaActive(1, global10)
	event.CharaActive(1, global11)
	event.CharaActive(1, 9)
	event.CharaActive(1, 11)
	event.CharaActive(1, 19)
	event.CharaActive(0, 20)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetPos(8, -3191.25, 25.75, 1213.17)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.ObjsSetPos(7, -2749.5, 25.75, 1190.29)
	event.ObjsSetRot(7, 0.0, 2.16, 0.0)
	event.ObjsSetPos(6, -2755.39, 25.75, 1165.67)
	event.ObjsSetRot(6, 0.0, 1.92, 0.0)
	event.ObjsSetPos(10, 0.0, -50.0, 0.0)
	event.ObjsSetPos(5, -166.32, 0.0, 83.49)
	event.ObjsSetRot(5, 0.0, -1.2, 0.0)
	event.ObjsSetPos(4, -71.49, 0.0, 76.37)
	event.ObjsSetRot(4, 0.0, -1.12, 0.0)
	event.ObjsSetPos(0, 0.0, -50.0, 10.0)
	event.ObjsSetRot(0, 0.0, -1.2, 0.0)
	event.ObjsSetPos(1, 0.0, -50.0, -10.0)
	event.ObjsSetRot(1, 0.0, -1.2, 0.0)
	event.SetFadeIn(30)
	event.ObjsMove(1, 0.0, 0.0, -10.0, 180)
	event.ObjsMove(0, 0.0, 0.0, 10.0, 180)
	event.ObjsMove(10, 0.0, 0.0, 0.0, 180)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(-104.47, 123.32, -554.46, 123.37, 22.54, -57.61)
	event.CmrsAddPas(-295.35, 123.32, -466.93, -67.52, 22.54, 29.92)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(2)
	end
	event.InitDramaScene()
	event.CmrsSetPos(94.12, 16.49, 28.03)
	event.CmrsSetRef(-65.76, 22.54, 25.67)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSeStop(var4, 5)
	event.SndSePlay(var4, 6)
	event.ObjsSetMotion(5, "振り向く", 6)
	event.ObjsNextMotion(5, "振り向くL", 4)
	event.ObjsSetMotion(4, "振り向く", 6)
	event.ObjsNextMotion(4, "振り向くL", 4)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetRot(4, 0.0, -1.12, 0.0)
	event.CmrsSetPos(-268.03, 16.49, 76.91)
	event.CmrsSetRef(-65.76, 22.54, 25.67)
	event.ObjsSetMotion(1, "歩き", 4, 0.75)
	event.ObjsMove(1, -263.33, 0.0, 81.55, 180, 1)
	event.SetPakuAnim(5, "通常口パク")
	helper_09b5edc9(3520190, -1)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-198.27, 24.06, -15.13)
	event.CmrsSetRef(-143.41, 22.54, 150.46)
	event.ObjsSetRot(5, 0.0, 0.24, 0.0)
	event.SetPakuAnim(1, "通常口パク")
	helper_09b5edc9(3520200, 60)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetRot(5, 0.0, -1.2, 0.0)
	event.ObjsSetMotion(5, "立ち2", 4)
	event.CmrsSetPos(-297.3, 23.01, 69.91)
	event.CmrsSetRef(-176.77, 22.54, 113.71)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "にらむ", 4)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-149.75, 53.84, 30.37)
	event.CmrsSetRef(-284.64, 36.42, 86.71)
	event.SndSePlay(var4, 7)
	helper_a0e17f3c(45)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-2289.28, -11.1, 1309.03)
	event.CmrsSetRef(-2581.77, 22.54, 1222.45)
	event.SndSePlay(var4, 7)
	helper_a0e17f3c(45)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "わらい顔")
	event.ObjsTexAnime(6, 1, "通常目パチ")
	event.CmrsSetPos(-2702.74, 44.98, 1141.15)
	event.CmrsSetRef(-2834.5, 81.31, 1195.57)
	event.CmrsSetPos(-2702.74, 48.17, 1141.15)
	event.CmrsSetRef(-2834.5, 105.2, 1195.57)
	event.ObjsSetPos(6, -2755.39, 38.24, 1165.67)
	event.ObjsSetRot(6, 0.0, 1.92, 0.0)
	event.ObjsResetDaPosition(6)
	event.SndSePlay(var4, 7)
	helper_a0e17f3c(45)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetPos(6, -2755.39, 25.75, 1165.67)
	event.ObjsSetRot(6, 0.0, 1.92, 0.0)
	event.ObjsSetMotion(1, "上にらみ", 4)
	event.CmrsSetPos(-297.3, 23.01, 69.91)
	event.CmrsSetRef(-176.77, 22.54, 113.71)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3520203)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-391.93, 13.26, 98.06)
	event.CmrsSetRef(-272.34, 20.12, 89.15)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var4, 8)
	event.SetCharaPos(15, -347.49, -8.42, 91.78)
	event.CharaActive(1, 15)
	event.SetMotion(15, "ｴﾌｪｸﾄ_モニカ火", 6, -1, 1)
	event.ObjsSetMotion(1, "あつい", 6)
	event.ObjsNextMotion(1, "あついL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_09b5edc9(3520205, -1)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(15)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetPos(5, -157.43, 0.0, 37.77)
	event.ObjsSetRot(5, 0.0, -1.2, 0.0)
	event.ObjsSetPos(4, -113.67, 0.0, 42.81)
	event.ObjsSetRot(4, 0.0, -1.12, 0.0)
	event.ObjsSetPos(0, -159.45, 0.0, 85.12)
	event.ObjsSetRot(0, 0.0, -1.56, 0.0)
	event.CharaActive(0, 15)
	event.CmrsSetPos(17.51, 106.77, -12.07)
	event.CmrsSetRef(-167.62, 22.54, 62.55)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(19)
	end
	event.StopBgm(0)
	if vm.wait() then
		return skip(20)
	end
	if vm.wait() then
		return skip(21)
	end
	if vm.wait() then
		return skip(22)
	end
	if vm.wait() then
		return skip(23)
	end
	event.LoadBgm(33)
	event.PlayBgm(0)
	event.ObjsSetRot(5, 0.0, -2.64, 0.0)
	event.ObjsSetPos(4, -110.41, 0.0, 20.43)
	event.ObjsSetMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "立ち", 6)
	event.ObjsNextMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.CmrsSetPos(-198.48, 18.18, 1.71)
	event.CmrsSetRef(-152.88, 22.54, 67.21)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3520210)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "しがみつく", 6)
	event.ObjsNextMotion(5, "しがみつくL", 4)
	event.ObjsSetMotion(4, "しがみつく", 6)
	event.ObjsNextMotion(4, "しがみつくL", 4)
	event.ObjsSetPos(4, -157.43, 0.0, 37.77)
	event.ObjsSetRot(4, 0.0, -2.62, 0.0)
	event.SndSePlay(var4, 9)
	event.CmrsSetPos(-195.7, 18.18, -27.74)
	event.CmrsSetRef(-152.88, 22.54, 67.21)
	event.ObjsSetMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "立ち", 6)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3520220)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetPos(0, -220.59, 0.0, 24.32)
	event.ObjsSetMotion(5, "だいじょうぶ", 6)
	event.ObjsNextMotion(5, "だいじょうぶL", 4)
	event.ObjsSetMotion(4, "だいじょうぶ", 6)
	event.ObjsNextMotion(4, "だいじょうぶL", 4)
	event.CmrsSetPos(-172.22, 21.82, 12.89)
	event.CmrsSetRef(-146.82, 22.54, 46.98)
	event.SetPakuAnim(5, "通常口パク")
	helper_fa57afea(3520230)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "なでなで", 6)
	event.ObjsNextMotion(5, "だいじょうぶL", 4)
	event.ObjsSetMotion(4, "なでなで", 6)
	event.ObjsNextMotion(4, "だいじょうぶL", 4)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSePlay(var4, 11)
	event.ObjsSetMotion(5, "方向転換", 6)
	event.ObjsNextMotion(5, "方向転換L", 4)
	event.ObjsSetMotion(4, "方向転換", 6)
	event.ObjsNextMotion(4, "方向転換L", 4)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(29)
	end
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3520240)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.ObjsSetPos(5, -182.1, 0.0, 109.05)
	event.ObjsSetRot(5, 0.0, -0.56, 0.0)
	event.CmrsSetPos(-204.21, 71.27, 153.44)
	event.CmrsSetRef(-185.43, 22.54, 115.87)
	event.ObjsSetMotion(5, "立ち2", 4)
	event.CmrsSetPos(-235.14, 83.43, 215.35)
	event.CmrsSetRef(-216.37, 22.54, 177.78)
	event.CmrsMove2(-201.16, 83.43, 147.34, -182.39, 22.54, 109.77, 90, 2, 1.0)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(31)
	end
	event.SndSePlay(var4, 12)
	event.ObjsSetMotion(5, "顔を上げる", 6)
	event.ObjsNextMotion(5, "顔を上げるL", 4)
	event.SetPakuAnim(5, "通常口パク")
	helper_fa57afea(3520250)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(33)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetRot(4, 0.0, -0.7, 0.0)
	event.CmrsSetPos(-85.52, 20.68, 6.25)
	event.CmrsSetRef(-208.47, 22.54, 109.19)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3520260)
	if vm.skipping() then
		return skip(35)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(25)
	event.CmrsAddPas(-85.52, 20.68, 6.25, -208.47, 22.54, 109.19)
	event.CmrsAddPas(-85.52, 20.68, 6.25, -208.47, 79.99, 109.19)
	event.CmrsStartPas()
	event.SndSePlay(var4, 13)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	helper_a0e17f3c(15)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsMove(5, -182.1, 100.3, 109.05, 10)
	event.ObjsSetMotion(4, "見上げる", 6)
	event.ObjsNextMotion(4, "見上げるL", 4)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(38)
	end
	event.SndSeStop(var4, 8)
	event.SndSePlay(var4, 14)
	event.ObjsSetMotion(5, "空中", 4)
	event.CmrsSetPos(-492.85, 213.33, 582.49)
	event.CmrsSetRef(22.56, 390.84, -208.1)
	event.CmrsMove2(-492.85, 409.38, 582.49, 22.56, 390.84, -208.1, 180, 0, 0.5)
	event.ObjsJump(5, -151.79, 185.12, 324.04, -0.6, 40)
	helper_a0e17f3c(25)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(5, "着地", 6)
	helper_a19c5ee3(5)
	if vm.skipping() then
		return skip(40)
	end
	event.SndSePlay(var4, 16)
	event.ObjsRotation(5, 0.0, -2.8, 0.0, 20)
	event.ObjsSetMotion(5, "歩き")
	helper_a19c5ee3(5)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(5, "立ち")
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(42)
	end
	event.SndSePlay(var4, 15)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsSetMotion(5, "空中", 5)
	helper_a19c5ee3(5)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsJump(5, -171.87, 401.97, -73.85, -0.4, 60)
	event.ObjsSetMotion(5, "空中", 4)
	event.ObjsMotionDelay(5, 45)
	event.ObjsSetMotion(5, "着地", 6)
	helper_a19c5ee3(5)
	if vm.skipping() then
		return skip(44)
	end
	event.SndSePlay(var4, 16)
	helper_a0e17f3c(50)
	if vm.skipping() then
		return skip(45)
	end
	helper_b35e85eb()
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsSetRot(5, 0.0, -0.37, 0.0)
	event.ObjsSetMotion(5, "立ち3", 4)
	event.CmrsSetPos(-269.68, 499.83, 184.82)
	event.CmrsSetRef(-101.0, 390.84, -261.7)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(47)
	end
	event.DeleteChara(11)
	event.CharaActive(1, 20)
	event.CmrsSetPos(-1457.89, -261.89, 4173.26)
	event.CmrsSetRef(-421.4, -280.5, -595.03)
	event.ObjsSetRot(8, 0.0, -1.0, 0.0)
	event.ObjsSetPos(8, -544.76, -500.0, -1135.49)
	event.ObjsSetPos(6, -348.21, -500.0, -746.45)
	event.ObjsSetRot(6, 0.0, 0.72, 0.0)
	event.ObjsMove2(6, -348.21, -29.77, -746.45, 420, 2, 1.0)
	event.ObjsSetPos(7, -382.55, -500.0, -760.19)
	event.ObjsSetRot(7, 0.0, 0.72, 0.0)
	event.ObjsMove2(7, -382.55, -30.09, -760.19, 420, 2, 1.0)
	event.ObjsMove2(8, -544.76, -29.77, -1135.49, 420, 2, 1.0)
	helper_a0e17f3c(150)
	if vm.skipping() then
		return skip(48)
	end
	event.SndSeStop(var4, 4)
	event.SndSePlay(var4, 17)
	event.SndSePlay(var4, 18)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetMotion(1, "にらむ", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(1, -81.37, 0.0, -233.88)
	event.ObjsSetRot(1, 0.0, -2.74, 0.0)
	event.ObjsSetPos(4, -95.85, 0.0, -144.83)
	event.ObjsSetRot(4, 0.0, -2.74, 0.0)
	event.ObjsSetPos(0, -27.4, 0.0, -192.2)
	event.ObjsSetRot(0, 0.0, -2.74, 0.0)
	event.CmrsSetPos(72.53, 32.73, -113.44)
	event.CmrsSetRef(-214.71, 27.16, -908.69)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-121.55, 32.73, -43.34, -408.79, 27.16, -838.6)
	event.CmrsAddPas(72.53, 32.73, -113.44, -214.71, 27.16, -908.69)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsSetPos(-104.37, 19.87, -248.05)
	event.CmrsSetRef(-79.52, 22.03, -232.43)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(50)
	end
	event.CmrsSetPos(-34.84, 37.38, -59.03)
	event.CmrsSetRef(-95.77, 20.25, -225.62)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(51)
	end
	event.CmrsSetPos(-348.67, -50.57, -550.42)
	event.CmrsSetRef(-351.04, 5.47, -770.66)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(52)
	end
	event.CmrsSetPos(-318.01, 1.52, -739.61)
	event.CmrsSetRef(-349.36, 5.47, -775.54)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(-339.91, 1.52, -720.51, -371.26, 5.47, -756.44)
	event.CmrsAddPas(-329.37, 1.52, -729.7, -360.72, 5.47, -765.63)
	event.CmrsStartPas()
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "デフォルト顔")
	event.ObjsTexAnime(6, 1, "通常目パチ")
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "わらい顔")
	event.ObjsTexAnime(6, 1, "通常目パチ")
	helper_b35e85eb()
	if vm.skipping() then
		return skip(54)
	end
	event.CmrsSetPos(-104.37, 19.87, -248.05)
	event.CmrsSetRef(-79.52, 22.03, -232.43)
	event.SetCrossfade(30)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(55)
	end
	event.CmrsSetPos(-207.34, 54.9, -452.6)
	event.CmrsSetRef(-71.26, 17.87, -226.97)
	event.ObjsSetPos(1, -47.62, 0.0, -137.28)
	event.ObjsSetRot(1, 0.0, -2.74, 0.0)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -70.49, 0.0, -204.72, 40)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(56)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(1, "飛び", 2)
	event.ObjsMove(1, -87.32, 0.0, -244.51, 20)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(58)
	end
	event.SndSePlay(var4, 19)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(59)
	end
	event.CmrsSetPos(-295.37, -86.21, -553.05)
	event.CmrsSetRef(-123.25, 61.72, -340.9)
	helper_a0e17f3c(50)
	if vm.skipping() then
		return skip(60)
	end
	event.CmrsSetPos(-62.09, 9.68, -219.85)
	event.CmrsSetRef(14.42, 33.43, -191.5)
	event.SndSePlay(var4, 20)
	event.ObjsSetMotion(0, "モニカぁあ～", 6)
	event.ObjsNextMotion(0, "モニカぁあ～L", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_09b5edc9(3520280, -1)
	if vm.skipping() then
		return skip(61)
	end
	event.ResetPakuAnim()
	event.ObjsSetPos(1, -138.57, 9.72, -786.98)
	event.ObjsSetMotion(1, "飛び2秒", 4)
	event.CmrsSetPos(-389.59, 107.61, -250.29)
	event.CmrsSetRef(-69.28, 33.43, -379.52)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(60)
	event.CmrsAddPas(-142.97, 98.14, -135.2, -116.47, 68.27, -429.76)
	event.CmrsAddPas(-218.4, 98.14, -142.95, -218.24, 68.27, -438.91)
	event.CmrsStartPas()
	event.ObjsJump(1, -297.28, -20.16, -768.4, -0.15, 60)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(62)
	end
	event.SndSeStop(var4, 18)
	event.EohSetFootSoundId(1, 0)
	event.CmrsSetPos(-153.85, 1.75, -965.32)
	event.CmrsSetRef(-213.98, -16.72, -854.17)
	event.FadeOutBgm(90)
	event.ObjsSetPos(1, -213.98, -29.77, -854.17)
	event.SndSePlay(var4, 21)
	event.ObjsSetMotion(1, "着地2", 6)
	event.ObjsNextMotion(1, "着地2Ｌ", 4)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(63)
	end
	event.StopBgm(0)
	event.ObjsSetMotion(1, "にらみ～ギルトーニＬ", 4)
	event.ObjsSetRot(1, 0.0, -0.89, 0.0)
	event.ObjsSetRot(7, 0.0, 2.16, 0.0)
	event.ObjsSetRot(6, 0.0, 2.16, 0.0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-382.3, 9.54, -680.59, -184.92, -16.72, -809.77)
	event.CmrsAddPas(-413.29, 9.54, -727.92, -215.9, -16.72, -857.11)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(64)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(360)
	event.CmrsAddPas(-296.02, -4.19, -748.32, -394.55, 1.71, -679.52)
	event.CmrsAddPas(-318.45, -4.19, -780.45, -416.98, 1.71, -711.64)
	event.CmrsStartPas()
	helper_a0e17f3c(120)
	if vm.skipping() then
		return skip(65)
	end
	event.SetPakuAnim(6, "通常口パク")
	helper_09b5edc9(3520290, -1)
	if vm.skipping() then
		return skip(66)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_09b5edc9(3520295, -1)
	if vm.skipping() then
		return skip(67)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 22)
	event.ObjsSetMotion(7, "立ちからはっ", 6)
	event.ObjsNextMotion(7, "立ち", 4)
	event.SetPakuAnim(7, "通常口パク")
	helper_09b5edc9(3520300, -1)
	if vm.skipping() then
		return skip(68)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, 16)
	event.SetCharaPos(16, -382.55, -29.77, -760.19)
	event.SetMotion(16, "ワープ", 2, -1, 1)
	event.SndSePlay(var4, 23)
	event.SetCharaShow(20, 0, 1, 0.025)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(69)
	end
	event.CharaActive(0, 20)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(70)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(71)
	end
	event.DeleteChara(20)
	event.CmrsSetPos(-236.39, -1.57, -810.07)
	event.CmrsSetRef(-210.96, -15.51, -863.92)
	event.SetPakuAnim(1, "通常口パク")
	helper_09b5edc9(3520310, -1)
	if vm.skipping() then
		return skip(72)
	end
	event.ResetPakuAnim()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(-193.72, -11.82, -832.4, -220.35, -5.56, -862.48)
	event.CmrsAddPas(-209.1, -11.82, -818.79, -235.72, -5.56, -848.88)
	event.CmrsStartPas()
	event.SetPakuAnim(1, "通常口パク")
	helper_09b5edc9(3520320, -1)
	if vm.skipping() then
		return skip(73)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_09b5edc9(3520325, -1)
	if vm.skipping() then
		return skip(74)
	end
	event.ResetPakuAnim()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(75)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(-298.65, -11.82, -739.54, -325.27, -5.56, -769.63)
	event.CmrsAddPas(-321.64, -11.82, -719.2, -348.27, -5.56, -749.28)
	event.CmrsStartPas()
	event.SetCrossfade(30)
	event.SetPakuAnim(6, "通常口パク")
	helper_09b5edc9(3520330, -1)
	if vm.skipping() then
		return skip(76)
	end
	event.ResetPakuAnim()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(77)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(78)
	end
	event.CmrsSetPos(-311.57, -2.68, -773.5)
	event.CmrsSetRef(-346.28, 0.67, -749.62)
	event.SndSePlay(var4, 24)
	event.ObjsSetMotion(6, "これはこれは", 6)
	event.ObjsNextMotion(6, "立ち", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3520340)
	if vm.skipping() then
		return skip(79)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(6)
	if vm.skipping() then
		return skip(80)
	end
	event.SetProjection(2000.0)
	event.CmrsSetPasFrm(200)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-389.89, 2.83, -660.42, -273.14, -7.07, -813.46)
	event.CmrsAddPas(-436.6, 2.83, -711.42, -273.14, -7.07, -813.46)
	event.CmrsStartPas()
	event.SetPakuAnim(1, "通常口パク")
	helper_09b5edc9(3520350, -1)
	if vm.skipping() then
		return skip(81)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(82)
	end
	event.SndSePlay(var4, 25)
	event.ObjsSetMotion(1, "許さない！", 6)
	event.ObjsNextMotion(1, "にらみ～ギルトーニＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_09b5edc9(3520355, -1)
	if vm.skipping() then
		return skip(83)
	end
	event.ResetPakuAnim()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(84)
	end
	event.CmrsSetPos(-316.92, -38.16, -871.1)
	event.CmrsSetRef(-346.81, 0.41, -749.55)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3520360)
	if vm.skipping() then
		return skip(85)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3520365)
	if vm.skipping() then
		return skip(86)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-52.38, 14.17, -934.99)
	event.CmrsSetRef(-338.56, -9.4, -775.64)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3520370)
	if vm.skipping() then
		return skip(87)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3520380)
	if vm.skipping() then
		return skip(88)
	end
	event.ResetPakuAnim()
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, 17)
		event.CharaActive(1, 18)
	else
		event.EohSyncChara(2, 1)
		event.EohSetShow(2, 1)
		event.EohSyncChara(3, 2)
		event.EohSetShow(3, 1)
	end
	event.PlayBgm(0)
	event.CmrsSetPos(-315.54, 2.28, -794.45)
	event.CmrsSetRef(-206.14, -9.4, -856.87)
	event.SndSePlay(var4, 26)
	event.ObjsSetMotion(1, "構え", 6)
	event.ObjsNextMotion(1, "構えＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3520390)
	if vm.skipping() then
		return skip(89)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(90)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(91)
	end
	event.DeleteChara(11)
	event.DeleteChara(19)
	event.DeleteChara(20)
	event.DeleteChara(15)
	event.DeleteChara(16)
	event.ClearStack(6)
	event.SetProjection(projection)
	event.LoadChara(6, "event/e300/e352/e352_fireball.gltf", "info", 21)
	event.EohSyncChara(12, 21)
	event.ObjsInit(12, 21)
	event.ObjsSyncObj(12, 12)
	event.CharaActive(0, 21)
	event.CopyChara(6, 21, 22)
	event.EohSyncChara(13, 22)
	event.ObjsInit(13, 22)
	event.ObjsSyncObj(13, 13)
	event.CharaActive(0, 22)
	event.CopyChara(6, 21, 23)
	event.EohSyncChara(14, 23)
	event.ObjsInit(14, 23)
	event.ObjsSyncObj(14, 14)
	event.CharaActive(0, 23)
	event.CopyChara(6, 21, 13)
	event.EohSyncChara(15, 13)
	event.ObjsInit(15, 13)
	event.ObjsSyncObj(15, 15)
	event.CharaActive(0, 13)
	event.CopyChara(6, 21, 14)
	event.EohSyncChara(16, 14)
	event.ObjsInit(16, 14)
	event.ObjsSyncObj(16, 16)
	event.CharaActive(0, 14)
	event.ObjsSetPos(12, 179.32, 0.0, 162.8)
	event.ObjsSetRot(12, 0.0, -2.4, 0.0)
	event.ObjsSetPos(13, 82.96, 0.0, 206.67)
	event.ObjsSetRot(13, 0.0, -2.88, 0.0)
	event.ObjsSetPos(14, -190.58, 0.0, -150.66)
	event.ObjsSetRot(14, 0.0, 1.32, 0.0)
	event.ObjsSetPos(15, -120.47, 0.0, -224.18)
	event.ObjsSetRot(15, 0.0, 0.24, 0.0)
	event.ObjsSetPos(16, -87.9, 0.0, -228.03)
	event.ObjsSetRot(16, 0.0, 0.6, 0.0)
	event.ObjsSetPos(4, -73.68, 0.0, -125.3)
	event.ObjsSetRot(4, 0.0, -2.74, 0.0)
	event.ObjsSetPos(0, -56.83, 0.0, -155.67)
	event.ObjsSetRot(0, 0.0, -2.74, 0.0)
	event.ObjsSetMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "立ち", 6)
	event.ObjsSetMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "立ち", 6)
	event.ObjsSetMotion(4, "おびえ立ち", 4)
	event.EohSetFrameShow(4, "houki", 1)
	event.SndSePlay(var4, 27)
	event.CmrsSetPos(-238.5, 71.05, -462.7)
	event.CmrsSetRef(-30.96, 27.68, -54.57)
	event.SetFadeIn(30)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(92)
	end
	event.CmrsSetPos(-90.18, 13.15, -222.54)
	event.CmrsSetRef(-38.29, 20.0, -70.1)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3520400)
	if vm.skipping() then
		return skip(93)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3520410)
	if vm.skipping() then
		return skip(94)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3520420)
	if vm.skipping() then
		return skip(95)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, 21)
	event.CmrsSetPos(289.65, 77.87, 17.75)
	event.CmrsSetRef(137.1, 27.68, 277.81)
	event.SndSePlay(var4, 28)
	event.ObjsSetMotion(12, "飛び込み登場", 6)
	event.ObjsNextMotion(12, "立ち", 4)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(96)
	end
	event.SndSePlay(var4, 32)
	helper_a19c5ee3(12)
	if vm.skipping() then
		return skip(97)
	end
	event.CharaActive(1, 22)
	event.SndSePlay(var4, 28)
	event.ObjsSetMotion(13, "飛び込み登場", 6)
	event.ObjsNextMotion(13, "立ち", 4)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(98)
	end
	event.SndSePlay(var4, 32)
	helper_a19c5ee3(13)
	if vm.skipping() then
		return skip(99)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(100)
	end
	event.CharaActive(1, 23)
	event.CharaActive(1, 13)
	event.CmrsSetPos(38.51, 77.87, -229.29)
	event.CmrsSetRef(-255.97, 27.68, -248.1)
	event.ObjsSetMotion(14, "立ち", 4)
	event.SndSePlay(var4, 28)
	event.ObjsSetMotion(15, "飛び込み登場", 6)
	event.ObjsNextMotion(15, "立ち", 4)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(101)
	end
	event.SndSePlay(var4, 32)
	helper_a19c5ee3(15)
	if vm.skipping() then
		return skip(102)
	end
	event.CharaActive(1, 14)
	event.SndSePlay(var4, 28)
	event.ObjsSetMotion(16, "飛び込み登場", 6)
	event.ObjsNextMotion(16, "立ち", 4)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(103)
	end
	event.SndSePlay(var4, 32)
	helper_a19c5ee3(16)
	if vm.skipping() then
		return skip(104)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(105)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, 17)
		event.CharaActive(1, 18)
	else
		event.EohSyncChara(2, 1)
		event.EohSetShow(2, 1)
		event.EohSyncChara(3, 2)
		event.EohSetShow(3, 1)
	end
	event.CmrsSetPos(-59.58, 20.53, -228.9)
	event.CmrsSetRef(-62.47, 27.68, -105.07)
	event.SndSePlay(var4, 29)
	event.ObjsSetMotion(0, "かまえる", 6)
	event.ObjsNextMotion(0, "かまえるL", 4)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(106)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(107)
	end
	return part2()
end

--- Helper function.
local function helper_25988()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global12 = 0
		global13 = 8
		global12 = 8
		global13 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global12 = 0
		global13 = 8
		event.LoadChara(5, "chara/c02_base.gltf", "info", global13)
		event.LoadEquip(5, 1, 1, "info", global13, 17)
		event.LoadEquip(5, 1, 0, "info", global13, 18)
		event.LoadEquip(5, 1, 4, "info", global13)
		event.LoadEquip(5, 1, 3, "info", global13)
		event.LoadEquip(5, 1, 2, "info", global13, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global13)
		event.LoadMotion(5, "event/e300/e352/vs_e352_monica.gltf", "info", global13)
		event.EohSyncChara(1, global13)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(1, global13)
		event.CharaActive(1, 12)
		event.CharaActive(1, 17)
		event.CharaActive(1, 18)
	end
	if active_chr_no == 1 then
		global12 = 8
		global13 = 0
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global13)
		event.LoadMotion(5, "event/e300/e352/vs_e352_monica.gltf", "info", global13)
		event.EohSyncChara(1, global13)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global13)
		event.EohSyncChara(2, 1)
		event.EohSetShow(2, 1)
		event.EohSyncChara(3, 2)
		event.EohSetShow(3, 1)
	end
	event.LoadChara(5, "event/e300/e352/e352_guiltoni.gltf", "info", 19)
	event.LoadMotion(5, "event/e300/e352/vs_e352_guiltoni.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(6, 19)
	event.ObjsInit(6, 19)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/lm/mo_vs_gil2/vs2_cam.gltf", "info", 15)
	event.EohSyncObj(8, "p01_battleship")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(10, "p01_d03b01", "d03b01_12-m0")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSyncObj(11, "p02_d03b01", "d03b01_3-m0")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(18, "p02_d03b01", "d03b01_15-m0")
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 18)
	block = event.LoadImg_4(5, "textures/dungeon/image/beffect_00.json", 0) or block
	event.SweInit(18, 0, 5, 16, 8)
	event.SweSetTexture(18, 0, block, "sweff", 0, 0, 64, 32)
	event.SweInit(18, 1, 5, 16, 8)
	event.SweSetTexture(18, 1, block, "sweff", 0, 0, 64, 32)
	event.SweInit(19, 0, 5, 16, 8)
	event.SweSetTexture(19, 0, block, "sweff", 64, 0, 64, 32)
	event.SweInit(19, 1, 5, 16, 8)
	event.SweSetTexture(19, 1, block, "sweff", 64, 0, 64, 32)
	block = event.LoadImg_4(5, "textures/event/e300/e352/e352telop01_1.json", 1) or block
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "e352telop01", block)
	event.SpriteSetUvsize(4, 0, 0, 512, 128)
	event.SpriteSetPutsize(4, 512, 128)
	event.SpriteSetPos(4, 320, 334)
	event.SpriteSetColor(4, 128, 128, 128, 0)
	event.SpriteSetScale(4, 1.0, 1.0)
	event.SpriteSetDraw(4, 0)
	event.EohSyncSprite(14, 4)
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
end

--- Helper function.
local function helper_25400()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(0, global13)
		event.DelExtMotion(global13)
		event.DeleteChara(global13)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global13)
		event.CharaActive(0, global12)
		event.DelExtMotion(global13)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(19)
	event.DelImg(0)
	event.DelImg(1)
	event.DeleteChara(15)
	event.FuncPointShow("", "func", 1)
	event.FuncPointShow("", "func4", 1)
	event.EohSetShow(18, 1)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.SetStatusbarShow(1, 1.0)
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Helper function.
local function helper_26f20()
	local var4: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var12: s32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_25988()
				helper_a0e17f3c(50)
			end
			if at <= 2 then
				helper_a0e17f3c(12)
			end
			if at <= 3 then
				helper_b35e85eb()
			end
			if at <= 4 then
				var12 = 0
				var12 = var12 + 1
			end
			if at <= 5 then
				var12 = 0
				var12 = var12 + 1
			end
			if at <= 6 then
				helper_a0e17f3c(90)
			end
			if at <= 7 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 10 then
			helper_25400()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.ObjsSetPos(10, 0.0, 0.0, 0.0)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SndSeAllStop(4)
		if vm.wait() then
			return skip(10)
		end
		helper_25400()
		if vm.skipping() then
			return skip(11)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var4 = event.SndLoadSound(3839) or var4
	helper_25988()
	time = event.GetTime() or time
	event.SetTime(18.0)
	event.SetTimeStepEnable(0)
	event.InitDramaScene()
	event.ObjsSetPos(8, -2195.0, 488.0, -475.0)
	event.CharaActive(0, 19)
	event.FuncPointShow("", "func", 0)
	event.FuncPointShow("", "func4", 0)
	event.ObjsSetRot(11, 0.0, 1.57, 0.0)
	event.ObjsSetRot(17, 0.0, 1.57, 0.0)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 0)
	event.EohSetShow(18, 0)
	event.SetCharaPos(global13, -2195.0, 488.0, -475.0)
	event.SetCharaRot(global13, 0.0, 1.94, 0.0)
	event.SetCharaPos(19, -2195.0, 488.0, -475.0)
	event.SetCharaRot(19, 0.0, 2.9, 0.0)
	event.SetMotion(global13, "ふりむき", 2, -1, 1)
	event.SetMotion(19, "戦い", 1, -1, 1)
	event.CharaActive(1, 15)
	event.SetCharaPos(15, -2195.0, 488.0, -475.0)
	event.SetCharaRot(15, 0.0, 2.9, 0.0)
	event.SetMotion(15, "1カメ", 5)
	event.CharaActive(1, global13)
	event.SetFadeIn(30)
	event.SndSePlay(var4, 30)
	event.SetCameraPos(-2170.97, 511.0, -483.67)
	event.SetCameraRef(-2195.0, 511.0, -475.0)
	helper_a0e17f3c(50)
	if vm.skipping() then
		return skip(2)
	end
	event.SweStartEffect(18, 0, "dcol00", "dcol01", 94, 10, 16)
	helper_a0e17f3c(12)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsMove2(-2142.85, 509.61, -493.81, -2195.0, 503.11, -475.0, 10, 1, 0.6)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "怒り目")
	event.EohSetTexAnim(1, 1, "怒り口")
	event.SetCharaRot(global13, 0.0, 2.9, 0.0)
	event.CharaActive(1, 19)
	event.EohSetFrameStatus(6, "sword", 1)
	event.SetMotion(global13, "戦い", 6)
	event.SetMotion(19, "戦い", 6)
	event.SetMotion(15, "1カメ", 6)
	event.EohSyncChara(17, 15)
	var12 = 0
	do
		local out1, out2, out3 = event.CopyVector(-2172.93, 510.33, -526.41)
		var13 = out1 or var13
		var14 = out2 or var14
		var15 = out3 or var15
	end
	do
		local out1, out2, out3 = event.CopyVector(-2168.55, 512.98, -523.85)
		var16 = out1 or var16
		var17 = out2 or var17
		var18 = out3 or var18
	end
	do
		local out1, out2, out3 = event.SubVector(var16, var17, var18, -2172.93, 510.33, -526.41)
		var16 = out1 or var16
		var17 = out2 or var17
		var18 = out3 or var18
	end
	do
		local out1, out2, out3 = event.ScaleVector(var16, var17, var18, 0.03)
		var16 = out1 or var16
		var17 = out2 or var17
		var18 = out3 or var18
	end
	while var12 < 123 do
		if var12 == 10 then
			event.SweStartEffect(18, 0, "dcol00", "dcol01", 94, 6, 6)
		end
		if var12 == 26 then
			event.SweStartEffect(18, 1, "dcol00", "dcol01", 94, 10, 10)
		end
		if var12 == 46 then
			event.SweStartEffect(18, 0, "dcol00", "dcol01", 94, 10, 10)
		end
		if var12 == 46 then
			event.SweStartEffect(19, 0, "ken00", "ken01", 94, 4, 8)
		end
		if var12 == 49 then
			event.HitEffect(0, var13, var14, var15)
		end
		if var12 > 50 and var12 <= 90 then
			do
				local out1, out2, out3 = event.AddVector(var13, var14, var15, var16, var17, var18)
				var13 = out1 or var13
				var14 = out2 or var14
				var15 = out3 or var15
			end
			if var12 >= 68 and var12 <= 90 and vm.imod(var12, 3) == 0 then
				event.HitEffect(1, var13, var14, var15)
			end
		end
		do
			local out1, out2, out3 = event.EohGetFramePos(17, "int1")
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		do
			local out1, out2, out3 = event.EohGetFramePos(17, "cam1")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		var12 = var12 + 1
		if vm.wait() then
			return skip(5)
		end
	end
	event.ObjsSetMotionNowTime(1, 53.1)
	event.ObjsSetMotionNowTime(6, 53.1)
	event.SetMotion(15, "2カメ", 6)
	var12 = 0
	while var12 < 85 do
		if var12 == 26 then
			event.SweStartEffect(19, 0, "ken00", "ken01", 94, 4, 8)
		end
		if var12 == 38 then
			event.SweStartEffect(19, 1, "ken00", "ken01", 94, 10, 10)
		end
		do
			local out1, out2, out3 = event.EohGetFramePos(17, "int2")
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		do
			local out1, out2, out3 = event.EohGetFramePos(17, "cam2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		var12 = var12 + 1
		if vm.wait() then
			return skip(6)
		end
	end
	event.SndSePlay(var4, 31)
	event.SetMotion(19, "着地", 6)
	event.SetCameraPos(-2216.51, 515.07, -318.73)
	event.SetCameraRef(-2223.46, 515.07, -269.18)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(45)
	event.CmrsAddPas(-2216.51, 497.31, -318.73, -2223.46, 497.3, -269.18)
	event.CmrsAddPas(-2216.51, 515.07, -318.73, -2223.46, 515.07, -269.18)
	event.CmrsStartPas()
	event.SpriteSetDraw(4, 1)
	event.ObjsSetColor(14, 128, 128, 128, 128, 30)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetColor(14, 128, 128, 128, 0, 30)
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_29bc4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global14 = 0
		global15 = 32
		global14 = 32
		global15 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global14 = 0
		global15 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global14)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global14)
		event.EohSyncChara(0, global14)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global14)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global15)
		event.LoadEquip(5, 1, 1, "info", global15, 41)
		event.LoadEquip(5, 1, 0, "info", global15, 42)
		event.LoadEquip(5, 1, 4, "info", global15)
		event.LoadEquip(5, 1, 3, "info", global15)
		event.LoadEquip(5, 1, 2, "info", global15, 36)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global15)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global15)
		event.EohSyncChara(1, global15)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global15)
		event.CharaActive(1, 36)
		event.CharaActive(0, 41)
		event.CharaActive(0, 42)
	end
	if active_chr_no == 1 then
		global14 = 32
		global15 = 0
		event.LoadEquip(5, 1, 1, "info", global15, 41)
		event.LoadEquip(5, 1, 0, "info", global15, 42)
		event.LoadChara(5, "chara/c01_base.gltf", "info", global14)
		event.LoadEquip(5, 0, 4, "info", global14)
		event.LoadEquip(5, 0, 3, "info", global14)
		event.LoadEquip(5, 0, 2, "info", global14, 36)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global14)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global14)
		event.EohSyncChara(0, global14)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global14)
		event.CharaActive(1, 36)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global15)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global15)
		event.EohSyncChara(1, global15)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global15)
	end
	event.LoadChara(5, "event/e300/e356/e356_crest.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(5, 34)
	event.ObjsInit(5, 34)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "event/e300/e356/e356_guiltoni.gltf", "info", 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(6, 37)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e300/e356/e356_jamming.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(7, 38)
	event.ObjsInit(7, 38)
	event.ObjsSyncObj(7, 7)
	event.EohSyncObj(8, "p01_battleship")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(10, "p01_d03b01", "d03b01_12-m0")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSyncObj(11, "p02_d03b01", "d03b01_3-m0")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(12, "p02_d03b01", "d03b01_15-m0")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(14, "p01_battleship", "t01-m0")
	event.LoadChara(5, "event/e300/e352/e352_houdai.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(13, 33)
	event.ObjsInit(17, 33)
	event.ObjsSyncObj(17, 13)
	event.LoadChara(5, "event/e300/e352/e352_gun_f.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/e300/e352/e352_gun_l.gltf", "info", 43)
	event.CharaActive(0, 43)
	event.EohSyncChara(16, 43)
	event.ObjsInit(19, 43)
	event.ObjsSyncObj(19, 16)
	event.LoadChara(5, "event/e300/e352/e352_gun_h.gltf", "info", 44)
	event.CharaActive(0, 44)
	event.LoadChara(5, "event/e300/e356/e356_crystal_f.gltf", "info", 45)
	event.CharaActive(0, 45)
	event.LoadChara(5, "event/e300/e356/e356_crystal_l.gltf", "info", 46)
	event.CharaActive(0, 46)
	event.EohSyncChara(15, 46)
	event.ObjsInit(18, 46)
	event.ObjsSyncObj(18, 15)
	event.LoadChara(5, "event/e300/e356/e356_crystal_h.gltf", "info", 47)
	event.CharaActive(0, 47)
	event.LoadChara(5, "event/e300/e356/e356_baria.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.LoadChara(5, "event/e300/e356/e356_tbaku.gltf", "info", 48)
	event.CharaActive(0, 48)
	event.LoadChara(5, "event/e300/e352/e352_warp.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.SetScale(39, 1.1, 1.1, 1.1)
	event.LoadMes(0, 5, "event/e300/e356/e356_1.txt")
end

--- Helper function.
local function helper_294b0()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global14)
		event.CharaActive(0, global15)
		event.DelExtMotion(global14)
		event.DelExtMotion(global15)
		event.DeleteChara(global15)
		event.DeleteChara(36)
		event.DeleteChara(41)
		event.DeleteChara(42)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global15)
		event.CharaActive(0, global14)
		event.DelExtMotion(global14)
		event.DelExtMotion(global15)
		event.DeleteChara(global14)
		event.DeleteChara(36)
		event.DeleteChara(41)
		event.DeleteChara(42)
	end
	event.DeleteChara(34)
	event.DeleteChara(37)
	event.DeleteChara(38)
	event.DeleteChara(33)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.DeleteChara(45)
	event.DeleteChara(46)
	event.DeleteChara(47)
	event.DeleteChara(35)
	event.DeleteChara(48)
	event.FuncPointShow("", "func", 1)
	event.FuncPointShow("", "func4", 1)
	event.EohSetShow(12, 1)
	event.SetStatus(1, 0, 256, 0)
	event.EohSetShow(14, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

--- Helper function.
local function helper_2b9f4()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 54 then
			if at <= 4 then
				helper_a0e17f3c(35)
			end
			if at <= 5 then
				helper_29bc4()
			end
			if at <= 6 then
				helper_fa57afea(3560010)
			end
			if at <= 7 then
				helper_a0e17f3c(30)
			end
			if at <= 8 then
				helper_fa57afea(3560020)
			end
			if at <= 9 then
				helper_a0e17f3c(60)
			end
			if at <= 10 then
				helper_a19c5ee3(1)
			end
			if at <= 11 then
				helper_a0e17f3c(60)
			end
			if at <= 12 then
				helper_a0e17f3c(60)
			end
			if at <= 13 then
				helper_a0e17f3c(60)
			end
			if at <= 14 then
				helper_a0e17f3c(30)
			end
			if at <= 15 then
				helper_b35e85eb()
			end
			if at <= 16 then
				helper_b35e85eb()
			end
			if at <= 17 then
				helper_b35e85eb()
			end
			if at <= 18 then
				helper_a0e17f3c(60)
			end
			if at <= 19 then
				helper_09b5edc9(3560025, -1)
			end
			if at <= 20 then
				helper_09b5edc9(3560030, -1)
			end
			if at <= 21 then
				helper_a0e17f3c(5)
			end
			if at <= 22 then
				helper_a0e17f3c(10)
			end
			if at <= 23 then
				helper_a0e17f3c(20)
			end
			if at <= 24 then
				helper_a19c5ee3(6)
			end
			if at <= 25 then
				helper_a0e17f3c(30)
			end
			if at <= 26 then
				helper_fa57afea(3560040)
			end
			if at <= 27 then
				helper_fa57afea(3560050)
			end
			if at <= 28 then
				helper_fa57afea(3560055)
			end
			if at <= 29 then
				helper_fa57afea(3560060)
			end
			if at <= 30 then
				helper_a0e17f3c(30)
			end
			if at <= 31 then
				helper_b35e85eb()
			end
			if at <= 32 then
				helper_a0e17f3c(60)
			end
			if at <= 33 then
				helper_09b5edc9(3560070, -1)
			end
			if at <= 34 then
				helper_a0e17f3c(30)
			end
			if at <= 35 then
				helper_a0e17f3c(15)
			end
			if at <= 36 then
				helper_a0e17f3c(15)
			end
			if at <= 37 then
				helper_a0e17f3c(20)
			end
			if at <= 38 then
				helper_a0e17f3c(9)
			end
			if at <= 39 then
				helper_a0e17f3c(30)
			end
			if at <= 40 then
				helper_a0e17f3c(60)
			end
			if at <= 41 then
				helper_a19c5ee3(17)
			end
			if at <= 42 then
				helper_a0e17f3c(5)
			end
			if at <= 43 then
				helper_a0e17f3c(60)
			end
			if at <= 44 then
				helper_a0e17f3c(5)
			end
			if at <= 45 then
				helper_a0e17f3c(60)
			end
			if at <= 46 then
				helper_a0e17f3c(60)
			end
			if at <= 47 then
				helper_a0e17f3c(30)
			end
			if at <= 48 then
				helper_a0e17f3c(60)
			end
			if at <= 49 then
				helper_a0e17f3c(90)
			end
			if at <= 50 then
				helper_a0e17f3c(60)
			end
			if at <= 51 then
				helper_a0e17f3c(29)
			end
			if at <= 52 then
				helper_a0e17f3c(30)
			end
			if at <= 53 then
				helper_a0e17f3c(40)
			end
			if vm.skip_end() then
				return skip(55)
			end
			return part2()
		end
		if at <= 55 then
			helper_a0e17f3c(30)
		end
		helper_294b0()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_a0e17f3c(30)
		if vm.skipping() then
			return skip(56)
		end
		event.SetProjection(projection)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SndSeStop(var4, 4)
		event.SndSeStop(var4, 14)
		event.SndSeStop(var4, 18)
		event.SndSeStop(var4, 19)
		event.SndSeStop(var4, 25)
		event.SndSeStop(var4, 30)
		event.SndSeAllStop(4)
		if vm.wait() then
			return skip(57)
		end
		helper_294b0()
	end
	event.SetFlag(356, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	event.LoadSound(3841)
	var4 = event.SndLoadSound(3841) or var4
	event.SetFadeOut(30)
	helper_a0e17f3c(35)
	if vm.skipping() then
		return skip(5)
	end
	helper_29bc4()
	event.SetStatus(1, 0, 256, 1)
	if vm.wait() then
		return skip(6)
	end
	projection = event.GetProjection() or projection
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(21.0)
	event.SetTimeStepEnable(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "無表情")
	event.ObjsTexAnime(5, 1, "通常目パチ")
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "くるし顔")
	event.ObjsTexAnime(6, 1, "通常目パチ")
	event.ObjsTexAnime(7, 0)
	event.ObjsTexAnime(7, 1, "デフォルト顔")
	event.ObjsTexAnime(7, 1, "目パチ")
	event.FuncPointShow("", "func2", 1)
	event.FuncPointShow("", "func3", 1)
	event.FuncPointShow("", "func0", 0)
	event.FuncPointShow("", "func", 0)
	event.FuncPointShow("", "func4", 0)
	event.ObjsSetRot(11, 0.0, 1.57, 0.0)
	event.ObjsSetRot(12, 0.0, 1.57, 0.0)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.SndSePlay(var4, 4)
	event.CmrsSetPos(-3228.79, 35.27, 1184.49)
	event.CmrsSetRef(-3120.21, 64.65, 1226.19)
	event.CharaActive(1, 36)
	event.CharaActive(0, global14)
	event.CharaActive(1, global15)
	event.CharaActive(0, 34)
	event.CharaActive(1, 37)
	event.CharaActive(0, 38)
	event.ObjsSetMotion(5, "手ひろげ立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(6, "ひざまづきＬ", 4)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetPos(8, -3191.25, 25.75, 1213.17)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.ObjsSetPos(7, -3213.34, 25.75, 1386.39)
	event.ObjsSetRot(7, 0.0, 3.12, 0.0)
	event.ObjsSetPos(6, -3191.25, 25.75, 1213.17)
	event.ObjsSetRot(6, 0.0, 3.12, 0.0)
	event.ObjsSetPos(1, -3193.71, 25.75, 1113.77)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(1, 3)
	event.ObjsSetPos(5, -171.87, 401.97, -73.85)
	event.ObjsSetRot(5, 0.0, -0.96, 0.0)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, -1.2, 0.0)
	event.SetFadeIn(30)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3560010)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(1, 41)
	event.CharaActive(1, 42)
	event.CmrsSetPos(-3217.06, 43.8, 1135.37)
	event.CmrsSetRef(-3161.01, 46.88, 1099.01)
	event.SndSePlay(var4, 5)
	event.ObjsSetMotion(1, "剣おろし", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3560020)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, -3193.71, 25.75, 1113.77)
	event.ObjsAddPas(1, -3191.52, 25.75, 1171.04)
	event.ObjsStartPas(1, 1)
	event.ObjsSetMotion(1, "歩き")
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-3252.89, 52.03, 1136.53)
	event.CmrsSetRef(-3191.9, 46.88, 1186.49)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目下パチ")
	event.CmrsSetPos(-3235.05, 37.69, 1207.12)
	event.CmrsSetRef(-3196.19, 46.88, 1176.66)
	event.SndSePlay(var4, 6)
	event.ObjsSetMotion(1, "剣突きつけ", 6)
	event.ObjsNextMotion(1, "剣突きつけＬ", 4)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(var4, 6)
	event.ObjsSetMotion(1, "剣突きつけ", 6)
	event.ObjsNextMotion(1, "剣突きつけＬ", 4)
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "わらい顔")
	event.ObjsTexAnime(6, 1, "目とじ")
	event.CmrsSetPos(-3214.05, 52.19, 1179.0)
	event.CmrsSetRef(-3184.91, 48.9, 1206.85)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(var4, 7)
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "わらい顔")
	event.ObjsTexAnime(6, 1, "目とじ～目あき")
	event.ObjsTexAnime(6, 1, "わらい口～口とじ")
	event.ObjsSetMotion(6, "顔上げる", 6)
	event.ObjsNextMotion(6, "顔上げるＬ", 4)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-3240.43, 47.09, 1159.88, -3177.08, 48.9, 1166.47)
	event.CmrsAddPas(-3243.26, 47.09, 1187.11, -3179.91, 48.9, 1193.69)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(90)
	event.CmrsAddPas(-3227.95, 37.5, 1215.78, -3178.62, 48.9, 1184.83)
	event.CmrsAddPas(-3234.28, 37.5, 1205.7, -3184.95, 48.9, 1174.74)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(17)
	end
	event.SetCrossfade(30)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(90)
	event.CmrsAddPas(-3203.96, 45.24, 1194.92, -3154.63, 56.45, 1163.97)
	event.CmrsAddPas(-3207.72, 45.24, 1188.92, -3158.39, 56.45, 1157.97)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-3909.29, 148.98, 1182.03)
	event.CmrsSetRef(-3563.8, -10.58, 1141.1)
	event.SetCharaPos(47, -3756.47, -58.75, 1194.56)
	event.SetCharaRot(47, 0.0, 0.0, 0.0)
	event.CharaActive(1, 47)
	event.SetMotion(47, "ヒット", 2, -1, 1)
	event.SndSePlay(var4, 8)
	event.CmrsQuakeDelay(30)
	event.CmrsQuake(0.0, 0.3, 0.0, 120)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(19)
	end
	event.CharaActive(0, 47)
	event.CmrsSetPos(-3218.05, 58.5, 1186.27)
	event.CmrsSetRef(-3110.83, 8.26, 1127.13)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "口とじ～半口")
	event.SndSePlay(var4, 9)
	event.ObjsSetMotion(1, "え？", 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_09b5edc9(3560025, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "デフォルト顔")
	event.ObjsTexAnime(6, 1, "通常目パチ")
	event.CmrsSetPos(-3229.37, 62.21, 1210.77)
	event.CmrsSetRef(-3103.54, 8.26, 1191.57)
	event.SndSePlay(var4, 10)
	event.ObjsSetMotion(6, "なんだ？", 6)
	event.ObjsNextMotion(6, "なんだ？Ｌ", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_09b5edc9(3560030, -1)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 11)
	event.ObjsSetMotion(6, "バク転", 6)
	helper_a0e17f3c(5)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsMove(6, -3186.11, 25.75, 1357.13, 45)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-3322.33, 78.68, 1141.68)
	event.CmrsSetRef(-3203.67, 55.98, 1199.43)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-3184.57, 48.67, 1183.98)
	event.CmrsSetRef(-3185.6, 46.46, 1288.4)
	helper_a19c5ee3(6)
	if vm.skipping() then
		return skip(25)
	end
	event.SndSePlay(var4, 12)
	event.SndSePlay(var4, 13)
	event.CharaActive(1, 39)
	event.SetCharaPos(39, -3213.34, 25.75, 1386.39)
	event.SetMotion(39, "ワープ", 2, -1, 1)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(26)
	end
	event.CharaActive(1, 38)
	event.SetCharaShow(38, 1, 1, 0.025)
	event.ObjsSetMotion(7, "立ちから話しポーズ", 6)
	event.ObjsNextMotion(7, "話し", 4)
	event.CmrsSetPos(-3197.25, 55.23, 1301.14)
	event.CmrsSetRef(-3198.28, 53.02, 1405.56)
	event.SetPakuAnim(7, "通常口パク")
	helper_fa57afea(3560040)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(7, "話しポーズ待機", 4)
	event.ObjsSetMotion(6, "会話", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3560050)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3560055)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetMotion(7, "はっ！", 6)
	event.ObjsNextMotion(7, "立ち", 4)
	event.SetPakuAnim(7, "通常口パク")
	helper_fa57afea(3560060)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(31)
	end
	event.SndSeStop(var4, 4)
	event.SndSePlay(var4, 14)
	event.CharaActive(1, 34)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(90)
	event.CmrsAddPas(-2317.41, 409.93, 812.37, -2227.35, 407.72, 780.15)
	event.CmrsAddPas(-1582.49, 409.93, 549.51, -1495.25, 407.72, 518.31)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(-572.71, 409.93, 60.46)
	event.CmrsSetRef(-485.48, 407.72, 29.26)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(5, "呪文", 4)
	event.SndSePlay(var4, 15)
	event.CmrsSetPos(-215.86, 432.29, -37.91)
	event.CmrsSetRef(-143.93, 430.08, -96.45)
	event.SetPakuAnim(5, "通常口パク")
	helper_09b5edc9(3560070, -1)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(35)
	end
	event.CmrsSetPos(2634.97, 591.93, 821.31)
	event.CmrsSetRef(1909.14, 546.61, 812.29)
	event.SetScale(45, 1.5, 1.5, 1.5)
	event.SetScale(46, 1.5, 1.5, 1.5)
	event.SetScale(47, 1.5, 1.5, 1.5)
	event.SetCharaPos(45, 0.0, 480.68, 0.0)
	event.SetCharaRot(45, 0.0, 0.0, 0.0)
	event.CharaActive(1, 45)
	event.SetCharaPos(46, 0.0, 480.68, 0.0)
	event.SetCharaRot(46, 0.0, -1.2, 0.0)
	event.SetCharaPos(47, -2741.37, 499.29, 1144.49)
	event.SetCharaRot(47, 0.0, 0.0, 0.0)
	event.SetMotion(45, "発射", 6, -1, 1)
	helper_a0e17f3c(15)
	if vm.skipping() then
		return skip(36)
	end
	event.SndSePlay(var4, 16)
	helper_a0e17f3c(15)
	if vm.skipping() then
		return skip(37)
	end
	event.CharaActive(1, 46)
	event.ObjsMove(18, -2884.97, 501.86, 1101.17, 30)
	helper_a0e17f3c(20)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-1963.8, 545.73, 2572.58)
	event.CmrsSetRef(-2020.19, 543.47, 2470.6)
	helper_a0e17f3c(9)
	if vm.skipping() then
		return skip(39)
	end
	event.CharaActive(0, 46)
	event.CharaActive(1, 47)
	event.SndSePlay(var4, 17)
	event.SetMotion(47, "ヒット", 6, -1, 1)
	event.CmrsQuakeDelay(10)
	event.CmrsQuake(0.0, 10.3, 0.0, 90)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsRotation(8, 0.0, 0.0, 0.06, 60)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(41)
	end
	event.CharaActive(0, 47)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.SndSePlay(var4, 18)
	event.SndSeStop(var4, 14)
	event.CmrsSetPos(-1938.53, 42.72, 1126.84)
	event.CmrsSetRef(-1989.75, 48.9, 1098.63)
	event.ObjsSetRot(17, 0.0, 1.92, 0.0)
	event.CharaActive(1, 33)
	event.EohSetShow(14, 0)
	event.ObjsSetPos(17, -2458.92, 167.76, 852.48)
	event.SndSePlay(var4, 19)
	event.ObjsSetMotion(17, "横から縦移動", 6)
	event.ObjsNextMotion(17, "狙う", 6)
	event.ObjsNextMotion(17, "狙い立ち", 6)
	helper_a19c5ee3(17)
	if vm.skipping() then
		return skip(42)
	end
	event.SndSeStop(var4, 19)
	event.SetCharaPos(40, -2279.73, 181.5, 788.22)
	event.SetCharaRot(40, 0.0, 1.9, 0.0)
	event.SetCharaPos(43, -2279.73, 181.5, 788.22)
	event.SetCharaRot(43, 0.0, 1.9, 0.0)
	event.CharaActive(1, 40)
	event.SndSePlay(var4, 20)
	event.SetMotion(40, "発射", 6, -1, 1)
	event.ObjsSetMotion(17, "発射", 6)
	event.ObjsNextMotion(17, "狙い立ち", 6)
	event.CmrsQuake(0.0, 1.3, 0.0, 60)
	helper_a0e17f3c(5)
	if vm.skipping() then
		return skip(43)
	end
	event.CharaActive(1, 43)
	event.ObjsMove(19, -1846.06, 191.5, 633.95, 30)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(44)
	end
	event.CharaActive(0, 43)
	event.SndSePlay(var4, 20)
	event.SetMotion(40, "発射", 6, -1, 1)
	event.ObjsSetMotion(17, "発射", 6)
	event.ObjsNextMotion(17, "狙い立ち", 6)
	event.CmrsQuake(0.0, 1.3, 0.0, 60)
	helper_a0e17f3c(5)
	if vm.skipping() then
		return skip(45)
	end
	event.CharaActive(1, 43)
	event.SetCharaPos(43, -2279.73, 181.5, 788.22)
	event.SetCharaRot(43, 0.0, 1.9, 0.0)
	event.ObjsMove(19, -1846.06, 191.5, 633.95, 30)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(46)
	end
	event.CharaActive(0, 40)
	event.CharaActive(0, 43)
	event.SndSeStop(var4, 18)
	event.SndSePlay(var4, 21)
	event.SetProjection(208.9)
	event.CmrsSetPos(-2164.25, 179.07, 755.08)
	event.CmrsSetRef(-2064.38, 141.78, 719.62)
	event.CharaActive(1, 43)
	event.ObjsSetPos(19, -2064.38, 141.78, 719.62)
	event.ObjsInitPas(19)
	event.ObjsSetPasFrm(19, 90)
	event.ObjsAddPas(19, -2064.38, 141.78, 719.62)
	event.ObjsAddPas(19, 0.0, 480.68, 0.0)
	event.ObjsStartPas(19)
	event.CmrsSyncObj(16, 0.0, 0.0, 0.0, -1.23, 37.29, 105.98)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsInitPas(19)
	event.ObjsSyncObj(19, 16)
	event.CmrsReleaseObj()
	event.SetProjection(projection)
	event.CmrsSetPos(-207.36, 438.78, -44.18)
	event.CmrsSetRef(-170.18, 431.53, -74.54)
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "はっと顔")
	event.ObjsTexAnime(5, 1, "通常目パチ")
	event.ObjsSetMotion(5, "ふせぐ", 6)
	event.ObjsNextMotion(5, "ふせぐL", 4)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(-87.05, 438.78, 734.67)
	event.CmrsSetRef(-222.41, 431.53, -65.71)
	event.SetCharaPos(35, -280.28, 480.68, 182.19)
	event.SetCharaRot(35, 0.0, -1.68, 0.0)
	event.SetMotion(35, "バリア", 2, -1, 1)
	event.CharaActive(1, 35)
	event.CmrsQuakeDelay(10)
	event.CmrsQuake(0.0, 0.6, 0.0, 120)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(49)
	end
	event.CharaActive(0, 35)
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "くいしばり")
	event.ObjsTexAnime(5, 1, "通常目パチ")
	event.SndSePlay(var4, 22)
	event.CmrsSetPos(-180.2, 426.54, -51.75)
	event.CmrsSetRef(-169.56, 436.78, -92.29)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(50)
	end
	event.SndSePlay(var4, 23)
	event.SetProjection(208.9)
	event.CmrsSetPos(-2164.25, 179.07, 755.08)
	event.CmrsSetRef(-2064.38, 141.78, 719.62)
	event.ObjsSetPos(19, -2064.38, 141.78, 719.62)
	event.ObjsInitPas(19)
	event.ObjsSetPasFrm(19, 90)
	event.ObjsAddPas(19, -2064.38, 141.78, 719.62)
	event.ObjsAddPas(19, -280.28, 480.68, 182.19)
	event.ObjsStartPas(19)
	event.CmrsSyncObj(16, 0.0, 0.0, 0.0, -1.23, 37.29, 105.98)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsInitPas(19)
	event.ObjsSyncObj(19, 16)
	event.CmrsReleaseObj()
	event.SetProjection(projection)
	event.CmrsSetPos(-1229.21, -140.51, 2033.13)
	event.CmrsSetRef(-413.29, 265.59, -747.44)
	event.SetCharaPos(48, -280.28, 480.68, 182.19)
	event.SetCharaRot(48, 0.0, -1.68, 0.0)
	helper_a0e17f3c(29)
	if vm.skipping() then
		return skip(52)
	end
	event.CharaActive(0, 43)
	event.CmrsQuake(0.0, 0.6, 0.0, 30)
	event.SetMotion(48, "命中", 6, -1, 1)
	event.CharaActive(1, 48)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(53)
	end
	event.CmrsSetPos(-499.15, 603.41, 701.23)
	event.CmrsSetRef(-222.41, 431.53, -65.71)
	event.SetCrossfade(30)
	event.CharaActive(0, 48)
	event.CmrsQuake(0.0, 0.6, 0.0, 30)
	event.SetMotion(48, "命中", 6, -1, 1)
	event.CharaActive(1, 48)
	helper_a0e17f3c(40)
	if vm.skipping() then
		return skip(54)
	end
	return part2()
end

--- Helper function.
local function helper_31ee0()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global16 = 0
		global17 = 8
		global16 = 8
		global17 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global16 = 0
		global17 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global16)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global16)
		event.EohSyncChara(0, global16)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global16)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global17)
		event.LoadEquip(5, 1, 1, "info", global17, 17)
		event.LoadEquip(5, 1, 0, "info", global17, 18)
		event.LoadEquip(5, 1, 4, "info", global17)
		event.LoadEquip(5, 1, 3, "info", global17)
		event.LoadEquip(5, 1, 2, "info", global17, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global17)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global17)
		event.EohSyncChara(1, global17)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global17)
		event.CharaActive(0, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global16 = 8
		global17 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global16)
		event.LoadEquip(5, 0, 1, "info", global16, 17)
		event.LoadEquip(5, 0, 0, "info", global16, 18)
		event.LoadEquip(5, 0, 4, "info", global16)
		event.LoadEquip(5, 0, 3, "info", global16)
		event.LoadEquip(5, 0, 2, "info", global16, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global16)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global16)
		event.EohSyncChara(0, global16)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global16)
		event.CharaActive(0, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global17)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global17)
		event.EohSyncChara(1, global17)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global17)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e356/e356_crest2.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(5, 11)
	event.ObjsInit(5, 11)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "event/e300/e356/e356_lin2.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(4, 9)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "event/e300/e356/e356_guiltoni.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.EohSyncChara(6, 15)
	event.ObjsInit(6, 15)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e300/e356/e356_jamming.gltf", "info", 21)
	event.CharaActive(0, 21)
	event.EohSyncChara(7, 21)
	event.ObjsInit(7, 21)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "event/e300/e356/e356_dsmoke.gltf", "info", 22)
	event.CharaActive(0, 22)
	event.LoadChara(5, "event/e300/e356/e356_cre_kemuri.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.LoadChara(5, "event/e300/e356/e356_dwarp.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(14, 19)
	event.ObjsInit(14, 19)
	event.ObjsSyncObj(14, 14)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ３５６火の粉")
	event.EsmInitFix(5)
	event.EohSyncObj(8, "p01_battleship")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(15, "p07_d03b01")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.EohSyncObj(10, "p01_d03b01", "d03b01_12-m0")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSyncObj(11, "p02_d03b01", "d03b01_3-m0")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(12, "p02_d03b01", "d03b01_15-m0")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(13, "p01_battleship", "tbig-m0")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.LoadMes(0, 5, "event/e300/e356/e356_1.txt")
end

--- Helper function.
local function helper_31850()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global16)
		event.CharaActive(0, global17)
		event.DelExtMotion(global16)
		event.DelExtMotion(global17)
		event.DeleteChara(global17)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global17)
		event.CharaActive(0, global16)
		event.DelExtMotion(global16)
		event.DelExtMotion(global17)
		event.DeleteChara(global16)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.DeleteChara(11)
	event.DeleteChara(15)
	event.DeleteChara(21)
	event.DeleteChara(22)
	event.DeleteChara(20)
	event.DeleteChara(19)
	event.FuncPointShow("", "func", 1)
	event.FuncPointShow("", "func4", 1)
	event.EohSetShow(12, 1)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_33a8c()
	local var4: s32 = 0
	local projection: f32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 75 then
			if at <= 1 then
				helper_31ee0()
				helper_a0e17f3c(4)
			end
			if at <= 2 then
				helper_09b5edc9(3560080, -1)
			end
			if at <= 3 then
				helper_09b5edc9(3560090, -1)
			end
			if at <= 4 then
				helper_a0e17f3c(30)
			end
			if at <= 5 then
				helper_a0e17f3c(90)
			end
			if at <= 6 then
				helper_a0e17f3c(60)
			end
			if at <= 7 then
				helper_a0e17f3c(60)
			end
			if at <= 8 then
				helper_a0e17f3c(60)
			end
			if at <= 9 then
				helper_a0e17f3c(100)
			end
			if at <= 10 then
				helper_b35e85eb()
			end
			if at <= 11 then
				helper_a0e17f3c(60)
			end
			if at <= 12 then
				helper_a0e17f3c(60)
			end
			if at <= 13 then
				helper_a0e17f3c(70)
			end
			if at <= 14 then
				helper_a19c5ee3(5)
			end
			if at <= 15 then
				helper_a0e17f3c(60)
			end
			if at <= 16 then
				helper_fa57afea(3560100)
			end
			if at <= 17 then
				helper_a0e17f3c(30)
			end
			if at <= 18 then
				helper_a0e17f3c(40)
			end
			if at <= 19 then
				helper_a19c5ee3(1)
			end
			if at <= 20 then
				helper_a0e17f3c(60)
			end
			if at <= 21 then
				helper_a0e17f3c(60)
			end
			if at <= 22 then
				helper_a0e17f3c(90)
			end
			if at <= 23 then
				helper_fa57afea(3560110)
			end
			if at <= 24 then
				helper_fa57afea(3560120)
			end
			if at <= 25 then
				helper_a0e17f3c(30)
			end
			if at <= 26 then
				helper_fa57afea(3560130)
			end
			if at <= 27 then
				helper_a0e17f3c(30)
			end
			if at <= 28 then
				helper_a0e17f3c(60)
			end
			if at <= 29 then
				helper_a0e17f3c(90)
			end
			if at <= 34 then
				helper_fa57afea(3560140)
			end
			if at <= 35 then
				helper_fa57afea(3560150)
			end
			if at <= 36 then
				helper_fa57afea(3560160)
			end
			if at <= 37 then
				helper_a19c5ee3(4)
			end
			if at <= 38 then
				helper_fa57afea(3560170)
			end
			if at <= 39 then
				helper_a0e17f3c(30)
			end
			if at <= 40 then
				helper_fa57afea(3560180)
			end
			if at <= 41 then
				helper_b35e85eb()
			end
			if at <= 42 then
				helper_a0e17f3c(30)
			end
			if at <= 43 then
				helper_fa57afea(3560190)
			end
			if at <= 44 then
				helper_a0e17f3c(30)
			end
			if at <= 45 then
				helper_fa57afea(3560200)
			end
			if at <= 46 then
				helper_fa57afea(3560210)
			end
			if at <= 47 then
				helper_fa57afea(3560215)
			end
			if at <= 48 then
				helper_fa57afea(3560220)
			end
			if at <= 49 then
				helper_a0e17f3c(38)
			end
			if at <= 50 then
				helper_a0e17f3c(30)
			end
			if at <= 51 then
				helper_09b5edc9(3560230, -1)
			end
			if at <= 52 then
				helper_a0e17f3c(170)
			end
			if at <= 53 then
				helper_a0e17f3c(30)
			end
			if at <= 54 then
				helper_b35e85eb()
			end
			if at <= 59 then
				helper_a0e17f3c(60)
			end
			if at <= 60 then
				helper_b35e85eb()
			end
			if at <= 61 then
				helper_fa57afea(3560270)
			end
			if at <= 62 then
				helper_a0e17f3c(60)
			end
			if at <= 63 then
				helper_fa57afea(3560280)
			end
			if at <= 64 then
				helper_a0e17f3c(30)
			end
			if at <= 65 then
				helper_fa57afea(3560290)
			end
			if at <= 66 then
				helper_fa57afea(3560295)
			end
			if at <= 67 then
				helper_fa57afea(3560300)
			end
			if at <= 68 then
				helper_fa57afea(3560310)
			end
			if at <= 69 then
				helper_a0e17f3c(60)
			end
			if at <= 70 then
				helper_fa57afea(3560320)
			end
			if at <= 71 then
				helper_a0e17f3c(60)
			end
			if at <= 72 then
				helper_fa57afea(3560330)
			end
			if at <= 73 then
				helper_b35e85eb()
			end
			if at <= 74 then
				helper_a0e17f3c(200)
			end
			if vm.skip_end() then
				return skip(76)
			end
			return part2()
		end
		if at <= 76 then
			helper_a0e17f3c(30)
		end
		if at <= 78 then
			helper_31850()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_a0e17f3c(30)
		if vm.skipping() then
			return skip(77)
		end
		event.SetProjection(projection)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SndSeAllStop(4)
		event.SndSeAllStop(1)
		event.SoundLoadCancel()
		event.BgmLoadCancel()
		event.EsmClear()
		event.EohSetShow(9, 1)
		event.EohSetShow(15, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeStop(var4, 14)
		event.SndSeStop(var4, 18)
		event.SndSeStop(var4, 19)
		event.SndSeStop(var4, 25)
		event.SndSeStop(var4, 30)
		event.SetMotionBlur(0)
		if vm.wait() then
			return skip(78)
		end
		helper_31850()
		if vm.skipping() then
			return skip(79)
		end
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	helper_31ee0()
	event.StopBgm(0)
	helper_a0e17f3c(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(152)
	event.LoadSound(3841)
	var4 = event.SndLoadSound(3841) or var4
	event.SndSeAllStop(1)
	projection = event.GetProjection() or projection
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(21.0)
	event.SetTimeStepEnable(0)
	event.EohSetFootSoundId(1, 3)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "直撃顔")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "おこり顔")
	event.ObjsTexAnime(4, 1, "おこり目パチ")
	event.ObjsTexAnime(6, 0)
	event.ObjsTexAnime(6, 1, "デフォルト顔")
	event.ObjsTexAnime(6, 1, "通常目パチ")
	event.ObjsTexAnime(7, 0)
	event.ObjsTexAnime(7, 1, "デフォルト顔")
	event.ObjsTexAnime(7, 1, "目パチ")
	event.FuncPointShow("", "func", 0)
	event.FuncPointShow("", "func4", 0)
	event.ObjsSetRot(11, 0.0, 1.57, 0.0)
	event.ObjsSetRot(12, 0.0, 1.57, 0.0)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.EohSetShow(12, 0)
	event.ObjsSetRot(13, -0.4, 1.9, 0.0)
	event.EsmCreate("Ｅ３５６火の粉")
	event.EsmSetVect1(0.0, 60.0, 0.0)
	event.CmrsSetPos(-130.8, 38.79, 63.09)
	event.CmrsSetRef(-74.0, 16.13, 36.55)
	event.CharaActive(1, 12)
	event.CharaActive(1, global16)
	event.CharaActive(1, global17)
	event.CharaActive(1, 9)
	event.CharaActive(1, 11)
	event.CharaActive(1, 15)
	event.CharaActive(0, 21)
	event.ObjsSetMotion(4, "上見かまえ", 4)
	event.ObjsSetMotion(5, "ふせぐL", 4)
	event.ObjsSetMotion(1, "驚き", 4)
	event.ObjsSetMotion(0, "上見かまえ", 4)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetPos(8, -3191.25, 25.75, 1213.17)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.CharaActive(1, 22)
	event.SetCharaPos(22, -3714.57, 453.25, 1349.41)
	event.SetCharaRot(22, 0.0, 0.0, 0.0)
	event.SetCharaPos(19, -3191.25, 25.75, 2275.09)
	event.SetCharaRot(19, 0.0, 0.0, 0.0)
	event.ObjsSetPos(7, -2784.72, 25.75, 1175.72)
	event.ObjsSetRot(7, 0.0, 1.41, 0.0)
	event.ObjsSetPos(6, -2765.6, 25.75, 1210.21)
	event.ObjsSetRot(6, 0.0, 1.4, 0.0)
	event.ObjsSetPos(1, -2766.34, 25.75, 1080.7)
	event.ObjsSetRot(1, 0.0, 1.68, 0.0)
	event.ObjsSetPos(5, -171.87, 401.97, -73.85)
	event.ObjsSetRot(5, 0.0, -0.96, 0.0)
	event.ObjsSetPos(4, -76.99, 0.0, 21.53)
	event.ObjsSetRot(4, 0.0, -1.12, 0.0)
	event.ObjsSetPos(0, -75.67, 0.0, 49.73)
	event.ObjsSetRot(0, 0.0, -1.2, 0.0)
	event.SetCharaPos(20, -171.87, 402.97, -73.85)
	event.SetCharaRot(20, 0.0, -0.96, 0.0)
	event.SetFadeIn(30)
	event.SetPakuAnim(4, "通常口パク")
	helper_09b5edc9(3560080, -1)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "大口パク")
	helper_09b5edc9(3560090, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(5)
	end
	event.EsmClear()
	event.CharaActive(1, 20)
	event.CmrsSetPos(-184.06, 415.94, -34.92)
	event.CmrsSetRef(-164.04, 432.34, -99.26)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 20)
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "つらい顔")
	event.SndSePlay(var4, 24)
	event.CmrsSetPos(-281.06, 415.94, -39.36)
	event.CmrsSetRef(-151.02, 432.34, -81.4)
	event.ObjsSetMotion(5, "振り返る", 6)
	event.ObjsNextMotion(5, "振り返るＬ", 4)
	event.ObjsRotation(5, 0.0, 0.72, 0.0, 30)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-140.77, 480.0, -15.54)
	event.CmrsSetRef(-172.28, 437.71, -70.64)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-258.09, 457.17, -222.7)
	event.CmrsSetRef(-172.28, 437.71, -70.64)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-154.99, 437.5, -84.08, -289.74, 438.77, 31.8)
	event.CmrsAddPas(-154.99, 431.92, -84.08, -289.74, 433.19, 31.8)
	event.CmrsStartPas()
	helper_a0e17f3c(100)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "つらいわらい顔")
	helper_b35e85eb()
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "目をとじる")
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(5, "倒れる", 6)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(13)
	end
	event.PlayBgm(0)
	event.EohSetShow(9, 0)
	event.EohSetShow(15, 1)
	event.SetMotionBlur(60)
	event.ObjsSetMotion(5, "落下", 4)
	event.EohSetShadow(5, 0)
	event.CmrsSetPos(-553.51, 200.25, 54.3)
	event.CmrsSetRef(-469.06, 205.75, 43.81)
	event.SetCrossfade(60)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 150)
	event.ObjsAddPas(5, -249.12, 273.7, 22.14)
	event.ObjsAddPas(5, -249.12, 240.32, 22.14)
	event.ObjsStartPas(5)
	helper_a0e17f3c(70)
	if vm.skipping() then
		return skip(14)
	end
	event.SetCrossfade(60)
	event.CmrsSetPos(-317.2, 237.89, -76.53)
	event.CmrsSetRef(-279.42, 243.39, -22.7)
	helper_a19c5ee3(5)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotionBlur(0)
	event.EohSetShow(9, 1)
	event.EohSetShow(15, 0)
	event.SetProjection(1502.9)
	event.SndSePlay(var4, 25)
	event.CmrsSetPos(-2744.52, 54.57, 1323.71)
	event.CmrsSetRef(-2754.11, 50.78, 1201.72)
	event.ObjsSetMotion(1, "驚き", 4, -1, 1)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "驚きからギル見", 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3560100)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-3256.95, 81.8, 1278.1)
	event.CmrsSetRef(-3074.49, 50.78, 1211.03)
	event.ObjsSetPos(1, -3078.05, 25.75, 1210.56)
	event.ObjsSetRot(1, 0.0, 1.92, 0.0)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(1, -2826.26, 25.75, 1118.0, 60)
	helper_a0e17f3c(40)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsNextMotion(1, "走り飛び", 6)
	event.ObjsNextMotion(1, "走り飛びＬ", 4)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(20)
	end
	event.SndSePlay(var4, 26)
	event.CharaActive(0, global17)
	event.EohSetShadow(5, 1)
	event.EohSetFootSoundId(1, 0)
	event.ObjsSetMotion(0, "下向くL", 4)
	event.ObjsSetMotion(4, "かかえ", 4)
	event.ObjsSetMotion(5, "かかえ", 4)
	event.ObjsSetPos(4, -137.71, 0.0, 40.8)
	event.ObjsSetRot(4, 0.0, -0.64, 0.0)
	event.ObjsSetPos(0, -75.67, 0.0, 49.73)
	event.ObjsSetRot(0, 0.0, -1.8, 0.0)
	event.ObjsSetPos(5, -137.71, 0.0, 40.8)
	event.ObjsSetRot(5, 0.0, -0.64, 0.0)
	event.ObjsSetPos(1, -211.67, 0.0, 80.32)
	event.ObjsSetRot(1, 0.0, 2.04, 0.0)
	event.CmrsSetPos(189.22, 107.03, -74.97)
	event.CmrsSetRef(87.21, 74.64, -36.26)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var4, 27)
	event.ObjsSetMotion(1, "着地２", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.CharaActive(1, global17)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(22)
	end
	event.SetProjection(projection)
	event.CmrsSetPos(-4827.61, 834.34, 4724.51)
	event.CmrsSetRef(-4506.58, 801.95, 4143.46)
	event.ObjsRotation(8, 0.0, 0.0, 0.06, 90)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.CharaActive(1, 21)
	event.CmrsSetPos(-2612.44, 131.75, 1201.26)
	event.CmrsSetRef(-2814.26, 47.07, 1200.05)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3560110)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(7, "通常口パク")
	helper_fa57afea(3560120)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-2737.6, 60.99, 1210.81)
	event.CmrsSetRef(-2832.46, 47.07, 1205.56)
	event.SetPakuAnim(6, "通常口パク")
	helper_fa57afea(3560130)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 28)
	event.ObjsSetMotion(6, "ふりかえり", 6)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(28)
	end
	event.CharaActive(0, 21)
	event.CharaActive(0, 15)
	event.CharaActive(0, 22)
	event.EohSetScale(14, 2.0, 2.0, 2.0)
	event.CharaActive(1, 19)
	event.CmrsSetPos(-8070.2, 232.04, 2437.64)
	event.CmrsSetRef(-3648.73, 198.15, 1794.44)
	event.SndSePlay(var4, 29)
	event.SndSeStop(var4, 14)
	event.SndSeStop(var4, 18)
	event.SndSeStop(var4, 19)
	event.SndSeStop(var4, 25)
	event.SndSeStop(var4, 30)
	event.SetMotion(19, "消える", 2, -1, 1)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(29)
	end
	event.SetCrossfade(60)
	event.EohSetShow(8, 0)
	event.FadeOutBgm(90)
	helper_a0e17f3c(90)
	if vm.skipping() then
		return skip(30)
	end
	event.StopBgm(0)
	event.FuncPointShow("p01_battleship", "func", 0)
	event.FuncPointShow("p01_battleship", "func0", 0)
	event.FuncPointShow("p01_battleship", "func1", 0)
	event.FuncPointShow("p01_battleship", "func2", 0)
	event.FuncPointShow("p01_battleship", "func3", 0)
	event.FuncPointShow("p01_battleship", "func4", 0)
	event.FuncPointShow("p01_battleship", "func5", 0)
	event.FuncPointShow("p01_battleship", "func6", 0)
	event.FuncPointShow("p01_battleship", "bframe01", 0)
	event.FuncPointShow("p01_battleship", "bframe02", 0)
	event.FuncPointShow("p01_battleship", "bframe03", 0)
	if vm.wait() then
		return skip(31)
	end
	if vm.wait() then
		return skip(32)
	end
	if vm.wait() then
		return skip(33)
	end
	if vm.wait() then
		return skip(34)
	end
	event.LoadBgm(52)
	event.PlayBgm(0)
	event.CharaActive(0, 19)
	event.ObjsSetPos(8, -13191.25, 25.75, 1213.17)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.SndSePlay(var4, 30, 10)
	event.SetMotionBlur(0)
	event.ObjsSetPos(1, -102.8, 0.0, 11.44)
	event.ObjsSetRot(1, 0.0, -0.72, 0.0)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "かなし顔")
	event.ObjsTexAnime(4, 1, "なき目パチ")
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "くるし目とじ顔")
	event.CmrsSetPos(-151.61, 15.21, 74.52)
	event.CmrsSetRef(-132.03, 7.02, 23.84)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3560140)
	if vm.skipping() then
		return skip(35)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "目をあける")
	event.SetPakuAnim(5, "くるし口パク")
	helper_fa57afea(3560150)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(4, "ひきよせる", 2)
	event.ObjsNextMotion(4, "ゆする", 4)
	event.ObjsSetMotion(5, "ひきよせる", 2)
	event.ObjsNextMotion(5, "ゆする", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3560160)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(4)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsNextMotion(4, "ひきよせるL")
	event.ObjsNextMotion(5, "ひきよせるL")
	event.SetPakuAnim(5, "くるし口パク")
	helper_fa57afea(3560170)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetMotion(4, "ゆする")
	event.ObjsSetMotion(5, "ゆする")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "かなし顔")
	event.ObjsTexAnime(1, 1, "かなし目パチ")
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-20.51, 20.32, 55.72, -95.9, 19.0, 70.13)
	event.CmrsAddPas(-26.7, 20.32, 23.31, -102.09, 19.0, 37.72)
	event.CmrsStartPas()
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3560180)
	if vm.skipping() then
		return skip(41)
	end
	event.ResetPakuAnim()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(42)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(4, "かかえ", 4)
	event.ObjsSetMotion(5, "かかえ", 4)
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "くるし顔")
	event.ObjsTexAnime(5, 1, "くるし目パチ")
	event.CmrsSetPos(-171.94, 29.88, 48.93)
	event.CmrsSetRef(-139.58, 8.06, 46.52)
	event.SetPakuAnim(5, "くるし口パク")
	helper_fa57afea(3560190)
	if vm.skipping() then
		return skip(44)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetPos(0, -91.26, 0.0, 25.67)
	event.ObjsSetRot(0, 0.0, -1.2, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1, 1)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ショック顔")
	event.ObjsTexAnime(0, 1, "ショック目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "ショック顔")
	event.ObjsTexAnime(1, 1, "ショック目パチ")
	event.CmrsSetPos(-151.61, 15.21, 74.52)
	event.CmrsSetRef(-132.03, 7.02, 23.84)
	event.ObjsSetMotion(4, "ゆする（小）", 4)
	event.ObjsSetMotion(5, "ゆする（小）", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3560200)
	if vm.skipping() then
		return skip(46)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(4, "ひきよせるL")
	event.ObjsSetMotion(5, "ひきよせるL")
	event.SndSePlay(var4, 32)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3560210)
	if vm.skipping() then
		return skip(47)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "なき目あき～なき目とじ")
	event.ObjsSetMotion(4, "すりすり", 2)
	event.ObjsNextMotion(4, "すりすりL", 4)
	event.ObjsSetMotion(5, "すりすり", 2)
	event.ObjsNextMotion(5, "すりすりL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3560215)
	if vm.skipping() then
		return skip(48)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "なき目とじ～なき目あき")
	event.ObjsSetMotion(4, "すりすり戻り", 2)
	event.ObjsNextMotion(4, "ひきよせるL", 4)
	event.ObjsSetMotion(5, "すりすり戻り", 2)
	event.ObjsNextMotion(5, "ひきよせるL", 4)
	event.SetPakuAnim(5, "くるし口パク")
	helper_fa57afea(3560220)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(5, 0)
	event.ObjsTexAnime(5, 1, "目をとじる")
	event.ObjsSetMotion(4, "死ぬ", 2)
	event.ObjsNextMotion(4, "死ぬL", 4)
	event.ObjsSetMotion(5, "死ぬ", 2)
	event.ObjsNextMotion(5, "死ぬL", 4)
	helper_a0e17f3c(38)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsSetMotion(4, "先生？", 2)
	event.ObjsNextMotion(4, "泣く", 2)
	event.ObjsNextMotion(4, "泣くL", 4)
	event.ObjsSetMotion(5, "先生？", 2)
	event.ObjsNextMotion(5, "泣く", 2)
	event.ObjsNextMotion(5, "泣くL", 4)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "ごうきゅう目とじ")
	event.SndSePlay(var4, 33)
	event.SetPakuAnim(4, "大口パク")
	event.CmrsPrdelay(150)
	event.CmrsSetPos(-129.66, 28.98, 36.73)
	event.CmrsSetRef(-83.24, 17.19, 9.16)
	event.ObjsMotionDelay(1, 150)
	event.ObjsSetMotion(1, "顔そむけ", 6)
	event.ObjsNextMotion(1, "顔そむけL", 4)
	event.ObjsTexaDelay(1, 150)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "ショック顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsTexAnime(1, 1, "口あき～口とじ")
	helper_09b5edc9(3560230, -1)
	if vm.skipping() then
		return skip(52)
	end
	event.ResetPakuAnim()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-2715.35, 28.98, 1572.42, -83.24, 17.19, 9.16)
	event.CmrsAddPas(-4454.34, 28.98, 2605.23, -83.24, 17.19, 9.16)
	event.CmrsStartPas()
	event.FadeOutBgm(200)
	helper_a0e17f3c(170)
	if vm.skipping() then
		return skip(53)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(54)
	end
	helper_b35e85eb()
	if vm.skipping() then
		return skip(55)
	end
	event.SndSeStop(var4, 30)
	event.StopBgm(0)
	if vm.wait() then
		return skip(56)
	end
	if vm.wait() then
		return skip(57)
	end
	if vm.wait() then
		return skip(58)
	end
	if vm.wait() then
		return skip(59)
	end
	event.LoadBgm(112)
	event.PlayBgm(0)
	event.DeleteChara(9)
	event.LoadChara(5, "event/e300/e356/e356_lin3.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(4, 9)
	event.ObjsSyncObj(4, 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.ObjsSetPos(4, -137.49, 0.0, 51.6)
	event.ObjsSetRot(4, 0.0, -1.24, 0.0)
	event.ObjsSetPos(5, -137.49, 0.0, 51.6)
	event.ObjsSetRot(5, 0.0, -1.24, 0.0)
	event.CharaActive(1, 9)
	event.CharaActive(0, global16)
	event.CharaActive(0, global17)
	event.CharaActive(0, 12)
	event.ObjsSetMotion(4, "ひざまくら", 4)
	event.ObjsSetMotion(5, "ひざまくら", 4)
	event.EohSetShow(9, 0)
	event.FuncPointShow("", "func2", 0)
	event.FuncPointShow("", "func3", 0)
	event.FuncPointShow("", "func0", 1)
	event.CmrsSetPos(-27.09, 20.37, 12.51)
	event.CmrsSetRef(-106.92, 28.16, 40.78)
	event.SetFadeIn(30)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(60)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-207.92, 44.8, 103.93, -142.38, 14.02, 55.1)
	event.CmrsAddPas(-170.48, 44.8, 76.03, -142.38, 14.02, 55.1)
	event.CmrsStartPas()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(61)
	end
	event.SetPakuAnim(4, "わらい口パク")
	helper_fa57afea(3560270)
	if vm.skipping() then
		return skip(62)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(63)
	end
	event.CmrsSetPos(-27.09, 20.37, 12.51)
	event.CmrsSetRef(-106.92, 28.16, 40.78)
	event.SetPakuAnim(4, "わらい口パク")
	helper_fa57afea(3560280)
	if vm.skipping() then
		return skip(64)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(65)
	end
	event.CmrsSetPos(-132.45, 11.9, 87.83)
	event.CmrsSetRef(-142.38, 10.03, 55.1)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "目あき～かなし目とじ")
	event.ObjsSetMotion(4, "下向く", 6)
	event.ObjsNextMotion(4, "下向くL", 4)
	event.SetPakuAnim(4, "わらい口パク")
	helper_fa57afea(3560290)
	if vm.skipping() then
		return skip(66)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "わらい口パク")
	helper_fa57afea(3560295)
	if vm.skipping() then
		return skip(67)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "わらい口パク")
	helper_fa57afea(3560300)
	if vm.skipping() then
		return skip(68)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "かなし目とじ～目あき")
	event.ObjsSetMotion(4, "下向く戻り", 6)
	event.ObjsNextMotion(4, "ひざまくら", 4)
	event.SetPakuAnim(4, "わらい口パク")
	helper_fa57afea(3560310)
	if vm.skipping() then
		return skip(69)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "涙目あき～目とじ")
	event.ObjsSetMotion(4, "涙をふく", 6)
	event.ObjsNextMotion(4, "ひざまくら", 4)
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(70)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.CmrsSetPos(-27.09, 20.37, 12.51)
	event.CmrsSetRef(-106.92, 28.16, 40.78)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3560320)
	if vm.skipping() then
		return skip(71)
	end
	event.ResetPakuAnim()
	helper_a0e17f3c(60)
	if vm.skipping() then
		return skip(72)
	end
	event.CmrsSetPos(-169.91, 44.8, 75.61)
	event.CmrsSetRef(-142.38, 14.02, 55.1)
	event.CmrsMove2(-189.8, 92.55, 87.58, -142.38, 14.02, 55.1, 200, 2, 1.0)
	event.SetPakuAnim(4, "通常口パク")
	helper_fa57afea(3560330)
	if vm.skipping() then
		return skip(73)
	end
	event.ResetPakuAnim()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(74)
	end
	event.CmrsSetPos(-1140.72, -772.93, 5162.45)
	event.CmrsSetRef(-1053.47, -759.54, 4629.56)
	event.CmrsMove2(-1140.72, -772.93, 5162.45, -1053.47, -306.64, 4629.56, 200, 2, 1.0)
	event.FadeOutBgm(200)
	helper_a0e17f3c(200)
	if vm.skipping() then
		return skip(75)
	end
	event.StopBgm(0)
	return part2()
end

--- Helper function.
local function helper_10ab8()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			active_chr_no = 0
		end
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.InitSepia(5)
	event.StartSepia()
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	active_chr_no = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 or active_chr_no == 3 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			global4 = out1 or global4
			global5 = out2 or global5
			global6 = out3 or global6
		end
		do
			local _, out2, _ = event.GetCharaRot(0)
			global7 = out2 or global7
		end
		event.DngSetupMainUnit(0)
		event.SetActiveChrNo(0)
		event.SetCharaChangeMask(0, 1)
		event.SetCharaChangeMask(2, 1)
		event.SetCharaChangeMask(1, 0)
		event.SetCharaChangeMask(3, 0)
		event.SetCharaPos(0, global0, global1, global2)
		event.SetCharaRot(0, 0.0, global3, 0.0)
		event.LoadSound(3690)
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			global0 = out1 or global0
			global1 = out2 or global1
			global2 = out3 or global2
		end
		do
			local _, out2, _ = event.GetCharaRot(0)
			global3 = out2 or global3
		end
		event.DngSetupMainUnit(1)
		event.SetActiveChrNo(1)
		event.SetCharaChangeMask(0, 0)
		event.SetCharaChangeMask(2, 0)
		event.SetCharaChangeMask(1, 1)
		event.SetCharaChangeMask(3, 1)
		event.SetCharaPos(0, global4, global5, global6)
		event.SetCharaRot(0, 0.0, global7, 0.0)
		event.LoadSound(3691)
	end
	event.DngCollisionAllClr()
	event.SetMotion(0, "かまえ立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.14, 20.0)
	do
		local out1, out2, out3 = event.GetBeforeCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetBeforeCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.EndSepia()
	event.SetCrossfade(1, 1, 20)
	if vm.wait() then
		return skip(3)
	end
	event.Finish()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_108fc

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetCharaPos(0, 0.0, 0.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(1)
	end
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3cba4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(10)
	event.SetFadeOut(10)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	event.DelMonster(-1)
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	event.SetFloorInfo(stage_id, var2, 5, 2)
	if vm.wait() then
		return skip(2)
	end
	event.GotoEdit(62, 504)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_13678()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 503.
script[503] = function()
	local time: f32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_26f20()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 4 then
			helper_a0e17f3c(4)
		end
	end
	function part2()
		event.EohSyncObj(0, "p01_battleship")
		event.EohSetPos(0, -2194.9, 487.8, -474.2)
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		time = event.GetTime() or time
		event.SetKeepTime(time)
		event.SetTimeStepEnable(0)
		event.SetTime(18.0)
		if vm.wait() then
			return skip(3)
		end
		event.Initialize()
		if vm.wait() then
			return skip(4)
		end
		event.StopBgm(0)
		helper_a0e17f3c(4)
		if vm.skipping() then
			return skip(5)
		end
		event.LoadBgm(190)
		event.PlayBgm(0)
		event.LoadSound(3691)
		event.FuncPointShow("", "func0", 0)
		event.FuncPointShow("", "func2", 1)
		event.FuncPointShow("", "func3", 1)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 1 then
			event.DngSetupMainUnit(1)
			event.SetActiveChrNo(1)
		end
		event.SetCharaChangeMask(0, 0)
		event.SetCharaChangeMask(2, 0)
		event.SetBitCtrl(1, 1)
		event.SetCharaPos(0, -2195.0, 488.0, -515.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.SetCameraRef(-2195.0, 513.0, -475.0)
		event.SetCameraPos(-2195.0, 518.0, -555.0)
		event.ResetCamera(0)
		event.SndInitPort(4)
		event.LoadMonsterFile(510, 1)
		event.LoadMonsterFile(513, 0)
		event.LoadMonsterFile(602, 0)
		event.AutoSetMonster(510, -2195.0, 488.0, -435.0, 0.0, 3.14, 0.0)
		event.AutoSetMonster(602, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		event.SetStatusbarShow(1, 0.16666667)
		event.SetFadeIn(30)
		event.Finish()
	end
	helper_108fc()
	helper_1b1c4()
	if vm.skipping() then
		return skip(1)
	end
	helper_26f20()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 504.
script[504] = function()
	local keep_time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_33a8c()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.MapJump(-1, "d03b01", 503)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetFadeOut(0)
	event.StopBgm(0)
	keep_time = event.GetKeepTime() or keep_time
	event.SetTime(keep_time)
	helper_2b9f4()
	if vm.skipping() then
		return skip(1)
	end
	helper_33a8c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a0e17f3c(20)
		end
		if at <= 2 then
			helper_29dc3834(0, -1, 8, 0, 0)
		end
	end
	helper_10ab8()
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(64) or flag
	if flag == 0 then
		helper_a0e17f3c(20)
		if vm.skipping() then
			return skip(2)
		end
		event.DngPause(3, 1)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "[UNI00a1]Protege a Lin de la Llama malvada que se aproxima!")
		helper_29dc3834(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetFlag(64, 1)
		event.DngPause(3, 0)
	end
end

--- Program 520.
script[520] = function()
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_500caf86()
		end
		if at <= 2 then
			helper_ed303a24(0, 7)
			helper_f1cdfb4a(3520430, -1, 10)
		end
		if at <= 3 then
			helper_a0e17f3c(10)
		end
		if at <= 4 then
			helper_a0e17f3c(30)
		end
		if at <= 5 then
			helper_a0e17f3c(120)
		end
		if at <= 6 then
			local _ = helper_ec8c350b(0)
		end
		if at <= 7 then
			helper_a0e17f3c(30)
		end
	end
	event.Initialize()
	event.DngPause(3, 1)
	event.FadeOutBgm(30)
	event.SetLoadbgFile(
		"snd2/bgm/bg_060.sound.json",
		"textures/dungeon/image/gameover/gameover_1.json",
		"event/boss_btl_lose_1.txt"
	)
	event.SetStatusbarShow(0, 0.033333335)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_500caf86()
	if vm.skipping() then
		return skip(2)
	end
	event.StopBgm(0)
	event.LoadBgmPack(60)
	helper_ed303a24(0, 7)
	event.LoadMes(0, 5, "event/boss_btl_lose_1.txt")
	helper_f1cdfb4a(3520430, -1, 10)
	if vm.skipping() then
		return skip(3)
	end
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(4)
	end
	event.LoadMes(0, -1)
	event.PlayBgm(0)
	block = event.LoadImg_4(5, "textures/dungeon/image/gameover/gameover_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "gameover1", block)
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetUvsize(0, 0, 0, 576, 128)
	event.SpriteSetPutsize(0, 576, 128)
	event.SpriteSetPos(0, -320, 208)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsMove(0, 288, 208, 0.0, 20)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "gameover1", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 128, 576, 64)
	event.SpriteSetPutsize(1, 576, 64)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(1, 1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetColor(1, 128, 128, 128, 128, 120)
	helper_a0e17f3c(120)
	if vm.skipping() then
		return skip(6)
	end
	while true do
		if helper_ec8c350b(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(7)
			end
		end
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(8)
	end
	event.StopBgm(0)
	event.SetExitFlag(1)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local active_chr_no: s32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7a92069b(0, 8530110)
		end
		if at <= 2 then
			helper_82700276(0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 or active_chr_no == 3 then
		value = event.GetRandInt(100) or value
		if vm.imod(value, 2) == 0 then
			helper_7a92069b(0, 8530100)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_7a92069b(0, 8530110)
			if vm.skipping() then
				return skip(2)
			end
		end
	else
		helper_82700276(0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 13560.
script[13560] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_33a8c()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.MapJump(-1, "d03b01", 503)
		if vm.wait() then
			return skip(3)
		end
	end
	event.StopBgm(0)
	helper_2b9f4()
	if vm.skipping() then
		return skip(1)
	end
	helper_33a8c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 23030.
script[23030] = function()
	local argc: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_108fc()
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.EohSyncObj(0, "p06_d03b01")
	event.EohSetShow(0, 1)
	event.SetTime(17.5)
	event.SetTimeStepEnable(0)
	event.SetCharaMaxhp(0, 240)
	event.SetCharaMaxhp(1, 96)
	event.SetCharaDefence(0, 94)
	event.SetCharaDefence(1, 28)
	argc = event.GetItemNum(270) or argc
	if argc < 20 then
		event.AddItem(270, vm.i32(20 - argc))
	end
	event.AddItem(20)
	event.SetCharaEquip(0, 20)
	event.AddItem(33)
	event.SetCharaEquip(0, 33)
	event.AddItem(54)
	event.SetCharaEquip(1, 54)
	event.AddItem(104)
	event.SetCharaEquip(1, 104)
	event.FuncPointShow("", "func0", 0)
	event.FuncPointShow("", "func2", 1)
	event.FuncPointShow("", "func3", 1)
	event.LoadBgm(190)
	event.PlayBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 1 then
		event.DngSetupMainUnit(1)
		event.SetActiveChrNo(1)
	end
	event.SetCharaPos(0, -2195.0, 488.0, -515.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetCameraRef(-2195.0, 513.0, -475.0)
	event.SetCameraPos(-2195.0, 518.0, -555.0)
	event.ResetCamera(0)
	event.LoadMonsterFile(510, 1)
	event.LoadMonsterFile(513, 0)
	event.LoadMonsterFile(602, 0)
	event.AutoSetMonster(510, -2195.0, 488.0, -435.0, 0.0, 3.14, 0.0)
	event.AutoSetMonster(602, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.SetStatusbarShow(1, 0.16666667)
	event.SetCharaChangeMask(0, 0)
	event.SetCharaChangeMask(2, 0)
	event.SetBitCtrl(1, 1)
	event.SetFadeIn(30)
	event.Finish()
end

return script
