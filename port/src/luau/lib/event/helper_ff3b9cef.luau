--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c954ed47 = require("@lib/event/helper_c954ed47")

--- Helper function.
local function helper_ff3b9cef(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		flag = event.GetFlag(612) or flag
		event.SetMotion(0, "立ち")
		if arg4 ~= 0 then
			event.SetLoadbgFile_2("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
		else
			event.SetLoadbgFile_2("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
		end
		event.CmrsInit()
		event.CmrsFadeInit()
		event.CmrsFadeOut(30)
		helper_c624bc16()
		helper_479dc9e9()
		event.InitDramaScene()
		event.SetSkipBotton(20)
		event.SetSkipFcol(255.0, 255.0, 255.0)
		event.SetWorldCoord(arg0, arg1, arg2, arg3)
		event.SetCharaShow(120, 0)
		event.SetCharaShow(121, 0)
		event.AssignStack(5)
		event.ClearStack(5)
		if arg4 ~= 0 then
			event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
			event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
		else
			event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
			event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
		end
		event.CharaActive(35)
		event.SetCharaType(35, 4)
		event.EohSyncChara(3, 35)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetPos(3, 0.0, 70.0, 0.0)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.CharaActive(36)
		event.SetCharaType(36, 4)
		event.EohSyncChara(4, 36)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetPos(4, 0.0, 0.0, 0.0)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
			event.CharaActive(34)
			event.EohSyncChara(2, 34)
			event.EohSetPos(2, 49.73999, 0.0, 8.969971)
			event.EohSetRot(2, 0.0, -1.76, 0.0)
		end
		if arg5 ~= 0 then
			active_chr_no = event.GetActiveChrNo() or active_chr_no
			if active_chr_no == 0 then
				event.GetEquipItemno(1, 2)
				event.GetEquipItemno(1, 3)
				event.GetEquipItemno(1, 4)
			end
			if active_chr_no == 1 then
				event.GetEquipItemno(0, 2)
				event.GetEquipItemno(0, 3)
				event.GetEquipItemno(0, 4)
			end
			if active_chr_no == 0 then
				if flag ~= 0 then
					event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 0)
				else
					event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
				end
				event.CharaActive(0)
				event.EohSyncChara(0, 0)
				event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
				event.CharaActive(33)
				event.EohSyncChara(1, 33)
				event.LoadEquip(5, 1, 4, "info", 33)
				event.LoadEquip(5, 1, 3, "info", 33)
				event.LoadEquip(5, 1, 2, "info", 33, 37)
				event.CharaActive(37)
				event.EohSyncChara(5, 37)
				event.EohSetShow(5, 1)
			end
			if active_chr_no == 1 then
				event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
				if flag ~= 0 then
					event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 32)
				else
					event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
				end
				event.CharaActive(32)
				event.EohSyncChara(0, 32)
				event.LoadEquip(5, 0, 4, "info", 32)
				event.LoadEquip(5, 0, 3, "info", 32)
				event.LoadEquip(5, 0, 2, "info", 32, 37)
				event.CharaActive(37)
				event.EohSyncChara(5, 37)
				event.EohSetShow(5, 1)
				event.CharaActive(0)
				event.EohSyncChara(1, 0)
			end
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
			event.ObjsSetPos(0, 38.0, 0.0, 22.0)
			event.ObjsSetRot(0, 0.0, -2.12, 0.0)
			event.ObjsSetMotion(0, "立ち", 4)
			event.ObjsTexAnime(0, 0)
			event.EohSetPos(1, 18.619995, 0.0, 35.179993)
			event.EohSetRot(1, 0.0, -2.48, 0.0)
			event.EohSetMotion(1, "立ち", 0.02)
			event.EohResetDaPosition(1)
		else
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
			event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			event.LoadMotion(5, "event/e500/e523/e523_mints.gltf", "info", 0)
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
			event.ObjsSetPos(0, 38.0, 0.0, 22.0)
			event.ObjsSetRot(0, 0.0, -2.12, 0.0)
			event.ObjsSetMotion(0, "立ち", 4)
			event.ObjsTexAnime(0, 0)
		end
		if flag ~= 0 then
			var12 = event.SndLoadSound_3(8, "snd2/sp/sp_043.sound.json") or var12
		else
			var13 = event.SndLoadSound_3(8, "snd2/sp/sp_013.sound.json") or var13
		end
		if arg4 ~= 0 then
			event.SetLoadbgFile_2("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
		else
			event.SetLoadbgFile_2("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
		end
		event.ObjsSetPos(0, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "旧・立ち", 4)
		event.ObjsResetDaPosition(0)
		if flag ~= 0 then
			event.SndSePlay(var12, 0)
		else
			event.SndSePlay(var13, 0)
			helper_888ab2a3(30)
		end
		event.SetFadeIn(30)
		if flag ~= 0 then
			event.CmrsSetPos(-56.29, 15.74, 3.56)
			event.CmrsSetRef(-12.65, 16.48, 2.06)
		else
			event.CmrsSetPos(-48.179993, 19.61, -28.70996)
			event.CmrsSetRef(-0.789978, 16.48, -0.05999756)
		end
		if arg5 == 0 and arg4 == 0 and flag == 0 then
			event.CmrsSetPos(-30.09, 19.5, 4.41)
			event.CmrsSetRef(-14.63, 21.71, 1.0)
		end
		event.ObjsSetMotion(0, "タイムワープ", 6, 0.45)
		event.ObjsNextMotion(0, "タイムワープL", 4)
		event.ObjsTexAnime(0, 1, "開閉口")
		helper_0958ca60(0)
		helper_479dc9e9()
		if arg4 ~= 0 then
			event.LoadChara(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
		else
			event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
		end
		if flag ~= 0 then
			event.CharaActive(0, 38)
		else
			event.CharaActive(1, 38)
		end
		event.EohSyncChara(6, 38)
		event.ObjsInit(6)
		event.ObjsSyncObj(6, 6)
		do
			local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		if arg4 ~= 0 then
			event.ObjsSetPos(6, pos_x, pos_y, pos_z)
		else
			event.ObjsSetPos(6, -3.54, 17.04, -1.46)
		end
		event.ObjsSetRot(6, -0.45, -2.12, 0.0)
		event.CmrsSetPos(-21.5, 23.92, -12.580017)
		event.CmrsSetRef(-0.789978, 16.17, -0.05999756)
		event.ObjsTexAnime(0, 0, "開閉口")
		event.ObjsTexAnime(0, 1, "開き口")
		event.ObjsSetMotion(0, "タイムワープL", 5)
		event.ObjsSetMotion(6, "発動", 6)
		event.ObjsNextMotion(6, "発動L", 4)
		if flag == 0 then
			helper_0958ca60(6)
		else
			event.SndSePlay(var12, 2)
		end
		if arg4 ~= 0 then
			event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
		else
			event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
		end
		event.CharaActive(39)
		event.EohSyncChara(7, 39)
		event.ObjsInit(7)
		event.ObjsSyncObj(7, 7)
		event.ObjsSetPos(7, 0.0, 0.0, 0.0)
		event.ObjsSetRot(7, 0.0, -2.12, 0.0)
		event.CmrsSetPos(-40.590027, 19.47, -24.339966)
		event.CmrsSetRef(13.950012, 15.23, 9.190002)
		event.CmrsMove2(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
		event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
		event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
		event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
		helper_888ab2a3(60)
		event.SetFadeOut(60, 255.0, 255.0, 255.0)
		helper_888ab2a3(60)
		helper_c954ed47(1)
	end)
	event.CancelDramaScene()
	if flag ~= 0 then
		event.SndSeStop(var12, 0)
	else
		event.SndSeStop(var13, 0)
	end
	event.FadeOutBgm(30)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.DelExtMotion(0)
		event.DeleteChara(33)
	end
	if active_chr_no == 1 then
		event.DeleteChara(32)
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.DeleteChara(34)
	end
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(37)
	event.DeleteChara(38)
	event.DeleteChara(39)
end

return helper_ff3b9cef
