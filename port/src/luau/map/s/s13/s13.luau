--!strict
-- map/s/s13/s13.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_22e0636e = require("@lib/event/helper_22e0636e")
local helper_23a302d6 = require("@lib/event/helper_23a302d6")
local helper_42b7a2cf = require("@lib/event/helper_42b7a2cf")
local helper_5b643440 = require("@lib/event/helper_5b643440")
local helper_7ee99e81 = require("@lib/event/helper_7ee99e81")
local helper_9d157a91 = require("@lib/event/helper_9d157a91")
local helper_9dde4b39 = require("@lib/event/helper_9dde4b39")
local helper_b23727d0 = require("@lib/event/helper_b23727d0")
local helper_c746120b = require("@lib/event/helper_c746120b")
local helper_ec15ccd9 = require("@lib/event/helper_ec15ccd9")
local helper_fcdf0839 = require("@lib/event/helper_fcdf0839")

--- Helper function.
local function helper_ff40()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "rapis", 0)
	event.EohSyncObj(30, "p01_s1301-m-m", "s1301_3-m0")
	event.EohSetShow(30, 0)
end

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(2694)
	flag = event.GetFlag(624) or flag
	if flag == 1 then
		helper_ff40()
	end
end

--- Helper function.
local function helper_10064()
	local var0: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_c746120b(150)
			end
			if at <= 2 then
				helper_c746120b(30)
			end
			if at <= 3 then
				helper_5b643440(2)
			end
			if at <= 4 then
				helper_c746120b(30)
			end
			if at <= 5 then
				helper_c746120b(30)
			end
			if at <= 6 then
				helper_c746120b(30)
			end
			if at <= 7 then
				helper_c746120b(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DeleteChara(10)
		event.DelImg(0)
		event.SetStatusbarShow(1, 1.0)
		event.CharaActive(0)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_c746120b(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	var0 = event.SndLoadSound(5, "snd2/mon/en_281.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetStatusbarShow(0, 1.0)
	event.LoadChara(5, "dungeon/monster/e205e.gltf", "e205e", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSetSoundId(2, var0)
	block = event.LoadImg_4(5, "textures/event/e600/e624/e624telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e624telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 0)
	event.ObjsSetPos(2, 0.0, 0.0, -800.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "待機")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.0, 20.0, 1200.0)
	event.CmrsSetRef(0.0, -700.0, -800.0)
	event.CmrsMove2(0.0, 5.0, -590.0, 0.0, 80.0, -800.0, 150, 2, 0.2)
	event.SetFadeIn(30)
	helper_c746120b(150)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "立ち", 2)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(3)
	end
	helper_5b643440(2)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "攻撃１", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(5)
	end
	helper_c746120b(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_c784(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ee99e81(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_7ee99e81(1, 4)
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
	helper_fcdf0839(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_73c(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		if arg0 == 1 then
			event.SetFadeOut(10)
			helper_c746120b(10)
			if vm.skipping() then
				return skip(2)
			end
		end
		argc_3 = event.GetNowLoopNo() or argc_3
		if argc_3 == 1 then
			event.GotoMenu(16)
			if vm.wait() then
				return skip(3)
			end
		end
		if argc_3 == 2 then
			event.GotoMenu(17)
			if vm.wait() then
				return skip(4)
			end
		end
		if arg0 == 1 then
			event.SetFadeIn(10)
		end
	end
end

--- Helper function.
local function helper_10cc8()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_c746120b(30)
			end
			if at <= 2 then
				helper_42b7a2cf(6240010)
			end
			if at <= 3 then
				helper_42b7a2cf(6240020)
			end
			if at <= 4 then
				helper_c746120b(2)
			end
			if at <= 5 then
				helper_c746120b(120)
			end
			if at <= 6 then
				helper_c784(365, 1)
			end
			if at <= 7 then
				helper_c746120b(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 9 then
			helper_ff40()
			helper_ec15ccd9(0.0, 4.0, -920.0, 0.0)
			helper_73c(0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.SndSeStop(var1, 0)
		event.SndSeStop(var0, 0)
		event.PlayBgm(0)
		event.EohSetShow(2, 1)
		event.EohSetShow(3, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		helper_ff40()
		helper_ec15ccd9(0.0, 4.0, -920.0, 0.0)
		event.SetCameraRef(0.0, 34.0, -920.0)
		event.SetCameraPos(0.0, 44.0, -800.0)
		event.ResetCamera(0)
		helper_73c(0)
		if vm.skipping() then
			return skip(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(624, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var0
	var1 = event.SndLoadSound(2841) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatusbarShow(0, 1.0)
	event.ChangeDir("event/e600/e624/")
	event.LoadMes(0, 5, "e624.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e624_mints.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e624_monica.gltf", "info", 0)
	end
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e624_lapis_tuti.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetEohFramePos(1, 0, "item", 0.0, 0.0, 0.0, -1)
	event.ChangeDir("")
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(2, 0)
	event.EohSetShow(3, 0)
	event.EohSetPos(0, 0.0, 4.0, -920.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-40.26, 20.64, -866.67)
	event.CmrsSetRef(-1.7, 36.27, -951.09)
	event.CmrsMove2(-29.36, 23.4, -890.54, -1.7, 36.27, -951.09, 90, 2, 1.0)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(2)
	end
	if active_chr_no == 0 then
		helper_42b7a2cf(6240010)
		if vm.skipping() then
			return skip(3)
		end
	else
		helper_42b7a2cf(6240020)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.CmrsInit()
	event.SndSeStop(var1, 0)
	event.SndPauseBgm()
	event.EohSyncObj(30, "p01_s1301-m-m", "s1301_3-m0")
	event.EohSetShow(30, 0)
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	if active_chr_no == 0 then
		event.CmrsSetPos(0.0, 51.31, -963.58)
		event.CmrsSetRef(0.0, 28.64, -917.36)
		event.CmrsMove2(0.0, 46.94, -952.38, 0.0, 28.64, -917.36, 120, 2, 0.4)
		event.SetCharaPos(9, 7.74, 35.0, -918.0)
		event.SetCharaRot(9, 0.2, 0.24, 0.0)
	else
		event.CmrsSetPos(0.0, 53.31, -963.58)
		event.CmrsSetRef(0.0, 30.64, -917.36)
		event.CmrsMove2(0.0, 48.94, -952.38, 0.0, 30.64, -917.36, 120, 2, 0.4)
		event.SetCharaPos(9, -4.45, 37.0, -918.0)
		event.SetCharaRot(9, 0.2, -0.24, 0.0)
	end
	event.SetMotion(9, "発動", 6)
	event.ObjsSetMotion(0, "ラピスゲット", 4, -1.0, 1)
	helper_c746120b(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 0)
	helper_c746120b(120)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var1, 1)
	helper_c784(365, 1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_c644(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ee99e81(1, 4)
			helper_fcdf0839(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_7ee99e81(1, 4)
	helper_fcdf0839(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_db50(arg0: any, arg1: any)
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
		if at <= 15 then
			if at <= 1 then
				helper_9d157a91()
			end
			if at <= 2 then
				helper_c746120b(30)
			end
			if at <= 3 then
				helper_b23727d0(arg1, -1)
			end
			if at <= 4 then
				helper_c746120b(10)
			end
			if at <= 5 then
				helper_c746120b(30)
			end
			if at <= 6 then
				helper_c746120b(120)
			end
			if at <= 7 then
				local _ = helper_22e0636e(0)
			end
			if at <= 8 then
				helper_c644(1)
			end
			if at <= 9 then
				helper_c644(4)
			end
			if at <= 10 then
				helper_c644(active_chr_no)
			end
			if at <= 11 then
				helper_c644(1)
			end
			if at <= 12 then
				helper_c746120b(30)
			end
			if at <= 14 then
				helper_c746120b(30)
			end
			return 1
		end
		print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
		print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
		print("---------------------------------------------BATTLE BGM PLAY\n")
		return 0
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
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_9d157a91()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_c746120b(30)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_b23727d0(arg1, -1)
			if vm.skipping() then
				return skip(4)
			end
			helper_c746120b(10)
			if vm.skipping() then
				return skip(5)
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
		helper_c746120b(30)
		if vm.skipping() then
			return skip(6)
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
		helper_c746120b(120)
		if vm.skipping() then
			return skip(7)
		end
		while true do
			if helper_22e0636e(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(8)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c644(1)
			if vm.skipping() then
				return skip(9)
			end
		else
			helper_c644(4)
			if vm.skipping() then
				return skip(10)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c644(active_chr_no)
		if vm.skipping() then
			return skip(11)
		end
	else
		helper_c644(1)
		if vm.skipping() then
			return skip(12)
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
		helper_c746120b(30)
		if vm.skipping() then
			return skip(13)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.MenuCharaChenge(-1)
		if vm.wait() then
			return skip(14)
		end
		event.SetFadeOut(0)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(15)
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
	helper_c746120b(4)
	if vm.skipping() then
		return skip(16)
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
local function helper_fe1c(arg0: s32)
	return helper_db50(arg0, -1)
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
		helper_ec15ccd9(0.0, 0.0, 1000.0, vm.f32(3.14))
	end
	event.Initialize()
	program_99()
	flag = event.GetFlag(624) or flag
	if flag == 0 then
		helper_10064()
		if vm.skipping() then
			return skip(1)
		end
		event.FuncPointShow("", "rapis", 0)
		event.LoadMonsterFile(609, 1)
		event.LoadMonsterFile(610, 0)
		event.AutoSetMonster(609, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	end
	event.SetBitCtrl(1, if flag == 0 then 1 else 0)
	helper_ec15ccd9(0.0, 0.0, 1000.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, 1000.0)
	event.SetCameraPos(0.0, 40.0, 1120.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10064()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_23a302d6(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_23a302d6(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 161.
script[161] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(6)
		end
		if at <= 2 then
			helper_5b643440(0)
		end
		if at <= 3 then
			print("pos[0]=", string.format("%f", pos_x), "---------------\n")
			print("pos[1]=", string.format("%f", pos_y), "---------------\n")
			print("pos[2]=", string.format("%f", pos_z), "---------------\n")
		end
		if at <= 4 then
			helper_23a302d6(32)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetStatus(1, 0, 256, 1)
	event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 91.79, 22.67, -311.8)
	event.SetCharaRot(0, 0.0, 2.52, 0.0)
	event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 8)
	event.CharaActive(1, 8)
	event.SetCharaPos(0, 91.79, -0.0, -311.8)
	event.SetCharaRot(0, 0.0, 2.52, 0.0)
	event.SetCharaPos(8, 93.06, 22.75, -313.0)
	event.SetCharaRot(8, 0.0, 2.44, 0.0)
	event.SetMotion(8, "発動", 4)
	helper_c746120b(6)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMotion(8, "発動", 1)
	event.ObjsSetMotion(0, "タイムワープ", 6)
	event.ObjsNextMotion(0, "タイムワープL", 5)
	helper_5b643440(0)
	if vm.skipping() then
		return skip(3)
	end
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	print("pos[0]=", string.format("%f", pos_x), "---------------\n")
	print("pos[1]=", string.format("%f", pos_y), "---------------\n")
	print("pos[2]=", string.format("%f", pos_z), "---------------\n")
	event.SetCharaPos(0, 91.79, -0.0, -311.8)
	event.SetCharaRot(0, 0.0, 2.52, 0.0)
	if vm.wait() then
		return skip(4)
	end
	helper_23a302d6(32)
	if vm.skipping() then
		return skip(5)
	end
	event.DelExtMotion(0)
	event.DeleteChara(8)
	event.SetStatus(1, 0, 256, 0)
	event.Finish()
end

--- Program 200.
script[200] = function()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_fcdf0839(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			helper_c746120b(15)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_fcdf0839(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_fcdf0839(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	flag = event.GetFlag(624) or flag
	if flag == 0 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "まだラピスを手に入れてないよ！")
		helper_fcdf0839(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
		event.Finish()
		return
	end
	var2 = helper_9dde4b39(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	if var2 == 0 then
		event.SetFadeOut(15)
		helper_c746120b(15)
		if vm.skipping() then
			return skip(5)
		end
		event.DelMonster(-1)
		event.LoadScript("d02/d02.stb", 1000)
	end
	event.Finish()
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_fcdf0839(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_10cc8()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetBitCtrl(1, 0)
		event.SetFadeIn(10)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_fcdf0839(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_fcdf0839(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.AddItem(365, 1)
	event.SetFadeOut(10)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(3)
	end
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	event.SetFloorInfo(stage_id, var2, 5, 2)
	helper_10cc8()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Program 550.
-- Defined empty, so the engine runs this instead of its default.
script[550] = function() end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.DelMonster(-1)
	event.ActchrSetDefMotion(0)
	event.FuncPointShow("", "rapis", 1)
	event.SetLoadbgFile("snd2/bgm/bg_193.sound.json")
	helper_9d157a91()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgmPack(193)
	event.PlayBgm(0)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fe1c(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 26010.
script[26010] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadMonsterFile(609, 1)
	event.LoadMonsterFile(610, 0)
	event.AutoSetMonster(609, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	event.DngPause(16384, 1)
	event.StopBgm(0)
	helper_c746120b(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	event.Finish()
end

return script
