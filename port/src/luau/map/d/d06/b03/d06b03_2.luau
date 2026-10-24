--!strict
-- map/d/d06/b03/d06b03_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_1f9a3afd = require("@lib/event/helper_1f9a3afd")
local helper_43975909 = require("@lib/event/helper_43975909")
local helper_8a57ebd6 = require("@lib/event/helper_8a57ebd6")
local helper_8aedfd4b = require("@lib/event/helper_8aedfd4b")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_acccbf55 = require("@lib/event/helper_acccbf55")
local helper_baf4fdf4 = require("@lib/event/helper_baf4fdf4")
local helper_c3e72b73 = require("@lib/event/helper_c3e72b73")
local helper_ffb2ea5d = require("@lib/event/helper_ffb2ea5d")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_19e14()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		active_chr_no = 0
		active_chr_no = 1
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
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
		active_chr_no = 1
	end
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 17)
		event.LoadEquip(5, 1, 0, "info", global1, 18)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 13)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 1, "info", global0, 17)
		event.LoadEquip(5, 0, 0, "info", global0, 18)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncObj(6, "p06_d06b03-0")
	event.EohSetShow(6, 0)
	event.CharaActive(1, 17)
	event.CharaActive(1, 18)
	event.LoadMes(0, 5, "event/e700/e732/e732_1.txt")
end

--- Helper function.
local function helper_19968()
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
		event.DeleteChara(13)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(13)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.EohSetShow(6, 1)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1ae30()
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 54 then
			if at <= 1 then
				helper_19e14()
				helper_aafd6a80(15)
			end
			if at <= 2 then
				helper_184013af()
			end
			if at <= 3 then
				helper_aafd6a80(30)
			end
			if at <= 4 then
				helper_1f9a3afd(7320210, -1)
			end
			if at <= 5 then
				helper_aafd6a80(30)
			end
			if at <= 6 then
				helper_1f9a3afd(7320215, -1)
			end
			if at <= 7 then
				helper_aafd6a80(30)
			end
			if at <= 8 then
				helper_1f9a3afd(7320220, -1)
			end
			if at <= 9 then
				helper_aafd6a80(30)
			end
			if at <= 10 then
				helper_1f9a3afd(7320230, -1)
			end
			if at <= 11 then
				helper_aafd6a80(30)
			end
			if at <= 12 then
				helper_1f9a3afd(7320240, -1)
			end
			if at <= 13 then
				helper_aafd6a80(30)
			end
			if at <= 14 then
				helper_1f9a3afd(7320250, -1)
			end
			if at <= 15 then
				helper_8f31f334(0)
			end
			if at <= 16 then
				helper_aafd6a80(30)
			end
			if at <= 17 then
				helper_1f9a3afd(7320255, -1)
			end
			if at <= 18 then
				helper_aafd6a80(15)
			end
			if at <= 19 then
				helper_1f9a3afd(7320260, -1)
			end
			if at <= 20 then
				helper_8f31f334(0)
			end
			if at <= 21 then
				helper_8f31f334(1)
			end
			if at <= 22 then
				helper_1f9a3afd(7320270, -1)
			end
			if at <= 23 then
				helper_8f31f334(0)
			end
			if at <= 24 then
				helper_aafd6a80(30)
			end
			if at <= 25 then
				helper_1f9a3afd(7320280, -1)
			end
			if at <= 26 then
				helper_aafd6a80(30)
			end
			if at <= 27 then
				helper_1f9a3afd(7320285, -1)
			end
			if at <= 28 then
				helper_aafd6a80(30)
			end
			if at <= 29 then
				helper_1f9a3afd(7320290, -1)
			end
			if at <= 30 then
				helper_aafd6a80(30)
			end
			if at <= 31 then
				helper_1f9a3afd(7320295, -1)
			end
			if at <= 32 then
				helper_aafd6a80(30)
			end
			if at <= 33 then
				helper_1f9a3afd(7320300, -1)
			end
			if at <= 34 then
				helper_aafd6a80(30)
			end
			if at <= 35 then
				helper_1f9a3afd(7320310, -1)
			end
			if at <= 36 then
				helper_184013af()
			end
			if at <= 37 then
				helper_1f9a3afd(7320320, -1)
			end
			if at <= 38 then
				helper_aafd6a80(30)
			end
			if at <= 39 then
				helper_1f9a3afd(7320330, -1)
			end
			if at <= 40 then
				helper_aafd6a80(30)
			end
			if at <= 41 then
				helper_1f9a3afd(7320340, -1)
			end
			if at <= 42 then
				helper_aafd6a80(30)
			end
			if at <= 43 then
				helper_1f9a3afd(7320350, -1)
			end
			if at <= 44 then
				helper_aafd6a80(30)
			end
			if at <= 45 then
				helper_1f9a3afd(7320360, -1)
			end
			if at <= 46 then
				helper_184013af()
			end
			if at <= 47 then
				helper_aafd6a80(30)
			end
			if at <= 48 then
				helper_1f9a3afd(7320370, -1)
			end
			if at <= 49 then
				helper_8f31f334(0)
			end
			if at <= 50 then
				helper_1f9a3afd(7320380, -1)
			end
			if at <= 51 then
				helper_8f31f334(0)
			end
			if at <= 52 then
				helper_aafd6a80(180)
			end
			if at <= 53 then
				helper_aafd6a80(60)
			end
			if vm.skip_end() then
				return skip(55)
			end
			return part2()
		end
		if at <= 55 then
			helper_19968()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(projection)
		helper_19968()
		if vm.skipping() then
			return skip(56)
		end
	end
	event.SetFlag(732, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(53)
	event.PlayBgm(0)
	event.LoadSound(7841)
	helper_19e14()
	projection = event.GetProjection() or projection
	event.InitDramaScene()
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsSetPos(281.98, 20.1, 298.37)
	event.CmrsSetRef(1436.08, 1324.63, 1446.43)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetPos(0, 457.63, 0.0, 460.14)
	event.ObjsSetRot(0, 0.0, 0.72, 0.0)
	event.ObjsSetPos(1, 443.3, 0.0, 472.44)
	event.ObjsSetRot(1, 0.0, 0.72, 0.0)
	event.SetFadeIn(30)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(281.98, 20.1, 298.37, 1436.08, 1324.63, 1446.43)
	event.CmrsAddPas(281.98, 20.1, 298.37, 1436.08, 215.39, 1446.43)
	event.CmrsStartPas()
	helper_184013af()
	if vm.skipping() then
		return skip(3)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(520.35, 27.62, 447.72)
	event.CmrsSetRef(443.3, 23.28, 472.44)
	event.SetPakuAnim(1, "通常口パク")
	helper_1f9a3afd(7320210, -1)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1f9a3afd(7320215, -1)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1f9a3afd(7320220, -1)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(422.7, -0.4, 438.35)
	event.CmrsSetRef(1436.08, 1232.78, 1446.43)
	event.SetPakuAnim(0, "通常口パク")
	helper_1f9a3afd(7320230, -1)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1f9a3afd(7320240, -1)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "上→右", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1f9a3afd(7320250, -1)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(16)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(17)
	end
	event.SetProjection(projection)
	event.CmrsSetPos(520.35, 27.62, 447.72)
	event.CmrsSetRef(443.3, 23.28, 472.44)
	event.SetPakuAnim(0, "通常口パク")
	helper_1f9a3afd(7320255, -1)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(1, "上から左", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "詩人ね", 6)
	event.ObjsNextMotion(1, "詩人ねL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_1f9a3afd(7320260, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(21)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "前向き～下向き")
	event.ObjsSetMotion(0, "そうかな", 6)
	event.ObjsNextMotion(0, "そうかなL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1f9a3afd(7320270, -1)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(25)
	end
	event.SetProjection(projection)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.CmrsSetPos(281.98, 20.1, 298.37)
	event.CmrsSetRef(1436.08, 215.39, 1446.43)
	helper_1f9a3afd(7320280, -1)
	if vm.skipping() then
		return skip(26)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(27)
	end
	helper_1f9a3afd(7320285, -1)
	if vm.skipping() then
		return skip(28)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(29)
	end
	helper_1f9a3afd(7320290, -1)
	if vm.skipping() then
		return skip(30)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(31)
	end
	helper_1f9a3afd(7320295, -1)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsMove2(281.98, 20.1, 298.37, 1436.08, 1963.82, 1446.43, 300, 0, 1.0)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(33)
	end
	helper_1f9a3afd(7320300, -1)
	if vm.skipping() then
		return skip(34)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(35)
	end
	helper_1f9a3afd(7320310, -1)
	if vm.skipping() then
		return skip(36)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(37)
	end
	helper_1f9a3afd(7320320, -1)
	if vm.skipping() then
		return skip(38)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(39)
	end
	helper_1f9a3afd(7320330, -1)
	if vm.skipping() then
		return skip(40)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CmrsSetPos(539.13, 94.76, 524.34)
	event.CmrsSetRef(457.63, 10.5, 460.14)
	event.CmrsMove2(484.6, 41.24, 479.15, 471.35, 30.37, 469.8, 300, 2, 1.0)
	event.SetCrossfade(30)
	helper_1f9a3afd(7320340, -1)
	if vm.skipping() then
		return skip(42)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(43)
	end
	helper_1f9a3afd(7320350, -1)
	if vm.skipping() then
		return skip(44)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(45)
	end
	helper_1f9a3afd(7320360, -1)
	if vm.skipping() then
		return skip(46)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(47)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsSetMotion(0, "帽子取る", 6)
	event.ObjsNextMotion(0, "帽子取るL", 4)
	helper_1f9a3afd(7320370, -1)
	if vm.skipping() then
		return skip(49)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsSetMotion(0, "ぶるぶる", 6)
	event.ObjsNextMotion(0, "帽子取るL", 4)
	helper_1f9a3afd(7320380, -1)
	if vm.skipping() then
		return skip(51)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(52)
	end
	event.SetProjection(182.9)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(240)
	event.CmrsAddPas(422.7, 30.65, 438.35, 1436.08, 349.8, 1446.43)
	event.CmrsAddPas(353.73, 30.65, 369.74, 1436.08, 349.8, 1446.43)
	event.CmrsStartPas()
	helper_aafd6a80(180)
	if vm.skipping() then
		return skip(53)
	end
	event.FadeOutBgm(60)
	event.SetFadeOut(60)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(54)
	end
	event.StopBgm(0)
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	flag = event.GetFlag(728) or flag
	if flag == 1 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 2 then
			event.DngSetupMainUnit(0)
		end
		if active_chr_no == 3 then
			event.DngSetupMainUnit(1)
		end
		event.SetStatusbarShow(0, 1.0)
		helper_ffb2ea5d()
		if vm.skipping() then
			return skip(1)
		end
		event.SetStatusbarShow(1, 1.0)
		event.LoadMonsterFile(621, 1)
		event.LoadMonsterFile(622, 0)
		event.AutoSetMonster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		event.AutoSetMonster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
		event.Stopwatch(3, 350, 370, 1)
		event.Stopwatch(2, 18000)
		event.Stopwatch_1(0)
	end
	event.SetCharaPos(0, 0.0, 0.0, -400.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -400.0)
	event.SetCameraPos(0.0, 40.0, -520.0)
	event.ResetCamera(0)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_baf4fdf4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local active_chr_no_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print(">>>>>>>>>>>>>>>>>RUN 500\n")
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.SetCharaCondition(0, 8, 1)
	end
	if active_chr_no == 1 then
		event.SetCharaCondition(1, 8, 1)
	end
	event.DelMonster(-1)
	event.SetFloorInfo(5, 27, 5, 2)
	active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
	if active_chr_no_2 == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no_2 == 3 then
		event.DngSetupMainUnit(1)
	end
	event.GotoEdit(180, 500)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1ae30()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(0, 10)
	if vm.wait() then
		return skip(2)
	end
	event.MapJump(-1, "s66", 520)
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetStatusbarShow(0, 1.0)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	helper_43975909()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	if vm.wait() then
		return skip(2)
	end
	event.LoadDungeonMapFile("d06b02")
	event.LoadScript("d06b02/d06b02.stb", 100)
end

--- Program 1200.
script[1200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8a57ebd6(0, 8570070)
			end
			return
		end
	end
	flag = event.GetFlag(728) or flag
	flag_2 = event.GetFlag(732) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_8a57ebd6(0, 8570060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_8a57ebd6(0, 8570070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_c3e72b73(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 1201.
script[1201] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local boss_map: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_aafd6a80(30)
			end
			if at <= 2 then
				helper_8aedfd4b()
			end
			if at <= 3 then
				helper_aafd6a80(30)
			end
			if at <= 4 then
				helper_aafd6a80(30)
			end
			if at <= 5 then
				helper_aafd6a80(120)
			end
			if at <= 6 then
				local _ = helper_acccbf55(0)
			end
			if at <= 7 then
				debug_flag = 0
				helper_aafd6a80(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.DngPause(15, 1)
	var0 = 0
	event.Initialize()
	var1 = event.SndLoadSound(8, "snd2/sp/sp_052.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.DngPause(16384, 1)
	event.SndSePlay(var1, 0)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(0, 128, 128, 128, 128, 90)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(1)
	end
	event.GetActiveBgmStatus(-1)
	var2 = event.GetEventInfoSndid(4) or var2
	argc = event.GetSeStatus(var2, 0) or argc
	battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
	event.SndSeStop(var2, 0)
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_8aedfd4b()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	event.PlayBgm(0)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 0) or block
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "gameover1", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 576, 128)
	event.SpriteSetPutsize(1, 576, 128)
	event.SpriteSetPos(1, -320, 208)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(1, 1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsMove(1, 288, 208, 0.0, 20)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "gameover1", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 128, 576, 64)
	event.SpriteSetPutsize(2, 576, 64)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 1)
	event.EohSyncSprite(2, 2)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetColor(2, 128, 128, 128, 128, 120)
	helper_aafd6a80(120)
	if vm.skipping() then
		return skip(6)
	end
	while true do
		if helper_acccbf55(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(7)
			end
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.ActchrSetDefMotion(0, 4)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(8)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(0)
		if var0 == 1 then
			event.AddHpRate(1.0, 0)
			event.AddWhp(0, 999)
			event.AddWhp(1, 999)
			event.DngRunEvent(-1)
			event.DelMonster(-1)
			event.DngPause(1, 0)
			event.Finish()
			return 1
		else
			event.SetExitFlag(1)
			event.Finish()
			return 0
		end
	end
	event.StopBgm(0)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(9)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(0)
	boss_map = event.DngCheckBossMap() or boss_map
	if boss_map ~= 1 then
		if argc == 1 then
			event.SndSePlay(var2, 0)
			event.SndSetSeVol(var2, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(30)
	end
	event.DngPause(16385, 0)
	event.Finish()
	return 0
end

--- Program 27070.
script[27070] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_baf4fdf4()
	if vm.skipping() then
		return skip(1)
	end
end

return script
