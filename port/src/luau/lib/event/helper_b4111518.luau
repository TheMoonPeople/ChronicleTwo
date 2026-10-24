--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_2f8c501c = require("@lib/event/helper_2f8c501c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_54207bc4 = require("@lib/event/helper_54207bc4")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_7b829e53 = require("@lib/event/helper_7b829e53")
local helper_cb265f35 = require("@lib/event/helper_cb265f35")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")

--- Helper function.
local function helper_b4111518(arg0: s32, arg1: s32)
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
	local at: number = 0
	return vm.guard(function()
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
		event.SetLoadbgFile_3(
			"snd2/bgm/bg_060.sound.json",
			"textures/dungeon/image/gameover/gameover_1.json",
			"event/boss_btl_lose_1.txt"
		)
		at = 1
		helper_25abe6d2(30)
		event.SetStatusbarShow(0, 0.06666667)
		at = 2
		helper_479dc9e9()
		event.LoadBgmPack(60)
		if var8 == 1 or var8 ~= 1 and arg1 < 0 then
			event.PlayBgm(0)
		end
		at = 3
		helper_25abe6d2(30)
		event.DngPause(1, 1)
		event.DngCollisionAllClr()
		if var8 ~= 1 then
			block = event.LoadImg_4(5, "textures/dungeon/image/gameover/gameover_1.json", 1) or block
			if arg1 >= 0 then
				helper_125385ee(0, 7)
				event.LoadMes(0, 5, "event/boss_btl_lose_1.txt")
				at = 4
				helper_cb265f35(arg1, -1, 10)
				at = 5
				helper_25abe6d2(10)
				event.LoadMes(0, -1)
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
			at = 6
			helper_25abe6d2(30)
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
			at = 7
			helper_25abe6d2(120)
			while true do
				if helper_581cb30c(0) ~= 0 then
					break
				end
				at = 8
				vm.wait(8)
			end
		elseif active_chr_no == 3 then
			var10 = event.CheckEnableCharaChange(1) or var10
			if var10 == 0 then
				at = 9
				helper_7b829e53(1)
			else
				at = 10
				helper_7b829e53(4)
			end
		elseif active_chr_no == 0 or active_chr_no == 2 then
			at = 11
			helper_7b829e53(active_chr_no)
		else
			at = 12
			helper_7b829e53(1)
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
			at = 13
			helper_25abe6d2(30)
			if active_chr_no == 2 then
				event.EsmClear()
			end
			event.MenuCharaChenge(-1)
			at = 14
			vm.wait(14)
			event.SetFadeOut(0)
		else
			event.FadeOutBgm(30)
			event.SetFadeOut(30)
			at = 15
			helper_25abe6d2(30)
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
		at = 16
		helper_25abe6d2(4)
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
	end, function(received: { any })
		if at <= 15 then
			if at <= 1 then
				helper_344d6cd8()
			end
			if at <= 2 then
				helper_d3f20302(30)
			end
			if at <= 3 then
				helper_fbd9683d(0, 7)
				helper_2f8c501c(arg1, -1, 10)
			end
			if at <= 4 then
				helper_d3f20302(10)
			end
			if at <= 5 then
				helper_d3f20302(30)
			end
			if at <= 6 then
				helper_d3f20302(120)
			end
			if at <= 8 then
				helper_54207bc4(1)
			end
			if at <= 9 then
				local _ = helper_dbff9fb6(0)
				helper_54207bc4(4)
			end
			if at <= 10 then
				helper_54207bc4(active_chr_no)
			end
			if at <= 11 then
				helper_54207bc4(1)
			end
			if at <= 12 then
				helper_d3f20302(30)
			end
			if at <= 14 then
				helper_d3f20302(30)
			end
			return 1
		end
		if at <= 16 then
			print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
			print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
			print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
			print("---------------------------------------------BATTLE BGM PLAY\n")
			return 0
		end
		return nil
	end)
end

return helper_b4111518
