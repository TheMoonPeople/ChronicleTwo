--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02b69e90 = require("@lib/event/helper_02b69e90")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_52626d1e = require("@lib/event/helper_52626d1e")
local helper_638d969d = require("@lib/event/helper_638d969d")
local helper_78000d2f = require("@lib/event/helper_78000d2f")
local helper_aea2bb82 = require("@lib/event/helper_aea2bb82")

--- Helper function.
local function helper_9ef508a9(arg0: any, arg1: any)
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
				helper_638d969d()
			end
			if at <= 2 then
				helper_2f481f12(30)
			end
			if at <= 3 then
				helper_02b69e90(0, 7)
				helper_78000d2f(arg1, -1, 10)
			end
			if at <= 4 then
				helper_2f481f12(10)
			end
			if at <= 5 then
				helper_2f481f12(30)
			end
			if at <= 6 then
				helper_2f481f12(120)
			end
			if at <= 7 then
				local _ = helper_aea2bb82(0)
			end
			if at <= 8 then
				helper_52626d1e(1)
			end
			if at <= 9 then
				helper_52626d1e(4)
			end
			if at <= 10 then
				helper_52626d1e(active_chr_no)
			end
			if at <= 11 then
				helper_52626d1e(1)
			end
			if at <= 12 then
				helper_2f481f12(30)
			end
			if at <= 14 then
				helper_2f481f12(30)
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
	event.SetLoadbgFile(
		"snd2/bgm/bg_060.sound.json",
		"textures/dungeon/image/gameover/gameover_1.json",
		"event/boss_btl_lose_1.txt"
	)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_638d969d()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover/gameover_1.json", 1) or block
		if arg1 >= 0 then
			helper_02b69e90(0, 7)
			event.LoadMes(0, 5, "event/boss_btl_lose_1.txt")
			helper_78000d2f(arg1, -1, 10)
			if vm.skipping() then
				return skip(4)
			end
			helper_2f481f12(10)
			if vm.skipping() then
				return skip(5)
			end
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
		helper_2f481f12(30)
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
		helper_2f481f12(120)
		if vm.skipping() then
			return skip(7)
		end
		while true do
			if helper_aea2bb82(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(8)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_52626d1e(1)
			if vm.skipping() then
				return skip(9)
			end
		else
			helper_52626d1e(4)
			if vm.skipping() then
				return skip(10)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_52626d1e(active_chr_no)
		if vm.skipping() then
			return skip(11)
		end
	else
		helper_52626d1e(1)
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
		helper_2f481f12(30)
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
		helper_2f481f12(30)
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
	helper_2f481f12(4)
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

return helper_9ef508a9
