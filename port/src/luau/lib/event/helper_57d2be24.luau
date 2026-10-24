--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_57d2be24()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local block: s32 = 0
	local language_code: s32 = 0
	local language_code_2: s32 = 0
	vm.section(function()
		event.Initialize()
		event.InitDramaScene()
		event.AssignStack(5)
		event.ClearStack(5)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local _, out2, _ = event.GetCharaRot(0)
			var3 = out2 or var3
		end
		event.SetWorldCoord(var0, var1, var2, var3)
		event.LoadMotion(5, "dungeon/chara/c02a_win.gltf", "info", 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		var6 = event.SndLoadSound_3(8, "snd2/sp/sp_000.sound.json") or var6
		var7 = event.GetEventInfoSndid(4) or var7
		event.SndSeStop(var7, 0)
		event.StopBgm(0)
		event.SndSePlay(var6, 0)
		language_code = event.GetLanguage() or language_code
		if language_code == 0 then
			block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
			event.SpriteInit(0)
			event.SpriteSetType(0, 0)
			event.SpriteSetTexture(0, "senmetu", block)
			event.SpriteSetPos(0, 256, 206)
			event.SpriteSetPutsize(0, 228, 64)
			event.SpriteSetUvsize(0, 0, 0, 255, 64)
			event.SpriteSetColor(0, 128, 128, 128, 0)
			event.SpriteSetScale(0, 5.0, 5.0)
			event.SpriteSetDraw(0, 1)
		else
			block = event.LoadImg_4(5, "dungeon/image/senmetsu/usa/finish.img", 0) or block
			event.SpriteInit(0)
			event.SpriteSetType(0, 0)
			event.SpriteSetTexture(0, "senmetu", block)
			event.SpriteSetPos(0, 256, 206)
			event.SpriteSetPutsize(0, 512, 64)
			event.SpriteSetUvsize(0, 0, 0, 512, 64)
			event.SpriteSetColor(0, 128, 128, 128, 0)
			event.SpriteSetScale(0, 5.0, 5.0)
			event.SpriteSetDraw(0, 1)
		end
		event.EohSyncSprite(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetMotion(0, "勝利のポーズ", 6)
		event.ObjsNextMotion(0, "勝利のポーズL", 6, 0.04)
		event.ObjsNextMotion(0, "余韻", 6)
		event.ObjsNextMotion(0, "余韻L", 4)
		event.CmrsInit()
		event.CmrsInitPas()
		event.CmrsSetPasFrm(160)
		event.CmrsAddPas(-21.28, 37.75, 24.27, -2.96, 23.12, 7.37)
		event.CmrsAddPas(-28.52, 37.89, 34.83, -2.96, 21.14, 7.37)
		event.CmrsAddPas(-28.68, 24.7, 45.16, -2.96, 19.14, 7.37)
		event.CmrsAddPas(-22.33, 14.47, 62.16, -2.96, 17.14, 7.37)
		event.CmrsAddPas(1.46, 10.46, 71.87, -2.96, 16.14, 7.37)
		event.CmrsAddPas(30.68, 10.46, 61.53, -2.96, 15.14, 7.37)
		event.CmrsAddPas(38.91, 13.26, 35.51, 4.6, 14.7, -11.02)
		event.CmrsStartPas()
		event.CmrsMove(36.58, 13.26, 32.4, 4.6, 14.7, -11.02, 60)
		event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
		event.ObjsSetColor(1, 128, 128, 128, 128, 60)
		helper_888ab2a3(90)
		language_code_2 = event.GetLanguage() or language_code_2
		if language_code_2 == 0 then
			event.ObjsMove(1, 134.0, 370.0, 0, 20)
		else
			event.ObjsMove(1, 154.0, 370.0, 0, 20)
		end
		helper_c624bc16()
		helper_888ab2a3(20)
		event.PlayBgm(0)
		event.CmrsReleaseObj()
	end)
	event.CancelDramaScene()
	event.SetFadeIn(1)
	event.SndSeStop(var6, 0)
	event.PlayBgm(0)
	event.CmrsReleaseObj()
	event.DelExtMotion(0)
	event.EohResetDaPosition(0)
	event.DelImg(0)
	event.SetCrossfade(10)
	event.Finish()
end

return helper_57d2be24
