--!strict
-- map/i/i01/h01/i01h01b_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_04a254d6 = require("@lib/event/helper_04a254d6")
local helper_10d80545 = require("@lib/event/helper_10d80545")
local helper_1844fc9c = require("@lib/event/helper_1844fc9c")
local helper_470f8a56 = require("@lib/event/helper_470f8a56")
local helper_54be73eb = require("@lib/event/helper_54be73eb")
local helper_59d5ef90 = require("@lib/event/helper_59d5ef90")
local helper_6ad81763 = require("@lib/event/helper_6ad81763")
local helper_6c89029a = require("@lib/event/helper_6c89029a")
local helper_6f3f5f84 = require("@lib/event/helper_6f3f5f84")
local helper_7377ea1d = require("@lib/event/helper_7377ea1d")
local helper_854d8da2 = require("@lib/event/helper_854d8da2")
local helper_93d5f4e9 = require("@lib/event/helper_93d5f4e9")
local helper_9d79a7c9 = require("@lib/event/helper_9d79a7c9")
local helper_a1c34b66 = require("@lib/event/helper_a1c34b66")
local helper_a348cd1a = require("@lib/event/helper_a348cd1a")
local helper_d1092507 = require("@lib/event/helper_d1092507")
local helper_e84a97e1 = require("@lib/event/helper_e84a97e1")
local helper_e85df3b0 = require("@lib/event/helper_e85df3b0")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_11100(arg0: any)
	local projection: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10d80545()
		end
		if at <= 2 then
			helper_10d80545()
		end
		if at <= 3 then
			helper_a1c34b66(0)
		end
		if at <= 4 then
			helper_a1c34b66(0)
		end
		if at <= 5 then
			helper_efffcfbb(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-13.56, 50.69, -99.84)
	event.CmrsSetRef(47.32, 59.3, -184.47)
	projection = event.GetProjection() or projection
	event.SetProjection(471.9)
	event.ObjsSetPos(0, -17.08, -0.02, -207.87)
	event.ObjsSetRot(0, 0.0, 1.62, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, 34.05, -0.02, -143.69)
	event.ObjsSetRot(1, 0.0, 2.73, 0.0)
	event.ObjsSetMotion(1, "上を見るL", 4)
	event.CmrsFadeInit()
	event.CmrsFadeIn(50, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsMove2(-13.56, 18.54, -99.84, 47.32, 27.15, -184.47, 90, 2, 0.4)
	helper_10d80545()
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "歩き", 0)
	event.ObjsMove(0, 8.7, -0.02, -189.32, 45)
	event.ObjsRotation(0, 0.0, 0.3, 0.0, 45)
	event.ObjsMove(0, 16.96, -0.02, -159.01, 45)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsRotation(0, 0.0, 1.74, 0.0, 10)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetProjection(projection)
end

--- Helper function.
local function helper_1183c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_efffcfbb(9)
		end
		if at <= 3 then
			helper_93d5f4e9(1050010)
		end
		if at <= 4 then
			helper_93d5f4e9(1050020)
		end
		if at <= 5 then
			helper_a1c34b66(0)
		end
		if at <= 6 then
			helper_efffcfbb(9)
		end
		if at <= 7 then
			helper_93d5f4e9(1050030)
		end
		if at <= 8 then
			helper_93d5f4e9(1050040)
		end
		if at <= 9 then
			helper_93d5f4e9(1050050)
		end
		if at <= 10 then
			helper_efffcfbb(24)
		end
		if at <= 11 then
			helper_93d5f4e9(1050060)
		end
		if at <= 12 then
			helper_a348cd1a(1050065, 15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(113.96, 46.95, -138.53)
	event.CmrsSetRef(50.9, 27.15, -165.35)
	event.ObjsSetRot(0, 0.0, 2.34, 0.0)
	event.ObjsSetMotion(0, "スティーブ見L", 4)
	event.ObjsSetMotion(1, "腕組み", 4)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "左を見る", 2)
	event.ObjsNextMotion(1, "左を見るL")
	helper_efffcfbb(9)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050010)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "うなづく（スティーブ）", 2)
	event.ObjsNextMotion(0, "スティーブ見L")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(1050020)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "右を見る", 2)
	event.ObjsNextMotion(0, "右を見るL")
	helper_efffcfbb(9)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(1050030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050040)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050050)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "アトラミリアをさわる", 6)
	event.ObjsNextMotion(0, "アトラミリアをさわるL")
	helper_efffcfbb(24)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(arg0, 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(1050060)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_a348cd1a(1050065, 15)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_12074(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(9)
		end
		if at <= 2 then
			helper_93d5f4e9(1050070)
		end
		if at <= 3 then
			helper_93d5f4e9(1050071)
		end
		if at <= 4 then
			helper_93d5f4e9(1050080)
		end
		if at <= 5 then
			helper_93d5f4e9(1050090)
		end
		if at <= 6 then
			helper_93d5f4e9(1050100)
		end
		if at <= 7 then
			helper_a1c34b66(0)
		end
		if at <= 8 then
			helper_93d5f4e9(1050110)
		end
		if at <= 9 then
			helper_a1c34b66(1)
		end
		if at <= 10 then
			helper_93d5f4e9(1050120)
		end
		if at <= 11 then
			helper_a1c34b66(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-17.27, 17.65, -125.13)
	event.CmrsSetRef(49.66, 25.36, -167.46)
	event.ObjsSetPos(0, 16.96, -0.02, -159.01)
	event.ObjsSetRot(0, 0.0, 1.62, 0.0)
	event.ObjsSetMotion(0, "スティーブ見L", 4)
	event.ObjsSetPos(1, 29.23, -0.02, -141.02)
	event.ObjsSetRot(1, 0.0, 2.13, 0.0)
	event.ObjsSetMotion(1, "腕組み", 4)
	helper_efffcfbb(9)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050070)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050071)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(1050080)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050090)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右を見る", 6)
	event.ObjsNextMotion(0, "右を見るL")
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(1050100)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "左を見る", 2)
	event.ObjsNextMotion(1, "左を見るL")
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050110)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "右を見る会話", 6)
	event.ObjsNextMotion(0, "右を見るL")
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(1050120)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(12)
	end
end

--- Helper function.
local function helper_128dc(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_93d5f4e9(1050130)
		end
		if at <= 2 then
			helper_efffcfbb(50)
		end
		if at <= 3 then
			helper_93d5f4e9(1050140)
		end
		if at <= 4 then
			helper_93d5f4e9(1050150)
		end
		if at <= 5 then
			helper_a1c34b66(0)
		end
		if at <= 6 then
			helper_93d5f4e9(1050160)
		end
		if at <= 7 then
			helper_a1c34b66(1)
		end
		if at <= 8 then
			helper_93d5f4e9(1050170)
		end
		if at <= 9 then
			helper_a1c34b66(0)
		end
		if at <= 10 then
			helper_93d5f4e9(1050180)
		end
		if at <= 11 then
			helper_10d80545()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-18.7, 18.74, -162.67)
	event.CmrsSetRef(41.67, 24.32, -147.28)
	event.ObjsSetRot(0, 0.0, 0.9, 0.0)
	event.ObjsSetMotion(0, "スターブル見L", 4)
	event.ObjsSetRot(1, 0.0, -2.23, 0.0)
	event.ObjsSetMotion(1, "腰に手L", 4)
	helper_93d5f4e9(1050130)
	if vm.skipping() then
		return skip(2)
	end
	helper_efffcfbb(50)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "腰に手会話", 6)
	event.ObjsNextMotion(1, "腰に手L", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050140)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 3)
	event.ObjsSetMotion(0, "ガッツポーズ", 6)
	event.ObjsNextMotion(0, "スターブル見L")
	event.ObjsMotionDelay(1, 18)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "腰に手L")
	helper_93d5f4e9(1050150)
	if vm.skipping() then
		return skip(5)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "腰に手会話", 6)
	event.ObjsNextMotion(1, "腰に手L", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050160)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSePlay(arg0, 4)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "スターブル見L")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(1050170)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050180)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.CmrsFadeInit()
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(12)
	end
end

--- Helper function.
local function helper_101ec(arg0: s32, arg1: f32, arg2: f32, arg3: any)
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
local function helper_1053c(arg0: s32)
	local check_motion_end: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if vm.wait() then
			return skip(2)
		end
		check_motion_end = event.CheckMotionEnd(arg0) or check_motion_end
		if check_motion_end ~= 0 then
			break
		end
	end
end

--- Helper function.
local function helper_131d4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10d80545()
		end
		if at <= 2 then
			helper_efffcfbb(10)
		end
		if at <= 3 then
			helper_93d5f4e9(1050190)
		end
		if at <= 4 then
			helper_93d5f4e9(1050200)
		end
		if at <= 5 then
			helper_efffcfbb(10)
		end
		if at <= 6 then
			helper_93d5f4e9(1050210)
		end
		if at <= 7 then
			helper_93d5f4e9(1050211)
		end
		if at <= 8 then
			helper_93d5f4e9(1050212)
		end
		if at <= 9 then
			helper_93d5f4e9(1050213)
		end
		if at <= 10 then
			helper_10d80545()
		end
		if at <= 11 then
			helper_101ec(32, vm.f32(0.206), -1.0, 20)
		end
		if at <= 12 then
			helper_101ec(32, vm.f32(0.956), -1.0, 20)
		end
		if at <= 13 then
			helper_1053c(32)
		end
		if at <= 14 then
			helper_93d5f4e9(1050220)
		end
		if at <= 15 then
			helper_93d5f4e9(1050230)
		end
		if at <= 16 then
			helper_93d5f4e9(1050240)
		end
		if at <= 17 then
			helper_93d5f4e9(1050241)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-23.06, 16.81, -167.38)
	event.CmrsSetRef(22.88, 29.55, -159.05)
	event.ObjsSetRot(1, 0.0, -2.35, 0.0)
	event.CharaActive(0, 0)
	event.CmrsFadeInit()
	event.CmrsFadeIn(50, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(3, 128.0, 128.0, 128.0, 128.0, 10)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050190)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050200)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(4, 128.0, 128.0, 128.0, 128.0, 30)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050210)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050211)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050212)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050213)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(1, 0)
	event.CmrsMove(-2.41, 23.65, -165.23, 57.71, 27.49, -130.12, 28)
	helper_10d80545()
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "カメラを出す", 6)
	event.ObjsNextMotion(1, "カメラを出すL")
	helper_101ec(32, vm.f32(0.206), -1.0, 20)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(arg0, 5)
	event.CharaActive(1, 33)
	event.SetReference(32, "camera_sta", 33)
	helper_101ec(32, vm.f32(0.956), -1.0, 20)
	if vm.skipping() then
		return skip(13)
	end
	helper_1053c(32)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(arg0, 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050220)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050230)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050240)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050241)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_13d2c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_04a254d6(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_04a254d6(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			helper_d1092507(355, 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(38.3, 34.99, -138.13)
	event.CmrsSetRef(16.02, 28.99, -153.84)
	event.CharaActive(1, 0)
	event.ObjsSetMotion(0, "カメラゲット", 4)
	event.EohSetShow(1, 0)
	event.ObjsSetRot(1, 0.0, -2.23, 0.0)
	event.DelReference(33)
	event.SetReference(0, "ef00", 33)
	event.SndPauseBgm()
	event.SndSePlay(arg1, 0)
	event.SndSePlay(arg0, 7)
	event.ObjsSetPos(2, -10.42, 26.48, -171.78)
	event.ObjsSetRot(2, 0.0, 1.02, 0.0)
	event.ObjsSetMotion(2, "発動", 6)
	event.EohSetShow(2, 1)
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]Ya tienes la C[UNI00e1]mara.\n Equ[UNI00ed]pala mediante el men[UNI00fa] Objetos.\n [UNI00da]sala pulsando el bot[UNI00f3]n (#)."
	)
	helper_04a254d6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"[(!)]Cuando est[UNI00e9]s en una Mazmorra, s[UNI00f3]lo podr[UNI00e1]s\nusar la C[UNI00e1]mara si est[UNI00e1]\nequipada como Objeto activo."
	)
	helper_04a254d6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesWindowMode(0, 7)
	helper_d1092507(355, 1)
	if vm.skipping() then
		return skip(4)
	end
	event.PlayBgm(0)
end

--- Helper function.
local function helper_14410(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_93d5f4e9(1050250)
		end
		if at <= 2 then
			helper_93d5f4e9(1050260)
		end
		if at <= 3 then
			helper_93d5f4e9(1050261)
		end
		if at <= 4 then
			helper_a1c34b66(1)
		end
		if at <= 5 then
			helper_a1c34b66(1)
		end
		if at <= 6 then
			helper_efffcfbb(10)
		end
		if at <= 7 then
			helper_a1c34b66(0)
		end
		if at <= 8 then
			helper_efffcfbb(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DelReference(33)
	event.CharaActive(0, 33)
	event.CmrsSetPos(-33.79, 30.18, -157.21)
	event.CmrsSetRef(24.92, 17.88, -150.76)
	event.ObjsSetMotion(0, "スターブル見L", 4)
	event.EohSetShow(1, 1)
	event.EohSetShow(2, 0)
	event.ObjsSetMotion(1, "会話2", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050250)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050260)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話2", 2)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050261)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(6)
	end
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsMotionWait(0)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_14a00()
	local var0: s32 = 0
	local var1: s32 = 0
	local projection: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_11100(var0)
			end
			if at <= 2 then
				helper_1183c(var0)
			end
			if at <= 3 then
				helper_12074(var0)
			end
			if at <= 4 then
				helper_128dc(var0)
			end
			if at <= 5 then
				helper_131d4(var0)
			end
			if at <= 6 then
				helper_13d2c(var0, var1)
			end
			if at <= 7 then
				helper_14410(var0)
			end
			if at <= 8 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
		if at <= 10 then
			helper_efffcfbb(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DelImg(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SetFlag(56, 0)
		event.StopBgm(0)
		helper_efffcfbb(4)
		if vm.skipping() then
			return skip(11)
		end
		event.LoadBgm(46)
		event.PlayBgm(0)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.SetProjection(projection)
		event.EohSetFootSoundId(0, 0)
		event.SetFadeIn(30)
	end
	event.SetFlag(105, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(1222)
	var0 = event.SndLoadSound(1222) or var0
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	event.LoadChara(4, "event/e100/e105/e105_steve.gltf", "info", 25)
	event.CharaActive(1, 25)
	event.SetCharaPos(25, 62.85, 11.43, -176.07)
	event.SetCharaRot(25, 0.0, -0.72, 0.0)
	event.AssignStack(5)
	event.ClearStack(5)
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
	projection = event.GetProjection() or projection
	event.CmrsInit()
	event.CmrsSetPos(-13.56, 50.69, -99.84)
	event.CmrsSetRef(47.32, 59.3, -184.47)
	event.LoadMotion(5, "event/e100/e105/e105_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "event/e100/e105/e105_starbre.gltf", "info", 32)
	event.CharaActive(0, 24)
	event.CharaActive(1, 32)
	event.EohSyncChara(1, 32)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadItem(5, 369, "info", 33)
	event.CharaActive(0, 33)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 34)
	event.CharaActive(1, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSetShow(2, 0)
	block = event.LoadImg_4(5, "textures/event/e100/e105/e105a_2d.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e105a_2d01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e105a_2d02", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(4, 1)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.SetTime(7)
	event.LoadMes(0, 5, "event/e100/e105/e105a_1.txt")
	event.StopBgm(0)
	helper_efffcfbb(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(193)
	event.PlayBgm(0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.InitDramaScene()
	helper_11100(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_1183c(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_12074(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_128dc(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_131d4(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_13d2c(var0, var1)
	if vm.skipping() then
		return skip(7)
	end
	helper_14410(var0)
	if vm.skipping() then
		return skip(8)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_10640(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: f32)
	local var5: s32 = 0
	local get_now_frame_wait: f32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	local loud: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var5 = 0
			var10 = 0
			loud = 0
			argc_2 = argc
			var5 = 2
			var11 = loud
			local t1: s32
			t1, var5 = helper_59d5ef90(arg0, var5)
			var9 = t1
			var10 = var10 + 1
		end
		var10 = vm.i32(var10 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var5 = 0
	var10 = 0
	argc_2 = event.StreamGetStatus(1) or argc_2
	loud = 0
	while true do
		get_now_frame_wait = event.GetMotNowWait(arg1) or get_now_frame_wait
		if get_now_frame_wait < vm.f32(arg4 + vm.f32(0.01)) and get_now_frame_wait > vm.f32(arg4 - vm.f32(0.01)) then
			event.SndSePlay(arg2, arg3)
		end
		argc_2 = argc
		argc = event.StreamGetStatus(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.TrgPakuMotion(2)
			var5 = 2
		end
		var11 = loud
		loud = event.StreamSilentCheck(1) or loud
		if var11 == 0 and loud == 1 then
			event.TrgPakuAnim(1)
		end
		if var11 == 1 and loud == 0 then
			event.TrgPakuAnim(0)
		end
		local t0: s32
		t0, var5 = helper_59d5ef90(arg0, var5)
		var9 = t0
		if var9 ~= 0 then
			var10 = vm.i32(var10 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var10 = vm.i32(var10 + 1)
		end
	end
	if var5 == 0 then
		event.TrgPakuMotion(2)
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
end

--- Helper function.
local function helper_10db0(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: f32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_e85df3b0(0, -1, 8, 0, 0)
			helper_10640(0, arg1, arg2, arg3, arg4)
		end
		helper_854d8da2(0)
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
	event.MesMake_2(0, arg0)
	helper_e85df3b0(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_10640(0, arg1, arg2, arg3, arg4)
	if vm.skipping() then
		return skip(4)
	end
	helper_854d8da2(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_16068(arg0: f32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_10d80545()
		end
		if at <= 3 then
			helper_efffcfbb(10)
		end
		if at <= 4 then
			helper_93d5f4e9(1050290)
		end
		if at <= 5 then
			helper_efffcfbb(30)
		end
		if at <= 6 then
			helper_93d5f4e9(1050291)
		end
		if at <= 7 then
			helper_a1c34b66(1)
		end
		if at <= 8 then
			helper_efffcfbb(16)
		end
		if at <= 9 then
			helper_93d5f4e9(1050300)
		end
		if at <= 10 then
			helper_efffcfbb(28)
		end
		if at <= 11 then
			helper_10db0(1050310, 32, arg1, 4, vm.f32(0.15))
		end
		if at <= 12 then
			helper_10db0(1050320, 32, arg1, 4, vm.f32(0.15))
		end
		if at <= 13 then
			helper_10db0(1050321, 32, arg1, 4, vm.f32(0.15))
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetProjection(arg0)
	event.CmrsSetPos(-15.15, 22.51, -151.72)
	event.CmrsSetRef(32.49, 27.39, -162.95)
	event.CharaActive(0, 0)
	event.ObjsSetPos(1, 38.77, -0.02, -147.68)
	event.ObjsSetRot(1, 0.0, -2.04, 0.0)
	event.ObjsSetMotion(1, "手に腰L", 4)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(1, 1, "目とじ")
	event.ObjsSetMotion(1, "下を見る", 2)
	event.ObjsNextMotion(1, "下を見るL")
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050290)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, 25)
	event.SetCrossfade(0, 0, 30)
	event.SpriteSetDraw(0, 2)
	event.ObjsSetColor(2, 128.0, 128.0, 128.0, 128.0, 0)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050291)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(8)
	end
	event.SetCrossfade(30)
	event.ObjsSetColor(2, 0.0, 0.0, 0.0, 0.0, 30)
	event.SpriteSetDraw(1, 2)
	event.ObjsSetColor(3, 128.0, 128.0, 128.0, 128.0, 30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "目パチ")
	event.SndSePlay(arg1, 2)
	event.ObjsSetMotion(1, "上を見る", 2)
	event.ObjsNextMotion(1, "上を見るL")
	helper_efffcfbb(16)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050300)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.SetCrossfade(30)
	event.ObjsSetColor(3, 0.0, 0.0, 0.0, 30)
	event.SpriteSetDraw(2, 2)
	event.ObjsSetColor(4, 128.0, 128.0, 128.0, 128.0, 30)
	event.ObjsSetColor(3, 0.0, 0.0, 0.0, 0.0, 30)
	event.SndSePlay(arg1, 3)
	event.ObjsSetMotion(1, "頭をかく", 2)
	event.ObjsNextMotion(1, "頭をかくL")
	helper_efffcfbb(28)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_10db0(1050310, 32, arg1, 4, vm.f32(0.15))
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_10db0(1050320, 32, arg1, 4, vm.f32(0.15))
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_10db0(1050321, 32, arg1, 4, vm.f32(0.15))
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, 32)
	event.SetCrossfade(30)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
end

--- Helper function.
local function helper_16e78(arg0: any, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_93d5f4e9(1050330)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-38.62, 34.71, -174.94)
	event.CmrsSetRef(37.54, 15.45, -157.32)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, 16.25, -0.02, -166.37)
	event.ObjsSetRot(0, 0.0, 1.16, 0.0)
	event.ObjsSetMotion(0, "スターブル見L", 4)
	event.CharaActive(1, 32)
	event.ObjsSetMotion(1, "腰に手L", 4)
	event.CharaActive(1, 25)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(1050330)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_171e0()
	local var0: s32 = 0
	local projection: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_16068(projection, var0)
			end
			if at <= 2 then
				helper_16e78(projection, var0)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
		if at <= 4 then
			helper_efffcfbb(30)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_efffcfbb(30)
		if vm.skipping() then
			return skip(5)
		end
		event.CharaActive(1, 0)
		event.CharaActive(1, 25)
		event.SetProjection(projection)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.DelImg(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(105, 1)
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(4, 1225) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	projection = event.GetProjection() or projection
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
	event.LoadMotion(5, "event/e100/e105/e105_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 72.86, 57.47, 35.39)
	event.LoadChara(5, "event/e100/e105/e105_starbre.gltf", "info", 32)
	event.CharaActive(1, 32)
	event.EohSyncChara(1, 32)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 67.74, -59.99, 63.26)
	event.ObjsSetRot(1, 0.0, 3.04, 0.0)
	block = event.LoadImg_4(5, "textures/event/e100/e105/e105b_2d.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e105b_2d01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetAlphab(0, 0)
	event.EohSyncSprite(2, 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e105b_2d02", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetAlphab(1, 0)
	event.EohSyncSprite(3, 1)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e105b_2d03", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetDraw(2, 0)
	event.SpriteSetAlphab(2, 0)
	event.EohSyncSprite(4, 2)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadMes(0, 5, "event/e100/e105/e105b_1.txt")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_16068(projection, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_16e78(projection, var0)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_184b0(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(20)
		end
		if at <= 2 then
			helper_10d80545()
		end
		if at <= 3 then
			helper_efffcfbb(15)
		end
		if at <= 4 then
			helper_93d5f4e9(1050340)
		end
		if at <= 5 then
			helper_93d5f4e9(1050341)
		end
		if at <= 6 then
			helper_93d5f4e9(1050350)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-33.29, 24.37, -167.32)
	event.CmrsSetRef(40.27, 15.44, -159.28)
	event.ObjsSetPos(0, 18.58, -1.12, -168.14)
	event.ObjsSetRot(0, 0.0, 0.92, 0.0)
	event.ObjsSetMotion(0, "スターブル見L", 4, -1.0, 1)
	event.ObjsSetPos(1, 38.77, -0.02, -147.68)
	event.ObjsSetRot(1, 0.0, -2.16, 0.0)
	helper_efffcfbb(20)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(3)
	end
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話2", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050340)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050341)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050350)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_18a38(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_10d80545()
		end
		if at <= 3 then
			helper_93d5f4e9(1050360)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(50.99, 20.54, -99.77)
	event.CmrsSetRef(50.2, 23.69, -140.94)
	event.ObjsSetPos(0, 59.55, -1.12, -135.97)
	event.ObjsSetRot(0, 0.0, -2.24, 0.0)
	event.ObjsSetMotion(0, "スターブル見L", 4, -1.0, 1)
	event.ObjsSetPos(1, 38.77, -0.02, -147.68)
	event.ObjsSetRot(1, 0.0, 0.72, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(2, 62.85, 11.43, -176.07)
	event.ObjsSetRot(2, 0.0, -0.72, 0.0)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "ガッツポーズ", 2)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050360)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_18f90(arg0: any)
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10d80545()
		end
		if at <= 2 then
			helper_efffcfbb(30)
		end
		if at <= 3 then
			helper_10d80545()
		end
		if at <= 4 then
			helper_efffcfbb(30)
		end
		if at <= 5 then
			helper_93d5f4e9(1050370)
		end
		if at <= 6 then
			helper_93d5f4e9(1050371)
		end
		if at <= 7 then
			helper_93d5f4e9(1050380)
		end
		if at <= 8 then
			helper_93d5f4e9(1050390)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInit()
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(91.52, 19.06, -115.56)
	event.CmrsSetRef(36.75, 33.39, -130.18)
	event.CharaActive(0, 0)
	event.ObjsSetMotion(1, "腰に手L", 4)
	block = event.LoadImg_4(5, "textures/event/e100/e105/e105c_2d.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e105c_2d01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(4)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 10)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "腰に手会話", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050370)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050371)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050380)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050390)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 0)
	event.DelImg(0)
end

--- Helper function.
local function helper_1986c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(15)
		end
		if at <= 2 then
			helper_efffcfbb(14)
		end
		if at <= 3 then
			helper_93d5f4e9(1050400)
		end
		if at <= 4 then
			helper_efffcfbb(60)
		end
		if at <= 5 then
			helper_04a254d6(0, -1, 8, 0, 0)
		end
		if at <= 6 then
			helper_a1c34b66(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(16.09, 22.59, -109.83)
	event.CmrsSetRef(50.2, 23.69, -140.94)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, 55.27, -1.12, -130.46)
	event.ObjsSetRot(0, 0.0, -2.24, 0.0)
	event.ObjsSetMotion(0, "スターブル見L", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4)
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 3)
	event.ObjsSetMotion(1, "お金をやる", 6)
	event.ObjsNextMotion(1, "お金をやるL")
	helper_efffcfbb(14)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050400)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 4)
	event.ObjsSetMotion(0, "お金をもらう", 6)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "お金をもらうL")
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(0, "[UNI00a1]Has conseguido 400 Gildas!")
	helper_04a254d6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 7)
	event.ObjsSetMotion(1, "お金をやる戻り", 6)
	event.ObjsNextMotion(1, "立ち")
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_19f64()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_19fc0(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(30)
		end
		if at <= 2 then
			helper_10d80545()
		end
		if at <= 3 then
			helper_efffcfbb(10)
		end
		if at <= 4 then
			helper_93d5f4e9(1050420)
		end
		if at <= 5 then
			helper_93d5f4e9(1050421)
		end
		if at <= 6 then
			helper_93d5f4e9(1050430)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(35.49, 25.34, -101.59)
	event.CmrsSetRef(50.2, 23.69, -140.94)
	event.ObjsSetPos(0, 59.55, -1.12, -135.97)
	event.ObjsSetRot(0, 0.0, -2.0, 0.0)
	event.ObjsSetMotion(0, "スターブル見L", 4)
	event.ObjsSetPos(1, 38.77, -0.02, -147.68)
	event.ObjsSetRot(1, 0.0, 0.96, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(2, 62.85, 11.43, -176.07)
	event.ObjsSetRot(2, 0.0, -0.72, 0.0)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(3)
	end
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "ガッツポーズ", 6)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050420)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050421)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050430)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.ObjsResetMotion(1)
end

--- Helper function.
local function helper_1a63c(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a1c34b66(0)
		end
		if at <= 2 then
			helper_efffcfbb(15)
		end
		if at <= 3 then
			helper_93d5f4e9(1050440)
		end
		if at <= 4 then
			helper_93d5f4e9(1050450)
		end
		if at <= 5 then
			var1 = 0
		end
		if at <= 6 then
			var1 = var1 + 1
			helper_efffcfbb(70)
		end
		if at <= 7 then
			helper_efffcfbb(14)
		end
		if at <= 8 then
			helper_93d5f4e9(1050460)
		end
		if at <= 9 then
			helper_efffcfbb(10)
		end
		if at <= 10 then
			helper_93d5f4e9(1050470)
		end
		if at <= 11 then
			helper_efffcfbb(10)
		end
		if at <= 12 then
			helper_93d5f4e9(1050480)
		end
		if at <= 13 then
			helper_93d5f4e9(1050490)
		end
		if at <= 14 then
			helper_93d5f4e9(1050491)
		end
		if at <= 15 then
			helper_93d5f4e9(1050500)
		end
		if at <= 16 then
			helper_93d5f4e9(1050510)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-13.13, 19.21, -128.25)
	event.CmrsSetRef(60.53, 17.71, -147.9)
	event.ObjsSetPos(0, 77.34, -0.02, -128.37)
	event.ObjsSetRot(0, 0.0, -1.94, 0.0)
	event.ObjsSetMotion(0, "バックパック歩き", 4, -1.0, 1)
	event.ObjsSetPos(1, 24.24, -0.02, -152.65)
	event.ObjsSetRot(1, 0.0, 0.93, 0.0)
	event.ObjsSetPos(2, 62.85, 11.43, -176.07)
	event.ObjsSetRot(2, 0.0, -0.72, 0.0)
	event.SetReference(0, "ef00", 35)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 1.12, 0.0)
	event.CharaActive(0, 24)
	event.SetFadeIn(15)
	event.ObjsMove(0, 58.55, -0.02, -130.49, 35)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "バックパック持ち")
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(1050440)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "ガッツポーズ", 2)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050450)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "バックパックを置く", 2)
	event.ObjsNextMotion(0, "スターブル見L")
	var1 = 0
	while var1 < 84 do
		if var1 == 24 then
			event.SndSePlay(arg0, 5)
			event.DelReference(35)
			event.ObjsSetPos(4, 44.54, 6.47, -135.54)
		end
		if vm.wait() then
			return skip(6)
		end
		var1 = var1 + 1
	end
	event.ObjsTexAnime(0, 1, "ためいき")
	helper_efffcfbb(70)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(1, "腰に手", 2)
	event.ObjsNextMotion(1, "腰に手L")
	helper_efffcfbb(14)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050460)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "スターブル見L")
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(1050470)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050480)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050490)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050491)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 7)
	event.ObjsSetMotion(0, "ガッツポーズ", 6, -1.0, 1)
	event.ObjsNextMotion(0, "スターブル見L")
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(1050500)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "腰に手L")
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050510)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_1b810(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10d80545()
		end
		if at <= 2 then
			helper_efffcfbb(30)
		end
		if at <= 3 then
			helper_10d80545()
		end
		if at <= 4 then
			helper_efffcfbb(15)
		end
		if at <= 5 then
			helper_93d5f4e9(1050520)
		end
		if at <= 6 then
			helper_04a254d6(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(133.98, 56.46, -175.98)
	event.CmrsSetRef(64.38, 33.46, -162.4)
	event.ObjsSetPos(0, 50.4, -0.02, -124.87)
	event.ObjsSetRot(0, 0.0, -1.94, 0.0)
	event.ObjsSetMotion(0, "右を見るL")
	event.ObjsSetPos(1, 26.91, -0.02, -138.97)
	event.ObjsSetRot(1, 0.0, 0.93, 0.0)
	event.ObjsSetMotion(1, "左を見るL")
	event.SetCharaPos(25, 62.71, 11.43, -173.15)
	event.SetCharaRot(25, 0.0, -1.52, 0.0)
	event.CharaActive(1, 36)
	event.ObjsSetPos(4, 74.43, 34.16, -174.29)
	event.ObjsSetRot(4, 0.0, -1.64, 0.0)
	event.ObjsSetPos(5, 75.19, 35.28, -173.96)
	event.ObjsSetRot(5, 0.0, -1.52, 0.0)
	event.ObjsSetMotion(5, "発動", 6)
	event.EohSetShow(5, 1)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(arg1, 0)
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(4)
	end
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(arg0, 8)
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050520)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	var2 = event.GetMesWindowMode(0) or var2
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]Puedes usar el Ridepod eligi[UNI00e9]ndolo\n en el apartado Personaje del men[UNI00fa] Principal. Para\n abreviar, tambi[UNI00e9]n puedes pulsar el bot[UNI00f3]n (R3)."
	)
	helper_04a254d6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesWindowMode(0, var2)
end

--- Helper function.
local function helper_1c150(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(15)
		end
		if at <= 2 then
			helper_93d5f4e9(1050530)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(51.28, 21.78, -97.62)
	event.CmrsSetRef(50.16, 19.92, -141.52)
	event.ObjsSetPos(0, 58.4, -0.02, -135.54)
	event.ObjsSetRot(0, 0.0, -2.3, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, 36.44, -0.02, -151.98)
	event.ObjsSetRot(1, 0.0, 0.69, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetCharaPos(25, 62.85, 11.43, -176.07)
	event.SetCharaRot(25, 0.0, -0.72, 0.0)
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(1050530)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_1c5b0(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_184b0(var1)
			end
			if at <= 2 then
				helper_18a38(var1)
			end
			if at <= 3 then
				helper_18f90(var1)
			end
			if at <= 4 then
				helper_1986c(var1)
			end
			if at <= 5 then
				helper_19f64()
				helper_19fc0(var1)
			end
			if at <= 6 then
				helper_1a63c(var1)
			end
			if at <= 7 then
				helper_1b810(var1, var2)
			end
			if at <= 8 then
				helper_1c150(var1)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
		if at <= 10 then
			helper_efffcfbb(30)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_efffcfbb(30)
		if vm.skipping() then
			return skip(11)
		end
		if arg0 == 5 then
			event.PlayBgm(0)
		end
		event.SetCharaPos(25, var3, var4, var5)
		event.SetCharaRot(25, var6, var7, var8)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.ResetCamera(1, 0.0, 20.0)
		event.SpriteSetDraw(0, 0)
		event.DelImg(0)
		event.CharaActive(1, 0)
		if vm.wait() then
			return skip(12)
		end
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(25)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = event.GetCharaRot(25)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	event.SetFlag(105, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var1 = event.SndLoadSound(1228) or var1
	var2 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var2
	event.AssignStack(5)
	event.ClearStack(5)
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
	event.CmrsInit()
	event.LoadChara(5, "event/e100/e105/e105_starbre.gltf", "info", 33)
	event.CharaActive(1, 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadMotion(5, "event/e100/e105/e105_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetSoundId(0, var1)
	event.LoadChara(5, "event/e100/e105/e105_back.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.LoadChara(5, "event/e100/e105/back01.gltf", "info", 36)
	event.CharaActive(1, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 37)
	event.CharaActive(1, 37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSetShow(5, 0)
	event.LoadMes(0, 5, "event/e100/e105/e105c_1.txt")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.InitDramaScene()
	if arg0 == 1 then
		event.ObjsResetDaPosition(0)
		helper_184b0(var1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if arg0 == 2 then
		event.ObjsResetDaPosition(0)
		helper_18a38(var1)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsResetDaPosition(0)
		helper_18f90(var1)
		if vm.skipping() then
			return skip(4)
		end
		event.ObjsResetDaPosition(0)
		helper_1986c(var1)
		if vm.skipping() then
			return skip(5)
		end
	end
	if arg0 == 3 then
		event.ObjsResetDaPosition(0)
		helper_19f64()
	end
	if arg0 == 4 then
		event.ObjsResetDaPosition(0)
		helper_19fc0(var1)
		if vm.skipping() then
			return skip(6)
		end
	end
	if arg0 == 5 then
		event.StopBgm(0)
		event.ObjsResetDaPosition(0)
		helper_1a63c(var1)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsResetDaPosition(0)
		helper_1b810(var1, var2)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsResetDaPosition(0)
		helper_1c150(var1)
		if vm.skipping() then
			return skip(9)
		end
	end
	return part2()
end

--- Helper function.
local function helper_e8f8(arg0: s32, arg1: any)
	local flag: s32 = 0
	local var3: s32 = 0
	local player_chara: s32 = 0
	local var5: any = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_efffcfbb(9)
			end
			if at <= 2 then
				helper_470f8a56(0, 1)
				helper_54be73eb(arg0, 0, 0)
			end
			if at <= 3 then
				helper_e84a97e1(0, -1, arg0, player_chara, 0)
			end
			if at <= 4 then
				var5 = helper_1844fc9c(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 5 then
				helper_e84a97e1(0, -1, arg0, player_chara, 0)
			end
			if at <= 6 then
				helper_efffcfbb(30)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 10 then
			return
		end
		if at <= 11 then
			return
		end
		if at <= 12 then
			return
		end
		if at <= 13 then
			return
		end
		if at <= 14 then
			return
		end
		if at <= 15 then
			return
		end
		if at <= 16 then
			return
		end
		if at <= 17 then
			return
		end
		if at <= 18 then
			helper_9d79a7c9(arg0, -1, 0, 0)
		end
		if at <= 19 then
			helper_9d79a7c9(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち", 0)
	helper_efffcfbb(9)
	if vm.skipping() then
		return skip(2)
	end
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		helper_470f8a56(0, 1)
		helper_54be73eb(arg0, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] tal va Steve?")
		helper_e84a97e1(0, -1, arg0, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Repostar\nMejorar el N[UNI00fa]cleo")
		var5 = helper_1844fc9c(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var5 == 0 then
			event.SetSavedataEtc(2)
			event.MesMake_2(0, "[UNI00a1]Ya! [UNI00a1]Todo listo!")
			helper_e84a97e1(0, -1, arg0, player_chara, 0)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var5 == 1 then
			event.SetFadeOut(25)
			helper_efffcfbb(30)
			if vm.skipping() then
				return skip(7)
			end
			event.GotoMenu(6, 23)
			if vm.wait() then
				return skip(8)
			end
			event.SetFadeIn(25)
		end
		event.SetAi(1, 24)
		return
	end
	flag = event.GetFlag(107) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(0, "[UNI00bf]Te rindes por algo tan insignificante\n? [UNI00a1]Nada de tirar la toalla!")
		helper_9d79a7c9(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetAi(1, 24)
		return
	end
	flag = event.GetFlag(20) or flag
	if flag == 1 then
		if vm.wait() then
			return skip(10)
		end
		event.LoadScript("i01h01/i01h01c_1.stb", 500)
		return
	end
	var3 = event.GetItemNum(165) or var3
	if var3 > 0 then
		event.SetFlag(20, 1)
		if vm.wait() then
			return skip(11)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	argc = event.GetItemNum(224) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	var3 = event.GetInventionId(165) or var3
	if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 and var3 ~= -1 then
		if vm.wait() then
			return skip(12)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.GetFlag(19) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(
			0,
			"Sal fuera: el sitio\nde enfrente con el s[UNI00ed]mbolo de la calabaza es la\nTienda de Objetos.<page>Necesitas 20 trozos de metal,\n2 buenos cachos de cobre y una piel gruesa.\nVe a la tienda y c[UNI00f3]mpralo todo."
		)
		helper_9d79a7c9(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(13)
		end
		event.SetAi(1, 24)
		return
	end
	var3 = event.GetInventionId(165) or var3
	if var3 ~= -1 then
		if vm.wait() then
			return skip(14)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	var3 = event.CheckInventItem(165) or var3
	if var3 == 1 then
		if vm.wait() then
			return skip(15)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.GetFlag(17) or flag
	if flag == 1 then
		if vm.wait() then
			return skip(16)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 510)
		return
	end
	flag = event.GetFlag(105) or flag
	if flag == 0 then
		event.MesMake_2(0, "Max, no puedes saltarte el trabajo,\n[UNI00bf]me oyes?")
		helper_9d79a7c9(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(17)
		end
		return
	end
	event.SetAi(0, 24)
	event.MesMake_2(0, "Int[UNI00e9]ntalo t[UNI00fa] mismo\nprimero, muchacho.")
	helper_9d79a7c9(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.MesMake_2(0, "Te echar[UNI00e9] una mano si\ntienes problemas, no te preocupes.")
	helper_9d79a7c9(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.MesMake_2(0, "[UNI00a1]Hale, venga, vete!")
	helper_9d79a7c9(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.SetAi(1, 24)
end

--- Helper function.
local function helper_fe98()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("[talk_chara]", var1, "\n")
			print("[talk_chara_id]", var1, "\n")
			helper_e8f8(var0, var1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	var0 = event.GetEventData_2(13) or var0
	var1 = event.GetEventData_2(14) or var1
	print("[talk_chara]", var1, "\n")
	print("[talk_chara_id]", var1, "\n")
	if var1 == 1 then
		helper_e8f8(var0, var1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == -1 then
		flag = event.GetFlag(6) or flag
		flag_2 = event.GetFlag(7) or flag_2
		if flag == 1 and flag_2 == 0 then
			if vm.wait() then
				return skip(3)
			end
			event.LoadScript("i01h01/i01h01c_1.stb", 520)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_6f3f5f84()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7377ea1d()
			helper_6c89029a(1)
		end
	end
	helper_6ad81763()
	event.SetFlag(18, 1)
	event.SetFlag(21, 1)
	helper_14a00()
	if vm.skipping() then
		return skip(1)
	end
	helper_7377ea1d()
	event.SetCharaPos(0, 16.25, -0.02, -166.37)
	event.SetCharaRot(0, 0.0, 1.16, 0.0)
	event.SetMotion(0, "立ち")
	event.SetAi(0, 24)
	event.SetCharaPos(24, 38.77, -0.02, -147.68)
	event.SetCharaRot(24, 0.0, -2.04, 0.0)
	event.SetMotion(24, "立ち")
	event.SetAi(1, 24)
	event.SetSavedataEtc(0, 3)
	event.AddItem(369, 1)
	event.AddItem(355, 1)
	helper_6c89029a(1)
	if vm.skipping() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.LoadScript("i01h01/i01h01_1.stb", -1)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6ad81763()
			helper_171e0()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_7377ea1d()
		end
	end
	function part2()
		helper_7377ea1d()
		event.SetCharaPos(0, 16.25, -0.02, -166.37)
		event.SetCharaRot(0, 0.0, 1.16, 0.0)
		event.SetMotion(0, "立ち")
		event.SetAi(0, 24)
		event.SetCharaPos(24, 38.77, -0.02, -147.68)
		event.SetCharaRot(24, 0.0, -2.04, 0.0)
		event.SetMotion(24, "立ち")
		if vm.wait() then
			return skip(3)
		end
		event.SetAi(1, 24)
		if vm.wait() then
			return skip(4)
		end
		event.LoadScript("i01h01/i01h01_1.stb", -1)
	end
	event.SetFadeOut(10, 0.0, 0.0, 0.0)
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(1)
	end
	helper_6ad81763()
	helper_171e0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 520.
script[520] = function()
	local var0: s32 = 0
	local flag: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local argc_4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_6ad81763()
				helper_1c5b0(5)
				if not vm.skipping() then
					return landing1()
				end
			end
			if at <= 2 then
				helper_7377ea1d()
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_7377ea1d()
			end
			return
		end
		if at <= 10 then
			if at <= 8 then
				helper_1c5b0(2)
				if not vm.skipping() then
					return landing2()
				end
			end
			if at <= 9 then
				helper_7377ea1d()
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_7377ea1d()
			end
			return
		end
		if at <= 13 then
			return
		end
	end
	function part2()
		event.SetFadeIn(15)
		event.MesMake_2(0, "Max, no puedes saltarte el trabajo,\n[UNI00bf]me oyes?")
		helper_9d79a7c9(24, -1, 0, 0)
		if vm.skipping() then
			return skip(14)
		end
		if vm.wait() then
			return skip(15)
		end
		event.LoadScript("i01h01/i01h01_1.stb", -1)
	end
	function landing1()
		helper_7377ea1d()
		event.SetCharaPos(0, 16.25, -0.02, -166.37)
		event.SetCharaRot(0, 0.0, 1.16, 0.0)
		event.SetMotion(0, "立ち")
		event.SetAi(0, 24)
		event.SetCharaPos(24, 38.77, -0.02, -147.68)
		event.SetCharaRot(24, 0.0, -2.04, 0.0)
		event.SetMotion(24, "立ち")
		if vm.wait() then
			return skip(3)
		end
		event.SetAi(1, 24)
		event.SetFlag(20, 1)
		event.CharaActive(1, 26)
		event.SetReference(25, "back", 26)
		event.SubItem(165, 1)
		if vm.wait() then
			return skip(4)
		end
		event.LoadScript("i01h01/i01h01_1.stb", -1)
	end
	function landing2()
		helper_7377ea1d()
		event.SetAi(0, 24)
		event.SetCharaPos(24, 38.77, -0.02, -147.68)
		event.SetCharaRot(24, 0.0, 0.72, 0.0)
		event.SetMotion(24, "立ち")
		if vm.wait() then
			return skip(10)
		end
		event.SetAi(1, 24)
		event.LoadScript("i01h01/i01h01_1.stb", -1)
	end
	event.SetMotion(0, "立ち")
	event.SetFlag(21, 0)
	event.SetFadeOut(30, 0.0, 0.0, 0.0)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_6ad81763()
	flag = event.GetFlag(13) or flag
	if flag == 1 then
		helper_1c5b0(5)
		if vm.skipping() then
			return skip(2)
		end
		helper_7377ea1d()
		event.SetCharaPos(0, 16.25, -0.02, -166.37)
		event.SetCharaRot(0, 0.0, 1.16, 0.0)
		event.SetMotion(0, "立ち")
		event.SetAi(0, 24)
		event.SetCharaPos(24, 38.77, -0.02, -147.68)
		event.SetCharaRot(24, 0.0, -2.04, 0.0)
		event.SetMotion(24, "立ち")
		if vm.wait() then
			return skip(3)
		end
		event.SetAi(1, 24)
		event.SetFlag(20, 1)
		event.CharaActive(1, 26)
		event.SetReference(25, "back", 26)
		event.SubItem(165, 1)
		if vm.wait() then
			return skip(4)
		end
		event.LoadScript("i01h01/i01h01_1.stb", -1)
		return
	else
		flag = event.GetFlag(19) or flag
		if flag == 1 then
			argc = event.GetItemNum(224) or argc
			argc_2 = event.GetItemNum(245) or argc_2
			argc_3 = event.GetItemNum(227) or argc_3
			if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 then
				var0 = event.GetItemNum(165) or var0
				print("backpack num =", var0, "---------------\n")
				if var0 == 0 then
					helper_1c5b0(4)
					if vm.skipping() then
						return skip(5)
					end
					helper_7377ea1d()
					event.SetCharaPos(0, 59.55, -1.12, -135.97)
					event.SetCharaRot(0, 0.0, -2.24, 0.0)
					event.SetMotion(0, "立ち")
					event.SetAi(0, 24)
					event.SetCharaPos(24, 38.77, -0.02, -147.68)
					event.SetCharaRot(24, 0.0, 0.72, 0.0)
					event.SetMotion(24, "立ち")
					if vm.wait() then
						return skip(6)
					end
					event.SetAi(1, 24)
					event.LoadScript("i01h01/i01h01_1.stb", -1)
					return
				end
			else
				event.SetFadeIn(0)
				event.SetAi(0, 24)
				event.MesMake_2(
					0,
					"Espabila de una vez. La Tienda de Objetos\nest[UNI00e1] justo al otro lado de la calle.\nVete corriendo para all[UNI00ed]."
				)
				helper_9d79a7c9(24, -1, 0, 0)
				if vm.skipping() then
					return skip(7)
				end
				event.SetAi(1, 24)
				if vm.wait() then
					return skip(8)
				end
				event.LoadScript("i01h01/i01h01_1.stb", -1)
			end
		else
			var0 = event.CheckInventItem(165) or var0
			if var0 == 1 then
				argc_4 = event.GetInventionId(165) or argc_4
				if argc_4 ~= -1 then
					event.SetFlag(19, 1)
					event.AddMoney(400)
					helper_1c5b0(2)
					if vm.skipping() then
						return skip(9)
					end
					helper_7377ea1d()
					event.SetAi(0, 24)
					event.SetCharaPos(24, 38.77, -0.02, -147.68)
					event.SetCharaRot(24, 0.0, 0.72, 0.0)
					event.SetMotion(24, "立ち")
					if vm.wait() then
						return skip(10)
					end
					event.SetAi(1, 24)
					event.LoadScript("i01h01/i01h01_1.stb", -1)
					return
				else
					helper_1c5b0(1)
					if vm.skipping() then
						return skip(11)
					end
					helper_7377ea1d()
					event.SetCharaPos(0, 16.25, -0.02, -166.37)
					event.SetCharaRot(0, 0.0, 1.16, 0.0)
					event.SetMotion(0, "立ち")
					event.SetAi(0, 24)
					event.SetCharaPos(24, 38.77, -0.02, -147.68)
					event.SetCharaRot(24, 0.0, -2.04, 0.0)
					event.SetMotion(24, "立ち")
					if vm.wait() then
						return skip(12)
					end
					event.SetAi(1, 24)
					event.LoadScript("i01h01/i01h01_1.stb", -1)
					return
				end
			else
				if vm.wait() then
					return skip(13)
				end
				event.LoadScript("i01h01/i01h01c_1.stb", 500)
				return
			end
		end
	end
	return part2()
end

--- Program 521.
script[521] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.CharaActive(0, 24)
	helper_1c5b0(2)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("i01h01/i01h01_1.stb", -1)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fe98()
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	helper_fe98()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 11053.
script[11053] = function()
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local argc_4: s32 = 0
	local argc_5: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_6ad81763()
				helper_1c5b0(5)
				if not vm.skipping() then
					return landing1()
				end
			end
			if at <= 2 then
				helper_7377ea1d()
			end
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_7377ea1d()
			end
			return
		end
		if at <= 10 then
			return
		end
		if at <= 13 then
			if at <= 11 then
				helper_7377ea1d()
			end
			return
		end
	end
	function part2()
		argc_3 = event.GetItemNum(224) or argc_3
		argc_4 = event.GetItemNum(245) or argc_4
		argc_5 = event.GetItemNum(227) or argc_5
		if argc_3 >= 20 and argc_4 >= 1 and argc_5 >= 2 then
			helper_1c5b0(4)
			if vm.skipping() then
				return skip(5)
			end
			helper_7377ea1d()
			event.SetCharaPos(0, 59.55, -1.12, -135.97)
			event.SetCharaRot(0, 0.0, -2.24, 0.0)
			event.SetMotion(0, "立ち")
			event.SetAi(0, 24)
			event.SetCharaPos(24, 38.77, -0.02, -147.68)
			event.SetCharaRot(24, 0.0, 0.72, 0.0)
			event.SetMotion(24, "立ち")
			if vm.wait() then
				return skip(6)
			end
			event.SetAi(1, 24)
			if vm.wait() then
				return skip(7)
			end
			event.LoadScript("i01h01/i01h01_1.stb", -1)
			return
		end
		argc = event.GetInventionId(165) or argc
		if argc ~= -1 then
			helper_1c5b0(2)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(0, 24)
			event.SetCharaPos(24, 38.77, -0.02, -147.68)
			event.SetCharaRot(24, 0.0, 0.72, 0.0)
			event.SetMotion(24, "立ち")
			if vm.wait() then
				return skip(9)
			end
			event.SetAi(1, 24)
			if vm.wait() then
				return skip(10)
			end
			event.LoadScript("i01h01/i01h01_1.stb", -1)
			return
		end
		if argc == -1 then
			helper_1c5b0(1)
			if vm.skipping() then
				return skip(11)
			end
			helper_7377ea1d()
			event.SetCharaPos(0, 16.25, -0.02, -166.37)
			event.SetCharaRot(0, 0.0, 1.16, 0.0)
			event.SetMotion(0, "立ち")
			event.SetAi(0, 24)
			event.SetCharaPos(24, 38.77, -0.02, -147.68)
			event.SetCharaRot(24, 0.0, -2.04, 0.0)
			event.SetMotion(24, "立ち")
			if vm.wait() then
				return skip(12)
			end
			event.SetAi(1, 24)
			if vm.wait() then
				return skip(13)
			end
			event.LoadScript("i01h01/i01h01_1.stb", -1)
			return
		end
		event.SetFadeIn(30)
		if vm.wait() then
			return skip(14)
		end
		event.LoadScript("i01h01/i01h01_1.stb", -1)
	end
	function landing1()
		helper_7377ea1d()
		event.SetCharaPos(0, 16.25, -0.02, -166.37)
		event.SetCharaRot(0, 0.0, 1.16, 0.0)
		event.SetMotion(0, "立ち")
		event.SetAi(0, 24)
		event.SetCharaPos(24, 38.77, -0.02, -147.68)
		event.SetCharaRot(24, 0.0, -2.04, 0.0)
		event.SetMotion(24, "立ち")
		if vm.wait() then
			return skip(3)
		end
		event.SetAi(1, 24)
		event.SetFlag(20, 1)
		event.CharaActive(1, 26)
		event.SetReference(25, "back", 26)
		if vm.wait() then
			return skip(4)
		end
		event.LoadScript("i01h01/i01h01_1.stb", -1)
	end
	event.SetMotion(0, "立ち")
	event.SetFlag(21, 0)
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_6ad81763()
	argc_2 = event.GetItemNum(165) or argc_2
	if argc_2 >= 1 then
		event.SubItem(165, 1)
		helper_1c5b0(5)
		if vm.skipping() then
			return skip(2)
		end
		helper_7377ea1d()
		event.SetCharaPos(0, 16.25, -0.02, -166.37)
		event.SetCharaRot(0, 0.0, 1.16, 0.0)
		event.SetMotion(0, "立ち")
		event.SetAi(0, 24)
		event.SetCharaPos(24, 38.77, -0.02, -147.68)
		event.SetCharaRot(24, 0.0, -2.04, 0.0)
		event.SetMotion(24, "立ち")
		if vm.wait() then
			return skip(3)
		end
		event.SetAi(1, 24)
		event.SetFlag(20, 1)
		event.CharaActive(1, 26)
		event.SetReference(25, "back", 26)
		if vm.wait() then
			return skip(4)
		end
		event.LoadScript("i01h01/i01h01_1.stb", -1)
		return
	end
	return part2()
end

return script
