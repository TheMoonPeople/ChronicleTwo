--!strict
-- map/g/g01/g01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_29101c9c = require("@lib/event/helper_29101c9c")
local helper_2a6d5753 = require("@lib/event/helper_2a6d5753")
local helper_342a37b0 = require("@lib/event/helper_342a37b0")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_66f48a5b = require("@lib/event/helper_66f48a5b")
local helper_7813b267 = require("@lib/event/helper_7813b267")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_b84429a4 = require("@lib/event/helper_b84429a4")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_c5ea1698 = require("@lib/event/helper_c5ea1698")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_e538a72d = require("@lib/event/helper_e538a72d")
local helper_ee09935e = require("@lib/event/helper_ee09935e")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_fc1176d4 = require("@lib/event/helper_fc1176d4")

local global0: s32 = 0
local global1: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	flag = event.GetFlag(250) or flag
	if flag ~= 0 then
		event.SetBitCtrl(2, 0)
	else
		event.SetBitCtrl(2, 1)
	end
end

--- Helper function.
local function helper_229d8()
	event.SetCameraPos(-738.31, 36.31, -959.51)
	event.SetCameraRef(-716.6, 22.73, -1033.69)
	event.SetCharaPos(0, -700.0, 0.0, -1090.0)
	event.SetCharaRot(0, 0.0, -0.26, 0.0)
	event.ResetCamera(1, 3.14, 2.0)
	event.SetFadeIn(30, 255.0, 255.0, 255.0)
end

--- Helper function.
local function helper_224d4()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.Initialize()
	flag = event.GetFlag(208) or flag
	flag_2 = event.GetFlag(207) or flag_2
	if not (flag == 0 and flag_2 == 1) then
		event.CmrsInit()
		event.CmrsSetPos(324.12, 34.59, 830.75)
		event.CmrsSetRef(362.46, 42.77, 960.05)
		event.EohSyncChara(0, 0)
		event.EohSetFootSoundId(0, 1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 404.68, 0.0, 1124.89)
		event.ObjsSetRot(0, 0.0, -2.84, 0.0)
		event.CmrsMove2(324.12, 34.59, 830.75, 377.85, 23.14, 1003.73, 48, 2, 0.25)
		event.ObjsSetMotion(0, "走り", 4)
		event.ObjsMove(0, 361.74, 0.0, 957.26, 60)
		event.CmrsFadeInit()
		event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
		helper_888ab2a3(60)
		event.ResetCamera(0)
	end
end

--- Helper function.
local function helper_22ee0()
	local flag: s32 = 0
	flag = event.GetFlag(207) or flag
	if flag == 1 then
		flag = event.GetFlag(208) or flag
		if flag == 0 then
			event.SetFadeOut(0)
			vm.wait(1)
			event.LoadScript("g01/g01b.stb", 501)
		end
	end
end

--- Helper function.
local function helper_22c14()
	local flag: s32 = 0
	flag = event.GetFlag(209) or flag
	if flag == 0 then
		event.FuncPointShow("p01_g010701", "door", 0)
	else
		event.FuncPointShow("p01_g010701", "door", 1)
	end
	flag = event.GetFlag(250) or flag
	if flag == 1 then
		event.CharaActive(1, 120)
		event.CharaActive(1, 121)
	else
		event.CharaActive(0, 120)
		event.CharaActive(0, 121)
	end
end

--- Helper function.
local function helper_1a050()
	if helper_e538a72d() ~= 0 then
		return 1
	end
	if helper_342a37b0() ~= 0 then
		return 1
	end
	if helper_ee09935e() ~= 0 then
		return 1
	end
	if helper_b84429a4() ~= 0 then
		return 1
	end
	if helper_c5ea1698() ~= 0 then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1a1f0(arg0: s32, arg1: s32)
	local var5: s32 = 0
	local var6: s32 = 0
	var5 = event.GetChapter() or var5
	if var5 >= 8 then
		return
	end
	event.SetMesWindowMode(1, 8)
	event.SetMotion(0, "立ち")
	var6 = 1050
	if helper_1a050() ~= 0 then
		var6 = 1051
	elseif arg0 ~= 0 then
		return
	end
	if arg1 ~= 0 then
		var6 = var6 + 10
	end
	event.MesMake_2(1, var6)
	helper_a3cc6850(1, -1, 8, 0, 0)
end

--- Helper function.
local function helper_1a508(arg0: s32)
	helper_1a1f0(arg0, 0)
end

--- Helper function.
local function helper_22900000()
	helper_038a2e4d(60)
end

--- Helper function.
local function helper_22d00000(arg0: any, arg1: any) end

--- Helper function.
local function helper_22c00000(arg0: s32)
	helper_22d00000(arg0, 0)
end

--- Helper function.
local function helper_1dd14()
	local active_chr_no: s32 = 0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e254/e254b_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254b_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 38)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 38)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e254/e254b_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254b_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
end

--- Helper function.
local function helper_22100000()
	global0 = 0
	global1 = 32
	global0 = 32
	global1 = 0
end

--- Helper function.
local function helper_1d97c()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(38)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(38)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
end

--- Helper function.
local function helper_1e9a4()
	local var4: s32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(34, 1)
		event.Initialize()
		event.SetMesPreset(0, 0)
		event.SetFadeOut(30)
		at = 1
		helper_888ab2a3(45)
		helper_1dd14()
		event.InitDramaScene()
		event.CmrsInit()
		event.CmrsSetPos(770.06, 6.44, -898.09)
		event.CmrsSetRef(616.07, 68.13, -1043.77)
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CharaActive(1, 38)
		event.ObjsSetPos(0, 714.22, 0.0, -963.1)
		event.ObjsSetRot(0, 0.0, -1.34, 0.0)
		event.ObjsSetMotion(0, "モニカ見立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsSetPos(1, 695.34, 0.0, -949.18)
		event.ObjsSetRot(1, 0.0, 1.58, 0.0)
		event.ObjsSetMotion(1, "立ち", 4)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.SetFadeIn(30)
		at = 2
		helper_888ab2a3(30)
		event.ObjsSetMotion(1, "会話", 2)
		event.ObjsNextMotion(1, "立ち", 4)
		event.SetPakuAnim(1, "通常口パク")
		event.MesMake_2(
			0,
			"今回持ち帰ったジオストーンによると、\nジュラクさまを復活させるためには、<page>このシャーロットに「木にくわしい人」を\n移住させないといけないみたいね。"
		)
		at = 3
		helper_a3cc6850(0, -1, 3, 0, 416)
		event.ResetPakuAnim()
		event.CmrsSetPos(680.02, 12.41, -968.76)
		event.CmrsSetRef(647.47, 24.66, -996.48)
		event.ObjsSetPos(0, 656.27, 0.0, -1003.39)
		event.ObjsSetRot(0, 0.0, -0.7853982, 0.0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsSetPos(1, 641.27, 0.0, -988.39)
		event.ObjsSetRot(1, 0.0, 2.3561945, 0.0)
		at = 4
		vm.wait(4)
		event.ObjsResetDaPosition(1)
		event.SetPakuAnim(0, "通常口パク")
		event.MesMake_2(0, "移住させる・・・？")
		at = 5
		helper_b5a98ffa(0, -1, global0, global1, var4)
		event.ResetPakuAnim()
		event.SetPakuAnim(1, "通常口パク")
		event.MesMake_2(
			0,
			"そうよ。パームブリンクスには\n人がたくさん住んでるでしょ。<page>そういう人たちを連れて来て\n大陸中に移住させていくの。<page>そうすることで未来が\n発展していくわけね。"
		)
		at = 6
		helper_b5a98ffa(0, -1, global1, global0, var4)
		event.ResetPakuAnim()
		event.MesMake_2(0, "ふ～ん。")
		at = 7
		helper_b5a98ffa(0, -1, global0, global1, var4)
		event.ObjsSetMotion(1, "向き直り", 2)
		event.ObjsNextMotion(1, "向き直りL", 4)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目～上向き目")
		event.SetPakuAnim(1, "通常口パク")
		event.MesMake_2(0, "で、今回必要なのは、\n「木にくわしい人」・・・か。")
		at = 8
		helper_b5a98ffa(0, -1, global1, global0, var4)
		event.ResetPakuAnim()
		at = 9
		helper_0958ca60(1)
		event.ObjsSetMotion(1, "顔向け", 2)
		event.ObjsNextMotion(1, "顔向けＬ", 4)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "上向き目～通常目")
		event.SetPakuAnim(1, "通常口パク")
		event.MesMake_2(0, "ユリス、誰か知らない？")
		at = 10
		helper_b5a98ffa(0, -1, global1, global0, var4)
		event.ResetPakuAnim()
		at = 11
		helper_0958ca60(1)
		event.ObjsSetMotion(0, "考える", 6)
		event.ObjsNextMotion(0, "考えるL", 4)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "目あき～目とじ")
		event.SetPakuAnim(0, "通常口パク")
		event.MesMake_2(0, "「木にくわしい人」・・・\nう～ん。")
		at = 12
		helper_b5a98ffa(0, -1, global0, global1, var4)
		event.ResetPakuAnim()
		at = 13
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "そうだ！！", 2)
		event.ObjsNextMotion(0, "そうだ！！L", 4)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "無表情")
		event.ObjsTexAnime(0, 1, "目とじ～目あき")
		event.SetPakuAnim(0, "わらい口パク")
		event.MesMake_2(0, "そうだ！！\nグリンがいる。")
		at = 14
		helper_b5a98ffa(0, -1, global0, global1, var4)
		event.ResetPakuAnim()
		at = 15
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "そうだ！！戻り", 2)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		event.ObjsSetMotion(1, "もどり", 2)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.SetPakuAnim(1, "通常口パク")
		event.MesMake_2(0, "グリン？")
		at = 16
		helper_b5a98ffa(0, -1, global1, global0, var4)
		event.ResetPakuAnim()
		at = 17
		helper_0958ca60(0)
		at = 18
		helper_0958ca60(1)
		event.ObjsSetMotion(0, "モニカ見うなづき", 2)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.SetPakuAnim(0, "通常口パク")
		event.MesMake_2(
			0,
			"うん。うちの庭師なんだ。\nグリンなら木の専門家だし、\nぴったりだよ。<page>今ごろ、うちの屋敷の前で\n花の手入れをしているはずだよ。"
		)
		at = 19
		helper_b5a98ffa(0, -1, global0, global1, var4)
		event.ResetPakuAnim()
		at = 20
		helper_0958ca60(0)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.SetPakuAnim(1, "わらい口パク")
		event.MesMake_2(0, "ホント！？\n行ってみましょう！")
		at = 21
		helper_b5a98ffa(0, -1, global1, global0, var4)
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "モニカ見うなづき", 2)
		event.ObjsNextMotion(0, "モニカ見立ち", 4)
		event.MesMake_2(0, "うん！")
		at = 22
		helper_b5a98ffa(0, -1, global0, global1, var4)
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]パームブリンクスに戻って、\n   庭師グリンを探してみましょう。\n   今はユリスの家の前にいるはずです。"
		)
		at = 23
		helper_a3cc6850(0, -1, 8, 0, 0)
		event.SetFadeOut(30)
		at = 24
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22100000()
			helper_038a2e4d(30)
		end
		if at <= 2 then
			helper_ee1c51d0(0, -1, 3, 0, 416)
		end
		if at <= 4 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 5 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 6 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 7 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 10 then
			helper_238b5abc(1)
		end
		if at <= 11 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 14 then
			helper_238b5abc(0)
		end
		if at <= 15 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 16 then
			helper_238b5abc(0)
		end
		if at <= 17 then
			helper_238b5abc(1)
		end
		if at <= 18 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 19 then
			helper_238b5abc(0)
		end
		if at <= 20 then
			helper_249b75d1(0, -1, global1, global0, var4)
		end
		if at <= 21 then
			helper_249b75d1(0, -1, global0, global1, var4)
		end
		if at <= 22 then
			helper_ee1c51d0(0, -1, 8, 0, 0)
		end
		if at <= 23 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.CancelDramaScene()
	helper_1d97c()
	event.SetMesPreset(0, 0)
	event.Finish()
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1a890()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_event.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e209/e209_rococo.gltf", "info", 33)
	event.EohSyncChara(2, 33)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 33)
	event.EohSyncEditObj(6, "p01_g010701", "g010707-m")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 6)
	event.ObjsSetPos(10, 1.0461, 59.1891, 78.8974)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.EohSyncEditObj(7, "p01_g010701", "g010708-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 7)
	event.ObjsSetPos(11, 1.0461, 59.1891, 78.8974)
	event.ObjsSetRot(11, 0.0, 0.0, 0.0)
	event.LoadMes(0, 5, "event/e200/e209/e209.txt")
end

--- Helper function.
local function helper_1a594()
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(33)
end

--- Helper function.
local function helper_1b6a8()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	vm.section(function()
		event.SetFlag(209, 1)
		event.Initialize()
		var0 = event.SndLoadSound_2(2217) or var0
		helper_1a890()
		event.EohSetSoundId(0, var0)
		do
			local out1, out2, out3, out4 = event.GetEditPartsPos("p01_g010701")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
			rot_y = out4 or rot_y
		end
		event.SetWorldCoord(pos_x, pos_y, pos_z, rot_y)
		event.StopBgm(0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.InitDramaScene()
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CmrsSetPos(-152.18, 97.87, 182.55)
		event.CmrsSetRef(-14.08, 63.23, 79.66)
		event.ObjsSetPos(0, -21.47, 35.67, 73.06)
		event.ObjsSetRot(0, 0.0, 1.6, 0.0)
		event.ObjsSetPos(1, -23.66, 35.67, 53.67)
		event.ObjsSetRot(1, 0.0, 1.48, 0.0)
		event.SetFadeIn(30)
		event.ObjsSetMotion(0, "ノック", 6, -1.0, 1)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		helper_888ab2a3(63)
		event.ObjsMotionDelay(0, 30)
		event.ObjsSetMotion(0, "左・モニカ見", 6)
		event.ObjsNextMotion(0, "左・モニカ見L", 0)
		event.ObjsMotionDelay(1, 40)
		event.ObjsSetMotion(1, "右を見る", 6)
		event.ObjsNextMotion(1, "右を見るL", 0)
		helper_e34416e2(2090010)
		helper_0958ca60(0)
		helper_0958ca60(1)
		event.CmrsSetPos(2.14, 52.68, 63.32)
		event.CmrsSetRef(-43.71, 54.31, 61.35)
		event.ObjsSetPos(0, -44.21, 30.26, 69.36)
		event.ObjsSetRot(0, 0.0, 1.6, 0.0)
		event.ObjsSetPos(1, -40.8, 31.97, 53.53)
		event.ObjsSetRot(1, 0.0, 1.24, 0.0)
		event.ObjsResetDaPosition(0)
		event.ObjsSetMotion(1, "ひそひそ", 6, -1.0, 1)
		event.ObjsNextMotion(1, "ひそひそL", 0)
		helper_888ab2a3(14)
		event.SetPakuAnim(1, "通常口パク")
		helper_e34416e2(2090020)
		event.ResetPakuAnim()
		helper_888ab2a3(15)
		event.ObjsSetMotion(1, "どうするのー！", 6)
		event.ObjsNextMotion(1, "どうするのー！L", 4)
		event.ObjsMotionDelay(0, 15)
		event.ObjsSetMotion(0, "左・モニカ見戻り", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		helper_888ab2a3(14)
		event.SetPakuAnim(1, "わらい口パク")
		helper_29101c9c(2090030, 130)
		event.ResetPakuAnim()
		event.SetPakuAnim(1, "わらい口パク")
		helper_29101c9c(2090040, 120)
		event.ResetPakuAnim()
		event.CharaActive(1, 33)
		event.CmrsSetPos(-101.88, 58.31, 65.69)
		event.CmrsSetRef(-24.94, 60.87, 62.04)
		event.ObjsSetPos(0, -38.21, 35.37, 69.15)
		event.ObjsSetRot(0, 0.0, 1.6, 0.0)
		event.ObjsSetPos(1, -40.8, 36.06, 53.53)
		event.ObjsSetRot(1, 0.0, 1.48, 0.0)
		event.ObjsSetPos(2, 6.91, 35.67, 60.19)
		event.ObjsSetRot(2, 0.0, -2.24, 0.0)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.StreamOpen3(1, 2090045)
		helper_9cbdc640(1)
		event.StreamPlay(1)
		helper_888ab2a3(75)
		event.SndSePlay(var0, 5)
		helper_888ab2a3(30)
		helper_888ab2a3(60)
		event.SndSePlay(var0, 6)
		event.ObjsRotation(10, 0.0, 0.78, 0.0, 30)
		event.ObjsRotation(11, 0.0, 0.78, 0.0, 30)
		helper_888ab2a3(30)
		event.CharaActive(0, global0)
		event.CharaActive(0, global1)
		event.CharaActive(0, 37)
		event.CmrsSetPos(-78.2, 56.82, 61.3)
		event.CmrsSetRef(-24.35, 59.62, 61.68)
		event.ObjsSetPos(2, 2.98, 37.07, 62.41)
		event.ObjsSetRot(2, 0.0, -2.6, 0.0)
		event.ObjsSetMotion(2, "手招き", 4)
		helper_e34416e2(2090050)
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CharaActive(1, 37)
		event.CharaActive(0, 33)
		event.CmrsSetPos(1.94, 52.68, 65.96)
		event.CmrsSetRef(-43.71, 52.77, 61.35)
		event.ObjsSetPos(0, -44.21, 30.26, 69.36)
		event.ObjsSetRot(0, 0.0, 1.6, 0.0)
		event.ObjsSetPos(1, -40.8, 31.97, 53.53)
		event.ObjsSetRot(1, 0.0, 1.24, 0.0)
		event.ObjsSetRot(10, 0.0, 0.0, 0.0)
		event.ObjsSetRot(11, 0.0, 0.0, 0.0)
		event.ObjsResetDaPosition(0)
		event.ObjsSetMotion(1, "右を見る", 6, -1.0, 1)
		event.ObjsNextMotion(1, "右を見るL", 0)
		event.ObjsTexAnime(0, 1, "半口")
		event.SetPakuAnim(1, "わらい口パク")
		helper_e34416e2(2090060)
		event.ResetPakuAnim()
		event.CmrsSetPos(-98.54, 68.99, 103.67)
		event.CmrsSetRef(-31.83, 65.79, 66.42)
		event.ObjsSetPos(0, -36.84, 35.67, 44.26)
		event.ObjsSetRot(0, 0.0, 1.48, 0.0)
		event.ObjsSetPos(1, -15.62, 35.67, 55.4)
		event.ObjsSetRot(1, 0.0, 1.36, 0.0)
		event.ObjsSetRot(10, 0.0, 1.2, 0.0)
		event.ObjsSetRot(11, 0.0, 1.2, 0.0)
		event.EohSetFootSoundId(0, 3)
		event.EohSetFootSoundId(1, 3)
		event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
		event.ObjsMove(1, 29.37, 35.67, 54.62, 60)
		event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
		event.ObjsMove(0, 20.32, 35.67, 64.47, 75)
		helper_888ab2a3(45)
		event.ObjsSetMotion(1, "立ち", 4)
		event.SndSePlay(var0, 7)
		event.ObjsRotation(10, 0.0, 0.0, 0.0, 30)
		event.ObjsRotation(11, 0.0, 0.0, 0.0, 30)
		helper_888ab2a3(15)
		event.ObjsSetMotion(0, "立ち", 4)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.ObjsSetRot(11, 0.0, 0.0, 0.0)
	helper_1a594()
	event.SetFadeIn(30)
end

--- Event 502, which map data, a script or the engine runs by number.
local function event_502()
	helper_1b6a8()
	event.SetFadeOut(15)
	helper_888ab2a3(15)
	vm.wait(3)
	event.BgmLoadCancel()
	event.MapJump_3(-1, "g01i07", 501)
	vm.wait(4)
end

--- Helper function.
local function helper_218d4()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.MesMake_2(0, "『シャーロット停車場』に移動しますか？")
		at = 1
		var0 = helper_c190f878(0, -1, 8, 256, 208, 2, 1)
		if var0 == 0 then
			event.ObjsSetPos(0, 435.65, 0.09, 1239.32)
			event.ObjsSetRot(0, 0.0, 0.15, 0.0)
			event.ObjsSetMotion(0, "走り", 4)
			event.CmrsInit()
			event.CmrsSetPos(509.64, 85.52, 1104.08)
			event.CmrsSetRef(467.67, 42.86, 1293.7)
			event.ObjsMove(0, 493.92, 0.01, 1423.13, 60, 1)
			event.CmrsMove(509.64, 85.52, 1104.08, 485.07, 46.59, 1340.58, 60)
			print("2")
			at = 2
			helper_888ab2a3(30)
			print("3")
			event.SetFadeOut(30)
			at = 3
			helper_888ab2a3(30)
			return 1
		end
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var1 = vm.f32(var1 + vm.f32(45.0 * vm.sin(vm.f32(-3.01))))
		var3 = vm.f32(var3 + vm.f32(45.0 * vm.cos(vm.f32(-3.01))))
		event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
		event.ObjsRotation(0, 0.0, -3.01, 0.0, 15)
		event.ObjsMove(0, var1, var2, var3, 45)
		for var4_i = 0, 44 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			event.CmrsSetRef(var1, var2 + 30.0, var3)
			at = 4
			vm.wait(4)
		end
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.SetMesWindowMode(0, 7)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				print("2")
				helper_038a2e4d(30)
			end
			if at <= 2 then
				print("3")
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 4 then
			local _ = var4 < 45
			var4 = var4 + 1
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_df3c()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: s32 = 0
	local angle: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMotion(5, "event/lm/e250r/e250_mints.gltf", "info", 0)
	event.SetCharaPos(0, -211.18, 0.0, 11.07)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "上見立ち", 4)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(1, 8)
	event.LoadEquip(5, 1, 4, "info", 8)
	event.LoadEquip(5, 1, 3, "info", 8)
	event.LoadEquip(5, 1, 2, "info", 8, 13)
	event.CharaActive(13)
	event.SetCharaPos(8, -173.24, 0.0, 0.0)
	event.SetCharaRot(8, 0.0, 0.0, 0.0)
	event.LoadMotion(5, "event/lm/e250r/e250_monica.gltf", "info", 8)
	event.SetMotion(8, "上見立ち", 4)
	event.EohSyncChara(1, 8)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "event/lm/e250r/e250_toryon.gltf", "info", 9)
	event.CharaActive(9)
	event.SetCharaPos(9, -1121.01, 394.47, -2048.83)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.EohSyncChara(2, 9)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/lm/e250r/e250_tree.gltf", "info", 10)
	event.SetCharaRot(10, 0.0, 3.14, 0.0)
	event.CharaActive(0, 10)
	event.SetReference(9, "R_tree", 10)
	event.LoadChara(5, "event/lm/e250r/e250_tree.gltf", "info", 11)
	event.SetCharaRot(11, 0.0, 3.14, 0.0)
	event.CharaActive(0, 11)
	event.SetReference(9, "L_tree", 11)
	event.EohSyncChrobj(6, 9, "puropera")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsRotation(6, 0.0, -0.2, 0.0, -1)
	event.CmrsInit()
	event.CmrsSetPos(-601.29, 522.11, 100.72)
	event.CmrsSetRef(-689.32, 571.24, -105.58)
	helper_888ab2a3(30)
	event.ObjsMove2(2, -1121.01, 995.31, -2048.83, 60, 2, 0.5)
	event.ObjsRotation(2, 0.0, -3.14, 0.0, 40)
	event.ObjsRotation(2, 0.0, 1.57, 0.0, 20)
	event.ObjsRotation2(2, 0.0, 0.16, 0.0, 20, 2, 0.5)
	helper_0958ca60(2)
	event.ObjsMove2(2, -671.63, 447.09, -193.49, 80, 1, 0.4)
	event.CmrsMove2(-601.29, 522.11, 100.72, -654.5, 581.35, -117.24, 60, 0, 0.4)
	helper_0958ca60(2)
	helper_c624bc16()
	event.CmrsSetPos(-298.8, 199.33, -185.86)
	event.CmrsSetRef(-194.57, 243.43, 136.45)
	event.CharaActive(1, 10)
	event.CharaActive(1, 11)
	event.SetCharaPos(9, -221.16, 0.0, 293.2)
	event.SetCharaRot(9, 0.0, 3.14, 0.0)
	event.SetMotion(9, "木持ち浮遊", 4)
	event.CmrsMove2(-299.31, 60.07, -348.88, -167.05, 136.09, 169.13, 60, 0, 0.5)
	helper_c624bc16()
	event.ObjsSetMotion(2, "右の木を植える", 2)
	event.ObjsNextMotion(2, "右の木を植えるL", 4)
	helper_888ab2a3(18)
	event.SetMotion(0, "右へよける", 6)
	event.SetMotion(8, "左へよける", 6)
	helper_888ab2a3(5)
	do
		local out1, _, out3 = event.EohGetFramePos(2, "R_tree")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	event.DelReference(10)
	event.SetCharaPos(10, pos_x, 0.0, pos_z)
	event.SetMotion(10, "ぷるん", 6)
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_0958ca60(2)
	event.CmrsSetPos(-280.52, 44.63, 49.11)
	event.CmrsSetRef(-280.82, 14.35, 12.64)
	event.SetCharaPos(0, -281.18, 0.0, 11.07)
	event.SetCharaPos(9, -291.16, 0.0, 293.2)
	event.ObjsSetMotion(0, "前を見る", 6)
	event.ObjsNextMotion(0, "前を見るL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目・おどろき")
	event.ObjsTexAnime(0, 1, "口・はっ")
	helper_0958ca60(0)
	event.CmrsSetPos(-299.31, 60.07, -348.88)
	event.CmrsSetRef(-167.05, 136.09, 169.13)
	event.ObjsSetMotion(2, "左の木を植える", 2)
	event.ObjsNextMotion(2, "左の木を植えるL", 4)
	helper_888ab2a3(18)
	event.ObjsSetMotion(0, "左へよける", 6)
	helper_888ab2a3(5)
	do
		local out1, _, out3 = event.EohGetFramePos(2, "L_tree")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	event.DelReference(11)
	event.SetCharaPos(11, pos_x, 0.0, pos_z)
	event.SetMotion(11, "ぷるん", 6)
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_0958ca60(2)
	helper_888ab2a3(30)
	event.CmrsSetPos(-814.87, 217.76, -136.29)
	event.CmrsSetRef(-388.48, 229.58, 435.09)
	event.CmrsMove2(-647.69, 217.76, 87.74, -388.48, 229.58, 435.09, 64, 2, 0.5)
	event.SetCharaPos(9, -360.96, 101.44, 464.93)
	event.SetCharaRot(9, 0.0, -2.9, 0.0)
	event.ObjsSetMotion(2, "まわる", 6)
	event.ObjsNextMotion(2, "まわるL", 6)
	event.ObjsMotionDelay(2, 1)
	event.ObjsSetStep(2, 1.0)
	event.ObjsNextMotion(2, "ピース", 6)
	event.ObjsNextMotion(2, "ピースL", 4)
	var3 = 0
	angle = vm.f32(-2.9)
	var6 = 0
	while var3 < 68 do
		var6 = vm.f32(var6 + vm.f32(0.04619989))
		var5 = vm.f32(vm.sin(var6) * vm.f32(0.3))
		angle = vm.f32(angle + var5)
		angle = event.AngleLimit(angle) or angle
		event.SetCharaRot(9, 0.0, angle, 0.0)
		var3 = var3 + 1
		vm.wait(14)
	end
	vm.wait(15)
	helper_c956b4a2(32)
	event.DelExtMotion(0)
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(13)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		old_map_no = event.GetOldMapNo() or old_map_no
		var1 = event.GetMapType(old_map_no) or var1
		if var1 ~= -1 then
			if var1 ~= 2 then
				if old_map_no == 25 then
					helper_229d8()
				elseif old_map_no == 16 then
					at = 1
					helper_224d4()
				elseif old_map_no == 71 then
					event.SetFadeIn(30)
					event.SetCharaPos(0, 275.0, 35.7, 465.0)
					event.SetCharaRot(0, 0.0, -1.57, 0.0)
					event.ResetCamera(1, 0.0, 20.0)
				else
					at = 2
					helper_224d4()
				end
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			event.GetOldInteriorMapNo()
			event.SetFadeIn(30)
		end
		at = 3
		helper_22ee0()
		helper_22c14()
		at = 4
		helper_1a508(1)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_22900000()
			end
			if at <= 2 then
				print("------  <START EVENT> OLD MAP ERR   ------\n")
				helper_344d6cd8()
			end
			if at <= 3 then
				helper_344d6cd8()
				helper_22c00000(1)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1e9a4

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	flag = event.GetFlag(209) or flag
	if flag == 0 then
		event_502()
		return
	end
	flag = event.GetFlag(247) or flag
	if flag == 1 then
		flag = event.GetFlag(250) or flag
		if flag == 0 then
			event.SetBitCtrl(2, 0)
			event.BgmLoadCancel()
			event.MapJump_3(-1, "g01i07", 100)
			vm.wait(2)
			return
		end
	end
	flag = event.GetFlag(250) or flag
	if flag == 0 then
		event.MapJump_3(-1, "g01i07", 100)
		vm.wait(3)
		return
	end
	vm.wait(4)
	event.GotoInterior(-1, "g01i07", 100)
	vm.wait(5)
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	if helper_218d4() == 1 then
		event.MapJump_2(-1, "s02")
		vm.wait(2)
	end
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	helper_fc1176d4(-700.0, 0.0, -1000.0, 1.0)
	var0 = event.GetAnalyze(103) or var0
	flag = event.GetFlag(270) or flag
	if (if var0 ~= 0 then helper_e538a72d() else 0) ~= 0 and flag == 0 then
		event.BgmLoadCancel()
	end
	flag_2 = event.GetFlag(280) or flag_2
	if (if var0 ~= 0 then helper_b84429a4() else 0) ~= 0 and flag_2 == 0 then
		event.BgmLoadCancel()
	end
	event.MapJump_2(-1, "f01")
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_1a508(0)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: any = 0
	helper_7813b267(0)
	var0 = helper_2a6d5753(0)
	helper_66f48a5b()
	if var0 == 0 then
		event.GotoInterior(-1, "i01h01")
		vm.wait(2)
	end
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	vm.wait(1)
	event.LoadScript("g01/g01b.stb", 501)
end

script.event_502 = event_502

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	event.SetCameraPos(-715.15, 30.36, -736.79)
	event.SetCameraRef(-715.13, 14.54, -733.45)
	event.SetFadeOut(0)
	vm.wait(1)
	event.LoadScript("g01/g01c.stb", 501)
	event.SetFadeOut(0)
end

--- Event 506, which map data, a script or the engine runs by number.
function script.event_506()
	local argc: s32 = 0
	local argc_2: s32 = 0
	event.AddItem(210, 28)
	event.AddItem(214)
	event.AddItem(216)
	event.AddItem(220)
	event.AddItem(224)
	event.AddItem(235)
	event.AddItem(231, 20)
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		event.SetFadeOut(10)
		helper_888ab2a3(10)
		event.GotoMenu(16)
		vm.wait(2)
		event.SetFadeIn(10)
	end
	event.SetBitCtrl(2, 0)
	event.GotoEditmode(0)
	vm.wait(3)
end

--- Event 507, which map data, a script or the engine runs by number.
function script.event_507()
	event.SetFlag(42, 1)
	helper_1e9a4()
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	vm.wait(1)
	event.LoadScript("g01/g01b.stb", 150)
end

--- Event 650, which map data, a script or the engine runs by number.
function script.event_650()
	vm.wait(1)
	event.LoadScript("g01/rush_g01.stb", 500)
end

--- Event 651, which map data, a script or the engine runs by number.
script.event_651 = helper_1b6a8

--- Event 690, which map data, a script or the engine runs by number.
script.event_690 = helper_df3c

--- Event 12080, which map data, a script or the engine runs by number.
function script.event_12080()
	vm.wait(1)
	event.LoadScript("g01/g01b.stb", 501)
end

--- Event 12090, which map data, a script or the engine runs by number.
function script.event_12090()
	helper_1b6a8()
	event.SetFadeOut(15)
	helper_888ab2a3(15)
	vm.wait(3)
	event.MapJump_3(-1, "g01i07", 501)
	vm.wait(4)
end

--- Event 12542, which map data, a script or the engine runs by number.
script.event_12542 = helper_1e9a4

return script
