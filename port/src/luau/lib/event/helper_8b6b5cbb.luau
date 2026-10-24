--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")

--- Helper function.
local function helper_8b6b5cbb()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: s32 = 0
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
		var6 = event.SndLoadSound_3(8, "snd2/sp/sp_000.sound.json") or var6
		event.LoadMotion(5, "dungeon/chara/c01b_win.gltf", "info", 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.StopBgm(0)
		event.SndSePlay(var6, 0)
		event.ObjsSetMotion(0, "勝利のポーズ", 6)
		event.ObjsMotionDelay(0, 1)
		event.ObjsNextMotion(0, "勝利のポーズL", 4)
		event.CmrsInit()
		event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 2.8, -5.0, 70.0, "", 1)
		event.CmrsMoveAhd(-0.24, -5.0, 70.0, 120)
		event.CmrsAhdSlowing(0.9, 30)
		event.ObjsMotionWait(0)
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
		event.ObjsSetScale(1, 1.0, 1.0, 0.0, 60)
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
	end)
	event.CancelDramaScene()
	event.SndSeStop(var6, 0)
	event.PlayBgm(0)
	event.CmrsReleaseObj()
	event.DelExtMotion(0)
	event.DelImg(0)
	event.SetCrossfade(15)
	event.Finish()
end

return helper_8b6b5cbb
