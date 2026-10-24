--!strict
-- map/i/i04/h03/i04h03_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0579a945 = require("@lib/event/helper_0579a945")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_186669aa = require("@lib/event/helper_186669aa")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_5e868d47 = require("@lib/event/helper_5e868d47")
local helper_809643bd = require("@lib/event/helper_809643bd")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_ad047ca5 = require("@lib/event/helper_ad047ca5")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_e28b3446 = require("@lib/event/helper_e28b3446")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")

--- Helper function.
local function helper_38218(arg0: s32, arg1: s32)
	event.SetMotion(arg1, "立ち")
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.Initialize()
	event.SetMesPreset(0, 0)
	event.EohSyncChara(0, arg1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, arg0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CmrsInit()
	event.CmrsSetPos(-41.63, 18.05, -20.16)
	event.CmrsSetRef(30.4, 34.28, -73.36)
	event.ObjsSetPos(0, 30.52, 0.2, -56.3)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 23.52, 0.2, -84.52)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_25abe6d2(30)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "Hi there.\nIt's Monica, right?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "I'm Parn.\nI'm a magical artist.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	helper_0958ca60(1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_0958ca60(1)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, 60.0, 0.0, -100.0, 30)
	helper_0958ca60(0)
	event.ObjsSetMotion(0, "立ち")
	helper_25abe6d2(30)
	event.MesMake_2(0, "...")
	helper_a3cc6850(0, -1, 2, 341, 416)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)] Monica's not very good in this kind of \n   situation. She might get somewhere, but\n   probably not. Better try again as Max."
	)
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.SetMesPreset(0, 0)
	event.Finish()
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_38f0c(arg0: s32, arg1: s32)
	event.SetMotion(arg1, "立ち")
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.Initialize()
	event.SetMesPreset(0, 0)
	event.EohSyncChara(0, arg1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, arg0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CmrsInit()
	event.CmrsSetPos(-41.63, 18.05, -20.16)
	event.CmrsSetRef(30.4, 34.28, -73.36)
	event.ObjsSetPos(0, 30.52, 0.2, -56.3)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 23.52, 0.2, -84.52)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_25abe6d2(30)
	event.MesMake_2(0, "Hey Max.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	helper_0958ca60(1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_0958ca60(1)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, 60.0, 0.0, -100.0, 30)
	helper_0958ca60(0)
	event.ObjsSetMotion(0, "立ち")
	helper_25abe6d2(30)
	event.MesMake_2(0, "...")
	helper_a3cc6850(0, -1, 2, 341, 416)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "Yeah, you can laugh.\nI know it's strange!<page>Who'd fall in love with\na girl in a picture?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"But I'm a magical artist.\nI have the power to make the things I draw real.<page>Whatever I draw really does exist in the picture.\nAs long as it's not a living thing..."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Even a magical artist can't draw life.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 3.1415927, 0.0, 30)
	helper_0958ca60(0)
	event.ObjsSetMotion(0, "立ち")
	event.MesMake_2(0, "But, I've heard of a way.\nThere's a Golden Egg in a big, old tree.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "It's said that with its golden colour,\nyou can give life to anything you draw.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsRotation(1, 0.0, 0.17, 0.0, 30)
	helper_0958ca60(1)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(
		0,
		"Max, you're going out of\ntown, right?<page>I wonder if you could get hold of some Golden Paint?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Of course I don't expect you to do it for nothing.<page>If you can help me, I'll use\nmy new power to help you in return."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]A big, old tree...\n   With  a Golden Egg! Where on earth\n   would you find a tree like that?!"
	)
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.SetMesPreset(0, 0)
	event.Finish()
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_3a3ac(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_38218(arg0, arg1)
		return
	end
	helper_38f0c(arg0, arg1)
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_3a51c()
	event.SetMesPreset(1, 4)
	helper_125385ee(1, 4)
	event.MesMake_2(1, "Julia joined your party.\nJulia went to the train.")
	helper_a3cc6850(1, -1, 8, 0, 0)
end

--- Helper function.
local function helper_3a6c0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_c8484b43(arg0, 0, 0)
		event.MesMake_2(0, "I guess girls just can't understand\nwhy men feel like they have to\npursue their ideals.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"I've been waiting for you.<page>Quick, give me the Paint so that\nI can give life to my picture."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	var3 = event.GotoUseItem(376) or var3
	vm.wait(5)
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 376 then
		event.MesMake_2(0, "You must be joking!<page>What I need is Golden Paint.\nGet it right!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.Initialize()
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.LoadSound(2827)
	var4 = event.SndLoadSound_2(2827) or var4
	var5 = event.SearchCharaNo(5) or var5
	event.SetAi(0, var5)
	event.EohSyncChara(1, var5)
	event.ObjsInit(1, var5)
	event.ObjsSyncObj(1, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "chara/p01_25a.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.EohSyncChara(2, 32)
	event.ObjsInit(2, 32)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e200/e255/e255_rafhikari.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(3, 33)
	event.ObjsInit(3, 33)
	event.ObjsSyncObj(3, 3)
	event.CmrsInit()
	event.CmrsSetPos(-41.63, 18.05, -20.16)
	event.CmrsSetRef(30.4, 34.28, -73.36)
	event.SetCharaPos(0, 30.52, 0.2, -56.3)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.SetMotion(0, "立ち")
	event.ObjsSetPos(1, 23.52, 0.2, -84.52)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_25abe6d2(30)
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "So this is Golden Paint...\nI'll try it straight away.")
	helper_b5a98ffa(0, -1, var5, 0, 0)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_0958ca60(1)
	event.ObjsSetMotion(1, "会話")
	helper_25abe6d2(60)
	event.ObjsSetMotion(1, "立ち")
	helper_25abe6d2(60)
	event.CharaActive(1, 33)
	event.ObjsSetPos(3, 45.0, 15.0, -90.0)
	event.ObjsSetMotion(3, "ラフレシアの光", 6)
	event.SndSePlay(var4, 2)
	helper_25abe6d2(60)
	event.SetFadeOut(30, 250.0, 250.0, 250.0)
	helper_25abe6d2(30)
	event.CharaActive(0, 33)
	event.CharaActive(1, 32)
	event.ObjsSetPos(2, 45.0, 15.0, -90.0)
	event.ObjsSetRot(2, 0.0, -0.7853982, 0.0)
	event.ObjsSetMotion(2, "立ち")
	helper_25abe6d2(30)
	event.SetFadeIn(30, 255.0, 255.0, 255.0)
	helper_25abe6d2(30)
	helper_25abe6d2(30)
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "Sh-she... She's real...<page>Amazing, she's perfect!")
	helper_b5a98ffa(0, -1, var5, 0, 0)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "歩き")
	event.ObjsReference(2, 30.52, 0.2, -56.3, 30)
	helper_0958ca60(2)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(2, "会話")
	event.MesMake_2(0, "Hi, I'm Julia. \nIt's a pleasure to meet you.")
	helper_b5a98ffa(0, -1, 32, 0, 0)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 30.52, 0.2, -56.3, 30)
	helper_0958ca60(1)
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "Thanks, Max.\nI haven't forgotten my promise. Please use\nmy new power whenever you want.")
	helper_b5a98ffa(0, -1, var5, 0, 0)
	event.ObjsSetMotion(1, "立ち")
	event.SetNpcStatus(5, 128)
	helper_5e868d47(5)
	event.SetNpcStatus(22, 130)
	helper_3a51c()
	event.SetFadeOut(30)
	helper_25abe6d2(35)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
	event.SetAi(1, var5)
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_3c184(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(
				0,
				"I guess girls just can't understand\nwhy men feel like they have to\npursue their ideals."
			)
		else
			event.MesMake_2(0, "Please use my new power\nwhenever you want.")
		end
	else
		event.MesMake_2(
			0,
			"The world of pictures is very deep.\nIt may take me a lifetime to master\nbut the journey is well worth it."
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

--- Helper function.
local function helper_3c4d4(arg0: s32)
	local player_chara: s32 = 0
	local var2: s32 = 0
	player_chara = event.GetControlChrid() or player_chara
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e28b3446(arg0, player_chara)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_3a3ac(arg0, player_chara)
		return
	end
	if var2 == 1 then
		helper_3a6c0(arg0, player_chara)
		return
	end
	if var2 == 2 then
		helper_3c184(arg0, player_chara)
		return
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_809643bd

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local flag: s32 = 0
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(37) or flag
	if flag == 0 then
		event.SetFlag(37, 1)
		event.AddItem(243, 20)
		helper_e8257c69(243, 20)
		helper_186669aa(0)
		helper_a87eb945(1)
	end
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.GetEventData_2(14) or var0
		if var0 == 5 then
			var1 = event.GetEventData_2(13) or var1
			event.CtrlcStay()
			event.SetAi(0, var1)
			at = 1
			helper_3c4d4(var1)
			event.SetAi(1, var1)
		else
			at = 2
			helper_0579a945()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 2 then
			end
			if at <= 1 then
				helper_ad047ca5()
			end
			return 0
		end
		return nil
	end)
end

return script
