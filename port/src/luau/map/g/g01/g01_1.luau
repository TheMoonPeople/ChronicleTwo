--!strict
-- map/g/g01/g01_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_165a2825 = require("@lib/event/helper_165a2825")
local helper_342a37b0 = require("@lib/event/helper_342a37b0")
local helper_41b1236d = require("@lib/event/helper_41b1236d")
local helper_50c5e4dc = require("@lib/event/helper_50c5e4dc")
local helper_59d97f4a = require("@lib/event/helper_59d97f4a")
local helper_64b3a7ae = require("@lib/event/helper_64b3a7ae")
local helper_65950238 = require("@lib/event/helper_65950238")
local helper_7b50e496 = require("@lib/event/helper_7b50e496")
local helper_7fce5425 = require("@lib/event/helper_7fce5425")
local helper_a8e031ba = require("@lib/event/helper_a8e031ba")
local helper_bbaf9470 = require("@lib/event/helper_bbaf9470")
local helper_c5ea1698 = require("@lib/event/helper_c5ea1698")
local helper_ccc22d40 = require("@lib/event/helper_ccc22d40")
local helper_df58599d = require("@lib/event/helper_df58599d")
local helper_e8b18690 = require("@lib/event/helper_e8b18690")
local helper_ec482fb4 = require("@lib/event/helper_ec482fb4")
local helper_ee09935e = require("@lib/event/helper_ee09935e")
local helper_ef567071 = require("@lib/event/helper_ef567071")
local helper_f9f6d02f = require("@lib/event/helper_f9f6d02f")

local global0: s32 = 0
local global1: s32 = 0

--- Program 99.
local function program_99()
	local flag: s32 = 0
	flag = event.GetFlag(250) or flag
	if flag ~= 0 then
		event.SetBitCtrl(2, 0)
	else
		event.SetBitCtrl(2, 1)
	end
end

--- Helper function.
local function helper_229d0()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e8b18690(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
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
		helper_e8b18690(60)
		if vm.skipping() then
			return skip(2)
		end
		event.ResetCamera(0)
	end
end

--- Helper function.
local function helper_233dc()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(207) or flag
	if flag == 1 then
		flag = event.GetFlag(208) or flag
		if flag == 0 then
			event.SetFadeOut(0)
			if vm.wait() then
				return skip(2)
			end
			event.LoadScript("g01/g01b_1.stb", 501)
		end
	end
end

--- Helper function.
local function helper_23110()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_19c08()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetAnalyze(103) or var1
	if var1 == 0 then
		return 0
	end
	flag = event.GetFlag(270) or flag
	if flag ~= 0 then
		return 0
	end
	var2 = event.CheckEnableCharaChange(1) or var2
	if var2 == 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1a1f0()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetAnalyze(103) or var1
	if var1 == 0 then
		return 0
	end
	flag = event.GetFlag(260) or flag
	if flag == 0 then
		return 0
	end
	flag = event.GetFlag(280) or flag
	if flag ~= 0 then
		return 0
	end
	var2 = event.CheckEnableCharaChange(1) or var2
	if var2 == 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1a614()
	if helper_19c08() ~= 0 then
		return 1
	end
	if helper_342a37b0() ~= 0 then
		return 1
	end
	if helper_ee09935e() ~= 0 then
		return 1
	end
	if helper_1a1f0() ~= 0 then
		return 1
	end
	if helper_c5ea1698() ~= 0 then
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1a7b4(arg0: s32, arg1: s32)
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var5 = event.GetChapter() or var5
	if var5 >= 8 then
		return
	end
	event.SetMesWindowMode(1, 8)
	event.SetMotion(0, "立ち")
	var6 = 1050
	if helper_1a614() ~= 0 then
		var6 = 1051
	elseif arg0 ~= 0 then
		return
	end
	if arg1 ~= 0 then
		var6 = var6 + 10
	end
	event.MesMake_2(1, var6)
	helper_41b1236d(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1aacc(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1a7b4(arg0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_1a7b4(arg0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_10378(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_41b1236d(0, -1, 5, 0, 0)
		end
		helper_50c5e4dc()
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(612) or flag
	if flag == 0 then
		return
	end
	event.SetMesWindowMode(0, 12)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	if vm.wait() then
		return skip(2)
	end
	if arg0 ~= 0 then
		event.MesMake_2(0, "We jumped to the future with the\nIxion's time-travelling mechanism.")
	else
		event.MesMake_2(0, "We returned to the present with the\nIxion's time-travelling mechanism.")
	end
	if vm.wait() then
		return skip(3)
	end
	helper_41b1236d(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(6)
	end
	helper_50c5e4dc()
end

--- Helper function.
local function helper_1e2e8()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_1df50()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_1ef78()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 25 then
			if at <= 1 then
				helper_e8b18690(45)
			end
			if at <= 2 then
				helper_1e2e8()
				helper_e8b18690(30)
			end
			if at <= 3 then
				helper_41b1236d(0, -1, 3, 0, 416)
			end
			if at <= 5 then
				helper_65950238(0, -1, global0, global1, var4)
			end
			if at <= 6 then
				helper_65950238(0, -1, global1, global0, var4)
			end
			if at <= 7 then
				helper_65950238(0, -1, global0, global1, var4)
			end
			if at <= 8 then
				helper_65950238(0, -1, global1, global0, var4)
			end
			if at <= 9 then
				helper_df58599d(1)
			end
			if at <= 10 then
				helper_65950238(0, -1, global1, global0, var4)
			end
			if at <= 11 then
				helper_df58599d(1)
			end
			if at <= 12 then
				helper_65950238(0, -1, global0, global1, var4)
			end
			if at <= 13 then
				helper_df58599d(0)
			end
			if at <= 14 then
				helper_65950238(0, -1, global0, global1, var4)
			end
			if at <= 15 then
				helper_df58599d(0)
			end
			if at <= 16 then
				helper_65950238(0, -1, global1, global0, var4)
			end
			if at <= 17 then
				helper_df58599d(0)
			end
			if at <= 18 then
				helper_df58599d(1)
			end
			if at <= 19 then
				helper_65950238(0, -1, global0, global1, var4)
			end
			if at <= 20 then
				helper_df58599d(0)
			end
			if at <= 21 then
				helper_65950238(0, -1, global1, global0, var4)
			end
			if at <= 22 then
				helper_65950238(0, -1, global0, global1, var4)
			end
			if at <= 23 then
				helper_41b1236d(0, -1, 8, 0, 0)
			end
			if at <= 24 then
				helper_e8b18690(30)
			end
			if vm.skip_end() then
				return skip(26)
			end
			return part2()
		end
		helper_1df50()
	end
	function part2()
		event.CancelDramaScene()
		helper_1df50()
		event.SetMesPreset(0, 0)
		event.Finish()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(34, 1)
	event.Initialize()
	event.SetMesPreset(0, 0)
	event.SetFadeOut(30)
	helper_e8b18690(45)
	if vm.skipping() then
		return skip(2)
	end
	helper_1e2e8()
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
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	event.MesMake_2(
		0,
		"According to the Geostone you\nbrought back this time, if we want\nto bring Jurak back...<page>We need to get 'someone who knows\nabout trees' to immigrate to\nSindain."
	)
	helper_41b1236d(0, -1, 3, 0, 416)
	if vm.skipping() then
		return skip(4)
	end
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
	if vm.wait() then
		return skip(5)
	end
	event.ObjsResetDaPosition(1)
	event.SetPakuAnim(0, "通常口パク")
	event.MesMake_2(0, "Get someone to immigrate?")
	helper_65950238(0, -1, global0, global1, var4)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	event.MesMake_2(
		0,
		"That's right. There are lots of\npeople living in Palm Brinks,\nright?<page>We've got to get those people to\nimmigrate out into the world.\nThat way, the future will develop."
	)
	helper_65950238(0, -1, global1, global0, var4)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.MesMake_2(0, "Hmm. I see.")
	helper_65950238(0, -1, global0, global1, var4)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "向き直り", 2)
	event.ObjsNextMotion(1, "向き直りL", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目～上向き目")
	event.SetPakuAnim(1, "通常口パク")
	event.MesMake_2(0, "And so what we need right now is\n'someone who knows about trees,'\nhuh?")
	helper_65950238(0, -1, global1, global0, var4)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_df58599d(1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "顔向け", 2)
	event.ObjsNextMotion(1, "顔向けＬ", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "上向き目～通常目")
	event.SetPakuAnim(1, "通常口パク")
	event.MesMake_2(0, "Max, do you know anyone like that?")
	helper_65950238(0, -1, global1, global0, var4)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_df58599d(1)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "考える", 6)
	event.ObjsNextMotion(0, "考えるL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目あき～目とじ")
	event.SetPakuAnim(0, "通常口パク")
	event.MesMake_2(0, "Hmm. 'Someone who knows about\ntrees...'")
	helper_65950238(0, -1, global0, global1, var4)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	helper_df58599d(0)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "そうだ！！", 2)
	event.ObjsNextMotion(0, "そうだ！！L", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目とじ～目あき")
	event.SetPakuAnim(0, "わらい口パク")
	event.MesMake_2(0, "Oh, I've got it! Gordon!")
	helper_65950238(0, -1, global0, global1, var4)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	helper_df58599d(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "そうだ！！戻り", 2)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsSetMotion(1, "もどり", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	event.MesMake_2(0, "Gordon?")
	helper_65950238(0, -1, global1, global0, var4)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	helper_df58599d(0)
	if vm.skipping() then
		return skip(18)
	end
	helper_df58599d(1)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "モニカ見うなづき", 2)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	event.MesMake_2(
		0,
		"Yeah. He's our gardener. He's an\nexpert on trees. He's perfect!<page>I bet he's in our yard right now,\ntending to the flowers or\nsomething."
	)
	helper_65950238(0, -1, global0, global1, var4)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	helper_df58599d(0)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "わらい口パク")
	event.MesMake_2(0, "Really? That's great! Let's go!")
	helper_65950238(0, -1, global1, global0, var4)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "モニカ見うなづき", 2)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.MesMake_2(0, "OK!")
	helper_65950238(0, -1, global0, global1, var4)
	if vm.skipping() then
		return skip(23)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Go back to Palm Brinks and\n   look for Gordon, the gardener.\n   He should be in Max's yard."
	)
	helper_41b1236d(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(24)
	end
	event.SetFadeOut(30)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(25)
	end
	return part2()
end

--- Helper function.
local function helper_1ae54()
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
	event.LoadMes(0, 5, "event/e200/e209/e209_1.txt")
end

--- Helper function.
local function helper_1ab58()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
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
local function helper_1bc7c()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_y: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				helper_a8e031ba(2090010)
			end
			if at <= 2 then
				helper_df58599d(0)
			end
			if at <= 3 then
				helper_df58599d(1)
			end
			if at <= 4 then
				helper_e8b18690(14)
			end
			if at <= 5 then
				helper_a8e031ba(2090020)
			end
			if at <= 6 then
				helper_e8b18690(15)
			end
			if at <= 7 then
				helper_e8b18690(14)
			end
			if at <= 8 then
				helper_165a2825(2090030, 150)
			end
			if at <= 9 then
				helper_165a2825(2090040, 120)
			end
			if at <= 10 then
				helper_64b3a7ae(1)
			end
			if at <= 11 then
				helper_e8b18690(75)
			end
			if at <= 12 then
				helper_e8b18690(30)
			end
			if at <= 13 then
				helper_e8b18690(60)
			end
			if at <= 14 then
				helper_e8b18690(30)
			end
			if at <= 15 then
				helper_a8e031ba(2090050)
			end
			if at <= 16 then
				helper_a8e031ba(2090060)
			end
			if at <= 17 then
				helper_e8b18690(45)
			end
			if at <= 18 then
				helper_e8b18690(15)
			end
			if at <= 19 then
				helper_e8b18690(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
		helper_1ab58()
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.ObjsSetRot(10, 0.0, 0.0, 0.0)
		event.ObjsSetRot(11, 0.0, 0.0, 0.0)
		helper_1ab58()
		event.SetFadeIn(30)
	end
	event.SetFlag(209, 1)
	event.Initialize()
	var0 = event.SndLoadSound(2217) or var0
	helper_1ae54()
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
	helper_e8b18690(63)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "左・モニカ見", 6)
	event.ObjsNextMotion(0, "左・モニカ見L", 0)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "右を見る", 6)
	event.ObjsNextMotion(1, "右を見るL", 0)
	helper_a8e031ba(2090010)
	if vm.skipping() then
		return skip(2)
	end
	helper_df58599d(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_df58599d(1)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(2.14, 52.68, 63.32)
	event.CmrsSetRef(-43.71, 54.31, 61.35)
	event.ObjsSetPos(0, -44.21, 30.26, 69.36)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -40.8, 31.97, 53.53)
	event.ObjsSetRot(1, 0.0, 1.24, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "ひそひそ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "ひそひそL", 0)
	helper_e8b18690(14)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_a8e031ba(2090020)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "どうするのー！", 6)
	event.ObjsNextMotion(1, "どうするのー！L", 4)
	event.ObjsMotionDelay(0, 15)
	event.ObjsSetMotion(0, "左・モニカ見戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_e8b18690(14)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_165a2825(2090030, 150)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_165a2825(2090040, 120)
	if vm.skipping() then
		return skip(10)
	end
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
	helper_64b3a7ae(1)
	if vm.skipping() then
		return skip(11)
	end
	event.StreamPlay(1)
	helper_e8b18690(75)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var0, 5)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(13)
	end
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(var0, 6)
	event.ObjsRotation(10, 0.0, 0.78, 0.0, 30)
	event.ObjsRotation(11, 0.0, 0.78, 0.0, 30)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 37)
	event.CmrsSetPos(-78.2, 56.82, 61.3)
	event.CmrsSetRef(-24.35, 59.62, 61.68)
	event.ObjsSetPos(2, 2.98, 37.07, 62.41)
	event.ObjsSetRot(2, 0.0, -2.6, 0.0)
	event.ObjsSetMotion(2, "手招き", 4)
	helper_a8e031ba(2090050)
	if vm.skipping() then
		return skip(16)
	end
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
	helper_a8e031ba(2090060)
	if vm.skipping() then
		return skip(17)
	end
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
	helper_e8b18690(45)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "立ち", 4)
	event.SndSePlay(var0, 7)
	event.ObjsRotation(10, 0.0, 0.0, 0.0, 30)
	event.ObjsRotation(11, 0.0, 0.0, 0.0, 30)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.SetFadeOut(30)
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

--- Program 502.
local function program_502()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e8b18690(15)
		end
	end
	helper_1bc7c()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "g01i07", 501)
	if vm.wait() then
		return skip(4)
	end
end

--- Helper function.
local function helper_21ef8()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("2")
				helper_e8b18690(30)
			end
			if at <= 2 then
				print("3")
				helper_e8b18690(30)
			end
			return 1
		end
		var4 = var4 + 1
		return 0
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	var0 = helper_f9f6d02f(5, 16)
	if vm.skipping() then
		return skip(1)
	end
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
		helper_e8b18690(30)
		if vm.skipping() then
			return skip(2)
		end
		print("3")
		event.SetFadeOut(30)
		helper_e8b18690(30)
		if vm.skipping() then
			return skip(3)
		end
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
	var4 = 0
	while var4 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.CmrsSetRef(var1, var2 + 30.0, var3)
		if vm.wait() then
			return skip(4)
		end
		var4 = var4 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	return 0
end

--- Helper function.
local function helper_108f0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_7b50e496()
			end
			if at <= 2 then
				helper_ec482fb4()
			end
			if at <= 3 then
				helper_e8b18690(30)
			end
			if at <= 4 then
				helper_df58599d(0)
			end
			if at <= 5 then
				helper_ec482fb4()
			end
			if at <= 6 then
				helper_df58599d(6)
			end
			if at <= 7 then
				helper_e8b18690(60)
			end
			if at <= 8 then
				helper_e8b18690(60)
			end
			if at <= 9 then
				helper_10378(1)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		else
			event.SndSeStop(var13, 0)
		end
		event.FadeOutBgm(30)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no == 1 then
			event.DeleteChara(32)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	flag = event.GetFlag(612) or flag
	event.SetMotion(0, "立ち")
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_7b50e496()
	if vm.skipping() then
		return skip(2)
	end
	helper_ec482fb4()
	if vm.skipping() then
		return skip(3)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
	else
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
	end
	event.CharaActive(35)
	event.SetCharaType(35, 4)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 70.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(36)
	event.SetCharaType(36, 4)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 49.73999, 0.0, 8.969971)
		event.EohSetRot(2, 0.0, -1.76, 0.0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 0)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			end
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 1, 4, "info", 33)
			event.LoadEquip(5, 1, 3, "info", 33)
			event.LoadEquip(5, 1, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
		end
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 32)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
			end
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, 18.619995, 0.0, 35.179993)
		event.EohSetRot(1, 0.0, -2.48, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
		event.EohResetDaPosition(1)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
		event.LoadMotion(5, "event/e500/e523/e523_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
	end
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	end
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_e8b18690(30)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(-56.29, 15.74, 3.56)
		event.CmrsSetRef(-12.65, 16.48, 2.06)
	else
		event.CmrsSetPos(-48.179993, 19.61, -28.70996)
		event.CmrsSetRef(-0.789978, 16.48, -0.05999756)
	end
	if arg5 == 0 and arg4 == 0 and flag == 0 then
		event.CmrsSetPos(-30.09, 19.5, 4.41)
		event.CmrsSetRef(-14.63, 21.71, 1.0)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6, 0.45)
	event.ObjsNextMotion(0, "タイムワープL", 4)
	event.ObjsTexAnime(0, 1, "開閉口")
	helper_df58599d(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_ec482fb4()
	if vm.skipping() then
		return skip(6)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg4 ~= 0 then
		event.ObjsSetPos(6, pos_x, pos_y, pos_z)
	else
		event.ObjsSetPos(6, -3.54, 17.04, -1.46)
	end
	event.ObjsSetRot(6, -0.45, -2.12, 0.0)
	event.CmrsSetPos(-21.5, 23.92, -12.580017)
	event.CmrsSetRef(-0.789978, 16.17, -0.05999756)
	event.ObjsTexAnime(0, 0, "開閉口")
	event.ObjsTexAnime(0, 1, "開き口")
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	if flag == 0 then
		helper_df58599d(6)
		if vm.skipping() then
			return skip(7)
		end
	else
		event.SndSePlay(var12, 2)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	end
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, -2.12, 0.0)
	event.CmrsSetPos(-40.590027, 19.47, -24.339966)
	event.CmrsSetRef(13.950012, 15.23, 9.190002)
	event.CmrsMove2(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_e8b18690(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_10378(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_173fc(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_108f0(arg0, arg1, arg2, arg3, 1, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_108f0(arg0, arg1, arg2, arg3, 1, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_108f0(arg0, arg1, arg2, arg3, 1, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Helper function.
local function helper_17928()
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local var3: s32 = 0
	local angle: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_df58599d(2)
		end
		if at <= 2 then
			helper_df58599d(2)
		end
		if at <= 3 then
			helper_7b50e496()
		end
		if at <= 4 then
			helper_7b50e496()
		end
		if at <= 5 then
			helper_e8b18690(18)
		end
		if at <= 6 then
			helper_e8b18690(5)
		end
		if at <= 7 then
			helper_df58599d(2)
		end
		if at <= 8 then
			helper_df58599d(0)
		end
		if at <= 9 then
			helper_e8b18690(18)
		end
		if at <= 10 then
			helper_e8b18690(5)
		end
		if at <= 11 then
			helper_df58599d(2)
		end
		if at <= 12 then
			helper_e8b18690(30)
		end
		if at <= 13 then
			var3 = 0
			angle = vm.f32(-2.9)
			var6 = 0
			var6 = vm.f32(var6 + vm.f32(0.04619989))
			var5 = vm.f32(vm.sin(var6) * vm.f32(0.3))
			angle = vm.f32(angle + var5)
			var3 = var3 + 1
		end
		if at <= 15 then
			helper_ccc22d40(64)
		end
	end
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
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove2(2, -1121.01, 995.31, -2048.83, 60, 2, 0.5)
	event.ObjsRotation(2, 0.0, -3.14, 0.0, 40)
	event.ObjsRotation(2, 0.0, 1.57, 0.0, 20)
	event.ObjsRotation2(2, 0.0, 0.16, 0.0, 20, 2, 0.5)
	helper_df58599d(2)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove2(2, -671.63, 447.09, -193.49, 80, 1, 0.4)
	event.CmrsMove2(-601.29, 522.11, 100.72, -654.5, 581.35, -117.24, 60, 0, 0.4)
	helper_df58599d(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_7b50e496()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-298.8, 199.33, -185.86)
	event.CmrsSetRef(-194.57, 243.43, 136.45)
	event.CharaActive(1, 10)
	event.CharaActive(1, 11)
	event.SetCharaPos(9, -221.16, 0.0, 293.2)
	event.SetCharaRot(9, 0.0, 3.14, 0.0)
	event.SetMotion(9, "木持ち浮遊", 4)
	event.CmrsMove2(-299.31, 60.07, -348.88, -167.05, 136.09, 169.13, 60, 0, 0.5)
	helper_7b50e496()
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "右の木を植える", 2)
	event.ObjsNextMotion(2, "右の木を植えるL", 4)
	helper_e8b18690(18)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(0, "右へよける", 6)
	event.SetMotion(8, "左へよける", 6)
	helper_e8b18690(5)
	if vm.skipping() then
		return skip(7)
	end
	do
		local out1, _, out3 = event.EohGetFramePos(2, "R_tree")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	event.DelReference(10)
	event.SetCharaPos(10, pos_x, 0.0, pos_z)
	event.SetMotion(10, "ぷるん", 6)
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_df58599d(2)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-280.52, 44.63, 49.11)
	event.CmrsSetRef(-280.82, 14.35, 12.64)
	event.SetCharaPos(0, -281.18, 0.0, 11.07)
	event.SetCharaPos(9, -291.16, 0.0, 293.2)
	event.ObjsSetMotion(0, "前を見る", 6)
	event.ObjsNextMotion(0, "前を見るL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目・おどろき")
	event.ObjsTexAnime(0, 1, "口・はっ")
	helper_df58599d(0)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-299.31, 60.07, -348.88)
	event.CmrsSetRef(-167.05, 136.09, 169.13)
	event.ObjsSetMotion(2, "左の木を植える", 2)
	event.ObjsNextMotion(2, "左の木を植えるL", 4)
	helper_e8b18690(18)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "左へよける", 6)
	helper_e8b18690(5)
	if vm.skipping() then
		return skip(11)
	end
	do
		local out1, _, out3 = event.EohGetFramePos(2, "L_tree")
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	event.DelReference(11)
	event.SetCharaPos(11, pos_x, 0.0, pos_z)
	event.SetMotion(11, "ぷるん", 6)
	event.CmrsQuake(0.0, 4.0, 0.0, 20)
	helper_df58599d(2)
	if vm.skipping() then
		return skip(12)
	end
	helper_e8b18690(30)
	if vm.skipping() then
		return skip(13)
	end
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
		if vm.wait() then
			return skip(14)
		end
	end
	if vm.wait() then
		return skip(15)
	end
	helper_ccc22d40(64)
	if vm.skipping() then
		return skip(16)
	end
	event.DelExtMotion(0)
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(13)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_229d0()
		end
		if at <= 2 then
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			helper_233dc()
		end
		if at <= 3 then
			helper_23110()
			helper_1aacc(1)
		end
	end
	program_99()
	old_map_no = event.GetOldMapNo() or old_map_no
	var1 = event.GetMapType(old_map_no) or var1
	if var1 ~= -1 then
		if var1 ~= 2 then
			if old_map_no == 25 then
				helper_59d97f4a()
			elseif old_map_no == 16 then
				helper_229d0()
				if vm.skipping() then
					return skip(1)
				end
			elseif old_map_no == 71 then
				event.SetFadeIn(30)
				event.SetCharaPos(0, 275.0, 35.7, 465.0)
				event.SetCharaRot(0, 0.0, -1.57, 0.0)
				event.ResetCamera(1, 0.0, 20.0)
			else
				helper_229d0()
				if vm.skipping() then
					return skip(2)
				end
			end
		end
	else
		print("------  <START EVENT> OLD MAP ERR   ------\n")
		event.GetOldInteriorMapNo()
		event.SetFadeIn(30)
	end
	helper_233dc()
	if vm.skipping() then
		return skip(3)
	end
	helper_23110()
	helper_1aacc(1)
	if vm.skipping() then
		return skip(4)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1ef78()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	helper_10378(1)
	if vm.skipping() then
		return skip(1)
	end
	helper_1ef78()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 200.
script[200] = function()
	local flag: s32 = 0
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
	flag = event.GetFlag(209) or flag
	if flag == 0 then
		program_502()
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	flag = event.GetFlag(247) or flag
	if flag == 1 then
		flag = event.GetFlag(250) or flag
		if flag == 0 then
			event.SetBitCtrl(2, 0)
			event.BgmLoadCancel()
			event.MapJump(-1, "g01i07", 100)
			if vm.wait() then
				return skip(2)
			end
			return
		end
	end
	flag = event.GetFlag(250) or flag
	if flag == 0 then
		event.MapJump(-1, "g01i07", 100)
		if vm.wait() then
			return skip(3)
		end
		return
	end
	if vm.wait() then
		return skip(4)
	end
	event.GotoInterior(-1, "g01i07", 100)
	if vm.wait() then
		return skip(5)
	end
end

--- Program 201.
script[201] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_21ef8() == 1
	if vm.skipping() then
		return skip(1)
	end
	if t0 then
		event.MapJump(-1, "s02")
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 300.
script[300] = function()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = helper_19c08()
		local _ = helper_1a1f0()
	end
	helper_173fc(-700.0, 0.0, -1000.0, 1.0)
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(103) or var0
	flag = event.GetFlag(270) or flag
	if (if var0 ~= 0 then helper_19c08() else 0) ~= 0 and flag == 0 then
		event.BgmLoadCancel()
	end
	flag_2 = event.GetFlag(280) or flag_2
	if (if var0 ~= 0 then helper_1a1f0() else 0) ~= 0 and flag_2 == 0 then
		event.BgmLoadCancel()
	end
	event.MapJump(-1, "f01")
end

--- Program 310.
script[310] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1aacc(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bbaf9470()
		end
	end
	helper_ef567071(0)
	var0 = helper_7fce5425(0)
	if vm.skipping() then
		return skip(1)
	end
	helper_bbaf9470()
	if var0 == 0 then
		event.GotoInterior(-1, "i01h01")
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("g01/g01b_1.stb", 501)
end

script[502] = program_502

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCameraPos(-715.15, 30.36, -736.79)
	event.SetCameraRef(-715.13, 14.54, -733.45)
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("g01/g01c_1.stb", 501)
	event.SetFadeOut(0)
end

--- Program 506.
script[506] = function()
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
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
		helper_e8b18690(10)
		if vm.skipping() then
			return skip(1)
		end
		event.GotoMenu(16)
		if vm.wait() then
			return skip(2)
		end
		event.SetFadeIn(10)
	end
	event.SetBitCtrl(2, 0)
	event.GotoEditmode(0)
	if vm.wait() then
		return skip(3)
	end
end

--- Program 507.
script[507] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(42, 1)
	helper_1ef78()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("g01/g01b_1.stb", 150)
end

--- Program 650.
script[650] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("g01/rush_g01_1.stb", 500)
end

--- Program 651.
script[651] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1bc7c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 690.
script[690] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_17928()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12080.
script[12080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("g01/g01b_1.stb", 501)
end

--- Program 12090.
script[12090] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e8b18690(15)
		end
	end
	helper_1bc7c()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_e8b18690(15)
	if vm.skipping() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.MapJump(-1, "g01i07", 501)
	if vm.wait() then
		return skip(4)
	end
end

--- Program 12542.
script[12542] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1ef78()
	if vm.skipping() then
		return skip(1)
	end
end

return script
