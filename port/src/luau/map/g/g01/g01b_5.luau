--!strict
-- map/g/g01/g01b_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_be50c541 = require("@lib/event/helper_be50c541")
local helper_c3ce9c48 = require("@lib/event/helper_c3ce9c48")
local helper_c758eb34 = require("@lib/event/helper_c758eb34")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_f90fbb97 = require("@lib/event/helper_f90fbb97")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Helper function.
local function helper_eaa0()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 9
		event.LoadMotion(5, "event/e200/e208/e208_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 37)
		event.LoadMotion(5, "event/e200/e208/e208_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global2 = 8
		global3 = 0
		event.LoadChara(5, "chara/c01_event.gltf", "info", global2)
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 37)
		event.LoadMotion(5, "event/e200/e208/e208_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e200/e208/e208_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
	end
	event.LoadChara(5, "event/e200/e208/e208_rococo.gltf", "info", 39)
	event.EohSyncChara(2, 39)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 39)
	event.EohSyncEditObj(6, "p01_g010701", "g010707-m")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 6)
	event.ObjsSetPos(10, 1.0461, 59.1891, 78.8974)
	event.ObjsSetRot(10, 0.0, 1.5707964, 0.0)
	event.EohSyncEditObj(7, "p01_g010701", "g010708-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 7)
	event.ObjsSetPos(11, 1.0461, 59.1891, 78.8974)
	event.ObjsSetRot(11, 0.0, 1.5707964, 0.0)
	event.LoadMes(0, 5, "event/e200/e208/e208_1.txt")
end

--- Helper function.
local function helper_e720()
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
		event.CharaActive(0, 39)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global3)
		event.DeleteChara(39)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global3)
		event.CharaActive(0, global2)
		event.CharaActive(0, 39)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global2)
		event.DeleteChara(39)
		event.DeleteChara(37)
	end
end

--- Helper function.
local function helper_f940()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 48 then
			if at <= 2 then
				helper_be50c541()
			end
			if at <= 3 then
				helper_ed0a80b8(45)
			end
			if at <= 4 then
				helper_c3ce9c48(2080010)
			end
			if at <= 5 then
				helper_c3ce9c48(2080020)
			end
			if at <= 6 then
				helper_c3ce9c48(2080025)
			end
			if at <= 7 then
				helper_c3ce9c48(2080030)
			end
			if at <= 8 then
				helper_e2d04ed9(0)
			end
			if at <= 9 then
				helper_ed0a80b8(45)
			end
			if at <= 10 then
				helper_ed0a80b8(30)
			end
			if at <= 11 then
				helper_ed0a80b8(30)
			end
			if at <= 12 then
				helper_c3ce9c48(2080040)
			end
			if at <= 13 then
				helper_c3ce9c48(2080050)
			end
			if at <= 14 then
				helper_e2d04ed9(2)
			end
			if at <= 15 then
				helper_ed0a80b8(57)
			end
			if at <= 16 then
				helper_ed0a80b8(24)
			end
			if at <= 17 then
				helper_c3ce9c48(2080060)
			end
			if at <= 18 then
				helper_c3ce9c48(2080070)
			end
			if at <= 19 then
				helper_e2d04ed9(2)
			end
			if at <= 20 then
				helper_ed0a80b8(9)
			end
			if at <= 21 then
				helper_c3ce9c48(2080080)
			end
			if at <= 22 then
				helper_e2d04ed9(1)
			end
			if at <= 23 then
				helper_ed0a80b8(15)
			end
			if at <= 24 then
				helper_c3ce9c48(2080090)
			end
			if at <= 25 then
				helper_c3ce9c48(2080100)
			end
			if at <= 26 then
				helper_c3ce9c48(2080110)
			end
			if at <= 27 then
				helper_c3ce9c48(2080120)
			end
			if at <= 28 then
				helper_f90fbb97(2080130, 45)
			end
			if at <= 29 then
				helper_f90fbb97(2080140, 45)
			end
			if at <= 30 then
				helper_e2d04ed9(1)
			end
			if at <= 31 then
				helper_ed0a80b8(40)
			end
			if at <= 32 then
				helper_c3ce9c48(2080150)
			end
			if at <= 33 then
				helper_e2d04ed9(2)
			end
			if at <= 34 then
				helper_ed0a80b8(16)
			end
			if at <= 35 then
				helper_f90fbb97(2080160, 95)
			end
			if at <= 36 then
				helper_f90fbb97(2080170, 60)
			end
			if at <= 37 then
				helper_e2d04ed9(2)
			end
			if at <= 38 then
				helper_ed0a80b8(20)
			end
			if at <= 39 then
				helper_ed0a80b8(27)
			end
			if at <= 40 then
				helper_ed0a80b8(27)
			end
			if at <= 41 then
				helper_ed0a80b8(6)
			end
			if at <= 42 then
				helper_ed0a80b8(15)
			end
			if at <= 43 then
				helper_ed0a80b8(16)
			end
			if at <= 44 then
				helper_c3ce9c48(2080180)
			end
			if at <= 45 then
				helper_ed0a80b8(16)
			end
			if at <= 46 then
				helper_c3ce9c48(2080190)
			end
			if at <= 47 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(49)
			end
			return part2()
		end
		if at <= 49 then
			helper_ed0a80b8(4)
		end
		helper_e720()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_ed0a80b8(4)
		if vm.skipping() then
			return skip(50)
		end
		event.LoadBgm(1)
		event.PlayBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeStop(var0, 8)
		event.ObjsSetRot(10, 0.0, 0.0, 0.0)
		event.ObjsSetRot(11, 0.0, 0.0, 0.0)
		event.SetCharaPos(0, pos_x + vm.f32(21.55), pos_y + 0.0, pos_z + vm.f32(189.06))
		event.SetCharaRot(0, 0.0, -3.0 + rot_y, 0.0)
		if vm.wait() then
			return skip(51)
		end
		helper_e720()
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(208, 1)
	event.Initialize()
	var0 = event.SndLoadSound(2214) or var0
	helper_eaa0()
	event.EohSetSoundId(1, var0)
	event.EohSetSoundId(2, var0)
	event.StopBgm(0)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(57)
	event.BgmPlayEnable()
	do
		local out1, out2, out3, out4 = event.GetEditPartsPos("p01_g010701")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
		rot_y = out4 or rot_y
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(2)
	end
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.CharaActive(0, 39)
	event.CmrsSetPos(386.32, 23.15, 869.55)
	event.CmrsSetRef(407.13, 22.85, 961.54)
	event.ObjsSetPos(0, 428.59, 0.01, 1007.54)
	event.ObjsSetRot(0, 0.0, -2.88, 0.0)
	event.ObjsSetPos(1, 410.85, 0.0, 1025.99)
	event.ObjsSetRot(1, 0.0, -3.0, 0.0)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.SetFadeIn(30)
	helper_be50c541()
	if vm.skipping() then
		return skip(3)
	end
	event.SetWorldCoord(pos_x, pos_y, pos_z, rot_y)
	event.CmrsSetPos(12.79, 48.44, 536.01)
	event.CmrsSetRef(3.61, 44.91, 229.8)
	event.ObjsSetPos(0, 15.98, -0.0, 422.01)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(1, -1.1, -0.0, 424.7)
	event.ObjsSetRot(1, 0.0, 3.04, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMove(0, 12.68, 0.0, 349.66, 45)
	event.ObjsMove(1, -3.27, 0.0, 352.5, 45)
	helper_ed0a80b8(45)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-9.39, 17.33, 317.74)
	event.CmrsSetRef(-1.99, 19.7, 331.6)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2080010)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2080020)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2080025)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2080030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetCrossfade(0, 0, 30)
	event.CharaActive(1, 39)
	event.CmrsSetPos(-288.44, 65.87, 235.41)
	event.CmrsSetRef(-153.47, 64.7, 159.38)
	event.ObjsSetPos(0, 7.3, 0.0, 211.56)
	event.ObjsSetPos(1, -11.34, 0.0, 212.58)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(0)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsSetMotion(2, "屋根の上", 4)
	event.ObjsMove(0, 7.38, 0.0, 180.67, 50)
	event.ObjsMove(1, -9.77, 0.0, 178.88, 45)
	helper_ed0a80b8(45)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-77.26, 129.5, 171.9)
	event.CmrsSetRef(13.69, 128.44, 66.47)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var0, 2)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-27.54, 22.23, 148.61)
	event.CmrsSetRef(1.89, 20.26, 180.45)
	event.ObjsSetMotion(0, "上を見る", 6)
	event.ObjsNextMotion(0, "上を見るL", 0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsMotionDelay(1, 15)
	event.ObjsSetMotion(1, "上を見る", 6)
	event.ObjsNextMotion(1, "上を見るL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2080040)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-19.03, 127.82, 124.37)
	event.CmrsSetRef(9.95, 135.93, 69.14)
	event.PlayBgm(0)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "起きる", 6)
	event.ObjsNextMotion(2, "起きるL", 0)
	event.SetPakuAnim(2, "口パク")
	helper_c3ce9c48(2080050)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-312.03, 58.57, 85.98)
	event.CmrsSetRef(-56.59, 65.39, 80.86)
	event.ObjsMotionDelay(0, 20)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(0, "下を見る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "下を見るL", 0)
	event.ObjsSetMotion(1, "下を見る", 6, -1.0, 1)
	event.ObjsNextMotion(1, "下を見るL", 0)
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(2, "飛び降り", 6)
	helper_ed0a80b8(57)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var0, 5)
	helper_ed0a80b8(24)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-22.94, 21.07, 151.6)
	event.CmrsSetRef(-12.34, 20.95, 163.78)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2080060)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, global2)
	event.CharaActive(0, global3)
	event.CmrsSetPos(-0.26, 17.19, 190.79)
	event.CmrsSetRef(0.01, 15.4, 161.55)
	event.ObjsSetPos(2, 0.19, 0.0, 152.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.SetPakuAnim(2, "口パク")
	helper_c3ce9c48(2080070)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(20)
	end
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.CmrsSetPos(-20.59, 23.87, 138.54)
	event.CmrsSetRef(-5.06, 19.62, 168.66)
	event.ObjsSetPos(0, 7.38, 0.0, 180.67)
	event.ObjsSetRot(0, 0.0, -2.52, 0.0)
	event.ObjsSetPos(1, -9.77, 0.0, 178.88)
	event.ObjsSetRot(1, 0.0, 2.8, 0.0)
	event.ObjsSetPos(2, -9.77, 0.0, 178.88)
	event.ObjsSetRot(2, 0.0, 2.8, 0.0)
	event.ObjsSetMotion(0, "小人見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "のぞきこむ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "のぞきこむL", 0)
	event.ObjsSetMotion(2, "のぞきこむL", 4)
	helper_ed0a80b8(9)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2080080)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(23)
	end
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetRot(0, 0.0, -2.52, 0.0)
	event.ObjsSetPos(2, -9.77, 0.0, 178.88)
	event.ObjsSetRot(2, 0.0, 2.8, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsSetMotion(1, "ひげを引っ張る", 6, -1.0, 1)
	event.ObjsNextMotion(1, "ひげを引っ張るL", 0)
	event.ObjsSetMotion(2, "ひげを引っ張る", 6)
	event.ObjsNextMotion(2, "ひげを引っ張るL", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2080090)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_c3ce9c48(2080100)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2080110)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, global2)
	event.CharaActive(0, global3)
	event.CharaActive(0, 37)
	event.CmrsSetPos(-9.0, 26.44, 178.59)
	event.CmrsSetRef(-5.88, 21.0, 168.44)
	event.SndSePlay(var0, 8)
	event.SetPakuAnim(2, "口パク")
	helper_c3ce9c48(2080120)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.CharaActive(1, 37)
	event.CmrsSetPos(-20.59, 23.87, 138.54)
	event.CmrsSetRef(-5.06, 19.62, 168.66)
	event.ObjsSetMotion(1, "ひげを引っ張るL", 4)
	event.ObjsSetMotion(2, "ひげを引っ張るL", 4)
	event.SndSeStop(var0, 8)
	event.SetPakuAnim(1, "通常口パク")
	helper_f90fbb97(2080130, 45)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var0, 9)
	event.ObjsSetMotion(1, "手をはなす", 6, -1.0, 1)
	event.ObjsNextMotion(1, "小人見立ち", 0)
	event.ObjsSetMotion(2, "手をはなす", 6)
	event.SetPakuAnim(2, "口パク")
	helper_f90fbb97(2080140, 45)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(31)
	end
	event.CharaActive(0, global2)
	event.CharaActive(0, global3)
	event.CharaActive(0, 37)
	event.CmrsSetPos(-18.9, 12.94, 198.36)
	event.CmrsSetRef(-6.29, 14.28, 166.39)
	event.ObjsSetPos(2, -2.8, 0.0, 158.75)
	event.ObjsSetRot(2, 0.0, -0.36, 0.0)
	event.SndSePlay(var0, 11)
	event.ObjsSetMotion(2, "立ちあがる", 6)
	event.ObjsNextMotion(2, "ぷるぷる", 0)
	helper_ed0a80b8(40)
	if vm.skipping() then
		return skip(32)
	end
	event.SetPakuAnim(2, "口くいしばり")
	helper_c3ce9c48(2080150)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(34)
	end
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.CharaActive(1, 37)
	event.CmrsSetPos(-45.5, 24.49, 199.75)
	event.CmrsSetRef(-6.19, 20.61, 167.64)
	event.ObjsSetMotion(1, "のぞきこむ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "のぞきこむL", 0)
	helper_ed0a80b8(16)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsMotionDelay(2, 95)
	event.ObjsSetMotion(2, "知るかー！", 6)
	event.ObjsMotionWait(2)
	helper_f90fbb97(2080160, 95)
	if vm.skipping() then
		return skip(36)
	end
	event.SetPakuAnim(2, "口パク")
	helper_f90fbb97(2080170, 60)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(38)
	end
	event.EohSetFootSoundId(2, 1)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 5)
	event.ObjsSetMotion(2, "走り", 4)
	event.ObjsRotation(2, 0.0, -1.68, 0.0, 5)
	event.ObjsPosDelay(2, 10)
	event.ObjsMove(2, -34.77, 0.0, 141.26, 10)
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(-7.94, 26.69, 297.02)
	event.CmrsSetRef(-14.45, 35.07, 200.07)
	event.ObjsSetRot(0, 0.0, -2.76, 0.0)
	event.ObjsSetPos(1, -9.45, 0.0, 183.58)
	event.ObjsSetRot(1, 0.0, -3.0, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 60)
	event.ObjsAddPas(2, -34.18, 0.0, 155.15)
	event.ObjsAddPas(2, -56.6, 0.0, 139.78)
	event.ObjsAddPas(2, -81.07, 10.66, 105.17)
	event.ObjsAddPas(2, -72.6, 14.0, 73.22)
	event.ObjsAddPas(2, -51.33, 26.7, 62.09)
	event.ObjsAddPas(2, -14.3, 35.67, 58.29)
	event.ObjsAddPas(2, 21.17, 35.67, 58.93)
	event.ObjsStartPas(2)
	helper_ed0a80b8(27)
	if vm.skipping() then
		return skip(40)
	end
	event.EohSetFootSoundId(2, 3)
	helper_ed0a80b8(27)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(2, "立ち", 4)
	event.SndSePlay(var0, 13)
	event.ObjsRotation(10, 0.0, 0.0, 0.0, 6)
	event.ObjsRotation(11, 0.0, 0.0, 0.0, 6)
	helper_ed0a80b8(6)
	if vm.skipping() then
		return skip(42)
	end
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsSetPos(-21.8, 20.0, 147.33)
	event.CmrsSetRef(-5.31, 20.05, 175.31)
	event.ObjsSetMotion(1, "ユリスを見る", 6)
	event.ObjsNextMotion(1, "ユリスを見るL", 0)
	helper_ed0a80b8(16)
	if vm.skipping() then
		return skip(44)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2080180)
	if vm.skipping() then
		return skip(45)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "モニカを見る", 6)
	event.ObjsNextMotion(0, "モニカを見るL", 0)
	helper_ed0a80b8(16)
	if vm.skipping() then
		return skip(46)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(2080190)
	if vm.skipping() then
		return skip(47)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(21.34, 23.15, 280.07)
	event.CmrsSetRef(8.85, 20.05, 195.33)
	event.ObjsSetPos(1, -10.02, 0.0, 195.29)
	event.ObjsSetRot(1, 0.0, 2.2, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMove(1, 0.15, 0.0, 187.37, 30)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(48)
	end
	return part2()
end

--- Program 501.
local function program_501()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f940()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("g01/g01_1.stb", -1)
end

--- Helper function.
local function helper_14690()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_event.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e209/e209_rococo.gltf", "info", 33)
	event.EohSyncChara(2, 33)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 33)
	event.EohSyncEditObj(6, "p01_g010701", "g010707-m")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 6)
	event.ObjsSetPos(10, 1.0461, 59.1891, 78.8974)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.EohSyncEditObj(7, "p01_g010701", "g010708-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 7)
	event.ObjsSetPos(11, 1.0461, 59.1891, 78.8974)
	event.ObjsSetRot(11, 0.0, 0.0, 0.0)
	event.LoadMes(0, 5, "event/e200/e209/e209_1.txt")
end

--- Helper function.
local function helper_14394()
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
	event.DeleteChara(33)
end

--- Helper function.
local function helper_154b8()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				helper_c3ce9c48(2090010)
			end
			if at <= 2 then
				helper_e2d04ed9(0)
			end
			if at <= 3 then
				helper_e2d04ed9(1)
			end
			if at <= 4 then
				helper_ed0a80b8(14)
			end
			if at <= 5 then
				helper_c3ce9c48(2090020)
			end
			if at <= 6 then
				helper_ed0a80b8(15)
			end
			if at <= 7 then
				helper_ed0a80b8(14)
			end
			if at <= 8 then
				helper_f90fbb97(2090030, 150)
			end
			if at <= 9 then
				helper_f90fbb97(2090040, 120)
			end
			if at <= 10 then
				helper_c758eb34(1)
			end
			if at <= 11 then
				helper_ed0a80b8(75)
			end
			if at <= 12 then
				helper_ed0a80b8(30)
			end
			if at <= 13 then
				helper_ed0a80b8(60)
			end
			if at <= 14 then
				helper_ed0a80b8(30)
			end
			if at <= 15 then
				helper_c3ce9c48(2090050)
			end
			if at <= 16 then
				helper_c3ce9c48(2090060)
			end
			if at <= 17 then
				helper_ed0a80b8(45)
			end
			if at <= 18 then
				helper_ed0a80b8(15)
			end
			if at <= 19 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
		helper_14394()
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.ObjsSetRot(10, 0.0, 0.0, 0.0)
		event.ObjsSetRot(11, 0.0, 0.0, 0.0)
		helper_14394()
		event.SetFadeIn(30)
	end
	event.SetFlag(209, 1)
	event.Initialize()
	var0 = event.SndLoadSound(2217) or var0
	helper_14690()
	event.EohSetSoundId(0, var0)
	do
		local out1, out2, out3, out4 = event.GetEditPartsPos("p01_g010701")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
		rot_y = out4 or rot_y
	end
	event.SetWorldCoord(pos_x, pos_y, pos_z, rot_y)
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
	event.CmrsSetPos(-152.18, 97.87, 182.55)
	event.CmrsSetRef(-14.08, 63.23, 79.66)
	event.ObjsSetPos(0, -21.47, 35.67, 73.06)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -23.66, 35.67, 53.67)
	event.ObjsSetRot(1, 0.0, 1.48, 0.0)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "ノック", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_ed0a80b8(63)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "左・モニカ見", 6)
	event.ObjsNextMotion(0, "左・モニカ見L", 0)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "右を見る", 6)
	event.ObjsNextMotion(1, "右を見るL", 0)
	helper_c3ce9c48(2090010)
	if vm.skipping() then
		return skip(2)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(2.14, 52.68, 63.32)
	event.CmrsSetRef(-43.71, 54.31, 61.35)
	event.ObjsSetPos(0, -44.21, 30.26, 69.36)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -40.8, 31.97, 53.53)
	event.ObjsSetRot(1, 0.0, 1.24, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "ひそひそ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "ひそひそL", 0)
	helper_ed0a80b8(14)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(2090020)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "どうするのー！", 6)
	event.ObjsNextMotion(1, "どうするのー！L", 4)
	event.ObjsMotionDelay(0, 15)
	event.ObjsSetMotion(0, "左・モニカ見戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_ed0a80b8(14)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_f90fbb97(2090030, 150)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_f90fbb97(2090040, 120)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, 33)
	event.CmrsSetPos(-101.88, 58.31, 65.69)
	event.CmrsSetRef(-24.94, 60.87, 62.04)
	event.ObjsSetPos(0, -38.21, 35.37, 69.15)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -40.8, 36.06, 53.53)
	event.ObjsSetRot(1, 0.0, 1.48, 0.0)
	event.ObjsSetPos(2, 6.91, 35.67, 60.19)
	event.ObjsSetRot(2, 0.0, -2.24, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.StreamOpen3(1, 2090045)
	helper_c758eb34(1)
	if vm.skipping() then
		return skip(11)
	end
	event.StreamPlay(1)
	helper_ed0a80b8(75)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var0, 5)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(13)
	end
	helper_ed0a80b8(60)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(var0, 6)
	event.ObjsRotation(10, 0.0, 0.78, 0.0, 30)
	event.ObjsRotation(11, 0.0, 0.78, 0.0, 30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 37)
	event.CmrsSetPos(-78.2, 56.82, 61.3)
	event.CmrsSetRef(-24.35, 59.62, 61.68)
	event.ObjsSetPos(2, 2.98, 37.07, 62.41)
	event.ObjsSetRot(2, 0.0, -2.6, 0.0)
	event.ObjsSetMotion(2, "手招き", 4)
	helper_c3ce9c48(2090050)
	if vm.skipping() then
		return skip(16)
	end
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 37)
	event.CharaActive(0, 33)
	event.CmrsSetPos(1.94, 52.68, 65.96)
	event.CmrsSetRef(-43.71, 52.77, 61.35)
	event.ObjsSetPos(0, -44.21, 30.26, 69.36)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -40.8, 31.97, 53.53)
	event.ObjsSetRot(1, 0.0, 1.24, 0.0)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.ObjsSetRot(11, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "右を見る", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右を見るL", 0)
	event.ObjsTexAnime(0, 1, "半口")
	event.SetPakuAnim(1, "わらい口パク")
	helper_c3ce9c48(2090060)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-98.54, 68.99, 103.67)
	event.CmrsSetRef(-31.83, 65.79, 66.42)
	event.ObjsSetPos(0, -36.84, 35.67, 44.26)
	event.ObjsSetRot(0, 0.0, 1.48, 0.0)
	event.ObjsSetPos(1, -15.62, 35.67, 55.4)
	event.ObjsSetRot(1, 0.0, 1.36, 0.0)
	event.ObjsSetRot(10, 0.0, 1.2, 0.0)
	event.ObjsSetRot(11, 0.0, 1.2, 0.0)
	event.EohSetFootSoundId(0, 3)
	event.EohSetFootSoundId(1, 3)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMove(1, 29.37, 35.67, 54.62, 60)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMove(0, 20.32, 35.67, 64.47, 75)
	helper_ed0a80b8(45)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "立ち", 4)
	event.SndSePlay(var0, 7)
	event.ObjsRotation(10, 0.0, 0.0, 0.0, 30)
	event.ObjsRotation(11, 0.0, 0.0, 0.0, 30)
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(207) or flag
	if flag == 1 then
		flag = event.GetFlag(208) or flag
		if flag == 0 then
			program_501()
			if vm.skipping() then
				return skip(1)
			end
		end
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_154b8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
-- Defined empty, so the engine runs this instead of its default.
script[200] = function() end

script[501] = program_501

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ed0a80b8(15)
		end
	end
	helper_154b8()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_ed0a80b8(15)
	if vm.skipping() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.MapJump(-1, "g01i07", 501)
	if vm.wait() then
		return skip(4)
	end
end

return script
