--!strict
-- map/i/i03/h01/i03h01a_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8ce95bf9 = require("@lib/event/helper_8ce95bf9")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_9d6455b5 = require("@lib/event/helper_9d6455b5")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_390d8(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_39134(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(2)
		end
		if at <= 2 then
			helper_aafd6a80(66)
		end
		if at <= 3 then
			helper_184013af()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(79.6, 44.59, -39.31)
	event.CmrsSetRef(-7.3, 30.03, -86.44)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "座り", 4)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.SndSePlay(arg0, 2)
	helper_aafd6a80(66)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsMove2(79.6, 44.59, -39.31, 39.97, 30.03, 52.15, 90, 2, 0.4)
	helper_184013af()
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_38ee4(arg0: any, arg1: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
		end
		var3 = var3 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = 0
	while var3 < arg1 do
		if vm.wait() then
			return skip(2)
		end
		if var3 == 60 then
			event.PlayBgm(0)
		end
		var3 = var3 + 1
	end
end

--- Helper function.
local function helper_39488(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_38ee4(arg0, 160)
		end
		if at <= 2 then
			helper_8f31f334(1)
		end
		if at <= 3 then
			helper_8f31f334(3)
		end
		if at <= 4 then
			helper_184013af()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-0.92, 28.84, -32.55)
	event.CmrsSetRef(-0.27, 28.03, 22.59)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -0.66, 0.0, 123.46)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -0.66, 0.0, 123.46)
	event.ObjsSetRot(3, 0.0, -3.14, 0.0)
	event.SndSePlay(arg0, 3)
	event.ObjsSetMotion(1, "ドア開け", 6)
	event.ObjsSetMotion(3, "ドア開け", 6)
	event.ObjsMotionWait(1)
	event.ObjsMotionWait(3)
	event.CmrsPrdelay(60)
	event.CmrsSetPos(9.38, 26.8, 22.17)
	event.CmrsSetRef(10.04, 25.99, 77.32)
	helper_38ee4(arg0, 160)
	if vm.skipping() then
		return skip(2)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(4)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_399b4(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_39a28(arg0: any)
	local var1: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(2)
		end
		if at <= 2 then
			helper_6c719c99(1090010)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(1.35, 30.21, -27.45)
	event.CmrsSetRef(0.24, 29.22, -88.19)
	event.GetProjection() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.SetProjection(950.9)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "座り", 4)
	event.CharaActive(0, 35)
	event.EohSetShow(13, 1)
	event.ObjsSetMotion(2, "立ちあがる", 6)
	event.ObjsNextMotion(2, "立ちあがるL")
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090010)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetProjection(var1)
end

--- Helper function.
local function helper_38d80(arg0: any, arg1: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
		end
		var3 = var3 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = 0
	while var3 < arg1 do
		if vm.wait() then
			return skip(2)
		end
		var3 = var3 + 1
	end
end

--- Helper function.
local function helper_39e44(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_38d80(arg0, 70)
		end
		if at <= 2 then
			helper_aafd6a80(5)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-49.42, 28.58, -9.71)
	event.CmrsSetRef(5.37, 27.75, -69.7)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -3.78, 5.43, -7.31)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ちあがるL", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 69)
	event.ObjsSetMotion(1, "立ち", 2)
	event.ObjsMove(1, 1.5, 5.43, -38.55, 70)
	helper_38d80(arg0, 70)
	if vm.skipping() then
		return skip(2)
	end
	helper_aafd6a80(5)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_37e6c(arg0: s32, arg1: f32, arg2: f32, arg3: any)
	local var4: s32 = 0
	local get_now_frame_wait: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg2 = vm.f32(0.01)
			arg3 = arg3
			var4 = 0
			return
		end
		var4 = vm.i32(var4 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg2 == -1.0 then
		arg2 = vm.f32(0.01)
	end
	if arg3 > 0 then
		arg3 = arg3
	end
	var4 = 0
	while var4 < arg3 do
		get_now_frame_wait = event.GetMotNowWait(arg0) or get_now_frame_wait
		if get_now_frame_wait < vm.f32(arg1 + arg2) and get_now_frame_wait > vm.f32(arg1 - arg2) then
			return
		end
		if vm.wait() then
			return skip(2)
		end
		var4 = vm.i32(var4 + 1)
	end
end

--- Helper function.
local function helper_3a2a4(arg0: s32)
	local projection: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(1)
		end
		if at <= 2 then
			helper_6c719c99(1090020)
		end
		if at <= 3 then
			helper_37e6c(33, vm.f32(0.805), -1.0, 60)
		end
		if at <= 4 then
			helper_6c719c99(1090030)
		end
		if at <= 5 then
			helper_8f31f334(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	projection = event.GetProjection() or projection
	event.SetProjection(813.9)
	event.CmrsSetPos(-11.48, 40.92, -121.7)
	event.CmrsSetRef(-8.15, 36.49, -100.87)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -4.0, 5.43, -39.21)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ちあがるL", 4)
	event.ObjsSetMotion(1, "腰に手", 6)
	event.ObjsNextMotion(1, "腰に手L")
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(1090020)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "机をたたく", 6)
	event.ObjsNextMotion(1, "机をたたくL")
	helper_37e6c(33, vm.f32(0.805), -1.0, 60)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(arg0, 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(1090030)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetProjection(projection)
end

--- Helper function.
local function helper_3a914(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6c719c99(1090040)
		end
		if at <= 2 then
			helper_6c719c99(1090050)
		end
		if at <= 3 then
			helper_8f31f334(2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-13.07, 25.09, -70.71)
	event.CmrsSetRef(1.86, 31.3, -95.34)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ちあがるL", 4)
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090040)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ため息", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "下向き立ち")
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090050)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_3ad68(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6c719c99(1090060)
		end
		if at <= 2 then
			helper_6c719c99(1090070)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-24.3, 23.42, -18.85)
	event.CmrsSetRef(2.59, 28.72, -60.25)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, 0.65, 5.43, -39.63)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "下向き立ち", 4)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(1090060)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090070)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_3b1a8(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6c719c99(1090080)
		end
		if at <= 2 then
			helper_184013af()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-0.73, 30.22, -58.88)
	event.CmrsSetRef(0.18, 32.06, -95.16)
	event.SetCharaPos(34, 0.22, 5.19, -94.18)
	event.SetCharaRot(34, 0.0, 0.0, 0.0)
	event.CmrsMove2(-0.4, 30.22, -71.81, 0.18, 32.06, -95.16, 100, 0, 0.4)
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090080)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_184013af()
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_3b490()
	local projection: f32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_8f31f334(3)
			end
			if at <= 2 then
				helper_390d8(var1)
				helper_39134(var1)
			end
			if at <= 3 then
				helper_39488(var1)
			end
			if at <= 4 then
				helper_399b4(var1)
				helper_39a28(var1)
			end
			if at <= 5 then
				helper_39e44(var1)
			end
			if at <= 6 then
				helper_3a2a4(var1)
			end
			if at <= 7 then
				helper_3a914(var1)
			end
			if at <= 8 then
				helper_3ad68(var1)
			end
			if at <= 9 then
				helper_3b1a8(var1)
			end
			if at <= 10 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.SetProjection(projection)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.StopBgm(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(109, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(1240)
	var1 = event.SndLoadSound(1240) or var1
	projection = event.GetProjection() or projection
	event.StopBgm(0)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(101)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.SetCameraPos(0.0, 0.0, 0.0)
	event.SetCameraRef(1.0, 0.0, 0.0)
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 33)
	event.CharaActive(1, 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -0.66, 0.09, 140.34)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.SetTexAnim(33, 0, "通常口パク")
	event.EohSetSoundId(1, var1)
	event.LoadChara(5, "event/e100/e109/e109_need.gltf", "info", 34)
	event.CharaActive(1, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 50.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.SetTexAnim(34, 0, "通常口パク")
	event.EohSetSoundId(2, var1)
	event.LoadChara(5, "event/e100/e109/e109_door.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -0.66, 0.0, 123.46)
	event.ObjsSetRot(3, 0.0, -3.14, 0.0)
	event.ObjsSetMotion(3, "待機", 4)
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSyncObj(10, "p06_i03h01a", "i03h01a_06-m")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -25.673, -42.2002, -83.6474)
	event.EohSyncObj(11, "p05_i03h01a", "i03h01a_05-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.ObjsSetPos(11, -25.4763, -40.9848, -84.1156)
	event.EohSyncObj(12, "p05_i03h01a", "i03h01a_05-m2")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.ObjsSetPos(12, -26.5572, -30.485, -63.0372)
	event.EohSyncObj(13, "p11_i03h01a", "i03h01a_11-m")
	event.EohSetShow(13, 0)
	event.LoadMes(0, 5, "event/e100/e109/e109a_1.txt")
	event.StopBgm(0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "こまり顔")
	event.ObjsTexAnime(2, 1, "こまり目パチ")
	event.InitDramaScene()
	helper_390d8(var1)
	helper_39134(var1)
	if vm.skipping() then
		return skip(3)
	end
	helper_39488(var1)
	if vm.skipping() then
		return skip(4)
	end
	helper_399b4(var1)
	helper_39a28(var1)
	if vm.skipping() then
		return skip(5)
	end
	helper_39e44(var1)
	if vm.skipping() then
		return skip(6)
	end
	helper_3a2a4(var1)
	if vm.skipping() then
		return skip(7)
	end
	helper_3a914(var1)
	if vm.skipping() then
		return skip(8)
	end
	helper_3ad68(var1)
	if vm.skipping() then
		return skip(9)
	end
	helper_3b1a8(var1)
	if vm.skipping() then
		return skip(10)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_3c6d4(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(30)
		end
		if at <= 2 then
			helper_6c719c99(1090090)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-46.87, 29.18, -9.44)
	event.CmrsSetRef(3.87, 26.86, -60.12)
	event.ObjsSetPos(1, -0.19, 5.43, -35.38)
	event.ObjsSetRot(1, 0.0, 3.04, 0.0)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "下向き立ち", 4)
	event.SetFadeIn(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090090)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_3ca5c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(1)
		end
		if at <= 2 then
			helper_6c719c99(1090100)
		end
		if at <= 3 then
			helper_6c719c99(1090110)
		end
		if at <= 4 then
			helper_8f31f334(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-1.63, 28.5, -58.54)
	event.CmrsSetRef(-1.54, 28.17, -29.76)
	event.SetCharaPos(33, -1.6, 4.14, -22.85)
	event.SetCharaRot(33, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(1, "腕組み", 4)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(1090100)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "腕組み会話", 6)
	event.ObjsNextMotion(1, "腕組み", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(1090110)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_3ce78(arg0: any)
	local var1: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(2)
		end
		if at <= 2 then
			helper_6c719c99(1090120)
		end
		if at <= 3 then
			helper_8f31f334(2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-0.29, 27.55, -25.02)
	event.CmrsSetRef(-1.02, 29.45, -94.81)
	event.GetProjection() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.SetProjection(871.9)
	event.SetCharaPos(34, 0.22, 5.19, -94.18)
	event.SetCharaRot(34, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "前を見るL", 4)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090120)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetProjection(var1)
end

--- Helper function.
local function helper_3d1ac(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6c719c99(1090130)
		end
		if at <= 2 then
			helper_8f31f334(1)
		end
		if at <= 3 then
			helper_6c719c99(1090131)
		end
		if at <= 4 then
			helper_8f31f334(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-3.62, 25.14, -51.33)
	event.CmrsSetRef(12.22, 28.93, -35.31)
	event.ObjsSetPos(1, 12.17, 5.43, -29.98)
	event.ObjsSetRot(1, 0.0, -3.12, 0.0)
	event.SndSePlay(arg0, 3)
	event.ObjsSetMotion(1, "バカもん！", 6)
	event.ObjsNextMotion(1, "バカもん！L", 6)
	event.ObjsNextMotion(1, "バカもん！戻り", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090130)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090131)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_3d62c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(1)
		end
		if at <= 2 then
			helper_8f31f334(2)
		end
		if at <= 3 then
			helper_6c719c99(1090140)
		end
		if at <= 4 then
			helper_6c719c99(1090150)
		end
		if at <= 5 then
			helper_6c719c99(1090160)
		end
		if at <= 6 then
			helper_6c719c99(1090170)
		end
		if at <= 7 then
			helper_8f31f334(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(17.24, 26.0, -9.56)
	event.CmrsSetRef(5.22, 26.46, -42.09)
	event.ObjsSetPos(1, -4.35, 5.29, -42.32)
	event.ObjsSetRot(1, 0.0, 2.92, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "下見向き立ち", 4)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090140)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090150)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_6c719c99(1090160)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090170)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_3dc18(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6c719c99(1090180)
		end
		if at <= 2 then
			helper_8f31f334(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(3.57, 18.33, -44.95)
	event.CmrsSetRef(-13.94, 26.79, -26.13)
	event.SetCharaPos(33, -12.31, 3.85, -22.31)
	event.SetCharaRot(33, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(1, "そうじゃ！", 6)
	event.ObjsNextMotion(1, "そうじゃ！L", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090180)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_3df04(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(2)
		end
		if at <= 2 then
			helper_6c719c99(1090190)
		end
		if at <= 3 then
			helper_6c719c99(1090200)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(24.93, 29.64, -79.63)
	event.CmrsSetRef(-8.31, 36.32, -96.0)
	event.SetCharaPos(34, 0.05, 10.14, -94.36)
	event.SetCharaRot(34, 0.0, 0.0, 0.0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目とじ～目あけ")
	event.ObjsSetMotion(2, "下向き立ち", 4)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "しんけん顔")
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090190)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(1090200)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_3e300(arg0: s32)
	local var1: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(1)
		end
		if at <= 2 then
			helper_8f31f334(2)
		end
		if at <= 3 then
			helper_6c719c99(1090210)
		end
		if at <= 4 then
			helper_8f31f334(1)
		end
		if at <= 5 then
			helper_6c719c99(1090220)
		end
		if at <= 6 then
			helper_8f31f334(2)
		end
		if at <= 7 then
			helper_6c719c99(1090230)
		end
		if at <= 8 then
			helper_8f31f334(1)
		end
		if at <= 9 then
			helper_aafd6a80(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(17.24, 26.0, -9.56)
	event.CmrsSetRef(5.22, 26.46, -42.09)
	event.ObjsSetPos(1, -4.35, 5.29, -42.32)
	event.ObjsSetRot(1, 0.0, 2.92, 0.0)
	event.ObjsSetMotion(1, "そうじゃ！L")
	event.ObjsSetPos(2, 0.22, 5.19, -94.18)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "前を見るL", 4)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "そうじゃ！会話", 6)
	event.ObjsNextMotion(1, "そうじゃ！L")
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090210)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.ObjsSetMotion(2, "考える", 6, 0.08)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "下向き立ち")
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090220)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(arg0, 5)
	event.ObjsSetMotion(1, "そうじゃ！会話", 6)
	event.ObjsNextMotion(1, "そうじゃ！L")
	event.SetPakuAnim(1, "大口パク")
	helper_6c719c99(1090230)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(9)
	end
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(10)
	end
	event.SetProjection(var1)
end

--- Helper function.
local function helper_3ead0(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8f31f334(2)
		end
		if at <= 2 then
			helper_6c719c99(1090240)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(24.93, 29.64, -79.63)
	event.CmrsSetRef(-8.31, 36.32, -96.0)
	event.ObjsSetPos(2, 0.05, 10.14, -94.36)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目とじ～目あけ")
	event.ObjsSetMotion(2, "前を見る", 2)
	event.ObjsNextMotion(2, "前を見るL")
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(1090240)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	if vm.wait() then
		return skip(4)
	end
end

--- Helper function.
local function helper_3ee20()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 14 then
			if at <= 1 then
				helper_8f31f334(3)
			end
			if at <= 2 then
				helper_8f31f334(10)
			end
			if at <= 3 then
				helper_8f31f334(11)
			end
			if at <= 4 then
				helper_8f31f334(12)
			end
			if at <= 5 then
				helper_3c6d4(var0)
			end
			if at <= 6 then
				helper_3ca5c(var0)
			end
			if at <= 7 then
				helper_3ce78(var0)
			end
			if at <= 8 then
				helper_3d1ac(var0)
			end
			if at <= 9 then
				helper_3d62c(var0)
			end
			if at <= 10 then
				helper_3dc18(var0)
			end
			if at <= 11 then
				helper_3df04(var0)
			end
			if at <= 12 then
				helper_3e300(var0)
			end
			if at <= 13 then
				helper_3ead0(var0)
			end
			if vm.skip_end() then
				return skip(15)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(1243)
	var0 = event.SndLoadSound(1243) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	if vm.wait() then
		return skip(1)
	end
	event.SetCameraPos(0.0, 0.0, 0.0)
	event.SetCameraRef(1.0, 0.0, 0.0)
	event.SetFadeOut(0)
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 33)
	event.CharaActive(1, 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(33, -0.66, 0.09, 140.34)
	event.SetCharaRot(33, 0.0, -3.12, 0.0)
	event.SetTexAnim(33, 0, "口パク")
	event.EohSetSoundId(1, var0)
	event.LoadChara(5, "event/e100/e109/e109_need.gltf", "info", 34)
	event.CharaActive(1, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(34, 0.0, 50.0, 0.0)
	event.SetTexAnim(34, 0, "口パク")
	event.LoadChara(5, "event/e100/e109/e109_door.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(35, -0.66, 0.0, 123.46)
	event.SetCharaRot(35, 0.0, -3.14, 0.0)
	event.ObjsSetMotion(3, "待機", 4)
	helper_8f31f334(3)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSyncObj(10, "p06_i03h01a", "i03h01a_06-m")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -25.673, -42.2002, -83.6474)
	event.EohSyncObj(11, "p05_i03h01a", "i03h01a_05-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.ObjsSetPos(11, -25.4763, -40.9848, -84.1156)
	event.EohSyncObj(12, "p05_i03h01a", "i03h01a_05-m2")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.ObjsSetPos(12, -26.5572, -30.485, -63.0372)
	helper_8f31f334(10)
	if vm.skipping() then
		return skip(3)
	end
	helper_8f31f334(11)
	if vm.skipping() then
		return skip(4)
	end
	helper_8f31f334(12)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSyncObj(13, "p01_i03h01a", "i03h01a_01-m")
	event.EohSetFrameStatus(13, "doa", 2)
	event.LoadMes(0, 5, "event/e100/e109/e109b_1.txt")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.InitDramaScene()
	helper_3c6d4(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_3ca5c(var0)
	if vm.skipping() then
		return skip(7)
	end
	helper_3ce78(var0)
	if vm.skipping() then
		return skip(8)
	end
	helper_3d1ac(var0)
	if vm.skipping() then
		return skip(9)
	end
	helper_3d62c(var0)
	if vm.skipping() then
		return skip(10)
	end
	helper_3dc18(var0)
	if vm.skipping() then
		return skip(11)
	end
	helper_3df04(var0)
	if vm.skipping() then
		return skip(12)
	end
	helper_3e300(var0)
	if vm.skipping() then
		return skip(13)
	end
	helper_3ead0(var0)
	if vm.skipping() then
		return skip(14)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.ResetCamera(1)
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3b490()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3ee20()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_9d6455b5()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3b490()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoDng(0, -1, 1000)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3ee20()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "i02h01", 500)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8ce95bf9()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11091.
script[11091] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3b490()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11092.
script[11092] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.CharaActive(0, 8)
	helper_3ee20()
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 8)
	event.BgmLoadCancel()
	event.MapJump(-1, "i02h01", 500)
	if vm.wait() then
		return skip(2)
	end
end

return script
