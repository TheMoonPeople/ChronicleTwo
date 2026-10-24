--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_845fb249(arg0: s32)
	local block: s32 = 0
	local language_code: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local language_code_2: s32 = 0
	vm.section(function()
		event.Initialize()
		event.InitDramaScene()
		helper_52115bbf()
		event.AssignStack(5)
		event.ClearStack(5)
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
		var3 = event.SndLoadSound_3(8, "snd2/sp/sp_000.sound.json") or var3
		var4 = event.GetEventInfoSndid(4) or var4
		event.SndSeStop(var4, 0)
		event.StopBgm(0)
		event.SndSePlay(var3, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local out1, out2, out3 = event.GetCameraPos()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		if arg0 == 2 then
			event.SetFcameraFollowA(var5, var6 + 40.0, var7)
		else
			event.SetFcameraFollowA(var5, var6 + 20.0, var7)
		end
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
		event.SetFcameraHeight(10.0)
		event.SetFcameraDist(64.0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsReference(0, pos_x, pos_y, pos_z, 10)
		event.EohSyncSprite(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
		event.ObjsSetColor(1, 128, 128, 128, 128, 60)
		helper_888ab2a3(90)
		language_code_2 = event.GetLanguage() or language_code_2
		if language_code_2 == 0 then
			event.ObjsMove(1, 134.0, 370.0, 0, 20)
		else
			event.ObjsMove(1, 154.0, 370.0, 0, 20)
		end
		helper_888ab2a3(70)
	end)
	event.CancelDramaScene()
	event.SetCameraCtrl(1)
	event.SetFadeIn(1)
	event.SndSeStop(var3, 0)
	event.PlayBgm(0)
	event.DelImg(0)
	event.SetCrossfade(10)
	event.Finish()
end

return helper_845fb249
