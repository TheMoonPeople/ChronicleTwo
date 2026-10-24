--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_fa57afea = require("@lib/event/helper_fa57afea")

--- Helper function.
local function helper_1a9dc31c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 88 then
			if at <= 1 then
				helper_a0e17f3c(30)
			end
			if at <= 2 then
				helper_a0e17f3c(4)
			end
			if at <= 3 then
				helper_a0e17f3c(30)
			end
			if at <= 4 then
				helper_fa57afea(3300010)
			end
			if at <= 5 then
				helper_a19c5ee3(3)
			end
			if at <= 6 then
				helper_fa57afea(3300020)
			end
			if at <= 7 then
				helper_a19c5ee3(2)
			end
			if at <= 8 then
				helper_fa57afea(3300030)
			end
			if at <= 9 then
				helper_a19c5ee3(3)
			end
			if at <= 10 then
				helper_fa57afea(3300040)
			end
			if at <= 11 then
				helper_a19c5ee3(2)
			end
			if at <= 12 then
				helper_fa57afea(3300050)
			end
			if at <= 13 then
				helper_fa57afea(3300060)
			end
			if at <= 14 then
				helper_a19c5ee3(3)
			end
			if at <= 15 then
				helper_fa57afea(3300070)
			end
			if at <= 16 then
				helper_fa57afea(3300080)
			end
			if at <= 17 then
				helper_a19c5ee3(3)
			end
			if at <= 18 then
				helper_fa57afea(3300090)
			end
			if at <= 19 then
				helper_a19c5ee3(2)
			end
			if at <= 20 then
				helper_fa57afea(3300100)
			end
			if at <= 21 then
				helper_fa57afea(3300110)
			end
			if at <= 22 then
				helper_a19c5ee3(0)
			end
			if at <= 23 then
				helper_fa57afea(3300120)
			end
			if at <= 24 then
				helper_fa57afea(3300130)
			end
			if at <= 25 then
				helper_a19c5ee3(3)
			end
			if at <= 26 then
				helper_fa57afea(3300140)
			end
			if at <= 27 then
				helper_a19c5ee3(2)
			end
			if at <= 28 then
				helper_fa57afea(3300150)
			end
			if at <= 29 then
				helper_fa57afea(3300155)
			end
			if at <= 30 then
				helper_a19c5ee3(3)
			end
			if at <= 31 then
				helper_fa57afea(3300160)
			end
			if at <= 32 then
				helper_a19c5ee3(2)
			end
			if at <= 33 then
				helper_fa57afea(3300170)
			end
			if at <= 34 then
				helper_fa57afea(3300175)
			end
			if at <= 35 then
				helper_a19c5ee3(2)
			end
			if at <= 36 then
				helper_fa57afea(3300180)
			end
			if at <= 37 then
				helper_a19c5ee3(2)
			end
			if at <= 38 then
				helper_a19c5ee3(3)
			end
			if at <= 39 then
				helper_fa57afea(3300190)
			end
			if at <= 40 then
				helper_a19c5ee3(3)
			end
			if at <= 41 then
				helper_fa57afea(3300200)
			end
			if at <= 42 then
				helper_a19c5ee3(3)
			end
			if at <= 43 then
				helper_a0e17f3c(30)
			end
			if at <= 44 then
				helper_a0e17f3c(15)
			end
			if at <= 45 then
				helper_a0e17f3c(110)
			end
			if at <= 46 then
				helper_fa57afea(3300210)
			end
			if at <= 47 then
				helper_a19c5ee3(2)
			end
			if at <= 48 then
				helper_fa57afea(3300220)
			end
			if at <= 49 then
				helper_a19c5ee3(2)
			end
			if at <= 50 then
				helper_a19c5ee3(5)
			end
			if at <= 51 then
				helper_fa57afea(3300225)
			end
			if at <= 52 then
				helper_fa57afea(3300230)
			end
			if at <= 53 then
				helper_fa57afea(3300240)
			end
			if at <= 54 then
				helper_fa57afea(3300250)
			end
			if at <= 55 then
				helper_fa57afea(3300260)
			end
			if at <= 56 then
				helper_a19c5ee3(2)
			end
			if at <= 57 then
				helper_fa57afea(3300270)
			end
			if at <= 58 then
				helper_a19c5ee3(3)
			end
			if at <= 59 then
				helper_fa57afea(3300280)
			end
			if at <= 60 then
				helper_fa57afea(3300285)
			end
			if at <= 61 then
				helper_a19c5ee3(2)
			end
			if at <= 62 then
				helper_fa57afea(3300290)
			end
			if at <= 63 then
				helper_fa57afea(3300295)
			end
			if at <= 64 then
				helper_a19c5ee3(1)
			end
			if at <= 65 then
				helper_fa57afea(3300300)
			end
			if at <= 66 then
				helper_fa57afea(3300310)
			end
			if at <= 67 then
				helper_fa57afea(3300315)
			end
			if at <= 68 then
				helper_a19c5ee3(1)
			end
			if at <= 69 then
				helper_fa57afea(3300320)
			end
			if at <= 70 then
				helper_fa57afea(3300325)
			end
			if at <= 71 then
				helper_a19c5ee3(3)
			end
			if at <= 72 then
				helper_fa57afea(3300330)
			end
			if at <= 73 then
				helper_fa57afea(3300335)
			end
			if at <= 74 then
				helper_a19c5ee3(2)
			end
			if at <= 75 then
				helper_fa57afea(3300340)
			end
			if at <= 76 then
				helper_fa57afea(3300345)
			end
			if at <= 77 then
				helper_fa57afea(3300350)
			end
			if at <= 78 then
				helper_fa57afea(3300360)
			end
			if at <= 79 then
				helper_fa57afea(3300365)
			end
			if at <= 80 then
				helper_fa57afea(3300370)
			end
			if at <= 81 then
				helper_a19c5ee3(1)
			end
			if at <= 82 then
				helper_fa57afea(3300380)
			end
			if at <= 83 then
				helper_a19c5ee3(2)
			end
			if at <= 84 then
				helper_a19c5ee3(1)
			end
			if at <= 85 then
				helper_a0e17f3c(10)
			end
			if at <= 86 then
				helper_a0e17f3c(40)
			end
			if at <= 87 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(89)
			end
			return part2()
		end
		if at <= 89 then
			helper_a0e17f3c(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.StopBgm(0)
		helper_a0e17f3c(4)
		if vm.skipping() then
			return skip(90)
		end
		event.LoadBgm(46)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(0, 25)
		event.CharaActive(0, 26)
		event.SetAi(1, 24)
		event.CharaActive(1, 24)
		event.EohSetShow(8, 1)
		event.CharaActive(0)
		event.SetCharaPos(0, 10.0, 0.0, 50.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	event.FadeOutBgm(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFlag(330, 1)
	event.SetAi(0, 24)
	event.CharaActive(0, 24)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_a0e17f3c(4)
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgm(112)
	event.PlayBgm(0)
	event.LoadSound(3217)
	var0 = event.SndLoadSound(3217) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e330/")
	event.LoadMes(0, 5, "e330_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e330_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e330_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.SetStatus(1, 0, 256, 1)
	event.LoadChara(5, "e330_shirooza.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncChara(3, 25)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncChara(4, 26)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	block = event.LoadImg_4(5, "e330.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e33001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(5, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e33002", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(6, 1)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e33003", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(7, 2)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e300/e330/e330_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e300/e330/e330_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncObj(8, "p01_g02i02", "g02i02_02-m0")
	event.EohSetShow(8, 0)
	event.EohSetPos(0, 28.0, 0.0, -90.0)
	event.EohSetRot(0, 0.0, -2.78, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "うれし口ひらき")
	event.EohSetPos(1, 10.0, 0.0, -90.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "うれし口ひらき")
	event.EohSetPos(2, 72.38, 16.24, -92.51)
	event.EohSetRot(2, 0.0, -2.28, 0.0)
	event.EohSetMotion(2, "たんすの上立ち", 4)
	event.EohSetFrameShow(2, "skin2", 0)
	event.EohSetFrameShow(2, "skin2_2", 1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetPos(3, 35.0, 16.0, -125.0)
	event.EohSetRot(3, -1.57, 1.57, 0.0)
	event.EohSetMotion(3, "寝てる", 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "苦しい顔")
	event.EohSetMotion(4, "寝てる", 4)
	event.SetStatus(1, 25, 8, 1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(24.01, 39.57, -131.04)
	event.CmrsSetRef(12.03, 16.62, -125.29)
	event.SetFadeIn(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsTexaDelay(3, 14)
	event.ObjsTexAnime(3, 1, "目をあける")
	event.ObjsTexaDelay(3, 40)
	helper_fa57afea(3300010)
	if vm.skipping() then
		return skip(5)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-1.81, 27.97, -154.78)
	event.CmrsSetRef(22.11, 20.33, -117.13)
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_fa57afea(3300020)
	if vm.skipping() then
		return skip(7)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(87.79, 35.12, -53.62)
	event.CmrsSetRef(30.17, 14.59, -122.91)
	event.SndSePlay(var0, 6)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "ボーっと顔")
	event.EohSetTexAnim(3, 1, "通常目パチ")
	event.ObjsSetMotion(3, "皆の方を見る", 6)
	event.ObjsNextMotion(3, "皆の方を見るL", 4)
	event.ObjsSetMotion(4, "皆の方を見る", 6)
	event.ObjsNextMotion(4, "皆の方を見るL", 4)
	event.SetPakuAnim(3, "通常口パク")
	helper_fa57afea(3300030)
	if vm.skipping() then
		return skip(9)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_fa57afea(3300040)
	if vm.skipping() then
		return skip(11)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-0.25, 29.43, -153.39)
	event.CmrsSetRef(31.82, 19.45, -101.83)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "まばたき目パチ")
	event.EohSetTexAnim(0, 1, "口とじ～半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "まばたき目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～半口")
	event.SetPakuAnim(3, "通常口パク")
	helper_fa57afea(3300050)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(14.77, 25.94, -93.48)
	event.CmrsSetRef(24.16, 22.04, -127.87)
	event.SndSePlay(var0, 7)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "無表情")
	event.EohSetTexAnim(3, 1, "通常目パチ")
	event.ObjsSetMotion(3, "起きる", 6)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる", 6)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_fa57afea(3300060)
	if vm.skipping() then
		return skip(14)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(15.87, 27.57, -153.99)
	event.CmrsSetRef(47.68, 18.9, -91.11)
	helper_fa57afea(3300070)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(3, "起きる会話", 2)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる会話", 2)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "通常口パク")
	helper_fa57afea(3300080)
	if vm.skipping() then
		return skip(17)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_fa57afea(3300090)
	if vm.skipping() then
		return skip(19)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-19.09, 25.03, -107.24)
	event.CmrsSetRef(21.58, 22.33, -92.56)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3300100)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "半口～大口")
	helper_fa57afea(3300110)
	if vm.skipping() then
		return skip(22)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-29.66, 47.69, -64.04)
	event.CmrsSetRef(49.02, 14.93, -110.71)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_fa57afea(3300120)
	if vm.skipping() then
		return skip(24)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(3, "起きる会話", 2)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる会話", 2)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "通常口パク")
	helper_fa57afea(3300130)
	if vm.skipping() then
		return skip(25)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(40.99, 26.64, -119.35)
	event.CmrsSetRef(70.6, 26.45, -93.81)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目とじ")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "首を振る", 6)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_fa57afea(3300140)
	if vm.skipping() then
		return skip(27)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(99.48, 34.17, -94.04)
	event.CmrsSetRef(30.19, 25.94, -108.59)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "かなしわらい顔")
	event.EohSetTexAnim(3, 1, "かなし目パチ")
	event.SetPakuAnim(3, "わらい口パク")
	helper_fa57afea(3300150)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(3, "起きる会話", 2)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる会話", 2)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_fa57afea(3300155)
	if vm.skipping() then
		return skip(30)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_fa57afea(3300160)
	if vm.skipping() then
		return skip(32)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(92.85, 16.62, -119.64)
	event.CmrsSetRef(40.1, 33.22, -74.69)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.ObjsSetMotion(2, "たんすの上会話", 2)
	event.ObjsNextMotion(2, "たんすの上立ち", 4)
	helper_fa57afea(3300170)
	if vm.skipping() then
		return skip(34)
	end
	helper_fa57afea(3300175)
	if vm.skipping() then
		return skip(35)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(15.77, 23.48, -148.74)
	event.CmrsSetRef(56.68, 21.9, -74.53)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.ObjsMotionDelay(2, 20)
	event.ObjsSetMotion(2, "うつむく", 2)
	event.ObjsNextMotion(2, "うつむくＬ", 4)
	event.ObjsSetMotion(3, "起きる会話", 2)
	event.ObjsNextMotion(3, "起きるL", 4)
	event.ObjsSetMotion(4, "起きる会話", 2)
	event.ObjsNextMotion(4, "起きるL", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_fa57afea(3300180)
	if vm.skipping() then
		return skip(37)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(38)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(64.26, 45.15, -27.39)
	event.CmrsSetRef(38.5, 14.35, -130.85)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "おこり顔")
	event.EohSetTexAnim(3, 1, "おこり目パチ")
	event.ObjsSetMotion(3, "あせる", 2)
	event.ObjsNextMotion(3, "あせるL", 4)
	event.ObjsSetMotion(4, "あせる", 2)
	event.ObjsNextMotion(4, "あせるL", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_fa57afea(3300190)
	if vm.skipping() then
		return skip(40)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(-131.61, 184.06, -64.71)
	event.CmrsSetRef(51.21, 2.33, -126.16)
	event.SndSePlay(var0, 8)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	event.ObjsSetMotion(3, "頭をかかえる", 2)
	event.ObjsNextMotion(3, "頭をかかえるL", 4)
	event.ObjsSetMotion(4, "頭をかかえる", 2)
	event.ObjsNextMotion(4, "頭をかかえるL", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_fa57afea(3300200)
	if vm.skipping() then
		return skip(42)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(43)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(44)
	end
	helper_a0e17f3c(15)
	if vm.skipping() then
		return skip(45)
	end
	event.SetStatus(1, 25, 8, 0)
	event.ObjsSetPos(0, 0.0, 0.0, -90.0)
	event.ObjsSetRot(0, 0.0, -1.69, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 0.0, 0.0, -70.0)
	event.ObjsSetRot(1, 0.0, -1.81, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(3, -53.0, 0.0, -97.0)
	event.ObjsSetRot(3, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(3, "おちこみ立ち", 4)
	event.ObjsSetPos(2, -16.0, 22.0, -139.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "左前見Ｌ", 4)
	event.EohSetFrameShow(2, "skin2", 1)
	event.EohSetFrameShow(2, "skin2_2", 0)
	event.CmrsSetPos(57.82, 62.91, -139.67)
	event.CmrsSetRef(-55.62, 5.38, -89.44)
	event.SetFadeIn(30)
	helper_a0e17f3c(110)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(-93.03, 24.39, -105.26)
	event.CmrsSetRef(12.72, 20.96, -113.84)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "絶望顔")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_fa57afea(3300210)
	if vm.skipping() then
		return skip(47)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(45.38, 35.01, -120.42)
	event.CmrsSetRef(-20.5, 28.5, -120.11)
	event.SpriteSetDraw(0, 1)
	event.ObjsColorDelay(5, 30)
	event.ObjsSetColor(5, 128, 128, 128, 128, 30)
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_fa57afea(3300220)
	if vm.skipping() then
		return skip(49)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(50)
	end
	helper_a19c5ee3(5)
	if vm.skipping() then
		return skip(51)
	end
	helper_fa57afea(3300225)
	if vm.skipping() then
		return skip(52)
	end
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(6, 128, 128, 128, 128, 30)
	helper_fa57afea(3300230)
	if vm.skipping() then
		return skip(53)
	end
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(7, 128, 128, 128, 128, 30)
	helper_fa57afea(3300240)
	if vm.skipping() then
		return skip(54)
	end
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.ObjsSetColor(7, 128, 128, 128, 0, 30)
	event.CmrsSetPos(56.94, 81.54, -45.44)
	event.CmrsSetRef(-56.07, 1.34, -106.43)
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_fa57afea(3300250)
	if vm.skipping() then
		return skip(55)
	end
	helper_fa57afea(3300260)
	if vm.skipping() then
		return skip(56)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(57)
	end
	event.CmrsSetPos(-119.33, 41.11, -95.7)
	event.CmrsSetRef(-22.39, 11.99, -99.98)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.ObjsSetMotion(3, "いやいや", 6)
	event.ObjsNextMotion(3, "おちこみ立ち", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_fa57afea(3300270)
	if vm.skipping() then
		return skip(58)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(59)
	end
	helper_fa57afea(3300280)
	if vm.skipping() then
		return skip(60)
	end
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_fa57afea(3300285)
	if vm.skipping() then
		return skip(61)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(62)
	end
	event.CmrsSetPos(10.36, 21.88, -39.67)
	event.CmrsSetRef(-27.66, 19.71, -97.71)
	event.SndSePlay(var0, 9)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "かなし顔")
	event.EohSetTexAnim(3, 1, "かなし目パチ")
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsMotionDelay(3, 40)
	event.ObjsSetMotion(3, "振り返る", 6)
	event.ObjsNextMotion(3, "振り返るL", 4)
	event.ObjsRotDelay(3, 40)
	event.ObjsRotation(3, 0.0, -1.93, 0.0, 40)
	event.ObjsSeDelay(3, 40)
	event.ObjsSePlay(3, var0, 10)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3300290)
	if vm.skipping() then
		return skip(63)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3300295)
	if vm.skipping() then
		return skip(64)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(65)
	end
	event.SetPakuAnim(3, "おこり口パク")
	helper_fa57afea(3300300)
	if vm.skipping() then
		return skip(66)
	end
	event.CmrsSetPos(-70.31, 31.36, -128.99)
	event.CmrsSetRef(-9.47, 13.8, -67.09)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3300310)
	if vm.skipping() then
		return skip(67)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3300315)
	if vm.skipping() then
		return skip(68)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(69)
	end
	event.CmrsSetPos(-26.17, 19.91, -113.4)
	event.CmrsSetRef(-51.02, 21.23, -95.32)
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_fa57afea(3300320)
	if vm.skipping() then
		return skip(70)
	end
	event.SndSePlay(var0, 11)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目をとじる")
	event.ObjsSetMotion(3, "ふさぎこむ", 4)
	event.ObjsNextMotion(3, "ふさぎこむL", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_fa57afea(3300325)
	if vm.skipping() then
		return skip(71)
	end
	helper_a19c5ee3(3)
	if vm.skipping() then
		return skip(72)
	end
	event.CmrsSetPos(-2.71, 9.25, -74.51)
	event.CmrsSetRef(-22.45, 20.78, -105.38)
	event.CharaActive(0, 0)
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "うつろ顔")
	event.ObjsSetPos(3, -30.0, 0.0, -97.0)
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_fa57afea(3300330)
	if vm.skipping() then
		return skip(73)
	end
	helper_fa57afea(3300335)
	if vm.skipping() then
		return skip(74)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(75)
	end
	event.ObjsSetMotion(2, "左前見会話", 6)
	event.ObjsNextMotion(2, "左前見Ｌ", 4)
	helper_fa57afea(3300340)
	if vm.skipping() then
		return skip(76)
	end
	helper_fa57afea(3300345)
	if vm.skipping() then
		return skip(77)
	end
	helper_fa57afea(3300350)
	if vm.skipping() then
		return skip(78)
	end
	event.CmrsSetPos(-77.82, 32.14, -80.91)
	event.CmrsSetRef(-1.37, 15.08, -92.17)
	event.CharaActive(1, 0)
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.ObjsSetPos(3, -53.0, 0.0, -97.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3300360)
	if vm.skipping() then
		return skip(79)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_fa57afea(3300365)
	if vm.skipping() then
		return skip(80)
	end
	event.ObjsSetMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_fa57afea(3300370)
	if vm.skipping() then
		return skip(81)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(82)
	end
	event.CmrsSetPos(27.61, 76.95, -20.78)
	event.CmrsSetRef(-28.7, 15.08, -105.78)
	event.SndSePlay(var0, 12)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetRot(0, 0.0, -2.62, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -2.89, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_fa57afea(3300380)
	if vm.skipping() then
		return skip(83)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(84)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var0, 13)
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(85)
	end
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(86)
	end
	event.CmrsSetPos(-68.75, 20.99, -120.19)
	event.CmrsSetRef(-23.11, 15.08, -79.67)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.ObjsSetRot(0, 0.0, -1.66, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -2.05, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_a0e17f3c(40)
	if vm.skipping() then
		return skip(87)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(88)
	end
	return part2()
end

return helper_1a9dc31c
