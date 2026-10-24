--!strict
-- map/f/f03/i03/f03i0301_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_366d50dc = require("@lib/event/helper_366d50dc")
local helper_4896c0c7 = require("@lib/event/helper_4896c0c7")
local helper_4a2354f0 = require("@lib/event/helper_4a2354f0")
local helper_51491a96 = require("@lib/event/helper_51491a96")
local helper_5cfcf598 = require("@lib/event/helper_5cfcf598")
local helper_6e156310 = require("@lib/event/helper_6e156310")
local helper_74c7bd44 = require("@lib/event/helper_74c7bd44")
local helper_ab9c465c = require("@lib/event/helper_ab9c465c")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_c2754f21 = require("@lib/event/helper_c2754f21")
local helper_cee01349 = require("@lib/event/helper_cee01349")
local helper_daeaeed0 = require("@lib/event/helper_daeaeed0")

--- Helper function.
local function helper_1d788()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_4896c0c7(4140010)
			end
			if at <= 2 then
				helper_4896c0c7(4140020)
			end
			if at <= 3 then
				helper_23bda4ba(0)
			end
			if at <= 4 then
				helper_4896c0c7(4140030)
			end
			if at <= 5 then
				helper_23bda4ba(1)
			end
			if at <= 6 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_ab9c465c(-92.0, 0.0, 117.0, vm.f32(0.59))
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
		helper_ab9c465c(-92.0, 0.0, 117.0, vm.f32(0.59))
		event.ResetCamera(1, 3.14, 10)
		event.SetFadeIn(30)
	end
	event.SetCameraPos(-141.13, 113.38, 123.83)
	event.SetCameraRef(-246.69, 70.4, -33.02)
	event.SetFlag(414, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e414/")
	event.LoadMes(0, 5, "e414_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e414_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e414_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e414/e414_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e400/e414/e414_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, -292.9, 40.4, -58.14)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -276.7, 40.4, -72.82)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(1, 6)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-141.13, 113.38, 123.83)
	event.CmrsSetRef(-246.69, 70.4, -33.02)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 80)
	event.ObjsAddPas(0, -292.9, 40.4, -58.14)
	event.ObjsAddPas(0, -292.45, 40.4, -27.37)
	event.ObjsAddPas(0, -284.23, 32.04, 8.02)
	event.ObjsAddPas(0, -277.65, 25.11, 28.59)
	event.ObjsStartPas(0, 1)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 80)
	event.ObjsAddPas(1, -276.7, 40.4, -72.82)
	event.ObjsAddPas(1, -272.25, 40.4, -27.73)
	event.ObjsAddPas(1, -265.38, 32.95, 2.25)
	event.ObjsStartPas(1, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.SetFadeIn(30)
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-32.57, 31.52, 76.71)
	event.CmrsSetRef(-55.79, 32.69, 217.54)
	event.CharaActive(0, 0)
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.ObjsSetPos(0, -66.07, 0.0, 134.78)
	event.ObjsSetRot(0, 0.0, -0.13, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, -48.48, 0.0, 138.36)
	event.ObjsSetRot(1, 0.0, -0.13, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_4896c0c7(4140010)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-26.03, 73.06, 273.78)
	event.CmrsSetRef(-57.55, 11.55, 129.5)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4140020)
	if vm.skipping() then
		return skip(3)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(4140030)
	if vm.skipping() then
		return skip(5)
	end
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_144d8()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4896c0c7(4120280)
		end
		if at <= 2 then
			helper_4896c0c7(4120290)
		end
		if at <= 3 then
			helper_4896c0c7(4120295)
		end
		if at <= 4 then
			helper_23bda4ba(2)
		end
		if at <= 5 then
			helper_4896c0c7(4120300)
		end
		if at <= 6 then
			helper_23bda4ba(2)
		end
		if at <= 7 then
			helper_4896c0c7(4120310)
		end
		if at <= 8 then
			helper_23bda4ba(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(1.94, 46.13, 182.69)
	event.CmrsSetRef(0.3, 9.85, 111.43)
	helper_4896c0c7(4120280)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(12.38, 21.89, 126.92)
	event.CmrsSetRef(0.56, 16.44, 101.56)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120290)
	if vm.skipping() then
		return skip(3)
	end
	helper_4896c0c7(4120295)
	if vm.skipping() then
		return skip(4)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(0.07, 37.81, 61.37)
	event.CmrsSetRef(0.86, 4.93, 133.5)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120300)
	if vm.skipping() then
		return skip(6)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "オズ見会話", 6)
	event.ObjsNextMotion(0, "オズ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120310)
	if vm.skipping() then
		return skip(8)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_149dc()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4896c0c7(4120320)
		end
		if at <= 2 then
			helper_4896c0c7(4120330)
		end
		if at <= 3 then
			helper_4896c0c7(4120335)
		end
		if at <= 4 then
			helper_23bda4ba(2)
		end
		if at <= 5 then
			helper_4896c0c7(4120340)
		end
		if at <= 6 then
			helper_23bda4ba(2)
		end
		if at <= 7 then
			helper_4896c0c7(4120350)
		end
		if at <= 8 then
			helper_23bda4ba(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(1.94, 46.13, 182.69)
	event.CmrsSetRef(0.3, 9.85, 111.43)
	helper_4896c0c7(4120320)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(12.38, 21.89, 126.92)
	event.CmrsSetRef(0.56, 16.44, 101.56)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120330)
	if vm.skipping() then
		return skip(3)
	end
	helper_4896c0c7(4120335)
	if vm.skipping() then
		return skip(4)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(0.07, 37.81, 61.37)
	event.CmrsSetRef(0.86, 4.93, 133.5)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120340)
	if vm.skipping() then
		return skip(6)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "オズ見会話", 6)
	event.ObjsNextMotion(0, "オズ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120350)
	if vm.skipping() then
		return skip(8)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_14ee0()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4896c0c7(4120360)
		end
		if at <= 2 then
			helper_4896c0c7(4120370)
		end
		if at <= 3 then
			helper_4896c0c7(4120375)
		end
		if at <= 4 then
			helper_23bda4ba(2)
		end
		if at <= 5 then
			helper_4896c0c7(4120380)
		end
		if at <= 6 then
			helper_23bda4ba(0)
		end
		if at <= 7 then
			helper_4896c0c7(4120390)
		end
		if at <= 8 then
			helper_23bda4ba(2)
		end
		if at <= 9 then
			helper_4896c0c7(4120395)
		end
		if at <= 10 then
			helper_23bda4ba(2)
		end
		if at <= 11 then
			helper_4896c0c7(4120400)
		end
		if at <= 12 then
			helper_23bda4ba(2)
		end
		if at <= 13 then
			helper_4896c0c7(4120410)
		end
		if at <= 14 then
			helper_23bda4ba(0)
		end
		if at <= 15 then
			helper_4896c0c7(4120420)
		end
		if at <= 16 then
			helper_23bda4ba(2)
		end
		if at <= 17 then
			helper_4896c0c7(4120430)
		end
		if at <= 18 then
			helper_23bda4ba(2)
		end
		if at <= 19 then
			helper_4896c0c7(4120440)
		end
		if at <= 20 then
			helper_23bda4ba(2)
		end
		if at <= 21 then
			helper_4896c0c7(4120450)
		end
		if at <= 22 then
			helper_23bda4ba(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120360)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(61.53, 21.92, 103.15)
	event.CmrsSetRef(-3.45, 12.1, 116.17)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120370)
	if vm.skipping() then
		return skip(3)
	end
	helper_4896c0c7(4120375)
	if vm.skipping() then
		return skip(4)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "オズ見会話", 6)
	event.ObjsNextMotion(0, "オズ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120380)
	if vm.skipping() then
		return skip(6)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120390)
	if vm.skipping() then
		return skip(8)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(11.42, 18.58, 127.72)
	event.CmrsSetRef(-0.07, 16.07, 102.57)
	event.ObjsSetMotion(2, "考える（立ち）in", 6)
	event.ObjsNextMotion(2, "考える（立ち）ループ", 4)
	helper_4896c0c7(4120395)
	if vm.skipping() then
		return skip(10)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(2, "考える（立ち）戻り", 6)
	event.ObjsNextMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120400)
	if vm.skipping() then
		return skip(12)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-29.49, 18.58, 77.42)
	event.CmrsSetRef(4.8, 16.07, 120.22)
	event.ObjsSetMotion(0, "オズ見会話", 6)
	event.ObjsNextMotion(0, "オズ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4896c0c7(4120410)
	if vm.skipping() then
		return skip(14)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120420)
	if vm.skipping() then
		return skip(16)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(11.42, 18.58, 127.72)
	event.CmrsSetRef(-0.07, 16.07, 102.57)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120430)
	if vm.skipping() then
		return skip(18)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-2.05, 15.78, 172.81)
	event.CmrsSetRef(-0.14, 17.4, 100.38)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120440)
	if vm.skipping() then
		return skip(20)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(0, "オズ見会話", 6)
	event.ObjsNextMotion(0, "オズ見立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120450)
	if vm.skipping() then
		return skip(22)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(23)
	end
end

--- Helper function.
local function helper_15ca8()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 86 then
			if at <= 1 then
				helper_23bda4ba(1)
			end
			if at <= 2 then
				helper_adea7ba0(60)
			end
			if at <= 3 then
				helper_4896c0c7(4120010)
			end
			if at <= 4 then
				helper_23bda4ba(2)
			end
			if at <= 5 then
				helper_23bda4ba(2)
			end
			if at <= 6 then
				helper_23bda4ba(2)
			end
			if at <= 7 then
				helper_adea7ba0(10)
			end
			if at <= 8 then
				helper_4896c0c7(4120020)
			end
			if at <= 9 then
				helper_23bda4ba(2)
			end
			if at <= 10 then
				helper_4896c0c7(4120030)
			end
			if at <= 11 then
				helper_23bda4ba(0)
			end
			if at <= 12 then
				helper_23bda4ba(2)
			end
			if at <= 13 then
				helper_4896c0c7(4120040)
			end
			if at <= 14 then
				helper_4896c0c7(4120043)
			end
			if at <= 15 then
				helper_23bda4ba(2)
			end
			if at <= 16 then
				helper_4896c0c7(4120046)
			end
			if at <= 17 then
				helper_4896c0c7(4120050)
			end
			if at <= 18 then
				helper_4896c0c7(4120055)
			end
			if at <= 19 then
				helper_23bda4ba(0)
			end
			if at <= 20 then
				helper_366d50dc(4120060, -1, 0)
			end
			if at <= 21 then
				helper_23bda4ba(2)
			end
			if at <= 22 then
				helper_adea7ba0(10)
			end
			if at <= 23 then
				helper_adea7ba0(10)
			end
			if at <= 24 then
				helper_4a2354f0(4120070, -1)
			end
			if at <= 25 then
				helper_adea7ba0(10)
			end
			if at <= 26 then
				helper_4a2354f0(4120080, -1)
			end
			if at <= 27 then
				helper_adea7ba0(30)
			end
			if at <= 28 then
				helper_adea7ba0(30)
			end
			if at <= 29 then
				helper_adea7ba0(60)
			end
			if at <= 30 then
				helper_4896c0c7(4120090)
			end
			if at <= 31 then
				helper_4896c0c7(4120095)
			end
			if at <= 32 then
				helper_23bda4ba(2)
			end
			if at <= 33 then
				helper_4896c0c7(4120100)
			end
			if at <= 34 then
				helper_23bda4ba(0)
			end
			if at <= 35 then
				helper_4896c0c7(4120110)
			end
			if at <= 36 then
				helper_23bda4ba(2)
			end
			if at <= 37 then
				helper_23bda4ba(2)
			end
			if at <= 38 then
				helper_23bda4ba(2)
			end
			if at <= 39 then
				helper_adea7ba0(30)
			end
			if at <= 40 then
				helper_23bda4ba(2)
			end
			if at <= 41 then
				helper_23bda4ba(2)
			end
			if at <= 42 then
				helper_adea7ba0(10)
			end
			if at <= 43 then
				helper_4896c0c7(4120120)
			end
			if at <= 44 then
				helper_23bda4ba(2)
			end
			if at <= 45 then
				helper_4896c0c7(4120130)
			end
			if at <= 46 then
				helper_23bda4ba(1)
			end
			if at <= 47 then
				helper_4896c0c7(4120140)
			end
			if at <= 48 then
				helper_23bda4ba(0)
			end
			if at <= 49 then
				helper_4896c0c7(4120150)
			end
			if at <= 50 then
				helper_4896c0c7(4120155)
			end
			if at <= 51 then
				helper_23bda4ba(0)
			end
			if at <= 52 then
				helper_4896c0c7(4120160)
			end
			if at <= 53 then
				helper_23bda4ba(0)
			end
			if at <= 54 then
				helper_4896c0c7(4120170)
			end
			if at <= 55 then
				helper_23bda4ba(0)
			end
			if at <= 56 then
				helper_366d50dc(4120180, -1, 2)
			end
			if at <= 57 then
				helper_23bda4ba(2)
			end
			if at <= 58 then
				helper_adea7ba0(60)
			end
			if at <= 59 then
				helper_4896c0c7(4120190)
			end
			if at <= 60 then
				helper_23bda4ba(0)
			end
			if at <= 61 then
				helper_4896c0c7(4120200)
			end
			if at <= 62 then
				helper_4896c0c7(4120205)
			end
			if at <= 63 then
				helper_23bda4ba(2)
			end
			if at <= 64 then
				helper_4896c0c7(4120210)
			end
			if at <= 65 then
				helper_23bda4ba(0)
			end
			if at <= 66 then
				helper_4896c0c7(4120220)
			end
			if at <= 67 then
				helper_23bda4ba(1)
			end
			if at <= 68 then
				helper_23bda4ba(2)
			end
			if at <= 69 then
				helper_23bda4ba(2)
			end
			if at <= 70 then
				helper_4896c0c7(4120230)
			end
			if at <= 71 then
				helper_4896c0c7(4120240)
			end
			if at <= 72 then
				helper_23bda4ba(1)
			end
			if at <= 73 then
				helper_4896c0c7(4120250)
			end
			if at <= 74 then
				helper_4896c0c7(4120255)
			end
			if at <= 75 then
				helper_23bda4ba(2)
			end
			if at <= 76 then
				helper_4896c0c7(4120260)
			end
			if at <= 77 then
				helper_4896c0c7(4120270)
			end
			if at <= 78 then
				helper_23bda4ba(2)
			end
			if at <= 79 then
				helper_144d8()
			end
			if at <= 80 then
				helper_149dc()
			end
			if at <= 81 then
				helper_14ee0()
			end
			if at <= 82 then
				helper_adea7ba0(2)
			end
			if at <= 83 then
				helper_adea7ba0(120)
			end
			if at <= 84 then
				helper_c2754f21(360, 1)
			end
			if at <= 85 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(87)
			end
			return part2()
		end
		if at <= 87 then
			helper_51491a96(0)
		end
		helper_ab9c465c(vm.f32(-15.3), 0.0, vm.f32(129.1), vm.f32(-1.71))
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsInit()
		event.PlayBgm(0)
		event.SndSeStop(var1, 0)
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
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.LoadMes(0, -1)
		event.CharaActive(var0)
		event.EohSetRot(3, 0.0, -0.157, 0.0)
		helper_51491a96(0)
		if vm.skipping() then
			return skip(88)
		end
		helper_ab9c465c(vm.f32(-15.3), 0.0, vm.f32(129.1), vm.f32(-1.71))
		event.ResetCamera(1, 3.14, 10)
		event.SetFadeIn(30)
	end
	event.SetFadeOut(0)
	event.SetCameraPos(-141.13, 113.38, 123.83)
	event.SetCameraRef(-246.69, 70.4, -33.02)
	event.SetFlag(412, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SearchCharaNo(301) or var0
	event.CharaActive(0, var0)
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(54)
	event.PlayBgm(0)
	event.LoadSound(4500)
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	var2 = event.SndLoadSound(4500) or var2
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e412/")
	event.LoadMes(0, 5, "e412_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e412_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e412_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e412_osmond.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e412_mimizu_e.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.SetReference(34, "mimizu", 35)
	event.LoadChara(5, "e412_kareha.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.LoadChara(5, "e412_mimizu.gltf", "info", 37)
	event.CharaActive(0, 37)
	event.ChangeDir("")
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncObj(3, "p03_f03i0301-1")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e412/e412_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e400/e412/e412_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, -292.9, 40.4, -58.14)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -276.7, 40.4, -72.82)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(1, 6)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -57.0056, 8.73, 219.919)
	event.EohSetRot(2, 0.0, -0.157, 0.0)
	event.EohSetMotion(2, "寝る", 4)
	event.EohSetFootSoundId(2, 6)
	event.SetCharaPos(36, -64.95, 10.43, 154.8)
	event.SetCharaRot(36, 0.0, 0.0, 0.0)
	event.EohSetPos(3, -57.0056, 1.362, 219.919)
	event.EohSetRot(3, 0.0, -0.157, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-141.13, 113.38, 123.83)
	event.CmrsSetRef(-246.69, 70.4, -33.02)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 80)
	event.ObjsAddPas(0, -292.9, 40.4, -58.14)
	event.ObjsAddPas(0, -292.45, 40.4, -27.37)
	event.ObjsAddPas(0, -284.23, 32.04, 8.02)
	event.ObjsAddPas(0, -277.65, 25.11, 28.59)
	event.ObjsStartPas(0, 1)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 80)
	event.ObjsAddPas(1, -276.7, 40.4, -72.82)
	event.ObjsAddPas(1, -272.25, 40.4, -27.73)
	event.ObjsAddPas(1, -265.38, 32.95, 2.25)
	event.ObjsStartPas(1, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.SetFadeIn(30)
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-60.4, 30.75, 94.03)
	event.CmrsSetRef(-57.07, 26.26, 219.16)
	event.CharaActive(0, 0)
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.ObjsSetPos(0, -68.91, 0.0, 141.39)
	event.ObjsSetRot(0, 0.0, 0.19, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, -52.53, 0.0, 138.51)
	event.ObjsSetRot(1, 0.0, -0.13, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(2, "あくびin", 2)
	event.ObjsNextMotion(2, "あくびループ", 4)
	helper_4896c0c7(4120010)
	if vm.skipping() then
		return skip(4)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "あくびout", 6)
	event.ObjsMotionWait(2)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var2, 2)
	event.ObjsRotation2(3, 0.0, -3.14, 0.0, 12, 0, 0.6)
	event.ObjsRotation2(2, 0.0, -3.14, 0.0, 12, 0, 0.6)
	event.ObjsSetMotion(2, "回る", 6)
	event.ObjsNextMotion(2, "座る（イス）", 4)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "会話（座り）in", 6)
	event.ObjsNextMotion(2, "会話（座り）ループ", 6)
	event.ObjsNextMotion(2, "会話（座り）out", 6)
	event.ObjsNextMotion(2, "座る（イス）", 4)
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(8)
	end
	helper_4896c0c7(4120020)
	if vm.skipping() then
		return skip(9)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-104.52, 93.75, 72.59)
	event.CmrsSetRef(-60.02, 16.31, 170.08)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.ObjsSetMotion(2, "ジャンプ（イス）", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsPosDelay(2, 14)
	event.ObjsJump(2, -58.85, 1.39, 188.8, -0.3, 10)
	event.ObjsSeDelay(2, 16)
	event.ObjsSePlay(2, var2, 3)
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120030)
	if vm.skipping() then
		return skip(11)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(12)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-31.93, 15.15, 145.12)
	event.CmrsSetRef(-57.86, 15.41, 187.43)
	helper_4896c0c7(4120040)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_4896c0c7(4120043)
	if vm.skipping() then
		return skip(15)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(16)
	end
	helper_4896c0c7(4120046)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-61.55, 45.1, 105.25)
	event.CmrsSetRef(-58.99, 3.18, 187.49)
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4896c0c7(4120050)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_4896c0c7(4120055)
	if vm.skipping() then
		return skip(19)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsMotionDelay(2, 20)
	event.ObjsSetMotion(2, "手を取るin", 2)
	event.ObjsNextMotion(2, "手を取るループ", 4)
	event.ObjsSeDelay(2, 20)
	event.ObjsSePlay(2, var2, 4)
	helper_366d50dc(4120060, -1, 0)
	if vm.skipping() then
		return skip(21)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(22)
	end
	event.SndPauseBgm()
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(23)
	end
	event.SndSePlay(var2, 5)
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(24)
	end
	event.CharaActive(1, 36)
	event.SetMotion(36, "枯れ葉", 6)
	helper_4a2354f0(4120070, -1)
	if vm.skipping() then
		return skip(25)
	end
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(26)
	end
	helper_4a2354f0(4120080, -1)
	if vm.skipping() then
		return skip(27)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(28)
	end
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(29)
	end
	event.CharaActive(0, 36)
	event.CmrsSetPos(-67.89, 95.56, 17.98)
	event.CmrsSetRef(-0.19, 24.67, 90.58)
	event.PlayBgm(0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetPos(0, 12.0, 0.0, 129.0)
	event.ObjsSetRot(0, 0.0, -2.87, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetPos(1, -12.0, 0.0, 129.0)
	event.ObjsSetRot(1, 0.0, 2.87, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetPos(2, 0.22, 16.25, 71.22)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "座る（作業）", 4)
	event.SetFadeIn(30)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-32.43, 23.17, 110.46)
	event.CmrsSetRef(-0.77, 29.3, 74.63)
	event.ObjsSetMotion(2, "会話（座る作業）", 6)
	event.ObjsNextMotion(2, "座る（作業）", 4)
	helper_4896c0c7(4120090)
	if vm.skipping() then
		return skip(31)
	end
	helper_4896c0c7(4120095)
	if vm.skipping() then
		return skip(32)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(-0.62, 52.01, 189.19)
	event.CmrsSetRef(0.13, 6.74, 74.63)
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120100)
	if vm.skipping() then
		return skip(34)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(2, "考えるin", 2)
	event.ObjsNextMotion(2, "考えるループ", 4)
	helper_4896c0c7(4120110)
	if vm.skipping() then
		return skip(36)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(-101.47, 52.81, 157.92)
	event.CmrsSetRef(19.07, 4.97, 86.26)
	event.ObjsSetMotion(2, "ジャンプ（座り降りる作業）", 6)
	event.ObjsPosDelay(2, 14)
	event.ObjsJump(2, 0.0, 0.0, 100.0, -0.3, 10)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var2, 6)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "上→オズ", 6)
	event.ObjsMotionDelay(0, 10)
	event.ObjsNextMotion(0, "オズ→右", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsMotionDelay(1, 16)
	event.ObjsSetMotion(1, "上から右見", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(2, "走り")
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 90)
	event.ObjsAddPas(2, 0.0, 0.0, 100.0)
	event.ObjsAddPas(2, 30.37, 0.0, 110.52)
	event.ObjsAddPas(2, 80.4, 0.0, 119.89)
	event.ObjsAddPas(2, 145.29, 7.33, 119.81)
	event.ObjsAddPas(2, 185.25, 18.79, 102.01)
	event.ObjsAddPas(2, 222.42, 20.0, 55.61)
	event.ObjsAddPas(2, 244.29, 20.0, 1.8)
	event.ObjsStartPas(2, 1)
	event.ObjsSeDelay(2, 90)
	event.ObjsSePlay(2, var2, 7)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(39)
	end
	event.CharaActive(35)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsMotionDelay(0, 76)
	event.ObjsSetMotion(0, "右向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsMotionDelay(1, 80)
	event.ObjsSetMotion(1, "右向く戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "走り")
	event.ObjsMotionDelay(2, 86)
	event.ObjsSetMotion(2, "ジャンプ（立ち上がる作業）", 2)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 90)
	event.ObjsAddPas(2, 244.29, 20.0, 1.8)
	event.ObjsAddPas(2, 222.42, 20.0, 55.61)
	event.ObjsAddPas(2, 185.25, 18.79, 102.01)
	event.ObjsAddPas(2, 145.29, 7.33, 119.81)
	event.ObjsAddPas(2, 80.4, 0.0, 119.89)
	event.ObjsAddPas(2, 30.37, 0.0, 110.52)
	event.ObjsAddPas(2, 0.0, 0.0, 100.0)
	event.ObjsStartPas(2, 1)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsPosDelay(2, 10)
	event.ObjsJump(2, 0.22, 20.73, 71.22, -0.4, 10)
	event.ObjsRotation(2, 0.0, 3.12, 0.0, 10)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var2, 8)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(42)
	end
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsSetPos(12.14, 18.23, 108.78)
	event.CmrsSetRef(-2.76, 35.85, 71.25)
	event.CharaActive(1, 37)
	event.SetCharaShow(37, 1, 1, 0.025)
	event.SetCharaPos(37, -11.36, 50.18, 62.56)
	event.SetCharaRot(37, 0.2, 0.38, 0.0)
	event.SndSePlay(var2, 9)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "ミミズin", 6)
	event.ObjsNextMotion(2, "ミミズループ", 4)
	event.ObjsSeDelay(2, 20)
	event.ObjsSePlay(2, var2, 10)
	helper_4896c0c7(4120120)
	if vm.skipping() then
		return skip(44)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(45)
	end
	event.CharaActive(0, 37)
	event.CmrsSetPos(-39.38, 71.0, 40.08)
	event.CmrsSetRef(-8.79, 33.78, 82.73)
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(4120130)
	if vm.skipping() then
		return skip(46)
	end
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120140)
	if vm.skipping() then
		return skip(48)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsSetPos(-35.69, 30.29, 106.67)
	event.CmrsSetRef(-1.38, 34.39, 76.96)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120150)
	if vm.skipping() then
		return skip(50)
	end
	helper_4896c0c7(4120155)
	if vm.skipping() then
		return skip(51)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(52)
	end
	event.CmrsSetPos(-1.94, 15.83, 175.3)
	event.CmrsSetRef(0.28, 29.07, 77.05)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "すごい！", 6)
	event.ObjsNextMotion(0, "すごい！L", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var2, 11)
	event.ObjsSetMotion(2, "エヘンin", 6)
	event.ObjsNextMotion(2, "エヘンループ", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4896c0c7(4120160)
	if vm.skipping() then
		return skip(53)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetMotion(1, "上から右見", 6)
	event.ObjsNextMotion(1, "右向き会話", 6)
	event.ObjsNextMotion(1, "右向きL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(4120170)
	if vm.skipping() then
		return skip(55)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(56)
	end
	event.ObjsSetMotion(0, "すごい！戻り", 6)
	event.ObjsNextMotion(0, "上向きL", 4)
	event.ObjsSetMotion(1, "右から上見", 6)
	event.ObjsNextMotion(1, "上向きL", 6)
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "エヘンとまるループ", 4)
	helper_366d50dc(4120180, -1, 2)
	if vm.skipping() then
		return skip(57)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(58)
	end
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(59)
	end
	event.CmrsSetPos(40.55, 84.1, 44.3)
	event.CmrsSetRef(3.43, 29.07, 90.92)
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(2, "立ち2", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120190)
	if vm.skipping() then
		return skip(60)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(61)
	end
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120200)
	if vm.skipping() then
		return skip(62)
	end
	helper_4896c0c7(4120205)
	if vm.skipping() then
		return skip(63)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(64)
	end
	event.ObjsSetMotion(0, "なるほど", 6)
	event.ObjsNextMotion(0, "なるほどL", 4)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var2, 12)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(4120210)
	if vm.skipping() then
		return skip(65)
	end
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(66)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	event.ObjsSetMotion(1, "上から右見", 6)
	event.ObjsNextMotion(1, "右向き会話", 6)
	event.ObjsNextMotion(1, "右向きL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(4120220)
	if vm.skipping() then
		return skip(67)
	end
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(68)
	end
	event.CmrsSetPos(-86.38, 18.21, 93.39)
	event.CmrsSetRef(7.04, 16.83, 103.58)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "上→左", 6)
	event.ObjsNextMotion(0, "左L", 4)
	event.ObjsSetMotion(1, "上向くL", 5.0, 1)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "上向く戻り", 6)
	event.ObjsNextMotion(1, "近オズ見", 6)
	event.ObjsNextMotion(1, "近オズ見L", 4)
	event.SndSePlay(var2, 13)
	event.ObjsSetMotion(2, "ジャンプ（立ち降りる作業）", 6)
	event.ObjsMotionWait(2)
	event.ObjsPosDelay(2, 6)
	event.ObjsJump(2, -4.56, 0.0, 94.9, -0.3, 10)
	event.ObjsRotDelay(2, 14)
	event.ObjsRotation(2, 0.0, -0.2, 0.0, 10)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(69)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -9.95, 0.0, 115.32, 30)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "モニカ前in", 2)
	event.ObjsNextMotion(2, "モニカ前ループ", 4)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(70)
	end
	event.ObjsSetMotion(2, "会話（モニカ前）", 6)
	event.ObjsNextMotion(2, "モニカ前ループ", 4)
	helper_4896c0c7(4120230)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsSetMotion(1, "近オズ見会話", 6)
	event.ObjsNextMotion(1, "近オズ見L", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(4120240)
	if vm.skipping() then
		return skip(72)
	end
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(73)
	end
	event.CmrsSetPos(-2.05, 15.78, 172.81)
	event.CmrsSetRef(-0.14, 17.4, 100.38)
	event.ObjsSetMotion(0, "オズ見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "下向くL", 4, -1.0, 1)
	event.ObjsSetPos(2, 0.0, 0.0, 100.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120250)
	if vm.skipping() then
		return skip(74)
	end
	helper_4896c0c7(4120255)
	if vm.skipping() then
		return skip(75)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(76)
	end
	event.CmrsSetPos(-25.65, 31.52, 124.65)
	event.CmrsSetRef(-0.14, 12.1, 100.38)
	helper_4896c0c7(4120260)
	if vm.skipping() then
		return skip(77)
	end
	event.CmrsSetPos(-41.74, 45.78, 69.3)
	event.CmrsSetRef(-3.45, 12.1, 116.17)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_4896c0c7(4120270)
	if vm.skipping() then
		return skip(78)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(79)
	end
	argc = event.GetItemHaveNum(309) or argc
	if argc >= 1 then
		helper_144d8()
		if vm.skipping() then
			return skip(80)
		end
	else
		argc_2 = event.GetInventionId(309) or argc_2
		if argc_2 >= 0 then
			helper_149dc()
			if vm.skipping() then
				return skip(81)
			end
		else
			helper_14ee0()
			if vm.skipping() then
				return skip(82)
			end
		end
	end
	event.CmrsSetPos(-5.15, 15.19, 86.26)
	event.CmrsSetRef(13.27, 25.71, 128.54)
	event.CmrsMove2(0.51, 18.67, 99.25, 13.27, 25.71, 128.54, 90, 2, 0.3)
	event.DelReference(35)
	if active_chr_no == 0 then
		event.SetReference(0, "item", 35)
	else
		event.SetReference(32, "item", 35)
	end
	event.ObjsSetMotion(0, "ミミズゲット", 4)
	event.SndPauseBgm()
	event.CharaActive(0, 34)
	event.CharaActive(1, 38)
	event.SetCharaPos(38, 17.1, 30.73, 123.76)
	event.SetCharaRot(38, 0.0, 0.48, 0.0)
	event.SetMotion(38, "発動", 6)
	helper_adea7ba0(2)
	if vm.skipping() then
		return skip(83)
	end
	event.SndSePlay(var1, 0)
	helper_adea7ba0(120)
	if vm.skipping() then
		return skip(84)
	end
	event.SndSePlay(var2, 14)
	helper_c2754f21(360, 1)
	if vm.skipping() then
		return skip(85)
	end
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(86)
	end
	return part2()
end

--- Helper function.
local function helper_21e10(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var2 = out2 or var2
	end
	var4 = vm.f32(arg0 + vm.f32(6.2831855))
	var5 = vm.f32(var2 + vm.f32(6.2831855))
	var6 = vm.f32(var4 - var5)
	if var6 < 0 then
		var6 = vm.f32(var6 * -1.0)
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, arg0, 0.0, vm.ftoi(vm.f32(var6 * 10.0)))
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1f72c()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_23bda4ba(2)
			end
			if at <= 2 then
				helper_4896c0c7(4680010)
			end
			if at <= 3 then
				helper_4896c0c7(4680015)
			end
			if at <= 4 then
				helper_4896c0c7(4680020)
			end
			if at <= 5 then
				helper_4896c0c7(4680030)
			end
			if at <= 6 then
				helper_4896c0c7(4680040)
			end
			if at <= 7 then
				helper_4896c0c7(4680050)
			end
			if at <= 8 then
				helper_4896c0c7(4680060)
			end
			if at <= 9 then
				helper_adea7ba0(8)
			end
			if at <= 10 then
				helper_23bda4ba(0)
			end
			if at <= 11 then
				helper_c2754f21(154, 1)
			end
			if at <= 12 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
		if at <= 14 then
			helper_51491a96(0)
		end
		helper_ab9c465c(vm.f32(-15.3), 0.0, vm.f32(129.1), vm.f32(-1.71))
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
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.LoadMes(0, -1)
		event.CharaActive(var0)
		helper_51491a96(0)
		if vm.skipping() then
			return skip(15)
		end
		event.PlayBgm(0)
		helper_ab9c465c(vm.f32(-15.3), 0.0, vm.f32(129.1), vm.f32(-1.71))
		event.ResetCamera(1, 3.14, 10)
		event.SetFadeIn(30)
	end
	event.SetFlag(468, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SearchCharaNo(301) or var0
	event.CharaActive(0, var0)
	event.StopBgm(0)
	event.LoadSound(4520)
	var1 = event.SndLoadSound(4520) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e468/")
	event.LoadMes(0, 5, "e468_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e468_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e468_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e468_osmond.gltf", "info", 34)
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
		event.LoadMotion(5, "event/e400/e468/e468_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e400/e468/e468_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.LoadItem(5, 154, "info", 35)
	event.CharaActive(35)
	event.EohSetPos(0, -247.64, 8.6, 49.13)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 6)
	event.EohSetPos(1, -282.38, 14.67, 40.57)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(1, 6)
	event.EohSetPos(2, -89.55, 0.0, 80.94)
	event.EohSetRot(2, 0.0, 1.56, 0.0)
	event.EohSetFootSoundId(2, 6)
	event.SetCharaPos(35, 7.23, 29.01, 8.69)
	event.SetCharaRot(35, 0.0, -0.6, 0.0)
	event.SetMotion(35, "立ち-足", 5)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(3.28, 114.18, 221.29)
	event.CmrsSetRef(-125.61, 36.71, 82.9)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 80)
	event.ObjsAddPas(0, -247.64, 8.6, 49.13)
	event.ObjsAddPas(0, -235.43, 0.0, 70.71)
	event.ObjsAddPas(0, -190.96, 0.0, 91.56)
	event.ObjsStartPas(0, 1)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 80)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, -282.38, 14.67, 40.57)
	event.ObjsAddPas(1, -272.58, 6.9, 61.69)
	event.ObjsAddPas(1, -240.47, 0.0, 89.87)
	event.ObjsAddPas(1, -204.44, 0.0, 106.62)
	event.ObjsStartPas(1, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_23bda4ba(1)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(2, "回る", 2)
	event.ObjsNextMotion(2, "立ち")
	event.ObjsRotation(2, 0.0, -1.6, 0.0, 20)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(2)
	end
	helper_4896c0c7(4680010)
	if vm.skipping() then
		return skip(3)
	end
	helper_4896c0c7(4680015)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(0.0, 56.0, 185.0)
	event.CmrsSetRef(0.0, 16.0, 36.0)
	event.ObjsSetPos(0, 0.0, 0.0, 100.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetPos(1, -25.0, 0.0, 100.0)
	event.ObjsSetRot(1, 0.0, 2.9, 0.0)
	event.ObjsSetPos(2, 25.0, 0.0, 100.0)
	event.ObjsSetRot(2, 0.0, -2.9, 0.0)
	helper_4896c0c7(4680020)
	if vm.skipping() then
		return skip(5)
	end
	helper_4896c0c7(4680030)
	if vm.skipping() then
		return skip(6)
	end
	helper_4896c0c7(4680040)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var1, 2)
	event.ObjsSetMotion(0, "すごい！", 6)
	event.ObjsNextMotion(0, "すごい！L", 4)
	helper_4896c0c7(4680050)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(2, "すごい！", 6)
	event.ObjsNextMotion(2, "すごい！L", 4)
	helper_4896c0c7(4680060)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "がっつL", 4)
	event.ObjsSetMotion(2, "がっつ", 6)
	event.ObjsNextMotion(2, "がっつL", 4)
	helper_adea7ba0(8)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var1, 3)
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(11)
	end
	helper_c2754f21(154, 1)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

--- Helper function.
local function helper_10c64()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local argc: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local active_chr_no: s32 = 0
	local player_chara_2: s32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5cfcf598(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_74c7bd44(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_5cfcf598(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_6e156310(player_chara_2, var22)
		end
		if at <= 5 then
			helper_5cfcf598(0, -1, var1, player_chara_2, 0)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	var3 = 0
	if var2 == 300 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(456) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"H[UNI00e9] ! Qui [UNI00ea]tes... ? Ceci est le plus\ngrand des centres de recherches,\nle Laboratoire psych[UNI00e9]-psychique.<page>Et m[UNI00ea]me si pour l'instant il n'en\na pas trop l'aspect, nous devrions\npouvoir terminer nos recherches."
				)
			else
				event.MesMake_2(
					0,
					"Il est impossible de qualifier le\nniveau d'excellence du Labo psy.\nIl faut le voir pour le croire."
				)
			end
		else
			event.MesMake_2(
				0,
				"Si on laisse faire Griffon,\nl'histoire ne reprendra jamais\nson cours normal.<page>L'existence m[UNI00ea]me de Griffon\nperturbe le cours de l'histoire."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.GetFlag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.GetFlag(408) or flag_4
			if flag_4 == 0 then
				event.MesMake_2(0, "Haaan, houuu, haaan, houuu.")
				var3 = 2
			else
				argc = event.GetInventionId(309) or argc
				if argc < 0 then
					event.MesMake_2(
						0,
						"Ces quelques trucs t'aideront [UNI00e0]\ninventer un aquarium : une bo[UNI00ee]te en\nbois, une fen[UNI00ea]tre et une fontaine.\nTu as bien [UNI00e7]a dans ta ville, non ?"
					)
				else
					var9 = event.GetSavedataEtc(2) or var9
					if var9 == 0 then
						event.MesMake_2(
							0,
							"D[UNI00e9]j[UNI00e0], donne un \"ver [UNI00e9]lectrique\" [UNI00e0]\nun poisson de l'aquarium pour\nl'[UNI00e9]lectrifier. Ensuite donne<page>ce poisson au Shigura. Tu as bien\ncompris, hein ?"
						)
					else
						event.MesMake_2(
							0,
							"Ooh, alors tu as le poisson ?\nMaintenant, donne-le au Shigura.\nTu devrais y arriver, non ?"
						)
					end
				end
			end
		else
			event.MesMake_2(
				0,
				"H[UNI00e9] bien, oui, tu y es arriv[UNI00e9] !\nOn dirait que mon invention a\nmarch[UNI00e9] pour toi, hein ? H[UNI00e9] oui."
			)
		end
	end
	if var2 == 302 then
		event.MesMake_2(0, "Que ce soit Osmond ou le directeur\ndu labo, ils sont un peu bizarres\nici.")
	end
	if var2 == 303 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(600) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(448) or flag_8
					if flag_8 == 0 then
						event.MesMake_2(
							0,
							"Prends soin de la traducoquille\ncar c'est l'une des plus\nimportantes inventions du Labo psy."
						)
					else
						event.MesMake_2(
							0,
							"Le temps presse. D[UNI00e9]p[UNI00ea]che-toi,\nles forces de Griffon s'approchent\nd'H[UNI00e9]l[UNI00e8]ne, et elles sont rapides..."
						)
					end
				else
					event.MesMake_2(0, "Je me demande quel type de\npersonne peut [UNI00ea]tre ce Griffon...")
				end
			else
				event.MesMake_2(
					0,
					"Les pierres que tu cherches sont les\ncristaux de sagesse des anciens.<page>Selon l'analyse de l'ordinateur du\nLabo psy, elles sont cach[UNI00e9]es en\nquatre lieux diff[UNI00e9]rents :"
				)
				helper_cee01349(player_chara, var1, 0)
				if vm.skipping() then
					return skip(1)
				end
				helper_5cfcf598(0, -1, var1, player_chara, 0)
				if vm.skipping() then
					return skip(2)
				end
				var3 = 1
				event.MesMake_2(
					0,
					"le Bois du Papillon arc-en-ciel, le\nCa[UNI00f1]on astral, la Caverne grondante \net le Mt. Gundor.<page>[UNI00c0] l'entr[UNI00e9]e de chaque lieu, il\ndevrait y avoir un symbole en forme\nd'[UNI00e9]toile... Ouvre bien les yeux."
				)
			end
		else
			event.MesMake_2(
				0,
				"Bien, il est temps d'[UNI00e9]liminer\nGriffon. Le destin du monde est\nentre vos mains. Bonne chance !"
			)
		end
	end
	if var2 == 304 then
		event.MesMake_2(
			0,
			"Tout est question de talent dans ce\nLabo. M[UNI00ea]me un enfant, s'il est tr[UNI00e8]s\ndou[UNI00e9], peut [UNI00ea]tre le chef ici."
		)
	end
	if var2 == 305 then
		event.MesMake_2(
			0,
			"Les lunites du Shigura aident [UNI00e0]\nnous lib[UNI00e9]rer l'esprit et [UNI00e0] nous\nconcentrer sur nos recherches.<page>Mais je ne sais pas exactement en\nquoi consistent ces lunites..."
		)
	end
	if var2 == 306 then
		event.MesMake_2(
			0,
			"Un labo oc[UNI00e9]anique, c'est pas top ?\nTu te rends compte du travail que\nj'ai fourni pour travailler ici ?"
		)
	end
	if var2 == 307 then
		event.MesMake_2(
			0,
			"Que penses-tu du design du Labo ?\nJe me demande qui a eu l'id[UNI00e9]e\nde ce dr[UNI00f4]le de concept..."
		)
	end
	if var2 == 308 then
		event.MesMake_2(
			0,
			"Un jour, je les surpasserai et ils\nverront mon intelligence. Ici, tout\nest question de talent, tu sais."
		)
	end
	if var2 == 309 then
		event.MesMake_2(
			0,
			"Je respecte beaucoup le patron. Il\nfaut reconna[UNI00ee]tre qu'un type qui\n[UNI00e9]crit un best-seller de 40 volumes<page> \"La Bible du G[UNI00e9]nie scientifique\n\" [UNI00e0] son [UNI00e2]ge, c'est quelqu'un."
		)
	end
	if var2 == 310 then
		event.MesMake_2(
			0,
			"Je suis encore novice ici. Mais\nje progresse chaque jour, je\ndeviendrai un grand chercheur."
		)
	end
	if var2 == 311 then
		event.MesMake_2(
			0,
			"Depuis ce labo, la vue sur la\nmer est exceptionnelle.<page>Tr[UNI00e8]s loin, [UNI00e0] l'horizon,\nl'obscurit[UNI00e9] de la mer et\ncelle du ciel fusionnent."
		)
	end
	if var2 == 312 then
		event.MesMake_2(
			0,
			"Ici c'est le Labo N[UNI00b0]2.<page>Au Labo psy, les laboratoires\ntravaillent tous sur\ndes domaines diff[UNI00e9]rents."
		)
	end
	if var2 == 313 then
		event.MesMake_2(
			0,
			"Ici, au Labo psy, nous simulons un\nenvironnement nocturne pour activer\nle pouvoir des lunites."
		)
	end
	if var2 == 314 then
		event.MesMake_2(
			0,
			"Quand j'ai commenc[UNI00e9] ici, moi aussi\nje me perdais sans cesse dans les\nlabos. Je vais t'expliquer : le<page>Labo 1 est rouge, le 2 est bleu,\nle 3 est violet et le Labo 4 est\nvert. Chacun a sa propre couleur."
		)
	end
	if var2 == 315 then
		event.MesMake_2(0, "L'embl[UNI00e8]me au-dessus du Labo\ncentral repr[UNI00e9]sente la lune.")
	end
	if var2 == 316 then
		event.MesMake_2(
			0,
			"Il para[UNI00ee]t que ce Labo a pu [UNI00ea]tre\ntermin[UNI00e9] gr[UNI00e2]ce aux lunites apport[UNI00e9]es\npar Shingala, un Drac de mer. <page>Il semble que ces cr[UNI00e9]atures soient\nplut[UNI00f4]t intelligentes, hein ? "
		)
	end
	if var2 == 317 then
		event.MesMake_2(
			0,
			"Ne lui dis pas que je t'ai dit [UNI00e7]a,<page> mais on en a ras-le-bol des\nsoi-disant blagues d'Osmond.\n Elles donnent envie de le frapper."
		)
	end
	if var2 == 318 then
		event.MesMake_2(
			0,
			"C'est vrai, moi aussi, j'ai pris\npart aux [UNI00e9]tudes du Ver [UNI00e9]lectrique.\nL[UNI00e0], je bosse sur un autre projet.<page> Ah non ! Je ne dirai pas quoi !\nJe peux pas le raconter [UNI00e0] tout le\nmonde, c'est top secret !"
		)
	end
	if var2 == 319 then
		event.MesMake_2(
			0,
			"Comment ? Toi aussi tu veux\ndevenir chercheur ?<page>C'est pas [UNI00e9]vident pour y arriver,\ntu sais.\nIl y a beaucoup de concurrence."
		)
	end
	if var2 == 320 then
		event.MesMake_2(
			0,
			"Certains chercheurs critiquent le\ndesign du Labo psy. Pour ma part,\nje le trouve plut[UNI00f4]t chouette...<page> Mais il semble que je sois un\ndes rares [UNI00e0] l'appr[UNI00e9]cier."
		)
	end
	if var2 == 321 then
		event.MesMake_2(
			0,
			"Nous discutons de recherches\ntr[UNI00e8]s confidentielles.<page>Pourriez-vous nous laisser\n seuls pendant un petit moment ?"
		)
	end
	if var2 == 322 then
		event.MesMake_2(
			0,
			"Pardonnez-nous, mais notre\ndiscussion concerne des\nrecherches tr[UNI00e8]s confidentielles.<page>On ne peut pas vraiment vous\nparler pour le moment, alors..."
		)
	end
	if var2 == 323 then
		event.MesMake_2(
			0,
			"Dr Nobb est tr[UNI00e8]s talentueux,\nbien s[UNI00fb]r, mais il\ntravaille aussi tr[UNI00e8]s dur.<page>En comparaison, je fais bien peu...\nJe serais presque paresseux..."
		)
	end
	if var2 == 324 then
		event.MesMake_2(
			0,
			"C'est toi ? On m'a dit que tu\nt'[UNI00e9]tais pris le bec avec Dr Osmond.<page>Je ne critique pas. Je trouve [UNI00e7]a\nbien. La remise en cause permet\nsouvent de nouvelles d[UNI00e9]couvertes."
		)
	end
	if var2 == 325 then
		event.MesMake_2(
			0,
			"Tu n'arrives pas [UNI00e0] t'habituer aux\nlumi[UNI00e8]res fortes, hein ?<page>Je suppose qu'il vous faudra\nun peu de temps pour vous y\nhabituer, vous qui venez du pass[UNI00e9]."
		)
	end
	if var2 == 326 then
		event.MesMake_2(
			0,
			"H[UNI00e9] bien, je fais une petite\npause.<page> Il faut parfois donner [UNI00e0] son\ncerveau un temps de repos, sinon on\nfinit par perdre de son acuit[UNI00e9]."
		)
	end
	if var2 == 327 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 1 then
			event.MesMake_2(
				0,
				"Para[UNI00ee]t que t'es bon inventeur ?\n Alors plus tard, [UNI00e7]a te dirait\nde venir travailler ici ?<page>Ce Labo psy sera tout juste fini\nquand tu deviendras adulte. Tu y\n serais s[UNI00fb]rement bien accueilli."
			)
		else
			event.MesMake_2(
				0,
				"Tu trouves pas que les inventeurs\nont beaucoup de charme ?<page>Mais ne tombe pas amoureuse de moi,\nmes recherches, c'est toute ma vie.\n[UNI00c7]a ne marcherait jamais entre nous."
			)
		end
	end
	if var2 == 328 then
		event.MesMake_2(
			0,
			"J'ai une id[UNI00e9]e r[UNI00e9]volutionnaire. Un\nsyst[UNI00e8]me qui permettrait [UNI00e0] monstres\net hommes de vivre en harmonie.<page>Je vais cr[UNI00e9]er une machine qui\ncomprend la langue humaine."
		)
	end
	if var2 == 329 then
		event.MesMake_2(
			0,
			"Les lunites sont [UNI00e0] la base de\ntoutes les activit[UNI00e9]s du Labo psy.<page>Sans elles, tous nos syst[UNI00e8]mes\ns'arr[UNI00ea]teraient instantan[UNI00e9]ment."
		)
	end
	if var3 == 0 then
		helper_74c7bd44(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_5cfcf598(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var16 = out1 or var16
			var18 = out3 or var18
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var19 = out1 or var19
			var21 = out3 or var21
		end
		var22 = event.GetRotLookPos(var19 - var16, var21 - var18) or var22
		helper_6e156310(player_chara_2, var22)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var22, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_5cfcf598(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	helper_daeaeed0()
	flag = event.GetFlag(400) or flag
	flag_2 = event.GetFlag(408) or flag_2
	if flag == 1 then
		if flag_2 == 0 then
			flag_3 = event.GetFlag(414) or flag_3
			if flag_3 == 0 then
				helper_1d788()
				if vm.skipping() then
					return skip(1)
				end
				return
			end
		else
			flag_4 = event.GetFlag(412) or flag_4
			if flag_4 == 0 then
				event.AddItem(360)
				helper_15ca8()
				if vm.skipping() then
					return skip(2)
				end
				return
			end
		end
	end
	helper_ab9c465c(0.0, vm.f32(69.1), -200.0, vm.f32(-1.57))
	event.ResetCamera(1, 3.14, 10)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15ca8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_adea7ba0(30)
		end
	end
	helper_21e10(vm.f32(3.1415927))
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(2)
	end
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(3)
	end
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_daeaeed0()
	event.AddItem(154)
	helper_1f72c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10c64()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14120.
script[14120] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(408, 1)
	helper_daeaeed0()
	helper_15ca8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14140.
script[14140] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(408, 0)
	helper_daeaeed0()
	helper_1d788()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14680.
script[14680] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_daeaeed0()
	helper_1f72c()
	if vm.skipping() then
		return skip(1)
	end
end

return script
