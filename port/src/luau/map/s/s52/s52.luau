--!strict
-- map/s/s52/s52.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4303896d = require("@lib/event/helper_4303896d")
local helper_65302558 = require("@lib/event/helper_65302558")
local helper_774ccd87 = require("@lib/event/helper_774ccd87")
local helper_79cab23e = require("@lib/event/helper_79cab23e")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_b2a0ed41 = require("@lib/event/helper_b2a0ed41")
local helper_c6c17732 = require("@lib/event/helper_c6c17732")
local helper_e42033a8 = require("@lib/event/helper_e42033a8")
local helper_e64ec5fa = require("@lib/event/helper_e64ec5fa")
local helper_f79a127e = require("@lib/event/helper_f79a127e")

--- Program 99.
local function program_99()
	event.StopBgm(0)
	event.LoadSound(8800)
end

--- Helper function.
local function helper_102bc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 28 then
			if at <= 1 then
				helper_774ccd87(150)
			end
			if at <= 2 then
				helper_4303896d(0)
			end
			if at <= 3 then
				helper_c6c17732()
			end
			if at <= 4 then
				helper_774ccd87(60)
			end
			if at <= 5 then
				helper_774ccd87(30)
			end
			if at <= 6 then
				helper_f79a127e(8040010, 30)
			end
			if at <= 7 then
				helper_774ccd87(30)
			end
			if at <= 8 then
				helper_774ccd87(90)
			end
			if at <= 9 then
				helper_774ccd87(30)
			end
			if at <= 10 then
				helper_774ccd87(30)
			end
			if at <= 11 then
				helper_e42033a8(8040020)
			end
			if at <= 12 then
				helper_c6c17732()
			end
			if at <= 13 then
				helper_e42033a8(8040030)
			end
			if at <= 14 then
				helper_e42033a8(8040040)
			end
			if at <= 15 then
				helper_e42033a8(8040050)
			end
			if at <= 16 then
				helper_e42033a8(8040060)
			end
			if at <= 17 then
				helper_4303896d(1)
			end
			if at <= 18 then
				helper_e42033a8(8040070)
			end
			if at <= 19 then
				helper_e42033a8(8040075)
			end
			if at <= 20 then
				helper_4303896d(1)
			end
			if at <= 21 then
				helper_e42033a8(8040080)
			end
			if at <= 22 then
				helper_f79a127e(8040090, 90)
			end
			if at <= 23 then
				helper_f79a127e(8040095, 150)
			end
			if at <= 24 then
				helper_c6c17732()
			end
			if at <= 25 then
				helper_e42033a8(8040100)
			end
			if at <= 26 then
				helper_e42033a8(8040110)
			end
			if at <= 27 then
				helper_774ccd87(30)
			end
			if vm.skip_end() then
				return skip(29)
			end
			return part2()
		end
		if at <= 29 then
			helper_774ccd87(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_774ccd87(4)
		if vm.skipping() then
			return skip(30)
		end
		var2 = event.GetDefBgmNo(171) or var2
		event.LoadBgm(var2)
		event.PlayBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.LoadMes(0, -1)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.SetStatusbarShow(1, 1.0)
	end
	event.SetFlag(804, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	helper_774ccd87(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(108)
	event.PlayBgm(0)
	event.LoadSound(8800)
	var0 = event.SndLoadSound(8800) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e800/e804/")
	event.LoadMes(0, 5, "e804.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e804_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e804_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 10)
		event.LoadMotion(5, "event/e800/e804/e804_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 10)
		event.LoadMotion(5, "event/e800/e804/e804_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(10)
	event.LoadChara(5, "event/e800/e804/e804_hikari01.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2, 11)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e800/e804/e804_hikari02.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(3, 12)
	event.ObjsInit(3, 12)
	event.ObjsSyncObj(3, 3)
	event.EohSetPos(0, -4.16, 0.0, -259.38)
	event.EohSetRot(0, 0.0, 0.07, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetPos(1, -18.33, 0.2, 634.43)
	event.EohSetRot(1, 0.0, 3.11, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetPos(2, -2.63, 19.79, 530.32)
	event.EohSetRot(2, 0.0, 0.35, 0.0)
	event.EohSetPos(3, -20.7, 19.79, 522.32)
	event.EohSetRot(3, 0.0, -0.01, 0.0)
	event.InitDramaScene()
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.CmrsInit()
	event.CmrsSetPos(-179.05, 220.35, 153.06)
	event.CmrsSetRef(1.71, 7.72, -123.24)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(10)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "キョロキョロ歩き")
	event.ObjsMove(0, -4.29, 0.0, 32.47, 300)
	helper_774ccd87(150)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-4.2, 15.51, 86.14)
	event.CmrsSetRef(-2.99, 14.98, -61.37)
	helper_4303896d(0)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-2.86, 25.18, 60.66)
	event.CmrsSetRef(-2.35, 39.82, 93.5)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.CmrsMove2(-2.86, 25.18, 60.66, 15.15, 36.78, 88.33, 30, 0, 1.0)
	event.CmrsMove2(-2.86, 25.18, 60.66, -21.66, 35.94, 88.23, 60, 0, 1.0)
	event.CmrsMove2(-2.86, 25.18, 60.66, -2.35, 39.82, 93.5, 30, 0, 1.0)
	helper_c6c17732()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-47.24, 104.74, 601.14)
	event.CmrsSetRef(2.9, 12.55, 502.54)
	event.ObjsSetPos(0, -3.66, 0.0, 486.81)
	event.ObjsSetRot(0, 0.0, 0.07, 0.0)
	event.ObjsResetDaPosition(0)
	helper_774ccd87(60)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.SndSePlay(var0, 0)
	event.CharaActive(11)
	event.ObjsSetMotion(2, "まぶしい", 6)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "目あき～目とじ")
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "まぶしい", 6)
	event.ObjsNextMotion(0, "まぶしいL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f79a127e(8040010, 30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30, 255, 255, 255)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeIn(30, 255, 255, 255)
	event.CmrsSetPos(-36.94, 14.3, 562.43)
	event.CmrsSetRef(-12.36, 17.91, 522.68)
	event.CharaActive(0, 11)
	event.CharaActive(1, 12)
	event.ObjsSetMotion(3, "ｴﾌｪｸﾄ_光02", 6)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目とじ～目あき")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	helper_774ccd87(90)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-29.48, 49.46, 446.35)
	event.CmrsSetRef(-4.87, 9.57, 484.15)
	event.SetStatus(1, 0, 256, 1)
	event.ObjsSetPos(1, -2.63, 0.0, 522.47)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "ふりかえり", 6)
	event.ObjsNextMotion(1, "ふりかえりL", 4)
	event.CmrsMove2(-14.27, 20.55, 486.53, -0.6, 23.59, 519.41, 90, 2, 1.0)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_e42033a8(8040020)
	if vm.skipping() then
		return skip(12)
	end
	helper_c6c17732()
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(1, "ふぅ～", 6)
	event.ObjsNextMotion(1, "ふりかえりL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_e42033a8(8040030)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(-47.02, 17.84, 537.96)
	event.CmrsSetRef(-5.93, 21.43, 507.2)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.SetPakuAnim(0, "通常口パク")
	helper_e42033a8(8040040)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_e42033a8(8040050)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_e42033a8(8040060)
	if vm.skipping() then
		return skip(17)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "グリフォン～", 6)
	event.ObjsNextMotion(1, "ふりかえりL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_e42033a8(8040070)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_e42033a8(8040075)
	if vm.skipping() then
		return skip(20)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(1, "どこ？", 6)
	event.ObjsNextMotion(1, "ふりかえりL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_e42033a8(8040080)
	if vm.skipping() then
		return skip(22)
	end
	event.SetStatus(1, 0, 256, 0)
	event.CmrsSetPos(-166.85, 42.01, 408.47)
	event.CmrsSetRef(163.82, 50.8, 533.42)
	event.CmrsMove(-166.85, 42.01, 408.47, -11.31, 50.66, 726.54, 270)
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f79a127e(8040090, 90)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f79a127e(8040095, 150)
	if vm.skipping() then
		return skip(24)
	end
	helper_c6c17732()
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-23.54, 21.87, 464.34)
	event.CmrsSetRef(1.34, 23.6, 508.99)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(1, -9.82, 0.0, 502.86)
	event.ObjsSetRot(1, 0.0, 2.92, 0.0)
	event.ObjsResetDaPosition(1)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(1, "よろこぶ", 6)
	event.ObjsNextMotion(1, "よろこぶL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_e42033a8(8040100)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_e42033a8(8040110)
	if vm.skipping() then
		return skip(27)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(28)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b2a0ed41(0.0, 0.0, 800.0, 0.0)
	end
	program_99()
	helper_7d7eee8f(0.0, 0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 30.0, 0.0)
	event.SetCameraPos(0.0, 40.0, -120.0)
	event.ResetCamera(0)
	flag = event.GetFlag(804) or flag
	if flag == 0 then
		event.ExtTyped(1078, "ii", 1, 1)
		event.SetCharaChangeFlag(1, 1)
		event.SetCharaChangeMask(1, 1)
		event.ExtTyped(1078, "ii", 3, 1)
		event.SetCharaChangeFlag(3, 1)
		event.SetCharaChangeMask(3, 1)
		helper_102bc()
		if vm.skipping() then
			return skip(1)
		end
		helper_b2a0ed41(0.0, 0.0, 800.0, 0.0)
		event.SetCameraRef(0.0, 30.0, 800.0)
		event.SetCameraPos(0.0, 40.0, 680.0)
		event.ResetCamera(0)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.Finish()
end

--- Program 300.
script[300] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e64ec5fa(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_774ccd87(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_e64ec5fa(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_e64ec5fa(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var1 = helper_65302558(0, 10, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_774ccd87(30)
		if vm.skipping() then
			return skip(4)
		end
		stage_id = event.DngGetStageId() or stage_id
		var3 = event.DngGetFloorId() or var3
		argc = event.GetNextFloor(var3, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var3, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.LoadScript("d07/d07.stb", 1000)
	else
		event.Finish()
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_79cab23e(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 18040.
script[18040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_102bc()
	if vm.skipping() then
		return skip(1)
	end
end

return script
