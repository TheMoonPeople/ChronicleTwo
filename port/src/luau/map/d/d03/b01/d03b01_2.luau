--!strict
-- map/d/d03/b01/d03b01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_161be1ae = require("@lib/event/helper_161be1ae")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_2ad1600a = require("@lib/event/helper_2ad1600a")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_6f70f976 = require("@lib/event/helper_6f70f976")
local helper_7b9ebd8b = require("@lib/event/helper_7b9ebd8b")
local helper_a26e53e3 = require("@lib/event/helper_a26e53e3")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_daa12212 = require("@lib/event/helper_daa12212")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Helper function.
local function helper_19744()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 1858.52, -189.52, 1308.84)
	event.ObjsSetRot(0, 0.0, -2.22, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(1910.24, -159.5, 1350.91)
	event.CmrsSetRef(1816.64, -159.5, 1274.78)
	event.ObjsMove(0, 1816.64, -189.5, 1274.78, 60)
	event.SetFadeIn(30)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSetFootSoundId(0, -1)
	event.ResetCamera(0)
	event.Finish()
end

--- Helper function.
local function helper_131b0()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(30)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 0)
	event.SetFadeIn(30)
	event.MesMake_2(0, "Ｅ３５６　～ギルトーニ撃退・クレストとの別れ～(つづき)")
	helper_daa12212(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Finish()
end

--- Helper function.
local function helper_1660c()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadEquip(5, 1, 1, "info", global3, 17)
		event.LoadEquip(5, 1, 0, "info", global3, 18)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global2 = 8
		global3 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global2)
		event.LoadEquip(5, 0, 1, "info", global2, 17)
		event.LoadEquip(5, 0, 0, "info", global2, 18)
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e356/e356_lin.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSetShow(9, 0)
	event.LoadMes(0, 5, "event/e300/e356/e356_1.txt")
end

--- Helper function.
local function helper_16100()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global2)
		event.CharaActive(0, global3)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global3)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global3)
		event.CharaActive(0, global2)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global2)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.SetStatus(1, 0, 256, 0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetShow(9, 0)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

--- Helper function.
local function helper_177a4()
	local var4: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 1 then
				helper_42c67f56(3560340)
			end
			if at <= 2 then
				helper_c1c32f84(60)
			end
			if at <= 3 then
				helper_42c67f56(3560350)
			end
			if at <= 4 then
				helper_42c67f56(3560360)
			end
			if at <= 5 then
				helper_2386f745(2)
			end
			if at <= 6 then
				helper_e5dca676()
			end
			if at <= 7 then
				helper_42c67f56(3560370)
			end
			if at <= 8 then
				helper_e5dca676()
			end
			if at <= 9 then
				helper_42c67f56(3560380)
			end
			if at <= 10 then
				helper_42c67f56(3560385)
			end
			if at <= 11 then
				helper_42c67f56(3560390)
			end
			if at <= 12 then
				helper_e5dca676()
			end
			if at <= 13 then
				helper_07cf3e45(3560400, -1)
			end
			if at <= 14 then
				helper_c1c32f84(30)
			end
			if at <= 15 then
				helper_42c67f56(3560410)
			end
			if at <= 16 then
				helper_42c67f56(3560420)
			end
			if at <= 17 then
				helper_42c67f56(3560430)
			end
			if at <= 18 then
				helper_42c67f56(3560440)
			end
			if at <= 19 then
				helper_c1c32f84(60)
			end
			if at <= 20 then
				helper_c1c32f84(170)
			end
			if vm.skip_end() then
				return skip(22)
			end
			return part2()
		end
		if at <= 22 then
			helper_c1c32f84(30)
		end
		helper_16100()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_c1c32f84(30)
		if vm.skipping() then
			return skip(23)
		end
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SndSeAllStop(4)
		event.BgmLoadCancel()
		if vm.wait() then
			return skip(24)
		end
		helper_16100()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	event.LoadSound(3847)
	var4 = event.SndLoadSound(3847) or var4
	helper_1660c()
	event.SetStatus(1, 0, 256, 1)
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(21.0)
	event.SetTimeStepEnable(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "半口")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.CharaActive(1, 9)
	event.ObjsSetPos(2, 543.2, 144.04, -840.61)
	event.ObjsSetRot(2, 0.0, 1.17, 0.0)
	event.ObjsSetPos(1, 569.2, 139.28, -817.83)
	event.ObjsSetRot(1, 0.0, -2.4, 0.0)
	event.ObjsSetPos(0, 574.57, 140.74, -836.69)
	event.ObjsSetRot(0, 0.0, -1.64, 0.0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(698.5, 198.36, -687.33, 415.41, 488.3, -904.7)
	event.CmrsAddPas(698.5, 198.36, -687.33, 415.41, 183.45, -904.7)
	event.CmrsStartPas()
	event.SetFadeIn(30)
	helper_c1c32f84(230)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(515.1, 182.78, -800.37)
	event.CmrsSetRef(557.38, 155.79, -834.03)
	event.ObjsSetMotion(0, "下向く", 6)
	event.ObjsNextMotion(0, "下向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(3560340)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "顔そむけ", 6)
	event.ObjsNextMotion(1, "顔そむけＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(3560350)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.LoadBgm(59)
	event.PlayBgm(0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(580.92, 168.28, -803.2, 557.45, 170.23, -863.66)
	event.CmrsAddPas(561.82, 168.28, -795.79, 538.36, 170.23, -856.24)
	event.CmrsStartPas()
	event.ObjsSetMotion(2, "ううん", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_42c67f56(3560360)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_2386f745(2)
	if vm.skipping() then
		return skip(6)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(531.29, 159.38, -832.46, 583.97, 163.32, -843.63)
	event.CmrsAddPas(535.18, 159.38, -814.11, 587.86, 163.32, -825.29)
	event.CmrsStartPas()
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(3560370)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_e5dca676()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(501.31, 169.51, -797.49)
	event.CmrsSetRef(551.47, 171.45, -833.25)
	event.SndSePlay(var4, 34)
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_42c67f56(3560380)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "上向く", 6)
	event.ObjsNextMotion(2, "上向くL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_42c67f56(3560385)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(521.48, 197.33, -852.11, 539.71, 166.13, -844.52)
	event.CmrsAddPas(511.07, 215.78, -856.44, 539.71, 166.13, -844.52)
	event.CmrsStartPas()
	event.SetPakuAnim(4, "通常口パク")
	helper_42c67f56(3560390)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_e5dca676()
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(501.31, 169.51, -797.49)
	event.CmrsSetRef(551.47, 171.45, -833.25)
	event.SetPakuAnim(1, "通常口パク")
	helper_07cf3e45(3560400, -1)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 35)
	event.ObjsSetMotion(2, "向きかえる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(4, "通常口パク")
	helper_42c67f56(3560410)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "通常口パク")
	helper_42c67f56(3560420)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 36)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(3560430)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(3560440)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(698.5, 198.36, -687.33, 415.41, 183.45, -904.7)
	event.CmrsAddPas(698.5, 198.36, -687.33, 415.41, 488.3, -904.7)
	event.CmrsStartPas()
	helper_c1c32f84(170)
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

--- Helper function.
local function helper_138ec()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 8
		global0 = 8
		global1 = 0
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
		global0 = 0
		global1 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 17)
		event.LoadEquip(5, 1, 0, "info", global1, 18)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 1, "info", global0, 17)
		event.LoadEquip(5, 0, 0, "info", global0, 18)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e352/e352_lin.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSetShow(9, 1)
	event.LoadMes(0, 5, "event/e300/e352/e352_1.txt")
end

--- Helper function.
local function helper_133a8()
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
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetShow(9, 0)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
	event.LoadDungeonMapFile("d03b02")
	event.LoadScript("d03b02/d03b02.stb", 503)
end

--- Helper function.
local function helper_14a84()
	local var4: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 4 then
				helper_138ec()
				helper_c1c32f84(230)
			end
			if at <= 5 then
				helper_e5dca676()
			end
			if at <= 6 then
				helper_42c67f56(3520170)
			end
			if at <= 7 then
				helper_2386f745(1)
			end
			if at <= 8 then
				helper_2386f745(0)
			end
			if at <= 9 then
				helper_42c67f56(3520180)
			end
			if at <= 10 then
				helper_2386f745(0)
			end
			if at <= 11 then
				helper_2386f745(0)
			end
			if at <= 12 then
				helper_2386f745(1)
			end
			if at <= 13 then
				helper_e5dca676()
			end
			if at <= 14 then
				helper_e5dca676()
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
		if at <= 16 then
			helper_c1c32f84(30)
		end
		if at <= 18 then
			helper_133a8()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_c1c32f84(30)
		if vm.skipping() then
			return skip(17)
		end
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SndSeAllStop(4)
		if vm.wait() then
			return skip(18)
		end
		event.SoundLoadCancel()
		event.BgmLoadCancel()
		helper_133a8()
		if vm.skipping() then
			return skip(19)
		end
	end
	event.SetFlag(352, 1)
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
	event.LoadSound(3836)
	var4 = event.SndLoadSound(3836) or var4
	helper_138ec()
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(18.0)
	event.SetTimeStepEnable(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "半口")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "上見立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 9)
	event.CmrsSetPos(752.46, 293.85, -635.82)
	event.CmrsSetRef(463.46, 169.14, -865.91)
	event.ObjsSetPos(2, 543.2, 144.04, -840.61)
	event.ObjsSetRot(2, 0.0, -1.99, 0.0)
	event.ObjsSetPos(0, 553.04, 141.0, -816.53)
	event.ObjsSetRot(0, 0.0, -2.4, 0.0)
	event.ObjsSetPos(1, 564.98, 142.65, -851.46)
	event.ObjsSetRot(1, 0.0, -1.64, 0.0)
	event.SndSePlay(var4, 0)
	event.SetFadeIn(30)
	helper_c1c32f84(230)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(485.46, 185.48, -900.58)
	event.CmrsSetRef(556.75, 169.14, -889.42)
	event.CmrsMove2(477.74, 185.48, -851.26, 549.03, 169.14, -840.1, 120, 2, 1.0)
	helper_e5dca676()
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSeDelay(1, 60)
	event.ObjsSePlay(1, var4, 1)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くＬ", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(3520170)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_2386f745(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "右向くうなづき", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(3520180)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_2386f745(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "右向く戻り", 6)
	event.ObjsSetMotion(1, "左向く戻り", 6)
	event.ObjsRotation(0, 0.0, -2.04, 0.0, 10)
	event.ObjsRotation(1, 0.0, -2.0, 0.0, 10)
	event.ObjsSetMotion(0, "走り")
	event.ObjsSetMotion(1, "走り", 0, -1.0, 1)
	event.ObjsMove(0, 492.39, 147.92, -843.54, 40, 1)
	event.ObjsMove(1, 498.64, 148.11, -878.52, 40, 1)
	helper_2386f745(0)
	if vm.skipping() then
		return skip(12)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsMove(516.37, 181.42, -848.28, 565.24, 159.44, -832.68, 120)
	helper_e5dca676()
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(802.37, 193.9, -653.74)
	event.CmrsSetRef(562.44, 177.39, -814.42)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(802.37, 193.9, -653.74, 562.44, 177.39, -814.42)
	event.CmrsAddPas(802.37, 323.65, -653.74, 562.44, 307.14, -814.42)
	event.CmrsStartPas()
	event.ObjsMove(0, 315.33, 250.34, -928.08, 150, 1)
	event.ObjsMove(1, 324.09, 250.34, -964.29, 150, 1)
	helper_e5dca676()
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

--- Helper function.
local function helper_19b64()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_daa12212(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				helper_c1c32f84(10)
			end
			return 0
		end
		if at <= 6 then
			if at <= 4 then
				helper_c1c32f84(30)
			end
			if at <= 5 then
				helper_c1c32f84(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_daa12212(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_daa12212(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetFadeOut(10)
		helper_c1c32f84(10)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaPos(0, 1804.36, -189.51, 1279.76)
		event.SetCharaRot(0, 0.0, -2.47, 0.0)
		event.SetCameraPos(1889.79, -158.65, 1386.92)
		event.SetCameraRef(1804.36, -159.51, 1279.76)
		event.ResetCamera(0)
		event.SetFadeIn(10)
		event.Finish()
		return 0
	end
	var1 = helper_a26e53e3(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.CmrsSetPos(1776.49, -106.69, 1400.79)
		event.CmrsSetRef(1951.33, -163.61, 1351.42)
		event.ObjsSetPos(0, 1943.88, -189.72, 1357.17)
		event.ObjsSetRot(0, 0.0, 1.21, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, 1943.88, -189.72, 1357.17)
		event.ObjsAddPas(0, 2022.78, -189.88, 1386.95)
		event.ObjsAddPas(0, 2104.45, -195.47, 1399.2)
		event.ObjsAddPas(0, 2155.72, -202.4, 1401.26)
		event.ObjsStartPas(0)
		helper_c1c32f84(30)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_c1c32f84(30)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, -1)
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(-2.14)) * 30.0) + var2)
		var6 = var3
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(-2.14)) * 30.0) + var4)
		event.ObjsMove(0, var5, var6, var7, 30, 1)
		event.ObjsReference(0, var5, var6, var7, 10)
		event.ObjsSetMotion(0, "歩き")
		var8 = 0
		while var8 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			var3 = vm.f32(var3 + 30.0)
			event.SetCameraRef(var2, var3, var4)
			var8 = var8 + 1
			if vm.wait() then
				return skip(7)
			end
		end
		event.EohSetFootSoundId(0, -1)
		event.ResetCamera(0)
		event.Finish()
	end
	return 0
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_161be1ae

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_161be1ae()
	helper_19744()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6f70f976(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_6f70f976(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 500.
-- Defined empty, so the engine runs this instead of its default.
script[500] = function() end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_131b0()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoEdit(1, 502)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7b9ebd8b()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	event.FuncPointShow("", "e348", 0)
	helper_52115bbf()
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_7b9ebd8b()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_177a4()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g02", 502)
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_14a84()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_19b64()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.LoadScript("d03/d03.stb", 1000)
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2ad1600a(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13480.
script[13480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7b9ebd8b()
	if vm.skipping() then
		return skip(1)
	end
end

return script
