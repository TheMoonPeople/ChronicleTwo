--!strict
-- map/s/s06/s06_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_203fe835 = require("@lib/event/helper_203fe835")
local helper_237fc52c = require("@lib/event/helper_237fc52c")
local helper_25f278c2 = require("@lib/event/helper_25f278c2")
local helper_2799c4e0 = require("@lib/event/helper_2799c4e0")
local helper_30652181 = require("@lib/event/helper_30652181")
local helper_3a5b1e2b = require("@lib/event/helper_3a5b1e2b")
local helper_5ebfecdc = require("@lib/event/helper_5ebfecdc")
local helper_646d1255 = require("@lib/event/helper_646d1255")
local helper_79254d33 = require("@lib/event/helper_79254d33")
local helper_adbbb722 = require("@lib/event/helper_adbbb722")
local helper_b51fc149 = require("@lib/event/helper_b51fc149")
local helper_e445e2f6 = require("@lib/event/helper_e445e2f6")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")
local helper_fab3eef4 = require("@lib/event/helper_fab3eef4")

--- Helper function.
local function helper_20d58()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(15)
		end
		if at <= 2 then
			helper_f33fd19e(0)
		end
		if at <= 3 then
			helper_f33fd19e(10)
		end
		if at <= 4 then
			helper_b51fc149(40)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_040.sound.json") or var0
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetCameraPos(133.95, 349.85, 995.49)
	event.SetCameraRef(10.87, 287.26, 1174.06)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.CharaActive(1, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 3.0, 263.17, 1196.78)
	event.ObjsSetRot(0, 0.0, -3.08, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.EohSyncObj(10, "p08_s06", "s06_08-m1")
	event.EohSetShow(10, 1)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, 2.90684, 312.375, 1188.04)
	event.ObjsMove(10, 2.90684, 412.375, 1188.04, 30)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_b51fc149(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 3.0, 263.17, 1131.27, 30)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f33fd19e(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 1)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 10)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 8)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 5)
	helper_b51fc149(40)
	if vm.skipping() then
		return skip(5)
	end
	event.SetStatusbarShow(1, 0.033333335)
	event.SetCharaPos(0, 3.0, 263.17, 1131.27)
	event.EohSetPos(10, 2.90684, 312.375, 1188.04)
	event.SetCameraRef(3.0, 293.17, 1131.27)
	event.SetCameraPos(3.0, 303.17, 1011.27)
	event.ResetCamera(0)
	event.Finish()
end

--- Program 310.
local function program_310()
	local flag: s32 = 0
	local var1: s32 = 0
	local member: s32 = 0
	local active_chr_no: s32 = 0
	local var5: any = 0
	local stage_id: s32 = 0
	local var7: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_b51fc149(30)
			end
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ActchrSetDefMotion(0)
	flag = event.GetFlag(7) or flag
	if flag == 0 then
		event.Initialize()
		event.DngPause(1, 1)
		member = event.JoinPartyMember(2) or member
		if member ~= 0 then
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "There's no time for that now!")
			helper_e445e2f6(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesWindowMode(0, var1)
			if vm.wait() then
				return skip(2)
			end
			event.DngPause(1, 0)
			event.Finish()
			return
		else
			event.SetMotion(0, "立ち")
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			flag = event.GetFlag(104) or flag
			if flag == 1 then
				event.MesMake_2(0, "The door just won't open.\nLet's go back up for now.")
			else
				event.MesMake_2(0, "There's no time for that now!")
			end
			helper_e445e2f6(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.SetMesWindowMode(0, var1)
			if vm.wait() then
				return skip(4)
			end
			event.DngPause(1, 0)
			event.Finish()
			return
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "It doesn't look like you can move\nforward unless you get off the\nRide Pod.")
		helper_e445e2f6(0, -1, 8, 256, 208)
		if vm.skipping() then
			return skip(5)
		end
		event.Finish()
		return
	end
	if active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		helper_e445e2f6(0, 21, 8, 256, 208)
		if vm.skipping() then
			return skip(6)
		end
		event.Finish()
		return
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var5 = helper_203fe835(1, -1)
	if vm.skipping() then
		return skip(7)
	end
	if var5 == 0 then
		event.SetBitCtrl(1, 0)
		stage_id = event.DngGetStageId() or stage_id
		var7 = event.DngGetFloorId() or var7
		argc = event.GetNextFloor(var7, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var7, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.SetFadeOut(30)
		helper_b51fc149(30)
		if vm.skipping() then
			return skip(8)
		end
		flag = event.GetFlag(8) or flag
		if flag == 0 then
			event.StopBgm(0)
			event.SetFlag(8, 1)
			event.BgmLoadCancel()
			event.GotoEdit(12, 540)
			if vm.wait() then
				return skip(9)
			end
			return
		end
		event.BgmLoadCancel()
		event.GotoDng(0, 5, 1000)
		if vm.wait() then
			return skip(10)
		end
	end
	event.Finish()
end

--- Helper function.
local function helper_21908(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncObj(0, "p01_s06", "s06_02-a0")
	event.EohSyncObj(1, "p01_s06", "s06_03-a0")
	if arg0 ~= 0 then
		event.EohSetShow(0, 1)
		event.EohSetShow(1, 1)
	else
		event.EohSetShow(0, 0)
		event.EohSetShow(1, 0)
	end
end

--- Helper function.
local function helper_17d44(arg0: any)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(30)
		end
		if at <= 2 then
			helper_e445e2f6(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			helper_e445e2f6(0, -1, 8, 0, 0)
		end
		if at <= 4 then
			helper_e445e2f6(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_e445e2f6(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-276.53, 81.94, 10.07)
	event.CmrsSetRef(31.75, 72.44, -9.51)
	event.ObjsSetPos(0, -165.91, 50.0, 2.54)
	event.ObjsSetRot(0, 0.0, 1.65, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetPos(1, -165.91, 50.0, 2.54)
	event.ObjsSetRot(1, 0.0, 1.65, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(2)
	end
	var1 = event.GetMesWindowMode() or var1
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]You can use the Ridepod with the\n   Ridepod command under Character\n   on the Main Menu.<page>When you want to get off, choose\nMax under Character."
	)
	helper_e445e2f6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "[(!)]You can get Cedric to refuel the\n   Ridepod for you.")
	helper_e445e2f6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"[(!)]And as the Ridepod builds up\n   EXP, you can get Cedric to\n   upgrade the Ridepod's Core.<page>The Core's Capacity for equipping\nmore parts will then increase."
	)
	helper_e445e2f6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Raise the Core's Capacity and try\n   installing various parts to make\n   your own, unique Ridepod!"
	)
	helper_e445e2f6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesWindowMode(0, var1)
end

--- Helper function.
local function helper_184f0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_5ebfecdc(var0)
			end
			if at <= 2 then
				helper_adbbb722(var0)
			end
			if at <= 3 then
				helper_30652181(var0)
			end
			if at <= 4 then
				helper_25f278c2(var0)
			end
			if at <= 5 then
				helper_2799c4e0(var0)
			end
			if at <= 6 then
				helper_17d44(var0)
			end
			if at <= 7 then
				helper_b51fc149(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 9 then
			helper_b51fc149(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 2)
		event.CharaActive(1, 0)
		event.EohSyncChara(10, 1)
		event.EohSetShow(10, 0)
		event.EohSyncChara(11, 2)
		event.EohSetShow(11, 0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SetCameraPos(-276.53, 81.94, 10.07)
		event.SetCameraRef(31.75, 72.44, -9.51)
		event.ResetCamera(0)
		event.DngSetupMainUnit(2)
		event.SetActiveChrNo(2)
		event.SetCharaPos(0, -167.59, 50.0, 2.86)
		event.SetCharaRot(0, 0.0, 1.77, 0.0)
		event.SetStatusbarShow(1)
		event.StopBgm(0)
		helper_b51fc149(4)
		if vm.skipping() then
			return skip(10)
		end
		event.LoadBgm(15)
		event.PlayBgm(0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
		if vm.wait() then
			return skip(11)
		end
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(1819) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.SetCameraPos(6.02, 94.24, 399.23)
	event.SetCameraRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e108/e108_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 0.0, 50.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(10, 0.0, 50.0, 0.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.EohSyncChara(10, 1)
	event.EohSetShow(10, 0)
	event.EohSyncChara(11, 2)
	event.EohSetShow(11, 0)
	event.LoadMes(0, 5, "event/e100/e108/e108a_1.txt")
	event.StopBgm(0)
	event.InitDramaScene()
	helper_5ebfecdc(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "おこり顔")
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_adbbb722(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_30652181(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_25f278c2(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_2799c4e0(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_17d44(var0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(8)
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
	helper_20d58()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_237fc52c(64)
		end
	end
	event.SetCharaPos(0, -240.84, 50.0, -5.32)
	event.SetCharaRot(0, 0.0, 1.6, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_237fc52c(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_310()
	if vm.skipping() then
		return skip(1)
	end
end

script[310] = program_310

--- Program 500.
script[500] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local member: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_21908(1)
			return
		end
		if at <= 2 then
			helper_20d58()
		end
		if at <= 3 then
			helper_20d58()
		end
		if at <= 4 then
			helper_20d58()
		end
		if at <= 5 then
			helper_20d58()
		end
	end
	helper_fab3eef4()
	flag = event.GetFlag(7) or flag
	if flag == 0 then
		flag = event.GetFlag(106) or flag
		flag_2 = event.GetFlag(104) or flag_2
		member = event.JoinPartyMember(2) or member
		if (if flag == 1 then member else 0) ~= 0 or flag_2 == 0 then
			event.SetBitCtrl(1, 1)
			helper_21908(1)
		end
	end
	event.FuncPointShow("", "dun_out", 0)
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.FuncPointShow("p01_s06", "doa1", 0)
		event.FuncPointShow("p01_s06", "doa0", 1)
		flag = event.GetFlag(109) or flag
		if flag ~= 0 then
			event.FuncPointShow("", "dun_out", 1)
		end
	else
		event.FuncPointShow("p01_s06", "doa1", 0)
		event.FuncPointShow("p01_s06", "doa0", 1)
		member = event.JoinPartyMember(2) or member
		if member == 0 then
			flag = event.GetFlag(105) or flag
			if flag == 1 then
				event.FuncPointShow("", "dun_out", 1)
			end
		else
			event.FuncPointShow("", "dun_out", 0)
		end
	end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	flag = event.GetFlag(103) or flag
	if flag == 0 then
		helper_21908(1)
		event.LoadScript("s06/s06b_1.stb", 500)
		return
	else
		member = event.JoinPartyMember(2) or member
		if member ~= 0 then
			flag = event.GetFlag(25) or flag
			if flag == 1 then
				event.SetFlag(5, 0)
				flag = event.GetFlag(6) or flag
				if flag == 0 then
					event.SetFadeOut(0)
					event.SetFlag(6, 1)
					event.LoadScript("s06/s06b_1.stb", 510)
					return
				else
					flag = event.GetFlag(7) or flag
					if flag == 0 then
						event.SetFadeOut(0)
						event.LoadScript("s06/s06b_1.stb", 520)
						return
					else
						helper_20d58()
						if vm.skipping() then
							return skip(2)
						end
					end
				end
			else
				helper_20d58()
				if vm.skipping() then
					return skip(3)
				end
			end
		else
			event.SetFlag(5, 0)
			flag = event.GetFlag(7) or flag
			if flag == 1 then
				helper_20d58()
				if vm.skipping() then
					return skip(4)
				end
			else
				member = event.JoinPartyMember(2) or member
				if member == 0 then
					flag = event.GetFlag(105) or flag
					if flag == 1 then
						helper_20d58()
						if vm.skipping() then
							return skip(5)
						end
					end
				else
					event.LoadMonsterFile(601, 1)
					helper_20d58()
					if vm.skipping() then
						return skip(6)
					end
					event.Initialize()
					event.AutoSetMonster(601, -36.31, 50.0, 1.24, 0.0, 0.0, 0.0)
					event.Finish()
				end
			end
		end
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.LoadScript("s06/s06c_1.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_21908(0)
			helper_184f0()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.DelMonster(-1)
	end
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFlag(7, 1)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	helper_21908(0)
	event.DngPause(17, 1)
	helper_184f0()
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
			helper_646d1255()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.GotoEdit(10, 531)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetBitCtrl(1, 0)
	helper_21908(0)
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(1)
	end
	event.AddHpRate(1.0, 0)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_646d1255()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_79254d33()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 505.
script[505] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadScript("s06/06c_1.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 506.
script[506] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadScript("s06/06c_1.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 507.
script[507] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	event.SetFlag(6, 1)
	event.LoadScript("s06/s06b_1.stb", 510)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 600.
script[600] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e445e2f6(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_b51fc149(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.Initialize()
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_e445e2f6(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_e445e2f6(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesDrawspeed(0, 0)
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	event.SetMesWindowMode(0, 5)
	var1 = helper_203fe835(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_b51fc149(30)
		if vm.skipping() then
			return skip(4)
		end
		event.SetBitCtrl(1, 0)
		event.LoadScript("d01/d01.stb", 1000)
		return
	end
	event.Finish()
end

--- Program 601.
script[601] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_21908(1)
	end
	if vm.wait() then
		return skip(1)
	end
	helper_21908(1)
	event.LoadScript("s06/s06c_1.stb", 600)
end

--- Program 630.
script[630] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.GotoEdit(12, 540)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 1200.
script[1200] = function()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3a5b1e2b(0)
		end
		if at <= 2 then
			helper_3a5b1e2b(0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		flag = event.GetFlag(7) or flag
		if flag == 0 then
			event.SetFlag(6, 1)
			if vm.wait() then
				return skip(1)
			end
			event.LoadScript("s06/s06.stb", 503)
		else
			helper_3a5b1e2b(0)
			if vm.skipping() then
				return skip(2)
			end
		end
	else
		helper_3a5b1e2b(0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 11030.
script[11030] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(103, 0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06b_1.stb", 500)
end

--- Program 11040.
script[11040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06c_1.stb", 500)
end

--- Program 11070.
script[11070] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(107, 1)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06b_1.stb", 510)
end

--- Program 11081.
script[11081] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_184f0()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetFlag(7, 1)
	end
	event.DngPause(1, 1)
	event.SetFadeOut(15)
	helper_b51fc149(15)
	if vm.skipping() then
		return skip(1)
	end
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_184f0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 11082.
script[11082] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_646d1255()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.GotoEdit(10, 531)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetBitCtrl(1, 0)
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(1)
	end
	event.AddHpRate(1.0, 0)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_646d1255()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 21010.
script[21010] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(4)
		end
		helper_21908(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_b51fc149(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	event.SetCharaPos(0, 0.0, 50.0, 100.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	helper_21908(1)
	event.LoadMonsterFile(601, 1)
	event.AutoSetMonster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.Finish()
	event.ResetCamera(1, 0.0, 20.0)
end

return script
