--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_8b19a097 = require("@lib/event/helper_8b19a097")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_da42986f()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 30 then
			if at <= 1 then
				helper_a8b5d854(40)
			end
			if at <= 2 then
				helper_a8b5d854(6)
			end
			if at <= 3 then
				helper_6018bc39()
			end
			if at <= 4 then
				helper_a8b5d854(30)
			end
			if at <= 5 then
				helper_a8b5d854(30)
			end
			if at <= 6 then
				helper_a8b5d854(30)
			end
			if at <= 7 then
				helper_8b19a097(6400400, 70)
			end
			if at <= 8 then
				helper_8b19a097(6400410, 180)
			end
			if at <= 9 then
				helper_40ca6466(2)
			end
			if at <= 10 then
				helper_6018bc39()
			end
			if at <= 11 then
				helper_a8b5d854(75)
			end
			if at <= 12 then
				helper_40ca6466(2)
			end
			if at <= 13 then
				helper_6018bc39()
			end
			if at <= 14 then
				helper_a8b5d854(12)
			end
			if at <= 15 then
				helper_40ca6466(2)
			end
			if at <= 16 then
				helper_a8b5d854(12)
			end
			if at <= 17 then
				helper_40ca6466(2)
			end
			if at <= 18 then
				helper_a8b5d854(69)
			end
			if at <= 19 then
				helper_a8b5d854(41)
			end
			if at <= 20 then
				helper_40ca6466(2)
			end
			if at <= 21 then
				helper_6018bc39()
			end
			if at <= 22 then
				helper_40ca6466(3)
			end
			if at <= 23 then
				helper_a8b5d854(10)
			end
			if at <= 24 then
				helper_a8b5d854(2)
			end
			if at <= 25 then
				helper_a8b5d854(28)
			end
			if at <= 26 then
				helper_6018bc39()
			end
			if at <= 27 then
				helper_40ca6466(3)
			end
			if at <= 28 then
				helper_a8b5d854(30)
			end
			if at <= 29 then
				helper_a8b5d854(30)
			end
			if vm.skip_end() then
				return skip(31)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.StopBgm(0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetMotionBlur(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.Finish()
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_a8b5d854(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(115)
	event.PlayBgm(0)
	event.LoadSound(6127)
	var0 = event.SndLoadSound(6217) or var0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e640_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e640_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e640_paz.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_paz2.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e640_joint.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 5)
	event.CopyChara(5, 36, 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 6)
	event.LoadChara(5, "e640_pazeye.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(7, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 7)
	block = event.LoadImg_4(5, "e640.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e64001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 2)
	event.EohSyncSprite(8, 0)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 8)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncObj(4, "p01_s3202-0")
	event.EohSetShow(4, 0)
	event.EohSetScale(5, 2.0, 2.0, 2.0)
	event.EohSetScale(6, 2.0, 2.0, 2.0)
	event.EohSetPos(2, 0.0, 1000.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "停止", 4)
	event.EohSetPos(3, 0.0, 1288.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "34_2", 4)
	event.EohSetShow(3, 0)
	var3 = event.EohGetFrameStatus(3, "eye--appcobyf2") or var3
	event.EohSetFrameStatus(3, "eye--appcobyf2", 0)
	event.EohSetFrameStatus(2, "udeli1--appc0f2z0", 0)
	event.EohSetFrameStatus(2, "udeli2--appc0f2z0", 0)
	event.EohSetFrameStatus(2, "udeli5--appc0f2z0", 0)
	event.EohSetFrameStatus(2, "udeli6--appc0f2z0", 0)
	event.EohSetPos(0, 23.34, -10000, 187.99)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 41.08, -10000, 186.05)
	event.EohSetRot(1, 0.0, -2.78, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetShow(0, 1)
	event.EohSetShow(1, 1)
	event.InitDramaScene()
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.SetProjection(300.9)
	event.CmrsInit()
	event.CmrsSetPos(-111.75, 911.17, 270.29)
	event.CmrsSetRef(0.0, 1000.0, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	event.CmrsMove2(-140.06, 1514.42, 332.93, 0.0, 1253.54, 0.0, 60, 0, 0.8)
	helper_a8b5d854(40)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "26＿27", 6)
	event.ObjsMotionWait(2)
	helper_a8b5d854(6)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotionBlur(64)
	helper_6018bc39()
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotionBlur(0)
	event.CmrsInit()
	event.CmrsSetPos(-113.65, 1223.45, 218.04)
	event.CmrsSetRef(-1.11, 1286.35, -8.92)
	event.CmrsMoveAhd(-0.25, -62.9, 253.33, 54)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetPos(0, 23.34, -12.5, 187.99)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 41.08, -11.08, 186.05)
	event.ObjsResetDaPosition(1)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetColor(7, 128, 128, 128, 128)
	event.EohSetShow(2, 0)
	event.CmrsSetPos(54.28, 1.22, 144.23)
	event.CmrsSetRef(22.48, 17.29, 208.69)
	event.SetProjection(524.9)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_8b19a097(6400400, 70)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_8b19a097(6400410, 180)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetColor(7, 128, 128, 128, 0)
	event.EohSetShow(2, 1)
	event.SetProjection(300.9)
	event.CmrsSetPos(193.62, 1333.67, 124.6)
	event.CmrsSetRef(93.29, 1343.08, 18.35)
	event.CmrsMove2(195.15, 1333.67, 68.97, 104.61, 1343.08, 9.78, 30, 2, 1.0)
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(2, "29", 6, 0.9)
	event.ObjsMotionWait(2)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(10)
	end
	helper_6018bc39()
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(0.0, 1069.05, 466.47)
	event.CmrsSetRef(0.0, 1160.83, 96.08)
	event.CmrsMove(0.0, 1100.96, 396.56, 0.0, 1160.83, 96.08, 100)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "30", 6)
	event.ObjsMotionWait(2)
	helper_a8b5d854(75)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(36)
	event.ObjsSetPos(4, 114.76, 1281.45, -29.48)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "ジョイント合体", 6)
	event.CharaActive(37)
	event.ObjsSetPos(5, -114.76, 1281.45, -29.48)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "ジョイント合体", 6)
	event.CmrsQuake(0.0, 0.6, 0.0, 14)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_6018bc39()
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(190.38, 1071.36, 114.36)
	event.CmrsSetRef(144.41, 1107.51, -36.76)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "31", 6)
	event.ObjsMotionWait(2)
	helper_a8b5d854(12)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotionBlur(64)
	event.HitEffect(0, 140.91, 1146.19, -9.4, 0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	event.HitEffect(1, 181.58, 1131.93, -25.69, 0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	event.HitEffect(2, 184.11, 1129.67, -49.68, 0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotionBlur(0)
	event.CmrsSetPos(-190.38, 1071.36, 114.36)
	event.CmrsSetRef(-144.41, 1107.51, -36.76)
	event.SndSePlay(var0, 3)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "31", 6)
	event.ObjsMotionWait(2)
	helper_a8b5d854(12)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotionBlur(64)
	event.HitEffect(0, -140.91, 1146.19, -9.4, -0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	event.HitEffect(1, -181.58, 1131.93, -25.69, -0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	event.HitEffect(2, -184.11, 1129.67, -49.68, -0.2, 0.15, -0.1, 50.0, 52.5, 0.0, 0.1, 30, 24)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMotionBlur(0)
	event.CmrsSetPos(0.0, 1106.47, 385.24)
	event.CmrsSetRef(0.0, 1149.39, 96.08)
	event.CmrsMove(0.0, 1055.59, 385.24, 0.0, 1149.39, 96.08, 130)
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(2, "33", 6)
	event.ObjsMotionWait(2)
	helper_a8b5d854(69)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsQuake(0.0, 1.0, 0.0, 20)
	event.ObjsSetPos(4, 42.33, 1231.79, -9.75)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "ジョイント合体", 6)
	event.ObjsSetPos(5, -42.33, 1231.79, -9.75)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "ジョイント合体", 6)
	helper_a8b5d854(41)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsQuake(0.0, 0.6, 0.0, 16)
	event.ObjsSetPos(4, 46.38, 1117.23, 34.1)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "ジョイント合体", 6)
	event.ObjsSetPos(5, -46.38, 1117.23, 34.1)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "ジョイント合体", 6)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(21)
	end
	helper_6018bc39()
	if vm.skipping() then
		return skip(22)
	end
	event.EohSetShow(2, 0)
	event.EohSetShow(3, 1)
	event.CmrsSetPos(0.0, 1356.59, 38.54)
	event.CmrsSetRef(0.0, 1358.02, 15.88)
	event.CmrsMove2(0.0, 1356.15, 49.81, 0.0, 1358.02, 15.88, 30, 2, 0.4)
	event.SndSePlay(var0, 5)
	event.ObjsSetMotion(3, "34_2", 6)
	event.ObjsMotionWait(3)
	helper_40ca6466(3)
	if vm.skipping() then
		return skip(23)
	end
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(24)
	end
	event.SndSePlay(var0, 6)
	event.CharaActive(1, 38)
	event.ObjsSetPos(6, 0.0, 1360.24, -11.53)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(6, "目光る", 6)
	helper_a8b5d854(2)
	if vm.skipping() then
		return skip(25)
	end
	event.EohSetFrameStatus(3, "eye--appcobyf2", var3)
	helper_a8b5d854(28)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(3, "35", 6)
	event.ObjsNextMotion(3, "35_L", 4)
	event.SndSePlay(var0, 7)
	event.CmrsMove2(0.0, 1232.77, 438.43, 0.0, 1231.93, 403.93, 60, 0, 0.3)
	event.SetMotionBlur(84)
	helper_6018bc39()
	if vm.skipping() then
		return skip(27)
	end
	helper_40ca6466(3)
	if vm.skipping() then
		return skip(28)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(29)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(30)
	end
	return part2()
end

return helper_da42986f
