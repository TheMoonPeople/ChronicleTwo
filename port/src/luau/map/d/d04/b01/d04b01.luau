--!strict
-- map/d/d04/b01/d04b01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_066106e5 = require("@lib/event/helper_066106e5")
local helper_1e056829 = require("@lib/event/helper_1e056829")
local helper_22a31ecc = require("@lib/event/helper_22a31ecc")
local helper_4b2e490f = require("@lib/event/helper_4b2e490f")
local helper_504dc885 = require("@lib/event/helper_504dc885")
local helper_50957e57 = require("@lib/event/helper_50957e57")
local helper_5fcc6d89 = require("@lib/event/helper_5fcc6d89")
local helper_7d755610 = require("@lib/event/helper_7d755610")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_9e457fe2 = require("@lib/event/helper_9e457fe2")
local helper_a1df9d0f = require("@lib/event/helper_a1df9d0f")
local helper_a1f03a46 = require("@lib/event/helper_a1f03a46")
local helper_a65ad647 = require("@lib/event/helper_a65ad647")
local helper_b5fd3167 = require("@lib/event/helper_b5fd3167")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local helper_be382d20 = require("@lib/event/helper_be382d20")
local helper_ddc352a1 = require("@lib/event/helper_ddc352a1")
local helper_f0415042 = require("@lib/event/helper_f0415042")
local helper_f705f18e = require("@lib/event/helper_f705f18e")
local helper_f86d86cb = require("@lib/event/helper_f86d86cb")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.StopBgm(0)
	helper_f86d86cb()
	flag = event.GetFlag(438) or flag
	flag_2 = event.GetFlag(444) or flag_2
	event.EohSyncObj(0, "p01_battleship")
	if flag == 1 and flag_2 == 0 then
		event.EohSetShow(0, 1)
	else
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_144cc()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_5fcc6d89(110)
			end
			if at <= 2 then
				helper_5fcc6d89(10)
			end
			if at <= 3 then
				helper_ddc352a1(1)
			end
			if at <= 4 then
				helper_a65ad647(4320010)
			end
			if at <= 5 then
				helper_a65ad647(4320015)
			end
			if at <= 6 then
				helper_22a31ecc()
			end
			if at <= 7 then
				helper_ddc352a1(1)
			end
			if at <= 8 then
				helper_a65ad647(4320020)
			end
			if at <= 9 then
				helper_22a31ecc()
			end
			if at <= 10 then
				helper_a65ad647(4320030)
			end
			if at <= 11 then
				helper_ddc352a1(0)
			end
			if at <= 12 then
				helper_a65ad647(4320040)
			end
			if at <= 13 then
				helper_ddc352a1(1)
			end
			if at <= 14 then
				helper_a65ad647(4320045)
			end
			if at <= 15 then
				helper_5fcc6d89(30)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		helper_50957e57(vm.f32(1779.8), 0.0, 354.5, vm.f32(-0.96))
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var2, 0)
		event.SndSeStop(var2, 1)
		event.PlayBgm(0)
		event.CharaActive(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetPos(3, 0.0, 0.0, 0.0)
		event.DelExtMotion(0)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.LoadMes(0, -1)
		helper_50957e57(vm.f32(1779.8), 0.0, 354.5, vm.f32(-0.96))
		event.SetCameraPos(1878.94, 40.0, 285.33)
		event.SetCameraRef(1779.8, 30.0, 354.5)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.SetFlag(432, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_5fcc6d89(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(3)
	event.LoadSound(4814)
	var2 = event.SndLoadSound(8, "snd2/sp/sp_041.sound.json") or var2
	var1 = event.SndLoadSound(4814) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e432/")
	event.LoadMes(0, 5, "e432.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e432_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e432_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 16)
		event.LoadEquip(5, 0, 4, "info", 16)
		event.LoadEquip(5, 0, 3, "info", 16)
		event.LoadEquip(5, 0, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e432/e432_mints.gltf", "info", 16)
		event.EohSyncChara(0, 16)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 16)
		event.LoadEquip(5, 1, 4, "info", 16)
		event.LoadEquip(5, 1, 3, "info", 16)
		event.LoadEquip(5, 1, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e432/e432_monica.gltf", "info", 16)
		event.EohSyncChara(1, 16)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(16)
	event.CharaActive(17)
	event.EohSyncObj(2, "p02_d04b01")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p03_d04b01")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, 2030.0, 0.0, -740.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 14)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 2046.0, 0.0, -740.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 14)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsRotation2(2, 0.0, 0.0, 3.14, 40, 0, 0.5)
	event.ObjsRotDelay(2, 168)
	event.ObjsRotation2(2, 0.0, 0.0, 0.0, 40, 0, 0.5)
	event.ObjsSePlay(2, var2, 0)
	event.ObjsSeDelay(2, 170)
	event.ObjsSePlay(2, var2, 1)
	event.ObjsPosDelay(3, 80)
	event.ObjsMove2(3, 0.0, 80.0, 0.0, 32, 1, 0.5)
	event.ObjsPosDelay(3, 40)
	event.ObjsMove2(3, 0.0, 0.0, 0.0, 32, 2, 0.5)
	event.CmrsInit()
	event.CmrsSetPos(2198.81, 99.4, -537.94)
	event.CmrsSetRef(2056.98, 54.61, -679.8)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_5fcc6d89(110)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(0, 2030.0, 0.0, -680.0, 60)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(1, 2046.0, 0.0, -680.0, 60)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(2061.53, 10.96, -648.18)
	event.CmrsSetRef(2030.82, 23.87, -686.56)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "口とじ～口あけ")
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4320010)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1924.65, 64.05, 196.6)
	event.CmrsSetRef(1932.83, 64.94, 223.63)
	event.CmrsMove2(1924.65, 64.05, 196.6, 1904.25, 64.94, 216.36, 90, 0, 0.4)
	event.PlayBgm(0)
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4320015)
	if vm.skipping() then
		return skip(6)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(1800.0, 39.0, 176.0)
	event.CmrsSetRef(1800.0, 22.0, 260.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetPos(0, 1794.0, 0.0, 200.0)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsMove(0, 1794.0, 0.0, 260.0, 20)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 1808.0, 0.0, 190.0)
	event.ObjsMove(1, 1808.0, 0.0, 260.0, 24)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMotionDelay(1, 24)
	event.ObjsSetMotion(1, "立ち")
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsMoveAhd2(0.9, -10.0, 38.0, 40, 0, 1.0)
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4320020)
	if vm.skipping() then
		return skip(9)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4320030)
	if vm.skipping() then
		return skip(11)
	end
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var1, 0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "目あき～目とじ")
	event.ObjsSetMotion(1, "さぁ？", 6)
	event.ObjsNextMotion(1, "さぁ？L", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4320040)
	if vm.skipping() then
		return skip(13)
	end
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(1785.99, 22.09, 263.93)
	event.CmrsSetRef(1808.23, 23.58, 259.85)
	if active_chr_no == 0 then
		event.CharaActive(0, 0)
	else
		event.CharaActive(0, 16)
		event.CharaActive(0, 17)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "目とじ～目あき")
	event.ObjsSetMotion(1, "こぶし", 6)
	event.ObjsNextMotion(1, "こぶしL", 4)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var1, 1)
	event.SetPakuAnim(1, "わらい口パク")
	helper_a65ad647(4320045)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeOut(30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

--- Helper function.
local function helper_1a57c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_5fcc6d89(10)
			end
			if at <= 2 then
				helper_ddc352a1(1)
			end
			if at <= 3 then
				helper_a65ad647(4360010)
			end
			if at <= 4 then
				helper_a65ad647(4360015)
			end
			if at <= 5 then
				helper_22a31ecc()
			end
			if at <= 6 then
				helper_ddc352a1(1)
			end
			if at <= 7 then
				helper_5fcc6d89(10)
			end
			if at <= 8 then
				helper_a65ad647(4360020)
			end
			if at <= 9 then
				helper_22a31ecc()
			end
			if at <= 10 then
				helper_5fcc6d89(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
		helper_50957e57(vm.f32(1779.8), 0.0, 354.5, vm.f32(-0.96))
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 1)
		event.CharaActive(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetPos(3, 0.0, 0.0, 0.0)
		event.DelExtMotion(0)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.LoadMes(0, -1)
		helper_50957e57(vm.f32(1779.8), 0.0, 354.5, vm.f32(-0.96))
		event.SetCameraPos(1878.94, 40.0, 285.33)
		event.SetCameraRef(1779.8, 30.0, 354.5)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.SetFlag(436, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	event.LoadSound(4820)
	var1 = event.SndLoadSound(8, "snd2/sp/sp_041.sound.json") or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e436/")
	event.LoadMes(0, 5, "e436.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e436_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e436_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 16)
		event.LoadEquip(5, 0, 4, "info", 16)
		event.LoadEquip(5, 0, 3, "info", 16)
		event.LoadEquip(5, 0, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e436/e436_mints.gltf", "info", 16)
		event.EohSyncChara(0, 16)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 16)
		event.LoadEquip(5, 1, 4, "info", 16)
		event.LoadEquip(5, 1, 3, "info", 16)
		event.LoadEquip(5, 1, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e436/e436_monica.gltf", "info", 16)
		event.EohSyncChara(1, 16)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(16)
	event.CharaActive(17)
	event.EohSyncObj(2, "p02_d04b01")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p03_d04b01")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, 2030.0, 0.0, -740.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 14)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 2046.0, 0.0, -740.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 14)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsRotation2(2, 0.0, 0.0, 3.14, 40, 0, 0.5)
	event.ObjsRotDelay(2, 168)
	event.ObjsRotation2(2, 0.0, 0.0, 0.0, 40, 0, 0.5)
	event.ObjsSePlay(2, var1, 0)
	event.ObjsSeDelay(2, 170)
	event.ObjsSePlay(2, var1, 1)
	event.ObjsPosDelay(3, 80)
	event.ObjsMove2(3, 0.0, 80.0, 0.0, 32, 1, 0.5)
	event.ObjsPosDelay(3, 40)
	event.ObjsMove2(3, 0.0, 0.0, 0.0, 32, 2, 0.5)
	event.CmrsInit()
	event.CmrsSetPos(2198.81, 99.4, -537.94)
	event.CmrsSetRef(2056.98, 54.61, -679.8)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_5fcc6d89(110)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(0, 2030.0, 0.0, -680.0, 60)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(1, 2046.0, 0.0, -680.0, 60)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(2061.53, 10.96, -648.18)
	event.CmrsSetRef(2030.82, 23.87, -686.56)
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4360010)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(1924.65, 64.05, 196.6)
	event.CmrsSetRef(1932.83, 64.94, 223.63)
	event.CmrsMove2(1924.65, 64.05, 196.6, 1904.25, 64.94, 216.36, 90, 0, 0.4)
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4360015)
	if vm.skipping() then
		return skip(5)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(1800.0, 39.0, 176.0)
	event.CmrsSetRef(1800.0, 22.0, 260.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.ObjsSetPos(0, 1794.0, 0.0, 200.0)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsMove(0, 1794.0, 0.0, 260.0, 20)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 1808.0, 0.0, 190.0)
	event.ObjsMove(1, 1808.0, 0.0, 260.0, 24)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMotionDelay(1, 24)
	event.ObjsSetMotion(1, "立ち")
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(7)
	end
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetAhd(0.9, -10.0, 38.0)
	event.ObjsSetMotion(0, "考える", 4, -1.0, 1)
	event.ObjsSetMotion(1, "指当て", 4, -1.0, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4360020)
	if vm.skipping() then
		return skip(9)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeOut(30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_1e360()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 33 then
			if at <= 1 then
				helper_22a31ecc()
			end
			if at <= 2 then
				helper_ddc352a1(1)
			end
			if at <= 3 then
				helper_5fcc6d89(160)
			end
			if at <= 4 then
				helper_a65ad647(4400010)
			end
			if at <= 5 then
				helper_ddc352a1(1)
			end
			if at <= 6 then
				helper_a65ad647(4400020)
			end
			if at <= 7 then
				helper_ddc352a1(0)
			end
			if at <= 8 then
				helper_ddc352a1(5)
			end
			if at <= 9 then
				helper_a65ad647(4400025)
			end
			if at <= 10 then
				helper_a65ad647(4400030)
			end
			if at <= 11 then
				helper_a65ad647(4400040)
			end
			if at <= 12 then
				helper_ddc352a1(0)
			end
			if at <= 13 then
				var3 = 0.0
				var4 = vm.f32(-0.35)
				var5 = 0
				pos_y = vm.f32(pos_y + var3)
				var3 = vm.f32(var3 + var4)
				var3 = vm.f32(var3 - vm.f32(var4 * vm.f32(2.2)))
				var5 = var5 + 1
			end
			if at <= 14 then
				helper_a65ad647(4400045)
			end
			if at <= 15 then
				helper_ddc352a1(2)
			end
			if at <= 16 then
				helper_22a31ecc()
			end
			if at <= 17 then
				helper_a65ad647(4400050)
			end
			if at <= 18 then
				helper_ddc352a1(2)
			end
			if at <= 19 then
				helper_a65ad647(4400060)
			end
			if at <= 20 then
				helper_5fcc6d89(2)
			end
			if at <= 21 then
				helper_ddc352a1(2)
			end
			if at <= 22 then
				helper_a65ad647(4400063)
			end
			if at <= 23 then
				helper_22a31ecc()
			end
			if at <= 24 then
				helper_a65ad647(4400066)
			end
			if at <= 25 then
				helper_ddc352a1(2)
			end
			if at <= 26 then
				helper_a65ad647(4400070)
			end
			if at <= 27 then
				helper_ddc352a1(1)
			end
			if at <= 28 then
				helper_a65ad647(4400080)
			end
			if at <= 29 then
				helper_a65ad647(4400083)
			end
			if at <= 30 then
				helper_a65ad647(4400086)
			end
			if at <= 31 then
				helper_22a31ecc()
			end
			if at <= 32 then
				helper_5fcc6d89(30)
			end
			if vm.skip_end() then
				return skip(34)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 3)
		event.SndSeStop(var1, 4)
		event.SpriteSetDraw(0, 0)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(8, 1)
		event.EohSetShow(9, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.LoadMes(0, -1)
		event.DelImg(0)
		event.CmrsInit()
	end
	event.SetFlag(440, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_5fcc6d89(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(34)
	event.LoadSound(4826)
	var1 = event.SndLoadSound(4826) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e440/")
	event.LoadMes(0, 5, "e440.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e440_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e440_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e440_jamming.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e440_sourcer.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e440_seagura.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 12, 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CopyChara(5, 12, 14)
	event.CharaActive(14)
	event.EohSyncChara(6, 14)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.CopyChara(5, 12, 15)
	event.CharaActive(15)
	event.EohSyncChara(7, 15)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	block = event.LoadImg_4(5, "e440telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e440telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 306)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 10)
	event.ChangeDir("")
	event.LoadChara(5, "event/e400/e440/mariometto_a.gltf", "info", 16)
	event.CharaActive(16)
	event.SetReference(12, "mettoa_null", 16)
	event.CopyChara(5, 16, 17)
	event.CharaActive(17)
	event.SetReference(13, "mettoa_null", 17)
	event.CopyChara(5, 16, 18)
	event.CharaActive(18)
	event.SetReference(14, "mettoa_null", 18)
	event.CopyChara(5, 16, 19)
	event.CharaActive(19)
	event.SetReference(15, "mettoa_null", 19)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e440/e440_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e400/e440/e440_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(8, 1)
	event.EohSyncChara(9, 2)
	event.EohSetShow(8, 0)
	event.EohSetShow(9, 0)
	event.EohSetPos(0, 682.0, 0.0, 189.0)
	event.EohSetRot(0, 0.0, -1.57, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 14)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "大口")
	event.EohSetPos(1, 700.0, 0.0, 200.0)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 14)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 1381.99, 900.0, 2158.32)
	event.EohSetRot(2, 0.0, 3.0, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetSoundId(2, var1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetPos(3, 1381.99, 900.0, 2158.32)
	event.EohSetRot(3, 0.0, 2.04, 0.0)
	event.EohSetPos(4, 132.83, 0.0, -305.18)
	event.EohSetRot(4, 0.0, 0.72, 0.0)
	event.EohSetMotion(4, "立ち", 4)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "目赤")
	event.EohSetPos(5, -456.48, 0.0, 1086.61)
	event.EohSetRot(5, 0.0, 2.28, 0.0)
	event.EohSetMotion(5, "立ち", 4)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "目赤")
	event.EohSetPos(6, 1347.63, 0.0, 856.01)
	event.EohSetRot(6, 0.0, -2.28, 0.0)
	event.EohSetMotion(6, "立ち", 4)
	event.EohSetTexAnim(6, 0)
	event.EohSetTexAnim(6, 1, "目赤")
	event.EohSetPos(7, 894.8, 0.0, -315.53)
	event.EohSetRot(7, 0.0, -0.72, 0.0)
	event.EohSetMotion(7, "立ち", 4)
	event.EohSetTexAnim(7, 0)
	event.EohSetTexAnim(7, 1, "目赤")
	event.InitDramaScene()
	event.SndSePlay(var1, 0)
	event.CmrsInit()
	event.CmrsSetPos(1793.56, 223.9, 283.1)
	event.CmrsSetRef(1848.03, 252.49, 433.57)
	event.CmrsMove2(1793.56, 403.69, 283.1, 1848.03, 478.81, 433.57, 90, 2, 1.0)
	event.SetFadeIn(30)
	helper_22a31ecc()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(488.77, 606.28, -354.72)
	event.CmrsSetRef(488.77, 429.77, -146.44)
	event.ObjsMove(0, 482.0, 0.0, 189.0, 60)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, 486.99, 0.0, 202.8, 64)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMotionDelay(1, 64)
	event.ObjsSetMotion(1, "立ち")
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var1, 1)
	event.ObjsMove(4, 267.78, 0.0, -96.39, 210)
	event.ObjsSetMotion(4, "歩き", 0)
	event.ObjsMotionDelay(4, 210)
	event.ObjsSetMotion(4, "立ち")
	event.ObjsMove(5, 171.77, 0.0, 463.88, 230)
	event.ObjsSetMotion(5, "歩き", 0, 0.48)
	event.ObjsMotionDelay(5, 230)
	event.ObjsSetMotion(5, "立ち")
	event.ObjsMove(6, 773.64, 0.0, 443.16, 220)
	event.ObjsSetMotion(6, "歩き", 0, 0.48)
	event.ObjsMotionDelay(6, 220)
	event.ObjsSetMotion(6, "立ち")
	event.ObjsMove(7, 711.27, 0.0, -99.08, 202)
	event.ObjsSetMotion(7, "歩き", 0)
	event.ObjsMotionDelay(7, 202)
	event.ObjsSetMotion(7, "立ち")
	helper_5fcc6d89(160)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(433.73, 10.85, 194.55)
	event.CmrsSetRef(494.45, 22.5, 195.7)
	event.ObjsSetMotion(0, "あとずさり", 6)
	event.ObjsNextMotion(0, "あとずさりL", 4)
	event.ObjsSetMotion(1, "のけぞり", 6)
	event.ObjsNextMotion(1, "のけぞりL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4400010)
	if vm.skipping() then
		return skip(5)
	end
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "指さす", 2)
	event.ObjsNextMotion(0, "指さすL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4400020)
	if vm.skipping() then
		return skip(7)
	end
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_ddc352a1(5)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(482.22, 295.97, 32.59)
	event.CmrsSetRef(358.04, 280.12, 4.29)
	event.SndSePlay(var1, 3)
	helper_a65ad647(4400025)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSeStop(var1, 3)
	event.CmrsSetPos(426.29, 336.99, 1022.57)
	event.CmrsSetRef(446.51, 249.73, 695.36)
	event.PlayBgm(0)
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4400030)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(466.23, 33.98, 224.28)
	event.CmrsSetRef(486.89, 17.34, 191.61)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "口とじ～大口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～大口")
	event.ObjsSetMotion(0, "左上を見る", 6)
	event.ObjsNextMotion(0, "左上を見るL", 4)
	event.ObjsSetMotion(1, "左上", 6)
	event.ObjsNextMotion(1, "左上L", 4)
	helper_a65ad647(4400040)
	if vm.skipping() then
		return skip(12)
	end
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(468.1, 89.63, 136.48)
	event.CmrsSetRef(619.55, 292.69, 882.71)
	event.CmrsMove2(604.47, 263.88, 808.44, 619.55, 292.69, 882.71, 90, 0, 1.0)
	event.SndSePlay(var1, 4)
	event.ObjsSetPos(0, 474.35, 0.0, 208.29)
	event.ObjsSetRot(0, 0.0, 0.5, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetPos(1, 486.05, 0.0, 198.18)
	event.ObjsSetRot(1, 0.0, 0.23, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "演奏1", 4)
	event.ObjsMove2(2, 600.0, 900.0, 850.0, 60, 2, 0.5)
	event.ObjsMove2(3, 600.0, 900.0, 850.0, 60, 2, 0.5)
	var3 = 0.0
	var4 = vm.f32(-0.35)
	var5 = 0
	while var5 < 70 do
		do
			local out1, out2, out3 = event.EohGetPos(2)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_y = vm.f32(pos_y + var3)
		if var5 < 50 then
			var3 = vm.f32(var3 + var4)
		else
			var3 = vm.f32(var3 - vm.f32(var4 * vm.f32(2.2)))
		end
		event.EohSetPos(2, pos_x, pos_y, pos_z)
		event.EohSetPos(3, pos_x, pos_y, pos_z)
		var5 = var5 + 1
		if vm.wait() then
			return skip(14)
		end
	end
	event.SndSePlay(var1, 5)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(8, 128, 128, 128, 128, 30)
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "演奏2", 6)
	event.ObjsNextMotion(2, "演奏1", 4)
	helper_a65ad647(4400045)
	if vm.skipping() then
		return skip(15)
	end
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(16)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(17)
	end
	event.SpriteSetDraw(0, 0)
	event.CmrsSetPos(520.65, 18.19, 210.67)
	event.CmrsSetRef(478.14, 21.46, 206.21)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4400050)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(640.97, 288.67, 848.2)
	event.CmrsSetRef(617.43, 290.99, 881.13)
	event.SndSePlay(var1, 6)
	event.ObjsSetMotion(2, "耳に手in", 6)
	event.ObjsMotionWait(2)
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsMoveAhd2(-2.74, -19.32, 54.92, 90, 0, 1.0)
	event.SetPakuMotion(2, "耳に手（会話）", 4, "耳に手", 0)
	helper_a65ad647(4400060)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "ギャーンin", 2)
	event.ObjsMotionWait(2)
	helper_5fcc6d89(2)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var1, 7)
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuMotion(2, "ギャーン（会話）", 4, "ギャーン", 0)
	helper_a65ad647(4400063)
	if vm.skipping() then
		return skip(23)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(2, "笑うin", 2)
	event.ObjsNextMotion(2, "笑う", 4)
	helper_a65ad647(4400066)
	if vm.skipping() then
		return skip(25)
	end
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(493.73, 43.46, 227.63)
	event.CmrsSetRef(488.06, 20.7, 202.27)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SndSePlay(var1, 8)
	event.ObjsSetMotion(1, "半歩前", 6)
	event.ObjsNextMotion(1, "半歩前L", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_a65ad647(4400070)
	if vm.skipping() then
		return skip(27)
	end
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(615.36, 287.58, 855.01)
	event.CmrsSetRef(619.05, 292.49, 877.81)
	event.ObjsSetMotion(2, "会話（演奏）", 6)
	event.ObjsNextMotion(2, "立ち（演奏）", 4)
	helper_a65ad647(4400080)
	if vm.skipping() then
		return skip(29)
	end
	helper_a65ad647(4400083)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsMove2(482.56, 23.28, 34.42, 619.05, 121.85, 877.81, 60, 0, 1.0)
	helper_a65ad647(4400086)
	if vm.skipping() then
		return skip(31)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(32)
	end
	event.SetFadeOut(30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(33)
	end
	return part2()
end

--- Helper function.
local function helper_13694()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_ddc352a1(0)
			end
			if at <= 2 then
				helper_ddc352a1(1)
			end
			if at <= 3 then
				helper_5fcc6d89(10)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		helper_50957e57(2040.0, 0.0, -680.0, 0.0)
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetRot(1, 0.0, 0.0, 0.0)
		event.EohSetPos(3, 0.0, 0.0, 0.0)
		helper_50957e57(2040.0, 0.0, -680.0, 0.0)
		event.SetCameraRef(2040.0, 30.0, -680.0)
		event.SetCameraPos(2040.0, 40.0, -580.0)
		event.ResetCamera(0)
		event.SetCrossfade(30)
		event.Finish()
	end
	event.Initialize()
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_041.sound.json") or var0
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p02_d04b01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(3, "p03_d04b01")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 3)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, 2040.0, 0.0, -740.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.EohSetFootSoundId(0, 14)
	event.SndSePlay(var0, 0)
	event.ObjsRotation2(1, 0.0, 0.0, 3.14, 40, 0, 0.5)
	event.ObjsPosDelay(2, 80)
	event.ObjsMove2(2, 0.0, 80.0, 0.0, 32, 1, 0.5)
	event.CmrsInit()
	event.CmrsSetPos(2198.81, 99.4, -537.94)
	event.CmrsSetRef(2056.98, 54.61, -679.8)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_5fcc6d89(110)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(0, 2040.0, 0.0, -660.0, 60)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_141a4()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5fcc6d89(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "前のフロアへ戻りますか？")
	var0 = helper_4b2e490f(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_5fcc6d89(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	else
		event.Finish()
		return 0
	end
end

--- Helper function.
local function helper_df04()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_5fcc6d89(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_6068(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1e056829(1)
		end
		if at <= 2 then
			helper_be382d20(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_1e056829(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_be382d20(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_235b0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 121 then
			if at <= 1 then
				helper_5fcc6d89(4)
			end
			if at <= 2 then
				active_chr_no = 0
				active_chr_no = 1
				helper_a65ad647(4440010)
			end
			if at <= 3 then
				helper_5fcc6d89(20)
			end
			if at <= 4 then
				helper_5fcc6d89(30)
			end
			if at <= 5 then
				helper_a65ad647(4440020)
			end
			if at <= 6 then
				helper_ddc352a1(5)
			end
			if at <= 7 then
				helper_a65ad647(4440030)
			end
			if at <= 8 then
				helper_a65ad647(4440040)
			end
			if at <= 9 then
				helper_ddc352a1(2)
			end
			if at <= 10 then
				helper_5fcc6d89(40)
			end
			if at <= 11 then
				helper_5fcc6d89(17)
			end
			if at <= 12 then
				helper_ddc352a1(2)
			end
			if at <= 13 then
				helper_5fcc6d89(10)
			end
			if at <= 14 then
				helper_5fcc6d89(50)
			end
			if at <= 15 then
				helper_22a31ecc()
			end
			if at <= 16 then
				helper_5fcc6d89(30)
			end
			if at <= 17 then
				helper_a65ad647(4440050)
			end
			if at <= 18 then
				helper_22a31ecc()
			end
			if at <= 19 then
				helper_5fcc6d89(30)
			end
			if at <= 20 then
				helper_a65ad647(4440060)
			end
			if at <= 21 then
				helper_22a31ecc()
			end
			if at <= 22 then
				helper_a65ad647(4440065)
			end
			if at <= 23 then
				helper_5fcc6d89(30)
			end
			if at <= 24 then
				helper_504dc885(4440070, 30)
			end
			if at <= 25 then
				helper_ddc352a1(7)
			end
			if at <= 26 then
				pos_x = vm.f32(vm.f32(vm.sin(vm.f32(-0.767)) * 600.0) + pos_x)
				pos_y = vm.f32(pos_y + 1900.0)
				pos_z = vm.f32(vm.f32(vm.cos(vm.f32(-0.767)) * 600.0) + pos_z)
				helper_ddc352a1(11)
			end
			if at <= 27 then
				pos_x = vm.f32(vm.f32(vm.sin(1.0) * 16000.0) + pos_x)
				pos_y = vm.f32(pos_y - 2000.0)
				pos_z = vm.f32(vm.f32(vm.cos(1.0) * 16000.0) + pos_z)
				helper_ddc352a1(11)
			end
			if at <= 28 then
				helper_066106e5()
			end
			if at <= 29 then
				helper_22a31ecc()
			end
			if at <= 30 then
				helper_a65ad647(4440080)
			end
			if at <= 31 then
				helper_ddc352a1(1)
			end
			if at <= 32 then
				helper_a65ad647(4440085)
			end
			if at <= 33 then
				helper_22a31ecc()
			end
			if at <= 34 then
				helper_a65ad647(4440090)
			end
			if at <= 35 then
				helper_ddc352a1(1)
			end
			if at <= 36 then
				helper_a65ad647(4440100)
			end
			if at <= 37 then
				helper_a65ad647(4440110)
			end
			if at <= 38 then
				helper_a65ad647(4440120)
			end
			if at <= 39 then
				helper_a65ad647(4440125)
			end
			if at <= 40 then
				helper_22a31ecc()
			end
			if at <= 41 then
				helper_ddc352a1(10)
			end
			if at <= 42 then
				helper_a65ad647(4440130)
			end
			if at <= 43 then
				helper_a65ad647(4440140)
			end
			if at <= 44 then
				helper_ddc352a1(10)
			end
			if at <= 45 then
				helper_a65ad647(4440145)
			end
			if at <= 46 then
				helper_22a31ecc()
			end
			if at <= 47 then
				helper_a65ad647(4440150)
			end
			if at <= 48 then
				helper_504dc885(4440160, 50)
			end
			if at <= 49 then
				helper_ddc352a1(8)
			end
			if at <= 50 then
				helper_ddc352a1(9)
			end
			if at <= 51 then
				helper_ddc352a1(8)
			end
			if at <= 52 then
				helper_22a31ecc()
			end
			if at <= 53 then
				helper_5fcc6d89(20)
			end
			if at <= 54 then
				helper_ddc352a1(10)
			end
			if at <= 55 then
				helper_a65ad647(4440170)
			end
			if at <= 56 then
				helper_a65ad647(4440180)
			end
			if at <= 57 then
				helper_ddc352a1(8)
			end
			if at <= 58 then
				helper_ddc352a1(10)
			end
			if at <= 59 then
				helper_5fcc6d89(30)
			end
			if at <= 60 then
				helper_a65ad647(4440190)
			end
			if at <= 61 then
				helper_a65ad647(4440195)
			end
			if at <= 62 then
				helper_22a31ecc()
			end
			if at <= 63 then
				helper_a65ad647(4440200)
			end
			if at <= 64 then
				helper_a65ad647(4440210)
			end
			if at <= 65 then
				helper_a65ad647(4440220)
			end
			if at <= 66 then
				helper_22a31ecc()
			end
			if at <= 67 then
				helper_6068(4440230, -1)
			end
			if at <= 68 then
				helper_a65ad647(4440240)
			end
			if at <= 69 then
				helper_ddc352a1(8)
			end
			if at <= 70 then
				helper_a65ad647(4440245)
			end
			if at <= 71 then
				helper_ddc352a1(9)
			end
			if at <= 72 then
				helper_a65ad647(4440250)
			end
			if at <= 73 then
				helper_a65ad647(4440260)
			end
			if at <= 74 then
				helper_22a31ecc()
			end
			if at <= 75 then
				helper_5fcc6d89(60)
			end
			if at <= 76 then
				helper_5fcc6d89(30)
			end
			if at <= 77 then
				helper_5fcc6d89(4)
			end
			if at <= 78 then
				helper_22a31ecc()
			end
			if at <= 79 then
				helper_5fcc6d89(30)
			end
			if at <= 80 then
				helper_a65ad647(4440270)
			end
			if at <= 81 then
				helper_ddc352a1(10)
			end
			if at <= 82 then
				helper_a65ad647(4440280)
			end
			if at <= 83 then
				helper_ddc352a1(0)
			end
			if at <= 84 then
				helper_a65ad647(4440290)
			end
			if at <= 85 then
				helper_ddc352a1(0)
			end
			if at <= 86 then
				helper_a65ad647(4440300)
			end
			if at <= 87 then
				helper_a65ad647(4440305)
			end
			if at <= 88 then
				helper_ddc352a1(10)
			end
			if at <= 89 then
				helper_ddc352a1(10)
			end
			if at <= 90 then
				helper_5fcc6d89(80)
			end
			if at <= 91 then
				helper_a65ad647(4440310)
			end
			if at <= 92 then
				helper_ddc352a1(8)
			end
			if at <= 93 then
				helper_a65ad647(4440320)
			end
			if at <= 94 then
				helper_a65ad647(4440330)
			end
			if at <= 95 then
				helper_a65ad647(4440335)
			end
			if at <= 96 then
				helper_ddc352a1(8)
			end
			if at <= 97 then
				helper_ddc352a1(8)
			end
			if at <= 98 then
				helper_ddc352a1(8)
			end
			if at <= 99 then
				helper_a65ad647(4440340)
			end
			if at <= 100 then
				helper_f0415042(4440350, 300)
			end
			if at <= 101 then
				helper_ddc352a1(9)
			end
			if at <= 102 then
				helper_5fcc6d89(20)
			end
			if at <= 103 then
				helper_ddc352a1(9)
			end
			if at <= 104 then
				helper_5fcc6d89(30)
			end
			if at <= 105 then
				helper_a65ad647(4440360)
			end
			if at <= 106 then
				helper_ddc352a1(8)
			end
			if at <= 107 then
				helper_5fcc6d89(10)
			end
			if at <= 108 then
				helper_5fcc6d89(40)
			end
			if at <= 109 then
				helper_a65ad647(4440370)
			end
			if at <= 110 then
				helper_ddc352a1(9)
			end
			if at <= 111 then
				helper_a65ad647(4440380)
			end
			if at <= 112 then
				helper_22a31ecc()
			end
			if at <= 113 then
				helper_a65ad647(4440390)
			end
			if at <= 114 then
				helper_a65ad647(4440400)
			end
			if at <= 115 then
				helper_a65ad647(4440410)
			end
			if at <= 116 then
				helper_a65ad647(4440420)
			end
			if at <= 117 then
				helper_a65ad647(4440430)
			end
			if at <= 118 then
				helper_5fcc6d89(4)
			end
			if at <= 119 then
				helper_a65ad647(4440435)
			end
			if at <= 120 then
				helper_5fcc6d89(30)
			end
			if vm.skip_end() then
				return skip(122)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SndSeStop(var0, 7)
		event.SndSeStop(var0, 12)
		event.SndSeStop(var0, 13)
		event.SndSeStop(var0, 15)
		event.ChangeDir("")
		event.CharaActive(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetMotion(1, "立ち", 4)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DeleteChara(20)
		event.DeleteChara(21)
		event.LoadMes(0, -1)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(12, 1)
		event.EohSetShow(13, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(444, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	helper_5fcc6d89(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(53)
	event.LoadSound(4829)
	var0 = event.SndLoadSound(4829) or var0
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
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e444/")
	event.LoadMes(0, 5, "e444.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e444_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e444_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e444_shigura.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CopyChara(5, 10, 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CopyChara(5, 10, 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e444/e444_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e400/e444/e444_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.AssignStack(6)
	event.ClearStack(6)
	event.ChangeDir("event/e400/e444/")
	event.LoadChara(6, "e444_jamming.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(6, "e440_sourcer.gltf", "info", 14)
	event.CharaActive(14)
	event.EohSyncChara(6, 14)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(6, "e444_break.gltf", "info", 15)
	event.CharaActive(15)
	event.SetReference(14, "null6", 15)
	event.LoadChara(6, "e444_guiltoni.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.EohSyncChara(7, 16)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(6, "e444_soldier.gltf", "info", 17)
	event.CharaActive(0, 17)
	event.CopyChara(6, 17, 18)
	event.CharaActive(0, 18)
	event.ChangeDir("")
	event.EohSyncObj(11, "p01_battleship")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncChara(12, 1)
	event.EohSyncChara(13, 2)
	event.EohSetShow(12, 0)
	event.EohSetShow(13, 0)
	event.EohSetPos(0, 252.3, 0.0, 357.5)
	event.EohSetRot(0, 0.0, 1.2, 0.0)
	event.EohSetFootSoundId(0, 14)
	event.EohSetPos(1, 258.89, 0.0, 341.43)
	event.EohSetRot(1, 0.0, 1.2, 0.0)
	event.EohSetFootSoundId(1, 14)
	event.EohSetPos(2, 545.17, 0.0, -7.91)
	event.EohSetRot(2, 0.0, -0.72, 0.0)
	event.EohSetSoundId(2, var0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目赤")
	event.EohSetPos(3, 129.15, 0.0, -26.35)
	event.EohSetRot(3, 0.0, 0.6, 0.0)
	event.EohSetSoundId(3, var0)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目赤")
	event.EohSetPos(4, 570.53, 0.0, 382.62)
	event.EohSetRot(4, 0.0, -1.96, 0.0)
	event.EohSetSoundId(4, var0)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "目赤")
	event.EohSetPos(5, 300.33, 240.0, 240.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetMotion(5, "落ち前（会話）", 4)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "目パチ")
	event.EohSetPos(6, 300.33, 240.0, 240.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetPos(7, 2290.9, 1276.37, 2358.88)
	event.EohSetRot(7, 0.0, -1.92, 0.0)
	event.EohSetMotion(7, "下向き立ち", 4)
	event.EohSetTexAnim(7, 0)
	event.EohSetTexAnim(7, 1, "デフォルト顔")
	event.EohSetTexAnim(7, 1, "下目パチ")
	event.SetCharaPos(17, 2312.3, 1275.66, 2387.69)
	event.SetCharaRot(17, 0.0, -2.16, 0.0)
	event.SetCharaPos(18, 2327.72, 1275.66, 2348.04)
	event.SetCharaRot(18, 0.0, -1.68, 0.0)
	event.EohSetPos(11, 2627.4, 1276.4, 2639.6)
	event.EohSetRot(11, 0.0, -0.767, 0.0)
	event.InitDramaScene()
	time = event.GetTime() or time
	event.SetTimeStepEnable(0)
	event.SndSePlay(var0, 7)
	event.CmrsInit()
	event.CmrsSetPos(300.17, 240.56, 319.36)
	event.CmrsSetRef(300.43, 248.47, 241.14)
	event.SetFadeIn(30)
	helper_a65ad647(4440010)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 8)
	event.ObjsMove(6, 300.33, 230.0, 240.0, 4)
	event.ObjsRotation(6, 0.2, 0.0, -0.4, 4)
	event.ObjsJump(5, 320.44, 0.0, 291.73, -0.14, 60)
	event.ObjsRotation(5, 0.0, 0.36, 0.0, 4)
	event.ObjsSetMotion(5, "落ちるin", 6)
	event.ObjsNextMotion(5, "落ちる", 4)
	helper_5fcc6d89(20)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(318.44, 131.15, 661.43)
	event.CmrsSetRef(322.58, 144.45, 500.53)
	event.SndSeStop(var0, 7)
	event.ObjsMove(6, 290.33, 180.0, 220.0, 30)
	event.ObjsRotation(6, -0.2, -3.14, 0.0, 30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(318.05, 24.6, 353.37)
	event.CmrsSetRef(322.78, 4.36, 298.93)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "目あき～目とじ")
	event.CharaActive(0, 14)
	event.CharaActive(0, 15)
	event.ObjsSetMotion(5, "落ちた", 2)
	event.ObjsMotionWait(5)
	helper_a65ad647(4440020)
	if vm.skipping() then
		return skip(6)
	end
	helper_ddc352a1(5)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(295.12, 92.37, 617.16)
	event.CmrsSetRef(303.66, 107.91, 513.32)
	event.ObjsSetMotion(4, "パウォーンin", 6)
	event.ObjsNextMotion(4, "パウォーンループ", 4)
	event.ObjsSeDelay(4, 10)
	event.ObjsSePlay(4, var0, 9)
	event.ObjsMotionDelay(3, 8)
	event.ObjsSetMotion(3, "パウォーンin", 6)
	event.ObjsNextMotion(3, "パウォーンループ", 4)
	event.ObjsMotionDelay(2, 20)
	event.ObjsSetMotion(2, "パウォーンin", 6)
	event.ObjsNextMotion(2, "パウォーンループ", 4)
	helper_a65ad647(4440030)
	if vm.skipping() then
		return skip(8)
	end
	helper_a65ad647(4440040)
	if vm.skipping() then
		return skip(9)
	end
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(422.0, 274.04, 460.88)
	event.CmrsSetRef(457.86, 277.56, 400.77)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "まばたき目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "まばたき目パチ")
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "まばたき目パチ")
	event.PlayBgm(0)
	helper_5fcc6d89(40)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(218.94, 252.83, 424.76)
	event.CmrsSetRef(320.08, 29.2, 293.98)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "目パチ")
	event.SndSePlay(var0, 10)
	event.ObjsSetPos(2, 614.03, 0.0, 217.01)
	event.ObjsSetRot(2, 0.0, -1.32, 0.0)
	event.ObjsSetMotion(2, "くわえるin", 4)
	event.ObjsNextMotion(2, "くわえるout", 6)
	event.ObjsMotionWait(2)
	event.ObjsSetPos(3, 20.52, 0.0, 157.49)
	event.ObjsSetRot(3, 0.0, 1.08, 0.0)
	event.ObjsSetMotion(3, "見下ろす", 6)
	event.ObjsNextMotion(3, "見下ろすループ", 4)
	event.ObjsSetPos(4, 181.65, 0.0, 660.37)
	event.ObjsSetRot(4, 0.0, 2.64, 0.0)
	helper_5fcc6d89(17)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsNextMotion(5, "くわえるout", 6)
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(229.1, 159.91, 213.0)
	event.CmrsSetRef(331.44, 4.22, 299.73)
	event.CmrsMove2(320.69, 24.73, 290.62, 331.44, 4.22, 299.73, 60, 0, 0.8)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "目とじ")
	event.ObjsSetMotion(2, "なめるin", 6)
	event.ObjsNextMotion(2, "なめるループ", 4)
	helper_5fcc6d89(50)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "しか目とじ")
	event.ObjsSetMotion(5, "なめるループ", 4)
	helper_22a31ecc()
	if vm.skipping() then
		return skip(16)
	end
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "しか目とじ～目あき")
	event.ObjsSetMotion(5, "目を覚ます", 2)
	event.ObjsNextMotion(5, "目を覚ます（会話）", 4)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(17)
	end
	helper_a65ad647(4440050)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(394.66, 61.86, 362.9)
	event.CmrsSetRef(331.44, 4.22, 299.73)
	event.CmrsMove2(2396.78, 1356.17, 2363.54, 331.44, 4.22, 299.73, 120, 0, 0.2)
	event.SndSePlay(var0, 12)
	helper_22a31ecc()
	if vm.skipping() then
		return skip(19)
	end
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(2123.1, 1250.04, 2302.95)
	event.CmrsSetRef(2287.46, 1298.13, 2360.01)
	event.CmrsMove2(2196.82, 1272.46, 2328.55, 2287.46, 1298.13, 2360.01, 30, 0, 1.0)
	event.SndSePlay(var0, 13)
	event.CharaActive(16)
	event.CharaActive(17)
	event.CharaActive(18)
	event.ObjsSetMotion(7, "下向き会話", 2)
	event.ObjsNextMotion(7, "下向き立ち", 4)
	event.SetPakuAnim(7, "通常口パク")
	helper_a65ad647(4440060)
	if vm.skipping() then
		return skip(21)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(7, "通常口パク")
	helper_a65ad647(4440065)
	if vm.skipping() then
		return skip(23)
	end
	event.SndSePlay(var0, 14)
	event.ObjsSetMotion(7, "振り返り", 2)
	event.ObjsRotation2(7, 0.0, 1.2, 0.0, 20, 0, 1.0)
	event.ObjsNextMotion(7, "歩き", 4)
	event.ObjsPosDelay(7, 45)
	event.ObjsMove(7, 2312.24, 1276.37, 2366.29, 30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(24)
	end
	helper_504dc885(4440070, 30)
	if vm.skipping() then
		return skip(25)
	end
	helper_ddc352a1(7)
	if vm.skipping() then
		return skip(26)
	end
	event.SndSeStop(var0, 12)
	event.SndSeStop(var0, 13)
	event.CmrsSetPos(307.51, 36.12, 379.62)
	event.CmrsSetRef(354.57, 49.17, 421.92)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(0, 14)
	event.CharaActive(0, 15)
	event.CharaActive(0, 16)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.DeleteChara(13)
	event.DeleteChara(14)
	event.DeleteChara(15)
	event.DeleteChara(16)
	event.DeleteChara(17)
	event.DeleteChara(18)
	event.ChangeDir("event/e400/e444/")
	event.SetLoadbgFile("e444_baru.gltf", "e444_paw.gltf", "e444_shigu.gltf")
	event.SndSePlay(var0, 15)
	do
		local out1, out2, out3 = event.EohGetPos(11)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pos_x = vm.f32(vm.f32(vm.sin(vm.f32(-0.767)) * 600.0) + pos_x)
	pos_y = vm.f32(pos_y + 1900.0)
	pos_z = vm.f32(vm.f32(vm.cos(vm.f32(-0.767)) * 600.0) + pos_z)
	event.ObjsRotation2(11, 0.12, -0.767, 0.0, 60, 0, 1.0)
	event.ObjsRotation2(11, 0.0, 1.0, 0.0, 60, 1, 1.0)
	event.ObjsPosDelay(11, 10)
	event.ObjsMove2(11, pos_x, pos_y, pos_z, 120, 1, 1.0)
	helper_ddc352a1(11)
	if vm.skipping() then
		return skip(27)
	end
	pos_x = vm.f32(vm.f32(vm.sin(1.0) * 16000.0) + pos_x)
	pos_y = vm.f32(pos_y - 2000.0)
	pos_z = vm.f32(vm.f32(vm.cos(1.0) * 16000.0) + pos_z)
	event.ObjsMove(11, pos_x, pos_y, pos_z, 240)
	helper_ddc352a1(11)
	if vm.skipping() then
		return skip(28)
	end
	helper_066106e5()
	if vm.skipping() then
		return skip(29)
	end
	event.ClearStack(6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.LoadChara(6, "e444_baru.gltf", "info", 21)
	event.CharaActive(21)
	event.EohSyncChara(10, 21)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSetPos(10, -49.41, 0.0, 184.42)
	event.EohSetRot(10, 0.0, 1.06, 0.0)
	event.EohSetMotion(10, "立ち（下見）", 4)
	event.EohSetTexAnim(10, 0)
	event.EohSetTexAnim(10, 1, "目パチ")
	event.EohSetSoundId(10, var0)
	event.LoadChara(6, "e444_paw.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(8, 19)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSetPos(8, 743.96, 0.0, 405.8)
	event.EohSetRot(8, 0.0, -1.68, 0.0)
	event.EohSetMotion(8, "立ち", 4)
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "目パチ")
	event.EohSetFootSoundId(8, 14)
	event.LoadChara(6, "e444_shigu.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(9, 20)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "目パチ")
	event.EohSetPos(9, 820.94, 0.0, 396.57)
	event.EohSetRot(9, 0.0, -1.68, 0.0)
	event.EohSetMotion(9, "立ち", 4)
	event.EohSetSoundId(9, var0)
	event.ChangeDir("")
	event.CmrsMove2(199.68, 6.1, 282.7, 354.57, 49.17, 421.92, 60, 0, 1.0)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	helper_22a31ecc()
	if vm.skipping() then
		return skip(30)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "左・振り返る", 6)
	event.ObjsNextMotion(0, "左・振り返るL", 4)
	event.ObjsSeDelay(0, 26)
	event.ObjsSePlay(0, var0, 16)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "バル見右振り返る", 6)
	event.ObjsNextMotion(1, "バル見右振り返るL", 4)
	helper_a65ad647(4440080)
	if vm.skipping() then
		return skip(31)
	end
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(231.08, 133.37, 346.07)
	event.CmrsSetRef(117.53, 106.94, 279.75)
	event.CmrsMove2(231.08, 133.37, 346.07, 117.53, 192.74, 279.75, 40, 2, 1.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(0, 0.0, -2.08, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -2.08, 0.0)
	event.SetPakuMotion(10, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4440085)
	if vm.skipping() then
		return skip(33)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(238.96, 20.42, 316.49)
	event.CmrsSetRef(263.11, 21.75, 361.47)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "あきれ顔")
	event.EohSetTexAnim(1, 1, "あきれ目パチ")
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4440090)
	if vm.skipping() then
		return skip(35)
	end
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(222.1, 248.84, 164.7)
	event.CmrsSetRef(72.33, 243.65, 235.39)
	event.EohSetTexAnim(10, 0)
	event.EohSetTexAnim(10, 1, "通常目～おどろき目")
	event.SetPakuMotion(10, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4440100)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(377.63, 113.56, -196.18)
	event.CmrsSetRef(139.89, 126.6, 285.69)
	event.CmrsMoveAhd2(1.08, -13.04, 537.3, 350, 0, 0.2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4440110)
	if vm.skipping() then
		return skip(38)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4440120)
	if vm.skipping() then
		return skip(39)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4440125)
	if vm.skipping() then
		return skip(40)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(41)
	end
	event.EohSetTexAnim(10, 0)
	event.EohSetTexAnim(10, 1, "半目")
	event.ObjsSetMotion(10, "頭下げin", 2)
	event.ObjsMotionWait(10)
	helper_ddc352a1(10)
	if vm.skipping() then
		return skip(42)
	end
	event.SetPakuMotion(10, "頭下げ（会話）", 0, "頭下げループ", 0)
	helper_a65ad647(4440130)
	if vm.skipping() then
		return skip(43)
	end
	event.EohSetTexAnim(10, 0)
	event.EohSetTexAnim(10, 1, "目とじ")
	event.CmrsMoveAhd2(-0.59, -13.04, 537.3, 350, 0, 0.2)
	event.SetPakuMotion(10, "頭下げ（会話）", 0, "頭下げループ", 0)
	helper_a65ad647(4440140)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(10, "うなだれるin", 2)
	event.ObjsMotionWait(10)
	helper_ddc352a1(10)
	if vm.skipping() then
		return skip(45)
	end
	event.SetPakuMotion(10, "うなだれる（会話）", 0, "うなだれるループ", 0)
	helper_a65ad647(4440145)
	if vm.skipping() then
		return skip(46)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "右・振り向く", 6)
	event.ObjsNextMotion(0, "右・振り向くL", 4)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "上見から振り返り", 6)
	event.ObjsNextMotion(1, "上見から振り返りL", 4)
	helper_a65ad647(4440150)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(495.19, 17.84, 361.84)
	event.CmrsSetRef(690.07, 37.26, 383.0)
	event.CharaActive(19)
	event.CharaActive(20)
	event.ObjsMove(8, 560.22, 0.0, 376.68, 60)
	event.ObjsSetMotion(8, "走り", 4)
	event.ObjsMove(9, 730.38, 0.0, 386.74, 60)
	event.ObjsSetMotion(9, "歩き", 4)
	helper_504dc885(4440160, 50)
	if vm.skipping() then
		return skip(49)
	end
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(50)
	end
	helper_ddc352a1(9)
	if vm.skipping() then
		return skip(51)
	end
	event.CmrsSetPos(268.74, 17.84, 243.45)
	event.CmrsSetRef(253.91, 23.46, 365.24)
	event.EohSetTexAnim(10, 0)
	event.EohSetTexAnim(10, 1, "目パチ")
	event.ObjsSetRot(1, 0.0, 2.76, 0.0)
	event.ObjsSetMotion(1, "右向くL", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "右向く戻り", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 6)
	event.ObjsTexaDelay(1, 16)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "前向き～左向き")
	event.ObjsSetRot(0, 0.0, 3.0, 0.0)
	event.ObjsSetMotion(0, "右向くL", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 16)
	event.ObjsSetMotion(0, "右向く戻り", 4, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 6)
	event.ObjsTexaDelay(0, 16)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "前向き～左向き")
	event.ObjsSetPos(8, 320.83, 0.0, 352.35)
	event.ObjsSetRot(8, 0.0, -2.04, 0.0)
	event.ObjsMove(8, 266.83, 0.0, 323.49, 40)
	event.ObjsMotionDelay(8, 40)
	event.ObjsSetMotion(8, "息切れ")
	event.ObjsSetPos(9, 452.72, 0.0, 425.6)
	event.ObjsSetRot(9, 0.0, -2.04, 0.0)
	event.ObjsMove(9, 389.06, 0.0, 393.13, 60)
	event.ObjsMotionDelay(9, 60)
	event.ObjsSetMotion(9, "立ち")
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(52)
	end
	event.CmrsSetPos(248.36, 14.52, 315.22)
	event.CmrsSetRef(272.47, 6.08, 326.81)
	event.CmrsMove2(248.36, 14.52, 315.22, 272.47, 17.46, 326.81, 30, 0, 1.0)
	helper_22a31ecc()
	if vm.skipping() then
		return skip(53)
	end
	helper_5fcc6d89(20)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(0, 0.0, -2.08, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -2.08, 0.0)
	event.ObjsSetMotion(8, "上見立ち", 4)
	event.CmrsSetPos(709.01, 282.92, 118.6)
	event.CmrsSetRef(526.53, 220.56, 171.63)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SndSePlay(var0, 17)
	event.ObjsSetMotion(10, "顔よせin", 6)
	event.ObjsMotionWait(10)
	helper_ddc352a1(10)
	if vm.skipping() then
		return skip(55)
	end
	event.SetPakuMotion(10, "顔よせ（会話）", 0, "顔よせループ", 0)
	helper_a65ad647(4440170)
	if vm.skipping() then
		return skip(56)
	end
	event.CmrsSetPos(241.68, 16.71, 309.43)
	event.CmrsSetRef(266.8, 16.62, 323.29)
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "てれ目パチ")
	event.ObjsSetMotion(8, "てれる", 6)
	event.ObjsNextMotion(8, "てれるL", 4)
	helper_a65ad647(4440180)
	if vm.skipping() then
		return skip(57)
	end
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(58)
	end
	event.CmrsSetPos(582.83, 16.71, 236.56)
	event.CmrsSetRef(218.16, 115.67, 270.9)
	event.ObjsSetMotion(8, "上見立ち", 4)
	event.ObjsSetMotion(10, "顔よせout", 6)
	event.ObjsMotionWait(10)
	helper_ddc352a1(10)
	if vm.skipping() then
		return skip(59)
	end
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(60)
	end
	event.SetPakuMotion(10, "シグー見（会話）", 0, "立ち", 0)
	helper_a65ad647(4440190)
	if vm.skipping() then
		return skip(61)
	end
	event.CmrsSetPos(223.01, 93.87, 310.22)
	event.CmrsSetRef(354.09, 88.95, 375.33)
	event.CmrsMoveAhd2(2.61, 4.92, 146.36, 120, 0, 0.6)
	helper_a65ad647(4440195)
	if vm.skipping() then
		return skip(62)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(63)
	end
	event.CmrsSetPos(592.78, 70.05, 215.14)
	event.CmrsSetRef(193.64, 115.67, 314.46)
	event.CmrsMoveAhd2(1.09, 289.34, 602.63, 360, 0, 1.0)
	event.SetPakuMotion(10, "シグー見（会話）", 0, "立ち", 0)
	helper_a65ad647(4440200)
	if vm.skipping() then
		return skip(64)
	end
	event.SetPakuMotion(10, "シグー見（会話）", 0, "立ち", 0)
	helper_a65ad647(4440210)
	if vm.skipping() then
		return skip(65)
	end
	event.SetPakuMotion(10, "シグー見（会話）", 0, "立ち", 0)
	helper_a65ad647(4440220)
	if vm.skipping() then
		return skip(66)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(67)
	end
	event.CmrsSetPos(270.35, 12.55, 273.69)
	event.CmrsSetRef(266.43, 13.93, 321.78)
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "さみし目パチ")
	event.ObjsSetMotion(8, "うなだれ", 4)
	helper_6068(4440230, -1)
	if vm.skipping() then
		return skip(68)
	end
	event.ObjsMotionDelay(8, 20)
	event.ObjsSetMotion(8, "上見る", 2)
	event.ObjsNextMotion(8, "上見立ち", 4)
	helper_a65ad647(4440240)
	if vm.skipping() then
		return skip(69)
	end
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(70)
	end
	helper_a65ad647(4440245)
	if vm.skipping() then
		return skip(71)
	end
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "笑い目とじ")
	event.ObjsSetMotion(8, "じゃれる", 6)
	event.ObjsNextMotion(8, "じゃれるL", 4)
	event.ObjsSetPos(9, 378.05, 0.0, 378.96)
	event.ObjsSetMotion(9, "じゃれる", 6)
	event.ObjsNextMotion(9, "じゃれるL", 4)
	helper_ddc352a1(9)
	if vm.skipping() then
		return skip(72)
	end
	helper_a65ad647(4440250)
	if vm.skipping() then
		return skip(73)
	end
	event.CmrsSetPos(224.1, 15.74, 287.53)
	event.CmrsSetRef(268.95, 17.12, 321.25)
	event.CmrsMove2(248.67, 15.74, 306.0, 268.95, 17.12, 321.25, 60, 0, 1.0)
	event.ObjsSetMotion(1, "右向くL", 4, -1.0, 1)
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "さみし目～片目とじ")
	helper_a65ad647(4440260)
	if vm.skipping() then
		return skip(74)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(75)
	end
	event.FadeOutBgm(60)
	event.SetFadeOut(60)
	helper_5fcc6d89(60)
	if vm.skipping() then
		return skip(76)
	end
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(77)
	end
	event.CmrsSetPos(923.53, 319.36, 605.97)
	event.CmrsSetRef(937.39, 309.52, 676.43)
	event.StopBgm(0)
	helper_5fcc6d89(4)
	if vm.skipping() then
		return skip(78)
	end
	event.LoadBgm(112)
	event.SetTime(17.5)
	event.ObjsSetPos(0, 324.85, 0.0, 743.21)
	event.ObjsSetRot(0, 0.0, -2.44, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 339.43, 0.0, 730.36)
	event.ObjsSetRot(1, 0.0, -2.44, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(8, 358.56, 0.0, 715.56)
	event.ObjsSetRot(8, 0.0, -2.44, 0.0)
	event.ObjsSetMotion(8, "上見立ち", 4)
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "目パチ")
	event.ObjsSetPos(9, 354.38, 0.0, 381.34)
	event.ObjsSetRot(9, 0.0, 0.36, 0.0)
	event.ObjsSetMotion(9, "立ち", 4)
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "目パチ")
	event.ObjsSetPos(10, 84.12, 0.0, 476.19)
	event.ObjsSetRot(10, 0.0, 0.7, 0.0)
	event.ObjsSetMotion(10, "立ち（下見）", 4)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(260)
	event.CmrsAddPas(923.53, 319.36, 605.97, 937.39, 309.52, 676.43)
	event.CmrsAddPas(923.53, 319.36, 605.97, 902.6, 309.52, 674.74)
	event.CmrsAddPas(923.53, 319.36, 605.97, 882.59, 309.48, 665.11)
	event.CmrsAddPas(923.53, 319.36, 605.97, 865.02, 306.16, 647.98)
	event.CmrsAddPas(923.53, 319.36, 605.97, 852.74, 302.36, 620.25)
	event.CmrsAddPas(923.53, 319.36, 605.97, 851.29, 295.52, 603.41)
	event.CmrsStartPas()
	event.SetFadeIn(60)
	helper_22a31ecc()
	if vm.skipping() then
		return skip(79)
	end
	event.SetCrossfade(60)
	event.CmrsSetPos(223.45, 515.0, 150.38)
	event.CmrsSetRef(212.66, 211.08, 449.02)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "さみし顔")
	event.EohSetTexAnim(0, 1, "さみし目パチ")
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(80)
	end
	event.SetPakuMotion(10, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4440270)
	if vm.skipping() then
		return skip(81)
	end
	helper_ddc352a1(10)
	if vm.skipping() then
		return skip(82)
	end
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_a65ad647(4440280)
	if vm.skipping() then
		return skip(83)
	end
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(84)
	end
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "うなだれる", 6)
	event.ObjsNextMotion(0, "うなだれるL", 4)
	event.SetPakuMotion(10, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4440290)
	if vm.skipping() then
		return skip(85)
	end
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(86)
	end
	event.ObjsSetMotion(0, "うなだれる戻り", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuMotion(10, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4440300)
	if vm.skipping() then
		return skip(87)
	end
	event.SetPakuMotion(10, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4440305)
	if vm.skipping() then
		return skip(88)
	end
	event.SndSePlay(var0, 18)
	event.ObjsSetMotion(10, "歩き")
	event.ObjsChengeStep(10, 0.02)
	event.ObjsRotation2(10, 0.0, -0.74, 0.0, 60, 0, 1.0)
	event.ObjsMove2(10, -91.56, 0.0, 632.05, 160, 1, 1.0)
	helper_ddc352a1(10)
	if vm.skipping() then
		return skip(89)
	end
	event.CmrsSetPos(4.01, 520.98, 81.91)
	event.CmrsSetRef(-200.88, 47.61, 516.52)
	event.ObjsSetPos(10, -330.83, 0.0, 588.98)
	event.ObjsSetRot(10, 0.0, -1.1, 0.0)
	event.ObjsMove(10, -606.74, -12.0, 763.16, 220)
	event.ObjsSetMotion(10, "水歩き", 4)
	event.CharaActive(10)
	event.ObjsSetPos(2, 45.1, 0.0, 642.1)
	event.ObjsSetRot(2, 0.0, -1.1, 0.0)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsSetMotionNowTime(2, 12.0)
	event.ObjsMove(2, -182.51, 0.0, 778.98, 220)
	event.CharaActive(11)
	event.ObjsSetPos(3, 13.41, 0.0, 156.64)
	event.ObjsSetRot(3, 0.0, -1.1, 0.0)
	event.ObjsSetMotion(3, "歩き", 4)
	event.ObjsSetMotionNowTime(3, 20.0)
	event.ObjsMove(3, -190.65, 0.0, 240.14, 220)
	helper_ddc352a1(10)
	if vm.skipping() then
		return skip(90)
	end
	event.CmrsSetPos(163.44, 190.58, 781.74)
	event.CmrsSetRef(-41.96, 53.55, 668.25)
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "さみし目パチ")
	event.PlayBgm(0)
	event.CharaActive(0, 0)
	event.CharaActive(0, 8)
	event.CharaActive(0, 8)
	event.CharaActive(0, 21)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.ObjsSetPos(8, -50.0, 0.0, 725.0)
	event.ObjsSetRot(8, 0.0, -3.14, 0.0)
	event.ObjsSetMotion(8, "上見立ち", 4)
	event.ObjsSetPos(9, -50.0, 0.0, 530.0)
	event.ObjsSetRot(9, 0.0, 0.0, 0.0)
	event.ObjsMove(9, -50.0, 0.0, 590.0, 60)
	event.ObjsSetMotion(9, "歩き", 4)
	event.ObjsMotionDelay(9, 60)
	event.ObjsSetMotion(9, "立ち")
	helper_5fcc6d89(80)
	if vm.skipping() then
		return skip(91)
	end
	event.SndSePlay(var0, 19)
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "目あき～目とじ")
	event.ObjsSetMotion(8, "なでる", 6)
	event.ObjsNextMotion(8, "なでるL", 4)
	event.ObjsSetMotion(9, "なでる", 6)
	event.ObjsNextMotion(9, "なでるL", 4)
	helper_a65ad647(4440310)
	if vm.skipping() then
		return skip(92)
	end
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(93)
	end
	helper_a65ad647(4440320)
	if vm.skipping() then
		return skip(94)
	end
	event.SndSePlay(var0, 20)
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "目とじ～目あき")
	event.ObjsSetMotion(9, "なでる戻り", 6)
	event.ObjsNextMotion(9, "立ち", 4)
	event.ObjsSetMotion(8, "なでる戻り", 6)
	event.ObjsNextMotion(8, "うなだれ", 4)
	helper_a65ad647(4440330)
	if vm.skipping() then
		return skip(95)
	end
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "通常目～さみし目")
	event.ObjsSetMotion(8, "左指す", 6)
	event.ObjsNextMotion(8, "左指すL", 4)
	helper_a65ad647(4440335)
	if vm.skipping() then
		return skip(96)
	end
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(97)
	end
	event.ObjsMotionDelay(9, 24)
	event.ObjsSetMotion(9, "左見る", 6)
	event.ObjsNextMotion(9, "左見るL", 4)
	event.ObjsSetMotion(8, "左指す戻り", 6)
	event.ObjsNextMotion(8, "うつむき走り")
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(98)
	end
	event.ObjsRotation(8, 0.0, 1.57, 0.0, 8)
	event.ObjsMove(8, 35.37, 0.0, 725.0, 30)
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(99)
	end
	event.CmrsSetPos(242.62, 3.04, 743.15)
	event.CmrsSetRef(144.17, 27.78, 743.82)
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "さみし目パチ")
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "泣き目とじ")
	event.CharaActive(21)
	event.ObjsSetPos(10, -6173.0, -82.0, 401.0)
	event.ObjsSetRot(10, 0.0, -1.58, 0.0)
	event.CharaActive(10)
	event.ObjsSetPos(2, -4863.0, -82.0, -403.0)
	event.ObjsSetRot(2, 0.0, -1.58, 0.0)
	event.CharaActive(11)
	event.ObjsSetPos(3, -3769.0, -82.0, 836.0)
	event.ObjsSetRot(3, 0.0, -1.46, 0.0)
	event.ObjsSetPos(8, 190.82, 0.0, 753.88)
	event.ObjsSetMotion(8, "泣く", 4)
	event.ObjsSetPos(9, -49.43, 0.0, 673.38)
	helper_a65ad647(4440340)
	if vm.skipping() then
		return skip(100)
	end
	event.ObjsSetMotion(9, "左見る戻り", 2)
	event.ObjsNextMotion(9, "歩き")
	event.ObjsChengeStep(9, 0.02)
	event.ObjsMotionDelay(9, 140)
	event.ObjsNextMotion(9, "水歩き", 4)
	event.ObjsRotation2(9, 0.0, -1.57, 0.0, 60, 0, 1.0)
	event.ObjsMove2(9, -838.9, -25.0, 648.72, 300, 1, 1.0)
	helper_f0415042(4440350, 300)
	if vm.skipping() then
		return skip(101)
	end
	helper_ddc352a1(9)
	if vm.skipping() then
		return skip(102)
	end
	event.ObjsSetMotion(9, "立ち")
	event.ObjsChengeStep(9, 0.02)
	helper_5fcc6d89(20)
	if vm.skipping() then
		return skip(103)
	end
	event.ObjsSetMotion(9, "左見る", 6)
	event.ObjsNextMotion(9, "左見るL", 4)
	helper_ddc352a1(9)
	if vm.skipping() then
		return skip(104)
	end
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(105)
	end
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "なみだ目")
	event.ObjsMotionDelay(8, 10)
	event.ObjsMotionWait(8)
	event.ObjsSetMotion(8, "顔上げる", 6)
	event.ObjsNextMotion(8, "立ち", 4)
	event.ObjsTexaDelay(8, 10)
	event.ObjsTexAnime(8, 1, "泣き目とじ～目あけ")
	helper_a65ad647(4440360)
	if vm.skipping() then
		return skip(106)
	end
	helper_ddc352a1(8)
	if vm.skipping() then
		return skip(107)
	end
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(108)
	end
	event.ObjsSetMotion(9, "左見る戻り", 6)
	event.ObjsNextMotion(9, "歩き")
	event.SndSePlay(var0, 21)
	event.ObjsRotation(8, 0.0, -1.57, 0.0, 10)
	event.ObjsMove(8, -125.45, 0.0, 754.45, 60)
	event.ObjsSetMotion(8, "走り")
	event.ObjsMotionDelay(8, 60)
	event.ObjsSetMotion(8, "叫ぶ")
	helper_5fcc6d89(40)
	if vm.skipping() then
		return skip(109)
	end
	event.CmrsSetPos(-997.46, 75.59, 665.14)
	event.CmrsSetRef(-897.68, 82.51, 666.04)
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "泣き目パチ")
	event.ObjsSetMotion(9, "立ち")
	event.ObjsChengeStep(9, 0.02)
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "なみだ目～うれし目")
	helper_a65ad647(4440370)
	if vm.skipping() then
		return skip(110)
	end
	event.CmrsSetPos(-772.6, 67.51, 676.22)
	event.CmrsSetRef(-873.85, 79.6, 666.69)
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "キラ目")
	event.ObjsSetMotion(9, "左見る", 6)
	event.ObjsNextMotion(9, "左見るL", 4)
	helper_ddc352a1(9)
	if vm.skipping() then
		return skip(111)
	end
	helper_a65ad647(4440380)
	if vm.skipping() then
		return skip(112)
	end
	event.CmrsMove2(-48.23, 14.46, 744.38, -873.85, 79.6, 666.69, 60.0, 0, 1.0)
	event.ObjsSetMotion(8, "手を振る", 4)
	event.ObjsSetMotion(9, "左見る戻り", 2)
	event.ObjsNextMotion(9, "立ち", 4)
	event.ObjsChengeStep(9, 0.02)
	helper_22a31ecc()
	if vm.skipping() then
		return skip(113)
	end
	helper_a65ad647(4440390)
	if vm.skipping() then
		return skip(114)
	end
	helper_a65ad647(4440400)
	if vm.skipping() then
		return skip(115)
	end
	event.SetCharaShow(20, 0, 1, 0.01)
	event.SetCharaShow(11, 0, 1, 0.01)
	event.SetCharaShow(10, 0, 1, 0.01)
	event.SetCharaShow(21, 0, 1, 0.01)
	helper_a65ad647(4440410)
	if vm.skipping() then
		return skip(116)
	end
	helper_a65ad647(4440420)
	if vm.skipping() then
		return skip(117)
	end
	event.SetCharaType(19, 4)
	event.SetCharaShow(19, 0, 1, 0.01)
	helper_a65ad647(4440430)
	if vm.skipping() then
		return skip(118)
	end
	helper_5fcc6d89(4)
	if vm.skipping() then
		return skip(119)
	end
	event.SetCrossfade(60)
	event.CharaActive(0, 19)
	event.SetTime(24.0)
	helper_a65ad647(4440435)
	if vm.skipping() then
		return skip(120)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(121)
	end
	return part2()
end

--- Helper function.
local function helper_10468()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadMonsterFile(522, 1)
	event.LoadMonsterFile(514, 0)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
		0.0,
		0.5235988,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
		0.0,
		1.5707964,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
		0.0,
		2.617994,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
		0.0,
		-2.617994,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
		0.0,
		-1.5707964,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
		0.0,
		-0.5235988,
		0.0
	)
	event.AutoSetMonster(522, 0, 0, 0)
	event.EohSyncObj(0, "p04_d04b01")
	event.EohSetShow(0, 1)
	if vm.wait() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1c9a4(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_ddc352a1(1)
			end
			if at <= 2 then
				helper_a65ad647(4360030)
			end
			if at <= 3 then
				helper_ddc352a1(1)
			end
			if at <= 4 then
				helper_a65ad647(4360035)
			end
			if at <= 5 then
				helper_5fcc6d89(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsInit()
		event.CharaActive(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.LoadMes(0, -1)
		if active_chr_no == 0 then
			event.ObjsSetPos(0, 0.0, 0.0, 180.0)
		else
			event.ObjsSetPos(1, 0.0, 0.0, 180.0)
		end
		event.CmrsSetPos(0.0, 30.0, 280.0)
		event.CmrsSetRef(0.0, 30.0, 180.0)
		if vm.wait() then
			return skip(8)
		end
		event.SetFadeIn(30)
		event.Finish()
	end
	event.SetMotion(0, "立ち")
	event.SetFadeOut(15)
	helper_5fcc6d89(15)
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var5 = out2 or var5
	end
	event.SetWorldCoord(var1, var2, var3, var5)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e436/")
	event.LoadMes(0, 5, "e436.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e436_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e436_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 16)
		event.LoadEquip(5, 0, 4, "info", 16)
		event.LoadEquip(5, 0, 3, "info", 16)
		event.LoadEquip(5, 0, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e436/e436_mints.gltf", "info", 16)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 16)
		event.EohSyncChara(0, 16)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 16)
		event.LoadEquip(5, 1, 4, "info", 16)
		event.LoadEquip(5, 1, 3, "info", 16)
		event.LoadEquip(5, 1, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e436/e436_monica.gltf", "info", 16)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 16)
		event.EohSyncChara(1, 16)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(16)
	event.CharaActive(17)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, -8.0, 0.0, 180.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "上向くL", 4)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.EohSetFootSoundId(0, 14)
	event.EohSetPos(1, 8.0, 0.0, 180.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "上向くL", 4)
	event.EohNormalDrive(1)
	event.EohResetDaPosition(1)
	event.EohSetFootSoundId(1, 14)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 30.0, 280.0)
	event.CmrsSetRef(0.0, 30.0, 100.0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "がっくり", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_a65ad647(4360030)
	if vm.skipping() then
		return skip(3)
	end
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	helper_a65ad647(4360035)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_cb38(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9e457fe2(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_9e457fe2(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_b5fd3167(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_16ffc()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 30 then
			if at <= 1 then
				var0 = 8
				helper_5fcc6d89(4)
			end
			if at <= 2 then
				helper_5fcc6d89(10)
			end
			if at <= 3 then
				helper_ddc352a1(1)
			end
			if at <= 4 then
				helper_5fcc6d89(10)
			end
			if at <= 5 then
				helper_a65ad647(4340010)
			end
			if at <= 6 then
				helper_a65ad647(4340015)
			end
			if at <= 7 then
				helper_22a31ecc()
			end
			if at <= 8 then
				helper_a65ad647(4340020)
			end
			if at <= 9 then
				helper_ddc352a1(0)
			end
			if at <= 10 then
				helper_a65ad647(4340030)
			end
			if at <= 11 then
				helper_a65ad647(4340040)
			end
			if at <= 12 then
				helper_ddc352a1(0)
			end
			if at <= 13 then
				helper_a65ad647(4340045)
			end
			if at <= 14 then
				helper_a65ad647(4340050)
			end
			if at <= 15 then
				helper_a65ad647(4340060)
			end
			if at <= 16 then
				helper_a65ad647(4340070)
			end
			if at <= 17 then
				helper_ddc352a1(2)
			end
			if at <= 18 then
				helper_ddc352a1(2)
			end
			if at <= 19 then
				helper_a65ad647(4340075)
			end
			if at <= 20 then
				helper_5fcc6d89(50)
			end
			if at <= 21 then
				helper_ddc352a1(2)
			end
			if at <= 22 then
				helper_5fcc6d89(30)
			end
			if at <= 23 then
				helper_cb38(375, 1)
			end
			if at <= 24 then
				helper_5fcc6d89(4)
			end
			if at <= 25 then
				helper_a65ad647(4340080)
			end
			if at <= 26 then
				helper_a65ad647(4340090)
			end
			if at <= 27 then
				helper_a65ad647(4340100)
			end
			if at <= 28 then
				helper_a65ad647(4340110)
			end
			if at <= 29 then
				helper_5fcc6d89(30)
			end
			if vm.skip_end() then
				return skip(31)
			end
			return part2()
		end
		if at <= 32 then
			helper_a1f03a46(0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.PlayBgm(0)
		event.CmrsInit()
		event.CharaActive(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DeleteChara(20)
		event.LoadMes(0, -1)
		if active_chr_no == 0 then
			event.ObjsSetPos(0, 0.0, 0.0, 180.0)
		else
			event.ObjsSetPos(1, 0.0, 0.0, 180.0)
		end
		event.CmrsSetPos(0.0, 30.0, 280.0)
		event.CmrsSetRef(0.0, 30.0, 180.0)
		if vm.wait() then
			return skip(32)
		end
		helper_a1f03a46(0)
		if vm.skipping() then
			return skip(33)
		end
		event.SetFadeIn(30)
		event.Finish()
	end
	event.SetMotion(0, "立ち")
	event.SetFadeOut(15)
	helper_5fcc6d89(15)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(434, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = 8
	do
		local out1, out2, out3 = event.GetCharaPos(var0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local _, out2, _ = event.GetCharaRot(var0)
		var5 = out2 or var5
	end
	event.SetWorldCoord(var1, var2, var3, var5)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	var8 = event.GetBgmNo() or var8
	if var8 ~= 3 then
		event.StopBgm(0)
		helper_5fcc6d89(4)
		if vm.skipping() then
			return skip(2)
		end
		event.LoadBgm(3)
		event.PlayBgm(0)
	end
	event.LoadSound(4817)
	var9 = event.SndLoadSound(4817) or var9
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e434/")
	event.LoadMes(0, 5, "e434.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e434_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e434_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.EohSyncChara(2, 8)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e434_honyaku_y.gltf", "info", 18)
	event.CharaActive(18)
	event.LoadChara(5, "e434_honyaku_m.gltf", "info", 19)
	event.CharaActive(19)
	event.LoadChara(5, "e434_hiyaku.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 16)
		event.LoadEquip(5, 0, 4, "info", 16)
		event.LoadEquip(5, 0, 3, "info", 16)
		event.LoadEquip(5, 0, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e434/e434_mints.gltf", "info", 16)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 16)
		event.EohSyncChara(0, 16)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 16)
		event.LoadEquip(5, 1, 4, "info", 16)
		event.LoadEquip(5, 1, 3, "info", 16)
		event.LoadEquip(5, 1, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e434/e434_monica.gltf", "info", 16)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 16)
		event.EohSyncChara(1, 16)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(16)
	event.CharaActive(17)
	event.EohSyncChara(3, 1)
	event.EohSyncChara(4, 2)
	event.EohSetShow(3, 0)
	event.EohSetShow(4, 0)
	if active_chr_no == 0 then
		event.SetReference(0, "item", 18)
		event.SetReference(0, "item", 20)
		event.SetReference(16, "item", 19)
	else
		event.SetReference(0, "item", 19)
		event.SetReference(16, "item", 18)
		event.SetReference(16, "item", 20)
	end
	event.EohSetPos(0, 8.0, 0.0, 310.0)
	event.EohSetRot(0, 0.0, -2.9, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -8.0, 0.0, 310.0)
	event.EohSetRot(1, 0.0, 2.9, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetMotion(2, "立ち（下見）", 4)
	event.ObjsSetMotion(0, "耳に当てる", 6, -1.0, 1)
	event.ObjsNextMotion(0, "耳に当てるL", 4)
	event.ObjsSetMotion(1, "耳に当てる", 6, -1.0, 1)
	event.ObjsNextMotion(1, "耳に当てるL", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 22.0, 360.0)
	event.CmrsSetRef(0.0, 22.0, 236.0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var9, 0)
	helper_ddc352a1(1)
	if vm.skipping() then
		return skip(4)
	end
	helper_5fcc6d89(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsMove2(0.0, 130.0, 700.0, 0.0, 130.0, 100.0, 60, 0, 1.0)
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4340010)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4340015)
	if vm.skipping() then
		return skip(7)
	end
	helper_22a31ecc()
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(0.0, 51.02, 278.53)
	event.CmrsSetRef(0.0, 17.44, 308.64)
	event.ObjsSetMotion(0, "耳に当てる会話", 6)
	event.ObjsNextMotion(0, "耳に当てるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4340020)
	if vm.skipping() then
		return skip(9)
	end
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(136.58, 282.08, 250.29)
	event.CmrsSetRef(103.01, 274.65, 222.02)
	event.ObjsSetMotion(2, "立ち（下見）", 4)
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4340030)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(532.81, 223.49, 220.44)
	event.CmrsSetRef(84.67, 164.89, 164.57)
	event.ObjsSetMotion(0, "耳に当てる会話", 6)
	event.ObjsNextMotion(0, "耳に当てるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4340040)
	if vm.skipping() then
		return skip(12)
	end
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4340045)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(136.58, 282.08, 250.29)
	event.CmrsSetRef(103.01, 274.65, 222.02)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.ObjsSetMotion(2, "立ち（下見）", 4)
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4340050)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(0.0, 51.02, 278.53)
	event.CmrsSetRef(0.0, 17.44, 308.64)
	event.SetPakuAnim(0, "通常口パク")
	helper_a65ad647(4340060)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(136.58, 282.08, 250.29)
	event.CmrsSetRef(103.01, 274.65, 222.02)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(2, "首ふる", 6)
	event.ObjsNextMotion(2, "首ふるL", 4)
	helper_a65ad647(4340070)
	if vm.skipping() then
		return skip(17)
	end
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsNextMotion(2, "首ふる戻り", 6)
	event.ObjsNextMotion(2, "会話入り", 4)
	event.ObjsNextMotion(2, "立ち（下見）", 4)
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4340075)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "会話戻り", 2)
	event.ObjsNextMotion(2, "首後ろにやる", 2)
	event.ObjsMotionWait(2)
	helper_5fcc6d89(50)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var9, 1)
	helper_ddc352a1(2)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(63.79, 24.14, 233.74)
	event.CmrsSetRef(6.92, 16.71, 285.79)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.CharaActive(20)
	event.CharaActive(0, 19)
	event.CharaActive(0, 18)
	event.SndSePlay(var9, 2)
	event.ObjsSetMotion(2, "竜の秘薬を渡す2", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetMotion(0, "竜の秘薬ゲット", 4, -1.0, 1)
	event.ObjsSetMotion(1, "秘薬見る", 4, -1.0, 1)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(23)
	end
	helper_cb38(375, 1)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(258.67, 378.76, -28.84)
	event.CmrsSetRef(79.78, 245.69, 90.44)
	event.ObjsSetMotion(2, "立ち（下見）", 4)
	event.ObjsSetMotion(0, "上見る", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	helper_5fcc6d89(4)
	if vm.skipping() then
		return skip(25)
	end
	event.SetPakuMotion(2, "会話L", 0, "立ち（下見）", 0)
	helper_a65ad647(4340080)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_a65ad647(4340090)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetMotion(1, "上から右", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a65ad647(4340100)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(0, "モニカ見る", 6)
	event.ObjsNextMotion(0, "モニカ見うなづく", 6)
	event.SetPakuAnim(0, "わらい口パク")
	helper_a65ad647(4340110)
	if vm.skipping() then
		return skip(29)
	end
	event.SetFadeOut(30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(30)
	end
	return part2()
end

--- Helper function.
local function helper_1a34(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
end

--- Helper function.
local function helper_31928(arg0: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local player_chara: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local angle: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local angle_2: f32 = 0
	local angle_3: f32 = 0
	local angle_4: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ddc352a1(0)
		end
		if at <= 2 then
			helper_b5fd3167(0, -1, 6, 170, 0)
		end
		if at <= 3 then
			helper_ddc352a1(0)
		end
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	player_chara = event.GetControlChrid() or player_chara
	do
		local out1, out2, out3 = event.GetCharaPos(player_chara)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local _, out2, _ = event.GetCharaRot(player_chara)
		var17 = out2 or var17
	end
	var18 = event.GetRotLookPos(var11 - var8, var13 - var10) or var18
	angle = vm.f32(var18 - var17)
	angle = event.AngleLimit(angle) or angle
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var20 = out2 or var20
	end
	var21 = event.GetRotLookPos(var8 - var11, var10 - var13) or var21
	angle_2 = vm.f32(var21 - var20)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(player_chara, "立ち")
	else
		event.SetMotion(player_chara, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg0, "歩き")
	end
	event.CmrsInit()
	if arg0 == 13 or arg0 == 14 or arg0 == 15 then
		event.CmrsSetRef(var8, var9 + 63.0, var10)
		angle_3 = vm.f32(var21 - vm.f32(0.73))
		angle_3 = event.AngleLimit(angle_3) or angle_3
		event.CmrsSetAhd(angle_3, 41.5, 179.0)
	else
		event.CmrsSetRef(var8, var9 + 130.0, var10)
		angle_4 = vm.f32(var21 - vm.f32(0.73))
		angle_4 = event.AngleLimit(angle_4) or angle_4
		event.CmrsSetAhd(angle_4, 45.0, 468.0)
	end
	var25 = 0.0
	var26 = vm.f32(helper_baeaba52(helper_05ce8bed(angle), helper_05ce8bed(angle_2)) * 8.0)
	while var25 < var26 do
		var27 = helper_1a34(0.0, angle, var25, var26)
		var27 = vm.f32(var27 + var17)
		event.SetCharaRot(player_chara, 0.0, var27, 0.0)
		var28 = helper_1a34(0.0, angle_2, var25, var26)
		var28 = vm.f32(var28 + var20)
		event.SetCharaRot(arg0, 0.0, var28, 0.0)
		var25 = vm.f32(var25 + 1.0)
		if vm.wait() then
			return skip(1)
		end
	end
	event.SetCharaRot(player_chara, 0.0, var18, 0.0)
	event.SetMotion(player_chara, "立ち")
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetRot(0, 0.0, var21, 0.0)
	event.ObjsSetMotion(0, "会話入り", 6)
	event.ObjsNextMotion(0, "会話L", 4)
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	if arg0 == 8 then
		event.MesMake_2(
			0,
			"それならばシーグラのケガにも効くであろう。\n治してやってくだされ。"
		)
	end
	if arg0 == 9 then
		event.MesMake_2(0, "ここはシーグラの村だ、\nゆっくりしていくがよい。")
	end
	if arg0 == 10 then
		event.MesMake_2(0, "こちらが、我々の長老さまだ。\n失礼の無いようにな。")
	end
	if arg0 == 11 then
		event.MesMake_2(0, "私たちは渡り竜、\n毎年こうしてここにやって来るのです。")
	end
	if arg0 == 12 then
		event.MesMake_2(
			0,
			"我々は、ここで長旅の疲れを癒すのだ。\n静かにしていてくだされ。"
		)
	end
	if arg0 == 13 or arg0 == 14 or arg0 == 15 then
		value = event.GetRandInt(10) or value
		if value == 0 then
			event.MesMake_2(0, "ピユーイ！！")
		end
		if value == 1 then
			event.MesMake_2(0, "ピュイーー")
		end
		if value == 2 then
			event.MesMake_2(0, "ピィユ～")
		end
		if value == 3 then
			event.MesMake_2(0, "ピュウィ！！")
		end
		if value == 4 then
			event.MesMake_2(0, "パオオオーー！")
		end
		if value == 5 then
			event.MesMake_2(0, "ピィイイイ")
		end
		if value == 6 then
			event.MesMake_2(0, "ピョオオイ")
		end
		if value == 7 then
			event.MesMake_2(0, "パオオオ～")
		end
		if value == 8 then
			event.MesMake_2(0, "ピィイイ？")
		end
		if value == 9 then
			event.MesMake_2(0, "ピィイイ！")
		end
	end
	helper_b5fd3167(0, -1, 6, 170, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話戻り", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_ddc352a1(0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetCrossfade(10)
end

--- Helper function.
local function helper_c9f8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9e457fe2(1, 4)
			helper_b5fd3167(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_9e457fe2(1, 4)
	helper_b5fd3167(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_e078(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local boss_map: s32 = 0
	local var4: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local block: s32 = 0
	local var10: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				print("---------------------------------------------BATTLE BGM STOP\n")
				var8 = 0
				helper_5fcc6d89(30)
			end
			if at <= 2 then
				helper_066106e5()
			end
			if at <= 3 then
				helper_5fcc6d89(30)
			end
			if at <= 4 then
				helper_6068(arg1, -1)
			end
			if at <= 5 then
				helper_5fcc6d89(10)
			end
			if at <= 6 then
				helper_5fcc6d89(30)
			end
			if at <= 7 then
				helper_5fcc6d89(120)
			end
			if at <= 8 then
				local _ = helper_f705f18e(0)
			end
			if at <= 9 then
				helper_c9f8(1)
			end
			if at <= 10 then
				helper_c9f8(4)
			end
			if at <= 11 then
				helper_c9f8(active_chr_no)
			end
			if at <= 12 then
				helper_c9f8(1)
			end
			if at <= 13 then
				helper_5fcc6d89(30)
			end
			if at <= 15 then
				helper_5fcc6d89(30)
			end
			return 1
		end
		print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
		print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
		print("---------------------------------------------BATTLE BGM PLAY\n")
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	var2 = event.DngCheckPause(16384) or var2
	if var2 ~= 16384 then
		event.DngPause(16384, 1)
	end
	boss_map = event.DngCheckBossMap() or boss_map
	event.GetActiveBgmStatus(-1)
	if var2 ~= 16384 and boss_map ~= 1 then
		var4 = event.GetEventInfoSndid(4) or var4
		argc = event.GetSeStatus(var4, 0) or argc
		battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
		event.SndSeStop(var4, 0)
		print("---------------------------------------------BATTLE BGM STOP\n")
	end
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 or active_chr_no == 1 then
		event.SetTexAnim(0, 0, "目パチ")
		event.SetTexAnim(0, 1, "死に")
	end
	if active_chr_no == 2 then
		event.ActchrSetMotion(0, "故障", 6)
		event.EsmInitialize(5, 1)
		event.EsmLoadBase("ロボ故障")
		event.EsmInitFix(5)
		event.EsmCreate("ロボ故障")
	end
	var8 = 0
	if active_chr_no == 2 then
		var8 = event.CheckEnableCharaChange(0) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(1) or var8
		end
	end
	if active_chr_no == 0 then
		var8 = event.CheckEnableCharaChange(1) or var8
	end
	if active_chr_no == 1 then
		var8 = event.CheckEnableCharaChange(0) or var8
	end
	if active_chr_no == 3 then
		var8 = event.CheckEnableCharaChange(1) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(0) or var8
		end
	end
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_066106e5()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_6068(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_5fcc6d89(10)
			if vm.skipping() then
				return skip(6)
			end
			event.PlayBgm(0)
		end
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
		helper_5fcc6d89(30)
		if vm.skipping() then
			return skip(7)
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
		helper_5fcc6d89(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_f705f18e(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c9f8(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_c9f8(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c9f8(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_c9f8(1)
		if vm.skipping() then
			return skip(13)
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.AddWhp(0, 999)
		event.AddWhp(1, 999)
		if active_chr_no == 2 then
			event.EsmClear()
		end
		if active_chr_no == 0 or active_chr_no == 1 then
			event.SetTexAnim(0, 0, "死に")
			event.SetTexAnim(0, 1, "目パチ")
		end
		event.ActchrSetDefMotion(0, 4)
	elseif var8 == 1 then
		event.SetFadeOut(30)
		helper_5fcc6d89(30)
		if vm.skipping() then
			return skip(14)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.MenuCharaChenge(-1)
		if vm.wait() then
			return skip(15)
		end
		event.SetFadeOut(0)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_5fcc6d89(30)
		if vm.skipping() then
			return skip(16)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(1)
		if arg0 == 1 then
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
	helper_5fcc6d89(4)
	if vm.skipping() then
		return skip(17)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
	print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
	print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(1)
	if var2 ~= 16384 and boss_map ~= 1 then
		if argc == 1 then
			print("---------------------------------------------BATTLE BGM PLAY\n")
			event.SndSePlay(var4, 0)
			event.SndSetSeVol(var4, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(10)
	end
	if var2 ~= 16384 then
		event.DngPause(16385, 0)
	else
		event.DngPause(1, 0)
	end
	event.Finish()
	return 0
end

--- Helper function.
local function helper_103dc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_e078(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_e078(arg0, arg1)
end

--- Helper function.
local function helper_10344(arg0: s32)
	return helper_e078(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 4 then
			helper_50957e57(250.0, 0.0, 250.0, 0.0)
			return
		end
	end
	program_99()
	event.SetFadeOut(0)
	event.SetBitCtrl(16, 1)
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_7d7eee8f(1900.0, 0.0, -330.0, 0.0)
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
		return
	end
	flag = event.GetFlag(400) or flag
	if flag == 1 then
		flag_2 = event.GetFlag(438) or flag_2
		flag_3 = event.GetFlag(432) or flag_3
		flag_4 = event.GetFlag(436) or flag_4
		flag_5 = event.GetFlag(444) or flag_5
		if flag_2 == 0 and (flag_3 == 0 and flag_4 == 0) then
			argc = event.GetItemHaveNum(373) or argc
			if argc >= 1 then
				helper_144cc()
				if vm.skipping() then
					return skip(1)
				end
				return
			else
				helper_1a57c()
				if vm.skipping() then
					return skip(2)
				end
				return
			end
		end
		if flag_2 == 1 and flag_5 == 0 then
			event.SetBitCtrl(16, 0)
			helper_1e360()
			if vm.skipping() then
				return skip(3)
			end
			if vm.wait() then
				return skip(4)
			end
			event.SetBitCtrl(1, 1)
			event.LoadMonsterFile(514, 1)
			event.LoadMonsterFile(522, 0)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
				0.0,
				0.5235988,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
				0.0,
				1.5707964,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
				0.0,
				2.617994,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
				0.0,
				-2.617994,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
				0.0,
				-1.5707964,
				0.0
			)
			event.AutoSetMonster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
				0.0,
				-0.5235988,
				0.0
			)
			event.AutoSetMonster(522, 186.17, 130.0, 141.45)
			helper_50957e57(250.0, 0.0, 250.0, 0.0)
			event.SetCameraRef(250.0, 30.0, 250.0)
			event.SetCameraPos(250.0, 40.0, 130.0)
			event.ResetCamera(0)
			event.SetFadeIn(30)
			event.Finish()
			return
		end
	end
	helper_13694()
	if vm.skipping() then
		return skip(5)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_144cc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 170.
script[170] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a1df9d0f(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_a1df9d0f(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
	end
	local t0 = helper_141a4()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.DngSetStageId(3)
		event.GotoMenu(3, 3)
		if vm.wait() then
			return skip(2)
		end
		do
			local _, _, out3, _ = event.GetMenuParam_4()
			var2 = out3 or var2
		end
		if var2 == 20 then
			event.SetFadeIn(30)
			return
		end
		helper_7d755610()
		event.SetBitCtrl(16, 0)
		if var2 == 0 then
			event.MapJump(-1, "g03", 100)
		else
			event.GotoDng(3, var2, 1010)
		end
		if vm.wait() then
			return skip(3)
		end
		return
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_df04()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_235b0()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SubItem(373)
		event.SetBitCtrl(16, 0)
		event.SetBitCtrl(1, 0)
		event.GotoEdit(2, 520)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_5fcc6d89(30)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	stage_id = event.DngGetStageId() or stage_id
	var1 = event.DngGetFloorId() or var1
	event.SetFloorInfo(stage_id, var1, 5, 2)
	helper_235b0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10468()
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaPos(0, 400.0, 0.0, 30.0)
	event.SetFadeIn(30)
	event.ResetCamera(0)
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
	end
	var0 = 0
	var1 = event.GetEventData_2(9) or var1
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona") or var2
	if var2 == 0 then
		var0 = 8
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona-1") or var2
	if var2 == 0 then
		var0 = 9
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona-2") or var2
	if var2 == 0 then
		var0 = 10
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona-3") or var2
	if var2 == 0 then
		var0 = 11
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_otona-4") or var2
	if var2 == 0 then
		var0 = 12
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_kodomo") or var2
	if var2 == 0 then
		var0 = 13
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_kodomo-1") or var2
	if var2 == 0 then
		var0 = 14
	end
	var2 = event.PlacePartsNameStrcmp(var1, "p01_kodomo-2") or var2
	if var2 == 0 then
		var0 = 15
	end
	if var0 == 0 then
		return
	end
	argc = event.GetItemHaveNum(373) or argc
	if argc <= 0 then
		helper_1c9a4(var0)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	if var0 == 8 then
		flag = event.GetFlag(434) or flag
		if flag == 0 then
			event.AddItem(375)
			helper_16ffc()
			if vm.skipping() then
				return skip(2)
			end
			return
		end
	end
	helper_31928(var0)
	if vm.skipping() then
		return skip(3)
	end
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
				helper_103dc(0, 8620070)
			end
			return
		end
	end
	flag = event.GetFlag(440) or flag
	flag_2 = event.GetFlag(444) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_103dc(0, 8620060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_103dc(0, 8620070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_10344(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 14400.
script[14400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(438, 1)
	program_99()
	helper_1e360()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14440.
script[14440] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_235b0()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoEdit(2, 520)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 24020.
script[24020] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5fcc6d89(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_5fcc6d89(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(34)
	event.PlayBgm(0)
	event.LoadMonsterFile(514, 1)
	event.LoadMonsterFile(522, 0)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
		0.0,
		0.5235988,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
		0.0,
		1.5707964,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
		0.0,
		2.617994,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
		0.0,
		-2.617994,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
		0.0,
		-1.5707964,
		0.0
	)
	event.AutoSetMonster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
		0.0,
		-0.5235988,
		0.0
	)
	event.AutoSetMonster(522, 186.17, 130.0, 141.45)
	if vm.wait() then
		return skip(3)
	end
	event.Finish()
end

return script
