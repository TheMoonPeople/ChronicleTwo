--!strict
-- map/i/i04/h03/i04h03_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_000001fe = require("@lib/event/helper_000001fe")
local helper_036a108f = require("@lib/event/helper_036a108f")
local helper_09b575ea = require("@lib/event/helper_09b575ea")
local helper_0f1a8d4c = require("@lib/event/helper_0f1a8d4c")
local helper_116d1683 = require("@lib/event/helper_116d1683")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_16701010 = require("@lib/event/helper_16701010")
local helper_4005e7b5 = require("@lib/event/helper_4005e7b5")
local helper_448f910b = require("@lib/event/helper_448f910b")
local helper_46eb7abe = require("@lib/event/helper_46eb7abe")
local helper_4704d9e3 = require("@lib/event/helper_4704d9e3")
local helper_5ac5e171 = require("@lib/event/helper_5ac5e171")
local helper_65c6dddf = require("@lib/event/helper_65c6dddf")
local helper_702eb091 = require("@lib/event/helper_702eb091")
local helper_7044c034 = require("@lib/event/helper_7044c034")
local helper_7d9a42e5 = require("@lib/event/helper_7d9a42e5")
local helper_8333218b = require("@lib/event/helper_8333218b")
local helper_8fdf0f7d = require("@lib/event/helper_8fdf0f7d")
local helper_93338a9a = require("@lib/event/helper_93338a9a")
local helper_a45deb91 = require("@lib/event/helper_a45deb91")
local helper_a6c70497 = require("@lib/event/helper_a6c70497")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_c03811a5 = require("@lib/event/helper_c03811a5")
local helper_c2be70c8 = require("@lib/event/helper_c2be70c8")
local helper_ce0590af = require("@lib/event/helper_ce0590af")
local helper_d0af65fd = require("@lib/event/helper_d0af65fd")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_d8d161f8 = require("@lib/event/helper_d8d161f8")
local helper_db5be1b1 = require("@lib/event/helper_db5be1b1")
local helper_db975eb7 = require("@lib/event/helper_db975eb7")
local helper_e7356421 = require("@lib/event/helper_e7356421")
local helper_e9cc4946 = require("@lib/event/helper_e9cc4946")
local helper_ee2fed44 = require("@lib/event/helper_ee2fed44")
local helper_f1049565 = require("@lib/event/helper_f1049565")
local helper_fdcff58e = require("@lib/event/helper_fdcff58e")
local helper_ff6f040f = require("@lib/event/helper_ff6f040f")

--- Helper function.
local function helper_3c838(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p08_i04h03")
	event.EohSetShow(0, arg0)
	event.FuncPointShow("", "func0", arg0)
end

--- Helper function.
local function helper_3c950()
	local flag: s32 = 0
	flag = event.GetFlag(37) or flag
	helper_3c838(if flag == 0 then 1 else 0)
end

--- Helper function.
local function helper_37e3c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_a45deb91(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "Hi there.\nIt's Monica, right?")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "I'm Parn.\nI'm a magical artist.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Hey Max.<page>How come you always\nlook so well?!")
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_38218(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		if at <= 2 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_126faf7c(1)
		end
		if at <= 5 then
			helper_126faf7c(1)
		end
		if at <= 6 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_126faf7c(0)
		end
		if at <= 8 then
			helper_b0211f82(30)
		end
		if at <= 9 then
			helper_d1353c5b(0, -1, 2, 341, 416)
		end
		if at <= 10 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_b0211f82(30)
		end
	end
	event.SetMotion(arg1, "立ち")
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(1)
	end
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
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "Hi there.\nIt's Monica, right?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "I'm Parn.\nI'm a magical artist.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "...")
	helper_d1353c5b(0, -1, 2, 341, 416)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)] Monica's not very good in this kind of \n   situation. She might get somewhere, but\n   probably not. Better try again as Max."
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_38f0c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(30)
		end
		if at <= 2 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_126faf7c(1)
		end
		if at <= 4 then
			helper_126faf7c(1)
		end
		if at <= 5 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_126faf7c(0)
		end
		if at <= 7 then
			helper_b0211f82(30)
		end
		if at <= 8 then
			helper_d1353c5b(0, -1, 2, 341, 416)
		end
		if at <= 9 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_126faf7c(0)
		end
		if at <= 13 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_126faf7c(1)
		end
		if at <= 16 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 18 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 19 then
			helper_b0211f82(30)
		end
	end
	event.SetMotion(arg1, "立ち")
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(1)
	end
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
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "Hey Max.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "I haven't introduced you yet, have I?<page>This is Julia, my wife-to-be.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(0, "...")
	helper_d1353c5b(0, -1, 2, 341, 416)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(0, "Yeah, you can laugh.\nI know it's strange!<page>Who'd fall in love with\na girl in a picture?")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"But I'm a magical artist.\nI have the power to make the things I draw real.<page>Whatever I draw really does exist in the picture.\nAs long as it's not a living thing..."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "Even a magical artist can't draw life.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 3.1415927, 0.0, 30)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "立ち")
	event.MesMake_2(0, "But, I've heard of a way.\nThere's a Golden Egg in a big, old tree.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "It's said that with its golden colour,\nyou can give life to anything you draw.")
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsRotation(1, 0.0, 0.17, 0.0, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	event.MesMake_2(
		0,
		"Max, you're going out of\ntown, right?<page>I wonder if you could get hold of some Golden Paint?"
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.MesMake_2(
		0,
		"Of course I don't expect you to do it for nothing.<page>If you can help me, I'll use\nmy new power to help you in return."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]A big, old tree...\n   With  a Golden Egg! Where on earth\n   would you find a tree like that?!"
	)
	helper_d1353c5b(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(20)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.ResetCamera(1, 3.14, 20.0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_3a3ac(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_38218(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	helper_38f0c(arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_3a51c()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4005e7b5(1, 4)
			helper_d1353c5b(1, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_4005e7b5(1, 4)
	event.MesMake_2(1, "Julia joined your party.\nJulia went to the train.")
	helper_d1353c5b(1, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3a6c0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 3 then
				helper_b8950300(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			helper_b0211f82(30)
		end
		if at <= 8 then
			helper_b8950300(0, -1, var5, 0, 0)
		end
		if at <= 9 then
			helper_126faf7c(1)
		end
		if at <= 10 then
			helper_b0211f82(60)
		end
		if at <= 11 then
			helper_b0211f82(60)
		end
		if at <= 12 then
			helper_b0211f82(60)
		end
		if at <= 13 then
			helper_b0211f82(30)
		end
		if at <= 14 then
			helper_b0211f82(30)
		end
		if at <= 15 then
			helper_b0211f82(30)
		end
		if at <= 16 then
			helper_b0211f82(30)
		end
		if at <= 17 then
			helper_b8950300(0, -1, var5, 0, 0)
		end
		if at <= 18 then
			helper_126faf7c(2)
		end
		if at <= 19 then
			helper_b8950300(0, -1, 32, 0, 0)
		end
		if at <= 20 then
			helper_126faf7c(1)
		end
		if at <= 21 then
			helper_b8950300(0, -1, var5, 0, 0)
		end
		if at <= 22 then
			helper_d8d161f8(5)
		end
		if at <= 23 then
			helper_3a51c()
		end
		if at <= 24 then
			helper_b0211f82(35)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_a45deb91(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "I guess girls just can't understand\nwhy men feel like they have to\npursue their ideals.")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_a45deb91(arg0, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"I've been waiting for you.<page>Quick, give me the Paint so that\nI can give life to my picture."
	)
	helper_b8950300(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.GotoUseItem(376)
	do
		local skipped = vm.wait()
		var3 = event.DeferredOutput() or var3
		if skipped then
			return skip(5)
		end
	end
	if var3 <= 0 then
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var3 ~= 376 then
		event.MesMake_2(0, "You must be joking!<page>What I need is Golden Paint.\nGet it right!")
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.Initialize()
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(7)
	end
	event.LoadSound(2827)
	var4 = event.SndLoadSound(2827) or var4
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
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "So this is Golden Paint...\nI'll try it straight away.")
	helper_b8950300(0, -1, var5, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 60.0, 0.0, -100.0, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "会話")
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(1, 33)
	event.ObjsSetPos(3, 45.0, 15.0, -90.0)
	event.ObjsSetMotion(3, "ラフレシアの光", 6)
	event.SndSePlay(var4, 2)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30, 250.0, 250.0, 250.0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CharaActive(0, 33)
	event.CharaActive(1, 32)
	event.ObjsSetPos(2, 45.0, 15.0, -90.0)
	event.ObjsSetRot(2, 0.0, -0.7853982, 0.0)
	event.ObjsSetMotion(2, "立ち")
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeIn(30, 255.0, 255.0, 255.0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(16)
	end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "Sh-she... She's real...<page>Amazing, she's perfect!")
	helper_b8950300(0, -1, var5, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "歩き")
	event.ObjsReference(2, 30.52, 0.2, -56.3, 30)
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(2, "会話")
	event.MesMake_2(0, "Hi, I'm Julia. \nIt's a pleasure to meet you.")
	helper_b8950300(0, -1, 32, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, 30.52, 0.2, -56.3, 30)
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(1, "会話")
	event.MesMake_2(0, "Thanks, Max.\nI haven't forgotten my promise. Please use\nmy new power whenever you want.")
	helper_b8950300(0, -1, var5, 0, 0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(1, "立ち")
	event.SetNpcStatus(5, 128)
	helper_d8d161f8(5)
	if vm.skipping() then
		return skip(23)
	end
	event.SetNpcStatus(22, 130)
	helper_3a51c()
	if vm.skipping() then
		return skip(24)
	end
	event.SetFadeOut(30)
	helper_b0211f82(35)
	if vm.skipping() then
		return skip(25)
	end
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
	local skip: (number) -> ...any
	function skip(at: number) end
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
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3c4d4(arg0: s32)
	local player_chara: s32 = 0
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
	player_chara = event.GetControlChrid() or player_chara
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_37e3c(arg0, player_chara)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_3a3ac(arg0, player_chara)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_3a6c0(arg0, player_chara)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_3c184(arg0, player_chara)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_11ecc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8950300(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_f1049565(arg0, -1, 0, 0)
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
		helper_b8950300(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.MesMake_2(
			0,
			"Oh, Max! You scared me.\nI was just taking some nasty bugs\noff this tree.<page>Not all trees grow up fine on\ntheir own, you know. Some, like\nthis one, you have to really watch."
		)
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_13ee4(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_11ecc(arg0, arg1)
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
		helper_11ecc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_db975eb7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_036a108f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_ce0590af(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_352a8(arg0: s32, arg1: s32)
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
				helper_13ee4(arg0, arg1)
			end
			if at <= 2 then
				helper_c2be70c8(arg0, arg1)
			end
			if at <= 3 then
				var7 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_b0211f82(30)
			end
			return
		end
		if at <= 9 then
			if at <= 8 then
				var8 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 10 then
				helper_b0211f82(30)
			end
			return
		end
		if at <= 18 then
			if at <= 13 then
				helper_5ac5e171(arg0, arg1)
			end
			if at <= 14 then
				helper_93338a9a(arg0, arg1)
			end
			if at <= 15 then
				helper_fdcff58e(arg0, arg1)
			end
			if at <= 16 then
				helper_ff6f040f(arg0, arg1)
			end
			if at <= 17 then
				var11 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 19 then
			return
		end
		if at <= 23 then
			if at <= 20 then
				helper_c03811a5(arg0, arg1)
			end
			if at <= 21 then
				helper_46eb7abe(arg0, arg1)
			end
			if at <= 22 then
				var14 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 24 then
			return
		end
		if at <= 29 then
			if at <= 25 then
				helper_e9cc4946(arg0, arg1)
			end
			if at <= 26 then
				helper_16701010(arg0, arg1)
			end
			if at <= 27 then
				helper_e7356421(arg0, arg1)
			end
			if at <= 28 then
				var17 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 30 then
			return
		end
		if at <= 39 then
			if at <= 31 then
				helper_116d1683(arg0, arg1)
			end
			if at <= 32 then
				helper_a6c70497(arg0, arg1)
			end
			if at <= 33 then
				helper_db5be1b1(arg0, arg1)
			end
			if at <= 34 then
				helper_65c6dddf(arg0, arg1)
			end
			if at <= 35 then
				helper_8fdf0f7d(arg0, arg1)
			end
			if at <= 36 then
				helper_d0af65fd(arg0, arg1)
			end
			if at <= 37 then
				helper_09b575ea(arg0, arg1)
			end
			if at <= 38 then
				var20 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 40 then
			return
		end
		if at <= 41 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 42 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 43 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 44 then
			helper_f1049565(arg0, -1, 0, 0)
		end
		if at <= 45 then
			helper_f1049565(arg0, -1, 0, 0)
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
		helper_13ee4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 5 then
		helper_c2be70c8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			event.MesMake_2(0, "Let me shop\nDig for a scoop")
			var7 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			if var7 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var7 == 1 then
				local t0 = helper_448f910b(0)
				if vm.skipping() then
					return skip(5)
				end
				if t0 ~= 0 then
					event.SetFadeOut(25)
					helper_b0211f82(30)
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
				helper_702eb091()
				if vm.skipping() then
					return skip(8)
				end
			end
		else
			event.MesMake_2(0, "Be my friend!\nDig for a scoop")
			var8 = helper_ee2fed44(arg0, -1, 2, 0, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			if var8 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var8 == 1 then
				local t1 = helper_448f910b(0)
				if vm.skipping() then
					return skip(10)
				end
				if t1 ~= 0 then
					event.SetFadeOut(25)
					helper_b0211f82(30)
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
				helper_7044c034(arg0, arg1)
				if vm.skipping() then
					return skip(13)
				end
			end
		end
	end
	if var3 == 7 then
		helper_5ac5e171(arg0, arg1)
		if vm.skipping() then
			return skip(14)
		end
	end
	if var3 == 8 then
		helper_93338a9a(arg0, arg1)
		if vm.skipping() then
			return skip(15)
		end
	end
	if var3 == 10 then
		helper_fdcff58e(arg0, arg1)
		if vm.skipping() then
			return skip(16)
		end
	end
	if var3 == 11 then
		helper_ff6f040f(arg0, arg1)
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
			var11 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(18)
			end
			if var11 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var11 == 1 then
				helper_c03811a5(arg0, arg1)
				if vm.skipping() then
					return skip(19)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_702eb091()
			if vm.skipping() then
				return skip(20)
			end
		else
			helper_c03811a5(arg0, arg1)
			if vm.skipping() then
				return skip(21)
			end
		end
	end
	if var3 == 14 then
		helper_46eb7abe(arg0, arg1)
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
			var14 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(23)
			end
			if var14 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var14 == 1 then
				helper_e9cc4946(arg0, arg1)
				if vm.skipping() then
					return skip(24)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_702eb091()
			if vm.skipping() then
				return skip(25)
			end
		else
			helper_e9cc4946(arg0, arg1)
			if vm.skipping() then
				return skip(26)
			end
		end
	end
	if var3 == 16 then
		helper_16701010(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 17 then
		helper_e7356421(arg0, arg1)
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
			var17 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(29)
			end
			if var17 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var17 == 1 then
				helper_116d1683(arg0, arg1)
				if vm.skipping() then
					return skip(30)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_702eb091()
			if vm.skipping() then
				return skip(31)
			end
		else
			helper_116d1683(arg0, arg1)
			if vm.skipping() then
				return skip(32)
			end
		end
	end
	if var3 == 19 then
		helper_a6c70497(arg0, arg1)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 20 then
		helper_db5be1b1(arg0, arg1)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 21 then
		helper_65c6dddf(arg0, arg1)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 23 then
		helper_8fdf0f7d(arg0, arg1)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 24 then
		helper_d0af65fd(arg0, arg1)
		if vm.skipping() then
			return skip(37)
		end
	end
	if var3 == 25 then
		helper_09b575ea(arg0, arg1)
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
			var20 = helper_0f1a8d4c(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(39)
			end
			if var20 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var20 == 1 then
				helper_000001fe(arg0, arg1)
				if vm.skipping() then
					return skip(40)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_702eb091()
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
		helper_f1049565(arg0, -1, 0, 0)
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
		helper_f1049565(arg0, -1, 0, 0)
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
		helper_f1049565(arg0, -1, 0, 0)
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
		helper_f1049565(arg0, -1, 0, 0)
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
		helper_f1049565(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(46)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_37cc0()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_352a8(var1, player_chara)
		end
		if at <= 2 then
			helper_4704d9e3()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_352a8(var1, player_chara)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_4704d9e3()
		if vm.skipping() then
			return skip(3)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_3c950

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 400.
script[400] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c838(0)
			helper_7d9a42e5(1)
		end
	end
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(37) or flag
	if flag == 0 then
		event.SetFlag(37, 1)
		event.AddItem(243, 20)
		helper_8333218b(243, 20)
		if vm.skipping() then
			return skip(1)
		end
		helper_3c838(0)
		helper_7d9a42e5(1)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_37cc0()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 5 then
		var1 = event.GetEventData_2(13) or var1
		event.CtrlcStay()
		event.SetAi(0, var1)
		helper_3c4d4(var1)
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var1)
	else
		helper_37cc0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
