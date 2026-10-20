--!strict
-- map/d/d01/e01/d01e01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
local function helper_38830()
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
local function helper_38b20()
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
local function helper_38c94()
	local flag: s32 = 0
	event.SetFlag(40, 1)
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		helper_38830()
	end
	helper_38b20()
end

--- Helper function.
local function helper_3a480()
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
local function helper_3a1e0()
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
local function helper_e300(arg0: s32, arg1: s32)
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
local function helper_3da04()
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
				helper_e300(22, 1)
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
				helper_e300(359, 1)
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
	helper_e300(22, 1)
	if vm.skipping() then
		return skip(67)
	end
	helper_c9057fa5(0, 4)
	event.MesMake_2(
		0,
		"[(!)] Mit [l1] gehst du in Position \n   und greifst mit (O) an.\n   Aber wenn du zu weit weg stehst,\n   sind deine Angriffe weniger wirksam."
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
	helper_e300(359, 1)
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
local function helper_44dfc()
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
				helper_3da04()
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
	event.MesMake_2(0, "Und was machst du jetzt?")
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
	event.MesMake_2(0, "Ich werde mich hier verstecken.\nUnterirdischer Kanal ... ...")
	var12 = helper_3000b46a(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_c9057fa5(0, 7)
	event.SetMesShippo(0, 1)
	if var12 == 1 then
		event.StreamClose(1)
		helper_3da04()
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
		event.MesMake_2(0, "Ich werde mich hier verstecken.")
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
		event.MesMake_2(0, "Bleib solang du willst.")
		helper_403f0e66(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.StreamClose(1)
	end
	return part2()
end

--- Helper function.
local function helper_3a8c4()
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
				helper_38830()
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
			"[(!)]Sprich mit Donny, dann geht's weiter.\n   Du kannst deinen Fortschritt am\n   Speicherpunkt speichern."
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
	helper_38830()
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
local function helper_d2e8(arg0: s32, arg1: s32)
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
local function helper_38dbc()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			var0 = helper_d2e8(5, 10)
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
	var0 = helper_d2e8(5, 10)
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
local function helper_39990()
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
	event.MesMake_2(0, "Wo dieser Kanal wohl hinf[UNI00fc]hrt?\nIch werde Donny fragen.")
	helper_c049c42a(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_38f78()
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
				var0 = helper_d2e8(5, 55)
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
	var0 = helper_d2e8(5, 55)
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
local function helper_12260(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Hmm, dieser Baum ... sieht nicht\ngut aus. Ich muss etwas tun.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max! Du hast mich erschreckt.\nIch entferne gerade Ungeziefer von\ndiesem Baum.<page>Nicht alle B[UNI00e4]ume wachsen\nvon alleine gut. Manche\nmuss man gut pflegen, so wie diesen."
		)
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_11f1c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "Hmm, dieser Baum ... sieht nicht\ngut aus. Ich muss etwas tun.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Gordon musst du offenbar\n   ansprechen, sonst merkt er nichts.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_125a8(arg0: s32, arg1: s32)
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
		helper_11f1c(arg0, arg1)
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
		"Oh, Max! Du siehst in letzter\nZeit oft traurig aus. Ist alles\nin Ordnung bei dir?<page>Kann ich etwas f[UNI00fc]r dich tun?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Wie? Ich soll dich auf\ndeinem Abenteuer begleiten?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Hmm ... ich w[UNI00fc]rde gern mitkommen ...\nAber dieser arme Baum\nist krank.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Die Pflege der B[UNI00e4]ume und\nBlumen auf diesem Gel[UNI00e4]nde\nist mir das Wichtigste [UNI00fc]berhaupt.<page>Wenn ich einfach abhaue,\nverliere ich noch meinen Job."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Etwas von Brunos Weihwasser\nw[UNI00fc]rde diesem Baum sicher helfen!<page>Aber du wei[UNI00df]t ja, dein Vater und\nder Priester verstehen sich nicht...<page>Dein Vater w[UNI00fc]rde mir nie Geld\nf[UNI00fc]r Priester Brunos Weihwasser geben!<page>Ich sitze in der Klemme."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Um Gordon nach Sindain zu\n   bringen, musst du ihn erst\n   als Begleiter gewinnen.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "[(!)]Wenn du Gordon hilfst,\n   schlie[UNI00df]t er sich dir an\n   und steigt in den Zug.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]Deine Auftr[UNI00e4]ge findest du\n   im Notizbuch\n   im Gegenst[UNI00e4]nde-Men[UNI00fc]."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(0, "[(!)]Oh, du hast kein Notizbuch.\n   Auf dem Tisch im\n   Ger[UNI00e4]teladen liegt eins.")
		helper_c049c42a(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]In Donnys Versteck liegt auch\n   eins. Es ist egal, welches\n   du nimmst, aber mach schnell!"
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
local function helper_132c8(arg0: s32, arg1: s32)
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
		helper_11f1c(arg0, arg1)
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
	event.MesMake_2(0, "Max, ich muss unbedingt diesem\nBaum helfen.<page>Na ja, und daf[UNI00fc]r brauche\nich ...")
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
		event.MesMake_2(0, "Max, so klappt das nicht.<page>Ich brauche Weihwasser\nvon Priester Bruno.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ja - das ist es, Max! Jetzt\nkann ich den Baum versorgen!<page>Danke, Max.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Meine Arbeit ist vorerst\nerledigt.<page>Jetzt kann ich dich auf\ndeinem Abenteuer begleiten!<page>Oh, und sag deinem Vater\nnichts von dem Weihwasser, ja?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Gordon reist jetzt mit.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		'[(!)]Seine Fertigkeiten verwendest\n   du [UNI00fc]ber den Statusbefehl unter\n   "Charakter" im Hauptmen[UNI00fc].<page>[(!)]Wenn du weitere Begleiter\n   gewinnst,\n   steigen diese in den Zug.'
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		'[(!)]Sprich jemand im Zug an,\n   um ihn oder sie als drittes\n   Gruppen-Mitglied zu aktivieren.<page>[(!)]Um einen deiner Begleiter in ein\n   Haus zu bewegen, w[UNI00e4]hle im T[UNI00fc]r-\n   Men[UNI00fc] des Hauses "Belegen".'
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]Es gibt bestimmt noch\n   viele, die mit dir kommen wollen.\n   Halte Ausschau nach ihnen!"
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
local function helper_13f68(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, hallo, junge Dame.\nKann ich etwas f[UNI00fc]r dich tun?")
		else
			event.MesMake_2(0, "Max, erz[UNI00e4]hl deinem Vater\nnichts von dem Weihwasser, ja?")
		end
	else
		event.MesMake_2(0, "Es muss so viele Pflanzen geben,\ndie wir noch nie gesehen haben.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14288(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_12260(arg0, arg1)
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
		helper_12260(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_125a8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_132c8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_13f68(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_16ca0(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Hallo.\nDu bist Monica, stimmt's?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Ich bin Parn.\nIch bin Zaubermaler.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hey, Max.<page>Warum siehst du immer\nso gesund aus?")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1707c(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Hallo.\nDu bist Monica, stimmt's?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Ich bin Parn.\nIch bin Zaubermaler.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Ich hab euch noch nicht\nvorgestellt, oder?<page>Das ist Julia, meine Zuk[UNI00fc]nftige.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, " ...")
		helper_403f0e66(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)] Monica ist in solchen Situationen\n   unbeholfen. Wahrscheinlich schafft\n   sie das nicht. Versuch's als Max."
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
	event.MesMake_2(0, "Hallo, Max.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Ich hab euch noch nicht\nvorgestellt, oder?<page>Das ist Julia, meine Zuk[UNI00fc]nftige.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, " ...")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"Ja, lach du nur.\nEs klingt ja auch komisch!<page>Wer verliebt sich schon\nin eine gemalte Frau?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"Aber ich bin Zaubermaler.\nWas ich zeichne, wird Wirklichkeit.<page>Was ich male, existiert im Bild\ntats[UNI00e4]chlich. Solange es nichts\nLebendiges ist ..."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "Selbst Zaubermaler k[UNI00f6]nnen nichts\nLebendiges erschaffen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"Aber es gibt eine M[UNI00f6]glichkeit.\nAuf einem gro[UNI00df]en alten Baum liegt\nein Goldenes Ei."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Angeblich kann man mit seiner\ngoldenen Farbe alles Gezeichnete\nzum Leben erwecken.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"Max, du verl[UNI00e4]sst die\nStadt, nicht wahr?<page>Kannst du mir wohl goldene\nFarbe mitbringen?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"Du bekommst nat[UNI00fc]rlich etwas daf[UNI00fc]r.<page>Wenn du mir hilfst, helfe\nich dir mit meiner neuen Kraft."
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
		"[(!)]Ein gro[UNI00df]er alter Baum ...\n   mit einem Goldenen Ei! Wo k[UNI00f6]nnte\n   so ein Baum blo[UNI00df] stehen?"
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
local function helper_d53c(arg0: s32)
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
local function helper_11e3c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d53c(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_d53c(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_181e4(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
		if at <= 8 then
			helper_d53c(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Ich hab dich erwartet.<page>Schnell, gib mir die Farbe,\ndann kann ich das Bild beleben.")
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
		event.MesMake_2(0, "Du machst Witze!<page>Ich brauche goldene Farbe.\nUnd nichts anderes!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "Das ist die goldene Farbe ...\nIch probiere sie sofort aus.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "S ... sie ... sie lebt ...<page>Unglaublich, sie ist perfekt!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Danke, Max.\nIch halte mein Versprechen. Nutze\nmeine neue Kraft, wann du willst.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_d53c(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_1899c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Bitte nutze meine neue\nKraft, wann immer du willst.")
	else
		event.MesMake_2(
			0,
			"Die Welt der Bilder ist gro[UNI00df].\nMalen zu lernen mag ein Leben\ndauern, doch es ist die Zeit wert."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18bf4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_16ca0(arg0, arg1)
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
		helper_16ca0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_1707c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_181e4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1899c(arg0, arg1)
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
		event.MesMake_2(arg0, "Wenn du mir keine Kn[UNI00fc]ller lieferst,\nkann ich dir nichts geben!")
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
			"Deine Fotografie-Stufe h[UNI00e4]ngt ab\nvon der Anzahl Ideen und Kn[UNI00fc]ller,\ndie du hast.<page>Je weiter deine Stufe steigt, umso\nmehr coole Belohnungen kriegst du."
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
local function helper_c698(arg0: s32)
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
		event.MesMake_2(arg0, "Bring mir mal ein paar\nKn[UNI00fc]ller-Notizen, ja?")
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
		event.MesMake_2(arg0, "Sieht aus, als g[UNI00e4]be es\nkeine weiteren Kn[UNI00fc]ller mehr.")
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
		event.MesMake_2(arg0, "Ich hab noch [Number1] Kn[UNI00fc]ller\nherausgefunden.")
		event.SetMesDrawspeed(arg0, 0)
		helper_c049c42a(arg0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	helper_c9057fa5(arg0, 1)
	var7 = event.GetMenuEtc_2(4) or var7
	if var7 <= 0 then
		event.MesMake_2(
			arg0,
			"Komm schon, Mann! H[UNI00e4]ng nicht nur rum!\nWo bleiben deine neuen\nInsider-Kn[UNI00fc]ller?"
		)
	else
		event.SetMesValue(arg0, 1, var7)
		event.MesMake_2(arg0, "Juhu! Du hast [Number1] neue(n) Kn[UNI00fc]ller!\nIch wusste, dass du's schaffst!")
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
local function helper_f6b4(arg0: s32)
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
local function helper_f7b8()
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
			helper_f6b4(15)
		end
		if at <= 3 then
			helper_f6b4(1)
		end
		if at <= 4 then
			helper_f6b4(6)
		end
		if at <= 5 then
			helper_f6b4(0)
		end
		if at <= 6 then
			helper_f6b4(4)
		end
		if at <= 7 then
			helper_f6b4(31)
		end
		if at <= 8 then
			helper_f6b4(35)
		end
		if at <= 9 then
			helper_f6b4(36)
		end
		if at <= 10 then
			helper_f6b4(37)
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
	event.MesMake_2(0, "Willkommen.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"M[UNI00f6]chtest du die Macht der\nG[UNI00f6]tter zeitweise verliehen bekommen?<page>Dann bitte ich um eine\nSpende f[UNI00fc]r die Kirche."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Schwer besch[UNI00e4]ftigt, was?\nBrauchst du was?<page>Aber gratis gibt's nichts.\nNicht mal f[UNI00fc]r dich, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"Du brauchst noch mehr Georama-\nTeile?<page>Falls du keine Zeit hast, sie\nselbst zu sammeln, kannst du vielleicht\nmit etwas Geld nachhelfen."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Hallo, ich bin B[UNI00e4]cker-Lehrling.\nIch k[UNI00fc]mmere mich um die B[UNI00e4]ckerei,\nsolange Polly fort ist.<page>Ich bin etwas nerv[UNI00f6]s, aber es\ngeh[UNI00f6]rt wohl auch zur Ausbildung.\nIch tue mein Bestes!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Wir sehen uns kaum [UNI00e4]hnlich ...\naber ich bin Milanes kleine\nSchwester.<page>Sie hat gesagt, ich soll auf den\nLaden aufpassen, w[UNI00e4]hrend sie\nweg ist.<page>Dabei hab ich gar\nkeine Ahnung von Waffen!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Hab ich dich [UNI00fc]berrascht, ja?\nEs ist ja auch [UNI00fc]berraschend, wenn hier\njemand in diesen Klamotten steht.<page>Ich bin mit Priester Bruno befreundet\nund vertrete ihn, solange er weg ist.\nKann ich dir denn helfen?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"M[UNI00f6]chtest du die Macht der\nG[UNI00f6]tter zeitweise verliehen bekommen?<page>Dann bitte ich um eine\nSpende f[UNI00fc]r die Kirche."
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
		helper_f6b4(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_f6b4(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_f6b4(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_f6b4(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_f6b4(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_f6b4(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_f6b4(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_f6b4(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_f6b4(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_19068(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Hier ist zu. Geh doch stattdessen\nzum Laden meines alten Herrn.<page>Achte auf die K[UNI00fc]rbisse. Du siehst\nsie bestimmt. Einfach die Leiter rauf."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_18ed8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Seit du da bist, hab ich\nMax kaum gesehen.\nIch wei[UNI00df] nicht, was du vor hast -<page>ich hoffe, du benutzt\nihn nicht."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_19218(arg0: s32, arg1: s32)
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
		helper_18ed8(arg0, arg1)
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
		"Du kennst die Antwort doch:\nN-I-E-M-A-L-S!<page>Warum sollte ich f[UNI00fc]r andere\nLeute arbeiten?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Es springt nichts f[UNI00fc]r mich\nheraus und es ist gef[UNI00e4]hrlich.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Aber weil du's bist, denk ich\nmal dr[UNI00fc]ber nach.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Andererseits bin ich ein H[UNI00e4]ndler-\nsohn - wir verschenken nichts.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Du wei[UNI00df]t ja, dass ich\nM[UNI00fc]nzen sammle.<page>Sie sind Symbole des Handels.\nIch h[UNI00e4]tte so gern alle."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Aber ich komme einfach nicht\nan die Dunkle M[UNI00fc]nze\nund die Panzer-M[UNI00fc]nze ran.<page>Wenn du mir hilfst, helfe\nich dir vielleicht auch."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_1997c(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_18ed8(arg0, arg1)
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
			"Wie? Ah, M[UNI00fc]nzen sammeln?<page>Ich suche die Dunkle M[UNI00fc]nze\nund die Panzer-M[UNI00fc]nze.<page>Die findest du nie. Ich hab [UNI00fc]berall\nnach ihnen gesucht - aber umsonst."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Wie? Du hast sie? Unglaublich!<page>Steh nicht rum!\nGib her, gib her, gib her!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Gut.\nWas soll ich tun?")
	var5 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Ahh! Wenn du mich\nver[UNI00e4]ppelst, helfe ich dir nie.")
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
		"Wow, ich hab sie alle!\nIch dachte, das w[UNI00e4]re unm[UNI00f6]glich ...<page>Tja, dann hab ich wohl keine Wahl.\nIch muss mitkommen!"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_1a3fc(arg0: s32, arg1: s32)
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
			helper_18ed8(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"Ich fass es nicht. Ich habe nicht\ngedacht, dass du sie findest.<page>Das war echt gut, Max!"
		)
	else
		event.MesMake_2(0, "He! Wie l[UNI00e4]uft die Zelmit-Suche?\nWenn ich helfen kann,\nsag einfach Bescheid.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1a70c(arg0: s32, arg1: s32)
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
		helper_19068(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_19218(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_1997c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_1a3fc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_1a9f0(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Hallo. Was f[UNI00fc]r Essen\nmagst du, Monica?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Ich mag nat[UNI00fc]rlich normales\nEssen, aber auch ungew[UNI00f6]hnliches.")
	else
		event.MesMake_2(0, "Ich werde der beste Koch\nder Welt, und wenn's soweit ist,\nisst du immer gratis bei mir.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1ada8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Na, was Gutes entdeckt?<page>W[UNI00e4]hrend du Maschinen und Ger[UNI00e4]te\nerfindest, erfinde ich\nneue Kochrezepte.<page>Ich versuche st[UNI00e4]ndig, Delikatessen\nzu schaffen, die noch\nnie jemand gegessen hat."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1af98(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Ah, das passt ja bestens!\nIch wollte mit dir reden.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Du wei[UNI00df]t ja sicher, dass\nich f[UNI00fc]r meine Forschungen auch\nS[UNI00fc][UNI00df]igkeiten aus aller Welt mache."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Es gibt ein Gericht\nnamens Castagnaccio,")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "f[UNI00fc]r das man Castarna braucht.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Diese Castarna wachsen\nauf den gleichen\nB[UNI00e4]umen wie Kastanien.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Da dachte ich, ich nehme einfach\nKastanien, aber es ist\nmerkw[UNI00fc]rdig - die sind [UNI00fc]berall ausverkauft."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Der B[UNI00fc]rgermeister soll alle\ngekauft haben. Kannst du mir helfen?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_1b6e4(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Hast du Kastanien bekommen?")
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
		event.MesMake_2(0, "Du kannst also nicht helfen.<page>Tja, dann vergesse ich das\nCastagnaccio besser.")
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
		"Ja, genau die. Vielen Dank.<page>Jetzt kann ich mal Castagnaccio machen.<page>Du kannst probieren, wenn's\nfertig ist."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Kann ich mich denn revanchieren?<page>Wie? Ich soll dich begleiten?<page>Ha ha! Nat[UNI00fc]rlich mach ich das.<page>Warum hast du nicht gleich gefragt?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1bd8c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Ich k[UNI00f6]nnte dir nie\netwas abschlagen.")
	else
		event.MesMake_2(0, "Ich werde der beste Koch\nder Welt, und wenn's soweit ist,\nisst du immer gratis bei mir.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1bfd4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1a9f0(arg0, arg1)
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
		helper_1a9f0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1ada8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1af98(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1b6e4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1bd8c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1c360(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Hi! Bist du Max'\nFreundin?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Deine Haarfarbe ist ungew[UNI00f6]hnlich.\nWie Eriks, nur anders ...<page>Deine Haare sind sch[UNI00f6]n,\nso wie Juwelen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1c630(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c360(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c360(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Du warst au[UNI00df]erhalb der Stadt,\nstimmt's, Max?<page>Streite es nicht ab.\nIch wei[UNI00df], dass es stimmt."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1c868(arg0: s32, arg1: s32)
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
		helper_1c360(arg0, arg1)
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
		"Ich w[UNI00fc]rde ja gern helfen, aber\nK[UNI00e4]mpfe sind gef[UNI00e4]hrlich\nund man wird schmutzig."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Und ich m[UNI00f6]chte niemand nerven.\nTut mir Leid, ich muss passen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Aber es muss viel Interessantes\nau[UNI00df]erhalb der Stadt geben.<page>Ich frag mich, wie die B[UNI00e4]ume\naussehen und was f[UNI00fc]r Blumen es gibt."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Wenn du eine interessante Blume\nsiehst, machst du mir ein Foto?\nIch m[UNI00f6]chte sie so gern sehen."
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
		"[(!)]Diesmal hat sie abgelehnt, aber wenn\n   du ihr ein Foto zeigst, das sie\n   interessiert, gibt sie wohl nach."
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
local function helper_1cfec(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1c360(arg0, arg1)
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
			"Hast du eine ungew[UNI00f6]hnliche\nBlume fotografiert?<page>Ich kenne viele Blumen - wenn's\nnichts Besonderes ist,\ninteressiert es mich nicht."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Hast du eine seltene Blume\nfotografiert? Zeig her, zeig her!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Wow - wie toll! So sehen also\ndie Blumen dort drau[UNI00df]en aus.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Hmm ... Was soll ich machen?<page>Oh, na gut! Nimm mich mit!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1d82c(arg0: s32, arg1: s32)
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
			helper_1c360(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "Aber geh nirgends hin,\nwo's zu gef[UNI00e4]hrlich ist.")
	else
		event.MesMake_2(0, "Endlich f[UNI00e4]hrt die Blackstone-\nBahn auf der ganzen Welt.\nDas ist so aufregend!")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1db1c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c630(arg0, arg1)
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
		helper_1c630(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1c868(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1cfec(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1d82c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1de00(arg0: s32, arg1: any)
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
			"Vielleicht liegt's an mir, aber\ndu erinnerst mich sehr an Elena.<page>Ich wei[UNI00df] nicht, woran es liegt,\naber du bist anders als die\nanderen Leute in der Stadt."
		)
	else
		event.MesMake_2(0, "Die Zelmit-Mine ist unheimlich.\nDort musst du immer\nwachsam bleiben.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1e0a8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Wenn du Probleme hast,\nfrag ruhig immer mich.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1e1e8(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Falls du etwas brauchst,\nhelfe ich gern so gut ich kann.<page>Verlass dich auf mich.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, " ...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ich wei[UNI00df] nicht, ob du helfen\nkannst ...<page>Aber h[UNI00f6]r dir das an.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Ich arbeite seit 30 Jahren\nhart in diesem Haus.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Ich mache sonst nichts, aber\nmein Hobby ist Lesen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Es gibt ein kostbares, seltenes\nBuch, das momentan versteigert wird.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "Alle wollen es haben.\nIch denke, ein Gebot von etwa\n1000 Gilda m[UNI00fc]sste reichen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"Aber so viel Geld habe ich nicht,\nund wenn ich meinen Meister frage, wird\ner wom[UNI00f6]glich sauer und k[UNI00fc]ndigt mir."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Du bist meine einzige Hoffnung.<page>Aber das hei[UNI00df]t nicht, dass\nich dir nicht helfe, wenn\ndu mir nicht hilfst."
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
		"[(!)]Egal was er sagt - Stewart\n   hilft dir wohl nur f[UNI00fc]r 1000 Gilda.\n   Tja, dann spar mal sch[UNI00f6]n!"
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
local function helper_1ec84(arg0: s32, arg1: s32)
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
			helper_11e3c()
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
				"Mit dem Betrag brauche ich\ngar nicht erst mitzubieten.<page>Ich brauche 1000 Gilda.\nBitte versuch es!"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(0, "Du wirst es nicht glauben!<page>Der Preis ist auf\n1200 Gilda gestiegen.")
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(0, "Es tut mir sehr Leid, aber\nkannst du auch 1500 Gilda besorgen?")
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
				"Wir d[UNI00fc]rfen keine Zeit verlieren,\nsonst kauft es jemand anderes.<page>Besorg mir so schnell wie\nm[UNI00f6]glich 1500 Gilda!"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"Es ist schrecklich!\nJemand will 1800 Gilda bieten!<page>Wenn ich nicht etwa 2000 Gilda\nbiete, bekomme ich es nie."
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
				"Wir d[UNI00fc]rfen keine Zeit verlieren,\nsonst kauft es jemand anderes.<page>Besorg mir so schnell wie\nm[UNI00f6]glich 2000 Gilda!"
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Na, Kleiner, hast du meine\n2000 Gilda zusammen?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Es geh[UNI00f6]rt dir.\nIch halte es f[UNI00fc]r Verschwendung.")
		var4 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"Na klar - 2000 Gilda sind viel Geld,\ndas verschenkt man nicht leicht.\nSelbst reiche Jungs wie du nicht ...<page>Na gut, vergiss es!\nAber die Auktion l[UNI00e4]uft noch.\nIch warte, egal wie lang ..."
			)
			helper_403f0e66(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "Vielen, vielen Dank.<page>Ich gehe direkt zur Auktion!")
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
	event.MesMake_2(0, "Vielen Dank.\nIch habe es ersteigert.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"Ich habe hoch geboten, und\nalle sind ausgestiegen -\nich hab's f[UNI00fc]r 1400 Gilda bekommen!"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Du bekommst 600 zur[UNI00fc]ck.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(0, "Und ab jetzt arbeite ich,\num dir den Rest zur[UNI00fc]ckzuzahlen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(0, "Ich wei[UNI00df], wie anstrengend das war.\nIch revanchiere mich gern,\nwann immer du willst.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_202dc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Mein neues Buch?\nIch hab's noch nicht gelesen.<page>Es einfach nur zu haben\nmacht mich schon gl[UNI00fc]cklich."
		)
	else
		event.MesMake_2(0, "Die Zelmit-Mine ist unheimlich.\nDort musst du immer\nwachsam bleiben.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_20554(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1de00(arg0, arg1)
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
		helper_1de00(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1e0a8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1e1e8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1ec84(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_202dc(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_208e0(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Bitte h[UNI00f6]r auf, Max in\nGefahr zu bringen.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Wenn ich nur einen Kratzer an\nihm finde, verzeih ich dir das nie!")
	else
		event.MesMake_2(0, "Ich bete f[UNI00fc]r deine Sicherheit ...")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_20c68(arg0: s32, arg1: s32)
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
		"Zurzeit bin ich hier Magd,\naber seit meiner Kindheit tr[UNI00e4]ume\nich davon, Schneiderin zu werden."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Tr[UNI00e4]ume werden nie wahr,\ndeshalb nenne ich es einen Traum.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_20f48(arg0: s32, arg1: s32)
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
		"Aha ... Ich w[UNI00fc]rde dir sehr\ngern helfen. Mehr\nals gern sogar.<page>Aber ich habe einfach\nkein Selbstvertrauen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Ich gebe immer auf halbem Weg\nauf - ich hab noch nie etwas\nzu Ende gebracht.<page>Als Kind wollte ich Schneiderin\nwerden und habe viel ausprobiert,\naber ich habe nie was fertig gen[UNI00e4]ht."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Wenn ich mitk[UNI00e4]me, w[UNI00e4]re ich\nbestimmt nur im Weg.<page>Tut mir Leid, aber - nein."
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
		"[(!)]Oh Mann, Adel hat gar kein\n   Selbstvertrauen. Das ist nicht\n   gut. Bring sie wieder zum N[UNI00e4]hen."
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
local function helper_21574(arg0: s32, arg1: s32)
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
		"Ja, wenn ich's wieder versuche\nund diesmal etwas schaffe,\nk[UNI00f6]nnte ich wieder an mich glauben."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Aber ich habe keine Materialien.<page>K[UNI00f6]nntest du sie mir holen?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ich brauche nur starken\nStoff, Tierhaut und einen\nKupferklumpen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_21964(arg0: s32, arg1: s32)
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
			"Ohne Materialien\nkann ich nichts n[UNI00e4]hen.<page>Ich brauche starken Stoff,\nTierhaut und einen Kupferklumpen.<page>Tut mir Leid, dass\nich so anstrengend bin."
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
	event.MesMake_2(0, "Hier, nimm die!\nIch halt's trotzdem f[UNI00fc]r\nVerschwendung.")
	var5 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "Ohne Materialien\nkann ich nichts n[UNI00e4]hen.")
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
	event.MesMake_2(0, "Vielen Dank! Jetzt\nversuche ich etwas zu n[UNI00e4]hen!<page>Das lasse ich nicht verkommen.")
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
local function helper_22398(arg0: s32, arg1: s32)
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
			helper_e300(var2, 1)
		end
		if at <= 6 then
			helper_136a94b8(1)
		end
		if at <= 7 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_11e3c()
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
	event.MesMake_2(0, "Ah, Max! Ich hab etwas gen[UNI00e4]ht!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Ich wollte deine Materialien\nnicht verschwenden,\nund das hat mich motiviert.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Ich bin nicht zufrieden damit,\naber w[UNI00fc]rdest du es trotzdem tragen?")
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
	helper_e300(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Ach, ich bin so froh, dass\nich etwas fertig bekommen habe.<page>Jetzt bin ich viel\nzuversichtlicher.<page>Ich werde mir alle M[UNI00fc]he geben,\nalso nimm mich bitte mit."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_22aa4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Wie passt es denn?<page>Sag die Wahrheit!")
	else
		event.MesMake_2(0, "Ich bete f[UNI00fc]r deine Sicherheit ...")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_22cbc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_208e0(arg0, arg1)
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
				helper_21964(arg0, arg1)
			end
			if at <= 6 then
				helper_22398(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_208e0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_20c68(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_20f48(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_21574(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_21964(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_22398(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_22aa4(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_23fb4(arg0: s32, arg1: s32)
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
			"Du bist das M[UNI00e4]dchen, das in\nletzter Zeit bei Max ist.<page>Ich erkenne einen guten\nMann, wenn ich ihn sehe."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Wenn ich etwas j[UNI00fc]nger w[UNI00e4]re,\nw[UNI00fc]rde ich ihn mir schnappen.")
	else
		event.MesMake_2(0, "Wenn du Lust auf Brot hast,\nwei[UNI00df]t du ja, wo ich bin.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2439c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Das Wichtigste in diesem Gesch[UNI00e4]ft\nist das Vertrauen der Kunden.<page>Das darf man nie\neinfach voraussetzen."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2452c(arg0: s32, arg1: s32)
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
			helper_e300(300, 20)
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
		"Du willst, dass ich\nmitkomme?<page>Ich bin nur eine B[UNI00e4]ckerin,\naber wenn du mich brauchst,\nhelfe ich gern."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Oh, aber zuerst habe ich eine\nLieferung f[UNI00fc]r Morton.<page>K[UNI00f6]nntest du diese 20 Brotlaibe\nf[UNI00fc]r mich zu Mortons Laden bringen?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "W[UNI00e4]hrend du das erledigst,\npacke ich f[UNI00fc]r die Reise.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_e300(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_136a94b8(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Was um alles in der\nWelt will er mit 20 Laiben?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_24aec(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(0, "Tut mir Leid, ich bin\nnoch nicht soweit.<page>Gibst du mir noch\netwas Zeit?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "[UNI00dc]brigens, warst du schon\nf[UNI00fc]r mich bei Morton?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Was! Wie kann er so\nr[UNI00fc]cksichtslos sein?<page>Na ja,\nnimm du sie.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Vergessen wir's,\nbrechen wir auf.<page>Und wo soll's\nhingehen?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_11e3c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_250dc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Na komm, Max,\nbrechen wir auf.<page>Wo gehen wir\ndenn hin?")
	else
		event.MesMake_2(0, "Wenn du Lust auf Brot hast,\nwei[UNI00df]t du ja, wo ich bin.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_25314(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_23fb4(arg0, arg1)
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
		helper_23fb4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2439c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_2452c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_24aec(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_250dc(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_14554(arg0: s32, arg1: any)
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
			"Ich mag eigentlich keine Frauen,\ndie mit Schwertern wedeln.<page>Die besten Frauen sind die\ndamenhaften. Adel zum Beispiel."
		)
	else
		event.MesMake_2(0, "Falls ich dir irgendwie helfen\nkann, frag mich ruhig.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_147cc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Diese Stadt ist zu friedlich -\nich hab nichts zu tun.<page>Ich wei[UNI00df] nat[UNI00fc]rlich, dass das gut\nist, aber trotzdem ..."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1496c(arg0: s32, arg1: s32)
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
		"Hallo, Max.\nTut mir Leid, ich bin\ngerade sehr besch[UNI00e4]ftigt.<page>Ich k[UNI00fc]mmere mich um wichtiges\nMaterial, mit dem ich diese Stadt\nsichern kann."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Falls es nicht dringend ist,\nhat es vielleicht Zeit bis morgen?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_14c8c(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Klar, ich versuch's.\nIch pack's nicht.")
	var2 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(0, "Na gut ...<page>Gut, wenn du's wieder probieren\nwillst, sag Bescheid. Ich warte.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "Auf die Pl[UNI00e4]tze, fertig,\nlos!")
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
local function helper_15230(arg0: s32, arg1: s32)
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
			helper_14c8c(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "He, Max, suchst du mich?<page>Ich hab auf dich gewartet.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Die Burgmauer sch[UNI00fc]tzt diese\nStadt recht gut.<page>Wir m[UNI00fc]ssen jetzt rausgehen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Es ist gut, dass du immer\nan Maschinen bastelst,\naber wie stark bist du wohl?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Beim K[UNI00e4]mpfen geht's um\nSchnelligkeit und Beinarbeit.<page>Wenn du langsamer bist als\nich, bringt es nichts."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Machen wir einen kleinen Test.\nLauf zum Boot am See und zur[UNI00fc]ck.<page>Mein Rekord ist 2 Min., 1 Sek.\nWenn du langsamer bist,\nbringt es nichts."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "Wie w[UNI00e4]r's, probierst du's mal?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_14c8c(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_158e4(arg0: s32, arg1: s32)
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
				helper_14c8c(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_14c8c(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_14c8c(arg0, arg1)
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
				helper_14c8c(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_11e3c()
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
		event.MesMake_2(0, "Hallo, Max.\nWillst du nochmal probieren?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_14c8c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(0, "He! Du warst nicht beim Boot,\noder? Du wolltest mich\ndrankriegen! Mogeln gilt nicht.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "Versuchst du's noch mal?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_14c8c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "He, nicht mogeln!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Versuchst du's noch mal?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_14c8c(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "Oh, da bist du ja wieder!\nGut,<page>sehen wir mal\nnach der Zeit!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "Oh Mann!\n[数値１] Min. [数値２] Sek. [数値３] ist\nzu langsam.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(0, "Versuchst du's noch mal?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_14c8c(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(0, "Oh!\n[数値１] Min. [数値２] Sek. [数値３]\nist keine schlechte Zeit!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Du bist schneller als du aussiehst.\nDann verm[UNI00f6]beln wir zusammen\ndie Fieslinge!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_16524(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Du bist viel schneller\nals du aussiehst.\nDu [UNI00fc]berraschst mich!")
	else
		event.MesMake_2(0, "Falls ich dir irgendwie helfen\nkann, frag mich ruhig.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1675c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14554(arg0, arg1)
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
		helper_14554(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_147cc(arg0, arg1)
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
		helper_1496c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_15230(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_158e4(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_16524(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_256a0(arg0: s32, arg1: any)
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
			"Du hast mich im Zirkus gesehen?\nNicht schlecht, was?<page>Es ist weniger mein Beruf\nals mein Hobby."
		)
	else
		event.MesMake_2(0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_25908(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mein Laden ist spezialisiert\nauf Klingen.<page>Ich habe auch Schusswaffen,\naber eigentlich mag\nich sie nicht besonders."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_25a98(arg0: s32, arg1: s32)
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
			helper_e300(44, 1)
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
	event.MesMake_2(0, "Du bist Monica,\nstimmt's?<page>Du sollst ganz gut mit\nSchwertern umgehen k[UNI00f6]nnen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Aber du musst wissen, dass\nSchwerter keine Spielzeuge sind.<page>Du musst dar[UNI00fc]ber nachdenken,\nwas du vor dir hast."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Wenn du ein Schwert um etwa\nzwei Stufen hochstufen kannst, glaube\nich dir, dass du Talent hast."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Warum f[UNI00e4]ngst du nicht mit\ndiesem Sto[UNI00df]schwert an?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_e300(44, 1)
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
		"[(!)]Um Milanes Respekt zu gewinnen,\n   musst du offenbar das\n   Sto[UNI00df]schwert um 2 Stufen hochstufen"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]Du kannst auch Waffen kaufen\n   oder finden. Bring ihr eine\n   starke Waffe, und Milane hilft dir."
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
local function helper_2629c(arg0: s32, arg1: s32)
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
			helper_11e3c()
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
			"Was ist das f[UNI00fc]r ein Schwert?\nDu kannst also nur gro[UNI00df] t[UNI00f6]nen?<page>Verschwinde hier!\nDu bist nur im Weg."
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
		"Wow, das ist ein sehr\nbeeindruckendes Schwert.<page>Tut mir Leid, dass ich dich\nauf die Probe stellen musste."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Aber K[UNI00e4]mpfe an der Seite\nvon Anf[UNI00e4]ngern sind eben gef[UNI00e4]hrlich.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Aber davor brauche ich bei dir\nkeine Angst zu haben.<page>Dann ziehen wir\ngemeinsam in den Kampf."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_26958(arg0: s32, arg1: s32)
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
			"Das Glitzern eines guten\nSchwertes ist einfach unvergleichlich.<page>Es raubt einem den Atem."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Ich verstehe nicht, wie man\nimmer nur Steine polieren kann.")
	else
		event.MesMake_2(0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_26d10(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_256a0(arg0, arg1)
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
		helper_256a0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_25908(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_25a98(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2629c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_26958(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_2709c(arg0: s32, arg1: any)
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
		event.MesMake_2(0, "Bist du eine Freundin von Max?<page>Na ja, pass auf dich auf.")
	else
		event.MesMake_2(
			0,
			"Ab jetzt helfe ich Need und Cedric,\ndie Welt wieder aufzubauen.\nDabei m[UNI00fc]ssen wir zusammenarbeiten."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_27304(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Mit Maschinen kennst du dich\naus, aber willst du nicht langsam\nmal etwas [UNI00fc]ber Bergbau lernen?"
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_27484(arg0: s32, arg1: s32)
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
			helper_e300(24, 1)
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
	event.MesMake_2(0, "Cedric sagt, du w[UNI00e4]rst in\nletzter Zeit viel\nunterwegs gewesen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Du kannst vieles gut,<page>aber andererseits bringst du\nnie etwas zu Ende.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Deshalb f[UNI00e4]llt es mir schwer,\ndich einfach ernst zu nehmen,\nwenn du mich um Hilfe bittest."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Ich hab's - stufe dieses\nTrompeten-Gewehr zu einem\nKlingel-Abzug hoch!<page>Schaffst du das?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_e300(24, 1)
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
		"[(!)]Damit Gerald dich akzeptiert,\n   musst du ihm einen\n   Klingel-Abzug bringen.<page>[(!)]Du kannst seine Waffe\n   hochstufen, eine andere kaufen\n   oder eine aus dem Verlies holen."
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
local function helper_27bb8(arg0: s32, arg1: s32)
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
			helper_11e3c()
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
			"Was ist denn los?\nGibst du schon wieder auf?<page>Ich bin entt[UNI00e4]uscht.\nKommt das davon, wenn man\nimmer an Maschinen bastelt?"
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
		"Oh! Du scheinst auch mit Waffen\nnicht schlecht zu sein!<page>Ich muss dich nicht mal\nschie[UNI00df]en sehen. Ich sehe schon, wie\nprofessionell du sie h[UNI00e4]ltst."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Na gut, ich helfe dir.\nAber ich tu's nicht f[UNI00fc]r dich.<page>Wenn die Stadt in Gefahr ist,\nkann ich nicht einfach\ntatenlos zusehen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_28158(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Feuerwaffen sind keine Spielzeuge.<page>Sei sehr vorsichtig mit\nihnen, sonst verletzt du dich."
		)
	else
		event.MesMake_2(
			0,
			"Ab jetzt helfe ich Need und Cedric,\ndie Welt wieder aufzubauen.\nDabei m[UNI00fc]ssen wir zusammenarbeiten."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_283e0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2709c(arg0, arg1)
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
		helper_2709c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_27304(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_27484(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_27bb8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_28158(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_2876c(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Grummel, grummel ...")
	helper_cd6723ca(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "... 1212,<page>Nein, nein, es war bestimmt 1122.<page>Oder vielleicht auch 1010.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Grummel, grummel ...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		'[(!)]Wenn er nicht einmal Notiz\n  von dir nimmt, wenn du "Hallo." sagst, hat er \n   wohl ernsthafte Probleme.<page>[(!)]Versuch\'s doch sp[UNI00e4]ter nochmal.\n   Vielleicht kannst du ihm zur\n   Hand gehen oder ein Ohr leihen.'
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_28bec(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Grummel, grummel ...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Was soll das hei[UNI00df]en, was\nmurmele ich da?<page>Ich versuche, mich an die\nSafe-Kombination zu erinnern."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Was soll das hei[UNI00df]en,\nwelcher Safe?<page>Der Safe hinter dem Bild\nin meinem B[UNI00fc]ro nat[UNI00fc]rlich ..."
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
		"Ah, du hast mich erschreckt!<page>Oh, Mist!<page>Jetzt hab ich mein gr[UNI00f6][UNI00df]tes\nGeheimnis ausgeplaudert!<page>Na ja, jetzt wei[UNI00df]t du's.<page>Vielleicht hilfst du mir\nja, ihn zu [UNI00f6]ffnen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Ich hab ein gro[UNI00df]es Problem -\nich habe die Kombination f[UNI00fc]r\nden Safe vergessen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Es sind vier Ziffern. Deshalb\nhabe ich Claires Geburtstag genommen -\nich dachte, den vergess ich nie."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Wie konnte ich ihn vergessen ...<page>Ich bin ein schrecklicher Vater!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Need scheint sehr besorgt.\n   H[UNI00f6]r zu, was er [UNI00fc]ber Claires Ge-\n   burtstag sagt und knack den Code!"
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
local function helper_295fc(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(0, "Ich habe ihr mal eine Brosche\nmit ihrem Sternzeichen geschenkt.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Holly hat sie ausgesucht, deshalb\nwei[UNI00df] ich's nicht mehr genau,\naber es war ein<page>vierbeiniges Tier ..."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"Was f[UNI00fc]r Geburtstagsgeschenke\nhabe ich ihr gemacht?<page>Hmm ... Viele M[UNI00e4]ntel und\nSchals, glaube ich.<page>Ich wei[UNI00df] nie, was ich nehmen\nsoll. Es ist jedes Jahr schwierig."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"Oh ja! An Claires Geburtstag wird\nimmer der M[UNI00fc]ll abgeholt - sowohl\nBiom[UNI00fc]ll als auch Restm[UNI00fc]ll.<page>Und meine Aufgabe ist\nes, den M[UNI00fc]ll rauszubringen."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"Restm[UNI00fc]ll wird an Tagen geholt,\ndie durch 7 teilbar sind,<page>Biom[UNI00fc]ll an Tagen, die\ndurch 3 teilbar sind."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "Aber so etwas vergisst\nman doch nicht, oder?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"Ich hab's! Des R[UNI00e4]tsels L[UNI00f6]sung!\nDie Kombination hei[UNI00df]t ...<page>Ich wei[UNI00df] nicht ...\n Lauschen wir noch etwas."
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
	event.SetMenuEtc(0, "Gib den Geheim-Code ein.", "2112", 0)
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
		event.MesMake_2(0, "Hmm, es geht nicht auf ...<page>Au weia - da sind wirklich\nwichtige Dokumente drin ...")
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
	event.MesMake_2(0, "[UNI00c4]h ... hmm ...\n2,<page>1,<page>1,<page>2 ...")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "Juhuu!<page>Toll,\nes funktioniert!")
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
	event.MesMake_2(0, "Super! Jetzt komme ich an meine\nwichtigen Dokumente heran!<page>Oh, vielen Dank!")
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
		"Was das f[UNI00fc]r Dokumente sind?<page>Mit ihnen soll mein Stellvertreter\nMorton arbeiten, w[UNI00e4]hrend ich weg bin.<page>Nat[UNI00fc]rlich ist es unangenehm,\naber es wird bestimmt klappen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"Gut, dann bin ich bereit\naufzubrechen.<page>Cedric hat mir alles erz[UNI00e4]hlt.<page>Na komm schon, auf geht's."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_2b5ec(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Und trenne immer sch[UNI00f6]n den\nM[UNI00fc]ll und denk an die M[UNI00fc]llabfuhr, ja?")
	else
		event.MesMake_2(
			0,
			"Nur so zwischen dir und mir - die\nZelmit-Mine ist nicht ungef[UNI00e4]hrlich.\nMach keine Dummheiten."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2b864(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2876c(arg0, arg1)
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
		helper_2876c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_28bec(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_295fc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2b5ec(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2c520(arg0: s32, arg1: any, arg2: s32)
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
		event.MesMake_2(0, "Ich bete, dass die Welt ab\nheute ewigen Frieden genie[UNI00df]t.")
	else
		event.MesMake_2(0, "Wer f[UNI00fc]r eine gute Sache k[UNI00e4]mpft,\nbraucht Weisheit.")
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2c78c(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Wirklich? Ich soll dir helfen?<page>Dann l[UNI00f6]se mein R[UNI00e4]tsel.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Die Kerzen dieser Kirche werden \nvon einem Mechanismus gesteuert.<page>Sind sie an, so l[UNI00f6]scht er sie,\nwenn sie aus sind, entz[UNI00fc]ndet er sie.<page>Wenn sich eine Kerze [UNI00e4]ndert,\n[UNI00e4]ndern sich ihre Nachbarn mit."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Wenn du alle Kerzen l[UNI00f6]schst,\nbeweist das deine Weisheit.\nDann komme ich mit.<page>Wenn du es l[UNI00f6]st, prima! Wenn nicht,\nmusst du verstehen, dass ich\ndir nicht helfen kann."
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
		"[(!)]Noch etwas Kniffliges. Versuch's\n   ein paar Mal, und merke dir,\n   was du dabei lernst."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Wenn du wieder in die Kirche\n   kommst, sind die Kerzen wieder normal.\n   Keine Angst vor Fehlversuchen!\n   Es k[UNI00f6]nnte ganz leicht sein."
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
local function helper_2bb48()
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
local function helper_2cf28(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_2bb48()
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_11e3c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_2bb48()
	if 0 < var2 then
		event.MesMake_2(0, "Du scheinst noch nicht gut\ngenug zu sein.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Ich setze gro[UNI00df]e Hoffnungen in dich,\naber ich f[UNI00fc]rchte, momentan kann\nich dir nicht helfen."
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
		"Gut gemacht.\nWunderbar.<page>Du wirst meine Erwartungen\nsicher nicht entt[UNI00e4]uschen.<page>Ich hab's versprochen, nicht wahr?\nIch begleite dich."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2d448(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c520(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2d4e0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2c520(arg0, arg1, 0)
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
		helper_2c520(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2c78c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2cf28(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2d448(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2d7d0(arg0: s32, arg1: any)
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
	event.MesMake_2(0, "Warum fehlt mir der Mond so sehr?<page>Ich frage mich, ob ich\nwohl von dort stamme ...")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2d940(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Ja, ich komme gern mit -\naber gibt's dort auch einen Mond?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Ach ja? Vielleicht sagst du das nur.\nIch wei[UNI00df], dass Menschen oft l[UNI00fc]gen.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Nein, ich hab's mir anders\n[UNI00fc]berlegt. Ich warte hier, bis der Mond kommt.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Vielleicht ist ihm fr[UNI00fc]her\n   etwas passiert - Rufio\n   vertraut Menschen offenbar nicht."
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Du musst Rufios Vertrauen\n   gewinnen. Vielleicht w[UNI00fc]rde\n   ein Foto des Mondes reichen."
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
local function helper_2dfac(arg0: s32, arg1: s32)
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
			helper_11e3c()
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
			"Ich dachte, du w[UNI00e4]rst vielleicht\nanders, aber Menschen sind\neben Menschen.<page>Egal. Ich bin's gewohnt,\ndass ihr Menschen immer l[UNI00fc]gt."
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
		"Wow, wie toll! Auf dem Foto ist\nein Mond.<page>Jetzt kann ich ihn immer\nund [UNI00fc]berall ansehen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Mitkommen?<page>Klar komm ich mit.\nIch hab sonst nichts\nzu tun.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2e4dc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Du hast mir dieses Bild\ndes Mondes gegeben.\nDu bist ein guter Mensch.")
	else
		event.MesMake_2(
			0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, k[UNI00f6]nnen wir\nlauter coole neue Orte besuchen."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2e754(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2d7d0(arg0, arg1)
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
		helper_2d7d0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2d940(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2dfac(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2e4dc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2ea38(arg0: s32, arg1: any)
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
		"Angeln ist mein Hobby.<page>Ich tr[UNI00e4]ume davon, einmal einen\nMardan Garayan zu fangen.<page>Ich respektiere nur Leute,\ndie gro[UNI00df]e Fische fangen."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2ebe8(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Ich soll dir einen Gefallen tun?<page>Warte - h[UNI00f6]r mich erst an.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Ich rede nur mit Leuten, die\nich respektiere.<page>Und ich respektiere nur Leute,\ndie gr[UNI00f6][UNI00df]ere Fische geangelt\nhaben als ich."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Mein gr[UNI00f6][UNI00df]ter Fang war\nein 60-cm-Nonky.<page>Bist du beeindruckt?\nWenn du gegen mich antreten\nm[UNI00f6]chtest, bin ich immer bereit!"
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
		"[(!)]Um ihn zu [UNI00fc]berzeugen, musst\n   du wohl einen Nonky fangen, der\n   l[UNI00e4]nger ist als 60 cm. Du schaffst es!"
	)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]Versuch doch mal, im\n   See von Palm Brinks zu angeln.")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_2f2c4(arg0: s32, arg1: s32)
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
			helper_11e3c()
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
			"Hey, wetten, dass du noch nie\neinen Nonky gefangen hast?<page>Ha ha. Du musst ein ganz\nmieser Angler sein!"
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
		event.MesMake_2(0, "Ha ha! Du hast nur ein\n [数値１]-cm-Baby geangelt!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "Du verdienst meine Hilfe nicht!<page>Fang lieber von vorn an.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "... Oh,ich hab dich untersch[UNI00e4]tzt!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Tja, ich bin ein Mann.\nMir muss man nichts zweimal sagen.<page>Ich h[UNI00f6]re dich wie abgemacht an."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "Sprich, so viel du willst!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_2fb2c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"[UNI00c4]hm, es muss ja nicht jetzt sein,\naber vielleicht verr[UNI00e4]tst du mir\neines Tages deine Angel-Tricks."
		)
	else
		event.MesMake_2(
			0,
			"Ich bin schon ganz gespannt auf\ndie neuen Angelpl[UNI00e4]tze in der\nganzen Welt. Das wird so toll!"
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2fdc4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2ea38(arg0, arg1)
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
		helper_2ea38(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2ebe8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2f2c4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2fb2c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_300a8(arg0: s32, arg1: any)
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
	event.MesMake_2(0, "Das Firbit-Volk gew[UNI00e4]hrt\nnur denen Hilfe,\ndie etwas besser k[UNI00f6]nnen als sie.")
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_30218(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Das Firbit-Volk gew[UNI00e4]hrt\nnur denen Hilfe,\ndie etwas besser k[UNI00f6]nnen als sie.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Was Fische angeht, bin ich\nsehr selbstbewusst.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Ich hab geh[UNI00f6]rt, dass einige Menschen\nihre Fische in einem Wettkampf\ngegeneinander antreten lassen.<page>Wenn du einen Fisch hast,\nkannst du doch versuchen,\ndas Wettschwimmen zu gewinnen!<page>Wenn du das schaffst, wei[UNI00df]\nich, dass du meine Hilfe\nverdienst."
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
		"[(!)]Sie redet wohl vom Flossen-\n   Fieber. Gewinne die Anf[UNI00e4]nger-\n   Klasse, dann hilft sie vielleicht!"
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
local function helper_30844(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "Man sagt, ein Fisch ist\nwie sein Besitzer.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Mit dem Besitzer eines so schwachen\nFisches spreche ich niemals.")
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
		"Ich hab's mir angesehen.\nEs war ein gutes Rennen.<page>So einen Fisch h[UNI00e4]tte ich\nselbst nicht z[UNI00fc]chten k[UNI00f6]nnen.<page>Bitte nimm mich mit dir.\nBitte bring mir bei, was du kannst."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_30d58(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Ich hoffe, dass ich auch einmal\nauf dem Siegertreppchen stehen werde.")
	else
		event.MesMake_2(
			0,
			"Ich w[UNI00fc]nschte nur, Fabio w[UNI00fc]rde\nsich auch f[UNI00fc]r andere Dinge\nals Angeln interessieren."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_30fd0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_300a8(arg0, arg1)
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
		helper_300a8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_30218(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_30844(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_30d58(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_31314(arg0: s32, arg1: s32)
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
	event.MesMake_2(0, "Mir geht's nicht gut in\nletzter Zeit.")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Dr. Dell war hier und hat mich\nuntersucht, aber er findet nichts.<page>Warum blo[UNI00df]?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_315d4(arg0: s32, arg1: s32)
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
		"Mir geht's in letzter Zeit nicht gut.<page>Eine Reise schaffe ich nicht.<page>Dr. Dell war hier und hat mich\nuntersucht, aber er findet nichts."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Aber selbst wenn ich nur stehe,\ndenke ich, ich kippe gleich um.<page>Es ist schwer zu erkl[UNI00e4]ren. Als\nob die Welt verzerrt w[UNI00e4]re."
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
			"Hmmm ...\nWenn Dr. Dell nicht wei[UNI00df], was los\nist, kann ich auch nichts weiter tun ..."
		)
		helper_403f0e66(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "Ich erkenne die Symptome.")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"In der Zeit, in der ich geboren\nwurde, ging es der Welt schlecht -\nes gab mehr Zeitverzerrungen\nals du dir vorstellen kannst."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"Das wirkte sich auf schwache\nund gebrechliche Menschen aus.<page>Leichten Menschen wurde schwindlig,\nund schwere konnten\neinfach nicht mehr stehen."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"Vielleicht bist du besonders\nempfindlich f[UNI00fc]r so etwas.<page>Selbst die wenigen Zeit-\nverzerrungen hier wirken auf dich."
	)
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "Wenn wir einige der nahe\ngelegenen Verzerrungen beseitigen,\ngeht's dir vielleicht besser.")
	helper_403f0e66(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Zeitverzerrungen beheben ... Spheda!\n   Wenn du etwa 10 Runden schaffst,\n   geht es Mina vielleicht besser."
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
local function helper_321e0(arg0: s32, arg1: s32)
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
			helper_11e3c()
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
		event.MesMake_2(0, "Mir geht's immer noch\nschlecht.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Vielleicht habe ich etwas\nganz Schlimmes?<page>Vielleicht kann selbst Dr. Dell\nmir jetzt nicht mehr helfen ..."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Hallo!<page>Wie es mir geht? Super!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Ich kann kaum glauben, wie gut\nes mir in letzter Zeit geht.<page>Jetzt scheint die Welt\nwieder in Ordnung zu sein."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"Oh ja, du wolltest etwas von mir.<page>Wenn ich helfen kann, tu ich's gern.<page>Du hast mir geholfen,\ndann helfe ich dir auch."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_32970(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Du hast mir geholfen, dann\nhelfe ich dir auch - aber bitte\nschlepp mich nicht zu Insekten!"
		)
	else
		event.MesMake_2(
			0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, muss\nich vielleicht auch mal hier raus."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_32be8(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_31314(arg0, arg1)
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
		helper_31314(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_315d4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_321e0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_32970(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_32eb4(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Ooh, Max! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	else
		event.MesMake_2(0, "Ooh, Monica! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "Das ist toll! Warum nimmst\ndu mich nicht mit?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_3325c(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Ooh, Max! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	else
		event.MesMake_2(0, "Ooh, Monica! Ich hab geh[UNI00f6]rt, du\nhast die Stadt letztens verlassen.")
	end
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Das ist toll! Warum nimmst\ndu mich nicht mit?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Du denkst bestimmt, ich bin nutzlos,\nweil ich ein M[UNI00e4]dchen bin.<page>Aber ich bringe den Leuten\nimmer viel Gl[UNI00fc]ck."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Wenn ich unterwegs bin, regnet\nes nie, und eine Los-Niete hab\nich noch nie gesehen.<page>Was meinst du?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Na gut.\nNein, tut mir Leid.")
	var3 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "Was? Sei nicht gemein!\nDu bist so fies!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Du bist bl[UNI00f6]d!<page>Du Dummkopf!<page>Du Idiot!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Du nimmst mich mit?<page>Das h[UNI00e4]tte ich nicht gedacht!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"Aber warum muss ich als Einzige\nfragen, wenn du all die anderen\nselbst um Hilfe bittest?<page>Wenn du einfach gefragt h[UNI00e4]ttest,\nh[UNI00e4]tte ich nat[UNI00fc]rlich geholfen."
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "Ich wei[UNI00df] - wenn du mich findest,\nhelf ich dir. Abgemacht?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Mit anderen Worten, wir\nspielen  Verstecken!<page>Gut, los geht's!")
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
		"[(!)]Na ja ... Du versuchst wohl besser,\n   Corinne zu finden. Sie hat sich\n   bestimmt in Palm Brinks versteckt."
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
local function helper_3439c(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "Oh! Du hast mich!<page>Aber findest du mich noch mal?")
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
		"Oh! Du hast mich ...<page>Ich hab keine Lust mehr.<page>Verstecken ist eigentlich\ntotal langweilig.<page>Na gut! Dann ziehen wir in\nunser Abenteuer!"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_34904(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Verstecken ist nur\nf[UNI00fc]r kleine Kinder.")
	else
		event.MesMake_2(
			0,
			"Mir machst du nichts vor. Ich\nwei[UNI00df], dass du alle m[UNI00f6]glichen tollen\nSachen gemacht hast. Erz[UNI00e4]hl mal!"
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_34b6c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_32eb4(arg0, arg1)
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
		helper_32eb4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_3325c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_3439c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_34904(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_34e50(arg0: s32, arg1: any)
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
		"...<page>Ah! Hallo!\nIch h[UNI00f6]re seit Kurzem schwer.<page>Ich verstehe dich nur, wenn\ndu ganz langsam sprichst."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_34fe0(arg0: s32, arg1: s32)
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
			helper_11e3c()
		end
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Wie bitte?<page>Kannst du nicht langsamer reden?")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(0, 'Bitte gib ein:"Komm mit mir." ', "Komm mit mir.", 0)
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
		event.MesMake_2(0, "Was redest du da?\nIch verstehe nichts ...")
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
		"Ein Abenteuer?\nDas w[UNI00e4]re sch[UNI00f6]n.<page>Aber was n[UNI00fc]tzt dir da\neine alte Frau wie ich?"
	)
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_11e3c()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_356a4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_34fe0(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_35730(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Was n[UNI00fc]tzt dir eine\nalte Oma wie ich?")
	else
		event.MesMake_2(
			0,
			'Wenn die Blackstone-Bahn fertig\nist, w[UNI00fc]rde ich gern mal\nzu den "Enden der Erde" fahren.'
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_35978(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_34e50(arg0, arg1)
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
		helper_34e50(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_34fe0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_356a4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_35730(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_23524(arg0: s32, arg1: s32)
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
		event.MesMake_2(0, "Oh, du hilfst\nPolly?<page>Toll.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Was ich mit\n20 Laiben will?<page>Ich mache heute mit ein\npaar Leuten K[UNI00e4]sefondue.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			'Um mit deinen "Erfindungen" zu\nsprechen - es ist eine Kombination<page>aus K[UNI00e4]se, Brot und Wein!'
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"Es ist super. Man isst viel,\ndeshalb brauche ich das Brot.<page>Aber ich wollte es eigentlich\nnicht hierher geliefert haben."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"Sag mal, Max, k[UNI00f6]nntest du es zu mir\nnach Hause bringen?<page>Du wei[UNI00df]t doch, wo das ist?\nBeim K[UNI00fc]rbisfeld."
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "Du wei[UNI00df]t, wo es ist, nicht?\nBeim K[UNI00fc]rbisfeld.")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "Abgesagt?\nWie schade!")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(
			0,
			"Dann brauche ich das Brot nicht.\nKannst du es f[UNI00fc]r mich zu Polly\nzur[UNI00fc]ckbringen?"
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "Tut mir Leid - kannst du Polly\ndas Brot f[UNI00fc]r mich zur[UNI00fc]ckbringen?")
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_35c5c(arg0: s32, arg1: s32)
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
				helper_14288(arg0, arg1)
			end
			if at <= 2 then
				helper_18bf4(arg0, arg1)
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
				helper_1bfd4(arg0, arg1)
			end
			if at <= 14 then
				helper_1db1c(arg0, arg1)
			end
			if at <= 15 then
				helper_20554(arg0, arg1)
			end
			if at <= 16 then
				helper_22cbc(arg0, arg1)
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
				helper_25314(arg0, arg1)
			end
			if at <= 21 then
				helper_1675c(arg0, arg1)
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
				helper_26d10(arg0, arg1)
			end
			if at <= 26 then
				helper_283e0(arg0, arg1)
			end
			if at <= 27 then
				helper_2b864(arg0, arg1)
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
				helper_2d4e0(arg0, arg1)
			end
			if at <= 32 then
				helper_2e754(arg0, arg1)
			end
			if at <= 33 then
				helper_2fdc4(arg0, arg1)
			end
			if at <= 34 then
				helper_30fd0(arg0, arg1)
			end
			if at <= 35 then
				helper_32be8(arg0, arg1)
			end
			if at <= 36 then
				helper_34b6c(arg0, arg1)
			end
			if at <= 37 then
				helper_35978(arg0, arg1)
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
		helper_14288(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 5 then
		helper_18bf4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Lass mich einkaufen.\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			var7 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_c698(0)
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
				helper_f7b8()
				if vm.skipping() then
					return skip(8)
				end
			end
		else
			event.MesMake_2(0, "Sei mein Freund!\nEinen Kn[UNI00fc]ller aufsp[UNI00fc]ren.")
			var8 = helper_4d397cfd(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_c698(0)
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
				helper_1a70c(arg0, arg1)
				if vm.skipping() then
					return skip(13)
				end
			end
		end
	end
	if var3 == 7 then
		helper_1bfd4(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 8 then
		helper_1db1c(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 10 then
		helper_20554(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 11 then
		helper_22cbc(arg0, arg1)
		if vm.skipping() then
			return skip(17)
		end
	end
	if var3 == 12 then
		var9 = event.GetQuestEtc(0, 0) or var9
		var10 = event.GetQuestEtc(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var11 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(18)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_25314(arg0, arg1)
				if vm.skipping() then
					return skip(19)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_f7b8()
			if vm.skipping() then
				return skip(20)
			end
		else
			helper_25314(arg0, arg1)
			if vm.skipping() then
				return skip(21)
			end
		end
	end
	if var3 == 14 then
		helper_1675c(arg0, arg1)
		if vm.skipping() then
			return skip(22)
		end
	end
	if var3 == 15 then
		var12 = event.GetQuestEtc(0, 0) or var12
		var13 = event.GetQuestEtc(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var14 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(23)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_26d10(arg0, arg1)
				if vm.skipping() then
					return skip(24)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_f7b8()
			if vm.skipping() then
				return skip(25)
			end
		else
			helper_26d10(arg0, arg1)
			if vm.skipping() then
				return skip(26)
			end
		end
	end
	if var3 == 16 then
		helper_283e0(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 17 then
		helper_2b864(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 18 then
		var15 = event.GetQuestEtc(0, 0) or var15
		var16 = event.GetQuestEtc(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Hallo.\nSei mein Freund!")
			var17 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(29)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_2d4e0(arg0, arg1)
				if vm.skipping() then
					return skip(30)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_f7b8()
			if vm.skipping() then
				return skip(31)
			end
		else
			helper_2d4e0(arg0, arg1)
			if vm.skipping() then
				return skip(32)
			end
		end
	end
	if var3 == 19 then
		helper_2e754(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 20 then
		helper_2fdc4(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 21 then
		helper_30fd0(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 23 then
		helper_32be8(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 24 then
		helper_34b6c(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 25 then
		helper_35978(arg0, arg1)
		if vm.skipping() then
			return skip(38)
		end
	end
	if var3 == 33 then
		var18 = event.GetQuestEtc(0, 8) or var18
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "Lass mich einkaufen.\nHallo.")
			var20 = helper_3000b46a(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(39)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_23524(arg0, arg1)
				if vm.skipping() then
					return skip(40)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_f7b8()
		if vm.skipping() then
			return skip(41)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"Ich hab in letzter Zeit Probleme,\ndie kleinen Teile zu sehen.<page>Ich werde wohl auch\nnicht j[UNI00fc]nger ..."
			)
		else
			event.MesMake_2(
				0,
				"Need und ich tr[UNI00e4]umen davon, dass\ndie Blackstone-Bahn den ganzen\nKontinent bef[UNI00e4]hrt.<page>Du hilft uns doch, oder?"
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
			event.MesMake_2(0, "Wenn ich nicht immer\nwas zu tun habe,\nwerde ich unausstehlich.")
		else
			event.MesMake_2(
				0,
				"Wenn sie Zelmit finden, bin ich\nauch besch[UNI00e4]ftigt. Dann w[UNI00fc]rde\nich buddeln, buddeln, buddeln!"
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
			event.MesMake_2(0, "Ich habe in letzter Zeit viel\nUngeziefer im Gefieder,\ndas juckt schrecklich.")
		else
			event.MesMake_2(
				0,
				"Wenn du Zelmit suchen willst,\nmach das ruhig. Aber\n[UNI00fc]beranstrenge dich nicht, Kleiner."
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
				"Ich liebe Schwarzpulver-Duft!\nDas ist echt mein Traumjob.<page>Aber mein Boss ist ziemlich\nstur und altmodisch.\nAch, na ja."
			)
		else
			event.MesMake_2(0, "Diese Abenteuer machen dir\neinen Riesenspa[UNI00df], was?")
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
				"Abgesehen davon, dass ich als\nGem[UNI00e4]lde zur Welt kam, bin\nich genau wie alle anderen."
			)
		else
			event.MesMake_2(0, "Ich hab ein dummes Gef[UNI00fc]hl bei der\nZelmit-Mine. Sei vorsichtig, ja?")
		end
		helper_30c30f62(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(46)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_106c0()
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
				helper_f7b8()
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
		helper_f7b8()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "Hey! Ab hier\nist abgesperrt.")
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
					"Sieh dir das an. Kaum zu\nglauben, dass das Ding\nfr[UNI00fc]her richtig gerast ist, was?<page>Ist es aber ... vor langer Zeit.<page>Ich tr[UNI00e4]ume davon, mit dem\nDing noch mal loszufahren. Darum\nhalte ich es auch in Schuss.<page>Wenn es je dazu kommt, kann\nich ihn sofort wieder\nauf die Gleise bringen."
				)
			else
				event.MesMake_2(
					0,
					"Du wei[UNI00df]t doch, dass man immer ver-\nsteift, wenn man zu selten trainiert.\nDas gilt f[UNI00fc]r Maschinen auch."
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
					"Hallo Max!\nDie Bahn f[UNI00e4]hrt schon seit\neiner Ewigkeit nicht mehr.<page>Aber ich k[UNI00fc]mmere mich\ntrotzdem immer um den Bahnhof."
				)
			else
				event.MesMake_2(
					0,
					"Der B[UNI00fc]rgermeister l[UNI00e4]sst die Bahn\nendlich wieder fahren. Aber\nnicht f[UNI00fc]r alle.<page>Oh Mann, ich w[UNI00fc]rde die\nLeute so gern einsteigen lassen ..."
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
					"Hi, Max. Wusstest du, dass der\nBahnhofsvorsteher mein Vater ist?\nWir k[UNI00fc]mmern uns um den Bahnhof.<page>Bis die Bahn eines Tages\nwieder fahren darf ..."
				)
			else
				event.MesMake_2(
					0,
					"Die Bahn f[UNI00e4]hrt!\nAber es wird etwas dauern, bis\nder Bahnhof wieder normal ist ..."
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
					"Ich verehre Monica seit langem\nheimlich, aber in letzter\nZeit war sie nicht hier.<page>Darum kann ich mich so schlecht\nauf die Arbeit konzentrieren."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(0, "He, Max!\nMonica ist zur[UNI00fc]ck, ja?\nDa werden sich alle freuen!")
				else
					event.MesMake_2(0, "Monica! Wie geht's dir?\nIch hab dich echt vermisst.")
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
					"Ich konnte gerade normal mit\nMonica reden, da ist sie\nverschwunden.<page>Komm schon,  Max,\nsag mir doch, wo sie ist!"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica ist zur[UNI00fc]ck.\nWie kann das sein?")
				else
					event.MesMake_2(0, "Monica, du bist zur[UNI00fc]ck!\nWie kann das sein?")
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
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_30c30f62(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_11d08()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_106c0()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_106c0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_386b4()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_35c5c(var1, player_chara)
		end
		if at <= 2 then
			helper_11d08()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_35c5c(var1, player_chara)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_11d08()
		if vm.skipping() then
			return skip(3)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_38c94

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3a1e0()
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_3a480()
		end
	end
	flag = event.GetFlag(103) or flag
	event.SetBitCtrl(1, if flag == 0 then 1 else 0)
	helper_38c94()
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
				helper_3a480()
				if vm.skipping() then
					return skip(1)
				end
			else
				helper_3a1e0()
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_3a480()
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
	helper_44dfc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_38b20()
	event.SetCnt(5, 3)
	helper_3a8c4()
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
			local _ = helper_38dbc()
		end
	end
	flag = event.GetFlag(103) or flag
	if flag == 0 then
		event.Initialize()
		event.SetMotion(0, "立ち")
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "Flotsam sucht noch nach mir.\nIch geh besser nicht zur[UNI00fc]ck nach\nPalm Brinks.")
		helper_c049c42a(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_38dbc()
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
			local _ = helper_38f78()
		end
		if at <= 3 then
			helper_3a480()
		end
		var2 = 0
		var6 = var6 + 1
	end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		helper_39990()
		if vm.skipping() then
			return skip(1)
		end
	else
		local t0 = helper_38f78()
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
				helper_3a480()
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
			helper_e300(386, 1)
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
	helper_e300(386, 1)
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
			helper_386b4()
		end
	end
	flag = event.GetFlag(4) or flag
	if flag == 1 then
		local t0 = helper_44dfc()
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
		helper_386b4()
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
			helper_38b20()
			helper_3a8c4()
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
	helper_38b20()
	event.SetFlag(4, 1)
	helper_3a8c4()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
