--!strict
-- map/m/m01/m01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0119cdf1 = require("@lib/event/helper_0119cdf1")
local helper_24df648f = require("@lib/event/helper_24df648f")
local helper_28505b7b = require("@lib/event/helper_28505b7b")
local helper_535bb029 = require("@lib/event/helper_535bb029")
local helper_58ba4dc1 = require("@lib/event/helper_58ba4dc1")
local helper_73110cf7 = require("@lib/event/helper_73110cf7")
local helper_7e912e1e = require("@lib/event/helper_7e912e1e")
local helper_9551b0ac = require("@lib/event/helper_9551b0ac")
local helper_a19f2806 = require("@lib/event/helper_a19f2806")
local helper_a9f02643 = require("@lib/event/helper_a9f02643")
local helper_b476f5ad = require("@lib/event/helper_b476f5ad")
local helper_b8d9d9d0 = require("@lib/event/helper_b8d9d9d0")
local helper_be890c0c = require("@lib/event/helper_be890c0c")
local helper_fd1f0e04 = require("@lib/event/helper_fd1f0e04")

--- Helper function.
local function helper_2ef0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = 1
		var3 = 0
		var3 = 0
		return 0, arg1
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMesWindowMode(arg0) or var2
	var3 = 1
	if var2 == 7 then
		var3 = 0
	end
	if var2 == 0 then
		var3 = 0
	end
	var4 = event.GetMesStatus(arg0) or var4
	if var4 == 0 then
		return 0, arg1
	end
	if var4 == 1 then
		return 0, arg1
	end
	if var4 == 4 then
		return 0, arg1
	end
	pressed = event.CheckButton(0) or pressed
	pressed_2 = event.CheckButton(1) or pressed_2
	if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then
		if var3 ~= 0 then
			if pressed_2 ~= 0 then
				event.MesSePlay(0)
			end
			if pressed ~= 0 then
				event.MesSePlay(1)
			end
		end
		if var4 == 5 then
			event.MesNextpage(arg0)
		end
		if var4 == 3 then
			return 1, arg1
		end
		if var4 ~= 5 and var4 ~= 3 then
			event.SetMesDrawspeed(arg0, 0.0)
			event.TrgPakuMotion(2)
			arg1 = 2
		end
	end
	return 0, arg1
end

--- Helper function.
local function helper_3d18(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local loud: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
			var6 = 0
			loud = 0
			argc_2 = argc
			var2 = 2
			var7 = loud
			local t1: s32
			t1, var2 = helper_2ef0(arg0, var2)
			var5 = t1
			var6 = var6 + 1
		end
		var6 = vm.i32(var6 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetSavedataEtc(5) or var1
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var2 = 0
	var6 = 0
	argc_2 = event.StreamGetStatus(1) or argc_2
	loud = 0
	while true do
		argc_2 = argc
		argc = event.StreamGetStatus(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.TrgPakuMotion(2)
			var2 = 2
			if var1 ~= 0 then
				break
			end
		end
		var7 = loud
		loud = event.StreamSilentCheck(1) or loud
		if var7 == 0 and loud == 1 then
			event.TrgPakuAnim(1)
		end
		if var7 == 1 and loud == 0 then
			event.TrgPakuAnim(0)
		end
		local t0: s32
		t0, var2 = helper_2ef0(arg0, var2)
		var5 = t0
		if var5 ~= 0 then
			var6 = vm.i32(var6 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var6 = vm.i32(var6 + 1)
		end
	end
	if var2 == 0 then
		event.TrgPakuMotion(2)
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
end

--- Helper function.
local function helper_5d88(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_58ba4dc1(0, -1, 8, 0, 0)
			helper_3d18(0)
		end
		helper_b476f5ad(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
	helper_58ba4dc1(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3d18(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_b476f5ad(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_6078(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5d88(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5d88(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_3ca30()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_fd1f0e04(180)
			end
			if at <= 2 then
				helper_0119cdf1()
			end
			if at <= 3 then
				helper_fd1f0e04(30)
			end
			if at <= 4 then
				helper_be890c0c(0)
			end
			if at <= 5 then
				helper_fd1f0e04(30)
			end
			if at <= 6 then
				helper_6078(8000010)
			end
			if at <= 7 then
				helper_6078(8000020)
			end
			if at <= 8 then
				helper_6078(8000030)
			end
			if at <= 9 then
				helper_be890c0c(2)
			end
			if at <= 10 then
				helper_6078(8000035)
			end
			if at <= 11 then
				helper_6078(8000040)
			end
			if at <= 12 then
				helper_6078(8000050)
			end
			if at <= 13 then
				helper_6078(8000060)
			end
			if at <= 14 then
				helper_6078(8000065)
			end
			if at <= 15 then
				helper_6078(8000070)
			end
			if at <= 16 then
				helper_6078(8000080)
			end
			if at <= 17 then
				helper_6078(8000090)
			end
			if at <= 18 then
				helper_6078(8000100)
			end
			if at <= 19 then
				helper_6078(8000110)
			end
			if at <= 20 then
				helper_6078(8000120)
			end
			if at <= 21 then
				helper_6078(8000130)
			end
			if at <= 22 then
				helper_fd1f0e04(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(35)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, 1678.13, -48.85, -1729.46)
		event.SetCharaRot(0, 0.0, 2.95, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(800, 1)
	event.SetCameraPos(1863.34, -57.23, -1093.45)
	event.SetCameraRef(1673.6, -34.95, -1596.24)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_fd1f0e04(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(193)
	event.PlayBgm(0)
	var0 = event.SndLoadSound(1261) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e800/e800/")
	event.LoadMes(0, 5, "e800.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e800_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	event.LoadChara(5, "e800_need.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	block = event.LoadImg_4(5, "e800.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e80001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e80002", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(4, 1)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	event.EohSetPos(0, 1471.93, -90.0, -1214.38)
	event.EohSetRot(0, 0.0, 2.95, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, 1693.4, -48.85, -1747.04)
	event.EohSetRot(2, 0.0, -3.09, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1863.34, -57.23, -1093.45)
	event.CmrsSetRef(1673.6, -34.95, -1596.24)
	event.CharaActive(0)
	event.CmrsMove(1419.0, -57.23, -1121.53, 1673.6, -34.95, -1596.24, 300)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	helper_fd1f0e04(180)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 1616.06, -90.0, -1552.76, 120, 1)
	helper_0119cdf1()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(1819.9, 101.8, -1573.08)
	event.CmrsSetRef(1698.78, -1.69, -1732.94)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 1607.13, -77.8, -1633.37)
	event.ObjsSetRot(0, 0.0, 2.95, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsMove(0, 1657.71, -48.85, -1704.67, 60, 1)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_fd1f0e04(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "振り向き", 6)
	event.ObjsRotation(2, 0.0, -0.33, 0.0, 20)
	event.ObjsMotionDelay(2, 20)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_be890c0c(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_fd1f0e04(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000010)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6078(8000020)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(1680.47, -37.85, -1706.19)
	event.CmrsSetRef(1694.26, -26.32, -1748.64)
	event.EohSetFrameShow(2, "te_l", 0)
	event.EohSetFrameShow(2, "te_r", 0)
	event.EohSetFrameShow(2, "te_gl--v0", 1)
	event.EohSetFrameShow(2, "te_gr--v0", 1)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "しんけん顔")
	event.ObjsTexAnime(2, 1, "しんけん目パチ")
	event.SetStatus(1, 0, 256, 1)
	event.ObjsSetMotion(2, "エキサイト", 6)
	event.ObjsNextMotion(2, "エキサイト戻り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000030)
	if vm.skipping() then
		return skip(9)
	end
	helper_be890c0c(2)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000035)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(1819.9, 101.8, -1573.08)
	event.CmrsSetRef(1698.78, -1.69, -1732.94)
	event.EohSetFrameShow(2, "te_l", 1)
	event.EohSetFrameShow(2, "te_r", 1)
	event.EohSetFrameShow(2, "te_gl--v0", 0)
	event.EohSetFrameShow(2, "te_gr--v0", 0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000040)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_6078(8000050)
	if vm.skipping() then
		return skip(13)
	end
	event.SetStatus(1, 0, 256, 0)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000060)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000065)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_6078(8000070)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000080)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000090)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000100)
	if vm.skipping() then
		return skip(19)
	end
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_6078(8000110)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000120)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	event.CmrsSetPos(1704.99, -31.99, -1684.63)
	event.CmrsSetRef(1684.93, -26.32, -1741.26)
	event.ObjsSetPos(0, 1678.13, -48.85, -1729.46)
	event.ObjsSetRot(0, 0.0, 2.95, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetPakuAnim(2, "通常口パク")
	helper_6078(8000130)
	if vm.skipping() then
		return skip(22)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_fd1f0e04(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_1974(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaPos(0, arg0, arg1, arg2)
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Helper function.
local function helper_406fc()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetCameraRef(225.0, 30.0, 280.0)
	event.SetCameraPos(225.0, 30.0, 160.0)
	event.SetCharaPos(0, 225.0, 0.0, 280.0)
	event.SetCharaRot(0, 0.0, -3.14, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Helper function.
local function helper_40960()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetCameraRef(225.0, 30.0, 280.0)
	event.SetCameraPos(225.0, 30.0, 160.0)
	event.SetCharaPos(0, 200.0, 0.0, -20.8)
	event.SetCharaRot(0, 0.0, 1.89, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Helper function.
local function helper_dcc(arg0: s32)
	local get_pad_down: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.i32(bit32.band(get_pad_down, arg0))
	end
	if vm.skipping() then
		return skip(1)
	end
	get_pad_down = event.GetPaddown() or get_pad_down
	return vm.i32(bit32.band(get_pad_down, arg0))
end

--- Helper function.
local function helper_fd0(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_dcc(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_dcc(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_3b974()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_fd0(32)
		end
	end
	event.Initialize()
	event.CharaActive(0, 0)
	event.CharaActive(0, 122)
	event.CharaActive(0, 123)
	event.SetProjection(524.9)
	event.CmrsInit()
	event.CmrsSetPos(-2805.19, 378.19, -1591.92)
	event.CmrsSetRef(-2901.57, 398.3, -1620.79)
	helper_fd1f0e04(30)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsMove(-2805.19, 378.19, -1591.92, -2902.6, 398.3, -1571.73, 300)
	if vm.wait() then
		return skip(2)
	end
	helper_fd0(32)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, 0)
end

--- Helper function.
local function helper_43e0(arg0: any, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local stream_playing: s32 = 0
	local var7: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local pressed_3: s32 = 0
	local pressed_4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var2 = 0
		var3 = 0
		var2 = 1
		var3 = 1
		var5 = 1
		var5 = 0
		var5 = 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = 0
	var3 = 0
	if arg1 == 1 then
		var2 = 1
	end
	if arg1 == 2 then
		var3 = 1
	end
	var4 = event.GetMesWindowMode(arg0) or var4
	var5 = 1
	if var4 == 7 then
		var5 = 0
	end
	if var4 == 0 then
		var5 = 0
	end
	stream_playing = event.GetMesVoice() or stream_playing
	var7 = event.GetMesStatus(arg0) or var7
	if var7 == 0 then
		return 0
	end
	if var7 == 1 then
		return 0
	end
	if var7 == 3 then
		if stream_playing == 0 then
			event.TrgPakuAnim(0)
			event.TrgPakuMotion(1)
		end
	end
	if var7 == 4 then
		return 0
	end
	if var7 == 5 then
		if stream_playing == 0 then
			event.TrgPakuAnim(0)
			event.TrgPakuMotion(1)
		end
	end
	pressed = event.CheckButton(0) or pressed
	pressed_2 = event.CheckButton(1) or pressed_2
	pressed_3 = event.CheckButton(2) or pressed_3
	pressed_4 = event.CheckButton(3) or pressed_4
	if
		(
			if (if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then 1 else if var2 ~= 0 then pressed_3 else 0)
					~= 0
				then 1
				else if var3 ~= 0 then pressed_4 else 0
		) ~= 0
	then
		if var5 ~= 0 then
			if pressed_2 ~= 0 then
				event.MesSePlay(0)
			end
			if pressed ~= 0 then
				event.MesSePlay(1)
			end
			if (if var2 ~= 0 then pressed_3 else 0) ~= 0 then
				event.MesSePlay(0)
			end
			if (if var3 ~= 0 then pressed_4 else 0) ~= 0 then
				event.MesSePlay(0)
			end
		end
		if var7 == 5 then
			event.MesNextpage(arg0)
			if stream_playing == 0 then
				event.TrgPakuAnim(1)
				event.TrgPakuMotion(0)
			end
		end
		if var7 == 3 then
			if stream_playing == 0 then
				event.TrgPakuAnim(0)
				event.TrgPakuMotion(2)
			end
			if (if var2 ~= 0 then pressed_3 else 0) ~= 0 then
				return 2
			end
			if (if var3 ~= 0 then pressed_4 else 0) ~= 0 then
				return 3
			end
			return 1
		end
		if var7 ~= 5 and var7 ~= 3 then
			event.SetMesDrawspeed(arg0, 0.0)
			event.TrgPakuAnim(0)
			event.TrgPakuMotion(1)
			if stream_playing ~= 0 then
				event.StreamStop(1)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_7af8(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_43e0(arg0, arg1)
			arg2 = 0
			arg2 = 1
			arg2 = 1
			var4 = var4 + 1
		end
		var4 = vm.i32(var4 + 1)
		return var4, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var4 = 0
	while true do
		var3 = helper_43e0(arg0, arg1)
		if var3 ~= 0 then
			arg2 = 0
			if arg1 == 1 and var3 == 2 then
				arg2 = 1
			end
			if arg1 == 2 and var3 == 3 then
				arg2 = 1
			end
			var4 = vm.i32(var4 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var4 = vm.i32(var4 + 1)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	return var4, arg2
end

--- Helper function.
local function helper_85c0(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_58ba4dc1(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7af8(arg0, 0, var6)
		end
		helper_b476f5ad(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_58ba4dc1(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7af8(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_b476f5ad(arg0)
end

--- Program 248.
local function program_248()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "You can't enter here in the demo version.")
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
end

--- Helper function.
local function helper_424a8()
	local var0: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_fd1f0e04(15)
			end
			if at <= 2 then
				helper_fd1f0e04(30)
			end
			return 1
		end
		if at <= 4 then
			helper_fd1f0e04(45)
		end
		return 0
	end
	print("00000000000000000000000000\n")
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetMesWindowMode(0, 5)
	var0 = event.GetMenuEtc_2(1) or var0
	if var0 == 1 then
		event.MesMake_2(0, "『釣り大会会場前』に移動しますか？")
	else
		event.MesMake_2(0, "『ギョレース会場前』に移動しますか？")
	end
	print("11111111111111111111111111111111\n")
	var1 = helper_9551b0ac(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 0 then
		event.CmrsSetPos(1332.56, 67.86, 1494.1)
		event.CmrsSetRef(1508.0, 12.6, 1425.04)
		event.CmrsMove2(1332.56, 97.86, 1494.1, 1508.0, 42.6, 1425.04, 48, 2, 0.4)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		do
			local out1, out2, _ = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
		end
		event.ObjsSetPos(0, var2, var3, 1415.0)
		event.ObjsSetRot(0, 0.0, 1.57, 0.0)
		event.ObjsMove(0, 1800.0, var3, 1415.0, 90)
		helper_fd1f0e04(15)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_fd1f0e04(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, -1.57, 0.0, 15)
	helper_fd1f0e04(15)
	if vm.skipping() then
		return skip(4)
	end
	do
		local _, out2, out3 = event.GetCharaPos(0)
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.ObjsMove(0, 1480.0, var6, var7, 45)
	helper_fd1f0e04(45)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	return 0
end

--- Helper function.
local function helper_1bc8(arg0: any, arg1: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = vm.f32(arg1 - var5)
			var6 = vm.f32(var6 + vm.f32(6.2831855))
			var6 = vm.f32(var6 - vm.f32(6.2831855))
			var7 = 0.0
			var8 = vm.f32(helper_a19f2806(var6) * 8.0)
			var9 = helper_7e912e1e(0.0, var6, var7, var8)
			var9 = vm.f32(var9 + var5)
			var7 = vm.f32(var7 + 1.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var5 = out2 or var5
	end
	var6 = vm.f32(arg1 - var5)
	if var6 < vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if -0.5 < var6 and var6 < 0.5 then
	else
		event.SetMotion(arg0, "歩き")
	end
	var7 = 0.0
	var8 = vm.f32(helper_a19f2806(var6) * 8.0)
	while var7 < var8 do
		var9 = helper_7e912e1e(0.0, var6, var7, var8)
		var9 = vm.f32(var9 + var5)
		event.SetCharaRot(arg0, 0.0, var9, 0.0)
		var7 = vm.f32(var7 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.GetCharaRot(arg0) -- retail: argument 2 is a value where the handler writes an output; the output is discarded; argument 3 is a value where the handler writes an output; the output is discarded; argument 4 is a value where the handler writes an output; the output is discarded
	event.SetMotion(arg0, "立ち")
end

--- Helper function.
local function helper_216ec()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1bc8(0, vm.f32(-1.57))
		end
		if at <= 2 then
			helper_73110cf7(0, 1)
			helper_85c0(0, -1, 5, 256, 208)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetQuestEtc(0, 8) or var0
	if var0 == 1 then
		var1 = event.GetCnt(12) or var1
		if 0 < var1 then
			if var1 == 1 then
				event.SetCnt(12, 2)
			end
			helper_1bc8(0, vm.f32(-1.57))
			if vm.skipping() then
				return skip(2)
			end
			helper_73110cf7(0, 1)
			event.MesMake_2(
				0,
				"ドアに手紙がはさんである。<page>「今日のパーティーは、とろりんチーズが\n　いまいちとろりんとしないので、中止に\n　します。　　　　　　　　　　　ポーク」"
			)
			helper_85c0(0, -1, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
			event.SetFuncEtc(1)
			if vm.wait() then
				return skip(4)
			end
		end
	end
end

--- Helper function.
local function helper_bb28(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var2
	end
	event.SetMesQuestionGyou(1, 0)
	event.SetMesWindowMode(1, 5)
	event.SetMesDrawspeed(1, 1)
	event.SetMesItemDirect(1, 1, vm.i32(arg1 + 20000))
	var2 = helper_9551b0ac(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesDrawspeed(1, 0)
	return var2
end

--- Helper function.
local function helper_40bc4()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fd1f0e04(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_bb28(5, 160)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_fd1f0e04(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_35ea8()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_fd1f0e04(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_fd1f0e04(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_fd1f0e04(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_403e8()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_9551b0ac(0, -1, 8, 0, 0, 2, 1)
		end
		if at <= 2 then
			helper_fd1f0e04(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	if vm.wait() then
		return skip(1)
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "『地下水道入り口』に移動しますか？")
	var0 = helper_9551b0ac(0, -1, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_fd1f0e04(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_3bc7c()
	local var0: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 6.5
			var0 = vm.f32(var0 + vm.f32(0.004))
		end
		if at <= 2 then
			helper_0119cdf1()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(396.92, 146.86, -175.05)
	event.CmrsSetRef(744.44, 257.9, -23.8)
	event.SetTime(6.5)
	var0 = 6.5
	while true do
		var0 = vm.f32(var0 + vm.f32(0.004))
		event.SetTime(var0)
		if vm.wait() then
			return skip(2)
		end
		if var0 > vm.f32(6.8) then
			break
		end
	end
	event.CmrsFadeInit()
	event.CmrsFadeDelay(190)
	event.CmrsFadeOut(60, 0.0, 0.0, 0.0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(250)
	event.CmrsAddPas(396.92, 146.86, -175.05, 744.44, 257.9, -23.8)
	event.CmrsAddPas(104.88, 122.77, 6.77, 326.18, 70.53, 147.12)
	event.CmrsStartPas()
	helper_0119cdf1()
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_3c098()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3bc7c()
			end
			if vm.skip_end() then
				return skip(3)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.SetFlag(56, 0)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.CmrsInit()
	if vm.wait() then
		return skip(1)
	end
	event.SetCameraPos(0.0, 0.0, 0.0)
	event.SetCameraRef(1.0, 0.0, 0.0)
	event.CharaActive(0, 0)
	helper_3bc7c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 530.
local function program_530()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.FuncPointShow("p01_e01g01-0", "invent_36-0", 1)
	helper_3c098()
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraPos(345.12, 84.74, -31.95)
	event.SetCameraRef(351.66, 70.52, 137.18)
	event.SetCharaPos(0, 350.13, 52.0, 148.02)
	event.SetCharaRot(0, 0.0, -3.12, 0.0)
	event.BgmPlayCancel()
	if vm.wait() then
		return skip(2)
	end
	event.GotoInterior(-1, "i01h01", 500, 1)
	if vm.wait() then
		return skip(3)
	end
end

--- Helper function.
local function helper_3c2d4()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			if vm.skip_end() then
				return skip(2)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.DeleteChara(32)
		event.CharaActive(1, 0)
	end
	helper_1974(1798.0, 0.0, vm.f32(2611.2), vm.f32(1.23))
	event.ResetCamera(1, 0.0, 10.0)
	event.Initialize()
	event.LoadSound(1240)
	event.SndLoadSound(1240)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 32)
	event.CharaActive(1, 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.EohSyncObj(1, "p01_e03h03-0")
	event.EohSetShow(1, 0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.CmrsSetPos(1992.97, 34.74, 2905.51)
	event.CmrsSetRef(2030.46, 40.14, 2965.77)
	event.ObjsSetPos(0, 2129.53, 0.0, 3073.66)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.CmrsMove2(1713.52, 39.48, 2489.48, 1730.42, 46.55, 2524.75, 150, 2, 0.4)
	event.ObjsSetMotion(0, "歩き２", 4)
	event.ObjsMove(0, 2128.59, 26.83, 3265.59, 150, 1)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(120)
	event.CmrsFadeOut(30)
	helper_0119cdf1()
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInit()
	return part2()
end

--- Helper function.
local function helper_7f2c(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_24df648f(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_7af8(arg0, 0, var5)
		end
		helper_b476f5ad(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_24df648f(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_7af8(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_b476f5ad(arg0)
end

--- Helper function.
local function helper_a604(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_a9f02643(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_7f2c(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_535bb029(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_a9f02643(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_7f2c(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_535bb029(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_109f0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "この木は・・・イカンな。\nなんとかせねば。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"おぉ、坊ちゃんでしたか、驚いた。\nちょうど木についた悪い虫を取っていたところです。<page>植物は勝手に育つ物ばかりじゃなく、こんな風に\n世話をしないと枯れてしまうのもあるんですよ。"
		)
		helper_a604(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_106bc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "この木は・・・イカンな。\nなんとかせねば。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ユリスが話しかけないと、グリンは\n   取り合ってくれないようです。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_10d18(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_106bc(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"あっ、ユリス坊ちゃん。\n最近、出歩かれることが多いようですが、\nくれぐれも気をつけてくださいよ。<page>それで、アッシに何かご用で？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "何と！アッシに坊ちゃんの\n冒険について来いと？")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"う～む、いっしょに行きたいところなのですが、\nこいつが病気にかかっているようなんです。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"アッシの第一の仕事は、この屋敷の\n木や花たちのお世話をすること。<page>それをほったらかしにして留守になどしたら\nダンナ様に怒られてしまいます。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"教会のブルーノさんが売っている「聖水」なら、\nこの木の病気を治せると思うんですけどね。<page>ダンナ様とブルーノ神父は、坊ちゃんも\n知ってのとおり犬猿の仲。<page>ブルーノさんの聖水を買うと言っても、\nお金はもらえませんし。<page>どうしたものでしょう・・・。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]グリンをシャーロットに移住させるためには、\n   まず、グリンを冒険に連れ出さねばなりません。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]グリンの頼みごとを聞いて、解決してあげることで、\n   グリンを冒険の仲間として、列車に乗せることができます。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]頼まれごと（クエスト）は、アイテムメニュー内にある\n   「メモ帳」で確認することができます。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)]おや、メモ帳を持っていないようですね。\n   メモ帳は、メンテナンスショップ奥の\n   テーブルの上に置いてあります。"
		)
		helper_85c0(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]ドニーのアジトにも同じような物が\n   落ちています。どちらでも良いので、\n   急いで取りに行きましょう。"
		)
		helper_85c0(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

--- Helper function.
local function helper_11a58(arg0: s32, arg1: s32)
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
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_106bc(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"ユリス坊ちゃん。この木を\n治すのがアッシの仕事です。<page>この木を治すためには・・・"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
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
			"坊ちゃん、これじゃあ\nどうにもなりません。<page>やはり、ブルーノさんの\n「聖水」でないと。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"おお！坊ちゃん。これで\nこの木は助かります。<page>ありがとうございます。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"さて、坊ちゃん。これで\nひとまず仕事は済みました。<page>坊ちゃんの冒険に\n同行させてもらいます。<page>あ、それと「聖水」のことは、\nダンナ様にはナイショですよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]グリンが仲間になった。\n   メインメニューの「キャラクター」から\n   「ステータスを見る」で能力が使えます。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]仲間がさらにふえた場合\n   列車の中に乗って、冒険に同行するので\n   話しかけてキャラを切り換えます。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]仲間を他の土地に移住させるためには、\n   建てた家の扉に出るメニューから\n   「移住させる」を選んでください。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]他にもいろいろな場所に、\n   仲間になってくれる人がいるかも\n   しれません。探してみましょう。"
	)
	helper_85c0(0, -1, 8, 0, 0)
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
local function helper_12698(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "お嬢さん、アッシに何かご用で？")
		else
			event.MesMake_2(0, "坊ちゃん、「聖水」のことは、\nダンナ様にはナイショですよ。")
		end
	else
		event.MesMake_2(
			0,
			"世界にはアッシの知らない植物が\nまだまだたくさんあるんですかねぇ。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_12998(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
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
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_109f0(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_10d18(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_11a58(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_12698(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_15270(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_a9f02643(arg0, 0, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_7f2c(0, -1, arg0, arg1, 0)
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
		helper_a9f02643(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"やぁ、ユリス、\nこんにちは。<page>いつも元気そうで\nうらやましいよ。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1567c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_7f2c(0, -1, arg1, arg0, 0)
			end
			if at <= 5 then
				helper_85c0(0, -1, 8, 0, 0)
			end
			return
		end
		if at <= 7 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_7f2c(0, -1, arg1, arg0, 0)
		end
		if at <= 10 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 13 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_a9f02643(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, "・・・")
		helper_7f2c(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]モニカはこういうタイプが苦手みたい。\n   まぁ、無理ないかも。仕方ありません。\n   ユリスで話しかけてみましょう。"
		)
		helper_85c0(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesPreset(0, 0)
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "やぁ、ユリス、\nこんにちは。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "・・・")
	helper_7f2c(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"ふっ、おかしいだろう、\n笑ってくれて良いよ。<page>絵の中の女性に惚れて\nしまったなんてさ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"でも、僕は魔法絵師だ。\n描いた物を本物にする力がある。<page>僕が描けば、それはそこに\n存在するんだ。それが\n生命のない物なら・・・"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "魔法絵師の力では、\n生命を描く事は\nどうしても出来ないんだ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "ただ、聞いた事がある。\nいにしえの巨木に宿る\n黄金の卵。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(
		0,
		"そこから得られる金色を\n用いれば、描いた物に\n生命を与えられると。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"なぁ、ユリス、君は\n町の外に出かけている\nそうじゃないか。<page>この『金色の絵の具』\nどこかで手に\n入らないかな？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"もちろん、ただとは\n言わない。<page>手に入れて来てくれたら、\n僕のこの能力を君のために\n使わせてもらうよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]いにしえの巨木・・・\n   金の卵が宿っちゃうような、\n   そんなとんでもない木なんて、\n   どこに行けば生えているんでしょう。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_bd7c(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_73110cf7(1, 4)
			var1 = 50
			var1 = 51
			helper_85c0(1, var1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_73110cf7(1, 4)
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
	helper_85c0(1, var1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesSetBuff(1, 1, 0)
end

--- Helper function.
local function helper_105dc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bd7c(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_bd7c(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_16794(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_105dc()
		end
		if at <= 8 then
			helper_bd7c(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"待ちくたびれたよ。<page>さぁ、早く絵に生命を\n宿らせる絵の具をくれ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
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
			"これは何の冗談なんだい？<page>僕が欲しいのは『金色の絵の具』だ。\n間違えないでくれ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "これが『金色の絵の具』か・・・\n早速、使ってみるよ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"は、ははっ、本当に\n本物になった・・・<page>すばらしい、まさに\n完璧な女性だ！"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"ありがとう、ユリス。\n約束だったね。僕のこの能力、\nえんりょなく存分に使ってくれ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_bd7c(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_16f4c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "僕のこの能力、えんりょなく\n存分に使ってくれ。")
	else
		event.MesMake_2(0, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_17174(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_15270(arg0, arg1)
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
		helper_15270(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_1567c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_16794(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_16f4c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_dfc4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fd1f0e04(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_fd1f0e04(15)
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
local function helper_e0c8()
	local var0: s32 = 0
	local var1: s32 = 0
	local language_code: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("IN go_shop_up()\n")
			print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
			helper_a604(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_dfc4(15)
		end
		if at <= 3 then
			helper_dfc4(1)
		end
		if at <= 4 then
			helper_dfc4(6)
		end
		if at <= 5 then
			helper_dfc4(0)
		end
		if at <= 6 then
			helper_dfc4(4)
		end
		if at <= 7 then
			helper_dfc4(31)
		end
		if at <= 8 then
			helper_dfc4(35)
		end
		if at <= 9 then
			helper_dfc4(36)
		end
		if at <= 10 then
			helper_dfc4(37)
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
	language_code = event.GetLanguage() or language_code
	if language_code ~= 0 then
		event.MesMake_2(0, "Welcome.")
	else
		event.MesMake_2(0, "いらっしゃい。")
		if var0 == 18 then
			event.MesMake_2(0, "神の力を借りますか？なら、\n教会への寄付をお願いします。")
		end
		if var0 == 4 then
			event.MesMake_2(
				0,
				"がんばってんな。\n何かいるか？<page>ただし、ユリスからでも\n金はもらうぜ。"
			)
		end
		if var0 == 34 then
			event.MesMake_2(
				0,
				"ジオラマの材料が足りないのかな？\n自分で集めるのが面倒なら、\nお金で解決するのもアリじゃよ。"
			)
		end
		if var0 == 1012 then
			flag = event.GetFlag(45) or flag
			if flag == 0 then
				event.MesMake_2(
					0,
					"こんにちは。私、パン職人見習いで、\nポリーおばさんの留守中、\nお店を切り盛りしてるんだ。<page>ちょっと不安だけど、\nこれも修行の１つと思って\n頑張るわ。"
				)
				event.SetFlag(45, 1)
			end
		end
		if var0 == 1015 then
			flag_2 = event.GetFlag(46) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"姉みたいにセクシーじゃないけど・・・\n一応、これでもミレーネの妹なんです。<page>姉がいない間、仕方なく\nここの店番をしてるの。\n武器のことなんて、全くの素人なんだけど・・・"
				)
				event.SetFlag(46, 1)
			end
		end
		if var0 == 1018 then
			flag_3 = event.GetFlag(47) or flag_3
			if flag_3 == 0 then
				event.MesMake_2(
					0,
					"びっくりしたかな？\n教会にこんな服装で突っ立っていたら、\n誰だって驚くよな。<page>オレはブルーノ神父の親友で\n旅に出ている間の留守を頼まれたんだ。\nさて、何かお困りかな？"
				)
				event.SetFlag(47, 1)
			else
				event.MesMake_2(
					0,
					"神の力を借りますか？なら、\n教会への寄付をお願いします。"
				)
			end
		end
	end
	if var1 ~= -1 then
		helper_a604(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_dfc4(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_dfc4(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_dfc4(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_dfc4(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_dfc4(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_dfc4(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_dfc4(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_dfc4(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_dfc4(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_175e8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"もう店じまいだ。これからは\n親父の店で買ってくれ。<page>カボチャが目印だ。知ってるだろ。\nそこのはしごから出りゃすぐだから。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_17458(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"お姉さんが来てから、ユリスの\n付き合いが悪くなっちまった。<page>何してんのか知らないけど、\nあいつをこき使わないでくれよ。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_17778(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_17458(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"聞かなくてもわかるだろう、\nお、こ、と、わ、り、だ。<page>何で俺様が人様の為に\n働かなくちゃいけないんだ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "大してもうかりそうもないし\nおっかないのはごめんだよ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でもなぁ、他ならぬ\nユリスの頼みだし、曲げて\n話を聞いても良いぜ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "でもよ、俺も商人のせがれ、\nもうからない事はやらない\n主義だ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"知ってるだろう、俺が\nコインを集めてるって事。<page>コインは商いの象徴だ。\nなんとしてもコンプリート\nしたいんだ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"でも、『鉄壁のコイン』\n『暗黒のコイン』が\nどうしても手に入らないんだ。<page>なんとかしてくれたら、\n俺もなんとかしてやるぜ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_17eac(arg0: s32, arg1: s32)
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
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_105dc()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_17458(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(201) or argc
	argc_2 = event.GetItemNum(202) or argc_2
	if argc <= 0 or argc_2 <= 0 then
		event.MesMake_2(
			0,
			"なんだよ、あぁ、\nコイン集めの話か？<page>『鉄壁のコイン』\n『暗黒のコイン』だぜ。\nなかなか手に入らないだろう。<page>なんせ俺が探しまくっても\nお目にかかれなかった\nシロモノだからな。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"え？\nコインを集めちまったのか、\nマジでか！<page>なにもったいぶってんだよ、\nくれくれくれー！"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "わかったよ。\nどうしようかな？")
	var5 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(
			0,
			"あぁ！そんないじわる\nするんなら、俺も仲間に\nなんかならないぜ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
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
		"すげぇ、本当にそろっちまった。\n絶対無理だと思ってたのに・・・<page>しょうがねぇ、めんどくさいけど\nいっしょに行ってやるよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_1893c(arg0: s32, arg1: s32)
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
			helper_17458(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"集められっこないと\n思って、ダメモトで\n言ったんだけどな。<page>やっぱ、ユリスは\nすごいぜ。"
		)
	else
		event.MesMake_2(
			0,
			"おう。ゼルマイト探しは進んでるか？\nなんか手伝うことがあったら\n遠慮なく言ってくれ。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_18c4c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_175e8(arg0, arg1)
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
		helper_175e8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_17778(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_17eac(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1893c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_18f30(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a9f02643(arg0, 0, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "こんにちは。\nモニカさんはどんな\n食べ物が好きですか？")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"僕はもちろんおいしい物が\n好きですが、めずらしい\n食べ物にも目がないんですよ。"
		)
	else
		event.MesMake_2(
			0,
			"料理の勉強をして世界一の\nコックをめざします。そしたら、\n坊ちゃんに一番にごちそうしますね。"
		)
	end
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_192f8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"坊ちゃん、「発明」の\n調子はどうですか？<page>坊ちゃんが機械や仕掛けを\n「発明」するように、私は\n料理を「発明」しています。<page>まだ誰も食べた事のない\n美味い食べ物を作るために、\n日々研究をしています。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_194d8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "あ、坊ちゃん、ちょうど良い所へ。\nちょっと相談があるんですよ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"僕が研究のために世界中の\nめずらしいお菓子を作って\nいるのはご存知ですよね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "なんでも、「カスタニャッチョ」\nというお菓子があるそうで、")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "それは「カスターニャ」という\n物を使って作るらしいんです。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"いろいろ調べてみて、その\n「カスターニャ」ってのは、<page>どうも『とんがりマロン』と\n同じ種類の木の実らしいと\nいう所までは突き止めました。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"そこで、とりあえず『とんがりマロン』を\n使って作って見ようと思ったのですが、<page>不思議な事に、町中の『とんがりマロン』が\n売り切れてしまっているのです。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"なんでも、町長が\n買い占めてしまったとか。<page>坊ちゃん、なんとか\nなりませんか？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_19c64(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "『とんがりマロン』は\n手に入りましたか？")
	helper_7f2c(0, -1, arg0, arg1, 0)
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
			"やっぱり無理ですか・・・\n仕方ないですね。<page>「カスタニャッチョ」は\nあきらめます。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"おお、これです。\nありがとうございます。<page>これで「カスタニャッチョ」を\n作ってみます。<page>出来たら真っ先に坊ちゃんに\n食べていただきますからね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そう言えば、\n私に何かご用で？<page>へ、坊ちゃんの冒険に\nついて来いですって。<page>はは、そりゃもちろん\nついて行きますとも。<page>なんで最初にそう言って\n下さらなかったんですか？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_1a35c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "僕が坊ちゃんの頼みを\n断るわけないじゃないですか。")
	else
		event.MesMake_2(
			0,
			"料理の勉強をして世界一の\nコックをめざします。そしたら、\n坊ちゃんに一番にごちそうしますね。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1a5a4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_18f30(arg0, arg1)
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
		helper_18f30(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_192f8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_194d8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_19c64(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1a35c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1a930(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a9f02643(arg0, 0, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "こんにちは、ユリスの\nガールフレンドさん？")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"めずらしい髪の色ですね。\nトムみたいな赤毛ともちがう、\nまるで宝石みたい。<page>ステキだわ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1abf0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1a930(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a930(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"ユリス、最近町の外に\n出かけてるんでしょう？<page>隠したってだめよ、\n知ってるんだから。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1ae08(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a930(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"そうね、ユリスの頼みだから聞いて\nあげたいけど、戦うなんて物騒だし\nなんだか汚れちゃいそう。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"何よりみんなの足手まといに\nなるのはいやだわ。悪いけど\nお断りします。ごめんなさい。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でも、町の外には、\n珍しい物がたくさん\nあるんでしょうね。<page>どんな木が生えてて、\nどんな花が\n咲いてるのかしら。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"ねぇユリス、めずらしい花を\n見つけたら、写真を撮って来て\nちょうだい。ぜひ見てみたいわ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]一度は断られましたが、あきらめるのは早そうです。\n   クレアが興味を持つような写真を見せれば、\n   いっしょに旅をしてくれるかも知れません。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 4, 1)
end

--- Helper function.
local function helper_1b56c(arg0: s32, arg1: s32)
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
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_105dc()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a930(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
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
			"めずらしい花の写真は\n撮れたのかしら？<page>私もいろいろな花を\n知ってるから、ちょっとや\nそっとじゃおどろかないわよ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "めずらしい花の\n写真が撮れたの？\n見せて、見せて！")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"あはっ、すごい、すごい！！\n外にはこんなにすごい花が\n咲いてるのね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "う～ん、\nどうしよう・・・<page>いいわ、私も\n連れて行って！")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1bd7c(arg0: s32, arg1: s32)
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
			helper_1a930(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "あまり危ないところには\n行かないでね。")
	else
		event.MesMake_2(0, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1c03c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1abf0(arg0, arg1)
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
		helper_1abf0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1ae08(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1b56c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1bd7c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1c320(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
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
			"そう思っているのは私だけかも\nしれませんが、モニカさんは、\nエイナ様に似てらっしゃいます。<page>雰囲気と言うかなんと言うか、\nお二人とも、この町の人とは\n何かが違うと思えてなりません。"
		)
	else
		event.MesMake_2(
			0,
			"ゼルマイト鉱山は怖いところです。\nくれぐれも気をつけてくださいませ。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1c5d8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"坊ちゃん、何か困った事が\nあれば、誰よりもまず\nこの私に相談してください。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1c738(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"坊ちゃんの頼みとあらば、\n出来る限りの事をして\n差し上げます。<page>お任せください。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "・・・")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"引き受けてくれとは\n申しません・・・<page>ただ、私の話を聞いて\n頂きとうございます。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"この家にお仕えして３０余年、\n真面目だけが取り得と\n今まで尽くしてまいりました。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "そんな仕事しか取り得の\nない私の、唯一の趣味が\n読書なんです。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"すごく貴重で珍しい本が\nありまして、その本が今、\nオークションに出ているのです。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"まさに競り合っている最中なのです。\n思うに、１０００ギルダもあれば\n落札出来ます。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"でも、そんな大金、とても\n持ち合わせていませんし、<page>こんな事、だんな様に\nご相談したなら、呆れ果てて、\nお暇を頂く事になるでしょう。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"ですから、お頼みできるのは、\n坊ちゃんだけなのです。<page>決して、決して交換条件と\nいう訳ではございませんよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]なんだかんだ言って、１０００ギルダ渡さないと\n   スチュアートは仲間になってくれそうにないですね。\n   仕方ありません。お金を用意しましょう。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

--- Helper function.
local function helper_1d224(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_fd1f0e04(30)
			end
			return
		end
		if at <= 13 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"坊ちゃん、そんな額では、\nオークションにすら\n出られませんよ。<page>１０００ギルダです。\nしっかりして下さい。"
			)
			helper_7f2c(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(
				0,
				"坊ちゃん、大変です！<page>値がつり上がって\n１２００ギルダに\nなってしまいました。"
			)
			helper_7f2c(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(
				0,
				"申し訳ないのですが、\n１５００ギルダ\n用立ててもらえませんか？"
			)
			helper_7f2c(0, -1, arg0, arg1, 0)
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
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>１５００ギルダ、\n急いでください。"
			)
			helper_7f2c(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"坊ちゃん、最悪です！\n１８００ギルダ出す\n方が現れました。<page>もう、２０００ギルダ\nくらい出さないと\n勝ち目はないです！"
			)
			helper_7f2c(0, -1, arg0, arg1, 0)
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
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>２０００ギルダ、\n急いでください。"
			)
			helper_7f2c(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "坊ちゃん、２０００ギルダは\n用意できましたか？")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "しょうがない、あげるよ。\nやっぱり、もったいないや。")
		var4 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"そうですか・・・やはり２０００ギルダは\n大金ですから、惜しくなってしまうのですね。\nこんなに裕福な坊ちゃんと言えども・・・<page>わかりました。あきらめます！\nでも、オークションはまだ続いています。\n私は待っていますよ、いつまでも・・・"
			)
			helper_7f2c(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(
			0,
			"あぁ、坊ちゃん、\nありがとうございます。<page>では、急いで\nオークショニアの所へ\n行って来ます！"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_fd1f0e04(30)
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
	event.MesMake_2(0, "坊ちゃん、\nありがとうございました。\n無事、落札できました。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"実は強気に出たら、\n相手が早めに降りまして、<page>１４００ギルダで\n落札できてしまいました。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "なので、余った\n６００ギルダは\nお返しします。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(
		0,
		"坊ちゃんからお借りした分は、\nこれからお仕えする事で\n返していきたいと思います。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"私のわがままのために、\n坊ちゃんには苦労をおかけしました。<page>今度は私が\nお力になる番でございます。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_1e8ac(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"落札した本ですか？\n実はまだ読んでないんです。<page>なんだか、手に入った事で、\n満足してしまったようです。"
		)
	else
		event.MesMake_2(
			0,
			"ゼルマイト鉱山は怖いところです。\nくれぐれも気をつけてくださいませ。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1eb14(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c320(arg0, arg1)
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
		helper_1c320(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1c5d8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1c738(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1d224(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1e8ac(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1eea0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a9f02643(arg0, 0, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "くれぐれも坊ちゃんを\n危ない目には\nあわせないで下さいね。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"坊ちゃんにすりキズひとつでも\nつけたら、このルネが\nしょうちしませんから！"
		)
	else
		event.MesMake_2(0, "ご無事をお祈りします・・・")
	end
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1f228(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"今はこうしてメイドをして\nますけど、洋服屋さんに\nなるのが小さい頃の夢でした。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "夢は実現しないから\n夢って言うんですよね。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1f4d8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですね・・・坊ちゃんの\nお願いですし、お引き受け\nしたいのはやまやまなんですけど、<page>私、自分に自信がないんです。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"なんでも途中で投げ出してしまって、\n何かをやりとげた事がないんです。<page>小さい頃、洋服屋になるのが夢で、\n自分で何度も作ってみたんですけど、\n一着も完成させられなかったんです。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"こんな私がいっしょにいると、\nきっとめいわくをかけて\nしまうでしょう。<page>だから、ごめんなさい。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]あらら、ルネは完全に自信をなくしている\n   みたいですね。このままではいけません。\n   もう一度、洋服を作ってもらいましょう。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

--- Helper function.
local function helper_1fb04(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですね、もう一度洋服を作ってみて、\n今度こそ完成させられたら、また自分を\n信じる事が出来るかも知れません。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"でも、洋服を作る材料なんて\n持っていません。<page>坊ちゃん、\n用意できないでしょうか？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"服を作るには、『意外と丈夫な布』\n『銅のかたまり』それと\n『ぶあつい皮』があれば充分です。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_1ff14(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_a9f02643(arg0, 0, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 4 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			helper_fd1f0e04(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	argc = event.GetItemNum(214) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	if argc <= 0 or argc_2 <= 0 or argc_3 <= 0 then
		event.MesMake_2(
			0,
			"材料がないと服は作れません。<page>『ぶあつい皮』『銅のかたまり』\nそれと『意外と丈夫な布』です。<page>甘えるようですが、\nお願いします。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
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
	event.MesMake_2(0, "これで服を作ってみなよ！\nやっぱり、もったいないや")
	var5 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "材料がないと服は作れません。")
		helper_7f2c(0, -1, arg0, arg1, 0)
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
		"ありがとうございます！\nこれで服を作ってみます。<page>坊ちゃんのお気持ち、\n決してむだにはしません。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_fd1f0e04(30)
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
local function helper_cbf8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_73110cf7(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_73110cf7(1, 4)
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
	helper_85c0(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_80c(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fd1f0e04(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		if arg0 == 1 then
			event.SetFadeOut(10)
			helper_fd1f0e04(10)
			if vm.skipping() then
				return skip(2)
			end
		end
		argc_3 = event.GetNowLoopNo() or argc_3
		if argc_3 == 1 then
			event.GotoMenu(16)
			if vm.wait() then
				return skip(3)
			end
		end
		if argc_3 == 2 then
			event.GotoMenu(17)
			if vm.wait() then
				return skip(4)
			end
		end
		if arg0 == 1 then
			event.SetFadeIn(10)
		end
	end
end

--- Helper function.
local function helper_20918(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a9f02643(arg0, 0, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			var2 = 259
			var2 = 258
			var2 = 260
			helper_cbf8(var2, 1)
		end
		if at <= 6 then
			helper_80c(1)
		end
		if at <= 7 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_105dc()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "あ、坊ちゃん。やっと\n洋服が出来ました！")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"頂いた材料をむだにしては\nいけないと思って、最後まで\nがんばる事が出来ました。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "まだまだ満足いく出来じゃ\nないんですけど、\n着て頂けますか？")
	helper_7f2c(0, -1, arg0, arg1, 0)
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
	helper_cbf8(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_80c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"はぁ、何かをやりとげるって\n良い気持ちですね。<page>これで私も\n自分に自信がつきました。<page>私なりに精一杯がんばりますので、\n旅のお供をさせてください。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_21004(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"洋服の着心地は\nどうですか？<page>正直な意見を\n聞かせてください。"
		)
	else
		event.MesMake_2(0, "ご無事をお祈りします・・・")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2121c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1eea0(arg0, arg1)
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
				helper_1ff14(arg0, arg1)
			end
			if at <= 6 then
				helper_20918(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1eea0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1f228(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_1f4d8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_1fb04(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_1ff14(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_20918(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_21004(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_224a4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a9f02643(arg0, 0, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"最近、ユリスと\nいっしょにいる娘だね。<page>なかなか男を見る目が\nあるよ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "私もあともうちょっと若けりゃ、\n放っておかないんだけどねぇ。")
	else
		event.MesMake_2(0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2283c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"商売はお客の\n信用が第一。<page>ないがしろにしちゃ\n絶対にいけないよ。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2299c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_cbf8(300, 20)
		end
		if at <= 5 then
			helper_80c(1)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"いっしょに旅をしてくれって？<page>パンを焼く事しか取り得のない\nおばさんだけど、ユリスの役に\n立つんなら、お安いご用さ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"あ、そうそう、その前に、\nモートンの所に配達する\n物があったんだっけ。<page>ユリス、すまないけど、\nモートンの店にパンを２０個\n届けてくれないかい？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "私はその間に旅の支度を\nしておくからさ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_cbf8(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_80c(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "しかし、２０個のパンなんて\n何に使うんだろう？")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_22f4c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"まだ、支度が\n出来てないんだよ。<page>もうちょっと\n待っておくれ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "ところで、\nモートンのところへは\n行ってくれたのかい？")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"なんだって！モートンの奴、\n勝手なことばっかり言って。<page>もう、いいわ、\nそのパンは全部あげる。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"そんなことより、ユリス、\n出発しましょう。<page>さぁ、どこへだって\nついて行きますよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_105dc()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_2355c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"さぁ、ユリス、\n出発しましょう。<page>どこへだって\nついて行きますよ。"
		)
	else
		event.MesMake_2(0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_23794(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_224a4(arg0, arg1)
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
		helper_224a4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2283c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_2299c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_22f4c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2355c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_12c64(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
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
			"女の子が剣を振り回すなんて、\n私はあまり好きではないな。<page>例えばルネさんのような、\nおしとやかな女性が一番だよ。"
		)
	else
		event.MesMake_2(0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_12ecc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"この町は平和すぎて、\n私のかつやくする場が\n全然ない。<page>もちろん、それが\n良い事なのはわかって\nいるんだが・・・"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1305c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"やぁ、ユリス。\n悪いが今は\n手が離せない。<page>町の安全のための\nとても重要な資料を\nまとめている所でね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "急ぎの用事でなければ、\n明日にしてもらえないか。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1332c(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
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
	event.MesMake_2(0, "やってみるよ。\nボクにはムリだ。")
	var2 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(
			0,
			"そうか・・・<page>じゃ、挑戦する気になったら\n来なさい。待っているよ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "じゃ、用意ドン！")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

--- Helper function.
local function helper_138a0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_1332c(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "やぁ、ユリス。私を\n呼びに来たのかい？<page>待っていたよ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"城壁のおかげでこの町は\nとりあえず無事だ。<page>今度は我々が\n打って出る番だ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"しかし、ユリスは\n機械いじりばかりしてるけど、\n体力は大丈夫なんだろうね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"戦いの基本はスピードと\nフットワークだ。<page>私よりのろまだと\n話にならんよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そうだな、試しに\n池のボートまで行って\n戻って来てみろ。<page>私の記録は２分１秒だ。\nそれ以上かかるようなら\n話にならんね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "どうだ、挑戦してみるか？")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_1332c(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_13ee4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_1332c(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_1332c(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_1332c(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_1332c(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_105dc()
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
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(
			0,
			"やぁ、ユリス。\n挑戦しに来たのか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_1332c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(
			0,
			"こら、ボートまで行かなかった\nだろう。俺にはお見通しだぞ。\nインチキするな！"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_1332c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "こら、インチキするな！")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_1332c(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "お、戻ってきたな。\nじゃ、タイム発表！")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "おいおい、\n[数値１]分[数値２]秒[数値３]なんて\n遅すぎるぞ。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_1332c(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(
		0,
		"お、[数値１]分[数値２]秒[数値３]とは\nなかなかのタイムじゃないか。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(
		0,
		"見かけによらず、良い足を\nしている。わかった、\nいっしょに悪と戦おう！"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_14ba4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"見かけによらず、なかなかの\n足を持ってるじゃないか。\n見なおしたぞ。"
		)
	else
		event.MesMake_2(0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14ddc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_12c64(arg0, arg1)
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
		helper_12c64(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_12ecc(arg0, arg1)
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
	if var4 ~= vm.f32(1182.3) or var6 ~= vm.f32(210.6) then
		helper_1305c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_138a0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_13ee4(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_14ba4(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_23b20(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
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
			"サーカスで見かけたって？\n結構、かっこよかったろう。<page>まぁ、アルバイトと言うか\n趣味みたいなもんかな。"
		)
	else
		event.MesMake_2(0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_23d88(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"うちの店は刃物専門だよ。<page>一応、銃も扱ってはいるが、\nどうも飛び道具は\n性に合わなくってね。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_23ef8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_cbf8(44, 1)
		end
		if at <= 6 then
			helper_80c(1)
		end
		if at <= 7 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "モニカって\n言ったっけ？<page>あんた、少しは剣が\n使えるらしいな。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"けどな、剣は子供の\n遊び道具じゃないぜ。<page>そんな腕じゃ\n先が思いやられる。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そうだな、剣を２回くらい\nビルドアップ出来たなら、\n腕を認めてやっても良いかな。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "とりあえず、\nこのグラディウスから\n初めてみな。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_cbf8(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_80c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ミレーネに認めてもらうには、グラディウスを\n   ２段階ビルドアップさせるしかなさそうです。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]買ったり、拾ったりしても良いでしょう。\n   とにかく、強い剣を手に入れない限り、\n   ミレーネは仲間になってくれなさそうです。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

--- Helper function.
local function helper_2469c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(67) or argc
	argc_2 = event.GetItemNum(69) or argc_2
	if argc <= 0 and argc_2 <= 0 then
		event.MesMake_2(
			0,
			"なんだよ、その剣は？\nけっきょく口だけかい。<page>なら、帰んな。\n商売のじゃまだ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "ほう、なかなかの\n剣じゃないか。<page>試したみたいで\n悪かったな。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "しろうとといっしょに戦うと、\nこっちも危なくなるからね。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でも、あんたの腕なら\nそんな心配はなさそうだ。<page>わかった、いっしょに\n戦うよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_24cd8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"よくきたえられた\n剣のかがやきは\n素晴らしいよ。<page>吸い込まれそうだ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "石ころをみがいて\nありがたがっている\n奴の気が知れないね。")
	else
		event.MesMake_2(0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_25070(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_23b20(arg0, arg1)
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
		helper_23b20(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_23d88(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_23ef8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2469c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_24cd8(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_253fc(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "ユリスのお友達かな？<page>まぁ、ゆっくりして\n行きなさい。")
	else
		event.MesMake_2(
			0,
			"これからは、ニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_25664(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "機械いじりも良いが、\nそろそろ鉱山の事も\n勉強したらどうだ。")
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_257b4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_cbf8(24, 1)
		end
		if at <= 6 then
			helper_80c(1)
		end
		if at <= 7 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"スターブルから聞いたぞ、<page>最近、何やらこそこそ\nやっているそうじゃないか。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"おまえは何でも\n器用にこなすが、<page>逆に言うと、何一つ\nやりとげたものが\nないんじゃないのか。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そんなおまえに力を貸せと\n言われても、うかつに\n信じられるわけがない。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"そうだな、このラッパガンを\nベルトリガーまで\nビルドアップしてみろ。<page>どうだ、出来るか？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_cbf8(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_80c(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ジラードに認めてもらうには、ベルトリガーを\n   持って来るしかなさそうです。もらった銃を成長\n   させても良いですし、ダンジョンで見つけても、\n   どこかで買って来ても良いでしょう。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

--- Helper function.
local function helper_25ee8(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"どうした、また\nあきらめるのか？<page>それも良かろう。\n部屋で機械いじりでも\nしていることだ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"ほう、銃の扱いにも\nだいぶ慣れて来たようだな。<page>撃っている姿を見なくても、\n持ち方を見ればわかる。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そうだな、力を貸してやろう。\nただし、これはおまえのためじゃない。<page>この町に良からぬ事が起きるのであれば、\nだまっているわけにいかないからな。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_26428(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"銃は子供の\nおもちゃじゃない。<page>扱いに気をつけないと\n怪我をするぞ。"
		)
	else
		event.MesMake_2(
			0,
			"これからは、ニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_266a0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_253fc(arg0, arg1)
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
		helper_253fc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_25664(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_257b4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_25ee8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_26428(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_a920(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_28505b7b(arg0, var8)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_28505b7b(arg0, var8)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaRot(arg0, 0.0, var8, 0.0)
	event.SetMotion(arg0, "立ち")
end

--- Helper function.
local function helper_aba8(arg0: s32)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a920(player_chara, arg0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, player_chara, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_a920(player_chara, arg0)
	if vm.skipping() then
		return skip(2)
	end
	helper_7f2c(0, -1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_26a2c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aba8(arg0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_aba8(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"・・・１２１２、<page>いやいや、１１２２\nだったような気が。<page>それとも１０１０\nだったかな。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]目の前で話しかけているのに気づかないなんて、\n   何やら大きな悩み事があるみたいですね。<page>   後でまた来てみましょう。もしかしたら、\n   力になってあげられるかもしれませんよ。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_26e8c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_a920(arg0, arg1)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a920(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"何ぶつぶつ\n言ってるのかって？<page>金庫の暗証番号を\n思い出してるんだ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"どこの金庫かって？<page>町長室のがくぶちの裏に\n隠してある金庫に\n決まっているだろう・・・"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_a920(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"わぁ、おどかさないで\nくれよ。<page>あ、しまった！<page>町長の最大の秘密を\nしゃべってしまった！<page>でも、ここまで聞かれた\nのならしようがない。<page>たのむ、知恵を貸して\nくれないか。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "困った事に、金庫の\n暗証番号を忘れて\nしまったんだよ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"４桁の数字なんだが、絶対\n忘れないようにと、クレアの\n誕生日にしておいたんだ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"まさか、それを\n忘れてしまうなんて・・・<page>親として恥ずかしいやら、\n情けないやら。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]町長はとても困っているみたいです。\n   クレアの誕生日にまつわる話を聞いて、\n   そこから暗証番号を推理してみましょう。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

--- Helper function.
local function helper_2780c(arg0: s32, arg1: s32)
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
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				var2 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_fd1f0e04(30)
			end
			if at <= 11 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_fd1f0e04(15)
			end
			return
		end
		if at <= 14 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_be890c0c(0)
		end
		if at <= 16 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_fd1f0e04(15)
		end
		if at <= 18 then
			helper_fd1f0e04(15)
		end
		if at <= 19 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 20 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 21 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(
			0,
			"【手がかり１】昔、誕生日に\nちなんだ星座のブローチを\nあげた事があったっけ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"ポリーに用意してもらったから\nよく覚えてないんだが、確か４本足の\n動物だったような気がする・・・"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"【手がかり２】\n今まであげた誕生日の\nプレゼント？<page>う～ん、コートとか\nマフラーとかが\n多いかなぁ。<page>どんなのが良いのか\nさっぱりわからんので、\n毎年苦労するんだよ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"【手がかり３】そうそう、クレアの誕生日は、\n燃えるゴミを出す日と、燃えないゴミを出す日が\n重なってるんで、いつも大変なんだよ。<page>ああ、我が家でゴミを出すのは私の役目だ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"燃えないゴミを出す日は\n日にちが７で割り切れる日、<page>燃えるゴミを出す日は\n３で割り切れる日だよ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "まさか、忘れてたんじゃ\nないだろうね。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"わかった、謎は解けたぞ！暗証番号は・・・\nわからない・・・もっと話を聞いてみよう。"
		)
		var2 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
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
	event.SetMenuEtc(0, "暗証番号を入力してください", "１２２１", 0)
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
	helper_fd1f0e04(15)
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
	helper_fd1f0e04(30)
	if vm.skipping() then
		return skip(11)
	end
	if var3 == 0 then
		event.SetMotion(arg0, "会話")
		event.MesMake_2(
			0,
			"う～ん、開かないな。\n困った・・・<page>とても大事な書類が\n入っているんだが。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		event.SetMotion(arg0, "立ち")
		event.SetFadeOut(15)
		helper_fd1f0e04(15)
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
	event.MesMake_2(0, "え・・・と、\n１、<page>２、<page>２、<page>１・・・")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "うわっ！<page>やった、\n開いたぞ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0, arg0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, var14, var15, var16, 30)
	helper_be890c0c(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "おお、これで重要な\n書類が取り出せるよ。<page>ありがとう。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetFadeOut(15)
	helper_fd1f0e04(15)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaRot(0, var17, var18, var19)
	event.SetCharaPos(arg0, var8, var9, var10)
	event.SetCharaRot(arg0, var11, var12, var13)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetFadeIn(15)
	helper_fd1f0e04(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"重要な書類って\n何かって？<page>私がいない時は、副町長の\nモートンに、町長の仕事を\n代行してもらうための書類だよ。<page>いささか不安ではあるが、\nまぁ、大丈夫だろう。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"よし、これで私もこの町を\n離れられるようになったぞ。<page>話はスターブルから\n聞いている。<page>さぁ、いっしょに\n連れて行ってくれ！"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_2974c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "ゴミはきちんと分別\nして、決められた日に\n出すようにな。")
	else
		event.MesMake_2(
			0,
			"頼みごとをしていて言うのも変だが、\n鉱山は危険な場所だ。\nあまり無理をしないようにな。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_29994(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_26a2c(arg0, arg1)
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
		helper_26a2c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_26e8c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2780c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2974c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2a650(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	var3 = event.GetChapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.MesMake_2(0, "これから先も、永久に世界が\n平和でありますように。")
	else
		event.MesMake_2(0, "正しき事を成そうとするなら、\n賢くあらねばなりません。")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2a89c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですか、私の力が\n必要ですか。<page>ならば、ひとつ\n問いを出しましょう。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"この教会のロウソクには、\nいささか仕掛けが\nしてありましてね。<page>点いていれば消え、\n消えていれば点く。<page>ひとつが変化すれば、\nその隣り合うロウソクにもまた、\n変化が訪れます。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"うまく全てのロウソクを\n消す事が出来れば、賢者と認め、\n同行いたしましょう。<page>解ければ良し、解けなくば\n力は得られぬと心得なさい。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]これまたよくわからない問題ですね。\n   何回か挑戦してみて、決まりを知る事から\n   始めた方が良さそうです。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]教会から外に出てまた入れば、ロウソクは全て\n   元に戻るみたいです。失敗を恐れずやってみましょう。\n   実は正解って、すごく簡単な事かも知れませんよ。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

--- Helper function.
local function helper_29c78()
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
local function helper_2afd8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_29c78()
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_29c78()
	if 0 < var2 then
		event.MesMake_2(0, "どうやら、時はまだ\n満ちていないようですね。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"未来の君には期待していますが、\n今の君に協力する事はできません。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"よく分かりましたね。\nすばらしい。<page>君なら私の期待にも\n答えてくれることでしょう。<page>約束でしたね。私も\n君と共に行きましょう。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2b4b8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2a650(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2b550(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2a650(arg0, arg1, 0)
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
		helper_2a650(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2a89c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2afd8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2b4b8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2b840(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"なんでこんなに月が恋しいんだろう。<page>もしかしたら、僕はあそこから\n来たのかも知れない・・・"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2b9b0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "う～ん、いっしょに\n行ってあげても良いけど、\nそこに月はあるの？")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "本当に？言葉だけじゃ\n信じられないよ。人間は\nうそをつくからね。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "やっぱり、やめとく。\nここで月が出るのを\n待っているよ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]過去に何があったのかわかりませんが、\n   ルーシオは、完全に人間を信じられなく\n   なっているようです。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]とにかく、信じてもらう事が先決です。\n   そんなに月を見ていたいと言うなら、\n   写真を撮ってあげたらどうでしょう。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 14, 1)
end

--- Helper function.
local function helper_2bffc(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"キミだけは違うような気がしてたんだけど、\nやっぱり人間には変わりないって事だね。<page>でも、いいんだ。人間はうそをつくんだって\nもうなれっこになってるからね。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"わぁ、すごい！まるで\nここにあるみたいだ。<page>これなら、いつでもどこでも\n月を見られるね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"いっしょに来いって\n言うんでしょ。<page>いいよ。他に\n行く所もないし。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2c52c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "キミは月の写真をとってくれた。\nキミは良い人間なんだね。")
	else
		event.MesMake_2(
			0,
			"バース鉄道が世界中に広がったら\nいろんなところにいけるようになるね。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2c764(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2b840(arg0, arg1)
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
		helper_2b840(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2b9b0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2bffc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2c52c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2ca48(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"俺の趣味は釣りだ。<page>俺の夢は\nマーダンガラヤンを\n釣る事だ。<page>俺が尊敬するのは、\nでっかい魚を\n釣った奴だけだ。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2cbd8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85c0(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "俺様に頼み事だって？<page>上等だ、聞いて\nやろうじゃねぇか。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"ただし、俺は\n俺が尊敬する奴の\n言う事しか聞かねぇ。<page>俺が尊敬するのは、俺より\nでかい魚を釣った事が\nある奴だけだ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"ちなみに、俺様が釣った中で\n一番でっかいのは、\n６０センチのノンキーだ。<page>どうだ、びびったかい？\n挑戦するなら、いつでも\n受けて立つぜ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]彼を仲間にするには、６０センチ以上のノンキーを\n   釣るしかなさそうです。でも、そんなにいばるほど\n   大きくはないような・・・"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]とりあえず、パームブリンクスの池で\n   釣りをしてみましょう。")
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_2d294(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"おい、実はノンキーを釣ったこと\nないんじゃないのか？<page>ははーん、さてはオマエ、\n釣りがヘタクソだろう！"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
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
		event.MesMake_2(0, "ぷぷっ、[数値１]センチのしか\n釣れてないでやんの。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"そんな腕前で\n俺様を使おうなんて\n１００年早い！<page>顔を洗って\n出直してきやがれ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "・・・お、おみそれしました。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "よし、俺も男だ。\n男に二言はない。<page>約束通り\n言う事を聞くぜ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "さぁ、煮るなり焼くなり\n好きにしやがれ！")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_2daec(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"あのさ、気が向いた時で\n良いから、釣りのコツってのを\n教えてくんねぇか。"
		)
	else
		event.MesMake_2(0, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2dd24(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2ca48(arg0, arg1)
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
		helper_2ca48(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2cbd8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2d294(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2daec(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2e008(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2e168(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "私も魚については、\nいささか自信があります。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"聞く所によると、人間は\n魚に競争をさせて\nいるとかいないとか。<page>あなたも魚を飼って\nいるのなら、それで\n一番になってみなさい。<page>そうすれば、\n私もあなたを認め、\n力になりましょう。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]彼女はどうやらギョレースの事を言っているようです。\n   さしあたり、ビギナークラスで優勝してみましょう。\n   彼女の態度も変わるかも知れません。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

--- Helper function.
local function helper_2e754(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "魚は飼い主に似ると言います。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "あんな弱っちい魚の飼い主と\n話す事なんて、ありません。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"こっそり見てましたよ。\nすばらしいレースでしたね。<page>あそこまで魚を育て上げるなんて、\n私には出来そうもありません。<page>いっしょに連れて行ってください。\nそして、勉強させてください。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_2ec48(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "私もいつの日か、\n表彰台の真ん中に\n立ってみたいものです。")
	else
		event.MesMake_2(
			0,
			"フラビンたら、少しは釣り以外の\nことにも興味を持って欲しいわ。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2ee80(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2e008(arg0, arg1)
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
		helper_2e008(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_2e168(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2e754(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2ec48(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2f1c4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a9f02643(arg0, 0, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "最近、身体の\n調子が悪いの。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"ダック先生に診て頂いたけど、\n身体には何の問題もないって。<page>なぜかしら？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2f464(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_7f2c(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_7f2c(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_7f2c(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"最近、身体の調子が悪いの。<page>旅なんてとてもじゃないけど\n無理だわ。<page>ダック先生に看て頂いたけど、\n何の問題もないって。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"でも、普通に\n立っているだけでも\n倒れそうになるの。<page>なんて言うのかな、\n世界がゆがんでしまった\nような感じがするのよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"う～ん、ダック先生でも\nわからないんじゃ、ボクに\nわかりっこないなぁ・・・"
		)
		helper_7f2c(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "この症状には\n覚えがあるわ。")
	helper_7f2c(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"私の生まれた時代では、世界がかなり\n崩壊していて、空間のゆがみも、こことは\n比べ物にならないくらいだったの。"
	)
	helper_7f2c(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"そんな世界だったから、特に\n身体の弱い人や神経の細やかな\n人ほど影響をうけていたのね。<page>軽い人はめまいや立ちくらみ、\n重い人だと立っていられなく\nなるくらい。"
	)
	helper_7f2c(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"ミーナさんは、特に\nその影響をうけやすい\n体質なのかも。<page>この程度の空間の\nゆがみでも、体調を\n崩すくらいだから。"
	)
	helper_7f2c(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"せめて近い場所のゆがみだけでも\n減らせれば、少しは楽にして\nあげられるかも知れないわね。"
	)
	helper_7f2c(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(arg1, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]時空のゆがみを修復する方法・・・\n   そうです。スフィーダがありますよね。\n   １０ステージくらいクリアすれば、\n   ミーナの体調も良くなるのではないでしょうか。"
	)
	helper_85c0(0, -1, 8, 0, 0)
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
local function helper_30050(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "まだ体調はすぐれないわ。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"もしかして、\n悪い病気なんじゃ\nないかしら？<page>ダック先生がああ言う\nのも、もう手おくれ\nだからなのかも・・・"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "こんにちは。<page>身体の調子？\n快調よ！")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"最近、うそみたいに\n楽になったわ。<page>なんていうか、世界が\nしっかりしてる感じ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そう言えば、何か\n頼み事があったのよね。<page>私に出来る事なら\n協力するわ。<page>助けてもらったんだもの。\n助けてあげなきゃね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_307b0(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"助けてもらったから\n協力するけど、虫がいる\n所には行きたくないわ。"
		)
	else
		event.MesMake_2(
			0,
			"バース鉄道が世界中に広がったら\nいろんなところに旅行とか\n行っちゃおっかな。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_309f8(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2f1c4(arg0, arg1)
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
		helper_2f1c4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_2f464(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_30050(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_307b0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_30cc4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a9f02643(arg0, 0, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.MesMake_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_3103c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_fd1f0e04(30)
		end
		if at <= 13 then
			helper_fd1f0e04(30)
		end
		if at <= 14 then
			helper_fd1f0e04(60)
		end
		if at <= 15 then
			helper_85c0(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.MesMake_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"子供だから役に立たないと\n思ってるでしょう？<page>実はね、私って幸運を呼ぶ\nラッキーガールなのよ。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"お出かけの日に雨だったことないし、\nくじの外れ券なんて見た事ないわ。<page>どうよ？"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "わかったよ\nおことわり")
	var3 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "なによ、いじわる！\nけちんぼ！")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "おたんこなす！<page>とうへんぼく！<page>ぼくねんじん！")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"ほんとに連れて\n行ってくれるの？<page>ダメモトでも\n言ってみるものね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"でもさ、他の人はたのまれてるのに、\nあたしだけ自分からたのむのって\nしゃくだわ。<page>あくまで、たのまれて\n協力してるってことにしないと、\nわたしの女がすたる。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "そうね、あたしを見つけたら\n仲間になってあげるってのは\nどう？")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "ようするに「かくれんぼ」よ。<page>じゃあ、スタート！")
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_fd1f0e04(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_fd1f0e04(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_fd1f0e04(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]しかたありませんね・・・\n   コリンを探しに行きましょう。\n   パームブリンクスのどこかに\n   かくれているはずです。"
	)
	helper_85c0(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

--- Helper function.
local function helper_320dc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_fd1f0e04(30)
			end
			return
		end
		if at <= 4 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "あはっ、見つかっちゃった！<page>じゃ、次はどうかしら？")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_fd1f0e04(30)
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
		"あぁ、\n見つかっちゃった・・・<page>ふぅ、なんだか\nあきて来ちゃった。<page>なんか、かくれてるのって\n意外とつまんないものね。<page>いいわ、そろそろ冒険に\n出発しましょう！"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_32654(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "かくれんぼなんて、\nしょせん\n子供の遊びよね。")
	else
		event.MesMake_2(
			0,
			"ねぇねぇ、最近なんか、こっそり\n楽しいことしてるでしょ？\nわたしにも教えてよ～。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3288c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_30cc4(arg0, arg1)
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
		helper_30cc4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_3103c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_320dc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_32654(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_32b70(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"・・・<page>ああ、こんにちは。\n最近、耳が遠くなっちまってねぇ。<page>ゆっくりしゃべってもらわないと、\n聞き取れないんだよ。"
	)
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_32d00(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_7f2c(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_105dc()
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"なんだって？<page>すまないけど、もっとゆっくり\n話してもらえんかね。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetQuestEtc(0, 19, 1)
	event.SetMenuEtc(
		0,
		"「いっしょに冒険しよう」と入力してください",
		"いっしょに冒険しよう",
		0
	)
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
		event.MesMake_2(0, "う～ん、何を言ってるのか\nよくわからないねぇ・・・")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"冒険にかい？\n良いですとも。<page>こんなおいぼれが何の役に\n立つのか知れないけど。"
	)
	helper_7f2c(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_105dc()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_333d4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_32d00(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_33460(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "こんなおばあちゃんでも、\n何かの役に立つのかねぇ。")
	else
		event.MesMake_2(
			0,
			"そうだねぇ、バース鉄道が完成したら\n”世界の果て”を見てみたいねぇ。"
		)
	end
	helper_a604(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_33698(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_32b70(arg0, arg1)
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
		helper_32b70(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_32d00(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_333d4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_33460(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_21a94(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_7f2c(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_a9f02643(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "ああ、ポリーの\nお手伝いかい？<page>ごくろうさん。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"ん、パンを２０個も\nどうするかって？<page>今日は「チーズフォンデュ」\nパーティーなんだ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"ユリスお得意の「発明」で言うなら、\nチーズとパンとワインで発明された\n料理のことさ。<page>うまいんだぜ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"みんな、たくさん食べるから、\nこれだけパンがいるんだ。<page>でも、今パンを渡されても\n困るな。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"ユリス、悪いんだが、\nそのパンを家まで\n持っていってくれないか。<page>家は知ってるよな、\nカボチャ畑が目印だ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "家は知ってるよな、\nカボチャ畑が目印だ。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "中止だって！？\nそいつは残念だな。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(
			0,
			"じゃ、ユリス、\nパンはいらないから、\nポリーに返して来てくれ。"
		)
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "悪いな。パンはポリーに\n返して来てくれ。")
		helper_7f2c(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_3397c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local var9: any = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local var12: any = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local var15: any = 0
	local var16: s32 = 0
	local active_chr_no: s32 = 0
	local var18: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_17174(arg0, arg1)
			end
			if at <= 2 then
				helper_e0c8()
			end
			if at <= 3 then
				helper_18c4c(arg0, arg1)
			end
			if at <= 4 then
				helper_1a5a4(arg0, arg1)
			end
			if at <= 5 then
				helper_1c03c(arg0, arg1)
			end
			if at <= 6 then
				helper_1eb14(arg0, arg1)
			end
			if at <= 7 then
				helper_2121c(arg0, arg1)
			end
			if at <= 8 then
				var9 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 10 then
			return
		end
		if at <= 14 then
			if at <= 11 then
				helper_23794(arg0, arg1)
			end
			if at <= 12 then
				helper_14ddc(arg0, arg1)
			end
			if at <= 13 then
				var12 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 15 then
			return
		end
		if at <= 20 then
			if at <= 16 then
				helper_25070(arg0, arg1)
			end
			if at <= 17 then
				helper_266a0(arg0, arg1)
			end
			if at <= 18 then
				helper_29994(arg0, arg1)
			end
			if at <= 19 then
				var15 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 21 then
			return
		end
		if at <= 30 then
			if at <= 22 then
				helper_2b550(arg0, arg1)
			end
			if at <= 23 then
				helper_2c764(arg0, arg1)
			end
			if at <= 24 then
				helper_2dd24(arg0, arg1)
			end
			if at <= 25 then
				helper_2ee80(arg0, arg1)
			end
			if at <= 26 then
				helper_309f8(arg0, arg1)
			end
			if at <= 27 then
				helper_3288c(arg0, arg1)
			end
			if at <= 28 then
				helper_33698(arg0, arg1)
			end
			if at <= 29 then
				var18 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 31 then
			return
		end
		if at <= 32 then
			helper_a604(arg0, -1, 0, 0)
		end
		if at <= 33 then
			helper_a604(arg0, -1, 0, 0)
		end
		if at <= 34 then
			helper_a604(arg0, -1, 0, 0)
		end
		if at <= 35 then
			helper_a604(arg0, -1, 0, 0)
		end
		if at <= 36 then
			helper_a604(arg0, -1, 0, 0)
		end
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
		helper_12998(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_17174(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			helper_e0c8()
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_18c4c(arg0, arg1)
			if vm.skipping() then
				return skip(4)
			end
		end
	end
	if var3 == 7 then
		helper_1a5a4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var3 == 8 then
		helper_1c03c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var3 == 10 then
		helper_1eb14(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var3 == 11 then
		helper_2121c(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var3 == 12 then
		var7 = event.GetQuestEtc(0, 0) or var7
		var8 = event.GetQuestEtc(0, 8) or var8
		if var7 == 2 and var8 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var9 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(9)
			end
			if var9 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var9 == 1 then
				helper_23794(arg0, arg1)
				if vm.skipping() then
					return skip(10)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_e0c8()
			if vm.skipping() then
				return skip(11)
			end
		else
			helper_23794(arg0, arg1)
			if vm.skipping() then
				return skip(12)
			end
		end
	end
	if var3 == 14 then
		helper_14ddc(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
	end
	if var3 == 15 then
		var10 = event.GetQuestEtc(0, 0) or var10
		var11 = event.GetQuestEtc(0, 10) or var11
		if var10 == 2 and var11 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var12 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(14)
			end
			if var12 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var12 == 1 then
				helper_25070(arg0, arg1)
				if vm.skipping() then
					return skip(15)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_e0c8()
			if vm.skipping() then
				return skip(16)
			end
		else
			helper_25070(arg0, arg1)
			if vm.skipping() then
				return skip(17)
			end
		end
	end
	if var3 == 16 then
		helper_266a0(arg0, arg1)
		if vm.skipping() then
			return skip(18)
		end
	end
	if var3 == 17 then
		helper_29994(arg0, arg1)
		if vm.skipping() then
			return skip(19)
		end
	end
	if var3 == 18 then
		var13 = event.GetQuestEtc(0, 0) or var13
		var14 = event.GetQuestEtc(0, 13) or var14
		if var13 == 2 and var14 ~= 2 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "こんにちは。\n仲間になってよ！")
			var15 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(20)
			end
			if var15 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var15 == 1 then
				helper_2b550(arg0, arg1)
				if vm.skipping() then
					return skip(21)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_e0c8()
			if vm.skipping() then
				return skip(22)
			end
		else
			helper_2b550(arg0, arg1)
			if vm.skipping() then
				return skip(23)
			end
		end
	end
	if var3 == 19 then
		helper_2c764(arg0, arg1)
		if vm.skipping() then
			return skip(24)
		end
	end
	if var3 == 20 then
		helper_2dd24(arg0, arg1)
		if vm.skipping() then
			return skip(25)
		end
	end
	if var3 == 21 then
		helper_2ee80(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 23 then
		helper_309f8(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 24 then
		helper_3288c(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 25 then
		helper_33698(arg0, arg1)
		if vm.skipping() then
			return skip(29)
		end
	end
	if var3 == 33 then
		var16 = event.GetQuestEtc(0, 8) or var16
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if var16 == 1 and active_chr_no == 0 then
			event.SetMotion(arg1, "立ち")
			event.MesMake_2(0, "買い物させて\nこんにちは")
			var18 = helper_9551b0ac(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(30)
			end
			if var18 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var18 == 1 then
				helper_21a94(arg0, arg1)
				if vm.skipping() then
					return skip(31)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_e0c8()
		if vm.skipping() then
			return skip(32)
		end
	end
	if var3 == 1 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"最近は細かい部品が\n見えにくくてのぅ。<page>わしも、もうろく\nしたのかのぅ・・・"
			)
		else
			event.MesMake_2(
				0,
				"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
			)
		end
		helper_a604(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(33)
		end
	end
	if var3 == 2 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
		else
			event.MesMake_2(
				0,
				"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
			)
		end
		helper_a604(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(34)
		end
	end
	if var3 == 6 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
		else
			event.MesMake_2(0, "ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。")
		end
		helper_a604(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(35)
		end
	end
	if var3 == 13 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
			)
		else
			event.MesMake_2(0, "おまえ、ホントに冒険が好きだよなぁ。")
		end
		helper_a604(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(36)
		end
	end
	if var3 == 22 then
		event.SetMesPreset(0, 0)
		if var2 ~= 8 then
			event.MesMake_2(
				0,
				"絵から出て来たって言っても、\nそれ以外は普通の人と変わらないのよ。"
			)
		else
			event.MesMake_2(
				0,
				"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
			)
		end
		helper_a604(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(37)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_eec0()
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
				helper_e0c8()
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
		helper_e0c8()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "おい、この先は\n立ち入り禁止だ。")
		helper_a604(var1, -1, 0, 0)
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
					"見てみろよ、こんなでっかい物が\n動いてたなんて、信じられないだろう。\nでもな、昔は本当に動いてたんだぜ。<page>また、こいつに乗って旅するのがオレの夢だ。\nだから、今でも整備にぬかりはねぇ。\n許しが出たら、いつでも動かせるようにな。"
				)
			else
				event.MesMake_2(
					0,
					"動かしてない間も整備してたんだけどな、\n実際に動かしてみると、あちこちガタが\n来てやがった。<page>毎日動かしてないと鈍っちまうってのは、\n機械も身体もいっしょだな。"
				)
			end
			helper_a604(var1, -1, 0, 0)
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
					"やあ、ユリス。\n鉄道が廃止されて\nどれだけの時間が流れたかのう。<page>私はたとえ、鉄道が動かずとも\nこうやって毎日駅を見回っているのだよ。"
				)
			else
				event.MesMake_2(
					0,
					"ようやく町長が、重い腰を上げたのじゃな。\n列車は走っているとはいえ、まだまだ\n一般開放できる状態ではない。<page>早く町のみんなを乗せて\nあげたいのじゃが・・・"
				)
			end
			helper_a604(var1, -1, 0, 0)
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
					"こんにちは、ユリス。\nそこにいる駅長、うちのパパなの。\nこうやって親子で駅を守っているの。<page>いつの日か、鉄道が復活する日まで・・・"
				)
			else
				event.MesMake_2(
					0,
					"列車が動いたわ！\nだけど、まだ駅が元通りになるのは、\n時間がかかりそうね・・・"
				)
			end
			helper_a604(var1, -1, 0, 0)
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
					"おっちゃん、モニカちゃんの\n隠れファンだったんだけど、\n最近モニカちゃんの姿が見えねーな。<page>おかげで、仕事のやる気が出ねーよ。"
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(
						0,
						"よお、ユリス。\nモニカが帰って来たらしいな。\n町のみんなも喜ぶぞー！"
					)
				else
					event.MesMake_2(
						0,
						"モニカー！元気だったか？\nおっちゃん、寂しかったよー。"
					)
				end
			end
			helper_a604(var1, -1, 0, 0)
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
					"やっとモニカちゃんと普通に\nしゃべれるようになったのに\n突然いなくなるんだもんな。<page>ユリス、一体モニカちゃん、\nどこに行ったんだ？"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "モニカが帰ってきたんだね。\n一体、どうやって？？")
				else
					event.MesMake_2(0, "モニカ、帰ってきたんだね。\n一体、どうやって？？")
				end
			end
			helper_a604(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_a604(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_104a8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eec0()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_eec0()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_35d2c()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_104a8()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_3397c(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_104a8()
		if vm.skipping() then
			return skip(2)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_b8d9d9d0

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local var8: s32 = 0
	local old_map_no: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local flag_6: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		helper_1974(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
		var12 = 1
		var12 = 0
		var12 = 0
		helper_406fc()
		var12 = 0
		var12 = 0
		helper_40960()
	end
	helper_b8d9d9d0()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		flag = event.GetFlag(736) or flag
		flag_2 = event.GetFlag(800) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.SetFadeOut(0)
			helper_3ca30()
			if vm.skipping() then
				return skip(1)
			end
			event.SetSavedataEtc(0, 10)
			event.SoundAllStop()
			event.SndInReverb(0)
			event.GotoDrawChapter(8)
			if vm.wait() then
				return skip(2)
			end
			event.SndInReverb(1)
			event.LoadSound(1000)
			var3 = event.GetDefBgmNo(10) or var3
			event.LoadBgm(var3)
			event.PlayBgm(0)
			event.AutoChengeBgmVol(1)
			event.SetCharaPos(0, 1640.0, -48.8, -1700.0)
			event.SetCharaRot(0, 0.0, 0.0, 0.0)
			event.ResetCamera(1, 0.0, 10.0)
			event.SetFadeIn(30)
			return
		end
		var4 = event.GetCnt(4) or var4
		if var4 == 0 then
			event.SetCharaPos(0, 560.0, 4.1, 120.0)
			event.SetCharaRot(0, 0.0, 3.14, 0.0)
		end
		if var4 == 1 then
			event.SetCharaPos(0, 2095.0, 0.0, 2100.0)
			event.SetCharaRot(0, 0.0, 0.0, 0.0)
		end
		if var4 == 2 then
			event.SetCharaPos(0, -4260.0, 350.0, 2810.0)
			event.SetCharaRot(0, 0.0, 2.86, 0.0)
		end
		if var4 == 3 then
			event.SetCharaPos(0, -3770.0, 359.4, -1640.0)
			event.SetCharaRot(0, 0.0, 1.57, 0.0)
		end
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		flag_3 = event.GetFlag(105) or flag_3
		flag_4 = event.GetFlag(109) or flag_4
		flag_5 = event.GetFlag(56) or flag_5
		if flag_3 ~= 0 and flag_4 == 0 and flag_5 == 0 then
			event.GetBgmNo() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
			event.GetMasterVol()
			if var8 ~= 10 then
				event.SetFadeOut(0)
				event.LoadSound(1000)
				var8 = event.GetDefBgmNo(10) or var8
				event.StopBgm(0)
				helper_fd1f0e04(4)
				if vm.skipping() then
					return skip(3)
				end
				event.LoadBgm(var8)
				event.PlayBgm(0)
				event.SetFlag(56, 1)
				event.AutoChengeBgmVol(1)
				event.SetFadeIn(30)
			end
		end
		old_map_no = event.GetOldMapNo() or old_map_no
		var11 = event.GetMapType(old_map_no) or var11
		if var11 ~= -1 then
			if var11 == 7 or var11 == 8 then
				helper_1974(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
				event.ResetCamera(1, 0.0, 10.0)
			else
				var12 = 1
				flag_6 = event.GetFlag(40) or flag_6
				if flag_6 == 1 then
					if old_map_no == 34 then
						var12 = 0
						event.SetCharaPos(0, 1645.1, -41.3, -1812.6)
						event.SetCharaRot(0, 0.0, -0.09, 0.0)
						event.ResetCamera(1)
					end
					if old_map_no == 22 then
						var12 = 0
						helper_406fc()
					end
				end
				get_old_interior_map_no = event.GetOldInteriorMapNo() or get_old_interior_map_no
				if 0 <= get_old_interior_map_no then
					var12 = 0
				elseif old_map_no == 121 then
					var12 = 0
					event.SetCharaPos(0, 1450.0, 0.0, 1420.0)
					event.SetCharaRot(0, 0.0, -1.57, 0.0)
					event.ResetCamera(1, 3.1415927)
				end
				if var12 ~= 0 then
					helper_40960()
				end
			end
		end
	end
	event.SetFlag(40, 0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3b974()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
		return
	end
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(3)
	end
	event.GotoInterior(-1, "i01h01", 100, 1)
	if vm.wait() then
		return skip(4)
	end
end

--- Program 201.
script[201] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
		end
	end
	print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n")
	local t0 = helper_424a8()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
		event.SetFadeOut(0)
		if vm.wait() then
			return skip(2)
		end
		event.MapJump(-1, "s45")
		return
	end
	print("ccccccccccccccccccccccccccc\n")
end

--- Program 204.
script[204] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
		return
	end
	event.MapJump(-1, "i02h01")
	if vm.wait() then
		return skip(3)
	end
end

--- Program 210.
script[210] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 211.
-- Defined empty, so the engine runs this instead of its default.
script[211] = function() end

--- Program 212.
-- Defined empty, so the engine runs this instead of its default.
script[212] = function() end

--- Program 213.
-- Defined empty, so the engine runs this instead of its default.
script[213] = function() end

--- Program 214.
script[214] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 215.
script[215] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 216.
script[216] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 217.
-- Defined empty, so the engine runs this instead of its default.
script[217] = function() end

--- Program 218.
script[218] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 219.
script[219] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 220.
script[220] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 221.
script[221] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 222.
script[222] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_216ec()
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	else
		helper_216ec()
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 223.
script[223] = function()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		program_248()
		if vm.skipping() then
			return skip(1)
		end
		event.SetFuncEtc(1)
		if vm.wait() then
			return skip(2)
		end
	end
	flag = event.GetFlag(304) or flag
	flag_2 = event.GetFlag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.BgmLoadCancel()
	end
end

script[248] = program_248

--- Program 290.
script[290] = function()
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(800) or flag
	if flag == 0 then
		return
	end
	local t0 = helper_40bc4()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.DngSetStageId(6)
		event.GotoMenu(3, 6)
		if vm.wait() then
			return skip(2)
		end
		do
			local _, _, out3, _ = event.GetMenuParam_4()
			var3 = out3 or var3
		end
		if var3 == 0 then
			event.SetFadeIn(30)
			return
		else
			if var3 == 37 then
				event.BgmLoadCancel()
			end
			event.GotoDng(6, var3, 1010)
		end
	end
end

--- Program 400.
script[400] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(15) or var0
	event.SetCnt(4, var0)
	helper_35ea8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 401.
script[401] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	var1 = event.GetCnt(7) or var1
	if active_chr_no == 0 and var1 == 1 then
		event.SetCnt(7, 2)
		event.MesMake_2(0, "よし！急いでパッカーの所に戻らなきゃ。")
	else
		event.MesMake_2(0, "だまって乗ったら怒られるかな？")
	end
	helper_85c0(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_403e8()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "d01e01", 100)
	end
end

script[530] = program_530

--- Program 531.
script[531] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		print("じゃんぷ------------------\n")
	end
	event.SetFadeOut(0)
	event.SetCameraPos(345.12, 84.74, -31.95)
	event.SetCameraRef(351.66, 70.52, 137.18)
	event.SetCharaPos(0, 350.13, 52.0, 148.02)
	event.SetCharaRot(0, 0.0, -3.12, 0.0)
	print("ぞうにまけた---------------------\n")
	if vm.wait() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 510, 1)
	if vm.wait() then
		return skip(2)
	end
	print("じゃんぷ------------------\n")
end

--- Program 540.
script[540] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3c2d4()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelLoadVillager()
	event.BgmLoadCancel()
	event.MapJump(-1, "i03h01a", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 550.
script[550] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a604(var2, -1, 0, 0)
		end
		if at <= 2 then
			helper_fd1f0e04(20)
		end
	end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		return
	end
	event.SetCameraPos(1300.0, 50.0, 763.0)
	event.SetCameraRef(1300.0, 30.0, 968.18)
	event.SetMotion(0, "立ち")
	var1 = event.SearchCharaNo(50) or var1
	var2 = vm.i32(var1 + 1)
	event.SetAi(0, var2)
	event.SetAi(0, var1)
	event.MesMake_2(0, "おい、この先は\n立ち入り禁止だ。")
	helper_a604(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "おとなしく引き返した方が\n身のためだぜ。")
	helper_a604(var2, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(20)
	helper_fd1f0e04(20)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCharaPos(0, 1302, 0, 951)
	event.SetCharaRot(0, 0, 3.14, 0)
	event.SetAi(1, var2)
	event.SetAi(1, var1)
	event.SetFadeIn(20)
end

--- Program 560.
script[560] = helper_b8d9d9d0

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		return
	end
	helper_35d2c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11051.
script[11051] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_530()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11052.
script[11052] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(105, 0)
	event.SetSavedataEtc(0, 3)
	if vm.wait() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 11052, 1)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11053.
script[11053] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(105, 0)
	event.SetSavedataEtc(0, 3)
	if vm.wait() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 11053, 1)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11060.
script[11060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(103, 1)
	event.SetFlag(106, 0)
	event.SetFlag(107, 0)
	event.SetSavedataEtc(0, 3)
	if vm.wait() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 11060, 1)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11091.
script[11091] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3c2d4()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelLoadVillager()
	if vm.wait() then
		return skip(2)
	end
	event.MapJump(-1, "i03h01a", 500)
	if vm.wait() then
		return skip(3)
	end
end

--- Program 18000.
script[18000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3ca30()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(0, 10)
	event.SoundAllStop()
	event.SndInReverb(0)
	event.GotoDrawChapter(8)
	if vm.wait() then
		return skip(2)
	end
	event.SndInReverb(1)
	event.LoadBgm(0)
	event.LoadSound(1000)
	event.PlayBgm(0)
	event.SetCharaPos(0, 1640.0, -48.8, -1700.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

return script
