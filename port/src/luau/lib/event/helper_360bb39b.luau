--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_360bb39b()
	local var0: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_c1c32f84(150)
			end
			if at <= 2 then
				helper_c1c32f84(30)
			end
			if at <= 3 then
				helper_2386f745(2)
			end
			if at <= 4 then
				helper_c1c32f84(30)
			end
			if at <= 5 then
				helper_c1c32f84(30)
			end
			if at <= 6 then
				helper_c1c32f84(30)
			end
			if at <= 7 then
				helper_c1c32f84(30)
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
	helper_c1c32f84(4)
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
	block = event.LoadImg_4(5, "textures/event/e600/e624/e624telop01_1.json", 0) or block
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
	helper_c1c32f84(150)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "立ち", 2)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(3)
	end
	helper_2386f745(2)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "攻撃１", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(5)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

return helper_360bb39b
