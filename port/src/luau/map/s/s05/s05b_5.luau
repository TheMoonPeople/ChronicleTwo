--!strict
-- map/s/s05/s05b_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1451869a = require("@lib/event/helper_1451869a")
local helper_90317de2 = require("@lib/event/helper_90317de2")
local helper_92f52aa8 = require("@lib/event/helper_92f52aa8")
local helper_b8f871c8 = require("@lib/event/helper_b8f871c8")
local helper_c3ce9c48 = require("@lib/event/helper_c3ce9c48")
local helper_cf67b418 = require("@lib/event/helper_cf67b418")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_f90fbb97 = require("@lib/event/helper_f90fbb97")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_12948()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e230/e230_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e230/e230_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e230/e230_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e230/e230_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e230/e230_utan.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e200/e230/e230_dokuring.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(3, 38)
	event.LoadChara(5, "event/e200/e230/e230_dokuring.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(4, 39)
	event.LoadChara(5, "event/e200/e230/e230_dokuring.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(5, 40)
	event.LoadChara(5, "event/e200/e230/e230_dokuring.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(6, 41)
	event.LoadMes(0, 5, "event/e200/e230/e230_1.txt")
end

--- Helper function.
local function helper_125bc()
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
	event.DeleteChara(34)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
end

--- Helper function.
local function helper_13a10()
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 56 then
			if at <= 1 then
				helper_12948()
				helper_ed0a80b8(4)
			end
			if at <= 2 then
				helper_ed0a80b8(150)
			end
			if at <= 3 then
				helper_c3ce9c48(2300010)
			end
			if at <= 4 then
				helper_ed0a80b8(17)
			end
			if at <= 5 then
				helper_c3ce9c48(2300020)
			end
			if at <= 6 then
				helper_ed0a80b8(17)
			end
			if at <= 7 then
				helper_c3ce9c48(2300030)
			end
			if at <= 8 then
				helper_ed0a80b8(9)
			end
			if at <= 9 then
				helper_c3ce9c48(2300040)
			end
			if at <= 10 then
				helper_e2d04ed9(0)
			end
			if at <= 11 then
				helper_ed0a80b8(20)
			end
			if at <= 12 then
				helper_ed0a80b8(45)
			end
			if at <= 13 then
				helper_c3ce9c48(2300050)
			end
			if at <= 14 then
				helper_c3ce9c48(2300060)
			end
			if at <= 15 then
				helper_c3ce9c48(2300070)
			end
			if at <= 16 then
				helper_c3ce9c48(2300075)
			end
			if at <= 17 then
				helper_c3ce9c48(2300080)
			end
			if at <= 18 then
				helper_f90fbb97(2300090, 240)
			end
			if at <= 19 then
				helper_c3ce9c48(2300100)
			end
			if at <= 20 then
				helper_e2d04ed9(2)
			end
			if at <= 21 then
				helper_c3ce9c48(2300110)
			end
			if at <= 22 then
				helper_c3ce9c48(2300120)
			end
			if at <= 23 then
				helper_ed0a80b8(27)
			end
			if at <= 24 then
				helper_ed0a80b8(31)
			end
			if at <= 25 then
				helper_c3ce9c48(2300130)
			end
			if at <= 26 then
				helper_c3ce9c48(2300135)
			end
			if at <= 27 then
				helper_ed0a80b8(10)
			end
			if at <= 28 then
				helper_c3ce9c48(2300140)
			end
			if at <= 29 then
				helper_e2d04ed9(1)
			end
			if at <= 30 then
				helper_c3ce9c48(2300150)
			end
			if at <= 31 then
				helper_ed0a80b8(24)
			end
			if at <= 32 then
				helper_c3ce9c48(2300160)
			end
			if at <= 33 then
				helper_c3ce9c48(2300170)
			end
			if at <= 34 then
				helper_e2d04ed9(1)
			end
			if at <= 35 then
				helper_ed0a80b8(15)
			end
			if at <= 36 then
				helper_c3ce9c48(2300180)
			end
			if at <= 37 then
				helper_c3ce9c48(2300190)
			end
			if at <= 38 then
				helper_c3ce9c48(2300200)
			end
			if at <= 39 then
				helper_ed0a80b8(17)
			end
			if at <= 40 then
				helper_c3ce9c48(2300210)
			end
			if at <= 41 then
				helper_e2d04ed9(0)
			end
			if at <= 42 then
				helper_c3ce9c48(2300220)
			end
			if at <= 43 then
				helper_c3ce9c48(2300225)
			end
			if at <= 44 then
				helper_c3ce9c48(2300230)
			end
			if at <= 45 then
				helper_e2d04ed9(1)
			end
			if at <= 46 then
				helper_c3ce9c48(2300240)
			end
			if at <= 47 then
				helper_e2d04ed9(0)
			end
			if at <= 48 then
				helper_c3ce9c48(2300250)
			end
			if at <= 49 then
				helper_c3ce9c48(2300260)
			end
			if at <= 50 then
				helper_ed0a80b8(17)
			end
			if at <= 51 then
				helper_c3ce9c48(2300270)
			end
			if at <= 52 then
				helper_e2d04ed9(1)
			end
			if at <= 53 then
				helper_ed0a80b8(30)
			end
			if at <= 54 then
				helper_f90fbb97(2300280, 150)
			end
			if at <= 55 then
				helper_ed0a80b8(45)
			end
			if vm.skip_end() then
				return skip(57)
			end
			return part2()
		end
		helper_125bc()
	end
	function part2()
		event.CancelDramaScene()
		event.ObjsInit(0)
		event.ObjsInit(1)
		helper_125bc()
		event.CharaActive(1, 8)
		event.SetMotion(0, "立ち")
		event.SetCharaPos(0, -1312.2, -15.78, 671.41)
		event.SetCharaRot(0, 0.0, 2.28, 0.0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.StopBgm(0)
		event.SetFadeIn(30)
		event.ResetCamera(1, 0.0, 20.0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(230, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 0)
	event.LoadSound(2806)
	var1 = event.SndLoadSound(2806) or var1
	helper_12948()
	event.CharaActive(0, 8)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.StopBgm(0)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(108)
	event.PlayBgm(0)
	event.InitDramaScene()
	event.CharaActive(1, 34)
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.CharaActive(1, 40)
	event.CharaActive(1, 41)
	event.ObjsSetPos(2, -1968.66, 0.4, 1106.69)
	event.ObjsSetRot(2, 0.0, 2.32, 0.0)
	event.SetCharaPos(38, -1923.31, 1.37, 1057.48)
	event.SetCharaRot(38, 3.1415927, 0.0, 0.0)
	event.SetCharaPos(39, -1919.91, 1.37, 1053.89)
	event.SetCharaPos(40, -1919.01, 1.37, 1057.56)
	event.SetCharaPos(41, -1925.65, 1.37, 1055.86)
	event.SetCharaRot(39, 3.1415927, 0.0, 0.0)
	event.SetCharaRot(40, 3.1415927, 0.0, 0.0)
	event.SetCharaRot(41, 3.1415927, 0.0, 0.0)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.SetFadeIn(30)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(180)
	event.CmrsAddPas(-1867.73, 11.94, 1125.15, -1943.18, 24.02, 1082.8)
	event.CmrsAddPas(-1857.2, 11.94, 1093.33, -1943.18, 24.02, 1082.8)
	event.CmrsAddPas(-1857.15, 11.94, 1072.13, -1943.18, 24.02, 1082.8)
	event.CmrsAddPas(-1864.74, 11.94, 1045.69, -1943.18, 24.02, 1082.8)
	event.CmrsAddPas(-1881.33, 11.94, 1021.81, -1943.18, 24.02, 1082.8)
	event.CmrsAddPas(-1901.11, 11.94, 1006.72, -1943.18, 24.02, 1082.8)
	event.CmrsAddPas(-1932.2, 11.94, 996.46, -1943.18, 24.02, 1082.8)
	event.CmrsAddPas(-1940.25, 11.94, 995.79, -1943.18, 24.02, 1082.8)
	event.CmrsStartPas()
	helper_ed0a80b8(150)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(0, 0, 30)
	event.CmrsInit()
	event.CmrsSetPos(-1733.89, 14.82, 832.21)
	event.CmrsSetRef(-1680.25, 22.42, 836.47)
	event.ObjsSetPos(0, -1681.29, 0.4, 845.23)
	event.ObjsSetRot(0, 0.0, -1.04, 0.0)
	event.ObjsSetPos(1, -1693.53, 0.4, 827.18)
	event.ObjsSetRot(1, 0.0, -0.84, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300010)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右向く", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右向くL", 0)
	helper_ed0a80b8(17)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2300020)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "左向くL", 0)
	helper_ed0a80b8(17)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向く戻り", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_ed0a80b8(9)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "右向く戻り", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300040)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "走り", 0)
	event.ObjsSetMotion(1, "走り", 0)
	event.ObjsMove(0, -1707.23, 0.4, 923.25, 45)
	event.ObjsMove(1, -1730.82, 0.4, 869.79, 20)
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(12)
	end
	event.SetCrossfade(30)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CmrsSetPos(-1942.18, 117.19, 1202.58)
	event.CmrsSetRef(-1947.7, 30.54, 1110.87)
	event.ObjsSetPos(0, -1786.46, 0.4, 1010.21)
	event.ObjsSetRot(0, 0.0, -1.04, 0.0)
	event.ObjsSetPos(1, -1833.95, 0.4, 966.71)
	event.ObjsSetRot(1, 0.0, -0.84, 0.0)
	event.ObjsMove(0, -1898.83, 0.4, 1075.37, 45)
	event.ObjsMove(1, -1912.91, 0.4, 1046.41, 30)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "立ち", 0)
	event.ObjsMotionDelay(1, 6)
	event.ObjsSetMotion(1, "上向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "上向くL", 0)
	helper_ed0a80b8(45)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "立ち", 0)
	event.ObjsMotionDelay(0, 6)
	event.ObjsSetMotion(0, "上向く", 6, -1.0, 1)
	event.ObjsSetMotion(0, "上向くL", 0)
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300050)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "座り会話", 2)
	event.ObjsNextMotion(2, "E230座り", 0)
	event.SetPakuMotion(2, "会話２", 0, "E230座り", 0)
	helper_c3ce9c48(2300060)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuMotion()
	event.SetPakuMotion(2, "会話２", 0, "E230座り", 0)
	helper_c3ce9c48(2300070)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuMotion()
	event.SetPakuMotion(2, "会話２", 0, "E230座り", 0)
	helper_c3ce9c48(2300075)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(2, "E230座り", 0)
	event.CmrsSetPos(-1884.57, 13.71, 1027.61)
	event.CmrsSetRef(-1927.88, 26.89, 1070.06)
	event.ObjsSetPos(0, -1903.73, 0.4, 1060.72)
	event.ObjsSetRot(0, 0.0, -0.8, 0.0)
	event.ObjsSetPos(1, -1920.27, 0.4, 1046.47)
	event.ObjsSetRot(1, 0.0, -0.72, 0.0)
	event.ObjsSetPos(2, -1968.66, 0.4, 1106.69)
	event.ObjsSetRot(2, 0.0, 2.32, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300080)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "会話２", 4)
	event.SetPakuMotion(2, "会話２", 0, "会話２", 0)
	helper_f90fbb97(2300090, 240)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuMotion()
	event.SetPakuMotion(2, "会話２", 0, "E230座り", 0)
	helper_c3ce9c48(2300100)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuMotion()
	event.ObjsSetMotion(2, "しょぼくれ入り", 6)
	event.ObjsNextMotion(2, "しょぼくれ", 4)
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuMotion(2, "しょぼくれ会話２", 0, "しょぼくれ", 0)
	helper_c3ce9c48(2300110)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuMotion()
	event.SetPakuMotion(2, "しょぼくれ会話２", 0, "しょぼくれ", 0)
	helper_c3ce9c48(2300120)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuMotion()
	event.CmrsSetPos(-1923.34, 17.33, 1025.86)
	event.CmrsSetRef(-1883.4, 21.14, 1020.69)
	event.ObjsSetPos(0, -1868.48, 0.4, 1031.7)
	event.ObjsSetRot(0, 0.0, -0.68, 0.0)
	event.ObjsSetPos(1, -1885.77, 0.4, 1014.51)
	event.ObjsSetRot(1, 0.0, -0.84, 0.0)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(var1, 4)
	event.ObjsSetMotion(1, "りんご取り", 6, -1.0, 1)
	event.ObjsNextMotion(1, "りんご取りＬ", 0)
	helper_ed0a80b8(27)
	if vm.skipping() then
		return skip(24)
	end
	event.SetCharaPos(38, 0.0, 0.0, 0.0)
	event.SetCharaRot(38, 0.0, 0.0, 0.0)
	event.SetReference(global1, "item", 38)
	helper_ed0a80b8(31)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "上見から右見", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300130)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300135)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	event.ObjsMotionDelay(0, 15)
	event.ObjsSetMotion(0, "右見から上見", 6)
	event.ObjsNextMotion(0, "上見L", 4)
	event.ObjsSetMotion(1, "りんご持ち上見", 6)
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(1, "りんご持ち上見会話", 2)
	event.ObjsNextMotion(1, "りんご持ち上見Ｌ", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2300140)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(30)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300150)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, global0)
	event.CharaActive(0, 38)
	event.CmrsSetPos(-1942.18, 117.19, 1202.58)
	event.CmrsSetRef(-1947.7, 30.54, 1110.87)
	event.ObjsSetPos(0, -1892.68, 0.4, 1074.49)
	event.ObjsSetRot(0, 0.0, -0.92, 0.0)
	event.ObjsSetPos(1, -1906.2, 0.4, 1049.58)
	event.ObjsSetRot(1, 0.0, -0.84, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "しょぼくれ戻り", 6)
	event.ObjsNextMotion(2, "会話２", 0)
	helper_ed0a80b8(24)
	if vm.skipping() then
		return skip(32)
	end
	helper_c3ce9c48(2300160)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(2, "E230座り", 0)
	event.ObjsSetMotion(1, "上向く会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "上向くL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300170)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(35)
	end
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(0, "上見から右見", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "上見から左見", 6, -1.0, 1)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2300180)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300190)
	if vm.skipping() then
		return skip(38)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300200)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右見から上見", 6, -1.0, 1)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "左見から上見", 6, -1.0, 1)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_ed0a80b8(17)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetMotion(0, "上向く会話", 6, -1.0, 1)
	event.ObjsNextMotion(0, "上向くL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2300210)
	if vm.skipping() then
		return skip(41)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsResetMotion(2)
	event.CmrsSetPos(-1885.94, 10.87, 1032.57)
	event.CmrsSetRef(-1896.84, 16.33, 1042.04)
	event.ObjsSetPos(0, -1903.73, 0.4, 1060.72)
	event.ObjsSetRot(0, 0.0, -1.04, 0.0)
	event.ObjsSetPos(1, -1920.27, 0.4, 1046.47)
	event.ObjsSetRot(1, 0.0, -0.6, 0.0)
	event.ObjsSetPos(2, -1949.25, 0.4, 1088.25)
	event.ObjsSetRot(2, 0.0, 2.32, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsResetDaPosition(1)
	event.ObjsNextMotion(2, "E230座り", 4)
	event.SetPakuMotion(2, "会話２", 0, "E230座り", 0)
	helper_c3ce9c48(2300220)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuMotion()
	event.SetPakuMotion(2, "会話２", 0, "E230座り", 0)
	helper_c3ce9c48(2300225)
	if vm.skipping() then
		return skip(44)
	end
	event.ResetPakuMotion()
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "上見から右見", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSetMotion(1, "上見から左見", 6)
	event.ObjsNextMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300230)
	if vm.skipping() then
		return skip(45)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsSetMotion(0, "右向くうなづき", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2300240)
	if vm.skipping() then
		return skip(47)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsSetMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2300250)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右向く会話", 2)
	event.ObjsNextMotion(0, "右向くL", 0)
	event.SetPakuAnim(0, "わらい口パク")
	helper_c3ce9c48(2300260)
	if vm.skipping() then
		return skip(50)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右見から上見", 6, -1.0, 1)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "左見から上見", 6, -1.0, 1)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_ed0a80b8(17)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsMotionDelay(1, 15)
	event.ObjsSetMotion(1, "上見から手振り", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2300270)
	if vm.skipping() then
		return skip(52)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 1.72, 0.0, 10)
	event.ObjsPosDelay(0, 10)
	event.ObjsMove(0, -1836.7, 0.4, 1123.98, 45)
	event.ObjsRotation(1, 0.0, 1.32, 0.0, 10)
	event.ObjsPosDelay(1, 10)
	event.ObjsMove(1, -1795.02, 0.4, 1063.66, 45)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCrossfade(0, 0, 30)
	event.CmrsSetPos(-2077.67, 91.91, 1212.19)
	event.CmrsSetRef(-1941.66, 59.01, 1088.55)
	event.ObjsSetPos(0, -1492.98, 0.4, 782.07)
	event.ObjsSetRot(0, 0.0, 2.2, 0.0)
	event.ObjsSetPos(1, -1531.9, 0.4, 770.09)
	event.ObjsSetRot(1, 0.0, 2.28, 0.0)
	event.ObjsSetPos(2, -1968.66, 0.4, 1106.69)
	event.ObjsSetRot(2, 0.0, 2.32, 0.0)
	event.ObjsMove(0, -418.74, 0.01, -210.33, 400, 1)
	event.ObjsMove(1, -432.44, 0.01, -245.86, 400, 1)
	event.SndSePlay(var1, 5)
	event.ObjsSetMotion(2, "手をふる入り", 6)
	event.ObjsNextMotion(2, "手をふるL", 0)
	helper_f90fbb97(2300280, 150)
	if vm.skipping() then
		return skip(55)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ed0a80b8(45)
	if vm.skipping() then
		return skip(56)
	end
	return part2()
end

--- Helper function.
local function helper_19330()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e235/e235_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e235/e235_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e235/e235_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e235/e235_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadMes(0, 5, "event/e200/e235/e235_1.txt")
end

--- Helper function.
local function helper_19058()
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
end

--- Helper function.
local function helper_19f8c()
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_19330()
				helper_ed0a80b8(17)
			end
			if at <= 2 then
				helper_f90fbb97(2350010, 120)
			end
			if at <= 3 then
				helper_f90fbb97(2350020, 75)
			end
			if at <= 4 then
				helper_f90fbb97(2350030, 165)
			end
			if at <= 5 then
				helper_f90fbb97(2350035, 135)
			end
			if at <= 6 then
				helper_f90fbb97(2350040, 150)
			end
			if at <= 7 then
				helper_c3ce9c48(2350050)
			end
			if at <= 8 then
				helper_b8f871c8(0, -1, 5, 0, 0)
			end
			if at <= 9 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		helper_19058()
	end
	function part2()
		event.CancelDramaScene()
		helper_19058()
		event.CmrsInit()
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(235, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var1 = event.SndLoadSound(2809) or var1
	helper_19330()
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsSetPos(-157.76, 19.55, -353.69)
	event.CmrsSetRef(-44.18, 22.24, -324.2)
	event.ObjsSetPos(0, -57.08, 0.0, -322.16)
	event.ObjsSetRot(0, 0.0, -3.02, 0.0)
	event.ObjsSetPos(1, -23.8, 0.0, -319.29)
	event.ObjsSetRot(1, 0.0, 2.92, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetFadeIn(30)
	event.CmrsMoveAhd2(1.79, -2.69, 122.7, 555, 2, 0.4)
	event.ObjsSetMotion(1, "左向く", 6, -1.0, 1)
	helper_ed0a80b8(17)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_f90fbb97(2350010, 120)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "半口顔")
	event.ObjsTexAnime(0, 1, "通常～おどろき目")
	event.SndSePlay(var1, 4)
	event.ObjsSetMotion(0, "驚く", 6, -1.0, 1)
	event.ObjsNextMotion(0, "驚くL", 0)
	event.SetPakuAnim(0, "大口パク")
	helper_f90fbb97(2350020, 75)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向く会話", 2)
	event.ObjsNextMotion(1, "左向くL", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_f90fbb97(2350030, 165)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_f90fbb97(2350035, 135)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "ユリス見会話", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_f90fbb97(2350040, 150)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "驚くL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2350050)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]Equipa la Ca[UNI00f1]a de pescar y pulsa el bot[UNI00f3]n (O)\npara lanzar el anzuelo. Consulta Pescar en el\nmen[UNI00fa] Principal para m[UNI00e1]s informaci[UNI00f3]n."
	)
	helper_b8f871c8(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1b4e8(arg0: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e247/e247_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e247/e247_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e247/e247_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e247/e247_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e247/e247_noam.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.EohSetSoundId(2, arg0)
	event.LoadChara(5, "event/e200/e247/e247_zak.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 35)
	event.EohSetSoundId(3, arg0)
	event.LoadChara(5, "event/e200/e247/e247_wicky.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(0, 36)
	event.EohSetSoundId(4, arg0)
	event.LoadChara(5, "event/e200/e247/e247_mogri.gltf", "info", 38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.CharaActive(0, 38)
	event.EohSetSoundId(6, arg0)
	event.LoadMes(0, 5, "event/e200/e247/e247_1.txt")
end

--- Helper function.
local function helper_1b180()
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
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(38)
end

--- Helper function.
local function helper_1c684()
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				helper_1b4e8(var1)
				helper_ed0a80b8(4)
			end
			if at <= 2 then
				helper_c3ce9c48(2470010)
			end
			if at <= 3 then
				helper_c3ce9c48(2470020)
			end
			if at <= 4 then
				helper_f90fbb97(2470030, 150)
			end
			if at <= 5 then
				helper_f90fbb97(2470040, 210)
			end
			if at <= 6 then
				helper_f90fbb97(2470050, 165)
			end
			if at <= 7 then
				helper_f90fbb97(2470060, 150)
			end
			if at <= 8 then
				helper_c3ce9c48(2470070)
			end
			if at <= 9 then
				helper_c3ce9c48(2470080)
			end
			if at <= 10 then
				helper_c3ce9c48(2470090)
			end
			if at <= 11 then
				helper_e2d04ed9(1)
			end
			if at <= 12 then
				helper_e2d04ed9(1)
			end
			if at <= 13 then
				helper_c3ce9c48(2470100)
			end
			if at <= 14 then
				helper_c3ce9c48(2470110)
			end
			if at <= 15 then
				helper_c3ce9c48(2470120)
			end
			if at <= 16 then
				helper_c3ce9c48(2470130)
			end
			if at <= 17 then
				helper_b8f871c8(0, -1, 8, 0, 0)
			end
			if at <= 18 then
				helper_b8f871c8(0, -1, 8, 0, 0)
			end
			if at <= 19 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
		helper_1b180()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_1b180()
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(247, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(2818)
	var1 = event.SndLoadSound(2818) or var1
	helper_1b4e8(var1)
	event.StopBgm(0)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(57)
	event.PlayBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.CharaActive(1, 36)
	event.CharaActive(1, 38)
	event.SetFadeIn(30)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CmrsSetPos(1719.11, 34.0, 714.02)
	event.CmrsSetRef(1739.12, 27.98, 727.37)
	event.ObjsSetPos(0, 1738.32, 0.01, 741.82)
	event.ObjsSetRot(0, 0.0, 1.25, 0.0)
	event.ObjsSetPos(1, 1748.79, 0.01, 715.17)
	event.ObjsSetRot(1, 0.0, 0.6, 0.0)
	event.ObjsSetPos(2, 1967.41, 0.01, 873.54)
	event.ObjsSetRot(2, 0.0, -2.16, 0.0)
	event.ObjsSetPos(3, 2381.04, 0.0, 1078.89)
	event.ObjsSetRot(3, 0.0, -2.04, 0.0)
	event.ObjsSetPos(4, 2381.04, 0.0, 1078.89)
	event.ObjsSetRot(4, 0.0, -2.04, 0.0)
	event.ObjsSetPos(6, 2381.04, 0.0, 1078.89)
	event.ObjsSetRot(6, 0.0, -2.04, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "立ち", 0)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "立ち", 0)
	event.ObjsSetMotion(2, "走り", 4)
	event.ObjsMotionDelay(2, 45)
	event.ObjsSetMotion(2, "立ち", 0)
	event.ObjsMove(0, 1773.43, 0.01, 763.65, 30)
	event.ObjsMove(1, 1786.54, 0.01, 743.76, 30)
	event.ObjsMove(2, 1831.97, 0.01, 787.95, 45)
	helper_c3ce9c48(2470010)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2470020)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsSetMotion(6, "走り", 4)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 150)
	event.ObjsAddPas(3, 2381.04, 0.0, 1078.89)
	event.ObjsAddPas(3, 2331.11, 0.0, 1116.22)
	event.ObjsAddPas(3, 2116.36, 0.0, 997.42)
	event.ObjsAddPas(3, 1848.69, 0.0, 775.64)
	event.ObjsStartPas(3)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 150)
	event.ObjsAddPas(4, 2381.04, 0.0, 1078.89)
	event.ObjsAddPas(4, 2276.7, 0.0, 1082.34)
	event.ObjsAddPas(4, 2018.28, 0.0, 933.17)
	event.ObjsAddPas(4, 1844.97, 0.01, 795.34)
	event.ObjsStartPas(4)
	event.ObjsInitPas(6)
	event.ObjsSetPasFrm(6, 150)
	event.ObjsAddPas(6, 2381.04, 0.0, 1078.89)
	event.ObjsAddPas(6, 2201.8, 0.0, 1064.29)
	event.ObjsAddPas(6, 1826.14, 0.01, 815.65)
	event.ObjsStartPas(6)
	helper_f90fbb97(2470030, 150)
	if vm.skipping() then
		return skip(5)
	end
	event.CharaActive(0, 34)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(3, 1848.69, 0.0, 775.64)
	event.ObjsSetPos(4, 1844.97, 0.01, 795.34)
	event.ObjsSetPos(6, 1826.14, 0.01, 815.65)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetMotion(6, "立ち", 4)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(525)
	event.CmrsAddPas(1821.21, 20.38, 744.56, 1849.75, 16.15, 775.36)
	event.CmrsAddPas(1809.08, 20.38, 774.26, 1843.57, 16.15, 793.85)
	event.CmrsAddPas(1787.87, 20.38, 816.77, 1829.31, 16.15, 811.65)
	event.CmrsStartPas()
	event.ObjsSetMotion(3, "会話", 2)
	event.ObjsNextMotion(3, "立ち", 0)
	event.MesMake_2(0, 2470040)
	event.SetPakuAnim(3, "口パク")
	helper_f90fbb97(2470040, 210)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(4, "会話", 2)
	event.ObjsNextMotion(4, "立ち", 0)
	event.MesMake_2(0, 2470050)
	event.SetPakuAnim(4, "口パク")
	helper_f90fbb97(2470050, 165)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(6, "会話", 2)
	event.ObjsNextMotion(6, "立ち", 0)
	event.MesMake_2(0, 2470060)
	event.SetPakuAnim(6, "口パク")
	helper_f90fbb97(2470060, 150)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.CmrsInit()
	event.CharaActive(1, 34)
	event.CmrsSetPos(1872.03, 33.39, 840.77)
	event.CmrsSetRef(1841.2, 22.59, 805.7)
	event.ObjsSetRot(0, 0.0, 0.89, 0.0)
	event.ObjsSetPos(2, 1830.92, 0.01, 806.7)
	event.ObjsSetRot(2, 0.0, -2.4, 0.0)
	event.ObjsSetRot(3, 0.0, -2.05, 0.0)
	event.ObjsSetRot(4, 0.0, -2.27, 0.0)
	event.ObjsSetPos(6, 1814.28, 0.01, 811.77)
	event.ObjsSetRot(6, 0.0, -2.72, 0.0)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2470070)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "会話", 2)
	event.ObjsNextMotion(3, "立ち", 0)
	event.SetPakuAnim(3, "口パク")
	helper_c3ce9c48(2470080)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "ゆびさし", 6)
	event.ObjsNextMotion(1, "ゆびさしＬ", 0)
	event.ObjsMotionDelay(1, 45)
	event.ObjsSetMotion(1, "ゆびさしＬから立ち", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2470090)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(12)
	end
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(1733.66, 30.77, 725.75)
	event.CmrsSetRef(1802.53, 17.99, 768.87)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsSetMotion(6, "会話", 2)
	event.ObjsNextMotion(6, "立ち", 0)
	event.SetPakuAnim(6, "口パク")
	helper_c3ce9c48(2470100)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(4, "会話", 2)
	event.ObjsNextMotion(4, "立ち", 0)
	event.SetPakuAnim(4, "口パク")
	helper_c3ce9c48(2470110)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 0)
	helper_c3ce9c48(2470120)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 0)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2470130)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	var2 = event.GetMesWindowMode(0) or var2
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]Deber[UNI00ed]as volver a Sindain por un tiempo.\n Se sale igual que se entra\no bien se puede seleccionar Salir de Mazmorra\nen el apartado Movimiento del men[UNI00fa] Principal."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.MesMake_2(
		0,
		"[(!)]Si no hay monstruos en la zona,\nno perder[UNI00e1]s dinero al seleccionar\nSalir de Mazmorra."
	)
	helper_b8f871c8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMesWindowMode(0, var2)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

--- Helper function.
local function helper_1f664()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e253/e253_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e253/e253_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e253/e253_utan.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(1, 34)
	event.LoadChara(5, "event/e200/e253/e253_rock.gltf", "info", 35)
	event.EohSyncChara(6, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 6)
	event.CharaActive(1, 35)
	event.SetCharaPos(35, -2303.34, 38.0002, 629.104)
	event.SetCharaRot(35, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p05_s0501", "s050111-m0")
	event.EohSetPos(3, -2303.34, 38.0002, 629.104)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p05_s0501", "s050102-a")
	event.EohSetPos(4, -2303.34, 38.0002, 629.104)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p05_s0501", "s050102-c")
	event.EohSetPos(5, -2303.34, 38.0002, 629.104)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetShow(3, 0)
	event.LoadMes(0, 5, "event/e200/e253/e253_1.txt")
end

--- Helper function.
local function helper_1f344()
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
	event.DeleteChara(34)
	event.DeleteChara(35)
end

--- Helper function.
local function helper_207ac()
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 30 then
			if at <= 1 then
				helper_1f664()
				helper_c3ce9c48(2530010)
			end
			if at <= 2 then
				helper_c3ce9c48(2530020)
			end
			if at <= 3 then
				helper_c3ce9c48(2530030)
			end
			if at <= 4 then
				helper_c3ce9c48(2530040)
			end
			if at <= 5 then
				helper_c3ce9c48(2530050)
			end
			if at <= 6 then
				helper_c3ce9c48(2530060)
			end
			if at <= 7 then
				helper_ed0a80b8(34)
			end
			if at <= 8 then
				helper_c3ce9c48(2530070)
			end
			if at <= 9 then
				helper_e2d04ed9(1)
			end
			if at <= 10 then
				helper_c3ce9c48(2530080)
			end
			if at <= 11 then
				helper_e2d04ed9(2)
			end
			if at <= 12 then
				helper_ed0a80b8(48)
			end
			if at <= 13 then
				helper_ed0a80b8(75)
			end
			if at <= 14 then
				helper_ed0a80b8(10)
			end
			if at <= 15 then
				helper_ed0a80b8(27)
			end
			if at <= 16 then
				helper_ed0a80b8(30)
			end
			if at <= 17 then
				helper_c3ce9c48(2530090)
			end
			if at <= 18 then
				helper_ed0a80b8(45)
			end
			if at <= 19 then
				helper_c3ce9c48(2530100)
			end
			if at <= 20 then
				helper_f90fbb97(2530110, -1)
			end
			if at <= 21 then
				helper_c3ce9c48(2530115)
			end
			if at <= 22 then
				helper_c3ce9c48(2530120)
			end
			if at <= 23 then
				helper_90317de2(2530130, -1, 15)
			end
			if at <= 24 then
				helper_ed0a80b8(6)
			end
			if at <= 25 then
				helper_ed0a80b8(15)
			end
			if at <= 26 then
				helper_c3ce9c48(2530140)
			end
			if at <= 27 then
				helper_e2d04ed9(1)
			end
			if at <= 28 then
				helper_c3ce9c48(2530150)
			end
			if at <= 29 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(31)
			end
			return part2()
		end
		helper_1f344()
	end
	function part2()
		event.CancelDramaScene()
		helper_1f344()
		event.SetCharaPos(0, -2114.19, 0.4, 672.39)
		event.SetCharaRot(0, 0.0, -1.34, 0.0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(253, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var1 = event.SndLoadSound(2821) or var1
	helper_1f664()
	event.EohSetSoundId(2, var1)
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CmrsSetPos(-1983.77, 35.19, 702.93)
	event.CmrsSetRef(-2025.3, 34.91, 704.63)
	event.ObjsSetPos(0, -2102.17, 0.4, 705.62)
	event.ObjsSetRot(0, 0.0, -0.86, 0.0)
	event.ObjsSetPos(1, -2119.98, 0.4, 680.76)
	event.ObjsSetRot(1, 0.0, -0.6, 0.0)
	event.ObjsSetPos(2, -2202.71, 0.4, 759.61)
	event.ObjsSetRot(2, 0.0, 2.16, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	helper_c3ce9c48(2530010)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2530020)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuMotion(2, "立ち会話２", 0, "立ち", 0)
	helper_c3ce9c48(2530030)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuMotion()
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2530040)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2530050)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	helper_c3ce9c48(2530060)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 0)
	helper_ed0a80b8(34)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2530070)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var1, 6)
	event.ObjsSetMotion(2, "左見る入り", 6)
	event.ObjsNextMotion(2, "左見るＬ", 0)
	helper_c3ce9c48(2530080)
	if vm.skipping() then
		return skip(11)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(2, "左見る戻り", 6)
	event.ObjsNextMotion(2, "歩き", 0)
	helper_ed0a80b8(48)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsRotation(2, 0.0, -2.55, 0.0, 25)
	event.ObjsMove(2, -2250.46, 0.4, 692.44, 75)
	helper_ed0a80b8(75)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(2, "立ち", 0)
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var1, 8)
	event.ObjsSetMotion(2, "岩触れる入り", 6)
	event.ObjsNextMotion(2, "岩触れる入りL", 0)
	helper_ed0a80b8(27)
	if vm.skipping() then
		return skip(16)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(34)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CharaActive(1, 35)
	event.SetCharaPos(35, 0.0, 0.0, 0.0)
	event.SetCharaRot(35, 0.0, 0.0, 0.0)
	event.SetReference(34, "rock_null", 35)
	event.SndSePlay(var1, 9)
	event.ObjsSetMotion(2, "岩持ち上げ", 6)
	event.ObjsNextMotion(2, "岩持ち上げL", 0)
	helper_c3ce9c48(2530090)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-2034.58, 17.54, 697.44)
	event.CmrsSetRef(-2146.5, 38.21, 676.58)
	event.ObjsSetPos(0, -2114.19, 0.4, 672.39)
	event.ObjsSetRot(0, 0.0, -1.34, 0.0)
	event.ObjsSetPos(1, -2118.22, 0.4, 650.68)
	event.ObjsSetRot(1, 0.0, -1.44, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "岩持ち歩き", 4)
	event.ObjsRotation(2, 0.0, 1.81, 0.0, 45)
	helper_ed0a80b8(45)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(2, "岩持ち上げL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2530100)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "岩持ち会話", 0)
	helper_f90fbb97(2530110, -1)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var1, 10)
	event.ObjsSeDelay(3, 15)
	event.ObjsSePlay(3, var1, 11)
	event.ObjsSetMotion(2, "腰痛める", 6)
	event.ObjsNextMotion(2, "腰痛めるL", 0)
	do
		local out1, out2, out3 = event.EohGetFramePos(2, "rock_null")
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	event.DelReference(35)
	event.ObjsSetPos(3, var2, var3, var4)
	event.ObjsJump(3, -2343.99, 35.68, 691.66, -1.0, 15)
	event.ObjsJump(3, -2343.99, 35.68, 691.66, -0.05, 25)
	event.CmrsQuakeDelay(15)
	event.CmrsQuake(0.0, 0.3, 0.0, 15)
	helper_c3ce9c48(2530115)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2530120)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "腰痛め会話", 0)
	helper_90317de2(2530130, -1, 15)
	if vm.skipping() then
		return skip(24)
	end
	event.SndSePlay(var1, 13)
	event.ObjsSetMotion(2, "座り入り", 6)
	event.ObjsNextMotion(2, "座り", 0)
	helper_ed0a80b8(6)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "上向く戻り", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "上向く戻り", 2)
	event.ObjsNextMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2530140)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(0, "手を振る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_c3ce9c48(2530150)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(30)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 501.
script[501] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13a10()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_92f52aa8()
		end
	end
	function part2()
		argc = event.GetItemNum(302) or argc
		if argc ~= 0 then
			event.SetCnt(3, 3)
		end
		helper_92f52aa8()
		if vm.wait() then
			return skip(3)
		end
		event.LoadScript("s05/s05_1.stb", -1)
	end
	event.Initialize()
	print("kits--------------------\n")
	event.SetMotion(0, "立ち")
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_13a10()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_19f8c()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_92f52aa8()
		end
	end
	function part2()
		event.SetCnt(3, 4)
		helper_92f52aa8()
		if vm.wait() then
			return skip(3)
		end
		event.LoadScript("s05/s05_1.stb", -1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_19f8c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1c684()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		if vm.wait() then
			return skip(3)
		end
		event.LoadScript("s05/s05_1.stb", -1)
	end
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.SetCnt(3, 7)
	helper_92f52aa8()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_1c684()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1451869a()
			helper_207ac()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_92f52aa8()
			helper_cf67b418(0)
		end
	end
	function part2()
		event.SetCnt(3, 8)
		helper_92f52aa8()
		helper_cf67b418(0)
		if vm.wait() then
			return skip(3)
		end
		event.LoadScript("s05/s05_1.stb", -1)
	end
	event.SetMotion(0, "立ち")
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_1451869a()
	helper_207ac()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
