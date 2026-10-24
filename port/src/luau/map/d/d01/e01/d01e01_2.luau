--!strict
-- map/d/d01/e01/d01e01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
local function helper_39bd0()
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
local function helper_39ec0()
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
local function helper_3a034()
	local flag: s32 = 0
	event.SetFlag(40, 1)
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		helper_39bd0()
	end
	helper_39ec0()
end

--- Helper function.
local function helper_3b830()
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
local function helper_3b590()
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
local function helper_e2f0(arg0: s32, arg1: s32)
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
local function helper_3edc4()
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
				helper_e2f0(22, 1)
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
				helper_e2f0(359, 1)
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
	helper_e2f0(22, 1)
	if vm.skipping() then
		return skip(67)
	end
	helper_c9057fa5(0, 4)
	event.MesMake_2(
		0,
		"[(!)] Utilise [l1] pour te pr[UNI00e9]parer, (O)\n    pour attaquer. Si tu te mets trop loin,\n    tes attaques seront moins efficaces."
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
	helper_e2f0(359, 1)
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
local function helper_461bc()
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
				helper_3edc4()
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
	event.MesMake_2(0, "Alors que vas-tu faire ?")
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
	event.MesMake_2(0, "Je vais rester cach[UNI00e9] un peu ici.\nLe Canal souterrain...")
	var12 = helper_3000b46a(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_c9057fa5(0, 7)
	event.SetMesShippo(0, 1)
	if var12 == 1 then
		event.StreamClose(1)
		helper_3edc4()
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
		event.MesMake_2(0, "Je vais rester cach[UNI00e9] un peu ici.")
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
		event.MesMake_2(0, "Restes-y tant que tu veux.")
		helper_403f0e66(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.StreamClose(1)
	end
	return part2()
end

--- Helper function.
local function helper_3bc74()
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
				helper_39bd0()
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
			"[(!)]Parle [UNI00e0] Donny pour continuer.\n   Avant, tu peux sauvegarder ta partie\n   [UNI00e0] un point de sauvegarde."
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
	helper_39bd0()
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
local function helper_d2c8(arg0: s32, arg1: s32)
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
local function helper_3a15c()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			var0 = helper_d2c8(5, 10)
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
	var0 = helper_d2c8(5, 10)
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
local function helper_3ad30()
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
	event.MesMake_2(0, "Je me demande o[UNI00f9] va ce canal ?\nJe vais le demander [UNI00e0] Donny.")
	helper_c049c42a(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3a318()
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
				var0 = helper_d2c8(5, 55)
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
	var0 = helper_d2c8(5, 55)
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
local function helper_12360(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max ! Tu m'as fait peur.\nJ'[UNI00e9]tais en train de traiter\ncet arbre contre les insectes.<page>Certains arbres poussent mal, tu\nsais. Il y en a, comme lui, qui\nont vraiment besoin de soins."
		)
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_1200c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "Humm, cet arbre... Il ne va pas\nbien. Je dois faire quelque chose.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Apparemment il faut parler [UNI00e0]\n   Gordon pour attirer son attention.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_126b8(arg0: s32, arg1: s32)
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
		helper_1200c(arg0, arg1)
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
		"Oh, Max ! Tu as l'air de tra[UNI00ee]ner\npas mal en ce moment. Tu te\nportes bien ?<page>Je peux faire quelque chose ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ah bon ! Tu veux que je\nt'accompagne dans tes aventures ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Mmm... J'aimerais bien venir avec\ntoi... Mais ce pauvre arbre ne va\npas tr[UNI00e8]s bien.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Soigner les arbres et les fleurs\nde cette propri[UNI00e9]t[UNI00e9] est ma grande\npriorit[UNI00e9], tu sais.<page>Si je pars me balader maintenant,\nje pourrais perdre mon travail."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Je parie que l'eau sacr[UNI00e9]e vendue [UNI00e0]\nl'[UNI00e9]glise soignerait cet arbre !<page>Mais, comme tu le sais, ton p[UNI00e8]re et\nP[UNI00e8]re Bruno ne s'entendent pas...<page>Ton p[UNI00e8]re ne me donnera jamais de\nsous pour acheter de l'eau sacr[UNI00e9]e !<page>J'ai un vrai probl[UNI00e8]me l[UNI00e0]."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Pour que Gordon aille [UNI00e0] Sindain,\n   tu dois le convaincre de venir\n   avec toi.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]R[UNI00e9]alise la mission de Gordon\n   et il montera dans le train pour\n   t'accompagner."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Tu peux consulter tes missions\n   en lisant ton carnet de notes,\n   situ[UNI00e9] dans le menu Objets."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)]Oh, tu n'as pas de carnet.\n   Il y en a un sur la table\n   chez C[UNI00e9]dric, le r[UNI00e9]parateur."
		)
		helper_c049c42a(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]Il y en a un autre dans la\n   base secr[UNI00e8]te de Donny. Ils se valent.\n   R[UNI00e9]cup[UNI00e8]re l'un d'eux !"
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
local function helper_13468(arg0: s32, arg1: s32)
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
		helper_1200c(arg0, arg1)
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
		"Max, soigner cet arbre est ma\ngrande priorit[UNI00e9].<page>Mais pour cela, il me\nfaudrait..."
	)
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
		event.MesMake_2(
			0,
			"Max, [UNI00e7]a ne marchera pas.<page>Ce qu'il me faut, c'est de l'Eau\nsacr[UNI00e9]e du P[UNI00e8]re Bruno."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ouais ! Max tu as r[UNI00e9]ussi ! Je vais\npouvoir soigner cet arbre !<page>Merci, Max.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"J'ai fait tout ce que je devais\nfaire pour un bon moment.<page>Je peux donc t'accompagner dans\nton aventure !<page>Oh, et ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon s'est joint [UNI00e0] ton aventure.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tu peux utiliser ses talents\n   [UNI00e0] partir de la commande Statut, dans\n   Personnages (Menu principal).<page>[(!)]Si tu recrutes une autre\n   personne pour tes aventures,\n   celle-ci montera dans le train."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Parle [UNI00e0] cette personne dans le\n   train pour en faire le 3e\n   membre de ton groupe.<page>[(!)]Pour d[UNI00e9]placer un ami du train\n   vers une maison, choisis Installer\n   quelqu'un (menu de la porte)."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]Il est possible que d'autres personnes\n   souhaitent participer [UNI00e0] l'aventure.\n   Surtout, ne les manque pas !"
	)
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
local function helper_141b8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, bonjour jeune dame.\nQue puis-je faire pour vous ?")
		else
			event.MesMake_2(
				0,
				"Max, ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
			)
		end
	else
		event.MesMake_2(0, "Il doit y avoir tant de plantes\nqu'on ne conna[UNI00ee]t pas encore.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_144f8(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_12360(arg0, arg1)
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
		helper_12360(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_126b8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_13468(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_141b8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_17090(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "H[UNI00e9], Max.<page>Comment tu fais pour toujours\navoir l'air en forme ?!")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1749c(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Salut.\nC'est Monica, c'est [UNI00e7]a ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Moi, c'est Parn.\nJe suis artiste magique.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
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
			"[(!)]Monica n'aime pas trop ce genre de \n   situation. Elle n'est pas s[UNI00fb]re d'arriver\n   [UNI00e0] ses fins. Essaie plut[UNI00f4]t avec Max."
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
	event.MesMake_2(0, "H[UNI00e9] Max.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Je n'ai pas fait les pr[UNI00e9]sentations.<page>Voici Julia, ma future [UNI00e9]pouse.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "...")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Ouais, [UNI00e7]a te fait rire, hein ?\nJe sais que c'est bizarre !<page>Qui irait tomber amoureux d'une\nfille en gouache ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"Mais je suis un artiste magique. Je\npeux donner l'existence [UNI00e0] ce que je<page>dessine. L'existence, mais pas la\nvie, c'est vrai..."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "Personne ne peut dessiner la vie.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "Mais j'ai entendu parler d'un [UNI0153]uf\ndor[UNI00e9] dans un grand arbre ancien.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Il para[UNI00ee]t qu'avec sa couleur dor[UNI00e9]e,\non peut donner vie aux dessins.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"Max, tu quittes la ville, non ?\nTu crois que tu pourrais m'avoir<page>de la peinture dor[UNI00e9]e ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Je te le revaudrai bien entendu.<page>Si tu m'aides, j'utiliserai mes\nnouveaux pouvoirs pour t'assister."
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
		"[(!)]Un vieil arbre, immense...\n   Avec un [UNI0153]uf dor[UNI00e9] ! Mais o[UNI00f9] trouver\n   un arbre comme celui-ci ?!"
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
local function helper_d51c(arg0: s32)
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
local function helper_11f2c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d51c(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_d51c(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_18604(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
		if at <= 8 then
			helper_d51c(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Je t'attendais. Vite, donne-moi<page>la peinture, que je puisse enfin\ndonner vie [UNI00e0] mon portrait."
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
		event.MesMake_2(
			0,
			"C'est une blague !?<page>Ce qu'il me faut, c'est de la\npeinture dor[UNI00e9]e. Et rien d'autre !"
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "Ah, la fameuse peinture dor[UNI00e9]e...\nJe vais l'essayer imm[UNI00e9]diatement.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "E-elle... Elle est r[UNI00e9]elle...<page>[UNI00c9]tonnant, elle est parfaite !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Merci, Max. Je n'ai pas oubli[UNI00e9] ma\npromesse. Tu pourras utiliser mes\nnouveaux pouvoirs quand tu veux."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_d51c(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_18e2c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "N'h[UNI00e9]site pas [UNI00e0] utiliser mes\nnouveaux pouvoirs quand tu le\nvoudras.")
	else
		event.MesMake_2(
			0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_190b4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_17090(arg0, arg1)
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
		helper_17090(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_1749c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_18604(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_18e2c(arg0, arg1)
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
		event.MesMake_2(arg0, "Ram[UNI00e8]ne-moi plus de scoops ou je ne\npourrai rien te donner !")
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
			"Ton niveau de photographie est\nd[UNI00e9]termin[UNI00e9] par le nombre d'id[UNI00e9]es et\nde scoops que tu as.<page>[UNI00c0] mesure que ton niveau s'am[UNI00e9]liore,\ntu gagnes des trucs supers."
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
local function helper_c6a8(arg0: s32)
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
		event.MesMake_2(arg0, "Va me chercher un\nM[UNI00e9]mo de scoops, tu veux bien ?")
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
		event.MesMake_2(arg0, "On dirait qu'il n'y\na plus de scoops.")
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
		event.MesMake_2(arg0, "J'ai trouv[UNI00e9] [Number1] nouveau(x) scoop(s).")
		event.SetMesDrawspeed(arg0, 0)
		helper_c049c42a(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_c9057fa5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(arg0, "Allez ! Arr[UNI00ea]te de lambiner !\nIls sont o[UNI00f9] tes super scoops ?")
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Ouah ! Tu as [Number1] nouveau(x)\nscoop(s) ! Je savais que tu y\narriverais.")
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
local function helper_f6a4(arg0: s32)
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
local function helper_f7a8()
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
			helper_f6a4(15)
		end
		if at <= 3 then
			helper_f6a4(1)
		end
		if at <= 4 then
			helper_f6a4(6)
		end
		if at <= 5 then
			helper_f6a4(0)
		end
		if at <= 6 then
			helper_f6a4(4)
		end
		if at <= 7 then
			helper_f6a4(31)
		end
		if at <= 8 then
			helper_f6a4(35)
		end
		if at <= 9 then
			helper_f6a4(36)
		end
		if at <= 10 then
			helper_f6a4(37)
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
	event.MesMake_2(0, "Bienvenue.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"[UNI00c7]a travaille dur, je vois ?\nIl te faut quelque chose ?<page>Ah mais, rien n'est gratuit.\nPas m[UNI00ea]me pour toi, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"Il te faut plus d'[UNI00e9]l[UNI00e9]ments de\nG[UNI00e9]orama ?<page>Si tu n'as pas le temps d'aller en\nchercher toi-m[UNI00ea]me, peut-[UNI00ea]tre que\nl'argent r[UNI00e9]soudra tes probl[UNI00e8]mes."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Bonjour, je suis apprentie boulang[UNI00e8]re\net je m'occupe de la boulangerie\npendant l'absence de Polly.<page>Je suis un peu nerveuse, mais [UNI00e7]a\npassera avec l'exp[UNI00e9]rience, je\nsuppose. Je ferai de mon mieux !"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"On se ressemble peu mais...\nJe suis la petite s[UNI0153]ur de Milane.<page>Je tiens le magasin pendant son absence.\nEt je suis archi-nulle en armes !"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Tu ne t'y attendais pas ? N'importe\nqui serait surpris de voir ici un\nindividu habill[UNI00e9] de cette mani[UNI00e8]re.<page>Je suis bon ami avec le P[UNI00e8]re Bruno.\nJe le remplace pendant son voyage.\nAlors, que puis-je faire pour toi ?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
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
		helper_f6a4(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_f6a4(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_f6a4(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_f6a4(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_f6a4(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_f6a4(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_f6a4(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_f6a4(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_f6a4(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_19548(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Le magasin est ferm[UNI00e9]. Tu dois donc\naller au magasin de mon p[UNI00e8]re. Cherche<page>les citrouilles, tu ne peux pas les\nrater. C'est en haut de la colline."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_19398(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Depuis ton arriv[UNI00e9]e, j'ai\n[UNI00e0] peine vu Max. Je ne sais pas\n[UNI00e0] quoi tu t'amuses, mais j'esp[UNI00e8]re<page>que tu ne te sers pas de lui."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_19708(arg0: s32, arg1: s32)
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
		helper_19398(arg0, arg1)
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
		"Tu devrais conna[UNI00ee]tre ma r[UNI00e9]ponse [UNI00e0]\n[UNI00e7]a : PAS QUESTION !<page>C'est pas mon genre de travailler\npour le compte des autres !"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "[UNI00c7]a ne m'apporte pas grand-chose et\nen plus, c'est trop dangereux.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Mais puisque c'est toi, je pense\nque je vais y r[UNI00e9]fl[UNI00e9]chir.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Mais bon, je suis fils de\ncommer[UNI00e7]ant et chez nous, rien\nn'est gratuit.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Je collectionne les pi[UNI00e8]ces de<page>monnaie, le symbole du commerce. Et\nje r[UNI00ea]ve de compl[UNI00e9]ter ma collection."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Mais je n'arrive pas [UNI00e0] mettre la\nmain sur la Pi[UNI00e8]ce de sacrifice et\nla Pi[UNI00e8]ce de Solidit[UNI00e9].<page>Si tu les trouves pour moi, je\nt'aiderai peut-[UNI00ea]tre [UNI00e0] mon tour."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_19efc(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_19398(arg0, arg1)
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
			"Quoi ? Ah, les pi[UNI00e8]ces de monnaie ?<page>Je cherche la Pi[UNI00e8]ce de sacrifice\net la Pi[UNI00e8]ce de solidit[UNI00e9].<page>Tu ne les trouveras jamais, j'ai\nd[UNI00e9]j[UNI00e0] cherch[UNI00e9] partout."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Quoi ? Tu les as ? Incroyable !<page>Allez vite, donne-les-moi !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Bon.\nQu'est-ce que je dois faire ?")
	var5 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Aaah ! Si tu me casses les pieds,\nje ne t'aiderai certainement pas.")
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
		"Ouaah, je les ai toutes !\nJe n'y croyais plus...<page>Bon, je n'ai plus le choix hein ?\nJe vais venir avec toi !"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_1a98c(arg0: s32, arg1: s32)
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
			helper_19398(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"Je n'y crois pas. Je n'ai jamais\nvraiment cru que tu les trouverais.<page>T'as fait tr[UNI00e8]s fort Max !"
		)
	else
		event.MesMake_2(
			0,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1accc(arg0: s32, arg1: s32)
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
		helper_19548(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_19708(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_19efc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_1a98c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_1afb0(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Bonjour. Quels types de plats\naimes-tu, Monica ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"Oui, j'aime les plats classiques,\nmais je m'int[UNI00e9]resse aussi aux\nsaveurs plus... inhabituelles."
		)
	else
		event.MesMake_2(
			0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1b398(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Alors, tu as fait des trouvailles ?<page>Tu sais, pendant que tu d[UNI00e9]couvres\nles rouages des machines,\nmoi, je d[UNI00e9]couvre la cuisine.<page>Chaque jour, je me perfectionne\ndans l'art de faire des plats\nd[UNI00e9]licieux et totalement in[UNI00e9]dits."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1b5b8(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Ah, tu arrives bien !\nJe voulais te parler de quelque\nchose.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Tu sais s[UNI00fb]rement que je cherche\ntoujours [UNI00e0] d[UNI00e9]couvrir de nouvelles\np[UNI00e2]tisseries venues du monde entier.\n"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "On m'a parl[UNI00e9] d'un g[UNI00e2]teau appel[UNI00e9]\ncastagnaccio...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Confectionn[UNI00e9] [UNI00e0] base de castarnas.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"J'ai appris que ces castarnas\npoussaient sur des arbres de la\nfamille des ch[UNI00e2]taigniers."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Alors j'ai pens[UNI00e9] essayer la recette\navec des marrons, mais bizarrement,\nil n'y a plus un marron en ville."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Il para[UNI00ee]t que le Maire les a tous\nachet[UNI00e9]s... Tu ne pourrais pas\nm'aider ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_1bd64(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Tu as trouv[UNI00e9] des marrons ?")
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
		event.MesMake_2(
			0,
			"Alors, tu ne peux pas m'aider...<page>Tant pis, je ne ferai pas\nde castagnaccio, voil[UNI00e0] tout."
		)
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
		"Oui, c'est [UNI00e7]a ! Merci beaucoup ! Je<page>vais pouvoir faire un castagnaccio.<page>Je te ferai go[UNI00fb]ter si tu veux."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Comment te remercier... ?<page>Quoi, te suivre dans une aventure ?<page>Ha ha ! Mais bien s[UNI00fb]r...<page>Il fallait le dire tout de suite."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1c42c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Moi, je ne pourrais jamais\nrien te refuser.")
	else
		event.MesMake_2(
			0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1c684(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1afb0(arg0, arg1)
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
		helper_1afb0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1b398(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1b5b8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1bd64(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1c42c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1ca10(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Salut ! Tu es la copine de\nMax ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Tes cheveux ont une couleur tr[UNI00e8]s\noriginale. Je les trouve<page>magnifiques, ils brillent\ncomme des bijoux."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1cce0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1ca10(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1ca10(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Tu as quitt[UNI00e9] la ville r[UNI00e9]cemment,\nnon, Max ?<page>Ne dis pas le contraire.\nJe le sais."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1cf08(arg0: s32, arg1: s32)
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
		helper_1ca10(arg0, arg1)
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
		"J'aimerais bien t'aider, mais j'ai\ntr[UNI00e8]s peur de me battre et je\nrisquerais de me salir."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Et j'ai horreur d'[UNI00ea]tre un poids\npour les autres. D[UNI00e9]sol[UNI00e9]e, mais...\nje vais devoir dire non."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Il y a plein de trucs bizarres\nhors de la ville, je parie !<page>Je me demande comment sont les\narbres, et quelles fleurs il y a."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Si tu vois une fleur [UNI00e9]trange, tu\npeux la prendre en photo pour moi\nMax ? J'aimerais tant en voir une."
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
		"[(!)]Elle a dit non cette fois-ci, mais\n   si tu lui montres une photo qui\n   l'int[UNI00e9]resse, elle capitulera s[UNI00fb]rement."
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
local function helper_1d6ac(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1ca10(arg0, arg1)
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
			"As-tu photographi[UNI00e9] une fleur ?<page>J'en connais plein alors elle devra\n[UNI00ea]tre tr[UNI00e8]s sp[UNI00e9]ciale pour m'int[UNI00e9]resser."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "As-tu photographi[UNI00e9] une fleur\ninhabituelle ?\nMontre-moi, montre-moi vite !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Ouaah ! [UNI00c9]tonnant ! Voici donc le\ngenre de fleur qu'on trouve [UNI00e0]\nl'ext[UNI00e9]rieur."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Humm... Que dois-je faire ?<page>Bon d'accord ! Emm[UNI00e8]ne-moi avec toi !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1df3c(arg0: s32, arg1: s32)
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
			helper_1ca10(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "[UNI00c9]vite les endroits\ntrop dangereux.")
	else
		event.MesMake_2(
			0,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1e22c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1cce0(arg0, arg1)
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
		helper_1cce0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1cf08(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1d6ac(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1df3c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1e510(arg0: s32, arg1: any)
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
			"Je suis peut-[UNI00ea]tre le seul [UNI00e0] le\npenser, quelque chose en toi me<page>rappelle H[UNI00e9]l[UNI00e8]ne. Un je-ne-sais-\nquoi qui te distingue des autres."
		)
	else
		event.MesMake_2(0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1e7c8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Quel que soit ton probl[UNI00e8]me,\nn'h[UNI00e9]site pas [UNI00e0] venir me voir\nen premier.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1e938(arg0: s32, arg1: s32)
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
	event.MesMake_2(
		0,
		"Je ferai de mon mieux pour t'aider\nsi tu as besoin de quoi que ce<page>soit. Pas de probl[UNI00e8]me."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Je ne sais pas si tu peux<page>m'aider... Mais [UNI00e9]coute bien [UNI00e7]a.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Je travaille dur depuis pr[UNI00e8]s de 30\nans dans cette maison.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Je consacre tout mon temps libre\n[UNI00e0] mon seul et unique passe-temps,\nla lecture.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Un livre extr[UNI00ea]mement rare et\npr[UNI00e9]cieux est [UNI00e0] vendre aux ench[UNI00e8]res\nen ce moment."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Tout le monde se bat pour l'avoir.\nJe pense qu'une somme d'environ\n1000 Gildas devrait suffire."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Mais je n'ai pas une telle somme,\net mon ma[UNI00ee]tre serait outr[UNI00e9] si je\nlui demandais de me la pr[UNI00ea]ter."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Alors tu es mon seul espoir.<page>[UNI00c7]a ne veut pas dire que si tu ne\npeux pas m'aider, je ne ferai rien pour toi."
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
		"[(!)]Malgr[UNI00e9] ses dires, Stewart ne t'aidera\n   s[UNI00fb]rement pas, sauf pour 1000 Gildas.\n   Bref, il va falloir trouver de l'argent."
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
local function helper_1f464(arg0: s32, arg1: s32)
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
			helper_11f2c()
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
				"[UNI00c7]a n'est pas assez pour que je\npuisse remporter les ench[UNI00e8]res.<page>Il me faut 1000 Gildas. Je t'en\nprie, trouve-les !"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(
				0,
				"Tu ne vas pas le croire !<page>L'ench[UNI00e8]re est mont[UNI00e9]e [UNI00e0]\n1200 Gildas."
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(
				0,
				"Je suis vraiment d[UNI00e9]sol[UNI00e9], mais tu\nne pourrais pas te procurer\n1500 Gildas ?"
			)
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
				"Il faut faire vite, sinon il va\n[UNI00ea]tre vendu [UNI00e0] quelqu'un d'autre.<page>Vite, trouve-moi 1500 Gildas !"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"C'est terrible ! Quelqu'un est\npr[UNI00ea]t [UNI00e0] payer 1800 Gildas !<page>Si je ne surench[UNI00e9]ris pas avec 2000\nGildas, je n'aurai pas le livre."
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
				"Il faut faire vite, sinon il va\n[UNI00ea]tre vendu [UNI00e0] quelqu'un d'autre.<page>Vite, trouve-moi 2000 Gildas !"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Fiston, tu as r[UNI00e9]ussi [UNI00e0] rassembler\nmes 2000 Gildas ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(
			0,
			"Ben oui. Ils sont [UNI00e0] toi.\nM[UNI00ea]me si j'ai l'impression que\nc'est du g[UNI00e2]chis."
		)
		var4 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"Mmm... 2000 Gildas, c'est beaucoup.\n[UNI00c7]a doit [UNI00ea]tre dur de s'en s[UNI00e9]parer.\nM[UNI00ea]me pour un gar[UNI00e7]on ais[UNI00e9] comme toi.<page>Tr[UNI00e8]s bien, tant pis ! Mais l'ench[UNI00e8]re\nn'est pas encore termin[UNI00e9]e.\nJ'attendrai le temps qu'il faudra."
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Merci de tout c[UNI0153]ur.<page>Je file aux ench[UNI00e8]res !")
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
	event.MesMake_2(0, "Merci de tout c[UNI0153]ur.\nMa surench[UNI00e8]re a r[UNI00e9]ussi.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"Les autres acheteurs potentiels ont\nvite abandonn[UNI00e9] et j'ai eu le livre\npour 1400 Gildas !"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Je peux donc t'en rendre 600.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(
		0,
		"Et maintenant, je vais travailler\ndur pour rembourser le reste de\nla somme que je t'ai emprunt[UNI00e9]e."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Je sais que tu t'es d[UNI00e9]men[UNI00e9] pour\nmoi. Je te rendrai la pareille\nquand tu voudras."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_20bec(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Le livre que j'ai achet[UNI00e9] ?\nEn fait, je ne l'ai pas encore lu.<page>Le poss[UNI00e9]der suffit [UNI00e0] mon\nbonheur."
		)
	else
		event.MesMake_2(0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_20e74(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1e510(arg0, arg1)
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
		helper_1e510(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1e7c8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1e938(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1f464(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_20bec(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_21200(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Je t'en prie, arr[UNI00ea]te de mettre Max\ndans des situations dangereuses.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "S'il a ne serait-ce qu'une\n[UNI00e9]gratignure, jamais je ne te\nle pardonnerai !")
	else
		event.MesMake_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_215a8(arg0: s32, arg1: s32)
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
		"Je travaille ici comme\ngouvernante, mais je r[UNI00ea]ve depuis\nl'enfance de devenir couturi[UNI00e8]re."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Mais les r[UNI00ea]ves ne se r[UNI00e9]alisent\npas, c'est pourquoi ils restent\ndes r[UNI00ea]ves."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_218a8(arg0: s32, arg1: s32)
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
		"Je vois... J'aimerais vraiment\npouvoir t'aider.\nTu le sais.<page>Mais je n'ai vraiment pas\nassez confiance en moi."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"J'abandonne toujours tout [UNI00e0] mi-\nchemin, je n'ai jamais rien fini.<page>J'ai toujours voulu devenir\ncouturi[UNI00e8]re, mais je n'ai jamais\ntermin[UNI00e9] un seul v[UNI00ea]tement."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si je venais avec toi,\nje ne ferais que t'emb[UNI00ea]ter.<page>Alors, d[UNI00e9]sol[UNI00e9]e, mais c'est non."
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
		"[(!)]Oh non, Ad[UNI00e8]le a perdu toute\n   confiance en elle. C'est un probl[UNI00e8]me.\n   Faisons-lui faire de nouveaux habits."
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
local function helper_21ef4(arg0: s32, arg1: s32)
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
		"Oui, si j'essaie [UNI00e0] nouveau et je\ntermine quelque chose, peut-[UNI00ea]tre\nretrouverai-je confiance en moi."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Mais j'ai pas les mat[UNI00e9]riaux<page>n[UNI00e9]cessaires. Pourrais-tu te les\nprocurer pour moi ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Il me faut du tissu r[UNI00e9]sistant,\ndu cuir [UNI00e9]pais et un morceau\nde cuivre.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_22324(arg0: s32, arg1: s32)
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
			"Sans mat[UNI00e9]riaux, je ne\npeux rien faire. Il me faut du<page>tissu r[UNI00e9]sistant, du cuir [UNI00e9]pais\net un morceau de cuivre.<page>Je suis d[UNI00e9]sol[UNI00e9]e de te cr[UNI00e9]er\ntant de soucis."
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
	event.MesMake_2(0, "Tiens, prends [UNI00e7]a !\n[UNI00c7]a sera perdu autrement.")
	var5 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Sans mat[UNI00e9]riaux,\nje ne peux rien faire.")
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
	event.MesMake_2(
		0,
		"Merci ! Maintenant, je vais\nessayer de coudre des v[UNI00ea]tements !<page>Rien de tout cela ne sera jet[UNI00e9]."
	)
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
local function helper_22d98(arg0: s32, arg1: s32)
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
			helper_e2f0(var2, 1)
		end
		if at <= 6 then
			helper_136a94b8(1)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_11f2c()
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
	event.MesMake_2(0, "Ah, Max ! J'ai enfin fini un\nv[UNI00ea]tement !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Je ne voulais pas que tes mat[UNI00e9]riaux\nsoient jet[UNI00e9]s, et c'est [UNI00e7]a qui\nm'a oblig[UNI00e9]e [UNI00e0] le terminer."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Je ne suis pas tr[UNI00e8]s satisfaite\nde cette tenue, mais... voudrais-tu\nla porter ?")
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
	helper_e2f0(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ah, c'est vraiment super d'avoir\nenfin pu terminer quelque chose.<page>Je me sens beaucoup plus s[UNI00fb]re\nde moi, maintenant.<page>Je ferai de mon mieux, je\nt'en prie, emm[UNI00e8]ne-moi avec toi."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_23514(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Qu'est-ce que [UNI00e7]a donne ?<page>Sois honn[UNI00ea]te avec moi !")
	else
		event.MesMake_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2374c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_21200(arg0, arg1)
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
				helper_22324(arg0, arg1)
			end
			if at <= 6 then
				helper_22d98(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_21200(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_215a8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_218a8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_21ef4(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_22324(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_22d98(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_23514(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_24a94(arg0: s32, arg1: s32)
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
			"C'est toi la fille qui tra[UNI00ee]ne\navec Max depuis quelque temps.<page>Je sais reconna[UNI00ee]tre une personne de\nvaleur quand j'en rencontre une."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Si j'[UNI00e9]tais un peu plus jeune, je\nne le laisserais pas partir.")
	else
		event.MesMake_2(0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_24e9c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"En affaires, il est essentiel de\ngagner la confiance de tes clients.<page>C'est quelque chose qu'il ne faut\njamais consid[UNI00e9]rer comme acquis."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2504c(arg0: s32, arg1: s32)
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
			helper_e2f0(300, 20)
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
		"Tu veux que je\nvienne avec toi ?<page>Je ne suis qu'une femme qui fait\ndu pain, mais si je peux t'aider,\nje le ferai avec plaisir."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, mais d'abord, j'ai quelque chose\n[UNI00e0] faire livrer [UNI00e0] Morton.<page>[UNI00c7]a t'emb[UNI00ea]terait d'emporter pour moi\n20 pains [UNI00e0] son magasin ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Pendant ce temps-l[UNI00e0], je vais\nfaire mes bagages pour le voyage.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_e2f0(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Je me demande ce qu'il peut bien\nvouloir faire avec 20 pains ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_2564c(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"D[UNI00e9]sol[UNI00e9]e, je ne suis\ntoujours pas pr[UNI00ea]te.<page>Tu peux me laisser\nun peu plus de temps ?"
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Mais au fait, tu es all[UNI00e9]\nchez Morton faire ma livraison ?")
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
		"Quoi ? Ce n'est vraiment\npas correct de sa part !<page>Bon, tr[UNI00e8]s bien,\ntu n'as qu'[UNI00e0] les garder."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Peu importe,\nallons-y.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_11f2c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_25c8c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Allez Max,\non y va.<page>Alors, o[UNI00f9] est-ce\nqu'on va ?")
	else
		event.MesMake_2(0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_25ec4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_24a94(arg0, arg1)
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
		helper_24a94(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_24e9c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_2504c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2564c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_25c8c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_147c4(arg0: s32, arg1: any)
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
			"Je n'aime pas trop voir les femmes\nmanier des [UNI00e9]p[UNI00e9]es. Pour moi, une<page>femme doit [UNI00ea]tre plus f[UNI00e9]minine.\nComme Ad[UNI00e8]le, par exemple."
		)
	else
		event.MesMake_2(0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_14a7c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Cette ville est tr[UNI00e8]s calme, du coup\nje n'ai pas de travail du tout.<page>[UNI00c9]videmment, je sais que c'est une\nbonne chose, mais quand m[UNI00ea]me..."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14c3c(arg0: s32, arg1: s32)
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
		"Salut, Max.\nExcuse-moi, mais je suis\nun peu pris pour l'instant.<page>Je suis en train de r[UNI00e9]cup[UNI00e9]rer des\nmat[UNI00e9]riaux importants qui aideront [UNI00e0]\npr[UNI00e9]server la s[UNI00e9]curit[UNI00e9] de la ville."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Si [UNI00e7]a n'est pas urgent,\n[UNI00e7]a peut attendre jusqu'[UNI00e0] demain ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_14fac(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Oui, je vais essayer.\nJe n'en suis pas capable.")
	var2 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(0, "OK...<page>OK, si tu veux r[UNI00e9]essayer plus tard,\nfais-le moi savoir. Je serai ici.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "[UNI00c0] vos marques, pr[UNI00ea]t,\npartez !")
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
local function helper_15560(arg0: s32, arg1: s32)
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
			helper_14fac(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "H[UNI00e9] Max, tu es venu me chercher ?<page>Je t'attendais.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Gr[UNI00e2]ce aux remparts, cette ville\nest bien prot[UNI00e9]g[UNI00e9]e. Nous devrions<page>maintenant en sortir."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"C'est bien de passer son temps\n[UNI00e0] bricoler comme tu le fais,\nmais fais-tu assez d'exercice ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Au combat, tout est dans la\nrapidit[UNI00e9] et le jeu de jambes.<page>Si tu es plus lent que moi, c'est\nm[UNI00ea]me pas la peine d'insister."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Tiens, on va voir ! Cours jusqu'au\nbateau sur le lac et reviens. Mon<page>record est de 2 minutes 1 seconde.\nSi tu es plus lent que [UNI00e7]a,\npas la peine d'insister."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "Alors, tu veux essayer ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_14fac(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_15c64(arg0: s32, arg1: s32)
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
				helper_14fac(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_14fac(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_14fac(arg0, arg1)
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
				helper_14fac(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_11f2c()
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
		event.MesMake_2(0, "Tiens salut Max.\nTu es venu r[UNI00e9]essayer ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_14fac(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(
			0,
			"H[UNI00e9] ! Tu n'es pas all[UNI00e9] jusqu'au\nbateau, hein ? Tu as essay[UNI00e9] de\nm'avoir. Ne triche pas !"
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_14fac(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "H[UNI00e9], on ne triche pas !")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_14fac(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "Oh, te voil[UNI00e0] de retour !\nBon,<page>regardons tes\ntemps !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(
			0,
			"Oh la la !\n[数値１] minutes [数値２].[数値３] secondes,\nc'est beaucoup trop lent."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(0, "Tu veux r[UNI00e9]essayer ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_14fac(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(0, "Oh !\n[数値１] minutes [数値２] secondes [数値３]\nc'est pas mauvais, [UNI00e7]a !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Tu es bien plus rapide que tu\nen as l'air. Bon, allons affronter\nl'ennemi ensemble !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_168f4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Tu es bien plus rapide\nque tu en as l'air.\nTu m'as surpris !")
	else
		event.MesMake_2(0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_16b4c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_147c4(arg0, arg1)
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
		helper_147c4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_14a7c(arg0, arg1)
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
		helper_14c3c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_15560(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_15c64(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_168f4(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_26250(arg0: s32, arg1: any)
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
			"Alors tu m'as vue au cirque ?\nC'[UNI00e9]tait pas mal, non ?<page>Mais ce n'est pas vraiment un\nboulot, plut[UNI00f4]t un passe-temps."
		)
	else
		event.MesMake_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_264d8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mon magasin est sp[UNI00e9]cialis[UNI00e9] en\narmes blanches.<page>J'ai quelques armes [UNI00e0] feu,\nmais [UNI00e7]a n'est pas\nvraiment mon truc."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_26688(arg0: s32, arg1: s32)
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
			helper_e2f0(44, 1)
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
	event.MesMake_2(
		0,
		"Tu es Monica,\nc'est [UNI00e7]a ?<page>J'ai entendu dire que tu te\nd[UNI00e9]brouillais plut[UNI00f4]t bien [UNI00e0] l'[UNI00e9]p[UNI00e9]e."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Mais les [UNI00e9]p[UNI00e9]es ne sont\npas des jouets, tu sais.<page>Il faut faire preuve de jugeote\nface [UNI00e0] l'ennemi."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] faire [UNI00e9]voluer\nune [UNI00e9]p[UNI00e9]e de 2 niveaux, tu\nm'auras convaincue de ton talent."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Pourquoi ne pas commencer\navec ce Gladius ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_e2f0(44, 1)
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
		"[(!)]Pour que Milane t'aide, il va\n   falloir faire [UNI00e9]voluer le\n   Gladius de 2 niveaux."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Tu peux aussi acheter ou r[UNI00e9]cup[UNI00e9]rer des\n   armes. Il te suffit de te procurer une\n   arme puissante et Milane t'aidera."
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
local function helper_26eec(arg0: s32, arg1: s32)
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
			helper_11f2c()
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
			"Qu'est-ce que c'est que [UNI00e7]a ?\nAlors c'[UNI00e9]tait juste du pipeau ?<page>Sors d'ici !\nTu g[UNI00ea]nes [UNI00e0] tra[UNI00ee]ner dans le coin."
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
		"Ouaah, c'est une [UNI00e9]p[UNI00e9]e\nplut[UNI00f4]t impressionnante.<page>Je m'excuse, mais\nje devais te tester."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Car tu sais, se battre avec un\namateur, c'est dangereux pour moi\naussi.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Mais j'ai l'impression que je n'ai\npas [UNI00e0] m'inqui[UNI00e9]ter de [UNI00e7]a avec toi.<page>Tr[UNI00e8]s bien, allons\ncombattre ensemble."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_275e8(arg0: s32, arg1: s32)
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
		event.MesMake_2(
			0,
			"L'[UNI00e9]clat d'une [UNI00e9]p[UNI00e9]e forg[UNI00e9]e\npar un ma[UNI00ee]tre est magnifique.<page>[UNI00c0] couper le souffle."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Je n'arrive pas [UNI00e0] comprendre\ncomment on peut [UNI00ea]tre heureux [UNI00e0]\npolir des cailloux."
		)
	else
		event.MesMake_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_279f0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_26250(arg0, arg1)
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
		helper_26250(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_264d8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_26688(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_26eec(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_275e8(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_27d7c(arg0: s32, arg1: any)
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
		event.MesMake_2(0, "Tu es une amie de Max ?<page>Alors, tiens-toi bien.")
	else
		event.MesMake_2(
			0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_27ff4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Tu es dou[UNI00e9] avec les machines, mais\nil serait temps d'apprendre le b.a.\n-ba de l'exploitation mini[UNI00e8]re..."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_28184(arg0: s32, arg1: s32)
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
			helper_e2f0(24, 1)
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
	event.MesMake_2(0, "D'apr[UNI00e8]s C[UNI00e9]dric,\ntu es toujours tr[UNI00e8]s\nactif en ce moment.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Tu es dou[UNI00e9] dans plein de domaines,<page>mais d'un autre c[UNI00f4]t[UNI00e9], tu ne\ntermines jamais rien."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Alors quand tu demandes de\nl'aide, j'ai un peu de mal [UNI00e0]\nte prendre au s[UNI00e9]rieux."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Je sais ! Essaie de transformer ce\npistolet trompette en pistolet cloche !<page>Tu crois que tu peux y arriver ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_e2f0(24, 1)
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
		"[(!)]Pour que G[UNI00e9]rald t'aide,\n   tu vas devoir lui rapporter\n   un pistolet cloche.<page>[(!)]Tu peux d[UNI00e9]velopper l'arme qu'il t'a\n   donn[UNI00e9]e, en acheter une ou en rapporter\n   une trouv[UNI00e9]e dans les d[UNI00e9]dales."
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
local function helper_28938(arg0: s32, arg1: s32)
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
			helper_11f2c()
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
			"Qu'est-ce qui se passe ?\nTu baisses encore les bras ?<page>Tu me d[UNI00e9][UNI00e7]ois.\nC'est [UNI00e0] [UNI00e7]a que [UNI00e7]a m[UNI00e8]ne de bricoler\ndes machines [UNI00e0] longueur de journ[UNI00e9]e ?"
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
		"Oh ! On dirait que tu commences\n[UNI00e0] t'y conna[UNI00ee]tre en armes aussi !<page>Il suffit de voir comment tu les\ntiens pour s'en rendre compte..."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"OK, je vais t'aider.\nMais je ne le fais pas pour toi.<page>Si cette ville est en danger,\nje ne peux pas rester assis\nici [UNI00e0] me tourner les pouces."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_28f28(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Les armes ne sont pas des jouets.<page>Sois prudent quand tu t'en sers,\nou tu pourrais te blesser."
		)
	else
		event.MesMake_2(
			0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_291d0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_27d7c(arg0, arg1)
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
		helper_27d7c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_27ff4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_28184(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_28938(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_28f28(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_2955c(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Ronchonnements...")
	helper_cd6723ca(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"...1212,<page>Mais non, c'[UNI00e9]tait 2211, c'est certain.<page>Ou peut-[UNI00ea]tre bien 1010."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ronchonnements...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]S'il ne te remarque m[UNI00ea]me pas quand \n   tu dis \"Bonjour\", c'est qu'il \n   doit avoir de gros, gros probl[UNI00e8]mes.<page>[(!)]Pourquoi ne pas r[UNI00e9]essayer plus tard\n   Tu pourras peut-[UNI00ea]tre l'aider, ou\n   l'[UNI00e9]couter se plaindre, au pire !"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_29a1c(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Ronchonnements...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Comment [UNI00e7]a, qu'est-ce que\nj'ai [UNI00e0] marmonner ?<page>J'essaie de me souvenir de la\ncombinaison du coffre."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Comment [UNI00e7]a,\nquel coffre ? Celui<page>qui est cach[UNI00e9] derri[UNI00e8]re le tableau\ndans mon bureau, bien s[UNI00fb]r..."
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
		"Ah, tu m'as fait peur !<page>Oh, fl[UNI00fb]te !<page>Je viens de l[UNI00e2]cher\nmon plus gros secret !<page>Bon, tant pis !<page>Tu peux peut-[UNI00ea]tre m'aider\n[UNI00e0] l'ouvrir maintenant."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"J'ai un gros probl[UNI00e8]me, je\nn'arrive plus [UNI00e0] me souvenir\nde la combinaison du coffre."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Il y a 4 chiffres alors j'ai choisi\nla date de naissance de Claire\npour [UNI00ea]tre s[UNI00fb]r de pas l'oublier."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Comment ai-je pu oublier [UNI00e7]a...<page>Quel mauvais p[UNI00e8]re je fais !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Le Maire para[UNI00ee]t tr[UNI00e8]s ennuy[UNI00e9].\n   [UNI00c9]coute ses propos sur l'anniversaire\n   de Claire pour trouver la combinaison."
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
local function helper_2a46c(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(0, "Une fois, je lui ai offert une\nbroche avec son signe astrologique.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"C'est Holly qui l'avait achet[UNI00e9]e\npour moi, mais je crois me souvenir\nque c'[UNI00e9]tait un animal [UNI00e0] 4 pattes..."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"Quel genre de cadeaux\nd'anniversaire je lui offre ?<page>Humm... beaucoup de manteaux et\nd'[UNI00e9]charpes il me semble.<page>Je ne sais jamais quoi lui offrir.\nEt tous les ans, c'est pire."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"Ah [UNI00e7]a ! Son anniversaire, c'est\ntoujours p[UNI00e9]nible. C'est un jour de\nramassage des d[UNI00e9]chets combustibles<page>et non-combustibles. C'est moi qui\nsort les poubelles chez nous."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"Les d[UNI00e9]chets non-combustibles sont\nramass[UNI00e9]s les jours divisibles par 7<page>et les d[UNI00e9]chets combustibles, les\njours divisibles par 3."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "Tu n'oublierais quand m[UNI00ea]me pas [UNI00e7]a,\nhein ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"J'ai compris ! Myst[UNI00e8]re r[UNI00e9]solu !\nLa combinaison est...<page>Je ne sais pas... Attends un peu."
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
	event.SetMenuEtc(0, "Saisis le num[UNI00e9]ro du code secret.", "2112", 0)
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
		event.MesMake_2(
			0,
			"Humm, [UNI00e7]a s'ouvre pas. Oh la la...<page>Il y a des documents vraiment\nimportants l[UNI00e0]-dedans..."
		)
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
	event.MesMake_2(0, "Euh... Mmm...\n2,<page>1,<page>1,<page>2...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "Ouaaaaouh !<page>Formidable,\n[UNI00e7]a a march[UNI00e9] !")
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
	event.MesMake_2(0, "Formidable ! Je peux enfin\nsortir mes documents importants !<page>Oh, merci !")
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
		"Quels documents ? Des dossiers<page>qui aideront Morton, mon adjoint,\n[UNI00e0] me remplacer en mon absence.<page>[UNI00c7]a m'inqui[UNI00e8]te un peu,\nmais je suis s[UNI00fb]r que [UNI00e7]a ira."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"Je suis pr[UNI00ea]t [UNI00e0] quitter la ville.<page>C[UNI00e9]dric m'a tout expliqu[UNI00e9].<page>Allez, on y va."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_2c4cc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Pense [UNI00e0] bien trier tes d[UNI00e9]chets et\n[UNI00e0] les jeter les bons jours, OK ?"
		)
	else
		event.MesMake_2(
			0,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2c754(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2955c(arg0, arg1)
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
		helper_2955c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_29a1c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2a46c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2c4cc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2d410(arg0: s32, arg1: any, arg2: s32)
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
		event.MesMake_2(0, "Je prie pour que le monde vive\nenfin en paix.")
	else
		event.MesMake_2(0, "Quand tu travailles dur pour une\nbonne cause, tu dois savoir\nr[UNI00e9]fl[UNI00e9]chir.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2d67c(arg0: s32, arg1: s32)
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
	event.MesMake_2(
		0,
		"Vraiment ? Tu as besoin de mon<page>aide ? Alors laisse-moi t'exposer\nun petit probl[UNI00e8]me."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Les bougies de cette [UNI00e9]glise sont\ncontr[UNI00f4]l[UNI00e9]es par un petit m[UNI00e9]canisme.<page>Il [UNI00e9]teint les bougies allum[UNI00e9]es,\net allume les bougies [UNI00e9]teintes.<page>Si l'une d'entre elles change, les\nbougies adjacentes changent aussi."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Si tu r[UNI00e9]ussis [UNI00e0] [UNI00e9]teindre toutes\nles bougies, je viendrai.<page>J'en serais tr[UNI00e8]s content ! Sinon,\nje ne viendrai pas."
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
		"[(!)]Une petite [UNI00e9]nigme. Essaie une ou\n   deux fois, et sers-toi de ce que ces\n   petites exp[UNI00e9]riences t'auront appris."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Si tu rentres [UNI00e0] nouveau dans l'[UNI00e9]glise,\n   les bougies seront r[UNI00e9]initialis[UNI00e9]es.\n   Alors n'aie pas peur de te tromper.\n   La r[UNI00e9]ponse peut [UNI00ea]tre tr[UNI00e8]s simple."
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
local function helper_2ca38()
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
local function helper_2de98(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_2ca38()
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11f2c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_2ca38()
	if 0 < var2 then
		event.MesMake_2(0, "On dirait que tu n'es pas tout\n[UNI00e0] fait assez bon pour l'instant.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Je suis s[UNI00fb]r que tu vas progresser,\nmais en attendant, j'ai bien peur\nde ne pouvoir coop[UNI00e9]rer avec toi."
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
		"Tu t'es bien d[UNI00e9]brouill[UNI00e9].\nMagnifique.<page>Je suis s[UNI00fb]r que tu sauras\nr[UNI00e9]pondre [UNI00e0] mes attentes.<page>Je t'ai fait une promesse...\nJe viens avec toi."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2e408(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2d410(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2e4a0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2d410(arg0, arg1, 0)
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
		helper_2d410(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2d67c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2de98(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2e408(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2e790(arg0: s32, arg1: any)
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
		"Pourquoi la lune me manque-t-elle<page>tant ? Je me demande si je ne\nviendrais pas de l[UNI00e0]-bas des fois..."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2e920(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Je veux bien venir avec toi,\nmais y aura-t-il une lune l[UNI00e0]-bas ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "C'est vrai ? Dois-je te croire sur\nparole. Les hommes mentent parfois.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "En fait, j'ai chang[UNI00e9] d'avis. Je\nvais attendre que la lune se\nmontre ici.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]C'est peut-[UNI00ea]tre li[UNI00e9] [UNI00e0] son histoire\n   pass[UNI00e9]e... Quoi qu'il en soit, Rufio\n   ne fait pas confiance aux hommes."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Il faut que Rufio te croie.\n   Si tu lui donnes une photo\n   de la lune, [UNI00e7]a marchera peut-[UNI00ea]tre."
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
local function helper_2efbc(arg0: s32, arg1: s32)
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
			helper_11f2c()
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
			"Je te croyais diff[UNI00e9]rent, mais non,\nles hommes sont les hommes.<page>Peu importe, je suis habitu[UNI00e9] [UNI00e0] ce\nqu'on me raconte des mensonges."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Il y a une lune sur cette photo !<page>Je pourrai la voir quand je veux !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Venir avec toi ?<page>Mais oui, bien s[UNI00fb]r.\nJe n'ai nulle part ailleurs o[UNI00f9]\naller."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2f4fc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Tu m'as donn[UNI00e9] cette photo de la\nlune. Tu es g[UNI00e9]n[UNI00e9]reux.")
	else
		event.MesMake_2(
			0,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2f784(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2e790(arg0, arg1)
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
		helper_2e790(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2e920(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2efbc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2f4fc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2fa68(arg0: s32, arg1: any)
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
		"Mon hobby [UNI00e0] moi, c'est la p[UNI00ea]che.<page>Je r[UNI00ea]ve de p[UNI00ea]cher un Mardan Garayan.<page>Il faut p[UNI00ea]cher gros pour m'[UNI00e9]pater."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2fc28(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Tu veux que je te rende service ?<page>Alors, [UNI00e9]coute-moi.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pour cela, tu devras gagner mon<page>respect. Et je ne respecte que\nceux qui ont d[UNI00e9]j[UNI00e0] attrap[UNI00e9] de\nplus gros poissons que moi."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Le plus gros poisson que j'aie\nattrap[UNI00e9] [UNI00e9]tait un Nonky de 60 cm.<page>[UNI00c7]a t'impressionne ?\nSi le d[UNI00e9]fi te tente, je t'offre de\nte mesurer [UNI00e0] moi quand tu veux !"
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
		"[(!)]Il semble que le seul moyen de le\n   faire venir soit de p[UNI00ea]cher un Nonky\n   de plus de 60 cm. Tu peux y arriver !"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]Enfin, essaie d'aller p[UNI00ea]cher\n   dans le lac de Palm Brinks.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_30344(arg0: s32, arg1: s32)
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
			helper_11f2c()
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
			"H[UNI00e9], je parie que tu n'as jamais\nattrap[UNI00e9] un Nonky ?<page>Ah ah. Tu dois [UNI00ea]tre vraiment\nnul en p[UNI00ea]che !"
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
		event.MesMake_2(0, "Ah ah ! Tu n'as attrap[UNI00e9] qu'un tout\npetit poisson de [数値１] cm !")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Tu ne m[UNI00e9]rites pas mon aide !<page>Tu ferais mieux de recommencer.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "...Oh, je t'avais sous-estim[UNI00e9].")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Un homme, [UNI00e7]a n'a qu'une parole.<page>Je vais [UNI00e9]couter ce que t'as [UNI00e0] dire."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Parle autant que tu veux !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_30bdc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Um, [UNI00e7]a peut attendre bien s[UNI00fb]r,\nmais un jour, j'aimerais que tu\nm'expliques ta technique de p[UNI00ea]che."
		)
	else
		event.MesMake_2(
			0,
			"J'ai h[UNI00e2]te de d[UNI00e9]couvrir les nouveaux\nhauts-lieux de la p[UNI00ea]che qu'a [UNI00e0]\noffrir le monde. [UNI00c7]a sera trop top."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_30ea4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2fa68(arg0, arg1)
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
		helper_2fa68(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2fc28(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_30344(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_30bdc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_31188(arg0: s32, arg1: any)
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
	event.MesMake_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_312f8(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Les Firbits ne rendent service\nqu'[UNI00e0] ceux qui leur sont\nsup[UNI00e9]rieurs.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Personnellement, je m'y connais\nen poissons.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"J'ai entendu dire que des hommes\norganisaient un concours o[UNI00f9]\ns'affrontaient leurs poissons.<page>Si tu en as un, pourquoi ne pas\nessayer de finir premier ?<page>Si tu [UNI00e9]choues, je saurais que tu \nne m[UNI00e9]rites pas mon aide."
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
		"[(!)]Il doit s'agir de la Course de poissons.\n   Pourquoi ne pas tenter la cat[UNI00e9]gorie\n   D[UNI00e9]butants ? Elle t'aidera peut-[UNI00ea]tre."
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
local function helper_31924(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "Tel poisson, tel ma[UNI00ee]tre, para[UNI00ee]t-il.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Pas question que je parle au \npropri[UNI00e9]taire d'un poisson si nul.")
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
		"J'ai bien regard[UNI00e9], tu sais.\nC'[UNI00e9]tait une course superbe.<page>Je ne pense pas que j'aurais pu\ndresser un aussi bon poisson.<page>Tu peux m'emmener avec toi et\nm'apprendre tout ce que tu sais ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_31e58(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "J'esp[UNI00e8]re un jour pouvoir moi\naussi occuper la plus haute\nmarche du podium.")
	else
		event.MesMake_2(
			0,
			"J'aimerais tant que Fabio\ns'int[UNI00e9]resse un peu [UNI00e0] autre chose\nque la p[UNI00ea]che."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_320d0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_31188(arg0, arg1)
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
		helper_31188(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_312f8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_31924(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_31e58(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_32414(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Je ne suis pas tr[UNI00e8]s en forme.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Le Dr Dell est venu me voir\nmais selon lui tout va bien.<page>Je me demande ce que j'ai ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_326d4(arg0: s32, arg1: s32)
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
		"Je ne suis pas tr[UNI00e8]s en forme.<page>Je ne peux pas partir en voyage.<page>Le Dr Dell est venu me voir, mais\nil m'a dit que tout allait bien."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Pourtant, quand je suis debout, j'ai\nl'impression que je vais tomber.<page>C'est dur [UNI00e0] expliquer. C'est un peu\ncomme si le monde avait [UNI00e9]t[UNI00e9] d[UNI00e9]form[UNI00e9]."
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
			"Mmm... Si le Dr Dell ne sait pas ce\nqui ne va pas, je ne vois pas bien\nce que je peux faire moi-m[UNI00ea]me..."
		)
		helper_403f0e66(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "[UNI00c7]a me rappelle quelque chose.")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[UNI00c0] l'[UNI00e9]poque o[UNI00f9] je suis n[UNI00e9], le\nmonde [UNI00e9]tait dans un [UNI00e9]tat d[UNI00e9]plorable,\navec un nombre incalculable de\ndistorsions temporelles."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Cela avait un impact sur les gens\n[UNI00e0] la sant[UNI00e9] fragile.<page>Les plus l[UNI00e9]gers avaient le tournis\net les plus lourds ne tenaient\nplus debout."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Tu es peut-[UNI00ea]tre particuli[UNI00e8]rement\nsensible [UNI00e0] ce genre de chose.<page>M[UNI00ea]me les rares distorsions qu'on\na ici suffisent [UNI00e0] t'affecter."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Si on pouvait [UNI00e9]liminer les plus\nproches d'entre elles, tu te\nsentirais peut-[UNI00ea]tre mieux."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Comment [UNI00e9]liminer une distorsion...\n   Le Spheda ! Termine environ 10 niveaux\n   et Mena ira peut-[UNI00ea]tre mieux."
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
local function helper_333c0(arg0: s32, arg1: s32)
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
			helper_11f2c()
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
		event.MesMake_2(0, "Je me sens toujours aussi mal.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"J'ai peut-[UNI00ea]tre quelque\nchose de tr[UNI00e8]s grave ?<page>Peut-[UNI00ea]tre que m[UNI00ea]me le Dr Dell ne\npeut plus rien faire pour moi..."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Bonjour !<page>Comment je vais ? Super bien !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Je me sens tellement mieux !<page>Le monde semble [UNI00e0] nouveau normal.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Ah oui. Tu voulais un service.<page>Je ferai tout pour t'aider.<page>Tu l'as fait pour moi, alors je\ndois aussi te venir en aide."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_33b50(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Tu m'as aid[UNI00e9]e, je le ferai donc\naussi, mais piti[UNI00e9], ne m'emm[UNI00e8]ne pas\ndans un endroit plein d'insectes !"
		)
	else
		event.MesMake_2(
			0,
			"Si la Voie ferr[UNI00e9]e Noirpierre\ns'[UNI00e9]tend au monde entier, j'irai\npeut-[UNI00ea]tre aussi voyager."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_33df8(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_32414(arg0, arg1)
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
		helper_32414(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_326d4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_333c0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_33b50(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_340c4(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Ooh, Max ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	else
		event.MesMake_2(0, "Ooh, Monica ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "C'est g[UNI00e9]nial ! Pourquoi ne\nm'emm[UNI00e8]nerais-tu pas avec toi ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_3448c(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Ooh, Max ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	else
		event.MesMake_2(0, "Ooh, Monica ! Il para[UNI00ee]t que tu sors\nde la ville de temps en temps.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "C'est g[UNI00e9]nial ! Pourquoi ne\nm'emm[UNI00e8]nerais-tu pas avec toi ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Je parie que tu crois que je serai\ninutile parce que je suis une fille<page>alors qu'en fait, je porte chance\naux gens que je c[UNI00f4]toie."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Il ne pleut jamais quand je sors,\net je n'ai jamais vu un billet de\nloterie perdant.<page>Qu'est-ce que tu en penses ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "D'accord.\nNon merci.")
	var3 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "Pourquoi ? C'est injuste !\nT'es horrible !")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "T'es naze !<page>Imb[UNI00e9]cile !<page>Stupide !")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Tu m'emm[UNI00e8]neras avec toi ?<page>Je croyais pas que tu le ferais !")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Mais pourquoi je suis la seule qui\ndoive te le demander, alors que tu\nl'as demand[UNI00e9] [UNI00e0] tous les autres ?<page>Il suffisait de le demander pour\nque je vienne."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Je sais, si tu arrives [UNI00e0] me\ntrouver, je t'aiderai. D'accord ?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Bref, on va jouer [UNI00e0] cache-cache !<page>Allez, on y va !")
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
		"[(!)]Bien... on dirait qu'il va falloir\n   retrouver Corinne. Elle se cache\n   s[UNI00fb]rement quelque part [UNI00e0] Palm Brinks."
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
local function helper_3560c(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "Oh ! Tu m'as trouv[UNI00e9]e !<page>Mais y arriveras-tu encore ?")
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
		"Oh ! Tu m'as trouv[UNI00e9]e...<page>Je commence [UNI00e0] en avoir assez.<page>Se cacher, en fait, c'est\nplut[UNI00f4]t ennuyeux.<page>Bon ! Allez, on part [UNI00e0]\nl'aventure !"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_35b94(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Le jeu de cache-cache, c'est\npour les petits.")
	else
		event.MesMake_2(
			0,
			"Ne dis pas le contraire. Je sais\nque tu as fait plein de trucs hyper\ncool. Viens m'en parler un jour !"
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_35dec(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_340c4(arg0, arg1)
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
		helper_340c4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_3448c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_3560c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_35b94(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_360d0(arg0: s32, arg1: any)
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
		"...<page>Ah ! Bonjour !\nJe suis un peu dure d'oreille.<page>Je ne comprends pas ce qu'on me\ndit, sauf quand on parle lentement."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_36260(arg0: s32, arg1: s32)
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
			helper_11f2c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Qu'est-ce que tu as dit ?<page>Peux-tu parler plus lentement?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(0, 'Saisis : "Partons ensemble."', "Partons ensemble.", 0)
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
		event.MesMake_2(0, "Que veux-tu dire par l[UNI00e0] ?\nJe n'y comprends rien...")
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
		"Une aventure ?\n[UNI00c7]a me tenterait bien...<page>Mais [UNI00e0] quoi pourrait servir\nune vieille femme comme moi ?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11f2c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_36944(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_36260(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_369d0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "[UNI00c0] quoi pourrait servir une\ngrand-m[UNI00e8]re comme moi ?")
	else
		event.MesMake_2(
			0,
			'Quand la voie ferr[UNI00e9]e Noirpierre\nsera termin[UNI00e9]e, j\'adorerais aller \naux "Confins de la Terre".'
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_36c38(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_360d0(arg0, arg1)
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
		helper_360d0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_36260(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_36944(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_369d0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_23fc4(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Oh, tu aides\nPolly ?<page>Super.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Ce que je vais faire\navec ces 20 pains ?<page>Eh bien, j'ai organis[UNI00e9] une soir[UNI00e9]e\nfondue savoyarde pour ce soir."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"Pour l'\"inventeur\" que tu es,\nc'est une combinaison culinaire<page>de fromage, de pain et de vin !"
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"C'est super bon. On en mange tant\nqu'il faut des tonnes de pain.<page>Mais je ne voulais pas\nqu'il soit livr[UNI00e9] ici."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"D[UNI00e9]sol[UNI00e9] Max, mais tu pourrais\nl'emporter chez moi ?<page>Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "Tu sais o[UNI00f9] c'est, non ?\nPr[UNI00e8]s du champ de citrouilles.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "Annul[UNI00e9]e ?!\nComme c'est dommage !")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(0, "Dans ce cas, je n'ai plus besoin\nde pain. Tu pourrais le rapporter\n[UNI00e0] Polly ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "D[UNI00e9]sol[UNI00e9], mais tu peux rapporter\nle pain [UNI00e0] Polly pour moi ?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_36f1c(arg0: s32, arg1: s32)
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
				helper_144f8(arg0, arg1)
			end
			if at <= 2 then
				helper_190b4(arg0, arg1)
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
				helper_1c684(arg0, arg1)
			end
			if at <= 14 then
				helper_1e22c(arg0, arg1)
			end
			if at <= 15 then
				helper_20e74(arg0, arg1)
			end
			if at <= 16 then
				helper_2374c(arg0, arg1)
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
				helper_25ec4(arg0, arg1)
			end
			if at <= 21 then
				helper_16b4c(arg0, arg1)
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
				helper_279f0(arg0, arg1)
			end
			if at <= 26 then
				helper_291d0(arg0, arg1)
			end
			if at <= 27 then
				helper_2c754(arg0, arg1)
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
				helper_2e4a0(arg0, arg1)
			end
			if at <= 32 then
				helper_2f784(arg0, arg1)
			end
			if at <= 33 then
				helper_30ea4(arg0, arg1)
			end
			if at <= 34 then
				helper_320d0(arg0, arg1)
			end
			if at <= 35 then
				helper_33df8(arg0, arg1)
			end
			if at <= 36 then
				helper_35dec(arg0, arg1)
			end
			if at <= 37 then
				helper_36c38(arg0, arg1)
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
		helper_144f8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 5 then
		helper_190b4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Je veux faire des achats\nC'est parti pour un scoop")
			var7 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_c6a8(0)
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
				helper_f7a8()
				if vm.skipping() then
					return skip(8)
				end
			end
		else
			event.MesMake_2(0, "En route pour l'aventure ?\nC'est parti pour un scoop")
			var8 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_c6a8(0)
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
				helper_1accc(arg0, arg1)
				if vm.skipping() then
					return skip(13)
				end
			end
		end
	end
	if var3 == 7 then
		helper_1c684(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 8 then
		helper_1e22c(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 10 then
		helper_20e74(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 11 then
		helper_2374c(arg0, arg1)
		if vm.skipping() then
			return skip(17)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var11 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(18)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_25ec4(arg0, arg1)
				if vm.skipping() then
					return skip(19)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_f7a8()
			if vm.skipping() then
				return skip(20)
			end
		else
			helper_25ec4(arg0, arg1)
			if vm.skipping() then
				return skip(21)
			end
		end
	end
	if var3 == 14 then
		helper_16b4c(arg0, arg1)
		if vm.skipping() then
			return skip(22)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var14 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(23)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_279f0(arg0, arg1)
				if vm.skipping() then
					return skip(24)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_f7a8()
			if vm.skipping() then
				return skip(25)
			end
		else
			helper_279f0(arg0, arg1)
			if vm.skipping() then
				return skip(26)
			end
		end
	end
	if var3 == 16 then
		helper_291d0(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 17 then
		helper_2c754(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Bonjour\nEn route pour l'aventure ?")
			var17 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(29)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_2e4a0(arg0, arg1)
				if vm.skipping() then
					return skip(30)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_f7a8()
			if vm.skipping() then
				return skip(31)
			end
		else
			helper_2e4a0(arg0, arg1)
			if vm.skipping() then
				return skip(32)
			end
		end
	end
	if var3 == 19 then
		helper_2f784(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 20 then
		helper_30ea4(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 21 then
		helper_320d0(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 23 then
		helper_33df8(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 24 then
		helper_35dec(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 25 then
		helper_36c38(arg0, arg1)
		if vm.skipping() then
			return skip(38)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Je veux faire des achats\nBonjour")
			var20 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(39)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_23fc4(arg0, arg1)
				if vm.skipping() then
					return skip(40)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_f7a8()
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"J'ai du mal depuis quelque temps [UNI00e0]\nvoir les toutes petites pi[UNI00e8]ces.<page>Je dois commencer [UNI00e0] me\nfaire un peu vieux..."
			)
		else
			event.MesMake_2(
				0,
				"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
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
			event.MesMake_2(0, "Quand je n'ai rien\n[UNI00e0] faire, je deviens de\nmauvaise humeur.")
		else
			event.MesMake_2(
				0,
				"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
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
				"Tu sais, j'ai plein de bestioles\ndans les plumes en ce moment,\net [UNI00e7]a me gratte terriblement."
			)
		else
			event.MesMake_2(
				0,
				"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
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
				"J'adore l'odeur de la poudre [UNI00e0]\ncanon ! C'est un boulot id[UNI00e9]al.<page>Malheureusement, j'ai un patron\ntr[UNI00e8]s ent[UNI00ea]t[UNI00e9] et vieille [UNI00e9]cole.\nM'enfin."
			)
		else
			event.MesMake_2(0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
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
				"[UNI00c0] part le fait que j'ai d[UNI00e9]but[UNI00e9]\nma vie sur une toile, je ne\nsuis pas diff[UNI00e9]rente des autres."
			)
		else
			event.MesMake_2(0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
		end
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(46)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_106b0()
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
				helper_f7a8()
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
		helper_f7a8()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "H[UNI00e9] ! Il est interdit d'avancer\nau-del[UNI00e0] de la limite.")
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
					"Regarde-moi [UNI00e7]a. Difficile de croire\nqu'autrefois cet engin avan[UNI00e7]ait [UNI00e0]\ntoute vitesse, hein ?<page>Ah mais si, si... Il y a longtemps.<page>Je r[UNI00ea]ve de faire un autre\nvoyage dans ce truc. C'est pour\n[UNI00e7]a que je le bichonne. Comme [UNI00e7]a,<page>si un jour on me "
				)
			else
				event.MesMake_2(
					0,
					"Il faut faire de l'exercice souvent\npour [UNI00e9]viter les courbatures. Pour\nles machines c'est pareil..."
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
					"H[UNI00e9], salut Max !\nIl y a une [UNI00e9]ternit[UNI00e9] que la\nvoie ferr[UNI00e9]e ne fonctionne plus.<page>Mais je continue [UNI00e0] surveiller\nla gare jour apr[UNI00e8]s jour."
				)
			else
				event.MesMake_2(
					0,
					"Le Maire s'est enfin boug[UNI00e9] un peu\net les trains ont repris du service\nmais pas encore pour le public.<page>Ah [UNI00e7]a, je meurs d'envie d'y faire\nmonter les gens de la ville..."
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
					"Salut, Max. Tu savais que mon p[UNI00e8]re\nest le chef de gare ? On surveille\nla gare tous les deux.<page>Jusqu'au jour o[UNI00f9] les trains\nseront remis en service..."
				)
			else
				event.MesMake_2(
					0,
					"Le train marche ! Mais il va\nfalloir un moment avant que la\ngare ne fonctionne [UNI00e0] nouveau normalement..."
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
					"J'admire secr[UNI00e8]tement Monica depuis\ntoujours, mais je ne l'ai pas vue\ndans le coin derni[UNI00e8]rement.<page>C'est pour [UNI00e7]a que je n'arrive pas\n[UNI00e0] me concentrer sur mon travail."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(
						0,
						"H[UNI00e9], Max !\nMonica est de retour, on dirait.\nTout le monde va [UNI00ea]tre enchant[UNI00e9] !"
					)
				else
					event.MesMake_2(0, "Monica ! Comment [UNI00e7]a va ?\nTu m'as vraiment manqu[UNI00e9].")
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
					"Je commen[UNI00e7]ais tout juste [UNI00e0] pouvoir\ndiscuter normalement avec\nMonica quand elle a disparu.<page>Allez Max,\ndis-moi o[UNI00f9] elle est, s'te pla[UNI00ee]t ?"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica est revenue.\nComment elle a fait ?")
				else
					event.MesMake_2(0, "Monica, tu es revenue !\nComment t'as fait ?")
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
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_30c30f62(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_11df8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_106b0()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_106b0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_39a54()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_36f1c(var1, player_chara)
		end
		if at <= 2 then
			helper_11df8()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_36f1c(var1, player_chara)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_11df8()
		if vm.skipping() then
			return skip(3)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_3a034

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3b590()
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_3b830()
		end
	end
	flag = event.GetFlag(103) or flag
	event.SetBitCtrl(1, if flag == 0 then 1 else 0)
	helper_3a034()
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
				helper_3b830()
				if vm.skipping() then
					return skip(1)
				end
			else
				helper_3b590()
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_3b830()
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
	helper_461bc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39ec0()
	event.SetCnt(5, 3)
	helper_3bc74()
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
			local _ = helper_3a15c()
		end
	end
	flag = event.GetFlag(103) or flag
	if flag == 0 then
		event.Initialize()
		event.SetMotion(0, "立ち")
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(
			0,
			"Flotsam me cherche peut-[UNI00ea]tre\nencore, il vaut mieux que je ne\nretourne pas [UNI00e0] Palm Brinks."
		)
		helper_c049c42a(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_3a15c()
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
			local _ = helper_3a318()
		end
		if at <= 3 then
			helper_3b830()
		end
		var2 = 0
		var6 = var6 + 1
	end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		helper_3ad30()
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_3a318()
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
				helper_3b830()
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
			helper_e2f0(386, 1)
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
	helper_e2f0(386, 1)
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
			helper_39a54()
		end
	end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		local t0 = helper_461bc()
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
		helper_39a54()
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
			helper_39ec0()
			helper_3bc74()
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
	helper_39ec0()
	event.SetFlag(4, 1)
	helper_3bc74()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
