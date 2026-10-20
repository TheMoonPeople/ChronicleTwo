--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_12e48d20 = require("@lib/event/helper_12e48d20")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")

--- Helper function.
local function helper_6ce9e84a()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var5: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_474c5bc8(6)
			end
			if at <= 2 then
				var5 = vm.f32(vector_z - vm.f32(3.1415927))
				helper_474c5bc8(30)
			end
			if at <= 3 then
				helper_41c448af(1)
			end
			if at <= 4 then
				helper_474c5bc8(10)
			end
			if at <= 5 then
				helper_12e48d20(4160010)
			end
			if at <= 6 then
				helper_12e48d20(4160020)
			end
			if at <= 7 then
				helper_41c448af(1)
			end
			if at <= 8 then
				helper_474c5bc8(10)
			end
			if at <= 9 then
				helper_12e48d20(4160030)
			end
			if at <= 10 then
				helper_41c448af(0)
			end
			if at <= 11 then
				helper_474c5bc8(30)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SndSeStop(var0, 2)
		event.SpriteSetDraw(0, 0)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetRot(3, vector_x, vector_y, vector_z)
		event.EohSetPos(4, pos_x, pos_y, pos_z)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(5, 1)
		event.EohSetShow(6, 1)
		event.CharaActive(0)
		event.SetCharaPos(0, -96.2, 1.8, 851.5)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.SetCameraRef(-96.2, 31.8, 851.5)
		event.SetCameraPos(-96.2, 41.8, 951.5)
		event.ResetCamera(0)
		if vm.wait() then
			return skip(14)
		end
		event.LoadMonsterFile(516, 1)
		event.LoadMonsterFile(1001, 0)
		event.AutoSetMonster(516, -78.11, -15.13, 426.88, 0.0, 0.0, 0.0)
		event.SetFadeIn(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(416, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	helper_474c5bc8(6)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(30)
	event.LoadSound(4809)
	var0 = event.SndLoadSound(4809) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e416/")
	event.LoadMes(0, 5, "e416_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e416_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e416_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	block = event.LoadImg_4(5, "e416telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e416telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(7, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 7)
	event.ChangeDir("")
	event.LoadChara(5, "event/e400/e410/e410_shigu.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e400/e410/mariometto_a.gltf", "info", 11)
	event.CharaActive(11)
	event.SetReference(10, "metto_null", 11)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e416/e416_mints.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e416/e416_monica.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(5, 1)
	event.EohSyncChara(6, 2)
	event.EohSyncObj(3, "p06_s19", "s19_09-m1")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p06_s19", "s19_10-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSetPos(0, -65.0, -38.28, 1157.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, -85.0, -38.13, 1157.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, -78.11, -15.13, 426.88)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "威嚇", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "赤目パチ")
	event.EohSetShow(5, 0)
	event.EohSetShow(6, 0)
	do
		local out1, out2, out3 = event.EohGetRot(3)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = event.CopyVector(rot_x, rot_y, var5)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = event.EohGetPos(4)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var5 = vm.f32(vector_z - vm.f32(3.1415927))
	var5 = event.AngleLimit(var5) or var5
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-228.84, 94.46, 882.3)
	event.CmrsSetRef(-94.17, 38.37, 1068.72)
	event.ObjsRotation2(3, rot_x, rot_y, var5, 40, 0, 0.5)
	event.ObjsPosDelay(4, 80)
	event.ObjsMove2(4, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	event.ObjsPosDelay(0, 100)
	event.ObjsMove(0, -65.0, -16.86, 1002.55, 40)
	event.ObjsMotionDelay(0, 100)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsPosDelay(1, 110)
	event.ObjsMove(1, -85.0, -16.86, 1002.55, 40)
	event.ObjsMotionDelay(1, 110)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 0)
	helper_41c448af(1)
	if vm.skipping() then
		return skip(4)
	end
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-70.27, 35.0, 783.66)
	event.CmrsSetRef(-73.25, 38.33, 674.48)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(5, 128, 128, 128, 128, 30)
	event.SndSePlay(var0, 1)
	event.ObjsSetPos(0, -50.18, 3.08, 671.54)
	event.ObjsSetRot(0, 0.0, -2.9, 0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -96.49, 3.79, 674.91)
	event.ObjsSetRot(1, 0.0, 2.78, 0.0)
	event.ObjsResetDaPosition(1)
	event.PlayBgm(0)
	helper_12e48d20(4160010)
	if vm.skipping() then
		return skip(6)
	end
	event.SpriteSetDraw(0, 0)
	event.SndSeStop(var0, 1)
	event.CmrsSetPos(-29.56, 15.56, 642.62)
	event.CmrsSetRef(-64.62, 25.05, 676.95)
	event.ObjsSetMotion(0, "間抜け立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, -78.55, 3.48, 677.41)
	event.ObjsSetRot(1, 0.0, 2.3, 0.0)
	event.ObjsSetMotion(1, "指差し", 6, -1.0, 1)
	event.ObjsNextMotion(1, "指差し会話", 6)
	event.ObjsNextMotion(1, "指差しＬ", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_12e48d20(4160020)
	if vm.skipping() then
		return skip(7)
	end
	helper_41c448af(1)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "うん！", 2)
	event.ObjsNextMotion(0, "間抜け立ち", 4)
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_12e48d20(4160030)
	if vm.skipping() then
		return skip(10)
	end
	helper_41c448af(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

return helper_6ce9e84a
