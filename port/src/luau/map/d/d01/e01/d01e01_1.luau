--!strict
-- map/d/d01/e01/d01e01_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_136a94b8 = require("@lib/event/helper_136a94b8")
local helper_1565f910 = require("@lib/event/helper_1565f910")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_1f9a3afd = require("@lib/event/helper_1f9a3afd")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_3000b46a = require("@lib/event/helper_3000b46a")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_4d397cfd = require("@lib/event/helper_4d397cfd")
local helper_57ae27b6 = require("@lib/event/helper_57ae27b6")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_a03e568e = require("@lib/event/helper_a03e568e")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_ab5bcd36 = require("@lib/event/helper_ab5bcd36")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_c9057fa5 = require("@lib/event/helper_c9057fa5")
local helper_cd6723ca = require("@lib/event/helper_cd6723ca")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")

--- Helper function.
local function helper_37fe0()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetTimeStepEnable(0)
	event.SetAi(0, 8)
	event.AssignStack(4)
	event.ClearStack(4)
	event.ChangeDir("event/opening/p6/")
	event.LoadChara(4, "p6_donnie.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, 124.7, 104.0, 183.68)
	event.SetCharaRot(8, 0.0, 0.85, 0.0)
	event.SetMotion(8, "立ち", 4)
	event.ChangeDir("")
	event.LoadBgm(108)
	event.PlayBgm(0)
end

--- Helper function.
local function helper_382d0()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc >= 1 then
		event.FuncPointShow("", "memo", 0)
		event.EohSyncObj(0, "memo")
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_38444()
	local flag: s32 = 0
	event.SetFlag(40, 1)
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		helper_37fe0()
	end
	helper_382d0()
end

--- Helper function.
local function helper_39c20()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(20)
		end
		if at <= 2 then
			helper_aafd6a80(20)
		end
		if at <= 3 then
			helper_aafd6a80(2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 1000.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.SetCameraRef(0.0, 30.0, 820.0)
	event.SetCameraPos(0.0, 66.0, 700.0)
	event.SetFadeIn(30)
	event.ObjsMove(0, 0.0, 0.0, 820.0, 40)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 6)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_aafd6a80(2)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_39980()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetCharaPos(0, -380.0, 104.0, 0.0)
	event.SetCharaRot(0, 0.0, 1.57, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.SetCameraRef(-380.0, 134.0, 0.0)
	event.SetCameraPos(-260.0, 134.0, 0.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e260(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c9057fa5(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_c9057fa5(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_c049c42a(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3d1b4()
	local var0: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 96 then
			if at <= 1 then
				helper_aafd6a80(30)
			end
			if at <= 2 then
				helper_c9057fa5(0, 7)
			end
			if at <= 3 then
				helper_a03e568e(60210, -1, 10)
			end
			if at <= 4 then
				helper_8f31f334(0)
			end
			if at <= 5 then
				helper_1f9a3afd(60220, 80)
			end
			if at <= 6 then
				helper_1f9a3afd(60230, 70)
			end
			if at <= 7 then
				helper_184013af()
			end
			if at <= 8 then
				helper_aafd6a80(60)
			end
			if at <= 9 then
				helper_a03e568e(60240, -1, 10)
			end
			if at <= 10 then
				helper_a03e568e(60250, -1, 10)
			end
			if at <= 11 then
				helper_a03e568e(60260, -1, 10)
			end
			if at <= 12 then
				helper_a03e568e(60270, -1, 10)
			end
			if at <= 13 then
				helper_a03e568e(60280, -1, 10)
			end
			if at <= 14 then
				helper_a03e568e(60290, -1, 10)
			end
			if at <= 15 then
				helper_a03e568e(60300, -1, 10)
			end
			if at <= 16 then
				helper_a03e568e(60305, -1, 10)
			end
			if at <= 17 then
				helper_a03e568e(60310, -1, 10)
			end
			if at <= 18 then
				helper_8f31f334(0)
			end
			if at <= 19 then
				helper_a03e568e(60320, -1, 10)
			end
			if at <= 20 then
				helper_a03e568e(60330, -1, 10)
			end
			if at <= 21 then
				helper_a03e568e(60340, -1, 10)
			end
			if at <= 22 then
				helper_a03e568e(60350, -1, 10)
			end
			if at <= 23 then
				helper_aafd6a80(30)
			end
			if at <= 24 then
				helper_a03e568e(60360, -1, 10)
			end
			if at <= 25 then
				helper_8f31f334(1)
			end
			if at <= 26 then
				helper_a03e568e(60370, -1, 10)
			end
			if at <= 27 then
				helper_8f31f334(0)
			end
			if at <= 28 then
				helper_a03e568e(60380, -1, 10)
			end
			if at <= 29 then
				helper_a03e568e(60385, -1, 10)
			end
			if at <= 30 then
				helper_8f31f334(1)
			end
			if at <= 31 then
				helper_a03e568e(60390, -1, 10)
			end
			if at <= 32 then
				helper_8f31f334(0)
			end
			if at <= 33 then
				helper_a03e568e(60400, -1, 10)
			end
			if at <= 34 then
				helper_aafd6a80(10)
			end
			if at <= 36 then
				helper_a03e568e(60410, -1, 10)
			end
			if at <= 37 then
				helper_8f31f334(0)
			end
			if at <= 38 then
				helper_aafd6a80(20)
			end
			if at <= 39 then
				helper_a03e568e(60430, -1, 10)
			end
			if at <= 40 then
				helper_8f31f334(1)
			end
			if at <= 41 then
				helper_aafd6a80(15)
			end
			if at <= 42 then
				helper_8f31f334(1)
			end
			if at <= 43 then
				helper_aafd6a80(80)
			end
			if at <= 44 then
				helper_aafd6a80(20)
			end
			if at <= 45 then
				helper_8f31f334(0)
			end
			if at <= 46 then
				helper_8f31f334(1)
			end
			if at <= 47 then
				helper_aafd6a80(100)
			end
			if at <= 48 then
				helper_8f31f334(1)
			end
			if at <= 49 then
				helper_8f31f334(1)
			end
			if at <= 50 then
				helper_8f31f334(1)
			end
			if at <= 51 then
				helper_a03e568e(60450, -1, 10)
			end
			if at <= 52 then
				helper_8f31f334(0)
			end
			if at <= 53 then
				helper_aafd6a80(20)
			end
			if at <= 54 then
				helper_aafd6a80(20)
			end
			if at <= 55 then
				helper_a03e568e(60460, -1, 10)
			end
			if at <= 56 then
				helper_a03e568e(60470, -1, 10)
			end
			if at <= 57 then
				helper_a03e568e(60475, -1, 10)
			end
			if at <= 58 then
				helper_8f31f334(0)
			end
			if at <= 60 then
				helper_a03e568e(60480, -1, 10)
			end
			if at <= 61 then
				helper_a03e568e(60490, -1, 10)
			end
			if at <= 62 then
				helper_a03e568e(60500, -1, 10)
			end
			if at <= 63 then
				helper_184013af()
			end
			if at <= 64 then
				helper_8f31f334(0)
			end
			if at <= 65 then
				helper_8f31f334(2)
			end
			if at <= 66 then
				helper_e260(22, 1)
			end
			if at <= 67 then
				helper_c9057fa5(0, 4)
				helper_c049c42a(0, -1, 8, 0, 0)
			end
			if at <= 68 then
				helper_c9057fa5(0, 7)
				helper_8f31f334(0)
			end
			if at <= 69 then
				helper_a03e568e(60510, -1, 10)
			end
			if at <= 70 then
				helper_8f31f334(1)
			end
			if at <= 71 then
				helper_aafd6a80(14)
			end
			if at <= 72 then
				helper_8f31f334(0)
			end
			if at <= 73 then
				helper_a03e568e(60520, -1, 10)
			end
			if at <= 74 then
				helper_a03e568e(60530, -1, 10)
			end
			if at <= 75 then
				helper_e260(359, 1)
			end
			if at <= 76 then
				helper_a03e568e(60540, -1, 10)
			end
			if at <= 77 then
				helper_a03e568e(60550, -1, 10)
			end
			if at <= 78 then
				helper_8f31f334(0)
			end
			if at <= 79 then
				helper_a03e568e(60560, -1, 10)
			end
			if at <= 80 then
				helper_8f31f334(0)
			end
			if at <= 81 then
				helper_8f31f334(0)
			end
			if at <= 82 then
				helper_1f9a3afd(60570, 200)
			end
			if at <= 83 then
				helper_1f9a3afd(60580, 50)
			end
			if at <= 84 then
				helper_8f31f334(0)
			end
			if at <= 85 then
				helper_8f31f334(0)
			end
			if at <= 86 then
				helper_aafd6a80(30)
			end
			if at <= 88 then
				helper_a03e568e(60590, -1, 10)
			end
			if at <= 89 then
				helper_a03e568e(60595, -1, 10)
			end
			if at <= 90 then
				helper_8f31f334(0)
			end
			if at <= 91 then
				helper_8f31f334(0)
			end
			if at <= 92 then
				helper_aafd6a80(6)
			end
			if at <= 93 then
				helper_aafd6a80(14)
			end
			if at <= 94 then
				helper_aafd6a80(76)
			end
			if at <= 95 then
				helper_184013af()
			end
			if vm.skip_end() then
				return skip(97)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.EohSetFootSoundId(0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Initialize()
	event.InitDramaScene()
	helper_c9057fa5(0, 7)
	event.SetProjection(618.0)
	event.AssignStack(5)
	event.ClearStack(5)
	var0 = event.SndLoadSound(1800) or var0
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	event.LoadMes(0, 5, "event/opening/p6/op6_1.txt")
	event.DelImg(0)
	block = event.LoadImg_4(5, "textures/event/opening/p6/op06.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "op0601", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "op0602", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetAlphab(1, 0)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(11, 1)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "op0603", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetAlphab(2, 0)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(12, 2)
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.DelExtMotion(0)
	event.LoadMotion(5, "event/opening/p6/p6_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 103.83, 104.0, 195.7)
	event.ObjsSetRot(0, 0.0, 0.85, 0.0)
	event.ObjsSetMotion(0, "考えポーズL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "考える目")
	event.ObjsTexAnime(0, 1, "考える口")
	event.CharaActive(8)
	event.EohSyncChara(1, 8)
	event.EohSetFootSoundId(1, 3)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 124.7, 104.0, 183.68)
	event.ObjsSetRot(1, 0.0, 0.85, 0.0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "口閉じ")
	event.LoadItem(5, 1, "info", 10)
	event.CharaActive(0, 10)
	event.SetReference(0, "ef00", 10)
	event.LoadItem(5, 22, "info", 11)
	event.CharaActive(0, 11)
	event.SetReference(8, "donnie_gun", 11)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(2, 12)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 110.0, 135.89, 193.52)
	event.ObjsSetRot(2, 0.0, 0.6, 0.0)
	event.ObjsSetMotion(2, "発動", 5)
	event.LoadItem(5, 359, "info", 13)
	event.SetCharaPos(13, 0.0, 0.0, 0.0)
	event.SetCharaRot(13, 0.0, 0.0, 0.0)
	event.CharaActive(0, 13)
	event.SetReference(8, "donnie_receiver", 13)
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	event.CmrsSetPos(103.9, 126.98, 225.65)
	event.CmrsSetRef(112.72, 126.94, 179.57)
	event.ObjsSetMotion(0, "ななめ前を見る", 6)
	event.ObjsNextMotion(0, "ななめ前を見るL", 4)
	event.ObjsSetMotion(1, "ミンツを見る", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目")
	if vm.wait() then
		return skip(3)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60210, -1, 10)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetPos(0, 103.83, -100.0, 195.7)
	event.CmrsSetPos(112.75, 131.05, 198.49)
	event.CmrsSetRef(163.01, 122.54, 302.27)
	event.CmrsMove(112.75, 131.05, 198.49, 87.37, 110.42, 341.57, 180)
	helper_1f9a3afd(60220, 80)
	if vm.skipping() then
		return skip(6)
	end
	helper_1f9a3afd(60230, 70)
	if vm.skipping() then
		return skip(7)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(124.82, 125.36, 251.04)
	event.CmrsSetRef(105.61, 114.01, 150.82)
	event.ObjsSetPos(0, 103.83, 104.0, 195.7)
	event.ObjsSetMotion(0, "考えポーズ", 6, -1.0, 1)
	event.ObjsNextMotion(0, "考えポーズL", 4)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "ミンツを見る会話", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60240, -1, 10)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60250, -1, 10)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60260, -1, 10)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "ドニーを見る", 2)
	event.ObjsNextMotion(0, "ドニーを見るL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60270, -1, 10)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "ミンツを見る会話", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60280, -1, 10)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(0, "ドニーを見る会話", 2)
	event.ObjsNextMotion(0, "ドニーを見るL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60290, -1, 10)
	if vm.skipping() then
		return skip(15)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128, 128, 128, 128, 30)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60300, -1, 10)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60305, -1, 10)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.ObjsSetColor(10, 128, 128, 128, 0, 30)
	event.ObjsSetMotion(0, "考えポーズL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60310, -1, 10)
	if vm.skipping() then
		return skip(18)
	end
	event.SpriteSetDraw(0, 0)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60320, -1, 10)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60330, -1, 10)
	if vm.skipping() then
		return skip(21)
	end
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(11, 128, 128, 128, 128, 30)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60340, -1, 10)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetColor(11, 128, 128, 128, 0, 30)
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(12, 128, 128, 128, 128, 30)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60350, -1, 10)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetColor(12, 128, 128, 128, 0, 30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(24)
	end
	event.SpriteSetDraw(2, 0)
	event.ObjsSetMotion(1, "ミンツを見る戻り", 6)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60360, -1, 10)
	if vm.skipping() then
		return skip(25)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(0, "左を向く", 2)
	event.ObjsNextMotion(0, "左を向くL")
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 10)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60370, -1, 10)
	if vm.skipping() then
		return skip(27)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(1, "ミンツを見る", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60380, -1, 10)
	if vm.skipping() then
		return skip(29)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60385, -1, 10)
	if vm.skipping() then
		return skip(30)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsMotionWait(0)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60390, -1, 10)
	if vm.skipping() then
		return skip(32)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(1, "ミンツを見る会話", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60400, -1, 10)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(1, "ミンツを見るL")
	event.ObjsSetMotion(0, "工具を出す", 2)
	event.ObjsNextMotion(0, "工具を出すL", 6)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "武器おろし", 6)
	event.ObjsNextMotion(0, "武器おろしL", 4)
	event.ObjsSePlay(0, var0, 11)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(35)
	end
	event.CharaActive(10)
	event.ObjsTexaDelay(1, 25)
	event.ObjsTexAnime(1, 1, "イィッ")
	event.ObjsTexAnime(0, 0, "真剣口")
	if vm.wait() then
		return skip(36)
	end
	event.SetPakuAnim(0, "通常口パク", "得意口")
	helper_a03e568e(60410, -1, 10)
	if vm.skipping() then
		return skip(37)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsTexAnime(0, 0, "得意口")
	event.ObjsTexAnime(0, 1, "真剣口")
	event.ObjsTexAnime(1, 0, "イィッ")
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(1, "ミンツを見る会話", 2)
	event.ObjsNextMotion(1, "ミンツを見るL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60430, -1, 10)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetMotion(1, "ミンツを見る戻り", 6)
	event.ObjsMotionWait(1)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, 112.5, 104.0, 138.09, 25)
	event.ObjsRotation(1, 0.0, -2.91, 0.0, 10)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(42)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(43)
	end
	event.EohSetFootSoundId(1, 2)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, 112.5, 104.0, 138.09)
	event.ObjsAddPas(1, 101.97, 104.0, 102.83)
	event.ObjsAddPas(1, 89.86, 104.0, 69.5)
	event.ObjsAddPas(1, 68.34, 104.0, 21.46)
	event.ObjsAddPas(1, 31.72, 104.0, -50.16)
	event.ObjsAddPas(1, 5.79, 104.0, -85.32)
	event.ObjsAddPas(1, -6.62, 104.0, -126.94)
	event.ObjsAddPas(1, 2.98, 104.0, -174.2)
	event.ObjsAddPas(1, 8.78, 104.0, -191.0)
	event.ObjsAddPas(1, 10.66, 104.0, -225.67)
	event.ObjsStartPas(1)
	event.ObjsSetMotion(0, "後ろを向く", 2)
	helper_aafd6a80(80)
	if vm.skipping() then
		return skip(44)
	end
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(45)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(46)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(47)
	end
	event.SetCrossfade(60)
	event.ObjsSetMotion(0, "待ちくたびれ", 4, -1, 1)
	event.CharaActive(11)
	event.CharaActive(0, 10)
	event.CmrsSetPos(140.01, 119.16, 248.76)
	event.CmrsSetRef(99.95, 120.89, 177.35)
	event.ObjsSetRot(0, 0.0, 0.73, 0.0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, 10.66, 104.0, -225.67)
	event.ObjsAddPas(1, 8.78, 104.0, -191.0)
	event.ObjsAddPas(1, 2.98, 104.0, -174.2)
	event.ObjsAddPas(1, -6.62, 104.0, -126.94)
	event.ObjsAddPas(1, 5.79, 104.0, -85.32)
	event.ObjsAddPas(1, 31.72, 104.0, -50.16)
	event.ObjsAddPas(1, 68.34, 104.0, 21.46)
	event.ObjsAddPas(1, 89.86, 104.0, 69.5)
	event.ObjsAddPas(1, 101.97, 104.0, 102.83)
	event.ObjsAddPas(1, 112.5, 104.0, 138.09)
	event.ObjsStartPas(1)
	helper_aafd6a80(100)
	if vm.skipping() then
		return skip(48)
	end
	event.EohSetFootSoundId(1, 3)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsMove(1, 114.43, 104.0, 184.04, 25)
	event.ObjsRotation(1, 0.0, -0.78, 0.0, 25)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsSetMotion(1, "立ち", 2)
	event.ObjsNextMotion(1, "銃を渡す", 6)
	event.ObjsMotionWait(1)
	event.ObjsSeDelay(1, 60)
	event.ObjsSePlay(1, var0, 12)
	event.ObjsSetMotion(0, "右向け右", 6)
	event.ObjsNextMotion(0, "右向け右L", 4)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(51)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60450, -1, 10)
	if vm.skipping() then
		return skip(52)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsSetMotion(0, "銃を受け取る", 2)
	event.ObjsMotionDelay(0, 1)
	event.ObjsNextMotion(0, "銃を受け取るL", 6)
	event.ObjsNextMotion(0, "銃を受け取るL2", 4)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var0, 13)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(54)
	end
	event.DelReference(11)
	event.SetReference(0, "gun_hand", 11)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(55)
	end
	event.ObjsSetMotion(1, "銃を渡す戻り", 6)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60460, -1, 10)
	if vm.skipping() then
		return skip(56)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60470, -1, 10)
	if vm.skipping() then
		return skip(57)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60475, -1, 10)
	if vm.skipping() then
		return skip(58)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsSetMotion(0, "すごいよ", 6)
	event.ObjsNextMotion(0, "すごいよL", 4)
	event.ObjsTexAnime(0, 0, "真剣口")
	if vm.wait() then
		return skip(60)
	end
	event.SetPakuAnim(0, "通常口パク", "得意口")
	helper_a03e568e(60480, -1, 10)
	if vm.skipping() then
		return skip(61)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60490, -1, 10)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotion(1, "立ち")
	event.SetPakuAnim(0, "通常口パク", "得意口")
	helper_a03e568e(60500, -1, 10)
	if vm.skipping() then
		return skip(63)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(64)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(65)
	end
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.CmrsSetPos(136.41, 122.25, 229.2)
	event.CmrsSetRef(102.5, 130.77, 197.18)
	event.CmrsMove(123.15, 123.01, 222.97, 110.99, 134.65, 195.81, 120)
	event.SetBgmVol(0)
	event.SndSePlay(var1, 0)
	event.ObjsSetMotion(0, "銃を掲げる", 6, -1.0, 1)
	event.ObjsNextMotion(0, "銃を掲げるL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsSePlay(0, var0, 14)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var0, 15)
	event.CharaActive(1, 12)
	event.ObjsSetMotion(2, "発動", 6)
	event.ObjsMotionWait(2)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(66)
	end
	event.CharaActive(0, 12)
	helper_e260(22, 1)
	if vm.skipping() then
		return skip(67)
	end
	helper_c9057fa5(0, 4)
	event.MesMake_2(
		0,
		"[(!)] Use [l1] to get into your stance and (O)\n    to attack. But if you get too far away\n    your attacks won't be very effective."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(68)
	end
	helper_c9057fa5(0, 7)
	event.SetMesDrawspeed(0, 0)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(69)
	end
	event.SetBgmVol(-1)
	event.ObjsTexAnime(0, 1, "真剣目")
	event.ObjsTexAnime(0, 1, "真剣口")
	event.CharaActive(0, 12)
	event.CharaActive(0, 11)
	event.CmrsSetPos(140.01, 119.16, 248.76)
	event.CmrsSetRef(99.95, 120.89, 177.35)
	event.CharaActive(1, 13)
	event.ObjsSetPos(1, 114.41, 103.98, 185.73)
	event.ObjsSetMotion(0, "右向け右L", 4)
	event.ObjsNormalDrive(0)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(var0, 18)
	event.ObjsSetMotion(1, "レシーバーをあげる", 6)
	event.ObjsNextMotion(1, "レシーバーをあげるL", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60510, -1, 10)
	if vm.skipping() then
		return skip(70)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsSetMotion(0, "レシーバーをもらう", 6)
	event.ObjsNextMotion(0, "レシーバーをもらうL", 4)
	helper_aafd6a80(14)
	if vm.skipping() then
		return skip(72)
	end
	event.SndSePlay(var0, 19)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(73)
	end
	event.DelReference(13)
	event.SetReference(0, "ef00", 13)
	event.ObjsSetMotion(0, "レシーバーを下ろす", 6)
	event.ObjsNextMotion(0, "レシーバーを下ろすL", 4)
	event.ObjsSetMotion(1, "レシーバーをあげる戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60520, -1, 10)
	if vm.skipping() then
		return skip(74)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60530, -1, 10)
	if vm.skipping() then
		return skip(75)
	end
	helper_e260(359, 1)
	if vm.skipping() then
		return skip(76)
	end
	event.CharaActive(0, 13)
	event.CmrsSetPos(0.0, 174.49, 49.35)
	event.CmrsSetRef(0.0, 126.26, 245.83)
	event.ObjsSetPos(0, 0.0, 48.0, 267.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 24.15, 104.0, 216.41)
	event.ObjsSetRot(1, 0.0, -0.2, 0.0)
	event.ObjsSetMotion(0, "はしご上立ち", 4)
	event.ObjsNormalDrive(0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60540, -1, 10)
	if vm.skipping() then
		return skip(77)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60550, -1, 10)
	if vm.skipping() then
		return skip(78)
	end
	event.CmrsSetPos(-104.06, 146.74, 477.55)
	event.CmrsSetRef(16.01, 86.26, 244.13)
	event.ObjsSePlay(0, var0, 16)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var0, 17)
	event.ObjsSetMotion(0, "飛び降りる", 6)
	event.ObjsMotionWait(0)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(79)
	end
	event.CmrsSetPos(-45.88, 52.01, 341.35)
	event.CmrsSetRef(16.98, 101.86, 233.55)
	event.ObjsSetPos(1, 7.1, 104.0, 227.78)
	event.ObjsSetRot(1, 0.0, -0.08, 0.0)
	event.ObjsSetMotion(1, "下を見るL", 4)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsMotionWait(0)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_a03e568e(60560, -1, 10)
	if vm.skipping() then
		return skip(80)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(81)
	end
	event.ObjsSetMotion(0, "振り返る戻り", 6)
	event.ObjsMotionWait(0)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(82)
	end
	event.ObjsSetMotion(0, "走り2")
	event.ObjsMove(0, 0.0, 48.0, 600.0, 140)
	event.ObjsMotionDelay(1, 120)
	event.ObjsSetMotion(1, "下を見る会話")
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_1f9a3afd(60570, 200)
	if vm.skipping() then
		return skip(83)
	end
	event.CmrsSetPos(-15.79, 151.18, 139.2)
	event.CmrsSetRef(4.88, 115.54, 302.4)
	event.ObjsSetPos(0, 0.0, 48.0, 400.0)
	event.ObjsMove(0, 0.0, 48.0, 600.0, 60)
	helper_1f9a3afd(60580, 50)
	if vm.skipping() then
		return skip(84)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(85)
	end
	event.CmrsSetPos(0.0, 61.0, 700.0)
	event.CmrsSetRef(0.0, 29.0, 850.0)
	event.EohSetFootSoundId(0, 15)
	event.ObjsSetPos(0, 0.0, 0.0, 750.0)
	event.ObjsMove(0, 0.0, 0.0, 830.0, 30)
	event.ObjsResetDaPosition(0)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(86)
	end
	event.ObjsSetMotion(0, "旧・立ち")
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(87)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-2.62, 29.33, 799.72)
	event.CmrsSetRef(-2.62, 22.33, 827.0)
	event.ObjsSetMotion(0, "心配ないさ", 2)
	event.ObjsNextMotion(0, "心配ないさL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	if vm.wait() then
		return skip(88)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_a03e568e(60590, -1, 10)
	if vm.skipping() then
		return skip(89)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_a03e568e(60595, -1, 10)
	if vm.skipping() then
		return skip(90)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(91)
	end
	event.ObjsSetMotion(0, "心配ないさ戻り", 2)
	event.ObjsNextMotion(0, "旧･立ち", 4)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(92)
	end
	helper_aafd6a80(6)
	if vm.skipping() then
		return skip(93)
	end
	event.ObjsMove(0, 0.0, 0.0, 1230.0, 120)
	event.ObjsSetMotion(0, "走り2")
	event.CmrsMove(-2.62, 26.75, 843.0, -2.62, 24.35, 939.2, 120)
	event.EohSetFootSoundId(0, 15)
	helper_aafd6a80(14)
	if vm.skipping() then
		return skip(94)
	end
	event.EohSetFootSoundId(0, 2)
	helper_aafd6a80(76)
	if vm.skipping() then
		return skip(95)
	end
	event.FadeOutBgm(30)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_184013af()
	if vm.skipping() then
		return skip(96)
	end
	return part2()
end

--- Helper function.
local function helper_4459c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var11: s32 = 0
	local var12: any = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_57ae27b6(1)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, 8, 0, 0)
			end
			if at <= 3 then
				helper_c9057fa5(0, 1)
				var12 = helper_3000b46a(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 4 then
				helper_c9057fa5(0, 7)
				helper_3d1b4()
				if not vm.skipping() then
					return landing1()
				end
			end
			return 1
		end
		if at <= 6 then
			helper_403f0e66(0, -1, 0, 8, 0)
		end
		if at <= 7 then
			helper_57ae27b6(1)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_aafd6a80(11)
		end
		return 0
	end
	function part2()
		event.ObjsRotation(1, 0.0, 0.85, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
		event.ObjsSetMotion(1, "立ち")
		helper_aafd6a80(11)
		if vm.skipping() then
			return skip(10)
		end
		return 0
	end
	function landing1()
		return 1
	end
	event.Initialize()
	helper_c9057fa5(0, 7)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(8)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	yaw = event.GetRefAngle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.GetRefAngle(var3, var4, var5, var0, var1, var2) or yaw_2
	var11 = event.AngleCmp(var7, yaw, 0.1) or var11
	if var11 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsRotation(1, 0.0, yaw_2, 0.0, 10)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "立ち")
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, 60180)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, "So, what're you gonna do?")
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	helper_403f0e66(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
	helper_c9057fa5(0, 1)
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.MesMake_2(0, "I think I'll lay low here a while.\nUnderground water channel...")
	var12 = helper_3000b46a(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_c9057fa5(0, 7)
	event.SetMesShippo(0, 1)
	if var12 == 1 then
		event.StreamClose(1)
		helper_3d1b4()
		if vm.skipping() then
			return skip(5)
		end
		return 1
	else
		event.StreamOpen3(1, 60190)
		helper_57ae27b6(1)
		if vm.skipping() then
			return skip(6)
		end
		event.StreamPlay(1)
		event.MesMake_2(0, "I think I'll lay low here a while.")
		helper_403f0e66(0, -1, 0, 8, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.StreamClose(1)
		event.StreamOpen3(1, 60200)
		helper_57ae27b6(1)
		if vm.skipping() then
			return skip(8)
		end
		event.StreamPlay(1)
		event.MesMake_2(0, "Stay as long as you like.")
		helper_403f0e66(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.StreamClose(1)
	end
	return part2()
end

--- Helper function.
local function helper_3a064()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 39 then
			if at <= 1 then
				helper_c9057fa5(0, 7)
				helper_aafd6a80(6)
			end
			if at <= 2 then
				helper_37fe0()
				helper_57ae27b6(1)
			end
			if at <= 3 then
				helper_184013af()
			end
			if at <= 4 then
				helper_aafd6a80(16)
			end
			if at <= 5 then
				helper_aafd6a80(100)
			end
			if at <= 6 then
				helper_aafd6a80(20)
			end
			if at <= 7 then
				helper_a03e568e(60010, -1, 10)
			end
			if at <= 8 then
				helper_a03e568e(60020, -1, 10)
			end
			if at <= 9 then
				helper_a03e568e(60030, -1, 10)
			end
			if at <= 10 then
				helper_aafd6a80(50)
			end
			if at <= 11 then
				helper_a03e568e(60040, -1, 10)
			end
			if at <= 12 then
				helper_8f31f334(0)
			end
			if at <= 13 then
				helper_a03e568e(60050, -1, 10)
			end
			if at <= 14 then
				helper_a03e568e(60055, -1, 10)
			end
			if at <= 15 then
				helper_a03e568e(60060, -1, 10)
			end
			if at <= 16 then
				helper_a03e568e(60070, -1, 10)
			end
			if at <= 17 then
				helper_8f31f334(1)
			end
			if at <= 18 then
				helper_a03e568e(60080, -1, 10)
			end
			if at <= 19 then
				helper_a03e568e(60090, -1, 10)
			end
			if at <= 20 then
				helper_a03e568e(60095, -1, 10)
			end
			if at <= 21 then
				helper_a03e568e(60100, -1, 10)
			end
			if at <= 22 then
				helper_8f31f334(1)
			end
			if at <= 23 then
				helper_a03e568e(60110, -1, 10)
			end
			if at <= 24 then
				helper_8f31f334(0)
			end
			if at <= 25 then
				helper_1f9a3afd(60120, 150)
			end
			if at <= 26 then
				helper_1f9a3afd(60130, 100)
			end
			if at <= 27 then
				helper_184013af()
			end
			if at <= 28 then
				helper_1f9a3afd(60140, 140)
			end
			if at <= 29 then
				helper_1f9a3afd(60150, 120)
			end
			if at <= 30 then
				helper_184013af()
			end
			if at <= 31 then
				helper_57ae27b6(1)
			end
			if at <= 32 then
				helper_27ff0b8f(0, -1, 8, 0, 0)
				helper_aafd6a80(80)
			end
			if at <= 33 then
				helper_aafd6a80(30)
			end
			if at <= 34 then
				helper_aafd6a80(90)
			end
			if at <= 35 then
				helper_dd7a6f53(0)
				helper_aafd6a80(30)
			end
			if at <= 36 then
				helper_1f9a3afd(60170, 40)
			end
			if at <= 37 then
				helper_184013af()
			end
			if at <= 38 then
				helper_184013af()
			end
			if vm.skip_end() then
				return skip(40)
			end
			return part2()
		end
		if at <= 40 then
			helper_aafd6a80(30)
		end
		if at <= 41 then
			helper_c9057fa5(0, 4)
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		helper_c9057fa5(0, 1)
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.DelExtMotion(0)
		event.CharaActive(0)
		event.EohSetFootSoundId(0, -1)
		event.EohSetFootSoundId(1, 3)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.SetCharaPos(0, 103.83, 104.0, 195.7)
		event.SetCharaRot(0, 0.0, 0.85, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.SetCharaPos(8, 124.7, 104.0, 183.68)
		event.SetCharaRot(8, 0.0, 0.85, 0.0)
		event.SetMotion(8, "立ち", 4)
		event.CmrsInit()
		event.SetCameraPos(22.1, 160.44, 138.08)
		event.SetCameraRef(103.83, 133.97, 195.7)
		event.ResetCamera(0)
		event.SetProjection(524.9)
		event.SetFadeIn(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(41)
		end
		event.SetMesPreset(0, 4)
		helper_c9057fa5(0, 4)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(
			0,
			"[(!)]Talk to Donny and the story will continue.\n   You may want to save your progress\n   at a Save Point first."
		)
		helper_c049c42a(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
		event.LoadMes(0, -1)
		helper_c9057fa5(0, 1)
		event.SetMesDrawspeed(0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	helper_c9057fa5(0, 7)
	event.SetProjection(618.0)
	event.LoadSound(1800)
	event.StopBgm(0)
	helper_aafd6a80(6)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(108)
	event.PlayBgm(0)
	event.InitDramaScene()
	var0 = event.SndLoadSound(1800) or var0
	helper_37fe0()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p6/op6_1.txt")
	event.DelExtMotion(0)
	event.LoadMotion(5, "event/opening/p6/p6_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 12)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -464.39, 100.52, 0.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "はあはあ目")
	event.ObjsTexAnime(0, 1, "はあはあ口")
	event.CharaActive(8)
	event.EohSyncChara(1, 8)
	event.EohSetFootSoundId(1, -1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -443.0, 100.52, 8.0)
	event.ObjsSetRot(1, 0.0, -1.57, 0.0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "口閉じ")
	event.StreamOpen3(1, 60005)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "はしご降り", 6)
	event.ObjsSetMotion(1, "はしご降り", 6)
	event.ObjsSePlay(1, var0, 8)
	event.CmrsInit()
	event.CmrsSetPos(-173.98, 180.32, 173.33)
	event.CmrsSetRef(-478.87, 162.2, -4.22)
	event.CmrsFadeInit()
	event.CmrsFadeIn(60)
	helper_184013af()
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSeDelay(1, 30)
	event.ObjsSePlay(1, var0, 9)
	helper_aafd6a80(16)
	if vm.skipping() then
		return skip(5)
	end
	event.StreamPlay(1)
	helper_aafd6a80(100)
	if vm.skipping() then
		return skip(6)
	end
	event.StreamClose(1)
	event.SetCrossfade(60)
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.CmrsSetPos(-383.51, 121.05, 34.45)
	event.CmrsSetRef(-455.56, 111.89, -1.44)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "はあはあL", 4, -1, 1)
	event.ObjsSetPos(0, -447.2, 100.52, -9.2)
	event.ObjsSetRot(0, 0.0, 0.47, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(1, -434.79, 100.52, 18.22)
	event.ObjsSetRot(1, 0.0, -2.89, 0.0)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(7)
	end
	helper_a03e568e(60010, -1, 10)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60020, -1, 10)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_a03e568e(60030, -1, 10)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "深呼吸目")
	event.ObjsTexAnime(0, 1, "深呼吸口")
	event.ObjsSetMotion(0, "深呼吸", 6)
	event.ObjsNextMotion(0, "立ち2", 4)
	helper_aafd6a80(50)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsTexAnime(0, 0, "深呼吸口")
	event.SetPakuAnim(0, "通常口パク", "デフォルト口")
	helper_a03e568e(60040, -1, 10)
	if vm.skipping() then
		return skip(12)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60050, -1, 10)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60055, -1, 10)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "会話2", 2)
	event.ObjsNextMotion(0, "立ち2", 4)
	event.SetPakuAnim(0, "通常口パク", "デフォルト口")
	helper_a03e568e(60060, -1, 10)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-416.96, 123.15, -56.77)
	event.CmrsSetRef(-445.66, 113.41, 7.28)
	event.ObjsSetMotion(1, "指差し会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60070, -1, 10)
	if vm.skipping() then
		return skip(17)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(0, "会話2", 2)
	event.ObjsNextMotion(0, "立ち2", 4)
	helper_a03e568e(60080, -1, 10)
	if vm.skipping() then
		return skip(19)
	end
	helper_a03e568e(60090, -1, 10)
	if vm.skipping() then
		return skip(20)
	end
	helper_a03e568e(60095, -1, 10)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(0, "立ち2")
	event.ObjsSetMotion(1, "腰に手", 2)
	event.ObjsMotionWait(1)
	event.ObjsSetMotion(1, "腰に手L", 4)
	event.SetPakuAnim(1, "口パク", "口閉じ")
	helper_a03e568e(60100, -1, 10)
	if vm.skipping() then
		return skip(22)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-306.09, 121.28, -6.32)
	event.CmrsSetRef(-334.81, 124.2, -6.72)
	event.ObjsMove(0, -334.72, 100.52, -7.62, 140)
	event.ObjsRotation(0, 0.0, 1.57, 0.0, 10)
	event.ObjsSetMotion(0, "きょろきょろ歩き", 2)
	event.ObjsNextMotion(0, "きょろきょろ歩き・上")
	event.ObjsSetMotion(1, "振り返る", 6)
	event.ObjsNextMotion(1, "振り返るL", 4)
	event.ObjsRotation(1, 0.0, -1.21, 0.0, 30)
	event.ObjsTexaDelay(0, 100)
	event.ObjsTexAnime(0, 0, "目パチ")
	event.ObjsTexAnime(0, 1, "上目")
	event.SetPakuAnim(0, "通常口パク", "ポカーン")
	helper_a03e568e(60110, -1, 10)
	if vm.skipping() then
		return skip(24)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.CmrsSetPos(-82.68, 160.58, 85.07)
	event.CmrsSetRef(-54.97, 205.76, 261.35)
	event.CmrsMove(-82.68, 160.58, 85.07, 60.21, 145.99, 192.66, 300)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	helper_1f9a3afd(60120, 150)
	if vm.skipping() then
		return skip(26)
	end
	helper_1f9a3afd(60130, 100)
	if vm.skipping() then
		return skip(27)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(393.03, 191.08, 62.48)
	event.CmrsSetRef(89.13, 151.44, 51.64)
	event.CmrsMove(393.03, 191.08, 62.48, 125.13, 148.6, -81.82, 300)
	helper_1f9a3afd(60140, 140)
	if vm.skipping() then
		return skip(29)
	end
	helper_1f9a3afd(60150, 120)
	if vm.skipping() then
		return skip(30)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-316.41, 284.74, -17.35)
	event.CmrsSetRef(-8.6, 159.57, 242.62)
	event.CmrsMove(4.84, 184.71, 131.56, 106.14, 116.67, 193.96, 300)
	event.CmrsPrSlowing(0.96, 60)
	event.CmrsPrdelay(15)
	event.ObjsSetPos(0, -16.51, 104.0, 94.06)
	event.ObjsSetRot(0, 0.0, 0.85, 0.0)
	event.ObjsMove(0, 103.83, 104.0, 195.7, 200)
	event.ObjsSetMotion(0, "歩き", 4, -1, 1)
	event.ObjsMotionDelay(0, 200)
	event.ObjsSetMotion(0, "旧・立ち")
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsSetPos(1, -19.11, 104.0, 62.23)
	event.ObjsSetRot(1, 0.0, 0.85, 0.0)
	event.ObjsMove(1, 124.7, 104.0, 183.68, 230)
	event.ObjsMotionDelay(1, 230)
	event.ObjsSetMotion(1, "立ち")
	event.StreamOpen3(1, 60160)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(32)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 60160)
	helper_27ff0b8f(0, -1, 8, 0, 0)
	helper_aafd6a80(80)
	if vm.skipping() then
		return skip(33)
	end
	event.EohSetFootSoundId(0, 3)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(34)
	end
	event.EohSetFootSoundId(1, 3)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(35)
	end
	helper_dd7a6f53(0)
	event.StreamClose(1)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(36)
	end
	helper_1f9a3afd(60170, 40)
	if vm.skipping() then
		return skip(37)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_184013af()
	if vm.skipping() then
		return skip(39)
	end
	return part2()
end

--- Helper function.
local function helper_d248(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = helper_3000b46a(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
		end
		return var2
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesQuestionGyou(1, 0)
	event.SetMesWindowMode(1, 5)
	event.SetMesDrawspeed(1, 1)
	event.SetMesItemDirect(1, 1, vm.i32(arg1 + 20000))
	var2 = helper_3000b46a(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesDrawspeed(1, 0)
	return var2
end

--- Helper function.
local function helper_3856c()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			var0 = helper_d248(5, 10)
		end
		if at <= 3 then
			helper_aafd6a80(30)
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	if vm.wait() then
		return skip(2)
	end
	var0 = helper_d248(5, 10)
	if vm.skipping() then
		return skip(3)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(4)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_39140()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c9057fa5(0, 1)
			helper_c049c42a(0, -1, 5, 256, 208)
		end
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMesQuestionGyou(0, 0)
	helper_c9057fa5(0, 5)
	event.SetMesDrawspeed(0, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var0)
	var4 = 0.0
	var5 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var2)
	event.ObjsMove(0, var3, var4, var5, 30, 1)
	event.ObjsReference(0, var3, var4, var5, 10)
	event.ObjsSetMotion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var6 = var6 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	event.ObjsSetMotion(0, "立ち")
	helper_c9057fa5(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "I wonder where this channel goes?\nI'll ask Donny.")
	helper_c049c42a(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_38728()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				var0 = helper_d248(5, 55)
			end
			if at <= 2 then
				helper_aafd6a80(10)
			end
			if at <= 3 then
				helper_aafd6a80(30)
			end
			if at <= 4 then
				helper_aafd6a80(2)
			end
			return 1
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	var0 = helper_d248(5, 55)
	if vm.skipping() then
		return skip(2)
	end
	if var0 == 0 then
		event.ObjsSetPos(0, 0.0, 0.0, 820.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.SetCameraRef(0.0, 30.0, 820.0)
		event.SetCameraPos(0.0, 40.0, 760.0)
		event.ObjsMove(0, 0.0, 0.0, 1000.0, 40)
		helper_aafd6a80(10)
		if vm.skipping() then
			return skip(3)
		end
		event.EohSetFootSoundId(0, 2)
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(4)
		end
		event.ObjsSetMotion(0, "立ち")
		helper_aafd6a80(2)
		if vm.skipping() then
			return skip(5)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30, 1)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(6)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_12070(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "Hmm, this tree... It doesn't look\ngood. I've got to do something.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max! You scared me.\nI was just taking some nasty bugs\noff this tree.<page>Not all trees grow up fine on\ntheir own, you know. Some, like\nthis one, you have to really watch."
		)
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_11d2c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "Hmm, this tree... It doesn't look\ngood. I've got to do something.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Looks like you have to talk to\n   Gordon to get his attention.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_123b8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_11d2c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, Max! You've been moping about\na lot lately. Are you taking care\nof yourself?<page>Something I can do for you?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "What! You want me to go with you\non your adventure?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Hmm... I'd like to go with you...\nBut this poor tree isn't doing\nso well.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Taking care of the trees and the\nflowers on this property is my\nnumber one priority, you know.<page>If I go off roaming about, I could\nlose my job."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"I bet some of the Holy Water that Priest Bruno\nsells at the church would fix this tree!<page>But, as you know, your father\nand Priest Bruno are on bad terms...<page>Your father'd never give me money to buy\nHoly Water from Priest Bruno!<page>I'm in a pickle."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]To get Gordon to Sindain, first you\n   have to get him to join you on\n   your journey.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]If you fulfill Gordon's quest,\n   he'll join you on your journey and\n   get on the train."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "[(!)]You can check out your quests\n   by reading your Notebook,\n   located on the Item Menu.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)]Oh, you don't have a Notebook.\n   There's one on the table\n   inside the Maintenance Shop."
		)
		helper_c049c42a(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]There's another one in\n   Donny's hideout. Either will do.\n   Just get hold of one quick!"
		)
		helper_c049c42a(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

--- Helper function.
local function helper_130b8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_11d2c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Max, fixing this tree is my number\none priority.<page>Now, what I need to fix this\ntree...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.GotoUseItem(276)
	do
		local skipped = vm.wait()
		var3 = event.DeferredOutput() or var3
		if skipped then
			return skip(4)
		end
	end
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 276 then
		event.MesMake_2(0, "Max, this just won't work.<page>What I need is Holy Water from\nPriest Bruno.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Yes! Max, you've done it! Now\nI can take care of this tree!<page>Thank you, Max.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"My work is all taken care of\nfor now.<page>Now I can go with you on your\nadventure!<page>Oh, and don't mention that Holy\nWater to you father, you hear?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon joined your party.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]You can use his abilities\n   from the Status command under\n   Characters on the Main Menu.<page>[(!)]If you recruit someone else\n   to join your adventure, that\n   person will get on the train."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Talk to that person inside\n   the train to switch him or her\n   in as your third party member.<page>[(!)]To move one of your train friends\n   into a house, choose Move Person\n   from the door menu of that house."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "[(!)]There may be many others\n   willing to join your party.\n   Be sure to look for them!")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	var4 = event.GetEventData_2(14) or var4
	event.SetNpcStatus(var4, 130)
	event.Finish()
	event.SetQuestEtc(1, 0, 1)
end

--- Helper function.
local function helper_13d68(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, hello, young lady.\nSomething I can do for you?")
		else
			event.MesMake_2(0, "Max, don't mention that Holy Water\nto your father, you hear?")
		end
	else
		event.MesMake_2(0, "There must be so many plants out\nthere we haven't even seen yet.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14088(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_12070(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_12070(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_123b8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_130b8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_13d68(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_16a30(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_dae2ac4c(arg0, 0, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_dae2ac4c(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Hi there.\nIt's Monica, right?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "I'm Parn.\nI'm a magical artist.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hey Max.<page>How come you always\nlook so well?!")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_16e0c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_403f0e66(0, -1, arg1, arg0, 0)
			end
			if at <= 5 then
				helper_c049c42a(0, -1, 8, 0, 0)
			end
			return
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 10 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 13 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_dae2ac4c(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "Hi there.\nIt's Monica, right?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "I'm Parn.\nI'm a magical artist.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, "...")
		helper_403f0e66(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)] Monica's not very good in this kind of \n   situation. She might get somewhere, but\n   probably not. Better try again as Max."
		)
		helper_c049c42a(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesPreset(0, 0)
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Hey Max.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "...")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Yeah, you can laugh.\nI know it's strange!<page>Who'd fall in love with\na girl in a picture?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"But I'm a magical artist.\nI have the power to make the things I draw real.<page>Whatever I draw really does exist in the picture.\nAs long as it's not a living thing..."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "Even a magical artist can't draw life.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "But, I've heard of a way.\nThere's a Golden Egg in a big, old tree.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "It's said that with its golden colour,\nyou can give life to anything you draw.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"Max, you're going out of\ntown, right?<page>I wonder if you could get hold of some Golden Paint?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Of course I don't expect you to do it for nothing.<page>If you can help me, I'll use\nmy new power to help you in return."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]A big, old tree...\n   With  a Golden Egg! Where on earth\n   would you find a tree like that?!"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_d49c(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c9057fa5(1, 4)
			var1 = 50
			var1 = 51
			helper_c049c42a(1, var1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_c9057fa5(1, 4)
	event.MesSetBuff(1, 1, 1)
	var2 = event.GetPartyCharaMesNo_3(arg0, 0) or var2
	event.SetMesItemDirect(1, 1, var2)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if true then
		var1 = 50
	else
		var4 = event.GetPartyCharaMesNo_3(now_party_chara_id, 0) or var4
		event.SetMesItemDirect(1, 2, var4)
		var1 = 51
	end
	helper_c049c42a(1, var1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesSetBuff(1, 1, 0)
end

--- Helper function.
local function helper_11c4c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d49c(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_d49c(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_17f14(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11c4c()
		end
		if at <= 8 then
			helper_d49c(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"I've been waiting for you.<page>Quick, give me the Paint so that\nI can give life to my picture."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(376)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 376 then
		event.MesMake_2(0, "You must be joking!<page>What I need is Golden Paint.\nGet it right!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "So this is Golden Paint...\nI'll try it straight away.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Sh-she... She's real...<page>Amazing, she's perfect!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Thanks, Max.\nI haven't forgotten my promise. Please use\nmy new power whenever you want.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_d49c(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_186cc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Please use my new power\nwhenever you want.")
	else
		event.MesMake_2(
			0,
			"The world of pictures is very deep.\nIt may take me a lifetime to master\nbut the journey is well worth it."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18924(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_16a30(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_16a30(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_16e0c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_17f14(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_186cc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_c020(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_c049c42a(arg0, -1, 3, 256, 208)
		end
		if at <= 3 then
			helper_c9057fa5(arg0, 1)
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_c049c42a(arg0, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var4 = out1 or var4
		var5 = out2 or var5
	end
	if 0 < var4 then
		return 1
	end
	if var5 == 1 then
		helper_c9057fa5(arg0, 1)
		event.MesMake_2(arg0, "If you don't bring me more scoops,\nI can't give ya nothin'!")
		if now_map_no == 22 then
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_c049c42a(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
	end
	if var5 == 2 then
		helper_c9057fa5(arg0, 1)
		event.MesMake_2(
			arg0,
			"Your Photography level's determined\nby the number of ideas and scoops\nyou have.<page>And as your level goes up, you get\nmore cool items as rewards."
		)
		if now_map_no == 22 then
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		else
			helper_c049c42a(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_c668(arg0: s32)
	local var1: s32 = 0
	local player_chara: s32 = 0
	local now_map_no: s32 = 0
	local argc: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c049c42a(arg0, -1, 3, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_c049c42a(arg0, -1, 3, 256, 208)
			end
			return helper_c020(arg0)
		end
		if at <= 5 then
			helper_c9057fa5(arg0, 1)
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
		end
		if at <= 6 then
			helper_c049c42a(arg0, -1, 3, 256, 208)
		end
		return helper_c020(arg0)
	end
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	now_map_no = event.GetNowMapNo() or now_map_no
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_c9057fa5(arg0, 1)
		event.MesMake_2(arg0, "Go get me a\nScoop Memo, will ya?")
		if now_map_no == 22 then
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_c049c42a(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var5 = out1 or var5
		var6 = out2 or var6
	end
	if var5 == var6 then
		helper_c9057fa5(arg0, 1)
		event.MesMake_2(arg0, "Looks like there's\nno more scoops to be had.")
		if now_map_no == 22 then
			helper_403f0e66(arg0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_c049c42a(arg0, -1, 3, 256, 208)
			if vm.skipping() then
				return skip(4)
			end
		end
		return helper_c020(arg0)
	end
	var7 = event.GetMenuEtc_2(3) or var7
	if 0 < var7 then
		helper_c9057fa5(arg0, 8)
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "I figured out [Number1] more scoops.")
		event.SetMesDrawspeed(arg0, 0)
		helper_c049c42a(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_c9057fa5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Come on, man! Quit slackin'!\nWhere's all your new inside scoops?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Woo! You got [Number1] new scoops!\nI knew you had it in ya!")
	end
	if now_map_no == 22 then
		helper_403f0e66(arg0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		helper_c049c42a(arg0, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(7)
		end
	end
	return helper_c020(arg0)
end

--- Helper function.
local function helper_f614(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_f718()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("IN go_shop_up()\n")
			print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
			helper_30c30f62(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_f614(15)
		end
		if at <= 3 then
			helper_f614(1)
		end
		if at <= 4 then
			helper_f614(6)
		end
		if at <= 5 then
			helper_f614(0)
		end
		if at <= 6 then
			helper_f614(4)
		end
		if at <= 7 then
			helper_f614(31)
		end
		if at <= 8 then
			helper_f614(35)
		end
		if at <= 9 then
			helper_f614(36)
		end
		if at <= 10 then
			helper_f614(37)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Welcome.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Working hard, I see?\nYou need something?<page>No freebies, though.\nNot even for you, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"You need some more Georama\nelements?<page>If you don't have the time to\ncollect them yourself, maybe\nmoney can solve your problems."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Hello. I'm a baker's apprentice.\nI'm handling the bakery while\nPolly's away.<page>I'm a little nervous, but this is\nall part of my training, I guess.\nI'll do my best!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"We may not look very much alike...\nBut I'm Milane's little sister.<page>Milane made me watch the shop while she's away.\nI don't know the first thing about weapons!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Surprise you, did I? I guess anyone\nwould be surprised to see someone\nstanding here dressed like this.<page>I'm a good friend of Priest Bruno. I'm\nfilling in for him while he's away on a trip.\nSo, is there anything I can help you with?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
			)
		end
	end
	if var1 ~= -1 then
		helper_30c30f62(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_f614(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_f614(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_f614(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_f614(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_f614(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_f614(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_f614(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_f614(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_f614(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_18d98(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"The shop's closed. You'll have to\ngo to my old man's shop instead.<page>Look for the pumpkins. I'm sure you'll see 'em.\nIt's just at the top of that ladder."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18c08(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Since you came along, I've\nhardly seen Max at all.\nI don't know what you're up to,<page>but I hope you're not using him."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18f48(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_18c08(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"You should know the answer to that:\nN-O W-A-Y!<page>Why should I have to work for the\nsake of other people?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "There's not much in it for me, and\nit's just too scary.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "As it's you, I suppose I could\nthink about it, though.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "But then, I am the son of a salesman\nand we don't do things for free.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"You probably know that I collect coins.<page>They're the symbol of business. I really\nwant to complete my collection."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"But I just can't seem to get\nmy hands on the Dark Coin\nand the Indestructible Coin.<page>If you can help me,\nmaybe I can help you."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_1968c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_11c4c()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_18c08(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(201) or argc
	argc_2 = event.GetItemNum(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.MesMake_2(
			0,
			"What? Aah, coin collecting?<page>I'm looking for the Dark Coin\nand the Indestructible Coin.<page>You'll never get hold of those. I've looked all\nover for them, but they're impossible to find."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Eh? You've got them? Unbelievable!<page>Don't just stand there! Gimme, gimme, gimme!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "OK.\nWhat shall I do?")
	var5 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Argh! If you're going to mess me\naround I definitely won't help you.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(201)
	event.SubItem(202)
	event.MesMake_2(
		0,
		"Wow, I've got them all!\nAnd I thought it was impossible...<page>Well, I guess I've got no choice now.\nI'd better go with you!"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_1a11c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_18c08(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"I can't believe it. I never\nreally imagined you could get them.<page>That's really something, Max!"
		)
	else
		event.MesMake_2(0, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1a43c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_18d98(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_18f48(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_1968c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_1a11c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_1a720(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dae2ac4c(arg0, 0, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Hello. What kind of food do you\nlike, Monica?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Of course, I like normal food, but\nI'm also partial to unusual food.")
	else
		event.MesMake_2(0, "I'm going to be the world's best\nchef someday, and when I do,\nyou can eat free anytime.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1aac8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Made any good discoveries?<page>You know, while you're making discoveries\nabout machines and devices,\nI'm making discoveries about cooking.<page>Every day, I'm researching how to make\ndelicious foods that no one's ever\ntasted before."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1acc8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ah, good timing!\nThere's something I wanted to talk to you about.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"I'm sure you know that I'm making\nunusual sweets from around the\nworld as part of my research."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "I've heard that there's a sweet called Castagnaccio.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "which is made using something called Castarna.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "I've managed to find out that this Castarna grows\non the same kind of tree as Chestnuts.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"So I thought I may as well try using Chestnuts instead,\nbut it's really weird...\nChestnuts are sold out all over town."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Apparently the Mayor's bought them all up or something.\nDon't suppose you could help me out?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_1b444(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Did you get hold of any Chestnuts?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoUseItem(301)
	do
		local skipped = vm.wait()
		var2 = event.DeferredOutput() or var2
		if skipped then
			return skip(3)
		end
	end
	if var2 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 ~= 301 then
		event.MesMake_2(0, "So you can't help...<page>Oh well, better give up on making\nCastagnaccio.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Yes, that's it. Thanks very much.<page>Now I can try to make some Castagnaccio.<page>I'll let you try some as soon as it's ready."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Actually, is there anything I can do in return?<page>What? You want me to go with you on an adventure?<page>Ha-ha! Of course I will.<page>Why didn't you just ask in the first place?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1bb1c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Of course I'd never refuse\nyou anything.")
	else
		event.MesMake_2(0, "I'm going to be the world's best\nchef someday, and when I do,\nyou can eat free anytime.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1bd64(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1a720(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a720(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1aac8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1acc8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1b444(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1bb1c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1c0f0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dae2ac4c(arg0, 0, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Hi! Are you Max's\ngirlfriend?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Your hair's a really unusual colour.\nLike Erik's, but different...<page>Yours is really pretty,\nlike a jewel."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1c3c0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c0f0(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c0f0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "You've been going out of town recently,\nright Max?<page>Don't deny it.\nI know you have.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1c5d8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c0f0(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "I wish I could help you out, but fighting's\nscary and I might get dirty.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "And I'd hate to be a nuisance to everyone.\nSorry, but I'll have to say no.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"But there must be lots of\nunusual things outside town.<page>I wonder what the trees are like,\nand what kind of flowers there are."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"If you see an interesting flower, could\nyou take a picture of it for me, Max?\nI'd so love to see it."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]She said no this time, but if you show\n   her a picture of something she's\n   interested in she'll probably give in."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 4, 1)
end

--- Helper function.
local function helper_1cd2c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11c4c()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c0f0(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	photo = event.CheckInventPhoto(2009) or photo
	photo_2 = event.CheckInventPhoto(52, 3) or photo_2
	photo_3 = event.CheckInventPhoto(53, 3) or photo_3
	photo_4 = event.CheckInventPhoto(54, 3) or photo_4
	photo_5 = event.CheckInventPhoto(55, 3) or photo_5
	if vm.i32(vm.i32(vm.i32(vm.i32(photo + photo_2) + photo_3) + photo_4) + photo_5) <= 0 then
		event.MesMake_2(
			0,
			"Did you get a picture of an unusual flower?<page>I know a lot about flowers, so if it's\nnothing special it won't interest me."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Did you get a picture of an unusual flower?\nLet's see, let's see!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Wow! This is amazing!\nSo these are the kind of flowers on the outside.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Hmm... what should I do?<page>Oh, okay! Take me with you!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1d55c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_1c0f0(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "Don't go anywhere too\ndangerous.")
	else
		event.MesMake_2(0, "At long last the Blackstone\nRailroad takes on the world.\nIt's so exciting!")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1d82c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c3c0(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_1c3c0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1c5d8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1cd2c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1d55c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1db10(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Maybe I'm the only one to think this, but something\nabout you really reminds me of Elena.<page>I don't know what it is, but you have a certain quality\nthat seems different to other people in this town."
		)
	else
		event.MesMake_2(0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1dde8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "If you have any kind of problem,\nmake sure you come to me first.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1df48(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "If there's anything you need,\nI'll do my best to help you.<page>Leave it to me.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "I don't know if you can help...<page>But just listen to this.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "I've spent some 30 years working\nhard in this house.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "That's all I do, but my one\nhobby is reading.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "There's a really valuable and rare book\nthat's up for auction at the moment.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "People are fighting over it.\nI believe a bid of about\n1000 Gilda would be enough.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"But I don't have those kind of funds, and if I were\nto ask my master, he'd be appalled and I'd probably\nhave to resign."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"So you're my only hope.<page>But that's not to say that\nif you can't help me I won't help you."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Despite what he says, Stewart probably\n   won't help unless you give him 1000 Gilda.\n   Oh well, better get some money together!"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

--- Helper function.
local function helper_1e9c4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_aafd6a80(30)
			end
			return
		end
		if at <= 13 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"That kind of money won't\nget me into the auction.<page>I need 1000 Gilda.\nPlease get it right!"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(0, "You won't believe this!<page>The price has gone up to\n1200 Gilda.")
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(0, "I'm terribly sorry, but could you\npossibly get hold a of 1500 Gilda?")
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetCnt(9, 1)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.MesMake_2(
				0,
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 1500 Gilda as quick as you can!"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"This is terrible!\nThere's someone who'll pay 1800 Gilda!<page>If I don't bid about 2000 Gilda,\nthere's no way I'll win."
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetCnt(9, 2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.MesMake_2(
				0,
				"We mustn't mess about otherwise\nit'll be sold to someone else.<page>Get me 2000 Gilda as quick as you can!"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Sonny, did you manage to get\nmy 2000 Gilders together?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "What can I do, it's yours.\nIt does seem a bit of a waste.")
		var4 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"I see... well, 2000 Gilda is a lot of money.\nso it must be hard to part with.\nEven for a well-off young lad like you...<page>Okay then, never mind!\nBut the auction isn't over yet.\nI'll wait, no matter how long it takes..."
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Thank you so much.<page>I'll get straight down to the auction!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(12)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		event.Finish()
		return
	end
	event.MesMake_2(0, "Thank you very much.\nI managed to make a successful bid.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "I bid strong and everyone else dropped out really\nquickly, so I got it for 1400 Gilda!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "So now I can give you 600 back.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(0, "And I'll work hard from now on to repay\nyou the rest of the money I borrowed.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(0, "I know I put you to a lot of trouble.\nI'll repay the favour anytime.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_2000c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"The book I got?\nActually, I haven't read it yet.<page>Just getting hold of it\nwas enough to make me happy."
		)
	else
		event.MesMake_2(0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_20284(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1db10(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1db10(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1dde8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1df48(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1e9c4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2000c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_20610(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dae2ac4c(arg0, 0, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Please stop getting Max into\ndangerous situations.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "If I find just one scratch on him,\nI'll never forgive you!")
	else
		event.MesMake_2(0, "I pray for your safety...")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_20978(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"I'm working here as a maid at the moment,\nbut since I was a child I had a dream of\nbecoming a tailor."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Dreams don't come true,\nso that's why I call it a dream.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_20c58(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"I see...I really wish\nthat I could help you.\nMore than anything.<page>But I don't have any\nconfidence in myself."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"I always seem to give up halfway,\nand I've never seen anything through.<page>When I was little, I dreamt of becoming a tailor,\nand I tried many times to make something,\nbut I never completed a single garment."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "If I went with you, I'm sure\nI'd just get in the way.<page>So, sorry, but no.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Oh dear, Adel has lost all her\n   confidence. This is no good. Let's\n   get her to try making clothes again."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

--- Helper function.
local function helper_21284(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Yes, if I try again and this\ntime manage to complete something,\nmaybe I'll believe in myself again."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "But I don't have the materials I need.<page>Would you be able to get them for me?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "All I need is Sturdy Cloth,\nThick Hide, and a Hunk of Copper.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_21674(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_dae2ac4c(arg0, 0, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 4 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			helper_aafd6a80(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(214) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	if argc <= 0 or argc_2 <= 0 or argc_3 <= 0 then
		event.MesMake_2(
			0,
			"Without the materials,\nI can't make anything.<page>I need Sturdy Cloth,\nThick Hide and a Copper Lump.<page>Sorry to be\nsuch a bother."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Here, have these!\nIt seems a bit of a waste.")
	var5 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Without the materials,\nI can't make anything.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(214)
	event.SubItem(245)
	event.SubItem(227)
	event.SetCnt(8, 2)
	event.MesMake_2(0, "Thanks very much!\nNow I'll try making some clothes!<page>I won't let these go to waste.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.Finish()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_22078(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dae2ac4c(arg0, 0, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			var2 = 259
			var2 = 258
			var2 = 260
			helper_e260(var2, 1)
		end
		if at <= 6 then
			helper_136a94b8(1)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_11c4c()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ah, Max! I've finally completed a garment!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"I didn't want to let the materials\nyou gave me go to waste,\nand that kept me going to the end."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "I'm not completely satisfied with it,\nbut would you wear it anyway?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	var2 = 259
	argc = event.GetItemNum(258) or argc
	if argc <= 0 then
		var2 = 258
	else
		argc = event.GetItemNum(260) or argc
		if argc <= 0 then
			var2 = 260
		end
	end
	event.AddItem(var2)
	helper_e260(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ah, it's so great to have\nfinished something.<page>Now I feel much\nmore confident.<page>I'll do the very best I can,\nso please take me with you."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_22784(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "How does it fit?<page>Tell me the truth!")
	else
		event.MesMake_2(0, "I pray for your safety...")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2298c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_20610(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_21674(arg0, arg1)
			end
			if at <= 6 then
				helper_22078(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_20610(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_20978(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_20c58(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_21284(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_21674(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_22078(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_22784(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_23c34(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dae2ac4c(arg0, 0, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"You're the girl that's been\nhanging around with Max lately.<page>I know a good man\nwhen I see one."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "If I was just a little bit younger,\nI wouldn't let that one go.")
	else
		event.MesMake_2(0, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_23ffc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"The most important thing in business\nis having the trust of your customers.<page>It's something you must\nnever take for granted."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2419c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_e260(300, 20)
		end
		if at <= 5 then
			helper_136a94b8(1)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"You want me to\ngo with you?<page>I'm just a woman who bakes bread,\nbut if I can be of any use to you,\nI will gladly."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, but first I've got something\nthat needs delivering to Morton.<page>Would you mind delivering 20 loaves\nof bread to Morton's shop for me?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "While you're doing that,\nI'll pack for the trip.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_e260(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "I wonder what on earth he\ncould want with 20 loaves?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_2474c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(0, "Sorry, I'm still\nnot ready.<page>Can you give me\na little longer?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "By the way, have you been\nto Morton's for me yet?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "What! How can he be\nso inconsiderate?<page>Oh well,\nyou have them.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Never mind that,\nlet's get going.<page>So where are\nwe off to?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_11c4c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_24d1c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Come on Max,\nlet's get going.<page>So where are\nwe off to?")
	else
		event.MesMake_2(0, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_24f54(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_23c34(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_23c34(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_23ffc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_2419c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2474c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_24d1c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_14354(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"I don't really like to see a\nwoman waving a sword around.<page>The best women are the ladylike\nones. Take Adel, for example."
		)
	else
		event.MesMake_2(0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_145dc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"This town is too peaceful, and\nthere's just no work for me.<page>Of course, I know that's a good thing,\nbut still..."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1476c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Hey, Max.\nSorry, but I'm a bit\ntied up right now.<page>I'm in the middle of\ngetting important materials\nto keep this town safe."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "If it's not urgent,\ncan it wait until tomorrow?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_14a5c(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Sure, I'll give it a try.\nI'm not up to it.")
	var2 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(0, "Okay...<page>Okay, if you wanna try again later,\njust let me know. I'll be waiting.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "Ready, steady,\ngo!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

--- Helper function.
local function helper_14ff0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_14a5c(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Hey Max, have you come looking for me?<page>I've been waiting.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Thanks to the castle walls,\nthis town is pretty safe.<page>It's time for us to go outside.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "It's good that you're always\ntinkering about with machines,\nbut I wonder how strong you are?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Fighting's all about\nspeed and footwork.<page>If you're any slower than me,\nit's no good.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Why don't we give you a test.\nRun to the boat at the lake and back.<page>My record is 2 minutes 1 second.\nIf you're any slower than that,\nit's no good."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "How about it, you want to try?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_14a5c(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_15694(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_14a5c(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_14a5c(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_14a5c(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_14a5c(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_11c4c()
		end
	end
	do
		local out1, out2, out3, out4 = event.Stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(0, "Hey there, Max.\nYou come to try again?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_14a5c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(0, "Oy! You didn't get to the boat,\ndid you? You tried to trick me.\nDon't cheat!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "Giving it another try?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_14a5c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "Hey, no cheating!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Giving it another try?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_14a5c(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "Oh, you're back!\nRight,<page>Let's check\nyour time!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "Oh Dear!\n[数値１] minutes [数値２].[数値３] seconds is\ntoo slow.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(0, "Giving it another try?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_14a5c(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(0, "Oh!\n[数値１] minutes [数値２] seconds [数値３]\nisn't a bad time!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "You're a lot faster than you look. Okay,\nlet's go and fight the bad guys together!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_162b4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "You're a lot faster\nthan you look.\nYou've surprised me!")
	else
		event.MesMake_2(0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_164ec(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14354(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_14354(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_145dc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_1476c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_14ff0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_15694(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_162b4(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_252e0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"So you saw me at the circus?\nPretty cool, right?<page>It's not so much a job\nas a hobby of mine."
		)
	else
		event.MesMake_2(0, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_25548(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"My shop specializes\nin blades.<page>I do have some guns,\nbut firearms aren't\nreally my kind of thing."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_256c8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_e260(44, 1)
		end
		if at <= 6 then
			helper_136a94b8(1)
		end
		if at <= 7 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "You're Monica,\nright?<page>I've heard you're not\nbad with a sword.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "But swords aren't\nplaythings you know.<page>You have to think about\nwhat's in front of you.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "If you can build-up a sword by about 2 levels,\nthen I'll believe you've got talent.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Why don't you start\nwith this Gladius.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_e260(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]To get Milane to accept you, it looks\n   like you'll have to build-up Gladius by\n   2 levels."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]It's fine to buy or pick up weapons too.\n   Just get hold of a strong weapon, and\n   then Milane will help you out."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

--- Helper function.
local function helper_25e7c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(67) or argc
	argc_2 = event.GetItemNum(69) or argc_2
	if argc <= 0 and argc_2 <= 0 then
		event.MesMake_2(
			0,
			"What sort of a sword is that?\nSo it was all just talk?<page>Get out of here!\nYou're just getting in the way."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Wow, that's a pretty\nimpressive sword.<page>Sorry I had\nto test you.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "It's just that if I fight with an\namateur it's dangerous for me too.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "But I guess I needn't worry\nabout that with you.<page>Right, let's go\nfight together.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_264e8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "A glint of a well-made\nsword is so brilliant.<page>It takes your breath away.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "I don't understand how anyone could\nbe happy just polishing stones.")
	else
		event.MesMake_2(0, "So, what's the scoop? Come across\nany tough guys in that mine yet?")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_268a0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_252e0(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_252e0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_25548(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_256c8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_25e7c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_264e8(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_26c2c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Are you a friend of Max's?<page>Well, mind how you go.")
	else
		event.MesMake_2(
			0,
			"From now on I'm going to be helping\nNeed and Cedric rebuild the world.\nWe have to work together on this."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_26e84(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"You're good with machines,\nbut don't you think it's time for\nyou to start learning about mining?"
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_27004(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_e260(24, 1)
		end
		if at <= 6 then
			helper_136a94b8(1)
		end
		if at <= 7 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "According to Cedric,\nyou've been off up to\nsomething recently.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "You're good at a lot of things,<page>but on the other hand you\nnever see anything through.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "So when you ask for help,\nit's hard for me to take you\nseriously just like that.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"I know, why don't you try to build-up\nthis Trumpet Gun to a Bell Trigger?<page>Think you can do it?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_e260(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]To get Gerald to accept you,\n   you'll have to bring\n   him a Bell Trigger.<page>[(!)]You can build-up the weapon you've\n   been given, or you can buy a weapon,\n   or bring one you find in the dungeons."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

--- Helper function.
local function helper_27758(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"What's wrong?\nYou're giving up again?<page>I'm disappointed.\nIs that what comes of tinkering\nwith machines all the time?"
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Oh! Looks like you've gotten\npretty good with weapons too!<page>I don't even need to see you shoot.\nI can tell by the way you hold it."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Okay, I'll help you out.\nBut I'm not doing it for you.<page>If this town's in danger,\nI can't just sit\nhere doing nothing."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_27cc8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Guns aren't toys.<page>Be careful what you do with\nthem or you might get hurt.")
	else
		event.MesMake_2(
			0,
			"From now on I'm going to be helping\nNeed and Cedric rebuild the world.\nWe have to work together on this."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_27f40(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_26c2c(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_26c2c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_26e84(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_27004(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_27758(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_27cc8(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_282cc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cd6723ca(arg0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Grumble, grumble...")
	helper_cd6723ca(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...1212,<page>No, no, I'm sure it was 1122.<page>Or maybe it was 1010.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Grumble, grumble...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]If he doesn't even notice you \n   trying to say, \"Hello.\" He must \n   have some pretty serious problems.<page>[(!)]Why don't you try back later?\n   Maybe you could lend him a hand or\n   an ear or something."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_2873c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_ab5bcd36(arg0, arg1)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_ab5bcd36(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Grumble, grumble...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"What do you mean, what\nam I muttering about?<page>I'm trying to remember the\ncombination for the safe."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"What do you mean,\nwhat safe?<page>The safe hidden behind the\npicture in my office of course..."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_ab5bcd36(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"Ah, you gave me a fright!<page>Oh, blast!<page>I've gone and let out\nmy biggest secret!<page>Oh well, you know now.<page>Maybe you can give me a\nhand trying to work it out."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "I've got a big problem\nbecause I can't remember the\ncombination for the safe.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "It's a 4-digit number so I used\nClaire's birth date thinking\nthat I'd never forget it.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "How could I possibly forget...<page>What a terrible father I am!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]It looks like the Mayor's very troubled.\n   Listen to what he says about Claire's\n   birthday and figure out the combination."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

--- Helper function.
local function helper_290ec(arg0: s32, arg1: s32)
	local var2: any = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				var2 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_aafd6a80(30)
			end
			if at <= 11 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_aafd6a80(15)
			end
			return
		end
		if at <= 14 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_8f31f334(0)
		end
		if at <= 16 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_aafd6a80(15)
		end
		if at <= 18 then
			helper_aafd6a80(15)
		end
		if at <= 19 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 20 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 21 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(0, "A long time ago I gave her a brooch\nwith her star sign on it.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Holly sorted it out for me so I don't\nreally remember,\nbut I'm sure it was a 4-legged animal..."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"What kind of birthday\npresents have I given her?<page>Hmm...lots of coats\nand scarves I suppose.<page>I never know what to get her.\nIt's a real struggle every year."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"Oh yes! Claire's birthday is always a right pain!\nIt's on a day when both burnable and non-burnable\ngarbage get collected.<page>It's my job to put the\ngarbage out in our house."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"Non-burnable garbage gets collected\non days divisible by 7,<page>and burnable garbage gets collected\non days divisible by 3."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "You wouldn't forget that though,\nwould you?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"I get it! Mystery solved!\nThe combination is...<page>I don't know...Let's listen some more."
		)
		var2 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(8)
		end
		if var2 == 0 then
			break
		else
			if var2 == -1 then
				event.Finish()
				return
			end
			event.SetMotion(arg0, "会話")
		end
	end
	event.SetMenuEtc(0, "Enter the secret code number.", "1221", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(9)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var3 = out1 or var3
	end
	if var3 == -1 then
		event.Finish()
		return
	end
	event.SetFadeOut(15)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(10)
	end
	var7 = event.GetSndId(2) or var7
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaRot(arg0)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	event.SetCharaPos(arg0, -100.0, 0.0, -110.0)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = event.Atan2f(-100.0 - var14, -110.0 - var16) or var20
	event.SetCharaRot(0, 0.0, var20, 0.0)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraPos(64.64, 46.9, 92.64)
	event.SetCameraRef(-100.0, 20.0, -110.0)
	event.SetFadeIn(15)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(11)
	end
	if var3 == 0 then
		event.SetMotion(arg0, "会話")
		event.MesMake_2(0, "Hmm, it won't open. Oh dear...<page>There are some really important\ndocuments in there...")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		event.SetMotion(arg0, "立ち")
		event.SetFadeOut(15)
		helper_aafd6a80(15)
		if vm.skipping() then
			return skip(13)
		end
		event.SetCharaRot(0, var17, var18, var19)
		event.SetCharaPos(arg0, var8, var9, var10)
		event.SetCharaRot(arg0, var11, var12, var13)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.SetFadeIn(15)
		event.Finish()
		return
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "Er...Hmm...\n1,<page>2,<page>2,<page>1...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "Wa-hoo!<page>Great,\nit worked!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0, arg0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, var14, var15, var16, 30)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "Great! Now I can get my\nimportant documents out!<page>Oh, thank you!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetFadeOut(15)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaRot(0, var17, var18, var19)
	event.SetCharaPos(arg0, var8, var9, var10)
	event.SetCharaRot(arg0, var11, var12, var13)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetFadeIn(15)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"What important documents?<page>Documents that will help Vice Mayor Morton\ndo my job while I'm away.<page>It's a bit of a worry,\nbut I'm sure it'll be okay."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"Right, now I'm all set to leave town too.<page>Cedric told me everything.<page>Come on, let's go."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_2b03c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Make sure you separate your garbage\nand throw it out on the right days, won't you?")
	else
		event.MesMake_2(
			0,
			"Just on a personal note here, I\nknow Zelmite Mine is a dangerous\nplace. Don't do anything foolish."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2b2b4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_282cc(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_282cc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_2873c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_290ec(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2b03c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2bf70(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var3 = event.GetChapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.MesMake_2(0, "I pray that the world will\nfrom today forever be at peace.")
	else
		event.MesMake_2(0, "When you're striving for a good cause,\nyou must have wisdom.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2c1cc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Really? You need my help?<page>Then let me pose you a problem.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"The candles in this church are\ncontrolled by a small mechanism.<page>When they're lit it puts them out,\nand when they're out it lights them.<page>If one of them changes,\nthe adjacent candles change too."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"If you can put all the candles out successfully,\nit'll prove your wisdom, and I'll go with you.<page>If you solve it, great! If not,\nplease understand that I cannot help you."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]This is another puzzler. Give\n   it a few attempts, and make use\n   of what you learn each time."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]If you re-enter the church,\n   the candles will be reset.\n   So don't worry about going wrong.\n   The answer could be simple."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

--- Helper function.
local function helper_2b598()
	local var0: { s32 } = table.create(14, 0)
	local var14: s32 = 0
	local var15: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var14 = 0
		var15 = 0
		var14 = var14 + 1
		var15 = var15 + 1
		return var14
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p08_i01h07", "i01h07_13-m7")
	event.EohSyncObj(1, "p08_i01h07", "i01h07_13-m21")
	event.EohSyncObj(2, "p08_i01h07", "i01h07_13-m8")
	event.EohSyncObj(3, "p08_i01h07", "i01h07_13-m20")
	event.EohSyncObj(4, "p08_i01h07", "i01h07_13-m9")
	event.EohSyncObj(5, "p08_i01h07", "i01h07_13-m19")
	event.EohSyncObj(6, "p08_i01h07", "i01h07_13-m10")
	event.EohSyncObj(7, "p08_i01h07", "i01h07_13-m18")
	event.EohSyncObj(8, "p08_i01h07", "i01h07_13-m11")
	event.EohSyncObj(9, "p08_i01h07", "i01h07_13-m17")
	event.EohSyncObj(10, "p08_i01h07", "i01h07_13-m12")
	event.EohSyncObj(11, "p08_i01h07", "i01h07_13-m16")
	event.EohSyncObj(12, "p08_i01h07", "i01h07_13-m14")
	event.EohSyncObj(13, "p08_i01h07", "i01h07_13-m15")
	var0[1] = event.EohGetShow(0) or var0[1]
	var0[2] = event.EohGetShow(1) or var0[2]
	var0[3] = event.EohGetShow(2) or var0[3]
	var0[4] = event.EohGetShow(3) or var0[4]
	var0[5] = event.EohGetShow(4) or var0[5]
	var0[6] = event.EohGetShow(5) or var0[6]
	var0[7] = event.EohGetShow(6) or var0[7]
	var0[8] = event.EohGetShow(7) or var0[8]
	var0[9] = event.EohGetShow(8) or var0[9]
	var0[10] = event.EohGetShow(9) or var0[10]
	var0[11] = event.EohGetShow(10) or var0[11]
	var0[12] = event.EohGetShow(11) or var0[12]
	var0[13] = event.EohGetShow(12) or var0[13]
	var0[14] = event.EohGetShow(13) or var0[14]
	var14 = 0
	var15 = 0
	while var15 < 14 do
		if var0[var15 + 1] ~= 0 then
			var14 = vm.i32(var14 + 1)
		end
		var15 = var15 + 1
	end
	return var14
end

--- Helper function.
local function helper_2c928(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_2b598()
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_2b598()
	if 0 < var2 then
		event.MesMake_2(0, "It seems like you're not\nquite good enough yet.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"I have high hopes for you in the future,\nbut I'm afraid I can't cooperate\nwith you at the moment."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"You've done well.\nWonderful.<page>I'm sure you'll live\nup to my expectations.<page>I promised, didn't I?\nI'll go with you."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2ce28(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2bf70(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2cec0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2bf70(arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2bf70(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2c1cc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2c928(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2ce28(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2d1b0(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Why do I miss the moon so much?<page>I wonder if that's where I\ncame from...")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2d310(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Yeah, I don't mind going with\nyou, but will there be a moon there?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Really? Maybe you're just saying that.\nI know humans tell lies.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Actually, I've changed my mind.\nI'm going to wait for the moon to come out here.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Maybe it's because of something that\n   happened in the past, but Rufio doesn't\n   trust humans at all."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]You've got to get Rufio to\n   believe you. If you gave him a\n   photo of the moon, that might do it."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 14, 1)
end

--- Helper function.
local function helper_2d96c(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"I thought you might be different,\nbut no, humans are humans.<page>No matter. I've got used to you\nhumans telling lies all the time."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Wow, amazing! There's a moon in this photo.<page>Now I can see the moon any time, any place.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Come with you?<page>Of course I will.\nI've nowhere else to go.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2de7c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "You gave me this photo of the moon.\nYou're a good human.")
	else
		event.MesMake_2(
			0,
			"If the Blackstone Railroad goes all\nover the world, we'll be able to\nvisit lots of cool new places."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2e0d4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2d1b0(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2d1b0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2d310(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2d96c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2de7c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2e3b8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"My hobby is fishing.<page>It's my dream to catch a Mardan Karayan.<page>I only respect people who catch big fish."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2e548(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "You want me to do you a favour?<page>First, hear me out.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"I only listen to people that I respect.<page>And the only people I respect are people\nthat have caught a bigger fish than me."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"The biggest fish I ever caught\nwas a 60cm Nonky.<page>Are you impressed?\nIf you feel like a challenge,\nI'll take you on anytime!"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]It seems like the only way to get\n   him on your side is to catch a Nonky\n   of more than 60cm. You can do it!"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]Anyway, try doing some fishing\n   in the Palm Brinks lake.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_2ebf4(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"Hey, I'll bet you've never\nactually caught a Nonky?<page>Ha-ha. You must really stink\nat fishing!"
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 < vm.f32(0.6) then
		var3 = vm.ftoi(vm.f32(var2 * 100.0))
		event.SetMesValue(0, 1, var3)
		event.MesMake_2(0, "Ha-ha! You only caught\na [数値１] cm baby!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "You're nowhere near worthy of my help!<page>You'd better start fresh.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "...Oh, I underestimated you.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Well, I'm a man. Men don't need to be told twice.<page>I'll listen to what you say as I promised."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Talk as much as you like!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_2f43c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Um, I don't need to know right this instant,\nbut maybe one day you could let me\nin on your fishing tricks."
		)
	else
		event.MesMake_2(
			0,
			"I can't wait to check out all the\nnew fishing spots all over the\nworld. It's gonna be so fun."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2f6c4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2e3b8(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2e3b8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2e548(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2ebf4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2f43c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2f9a8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "The Firbit people will only\ngrant favours to people who are\nmore skilled than themselves.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2fb18(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "The Firbit people will only\ngrant favours to people who are\nmore skilled than themselves.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "I'm fairly confident when it\ncomes to fish.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"I've heard that some humans are holding\nan event where they make their fish compete\nagainst each other.<page>If you've got a fish, why don't you\ntry to come in first place?<page>If you can do that, then \nI'll know you're worthy of my help."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]She seems to be talking about the Fish\n   Race.  Why not try to win the Beginners'\n   Class?  Then maybe she'll help."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

--- Helper function.
local function helper_30134(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "They say that a fish mirrors its owner.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "There's no way I'll talk to such a \nweak fish's owner.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"I was watching, you know.\nIt was a great race.<page>I doubt that I could've raised\nsuch a good fish.<page>Please take me with you.\nPlease teach me what you know."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_30618(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "I hope that one day I'll be able\nto stand at the top of the winner's podium too.")
	else
		event.MesMake_2(
			0,
			"I just wish that Fabio would have\na bit of an interest in something\noutside of fishing, too."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_30880(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2f9a8(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_2f9a8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_2fb18(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_30134(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_30618(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_30bc4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dae2ac4c(arg0, 0, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "I've not been feeling too good lately.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"I got Dr. Dell to come and have a look at me,\nbut he said there's nothing wrong.<page>I wonder why?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_30e84(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"I've not been feeling too good lately.<page>I'm just not up to going on a trip.<page>I got Dr. Dell to come and have a look at me,\nbut he said there's nothing wrong."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"But even standing normally I feel\nlike I'm going to fall down.<page>It's hard to explain. It's almost\nas if the world has been distorted."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"Hmmm...\nif Dr. Dell doesn't know what the problem is,\nthen there's not much I can do to help..."
		)
		helper_403f0e66(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "I remember those symptoms.")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"In the time I was born,\nthe world was in a very bad state,\nwith more time distortions than\nyou can possibly imagine."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"This had an effect on physically\nweak and fragile people.<page>Light people would get dizzy or faint,\nand heavier people couldn't stand at all."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Maybe you're particularly susceptible\nto this kind of thing.<page>Even the few time distortions we have\nhere are enough to affect you."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "If we can just get rid of some of the closest\ndistortions, maybe you'll start to feel better.")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]How to fix a time distortion... Spheda!\n   If you can complete about 10 stages,\n   maybe Mena will start to feel better."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	var3 = event.GetMenuEtc_2(0) or var3
	event.SetCnt(19, var3)
	event.SetQuestEtc(0, 17, 1)
end

--- Helper function.
local function helper_31ab0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "I'm still not feeling great.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Maybe there's something\nreally wrong with me?<page>Maybe even Dr. Dell\ncan't help me now..."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Hello!<page>How am I feeling? Great!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "I can't believe how much better I am recently.<page>Now the world feels right again.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Oh yeah, you wanted me to do you a favour.<page>I'll do whatever I can to help.<page>You helped me,\nso I must help you."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_32200(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "You helped me so I'll help you, but please\ndon't take me to a place that has insects!")
	else
		event.MesMake_2(
			0,
			"If the Blackstone Railroad spreads\nall around the world, maybe I'll\nhave to go around the world too."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_32478(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_30bc4(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_30bc4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_30e84(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_31ab0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_32200(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_32744(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dae2ac4c(arg0, 0, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Ooh, Max! I've heard that\nyou've been going out of town recently.")
	else
		event.MesMake_2(0, "Ooh, Monica! I've heard that\nyou've been going out of town recently.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "That's great! Why don't you\ntake me with you?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_32adc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_aafd6a80(30)
		end
		if at <= 13 then
			helper_aafd6a80(30)
		end
		if at <= 14 then
			helper_aafd6a80(60)
		end
		if at <= 15 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "Ooh, Max! I've heard that\nyou've been going out of town recently.")
	else
		event.MesMake_2(0, "Ooh, Monica! I've heard that\nyou've been going out of town recently.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "That's great! Why don't you\ntake me with you?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"I bet you're thinking I won't be\nany use because I'm a girl.<page>But I actually bring people\na lot of luck."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"It never rains when I go out,\nand I've never seen a losing\nlottery ticket.<page>What do you think?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "OK then.\nNo, sorry.")
	var3 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "Why! Don't be mean!\nYou're horrible!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "You're useless!<page>You fool!<page>You idiot!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "You'll take me with you?<page>I didn't think you would!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"But how come I'm the only one\nthat has to ask you, when you've\nbeen asking all these other people.<page>If you'd just asked, then of\ncourse I would have helped you."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "I know, if you can find me,\nthen I'll help you. What do you think?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "In other words, let's play hide-and-seek!<page>Right, go!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Oh well... Looks like you'd better try\n   to find Corinne. She's probably hiding\n   somewhere in Palm Brinks."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

--- Helper function.
local function helper_33bbc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_aafd6a80(30)
			end
			return
		end
		if at <= 4 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "Oh! You found me!<page>But can you find me again?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_aafd6a80(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		return
	end
	event.MesMake_2(
		0,
		"Oh! You found me...<page>I'm getting a bit fed up with this now.<page>Hiding is actually\nreally boring.<page>Oh well! Let's go off on\nour adventure then!"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_34124(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Hide-and-seek is just\nfor little kids.")
	else
		event.MesMake_2(
			0,
			"You can't fool me. I know you've\nbeen off doing all sorts of fun\nstuff. Tell me about it sometime!"
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3436c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_32744(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_32744(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_32adc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_33bbc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_34124(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_34650(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"...<page>Ah! Hello!\nI've been a bit deaf lately.<page>I can't make out what you're\nsaying unless you speak slowly."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_347e0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_11c4c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "What was that?<page>Can't you talk a bit more slowly?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(0, 'Please enter, "Let\'s go together."', "Let's go together.", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
	do
		local out1, _, _, _ = event.GetMenuParam_4()
		var2 = out1 or var2
	end
	if var2 == -1 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 0 then
		event.MesMake_2(0, "What are you going on about?\nI've no idea...")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "An adventure?\nThat would be nice.<page>What use could an old\nwoman like me be?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11c4c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_34e94(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_347e0(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_34f20(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "What use could an old\ngranny like me be?")
	else
		event.MesMake_2(
			0,
			'When the Blackstone Railroad is\nall done, I\'d just love to \ngo to the "Ends of the Earth".'
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_35168(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_34650(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_34650(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_347e0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_34e94(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_34f20(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_231e4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "Oh, you're\nhelping Polly?<page>Great.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "What'll I do\nwith 20 loaves?<page>Well, I'm having a cheese\nfondue party today.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			'In terms of your famous "inventions",\nit\'s a culinary combination of cheese,<page>bread and wine!'
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"It's mighty good. Everyone eats loads,\nso that's why I need so much bread.<page>But I didn't want it\ndelivered here really."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"Sorry Max, but you couldn't\ntake it to my house could you?<page>You know where it is, don't you?\nNear the pumpkin field."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "You know where it is, don't you?\nNear the pumpkin field.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "Cancelled?!\nWhat a shame!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(0, "In that case, I don't need the bread.\nCan you take it back to Polly for me?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "Sorry, but can you take the\nbread back to Polly for me?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_3544c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_14088(arg0, arg1)
			end
			if at <= 2 then
				helper_18924(arg0, arg1)
			end
			if at <= 3 then
				var7 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_aafd6a80(30)
			end
			return
		end
		if at <= 9 then
			if at <= 8 then
				var8 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 10 then
				helper_aafd6a80(30)
			end
			return
		end
		if at <= 18 then
			if at <= 13 then
				helper_1bd64(arg0, arg1)
			end
			if at <= 14 then
				helper_1d82c(arg0, arg1)
			end
			if at <= 15 then
				helper_20284(arg0, arg1)
			end
			if at <= 16 then
				helper_2298c(arg0, arg1)
			end
			if at <= 17 then
				var11 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 19 then
			return
		end
		if at <= 23 then
			if at <= 20 then
				helper_24f54(arg0, arg1)
			end
			if at <= 21 then
				helper_164ec(arg0, arg1)
			end
			if at <= 22 then
				var14 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 24 then
			return
		end
		if at <= 29 then
			if at <= 25 then
				helper_268a0(arg0, arg1)
			end
			if at <= 26 then
				helper_27f40(arg0, arg1)
			end
			if at <= 27 then
				helper_2b2b4(arg0, arg1)
			end
			if at <= 28 then
				var17 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 30 then
			return
		end
		if at <= 39 then
			if at <= 31 then
				helper_2cec0(arg0, arg1)
			end
			if at <= 32 then
				helper_2e0d4(arg0, arg1)
			end
			if at <= 33 then
				helper_2f6c4(arg0, arg1)
			end
			if at <= 34 then
				helper_30880(arg0, arg1)
			end
			if at <= 35 then
				helper_32478(arg0, arg1)
			end
			if at <= 36 then
				helper_3436c(arg0, arg1)
			end
			if at <= 37 then
				helper_35168(arg0, arg1)
			end
			if at <= 38 then
				var20 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 40 then
			return
		end
		if at <= 41 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
		if at <= 45 then
			helper_30c30f62(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(14) or var3
	event.GetNowMapNo()
	now_sub_map_no = event.GetNowSubmapNo() or now_sub_map_no
	event.CtrlcStay()
	event.SetAi(0, arg0)
	if var3 == 3 then
		helper_14088(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 5 then
		helper_18924(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Let me shop\nDig for a scoop")
			var7 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_c668(0)
				if vm.skipping() then
					return skip(5)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_aafd6a80(30)
					if vm.skipping() then
						return skip(6)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(7)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_f718()
				if vm.skipping() then
					return skip(8)
				end
			end
		else
			event.MesMake_2(0, "Be my friend!\nDig for a scoop")
			var8 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_c668(0)
				if vm.skipping() then
					return skip(10)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_aafd6a80(30)
					if vm.skipping() then
						return skip(11)
					end
					event.GotoMenu(6, 33)
					if vm.wait() then
						return skip(12)
					end
					event.SetFadeIn(30)
				end
				event.SetAi(1, arg0)
				return
			else
				helper_1a43c(arg0, arg1)
				if vm.skipping() then
					return skip(13)
				end
			end
		end
	end
	if var3 == 7 then
		helper_1bd64(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 8 then
		helper_1d82c(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 10 then
		helper_20284(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 11 then
		helper_2298c(arg0, arg1)
		if vm.skipping() then
			return skip(17)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var11 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(18)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_24f54(arg0, arg1)
				if vm.skipping() then
					return skip(19)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_f718()
			if vm.skipping() then
				return skip(20)
			end
		else
			helper_24f54(arg0, arg1)
			if vm.skipping() then
				return skip(21)
			end
		end
	end
	if var3 == 14 then
		helper_164ec(arg0, arg1)
		if vm.skipping() then
			return skip(22)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var14 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(23)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_268a0(arg0, arg1)
				if vm.skipping() then
					return skip(24)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_f718()
			if vm.skipping() then
				return skip(25)
			end
		else
			helper_268a0(arg0, arg1)
			if vm.skipping() then
				return skip(26)
			end
		end
	end
	if var3 == 16 then
		helper_27f40(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 17 then
		helper_2b2b4(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hello\nBe my friend!")
			var17 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(29)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_2cec0(arg0, arg1)
				if vm.skipping() then
					return skip(30)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_f718()
			if vm.skipping() then
				return skip(31)
			end
		else
			helper_2cec0(arg0, arg1)
			if vm.skipping() then
				return skip(32)
			end
		end
	end
	if var3 == 19 then
		helper_2e0d4(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 20 then
		helper_2f6c4(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 21 then
		helper_30880(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 23 then
		helper_32478(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 24 then
		helper_3436c(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 25 then
		helper_35168(arg0, arg1)
		if vm.skipping() then
			return skip(38)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Let me shop\nHello")
			var20 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(39)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_231e4(arg0, arg1)
				if vm.skipping() then
					return skip(40)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_f718()
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Lately I've been having a hard time\nseeing all the tiny little parts.<page>Guess I'm gettin' a bit\nlong in the tooth..."
			)
		else
			event.MesMake_2(
				0,
				"Seeing the Blackstone Railroad\noperate all over the continent is a\ndream both Need and I share.<page>We can count on you to help, right?"
			)
		end
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(42)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "If I don't have my hands in\nsomething at all times,\nI get real cranky.")
		else
			event.MesMake_2(
				0,
				"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
			)
		end
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(43)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"You know, I have a lot of bugs\nin my feathers these days,\nand they make me itch terribly."
			)
		else
			event.MesMake_2(
				0,
				"It's fine if you spend your time\nhunting for Zelmite. Just don't\npush yourself too hard, kid."
			)
		end
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(44)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"I love the smell of gunpowder!\nThis job is really made for me.<page>Then again, my boss is awfully\nstubborn and old-fashioned.\nOh, well."
			)
		else
			event.MesMake_2(0, "You really like all this\nadventure, don't ya.")
		end
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(45)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Apart from the fact that I started\nlife as a picture, I'm no different\nthan any other person."
			)
		else
			event.MesMake_2(0, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
		end
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(46)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_10550()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
				var5 = 2
				var5 = 1
				helper_f718()
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.GetMesEtc(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_f718()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "Hey! No admittance\nbeyond this point.")
		helper_30c30f62(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Take a look at that. Hard to\nbelieve this thing used to zoom\nalong, eh?<page>It really did...a long time ago.<page>It's my dream to set off on another\njourney in this thing. That's why I\nmake sure to keep 'er in top shape.<page>That way, if I ever get"
				)
			else
				event.MesMake_2(
					0,
					"You know how you go to exercise\nevery day or you get all stiff and\nachy? Same thing goes for machines."
				)
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Hey there, Max!\nIt's been ages since the\nrailroad stopped running.<page>But I'm still here patrolling\nthe station, every day."
				)
			else
				event.MesMake_2(
					0,
					"The Mayor finally got off his duff\nand got the trains going again. But\nthey're still not ready for the public.<page>Boy, I really want to let the\ntownspeople on board..."
				)
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Hi, Max. Did you know that the\nStationmaster is my dad? We watch\nover this station together.<page>Until the day the railway is back\nup and running..."
				)
			else
				event.MesMake_2(
					0,
					"The train's running!\nBut it'll take a while before\nthe station's back to normal..."
				)
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetAi(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.GetFlag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"I've been a secret admirer\nof Monica for ages, but I\nain't seen her around lately.<page>That's why I can't seem\nto concentrate on work."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(0, "Hey, Max!\nSeems Monica's back.\nEveryone'll be really pleased!")
				else
					event.MesMake_2(0, "Monica! How've you been?\nI really missed you.")
				end
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"I'd just got to the point where\nI could talk to Monica normally,\nand then she disappeared.<page>Come on Max,\ntell me where she is, will ya?"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica's back.\nHow on earth??")
				else
					event.MesMake_2(0, "Monica, you're back!\nHow on earth??")
				end
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Hello there.\nGreat weather, isn't it.")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_30c30f62(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_11b18()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10550()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_10550()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_37e64()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3544c(var1, player_chara)
		end
		if at <= 2 then
			helper_11b18()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_3544c(var1, player_chara)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_11b18()
		if vm.skipping() then
			return skip(3)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_38444

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_39980()
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_39c20()
		end
	end
	flag = event.GetFlag(103) or flag
	event.SetBitCtrl(1, if flag == 0 then 1 else 0)
	helper_38444()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -112.0, 104.0, -114.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var3 = event.GetMapType(old_map_no) or var3
		if var3 ~= -1 then
			if old_map_no == 15 or var3 == 7 or var3 == 8 then
				helper_39c20()
				if vm.skipping() then
					return skip(1)
				end
			else
				helper_39980()
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_39c20()
			if vm.skipping() then
				return skip(2)
			end
		end
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(4, 1)
	helper_4459c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_382d0()
	event.SetCnt(5, 3)
	helper_3a064()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		event.SetSavedataEtc(3, 1)
	end
	helper_1565f910()
	if vm.skipping() then
		return skip(1)
	end
	if flag == 1 then
		event.SetSavedataEtc(3, 0)
	end
end

--- Program 500.
script[500] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_3856c()
		end
	end
	flag = event.GetFlag(103) or flag
	if flag == 0 then
		event.Initialize()
		event.SetMotion(0, "立ち")
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "Flotsam might still be looking for\nme. I'd better not go back to Palm\nBrinks.")
		helper_c049c42a(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_3856c()
		if vm.skipping() then
			return skip(2)
		end
		if t0 ~= 0 then
			event.MapJump(-1, "m01", 100)
		end
	end
end

--- Program 530.
script[530] = function()
	local flag: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag_2: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_38728()
		end
		if at <= 3 then
			helper_39c20()
		end
		var2 = 0
		var6 = var6 + 1
	end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		helper_39140()
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_38728()
		if vm.skipping() then
			return skip(2)
		end
		if t0 ~= 0 then
			event.DngSetStageId(0)
			event.GotoMenu(3, 0)
			if vm.wait() then
				return skip(3)
			end
			do
				local _, out2, out3, _ = event.GetMenuParam_4()
				var2 = out2 or var2
				var3 = out3 or var3
			end
			if var3 == 0 then
				helper_39c20()
				if vm.skipping() then
					return skip(4)
				end
			else
				flag_2 = event.GetFlag(102) or flag_2
				if var3 == 3 and flag_2 == 0 then
					var2 = 0
					var6 = event.GetFloorInfo(var2, var3, 7) or var6
					var6 = vm.i32(var6 + 1)
					event.SetFloorInfo(var2, var3, 7, var6)
					event.StopBgm(0)
					event.BgmPlayCancel()
					event.GotoEdit(41, 500)
					return
				end
				if var3 == 6 then
					event.BgmLoadCancel()
				end
				event.SetBitCtrl(1, 0)
				event.GotoDng(0, var3, 1010)
			end
		end
	end
end

--- Program 550.
script[550] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e260(386, 1)
		end
		if at <= 2 then
			helper_136a94b8(1)
		end
	end
	event.Initialize()
	event.FuncPointShow("", "memo", 0)
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var0, var1, var2, 10)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(1, "memo")
	event.EohSetShow(1, 0)
	event.AddItem(386)
	helper_e260(386, 1)
	if vm.skipping() then
		return skip(2)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 1000.
script[1000] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_37e64()
		end
	end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		local t0 = helper_4459c()
		if vm.skipping() then
			return skip(1)
		end
		if t0 ~= 0 then
			event.SetFlag(4, 0)
			event.SetSavedataEtc(0, 2)
			event.AddItem(22)
			event.SetCharaEquip(0, 22)
			event.AddItem(359)
			event.SetTimeStepEnable(1)
			event.SoundAllStop()
			event.SndInReverb(0)
			event.GotoDrawChapter(1)
			if vm.wait() then
				return skip(2)
			end
			event.SndInReverb(1)
			event.SetBitCtrl(1, 0)
			event.GotoDng(0, -1, 1000)
			if vm.wait() then
				return skip(3)
			end
		end
	else
		helper_37e64()
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 10070.
script[10070] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_382d0()
			helper_3a064()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_aafd6a80(6)
	if vm.skipping() then
		return skip(1)
	end
	helper_382d0()
	event.SetFlag(4, 1)
	helper_3a064()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
