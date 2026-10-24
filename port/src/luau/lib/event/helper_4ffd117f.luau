--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_4ffd117f(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var7: s32 = 0
	local now_party_chara_id: s32 = 0
	local language_code: s32 = 0
	vm.section(function()
		event.SetFlag(522, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		var7 = event.SndLoadSound_3(8, "snd2/sp/sp_043.sound.json") or var7
		event.AssignStack(5)
		event.ClearStack(5)
		event.SetWorldCoord(arg0, arg1, arg2, arg3)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		event.LoadMotion(5, "event/e500/e522/e522_mints.gltf", "info", 0)
		event.CharaActive(1, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetMotion(0, "立ち", 0)
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.LoadCharaNpc(0, 5, now_party_chara_id, 33)
			event.CharaActive(0, 33)
			event.EohSyncChara(1, 33)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
		end
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 34)
		event.CharaActive(0, 34)
		event.SetCharaType(34, 4)
		event.EohSyncChara(2, 34)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		language_code = event.GetLanguage() or language_code
		if language_code == 0 then
			event.LoadMes(0, 5, "event/e500/e522/e522.txt")
		else
			event.LoadMes(0, 5, "event/e500/e522/e522_1.txt")
		end
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		event.SetFadeIn(30)
		event.SndSePlay(var7, 0)
		event.InitDramaScene()
		event.CharaActive(1, 33)
		event.CmrsSetPos(5.32, 62.92, -97.07)
		event.CmrsSetRef(11.48, 61.6, -39.43)
		event.ObjsSetPos(0, 39.64, -0.0, 9.33)
		event.ObjsSetRot(0, 0.0, -2.33, 0.0)
		event.ObjsSetPos(1, 34.65, 0.0, 29.92)
		event.ObjsSetRot(1, 0.0, -2.36, 0.0)
		event.ObjsSetMotion(0, "上向く", 6)
		event.ObjsNextMotion(0, "上向くL", 0)
		event.CmrsMove2(5.32, 24.78, -97.07, 11.48, 29.98, -39.43, 90, 2, 0.4)
		helper_c624bc16()
		event.CharaActive(0, 33)
		event.CmrsSetPos(25.53, 21.33, -15.17)
		event.CmrsSetRef(32.72, 21.29, -3.29)
		event.ObjsSetRot(0, 0.0, -2.69, 0.0)
		event.CharaDaEnable(0, 0)
		event.CharaActive(1, 34)
		event.EohGetFramePos(0, "atoramiria")
		event.SetReference(0, "atoramiria", 34)
		event.SetCharaPos(34, 0.04, -1.42988, 0.89)
		event.ObjsSeDelay(2, 25)
		event.ObjsSePlay(2, var7, 1)
		event.ObjsSetMotion(2, "発動", 6)
		event.ObjsNextMotion(2, "発動L", 0)
		event.ObjsSetMotion(0, "アトラ見る", 6)
		event.ObjsNextMotion(0, "アトラ見るL", 0)
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "アトラさわる", 6)
		event.ObjsNextMotion(0, "アトラさわるL", 6)
		helper_e34416e2(5220010)
		helper_e34416e2(5220015)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
	end)
	event.CancelDramaScene()
	event.SndSeStop(var7, 0)
	event.DelExtMotion(0)
	event.DeleteChara(33)
	event.DeleteChara(34)
end

return helper_4ffd117f
