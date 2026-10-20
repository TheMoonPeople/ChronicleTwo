--!strict
-- map/i/i03/h01/i03h01a.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_076280e8 = require("@lib/event/helper_076280e8")
local helper_1b06d86e = require("@lib/event/helper_1b06d86e")
local helper_1d96573f = require("@lib/event/helper_1d96573f")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_3c8e2192 = require("@lib/event/helper_3c8e2192")
local helper_3dd465f9 = require("@lib/event/helper_3dd465f9")
local helper_3e8d7f78 = require("@lib/event/helper_3e8d7f78")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_7e17ca03 = require("@lib/event/helper_7e17ca03")
local helper_8d58a537 = require("@lib/event/helper_8d58a537")
local helper_d1f370f3 = require("@lib/event/helper_d1f370f3")
local helper_eb838ef8 = require("@lib/event/helper_eb838ef8")
local helper_f96a9d1b = require("@lib/event/helper_f96a9d1b")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")
local helper_fff7b413 = require("@lib/event/helper_fff7b413")

--- Helper function.
local function helper_36b6c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_36bc8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(2)
		end
		if at <= 2 then
			helper_ff0edc1d(66)
		end
		if at <= 3 then
			helper_076280e8()
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
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.SndSePlay(arg0, 2)
	helper_ff0edc1d(66)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsMove2(79.6, 44.59, -39.31, 39.97, 30.03, 52.15, 90, 2, 0.4)
	helper_076280e8()
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_369d8(arg0: any, arg1: s32)
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
local function helper_36f1c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_369d8(arg0, 160)
		end
		if at <= 2 then
			helper_650bfa16(1)
		end
		if at <= 3 then
			helper_650bfa16(3)
		end
		if at <= 4 then
			helper_076280e8()
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
	helper_369d8(arg0, 160)
	if vm.skipping() then
		return skip(2)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_650bfa16(3)
	if vm.skipping() then
		return skip(4)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_37448(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_374bc(arg0: any)
	local var1: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(2)
		end
		if at <= 2 then
			helper_1d96573f(1090010)
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
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090010)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetProjection(var1)
end

--- Helper function.
local function helper_368a4(arg0: any, arg1: s32)
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
local function helper_378d8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_368a4(arg0, 70)
		end
		if at <= 2 then
			helper_ff0edc1d(5)
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
	helper_368a4(arg0, 70)
	if vm.skipping() then
		return skip(2)
	end
	helper_ff0edc1d(5)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_35a2c(arg0: s32, arg1: f32, arg2: f32, arg3: s32)
	local var4: s32 = 0
	local get_now_frame_wait: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg2 = vm.f32(0.01)
			var4 = 0
			return
		end
		var4 = var4 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg2 == -1.0 then
		arg2 = vm.f32(0.01)
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
		var4 = var4 + 1
	end
end

--- Helper function.
local function helper_37d38(arg0: s32)
	local projection: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(1)
		end
		if at <= 2 then
			helper_1d96573f(1090020)
		end
		if at <= 3 then
			helper_35a2c(33, vm.f32(0.805), -1.0, 60)
		end
		if at <= 4 then
			helper_1d96573f(1090030)
		end
		if at <= 5 then
			helper_650bfa16(1)
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
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(1090020)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "机をたたく", 6)
	event.ObjsNextMotion(1, "机をたたくL")
	helper_35a2c(33, vm.f32(0.805), -1.0, 60)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(arg0, 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(1090030)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetProjection(projection)
end

--- Helper function.
local function helper_383a8(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d96573f(1090040)
		end
		if at <= 2 then
			helper_1d96573f(1090050)
		end
		if at <= 3 then
			helper_650bfa16(2)
		end
		if at <= 4 then
			helper_1d96573f(1090051)
		end
		if at <= 5 then
			helper_1d96573f(1090052)
		end
		if at <= 6 then
			helper_ff0edc1d(30)
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
	helper_1d96573f(1090040)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ため息", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "下向き立ち")
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090050)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090051)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090052)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_38908(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d96573f(1090060)
		end
		if at <= 2 then
			helper_1d96573f(1090070)
		end
		if at <= 3 then
			helper_1d96573f(1090071)
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
	helper_1d96573f(1090060)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090070)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090071)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_38dc4(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d96573f(1090080)
		end
		if at <= 2 then
			helper_076280e8()
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
	helper_1d96573f(1090080)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_076280e8()
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_390ac()
	local projection: f32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_650bfa16(3)
			end
			if at <= 2 then
				helper_36b6c(var1)
				helper_36bc8(var1)
			end
			if at <= 3 then
				helper_36f1c(var1)
			end
			if at <= 4 then
				helper_37448(var1)
				helper_374bc(var1)
			end
			if at <= 5 then
				helper_378d8(var1)
			end
			if at <= 6 then
				helper_37d38(var1)
			end
			if at <= 7 then
				helper_383a8(var1)
			end
			if at <= 8 then
				helper_38908(var1)
			end
			if at <= 9 then
				helper_38dc4(var1)
			end
			if at <= 10 then
				helper_ff0edc1d(30)
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
	helper_ff0edc1d(4)
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
	helper_650bfa16(3)
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
	event.LoadMes(0, 5, "event/e100/e109/e109a.txt")
	event.StopBgm(0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "こまり顔")
	event.ObjsTexAnime(2, 1, "こまり目パチ")
	event.InitDramaScene()
	helper_36b6c(var1)
	helper_36bc8(var1)
	if vm.skipping() then
		return skip(3)
	end
	helper_36f1c(var1)
	if vm.skipping() then
		return skip(4)
	end
	helper_37448(var1)
	helper_374bc(var1)
	if vm.skipping() then
		return skip(5)
	end
	helper_378d8(var1)
	if vm.skipping() then
		return skip(6)
	end
	helper_37d38(var1)
	if vm.skipping() then
		return skip(7)
	end
	helper_383a8(var1)
	if vm.skipping() then
		return skip(8)
	end
	helper_38908(var1)
	if vm.skipping() then
		return skip(9)
	end
	helper_38dc4(var1)
	if vm.skipping() then
		return skip(10)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_3a2e0(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(30)
		end
		if at <= 2 then
			helper_1d96573f(1090090)
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
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090090)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_3a668(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(1)
		end
		if at <= 2 then
			helper_1d96573f(1090100)
		end
		if at <= 3 then
			helper_1d96573f(1090110)
		end
		if at <= 4 then
			helper_650bfa16(1)
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
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(1090100)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "腕組み会話", 6)
	event.ObjsNextMotion(1, "腕組み", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(1090110)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_3aa84(arg0: any)
	local var1: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(2)
		end
		if at <= 2 then
			helper_1d96573f(1090120)
		end
		if at <= 3 then
			helper_650bfa16(2)
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
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090120)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetProjection(var1)
end

--- Helper function.
local function helper_3adb8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d96573f(1090130)
		end
		if at <= 2 then
			helper_650bfa16(1)
		end
		if at <= 3 then
			helper_1d96573f(1090131)
		end
		if at <= 4 then
			helper_650bfa16(1)
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
	helper_1d96573f(1090130)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "大口パク")
	helper_1d96573f(1090131)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_3b238(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(1)
		end
		if at <= 2 then
			helper_650bfa16(2)
		end
		if at <= 3 then
			helper_1d96573f(1090140)
		end
		if at <= 4 then
			helper_1d96573f(1090141)
		end
		if at <= 5 then
			helper_1d96573f(1090150)
		end
		if at <= 6 then
			helper_1d96573f(1090160)
		end
		if at <= 7 then
			helper_1d96573f(1090170)
		end
		if at <= 8 then
			helper_650bfa16(1)
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
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090140)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090141)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_1d96573f(1090150)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_1d96573f(1090160)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_1d96573f(1090170)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_3b890(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d96573f(1090180)
		end
		if at <= 2 then
			helper_650bfa16(1)
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
	helper_1d96573f(1090180)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_3bb7c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(2)
		end
		if at <= 2 then
			helper_1d96573f(1090190)
		end
		if at <= 3 then
			helper_1d96573f(1090200)
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
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "しんけん顔")
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090190)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(1090200)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_3bf78(arg0: s32)
	local var1: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(1)
		end
		if at <= 2 then
			helper_650bfa16(2)
		end
		if at <= 3 then
			helper_1d96573f(1090210)
		end
		if at <= 4 then
			helper_650bfa16(1)
		end
		if at <= 5 then
			helper_1d96573f(1090211)
		end
		if at <= 6 then
			helper_1d96573f(1090220)
		end
		if at <= 7 then
			helper_650bfa16(2)
		end
		if at <= 8 then
			helper_1d96573f(1090230)
		end
		if at <= 9 then
			helper_650bfa16(1)
		end
		if at <= 10 then
			helper_ff0edc1d(60)
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
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "そうじゃ！会話", 6)
	event.ObjsNextMotion(1, "そうじゃ！L")
	event.SetPakuAnim(1, "大口パク")
	helper_1d96573f(1090210)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "そうじゃ！会話", 6)
	event.ObjsNextMotion(1, "そうじゃ！L", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_1d96573f(1090211)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.ObjsSetMotion(2, "考える", 6, 0.08)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "下向き立ち")
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090220)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSePlay(arg0, 5)
	event.ObjsSetMotion(1, "そうじゃ！会話", 6)
	event.ObjsNextMotion(1, "そうじゃ！L")
	event.SetPakuAnim(1, "大口パク")
	helper_1d96573f(1090230)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(10)
	end
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(11)
	end
	event.SetProjection(var1)
end

--- Helper function.
local function helper_3c864(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(2)
		end
		if at <= 2 then
			helper_1d96573f(1090240)
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
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(1090240)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	if vm.wait() then
		return skip(4)
	end
end

--- Helper function.
local function helper_3cbb4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 14 then
			if at <= 1 then
				helper_650bfa16(3)
			end
			if at <= 2 then
				helper_650bfa16(10)
			end
			if at <= 3 then
				helper_650bfa16(11)
			end
			if at <= 4 then
				helper_650bfa16(12)
			end
			if at <= 5 then
				helper_3a2e0(var0)
			end
			if at <= 6 then
				helper_3a668(var0)
			end
			if at <= 7 then
				helper_3aa84(var0)
			end
			if at <= 8 then
				helper_3adb8(var0)
			end
			if at <= 9 then
				helper_3b238(var0)
			end
			if at <= 10 then
				helper_3b890(var0)
			end
			if at <= 11 then
				helper_3bb7c(var0)
			end
			if at <= 12 then
				helper_3bf78(var0)
			end
			if at <= 13 then
				helper_3c864(var0)
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
	helper_650bfa16(3)
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
	helper_650bfa16(10)
	if vm.skipping() then
		return skip(3)
	end
	helper_650bfa16(11)
	if vm.skipping() then
		return skip(4)
	end
	helper_650bfa16(12)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSyncObj(13, "p01_i03h01a", "i03h01a_01-m")
	event.EohSetFrameStatus(13, "doa", 2)
	event.LoadMes(0, 5, "event/e100/e109/e109b.txt")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.InitDramaScene()
	helper_3a2e0(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_3a668(var0)
	if vm.skipping() then
		return skip(7)
	end
	helper_3aa84(var0)
	if vm.skipping() then
		return skip(8)
	end
	helper_3adb8(var0)
	if vm.skipping() then
		return skip(9)
	end
	helper_3b238(var0)
	if vm.skipping() then
		return skip(10)
	end
	helper_3b890(var0)
	if vm.skipping() then
		return skip(11)
	end
	helper_3bb7c(var0)
	if vm.skipping() then
		return skip(12)
	end
	helper_3bf78(var0)
	if vm.skipping() then
		return skip(13)
	end
	helper_3c864(var0)
	if vm.skipping() then
		return skip(14)
	end
	return part2()
end

--- Helper function.
local function helper_15f8()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(10)
		end
	end
	event.FunctionDoorMode()
	if vm.wait() then
		return skip(1)
	end
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(2)
	end
	event.FunctionMapJump()
end

--- Helper function.
local function helper_10574(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "この木は・・・イカンな。\nなんとかせねば。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"おぉ、坊ちゃんでしたか、驚いた。\nちょうど木についた悪い虫を取っていたところです。<page>植物は勝手に育つ物ばかりじゃなく、こんな風に\n世話をしないと枯れてしまうのもあるんですよ。"
		)
		helper_f96a9d1b(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_10240(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMotion(arg1, "立ち")
	event.MesMake_2(0, "この木は・・・イカンな。\nなんとかせねば。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
end

--- Helper function.
local function helper_1089c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 11 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_10240(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"あっ、ユリス坊ちゃん。\n最近、出歩かれることが多いようですが、\nくれぐれも気をつけてくださいよ。<page>それで、アッシに何かご用で？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "何と！アッシに坊ちゃんの\n冒険について来いと？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"う～む、いっしょに行きたいところなのですが、\nこいつが病気にかかっているようなんです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"アッシの第一の仕事は、この屋敷の\n木や花たちのお世話をすること。<page>それをほったらかしにして留守になどしたら\nダンナ様に怒られてしまいます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"教会のブルーノさんが売っている「聖水」なら、\nこの木の病気を治せると思うんですけどね。<page>ダンナ様とブルーノ神父は、坊ちゃんも\n知ってのとおり犬猿の仲。<page>ブルーノさんの聖水を買うと言っても、\nお金はもらえませんし。<page>どうしたものでしょう・・・。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]グリンの頼みごとを聞いて、解決してあげることで、\n   グリンを冒険の仲間として、列車に乗せることができます。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]頼まれごと（クエスト）は、アイテムメニュー内にある\n   「メモ帳」で確認することができます。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	argc = event.GetItemHaveNum(386) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"[(!)]おや、メモ帳を持っていないようですね。\n   メモ帳は、メンテナンスショップ奥の\n   テーブルの上に置いてあります。"
		)
		helper_eb838ef8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"[(!)]ドニーのアジトにも同じような物が\n   落ちています。どちらでも良いので、\n   急いで取りに行きましょう。"
		)
		helper_eb838ef8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 0, 1)
end

--- Helper function.
local function helper_115dc(arg0: s32, arg1: s32)
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
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 9 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 10 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_10240(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"ユリス坊ちゃん。この木を\n治すのがアッシの仕事です。<page>この木を治すためには・・・"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"さて、坊ちゃん。これで\nひとまず仕事は済みました。<page>坊ちゃんの冒険に\n同行させてもらいます。<page>あ、それと「聖水」のことは、\nダンナ様にはナイショですよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]仲間がさらにふえた場合\n   列車の中に乗って、冒険に同行するので\n   話しかけてキャラを切り換えます。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"[(!)]仲間を他の土地に移住させるためには、\n   建てた家の扉に出るメニューから\n   「移住させる」を選んでください。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"[(!)]他にもいろいろな場所に、\n   仲間になってくれる人がいるかも\n   しれません。探してみましょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
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
local function helper_1221c(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1251c(arg0: s32, arg1: s32)
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
		helper_10574(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_1089c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_115dc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_1221c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

--- Helper function.
local function helper_14df4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_3c8e2192(arg0, 0, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
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
		helper_3c8e2192(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_15200(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_3dd465f9(0, -1, arg1, arg0, 0)
			end
			if at <= 5 then
				helper_eb838ef8(0, -1, 8, 0, 0)
			end
			return
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 10 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 13 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_3c8e2192(arg0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.MesMake_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(0, "・・・")
		helper_3dd465f9(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]モニカはこういうタイプが苦手みたい。\n   まぁ、無理ないかも。仕方ありません。\n   ユリスで話しかけてみましょう。"
		)
		helper_eb838ef8(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMesPreset(0, 0)
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "やぁ、ユリス、\nこんにちは。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(0, "・・・")
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(
		0,
		"ふっ、おかしいだろう、\n笑ってくれて良いよ。<page>絵の中の女性に惚れて\nしまったなんてさ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(
		0,
		"でも、僕は魔法絵師だ。\n描いた物を本物にする力がある。<page>僕が描けば、それはそこに\n存在するんだ。それが\n生命のない物なら・・・"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, "魔法絵師の力では、\n生命を描く事は\nどうしても出来ないんだ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(0, "ただ、聞いた事がある。\nいにしえの巨木に宿る\n黄金の卵。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(
		0,
		"そこから得られる金色を\n用いれば、描いた物に\n生命を与えられると。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.MesMake_2(
		0,
		"なぁ、ユリス、君は\n町の外に出かけている\nそうじゃないか。<page>この『金色の絵の具』\nどこかで手に\n入らないかな？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"もちろん、ただとは\n言わない。<page>手に入れて来てくれたら、\n僕のこの能力を君のために\n使わせてもらうよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 1, 1)
end

--- Helper function.
local function helper_10160()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3e8d7f78(var0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_3e8d7f78(var0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_16318(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_10160()
		end
		if at <= 8 then
			helper_3e8d7f78(22)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"待ちくたびれたよ。<page>さぁ、早く絵に生命を\n宿らせる絵の具をくれ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SubItem(376)
	event.MesMake_2(0, "これが『金色の絵の具』か・・・\n早速、使ってみるよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"は、ははっ、本当に\n本物になった・・・<page>すばらしい、まさに\n完璧な女性だ！"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"ありがとう、ユリス。\n約束だったね。僕のこの能力、\nえんりょなく存分に使ってくれ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(8)
	end
	event.SetNpcStatus(22, 130)
	helper_3e8d7f78(22)
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 1, 1)
end

--- Helper function.
local function helper_16ad0(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_16cf8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_14df4(arg0, arg1)
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
		helper_14df4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_15200(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_16318(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_16ad0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_db48(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_ff0edc1d(15)
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
local function helper_dc4c()
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
			helper_f96a9d1b(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_db48(15)
		end
		if at <= 3 then
			helper_db48(1)
		end
		if at <= 4 then
			helper_db48(6)
		end
		if at <= 5 then
			helper_db48(0)
		end
		if at <= 6 then
			helper_db48(4)
		end
		if at <= 7 then
			helper_db48(31)
		end
		if at <= 8 then
			helper_db48(35)
		end
		if at <= 9 then
			helper_db48(36)
		end
		if at <= 10 then
			helper_db48(37)
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
		helper_f96a9d1b(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_db48(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_db48(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_db48(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_db48(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_db48(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_db48(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_db48(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_db48(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_db48(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

--- Helper function.
local function helper_1716c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_16fdc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"お姉さんが来てから、ユリスの\n付き合いが悪くなっちまった。<page>何してんのか知らないけど、\nあいつをこき使わないでくれよ。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_172fc(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_16fdc(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"聞かなくてもわかるだろう、\nお、こ、と、わ、り、だ。<page>何で俺様が人様の為に\n働かなくちゃいけないんだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "大してもうかりそうもないし\nおっかないのはごめんだよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でもなぁ、他ならぬ\nユリスの頼みだし、曲げて\n話を聞いても良いぜ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "でもよ、俺も商人のせがれ、\nもうからない事はやらない\n主義だ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"知ってるだろう、俺が\nコインを集めてるって事。<page>コインは商いの象徴だ。\nなんとしてもコンプリート\nしたいんだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"でも、『鉄壁のコイン』\n『暗黒のコイン』が\nどうしても手に入らないんだ。<page>なんとかしてくれたら、\n俺もなんとかしてやるぜ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

--- Helper function.
local function helper_17a30(arg0: s32, arg1: s32)
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
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				var5 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 5 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			helper_10160()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_16fdc(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "わかったよ。\nどうしようかな？")
	var5 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 2, 1)
end

--- Helper function.
local function helper_184c0(arg0: s32, arg1: s32)
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
			helper_16fdc(arg0, arg1)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_187d0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1716c(arg0, arg1)
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
		helper_1716c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_172fc(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_17a30(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_184c0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_18ab4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "こんにちは。\nモニカさんはどんな\n食べ物が好きですか？")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_18e7c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"坊ちゃん、「発明」の\n調子はどうですか？<page>坊ちゃんが機械や仕掛けを\n「発明」するように、私は\n料理を「発明」しています。<page>まだ誰も食べた事のない\n美味い食べ物を作るために、\n日々研究をしています。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1905c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "あ、坊ちゃん、ちょうど良い所へ。\nちょっと相談があるんですよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"僕が研究のために世界中の\nめずらしいお菓子を作って\nいるのはご存知ですよね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "なんでも、「カスタニャッチョ」\nというお菓子があるそうで、")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "それは「カスターニャ」という\n物を使って作るらしいんです。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"いろいろ調べてみて、その\n「カスターニャ」ってのは、<page>どうも『とんがりマロン』と\n同じ種類の木の実らしいと\nいう所までは突き止めました。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"そこで、とりあえず『とんがりマロン』を\n使って作って見ようと思ったのですが、<page>不思議な事に、町中の『とんがりマロン』が\n売り切れてしまっているのです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"なんでも、町長が\n買い占めてしまったとか。<page>坊ちゃん、なんとか\nなりませんか？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

--- Helper function.
local function helper_197e8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "『とんがりマロン』は\n手に入りましたか？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そう言えば、\n私に何かご用で？<page>へ、坊ちゃんの冒険に\nついて来いですって。<page>はは、そりゃもちろん\nついて行きますとも。<page>なんで最初にそう言って\n下さらなかったんですか？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 3, 1)
end

--- Helper function.
local function helper_19ee0(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1a128(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_18ab4(arg0, arg1)
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
		helper_18ab4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_18e7c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1905c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_197e8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_19ee0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1a4b4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "こんにちは、ユリスの\nガールフレンドさん？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"めずらしい髪の色ですね。\nトムみたいな赤毛ともちがう、\nまるで宝石みたい。<page>ステキだわ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1a774(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1a4b4(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a4b4(arg0, arg1)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_1a98c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a4b4(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"そうね、ユリスの頼みだから聞いて\nあげたいけど、戦うなんて物騒だし\nなんだか汚れちゃいそう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"何よりみんなの足手まといに\nなるのはいやだわ。悪いけど\nお断りします。ごめんなさい。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でも、町の外には、\n珍しい物がたくさん\nあるんでしょうね。<page>どんな木が生えてて、\nどんな花が\n咲いてるのかしら。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"ねぇユリス、めずらしい花を\n見つけたら、写真を撮って来て\nちょうだい。ぜひ見てみたいわ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 4, 1)
end

--- Helper function.
local function helper_1b0f0(arg0: s32, arg1: s32)
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
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_10160()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1a4b4(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "めずらしい花の\n写真が撮れたの？\n見せて、見せて！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"あはっ、すごい、すごい！！\n外にはこんなにすごい花が\n咲いてるのね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "う～ん、\nどうしよう・・・<page>いいわ、私も\n連れて行って！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

--- Helper function.
local function helper_1b900(arg0: s32, arg1: s32)
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
			helper_1a4b4(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "あまり危ないところには\n行かないでね。")
	else
		event.MesMake_2(0, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1bbc0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1a774(arg0, arg1)
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
		helper_1a774(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_1a98c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1b0f0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1b900(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_1bea4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1c15c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"坊ちゃん、何か困った事が\nあれば、誰よりもまず\nこの私に相談してください。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1c2bc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"坊ちゃんの頼みとあらば、\n出来る限りの事をして\n差し上げます。<page>お任せください。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "・・・")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"引き受けてくれとは\n申しません・・・<page>ただ、私の話を聞いて\n頂きとうございます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"この家にお仕えして３０余年、\n真面目だけが取り得と\n今まで尽くしてまいりました。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "そんな仕事しか取り得の\nない私の、唯一の趣味が\n読書なんです。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"すごく貴重で珍しい本が\nありまして、その本が今、\nオークションに出ているのです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"まさに競り合っている最中なのです。\n思うに、１０００ギルダもあれば\n落札出来ます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"でも、そんな大金、とても\n持ち合わせていませんし、<page>こんな事、だんな様に\nご相談したなら、呆れ果てて、\nお暇を頂く事になるでしょう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"ですから、お頼みできるのは、\n坊ちゃんだけなのです。<page>決して、決して交換条件と\nいう訳ではございませんよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

--- Helper function.
local function helper_1cda8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_ff0edc1d(30)
			end
			return
		end
		if at <= 13 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
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
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(
				0,
				"坊ちゃん、大変です！<page>値がつり上がって\n１２００ギルダに\nなってしまいました。"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(
				0,
				"申し訳ないのですが、\n１５００ギルダ\n用立ててもらえませんか？"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
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
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"坊ちゃん、最悪です！\n１８００ギルダ出す\n方が現れました。<page>もう、２０００ギルダ\nくらい出さないと\n勝ち目はないです！"
			)
			helper_3dd465f9(0, -1, arg0, arg1, 0)
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
			helper_3dd465f9(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "坊ちゃん、２０００ギルダは\n用意できましたか？")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "しょうがない、あげるよ。\nやっぱり、もったいないや。")
		var4 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
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
			helper_3dd465f9(0, -1, arg0, arg1, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"実は強気に出たら、\n相手が早めに降りまして、<page>１４００ギルダで\n落札できてしまいました。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "なので、余った\n６００ギルダは\nお返しします。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(
		0,
		"坊ちゃんからお借りした分は、\nこれからお仕えする事で\n返していきたいと思います。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"私のわがままのために、\n坊ちゃんには苦労をおかけしました。<page>今度は私が\nお力になる番でございます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

--- Helper function.
local function helper_1e430(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1e698(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1bea4(arg0, arg1)
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
		helper_1bea4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1c15c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_1c2bc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_1cda8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1e430(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_1ea24(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "くれぐれも坊ちゃんを\n危ない目には\nあわせないで下さいね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1edac(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"今はこうしてメイドをして\nますけど、洋服屋さんに\nなるのが小さい頃の夢でした。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "夢は実現しないから\n夢って言うんですよね。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1f05c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですね・・・坊ちゃんの\nお願いですし、お引き受け\nしたいのはやまやまなんですけど、<page>私、自分に自信がないんです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"なんでも途中で投げ出してしまって、\n何かをやりとげた事がないんです。<page>小さい頃、洋服屋になるのが夢で、\n自分で何度も作ってみたんですけど、\n一着も完成させられなかったんです。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"こんな私がいっしょにいると、\nきっとめいわくをかけて\nしまうでしょう。<page>だから、ごめんなさい。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 7, 1)
end

--- Helper function.
local function helper_1f688(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですね、もう一度洋服を作ってみて、\n今度こそ完成させられたら、また自分を\n信じる事が出来るかも知れません。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"でも、洋服を作る材料なんて\n持っていません。<page>坊ちゃん、\n用意できないでしょうか？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"服を作るには、『意外と丈夫な布』\n『銅のかたまり』それと\n『ぶあつい皮』があれば充分です。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

--- Helper function.
local function helper_1fa98(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local var5: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3c8e2192(arg0, 0, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			if at <= 4 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			helper_ff0edc1d(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	var5 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var5 ~= 0 then
		event.MesMake_2(0, "材料がないと服は作れません。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
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
local function helper_2049c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			var2 = 259
			var2 = 258
			var2 = 260
			helper_7e17ca03(var2, 1)
		end
		if at <= 6 then
			helper_1b06d86e(1)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_10160()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "あ、坊ちゃん。やっと\n洋服が出来ました！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"頂いた材料をむだにしては\nいけないと思って、最後まで\nがんばる事が出来ました。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "まだまだ満足いく出来じゃ\nないんですけど、\n着て頂けますか？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_7e17ca03(var2, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"はぁ、何かをやりとげるって\n良い気持ちですね。<page>これで私も\n自分に自信がつきました。<page>私なりに精一杯がんばりますので、\n旅のお供をさせてください。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(9)
	end
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

--- Helper function.
local function helper_20b88(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_20da0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1ea24(arg0, arg1)
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
				helper_1fa98(arg0, arg1)
			end
			if at <= 6 then
				helper_2049c(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1ea24(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1edac(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_1f05c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_1f688(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_1fa98(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_2049c(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_20b88(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

--- Helper function.
local function helper_22028(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"最近、ユリスと\nいっしょにいる娘だね。<page>なかなか男を見る目が\nあるよ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "私もあともうちょっと若けりゃ、\n放っておかないんだけどねぇ。")
	else
		event.MesMake_2(0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_223c0(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"商売はお客の\n信用が第一。<page>ないがしろにしちゃ\n絶対にいけないよ。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_22520(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_7e17ca03(300, 20)
		end
		if at <= 5 then
			helper_1b06d86e(1)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"いっしょに旅をしてくれって？<page>パンを焼く事しか取り得のない\nおばさんだけど、ユリスの役に\n立つんなら、お安いご用さ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"あ、そうそう、その前に、\nモートンの所に配達する\n物があったんだっけ。<page>ユリス、すまないけど、\nモートンの店にパンを２０個\n届けてくれないかい？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "私はその間に旅の支度を\nしておくからさ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_7e17ca03(300, 20)
	if vm.skipping() then
		return skip(5)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "しかし、２０個のパンなんて\n何に使うんだろう？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

--- Helper function.
local function helper_22ad0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 < 3 then
		event.MesMake_2(
			0,
			"まだ、支度が\n出来てないんだよ。<page>もうちょっと\n待っておくれ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "ところで、\nモートンのところへは\n行ってくれたのかい？")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"そんなことより、ユリス、\n出発しましょう。<page>さぁ、どこへだって\nついて行きますよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SubItem(300, 20)
	event.AddItem(299, 20)
	helper_10160()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 8, 1)
end

--- Helper function.
local function helper_230e0(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_23318(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_22028(arg0, arg1)
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
		helper_22028(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_223c0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_22520(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_22ad0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_230e0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_127e8(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_12a50(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"この町は平和すぎて、\n私のかつやくする場が\n全然ない。<page>もちろん、それが\n良い事なのはわかって\nいるんだが・・・"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_12be0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"やぁ、ユリス。\n悪いが今は\n手が離せない。<page>町の安全のための\nとても重要な資料を\nまとめている所でね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "急ぎの用事でなければ、\n明日にしてもらえないか。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_12eb0(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	var2 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "じゃ、用意ドン！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

--- Helper function.
local function helper_13424(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_12eb0(arg0, arg1)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "やぁ、ユリス。私を\n呼びに来たのかい？<page>待っていたよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"城壁のおかげでこの町は\nとりあえず無事だ。<page>今度は我々が\n打って出る番だ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"しかし、ユリスは\n機械いじりばかりしてるけど、\n体力は大丈夫なんだろうね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"戦いの基本はスピードと\nフットワークだ。<page>私よりのろまだと\n話にならんよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そうだな、試しに\n池のボートまで行って\n戻って来てみろ。<page>私の記録は２分１秒だ。\nそれ以上かかるようなら\n話にならんね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "どうだ、挑戦してみるか？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	helper_12eb0(arg0, arg1)
	if vm.skipping() then
		return skip(8)
	end
end

--- Helper function.
local function helper_13a68(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_12eb0(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_12eb0(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_12eb0(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_12eb0(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_10160()
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
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(
			0,
			"やぁ、ユリス。\n挑戦しに来たのか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_12eb0(arg0, arg1)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_12eb0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "こら、インチキするな！")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_12eb0(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "お、戻ってきたな。\nじゃ、タイム発表！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "おいおい、\n[数値１]分[数値２]秒[数値３]なんて\n遅すぎるぞ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_12eb0(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(
		0,
		"お、[数値１]分[数値２]秒[数値３]とは\nなかなかのタイムじゃないか。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(
		0,
		"見かけによらず、良い足を\nしている。わかった、\nいっしょに悪と戦おう！"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

--- Helper function.
local function helper_14728(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14960(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_127e8(arg0, arg1)
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
		helper_127e8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_12a50(arg0, arg1)
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
		helper_12be0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_13424(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_13a68(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_14728(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

--- Helper function.
local function helper_236a4(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2390c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"うちの店は刃物専門だよ。<page>一応、銃も扱ってはいるが、\nどうも飛び道具は\n性に合わなくってね。"
	)
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_23a7c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7e17ca03(44, 1)
		end
		if at <= 6 then
			helper_1b06d86e(1)
		end
		if at <= 7 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 8 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "モニカって\n言ったっけ？<page>あんた、少しは剣が\n使えるらしいな。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"けどな、剣は子供の\n遊び道具じゃないぜ。<page>そんな腕じゃ\n先が思いやられる。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そうだな、剣を２回くらい\nビルドアップ出来たなら、\n腕を認めてやっても良いかな。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "とりあえず、\nこのグラディウスから\n初めてみな。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(44)
	helper_7e17ca03(44, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ミレーネに認めてもらうには、グラディウスを\n   ２段階ビルドアップさせるしかなさそうです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"[(!)]買ったり、拾ったりしても良いでしょう。\n   とにかく、強い剣を手に入れない限り、\n   ミレーネは仲間になってくれなさそうです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 10, 1)
end

--- Helper function.
local function helper_24220(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "ほう、なかなかの\n剣じゃないか。<page>試したみたいで\n悪かったな。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "しろうとといっしょに戦うと、\nこっちも危なくなるからね。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"でも、あんたの腕なら\nそんな心配はなさそうだ。<page>わかった、いっしょに\n戦うよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 10, 1)
end

--- Helper function.
local function helper_2485c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"よくきたえられた\n剣のかがやきは\n素晴らしいよ。<page>吸い込まれそうだ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "石ころをみがいて\nありがたがっている\n奴の気が知れないね。")
	else
		event.MesMake_2(0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_24bf4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_236a4(arg0, arg1)
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
		helper_236a4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2390c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_23a7c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_24220(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_2485c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_24f80(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_251e8(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "機械いじりも良いが、\nそろそろ鉱山の事も\n勉強したらどうだ。")
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_25338(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_7e17ca03(24, 1)
		end
		if at <= 6 then
			helper_1b06d86e(1)
		end
		if at <= 7 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"スターブルから聞いたぞ、<page>最近、何やらこそこそ\nやっているそうじゃないか。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"おまえは何でも\n器用にこなすが、<page>逆に言うと、何一つ\nやりとげたものが\nないんじゃないのか。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そんなおまえに力を貸せと\n言われても、うかつに\n信じられるわけがない。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"そうだな、このラッパガンを\nベルトリガーまで\nビルドアップしてみろ。<page>どうだ、出来るか？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.AddItem(24)
	helper_7e17ca03(24, 1)
	if vm.skipping() then
		return skip(6)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]ジラードに認めてもらうには、ベルトリガーを\n   持って来るしかなさそうです。もらった銃を成長\n   させても良いですし、ダンジョンで見つけても、\n   どこかで買って来ても良いでしょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 11, 1)
end

--- Helper function.
local function helper_25a6c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(25) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"どうした、また\nあきらめるのか？<page>それも良かろう。\n部屋で機械いじりでも\nしていることだ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"そうだな、力を貸してやろう。\nただし、これはおまえのためじゃない。<page>この町に良からぬ事が起きるのであれば、\nだまっているわけにいかないからな。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 11, 1)
end

--- Helper function.
local function helper_25fac(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_26224(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_24f80(arg0, arg1)
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
		helper_24f80(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_251e8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_25338(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_25a6c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_25fac(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

--- Helper function.
local function helper_265b0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d1f370f3(arg0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_d1f370f3(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"・・・１２１２、<page>いやいや、１１２２\nだったような気が。<page>それとも１０１０\nだったかな。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]目の前で話しかけているのに気づかないなんて、\n   何やら大きな悩み事があるみたいですね。<page>   後でまた来てみましょう。もしかしたら、\n   力になってあげられるかもしれませんよ。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
end

--- Helper function.
local function helper_26a10(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_fff7b413(arg0, arg1)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_fff7b413(arg1, arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "ぶつぶつ・・・")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"何ぶつぶつ\n言ってるのかって？<page>金庫の暗証番号を\n思い出してるんだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"どこの金庫かって？<page>町長室のがくぶちの裏に\n隠してある金庫に\n決まっているだろう・・・"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_fff7b413(arg0, arg1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"わぁ、おどかさないで\nくれよ。<page>あ、しまった！<page>町長の最大の秘密を\nしゃべってしまった！<page>でも、ここまで聞かれた\nのならしようがない。<page>たのむ、知恵を貸して\nくれないか。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "困った事に、金庫の\n暗証番号を忘れて\nしまったんだよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"４桁の数字なんだが、絶対\n忘れないようにと、クレアの\n誕生日にしておいたんだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"まさか、それを\n忘れてしまうなんて・・・<page>親として恥ずかしいやら、\n情けないやら。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 12, 1)
end

--- Helper function.
local function helper_27390(arg0: s32, arg1: s32)
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
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				var2 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_ff0edc1d(30)
			end
			if at <= 11 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_ff0edc1d(15)
			end
			return
		end
		if at <= 14 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_650bfa16(0)
		end
		if at <= 16 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_ff0edc1d(15)
		end
		if at <= 18 then
			helper_ff0edc1d(15)
		end
		if at <= 19 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 20 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 21 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	while true do
		event.MesMake_2(
			0,
			"【手がかり１】昔、誕生日に\nちなんだ星座のブローチを\nあげた事があったっけ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"ポリーに用意してもらったから\nよく覚えてないんだが、確か４本足の\n動物だったような気がする・・・"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"【手がかり２】\n今まであげた誕生日の\nプレゼント？<page>う～ん、コートとか\nマフラーとかが\n多いかなぁ。<page>どんなのが良いのか\nさっぱりわからんので、\n毎年苦労するんだよ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"【手がかり３】そうそう、クレアの誕生日は、\n燃えるゴミを出す日と、燃えないゴミを出す日が\n重なってるんで、いつも大変なんだよ。<page>ああ、我が家でゴミを出すのは私の役目だ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"燃えないゴミを出す日は\n日にちが７で割り切れる日、<page>燃えるゴミを出す日は\n３で割り切れる日だよ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.MesMake_2(0, "まさか、忘れてたんじゃ\nないだろうね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMotion(arg0, "立ち")
		event.MesMake_2(
			0,
			"わかった、謎は解けたぞ！暗証番号は・・・\nわからない・・・もっと話を聞いてみよう。"
		)
		var2 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
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
	helper_ff0edc1d(15)
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
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(11)
	end
	if var3 == 0 then
		event.SetMotion(arg0, "会話")
		event.MesMake_2(
			0,
			"う～ん、開かないな。\n困った・・・<page>とても大事な書類が\n入っているんだが。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		event.SetMotion(arg0, "立ち")
		event.SetFadeOut(15)
		helper_ff0edc1d(15)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMotion(arg0, "立ち")
	event.SndSePlay(var7, 66)
	event.MesMake_2(0, "うわっ！<page>やった、\n開いたぞ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSyncChara(0, arg0)
	event.ObjsInit(0, arg0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsReference(0, var14, var15, var16, 30)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(0, "おお、これで重要な\n書類が取り出せるよ。<page>ありがとう。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	event.SetFadeOut(15)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaRot(0, var17, var18, var19)
	event.SetCharaPos(arg0, var8, var9, var10)
	event.SetCharaRot(arg0, var11, var12, var13)
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetFadeIn(15)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetMotion(arg0, "会話")
	event.MesMake_2(
		0,
		"重要な書類って\n何かって？<page>私がいない時は、副町長の\nモートンに、町長の仕事を\n代行してもらうための書類だよ。<page>いささか不安ではあるが、\nまぁ、大丈夫だろう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.MesMake_2(
		0,
		"よし、これで私もこの町を\n離れられるようになったぞ。<page>話はスターブルから\n聞いている。<page>さぁ、いっしょに\n連れて行ってくれ！"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(22)
	end
	event.Finish()
	event.SetQuestEtc(1, 12, 1)
end

--- Helper function.
local function helper_292d0(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_29518(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_265b0(arg0, arg1)
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
		helper_265b0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_26a10(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_27390(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_292d0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2a1d4(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2a420(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"そうですか、私の力が\n必要ですか。<page>ならば、ひとつ\n問いを出しましょう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"この教会のロウソクには、\nいささか仕掛けが\nしてありましてね。<page>点いていれば消え、\n消えていれば点く。<page>ひとつが変化すれば、\nその隣り合うロウソクにもまた、\n変化が訪れます。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"うまく全てのロウソクを\n消す事が出来れば、賢者と認め、\n同行いたしましょう。<page>解ければ良し、解けなくば\n力は得られぬと心得なさい。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]教会から外に出てまた入れば、ロウソクは全て\n   元に戻るみたいです。失敗を恐れずやってみましょう。\n   実は正解って、すごく簡単な事かも知れませんよ。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 13, 1)
end

--- Helper function.
local function helper_297fc()
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
local function helper_2ab5c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var2 = helper_297fc()
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = helper_297fc()
	if 0 < var2 then
		event.MesMake_2(0, "どうやら、時はまだ\n満ちていないようですね。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"未来の君には期待していますが、\n今の君に協力する事はできません。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

--- Helper function.
local function helper_2b03c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2a1d4(arg0, arg1, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2b0d4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2a1d4(arg0, arg1, 0)
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
		helper_2a1d4(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_2a420(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2ab5c(arg0, arg1)
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
local function helper_2b3c4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2b534(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "う～ん、いっしょに\n行ってあげても良いけど、\nそこに月はあるの？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "本当に？言葉だけじゃ\n信じられないよ。人間は\nうそをつくからね。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "やっぱり、やめとく。\nここで月が出るのを\n待っているよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]とにかく、信じてもらう事が先決です。\n   そんなに月を見ていたいと言うなら、\n   写真を撮ってあげたらどうでしょう。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 14, 1)
end

--- Helper function.
local function helper_2bb80(arg0: s32, arg1: s32)
	local photo: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	photo = event.CheckInventPhoto(193) or photo
	if photo <= 0 then
		event.MesMake_2(
			0,
			"キミだけは違うような気がしてたんだけど、\nやっぱり人間には変わりないって事だね。<page>でも、いいんだ。人間はうそをつくんだって\nもうなれっこになってるからね。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"いっしょに来いって\n言うんでしょ。<page>いいよ。他に\n行く所もないし。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 14, 1)
end

--- Helper function.
local function helper_2c0b0(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2c2e8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2b3c4(arg0, arg1)
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
		helper_2b3c4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2b534(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2bb80(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2c0b0(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2c5cc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2c75c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "俺様に頼み事だって？<page>上等だ、聞いて\nやろうじゃねぇか。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"ただし、俺は\n俺が尊敬する奴の\n言う事しか聞かねぇ。<page>俺が尊敬するのは、俺より\nでかい魚を釣った事が\nある奴だけだ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"ちなみに、俺様が釣った中で\n一番でっかいのは、\n６０センチのノンキーだ。<page>どうだ、びびったかい？\n挑戦するなら、いつでも\n受けて立つぜ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "[(!)]とりあえず、パームブリンクスの池で\n   釣りをしてみましょう。")
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

--- Helper function.
local function helper_2ce18(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.ExtTyped(564, "iiF", 2, 322) or var2
	if var2 <= 0 then
		event.MesMake_2(
			0,
			"おい、実はノンキーを釣ったこと\nないんじゃないのか？<page>ははーん、さてはオマエ、\n釣りがヘタクソだろう！"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"そんな腕前で\n俺様を使おうなんて\n１００年早い！<page>顔を洗って\n出直してきやがれ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "・・・お、おみそれしました。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "よし、俺も男だ。\n男に二言はない。<page>約束通り\n言う事を聞くぜ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(0, "さぁ、煮るなり焼くなり\n好きにしやがれ！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(8)
	end
	event.Finish()
	event.SetQuestEtc(1, 15, 1)
end

--- Helper function.
local function helper_2d670(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2d8a8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2c5cc(arg0, arg1)
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
		helper_2c5cc(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_2c75c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2ce18(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2d670(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2db8c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2dcec(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "私も魚については、\nいささか自信があります。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"聞く所によると、人間は\n魚に競争をさせて\nいるとかいないとか。<page>あなたも魚を飼って\nいるのなら、それで\n一番になってみなさい。<page>そうすれば、\n私もあなたを認め、\n力になりましょう。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

--- Helper function.
local function helper_2e2d8(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "魚は飼い主に似ると言います。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "あんな弱っちい魚の飼い主と\n話す事なんて、ありません。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

--- Helper function.
local function helper_2e7cc(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_2ea04(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2db8c(arg0, arg1)
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
		helper_2db8c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_2dcec(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2e2d8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_2e7cc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_2ed48(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "最近、身体の\n調子が悪いの。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"ダック先生に診て頂いたけど、\n身体には何の問題もないって。<page>なぜかしら？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_2efe8(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg1, arg0, 0)
			end
			return
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg1, arg0, 0)
		end
		if at <= 9 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"最近、身体の調子が悪いの。<page>旅なんてとてもじゃないけど\n無理だわ。<page>ダック先生に看て頂いたけど、\n何の問題もないって。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"でも、普通に\n立っているだけでも\n倒れそうになるの。<page>なんて言うのかな、\n世界がゆがんでしまった\nような感じがするのよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
		helper_3dd465f9(0, -1, arg1, arg0, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return
	end
	event.MesMake_2(0, "この症状には\n覚えがあるわ。")
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"私の生まれた時代では、世界がかなり\n崩壊していて、空間のゆがみも、こことは\n比べ物にならないくらいだったの。"
	)
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.MesMake_2(
		0,
		"そんな世界だったから、特に\n身体の弱い人や神経の細やかな\n人ほど影響をうけていたのね。<page>軽い人はめまいや立ちくらみ、\n重い人だと立っていられなく\nなるくらい。"
	)
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(
		0,
		"ミーナさんは、特に\nその影響をうけやすい\n体質なのかも。<page>この程度の空間の\nゆがみでも、体調を\n崩すくらいだから。"
	)
	helper_3dd465f9(0, -1, arg1, arg0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.MesMake_2(
		0,
		"せめて近い場所のゆがみだけでも\n減らせれば、少しは楽にして\nあげられるかも知れないわね。"
	)
	helper_3dd465f9(0, -1, arg1, arg0, 0)
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
	helper_eb838ef8(0, -1, 8, 0, 0)
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
local function helper_2fbd4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "まだ体調はすぐれないわ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"もしかして、\n悪い病気なんじゃ\nないかしら？<page>ダック先生がああ言う\nのも、もう手おくれ\nだからなのかも・・・"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "こんにちは。<page>身体の調子？\n快調よ！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"最近、うそみたいに\n楽になったわ。<page>なんていうか、世界が\nしっかりしてる感じ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そう言えば、何か\n頼み事があったのよね。<page>私に出来る事なら\n協力するわ。<page>助けてもらったんだもの。\n助けてあげなきゃね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

--- Helper function.
local function helper_30334(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3057c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2ed48(arg0, arg1)
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
		helper_2ed48(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_2efe8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_2fbd4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_30334(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_30848(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c8e2192(arg0, 0, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.MesMake_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_30bc0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 4 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				var3 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 6 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 7 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 9 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 10 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 11 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 12 then
			helper_ff0edc1d(30)
		end
		if at <= 13 then
			helper_ff0edc1d(30)
		end
		if at <= 14 then
			helper_ff0edc1d(60)
		end
		if at <= 15 then
			helper_eb838ef8(0, -1, 8, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.MesMake_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"子供だから役に立たないと\n思ってるでしょう？<page>実はね、私って幸運を呼ぶ\nラッキーガールなのよ。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"お出かけの日に雨だったことないし、\nくじの外れ券なんて見た事ないわ。<page>どうよ？"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "わかったよ\nおことわり")
	var3 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "会話")
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var3 ~= 0 then
		event.MesMake_2(0, "なによ、いじわる！\nけちんぼ！")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "おたんこなす！<page>とうへんぼく！<page>ぼくねんじん！")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.MesMake_2(
		0,
		"でもさ、他の人はたのまれてるのに、\nあたしだけ自分からたのむのって\nしゃくだわ。<page>あくまで、たのまれて\n協力してるってことにしないと、\nわたしの女がすたる。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.MesMake_2(0, "そうね、あたしを見つけたら\n仲間になってあげるってのは\nどう？")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(11)
	end
	event.MesMake_2(0, "ようするに「かくれんぼ」よ。<page>じゃあ、スタート！")
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMotion(arg0, "立ち")
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetAi(1, arg0)
	event.CharaActive(0, arg0)
	event.DeleteVillager(arg0)
	event.SetFadeIn(30)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]しかたありませんね・・・\n   コリンを探しに行きましょう。\n   パームブリンクスのどこかに\n   かくれているはずです。"
	)
	helper_eb838ef8(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 18, 1)
	event.SetCnt(11, 0)
end

--- Helper function.
local function helper_31c60(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_ff0edc1d(30)
			end
			return
		end
		if at <= 4 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(11) or var2
	if var2 < 1 then
		event.MesMake_2(0, "あはっ、見つかっちゃった！<page>じゃ、次はどうかしら？")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(11, var2 + 1)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
	event.SetQuestEtc(1, 18, 1)
end

--- Helper function.
local function helper_321d8(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_32410(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_30848(arg0, arg1)
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
		helper_30848(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_30bc0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_31c60(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_321d8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_326f4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_32884(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3dd465f9(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			helper_10160()
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"なんだって？<page>すまないけど、もっとゆっくり\n話してもらえんかね。"
	)
	helper_3dd465f9(0, -1, arg0, arg1, 0)
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
		helper_3dd465f9(0, -1, arg0, arg1, 0)
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
	helper_3dd465f9(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMotion(arg0, "立ち")
	helper_10160()
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
	event.SetQuestEtc(1, 19, 1)
end

--- Helper function.
local function helper_32f58(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_32884(arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_32fe4(arg0: s32, arg1: any)
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
	helper_f96a9d1b(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_3321c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_326f4(arg0, arg1)
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
		helper_326f4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_32884(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_32f58(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_32fe4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

--- Helper function.
local function helper_21618(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 3 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 4 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 7 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 8 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
		if at <= 9 then
			helper_3dd465f9(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_3c8e2192(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "ああ、ポリーの\nお手伝いかい？<page>ごくろうさん。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"ん、パンを２０個も\nどうするかって？<page>今日は「チーズフォンデュ」\nパーティーなんだ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(
			0,
			"ユリスお得意の「発明」で言うなら、\nチーズとパンとワインで発明された\n料理のことさ。<page>うまいんだぜ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(
			0,
			"みんな、たくさん食べるから、\nこれだけパンがいるんだ。<page>でも、今パンを渡されても\n困るな。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.MesMake_2(
			0,
			"ユリス、悪いんだが、\nそのパンを家まで\n持っていってくれないか。<page>家は知ってるよな、\nカボチャ畑が目印だ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "家は知ってるよな、\nカボチャ畑が目印だ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 2 then
		event.MesMake_2(0, "中止だって！？\nそいつは残念だな。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.MesMake_2(
			0,
			"じゃ、ユリス、\nパンはいらないから、\nポリーに返して来てくれ。"
		)
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "悪いな。パンはポリーに\n返して来てくれ。")
		helper_3dd465f9(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(10)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_33500(arg0: s32, arg1: s32)
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
				helper_16cf8(arg0, arg1)
			end
			if at <= 2 then
				helper_dc4c()
			end
			if at <= 3 then
				helper_187d0(arg0, arg1)
			end
			if at <= 4 then
				helper_1a128(arg0, arg1)
			end
			if at <= 5 then
				helper_1bbc0(arg0, arg1)
			end
			if at <= 6 then
				helper_1e698(arg0, arg1)
			end
			if at <= 7 then
				helper_20da0(arg0, arg1)
			end
			if at <= 8 then
				var9 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 10 then
			return
		end
		if at <= 14 then
			if at <= 11 then
				helper_23318(arg0, arg1)
			end
			if at <= 12 then
				helper_14960(arg0, arg1)
			end
			if at <= 13 then
				var12 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 15 then
			return
		end
		if at <= 20 then
			if at <= 16 then
				helper_24bf4(arg0, arg1)
			end
			if at <= 17 then
				helper_26224(arg0, arg1)
			end
			if at <= 18 then
				helper_29518(arg0, arg1)
			end
			if at <= 19 then
				var15 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 21 then
			return
		end
		if at <= 30 then
			if at <= 22 then
				helper_2b0d4(arg0, arg1)
			end
			if at <= 23 then
				helper_2c2e8(arg0, arg1)
			end
			if at <= 24 then
				helper_2d8a8(arg0, arg1)
			end
			if at <= 25 then
				helper_2ea04(arg0, arg1)
			end
			if at <= 26 then
				helper_3057c(arg0, arg1)
			end
			if at <= 27 then
				helper_32410(arg0, arg1)
			end
			if at <= 28 then
				helper_3321c(arg0, arg1)
			end
			if at <= 29 then
				var18 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			end
			return
		end
		if at <= 31 then
			return
		end
		if at <= 32 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
		if at <= 33 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
		if at <= 34 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
		if at <= 35 then
			helper_f96a9d1b(arg0, -1, 0, 0)
		end
		if at <= 36 then
			helper_f96a9d1b(arg0, -1, 0, 0)
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
		helper_1251c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 5 then
		helper_16cf8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var3 == 4 then
		flag = event.GetFlag(104) or flag
		if flag == 0 then
			helper_dc4c()
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_187d0(arg0, arg1)
			if vm.skipping() then
				return skip(4)
			end
		end
	end
	if var3 == 7 then
		helper_1a128(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var3 == 8 then
		helper_1bbc0(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var3 == 10 then
		helper_1e698(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var3 == 11 then
		helper_20da0(arg0, arg1)
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
			var9 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(9)
			end
			if var9 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var9 == 1 then
				helper_23318(arg0, arg1)
				if vm.skipping() then
					return skip(10)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_dc4c()
			if vm.skipping() then
				return skip(11)
			end
		else
			helper_23318(arg0, arg1)
			if vm.skipping() then
				return skip(12)
			end
		end
	end
	if var3 == 14 then
		helper_14960(arg0, arg1)
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
			var12 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(14)
			end
			if var12 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var12 == 1 then
				helper_24bf4(arg0, arg1)
				if vm.skipping() then
					return skip(15)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_dc4c()
			if vm.skipping() then
				return skip(16)
			end
		else
			helper_24bf4(arg0, arg1)
			if vm.skipping() then
				return skip(17)
			end
		end
	end
	if var3 == 16 then
		helper_26224(arg0, arg1)
		if vm.skipping() then
			return skip(18)
		end
	end
	if var3 == 17 then
		helper_29518(arg0, arg1)
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
			var15 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(20)
			end
			if var15 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var15 == 1 then
				helper_2b0d4(arg0, arg1)
				if vm.skipping() then
					return skip(21)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_dc4c()
			if vm.skipping() then
				return skip(22)
			end
		else
			helper_2b0d4(arg0, arg1)
			if vm.skipping() then
				return skip(23)
			end
		end
	end
	if var3 == 19 then
		helper_2c2e8(arg0, arg1)
		if vm.skipping() then
			return skip(24)
		end
	end
	if var3 == 20 then
		helper_2d8a8(arg0, arg1)
		if vm.skipping() then
			return skip(25)
		end
	end
	if var3 == 21 then
		helper_2ea04(arg0, arg1)
		if vm.skipping() then
			return skip(26)
		end
	end
	if var3 == 23 then
		helper_3057c(arg0, arg1)
		if vm.skipping() then
			return skip(27)
		end
	end
	if var3 == 24 then
		helper_32410(arg0, arg1)
		if vm.skipping() then
			return skip(28)
		end
	end
	if var3 == 25 then
		helper_3321c(arg0, arg1)
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
			var18 = helper_8d58a537(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(30)
			end
			if var18 < 0 then
				event.SetAi(1, arg0)
				return
			end
			if var18 == 1 then
				helper_21618(arg0, arg1)
				if vm.skipping() then
					return skip(31)
				end
				event.SetAi(1, arg0)
				return
			end
		end
		helper_dc4c()
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
		helper_f96a9d1b(arg0, -1, 0, 0)
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
		helper_f96a9d1b(arg0, -1, 0, 0)
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
		helper_f96a9d1b(arg0, -1, 0, 0)
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
		helper_f96a9d1b(arg0, -1, 0, 0)
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
		helper_f96a9d1b(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(37)
		end
	end
	event.SetAi(1, arg0)
end

--- Helper function.
local function helper_ea44()
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
				helper_dc4c()
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
		helper_dc4c()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "おい、この先は\n立ち入り禁止だ。")
		helper_f96a9d1b(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(109) or flag
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
			helper_f96a9d1b(var1, -1, 0, 0)
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
			helper_f96a9d1b(var1, -1, 0, 0)
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
			helper_f96a9d1b(var1, -1, 0, 0)
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
			helper_f96a9d1b(var1, -1, 0, 0)
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
			helper_f96a9d1b(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_f96a9d1b(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_1002c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ea44()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_ea44()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_358b0()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1002c()
		end
	end
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	player_chara = event.GetControlChrid() or player_chara
	if var0 <= 34 then
		helper_33500(var1, player_chara)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_1002c()
		if vm.skipping() then
			return skip(2)
		end
	end
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
	helper_390ac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3cbb4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15f8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_390ac()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoDng(0, -1, 1000)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3cbb4()
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
	helper_358b0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11091.
script[11091] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_390ac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11092.
script[11092] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.CharaActive(0, 8)
	helper_3cbb4()
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
