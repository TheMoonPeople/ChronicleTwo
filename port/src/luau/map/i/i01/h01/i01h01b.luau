--!strict
-- map/i/i01/h01/i01h01b.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0924108c = require("@lib/event/helper_0924108c")
local helper_13e53048 = require("@lib/event/helper_13e53048")
local helper_19a74323 = require("@lib/event/helper_19a74323")
local helper_2a5f7c21 = require("@lib/event/helper_2a5f7c21")
local helper_330d2062 = require("@lib/event/helper_330d2062")
local helper_36223217 = require("@lib/event/helper_36223217")
local helper_7608018e = require("@lib/event/helper_7608018e")
local helper_7c88d7a5 = require("@lib/event/helper_7c88d7a5")
local helper_8b3317ed = require("@lib/event/helper_8b3317ed")
local helper_93fd01b9 = require("@lib/event/helper_93fd01b9")
local helper_9fb4735f = require("@lib/event/helper_9fb4735f")
local helper_d54fe372 = require("@lib/event/helper_d54fe372")
local helper_db7d11d7 = require("@lib/event/helper_db7d11d7")
local helper_efde54cc = require("@lib/event/helper_efde54cc")

--- Helper function.
local function helper_bdbc()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetAi(0, 24)
	event.CharaActive(0, 24)
end

--- Helper function.
local function helper_be78()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_bdbc()
	flag = event.GetFlag(18) or flag
	if flag == 1 then
		flag = event.GetFlag(17) or flag
		if flag == 0 then
			event.SetFlag(17, 1)
		end
	end
	event.SetFadeOut(1)
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeIn(30)
	event.GotoOutside(-1, "m01")
end

--- Helper function.
local function helper_e768(arg0: any)
	local projection: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8b3317ed()
		end
		if at <= 2 then
			helper_8b3317ed()
		end
		if at <= 3 then
			helper_db7d11d7(0)
		end
		if at <= 4 then
			helper_db7d11d7(0)
		end
		if at <= 5 then
			helper_13e53048(10)
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
	helper_8b3317ed()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsMove2(-13.56, 18.54, -99.84, 47.32, 27.15, -184.47, 90, 2, 0.4)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "歩き", 0)
	event.ObjsMove(0, 8.7, -0.02, -189.32, 45)
	event.ObjsRotation(0, 0.0, 0.3, 0.0, 45)
	event.ObjsMove(0, 16.96, -0.02, -159.01, 45)
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsRotation(0, 0.0, 1.74, 0.0, 10)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_13e53048(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetProjection(projection)
end

--- Helper function.
local function helper_eea4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_13e53048(9)
		end
		if at <= 3 then
			helper_9fb4735f(1050010)
		end
		if at <= 4 then
			helper_9fb4735f(1050020)
		end
		if at <= 5 then
			helper_db7d11d7(0)
		end
		if at <= 6 then
			helper_13e53048(9)
		end
		if at <= 7 then
			helper_9fb4735f(1050030)
		end
		if at <= 8 then
			helper_9fb4735f(1050040)
		end
		if at <= 9 then
			helper_9fb4735f(1050050)
		end
		if at <= 10 then
			helper_13e53048(24)
		end
		if at <= 11 then
			helper_9fb4735f(1050060)
		end
		if at <= 12 then
			helper_9fb4735f(1050065)
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "左を見る", 2)
	event.ObjsNextMotion(1, "左を見るL")
	helper_13e53048(9)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050010)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "うなづく（スティーブ）", 2)
	event.ObjsNextMotion(0, "スティーブ見L")
	event.SetPakuAnim(0, "通常口パク")
	helper_9fb4735f(1050020)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "右を見る", 2)
	event.ObjsNextMotion(0, "右を見るL")
	helper_13e53048(9)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_9fb4735f(1050030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050040)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050050)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "アトラミリアをさわる", 6)
	event.ObjsNextMotion(0, "アトラミリアをさわるL")
	helper_13e53048(24)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(arg0, 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_9fb4735f(1050060)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050065)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_f6d0(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(9)
		end
		if at <= 2 then
			helper_9fb4735f(1050070)
		end
		if at <= 3 then
			helper_9fb4735f(1050071)
		end
		if at <= 4 then
			helper_9fb4735f(1050080)
		end
		if at <= 5 then
			helper_9fb4735f(1050090)
		end
		if at <= 6 then
			helper_9fb4735f(1050100)
		end
		if at <= 7 then
			helper_db7d11d7(0)
		end
		if at <= 8 then
			helper_9fb4735f(1050110)
		end
		if at <= 9 then
			helper_db7d11d7(1)
		end
		if at <= 10 then
			helper_9fb4735f(1050120)
		end
		if at <= 11 then
			helper_db7d11d7(0)
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
	helper_13e53048(9)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050070)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050071)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "わらい口パク")
	helper_9fb4735f(1050080)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050090)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右を見る", 6)
	event.ObjsNextMotion(0, "右を見るL")
	event.SetPakuAnim(0, "わらい口パク")
	helper_9fb4735f(1050100)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "左を見る", 2)
	event.ObjsNextMotion(1, "左を見るL")
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050110)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_db7d11d7(1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "右を見る会話", 6)
	event.ObjsNextMotion(0, "右を見るL")
	event.SetPakuAnim(0, "わらい口パク")
	helper_9fb4735f(1050120)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(12)
	end
end

--- Helper function.
local function helper_ff38(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9fb4735f(1050130)
		end
		if at <= 2 then
			helper_13e53048(50)
		end
		if at <= 3 then
			helper_9fb4735f(1050140)
		end
		if at <= 4 then
			helper_9fb4735f(1050150)
		end
		if at <= 5 then
			helper_db7d11d7(0)
		end
		if at <= 6 then
			helper_9fb4735f(1050160)
		end
		if at <= 7 then
			helper_db7d11d7(1)
		end
		if at <= 8 then
			helper_9fb4735f(1050170)
		end
		if at <= 9 then
			helper_db7d11d7(0)
		end
		if at <= 10 then
			helper_9fb4735f(1050180)
		end
		if at <= 11 then
			helper_8b3317ed()
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
	helper_9fb4735f(1050130)
	if vm.skipping() then
		return skip(2)
	end
	helper_13e53048(50)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "腰に手会話", 6)
	event.ObjsNextMotion(1, "腰に手L", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050140)
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
	helper_9fb4735f(1050150)
	if vm.skipping() then
		return skip(5)
	end
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "腰に手会話", 6)
	event.ObjsNextMotion(1, "腰に手L", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050160)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_db7d11d7(1)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSePlay(arg0, 4)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "スターブル見L")
	event.SetPakuAnim(0, "通常口パク")
	helper_9fb4735f(1050170)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050180)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.CmrsFadeInit()
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(12)
	end
end

--- Helper function.
local function helper_d8f0(arg0: s32, arg1: f32, arg2: f32, arg3: s32)
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
local function helper_dba4(arg0: s32)
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
local function helper_10830(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8b3317ed()
		end
		if at <= 2 then
			helper_13e53048(10)
		end
		if at <= 3 then
			helper_9fb4735f(1050190)
		end
		if at <= 4 then
			helper_9fb4735f(1050200)
		end
		if at <= 5 then
			helper_13e53048(10)
		end
		if at <= 6 then
			helper_9fb4735f(1050210)
		end
		if at <= 7 then
			helper_9fb4735f(1050211)
		end
		if at <= 8 then
			helper_9fb4735f(1050212)
		end
		if at <= 9 then
			helper_9fb4735f(1050213)
		end
		if at <= 10 then
			helper_8b3317ed()
		end
		if at <= 11 then
			helper_d8f0(32, vm.f32(0.206), -1.0, 20)
		end
		if at <= 12 then
			helper_d8f0(32, vm.f32(0.956), -1.0, 20)
		end
		if at <= 13 then
			helper_dba4(32)
		end
		if at <= 14 then
			helper_9fb4735f(1050220)
		end
		if at <= 15 then
			helper_9fb4735f(1050230)
		end
		if at <= 16 then
			helper_9fb4735f(1050240)
		end
		if at <= 17 then
			helper_9fb4735f(1050241)
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
	helper_8b3317ed()
	if vm.skipping() then
		return skip(2)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(3, 128.0, 128.0, 128.0, 128.0, 10)
	helper_13e53048(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050190)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050200)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(4, 128.0, 128.0, 128.0, 128.0, 30)
	helper_13e53048(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050210)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050211)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050212)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050213)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(1, 0)
	event.CmrsMove(-2.41, 23.65, -165.23, 57.71, 27.49, -130.12, 28)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "カメラを出す", 6)
	event.ObjsNextMotion(1, "カメラを出すL")
	helper_d8f0(32, vm.f32(0.206), -1.0, 20)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(arg0, 5)
	event.CharaActive(1, 33)
	event.SetReference(32, "camera_sta", 33)
	helper_d8f0(32, vm.f32(0.956), -1.0, 20)
	if vm.skipping() then
		return skip(13)
	end
	helper_dba4(32)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(arg0, 6)
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050220)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050230)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050240)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050241)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_7cbc(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_7608018e(arg0, arg1)
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
		var3 = helper_7608018e(arg0, arg1)
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
local function helper_8784(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7cbc(arg0, 0, var6)
		end
		helper_19a74323(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7cbc(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_19a74323(arg0)
end

--- Helper function.
local function helper_11388(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8784(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_8784(0, -1, 8, 0, 0)
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
		"[(!)]カメラを手に入れた。\n   アイテムメニューで「そうび」して\n   (#)ボタンで使えるぞ。"
	)
	helper_8784(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"[(!)]ダンジョン内では、アクティブアイテムの\n   カーソルがカメラに合っていないと使えません。"
	)
	helper_8784(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesWindowMode(0, 7)
	event.PlayBgm(0)
end

--- Helper function.
local function helper_119dc(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9fb4735f(1050250)
		end
		if at <= 2 then
			helper_9fb4735f(1050260)
		end
		if at <= 3 then
			helper_9fb4735f(1050261)
		end
		if at <= 4 then
			helper_db7d11d7(1)
		end
		if at <= 5 then
			helper_db7d11d7(1)
		end
		if at <= 6 then
			helper_13e53048(10)
		end
		if at <= 7 then
			helper_db7d11d7(0)
		end
		if at <= 8 then
			helper_13e53048(15)
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
	helper_9fb4735f(1050250)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050260)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話2", 2)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050261)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_db7d11d7(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_db7d11d7(1)
	if vm.skipping() then
		return skip(6)
	end
	helper_13e53048(10)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsMotionWait(0)
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_13e53048(15)
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_11fcc()
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
				helper_e768(var0)
			end
			if at <= 2 then
				helper_eea4(var0)
			end
			if at <= 3 then
				helper_f6d0(var0)
			end
			if at <= 4 then
				helper_ff38(var0)
			end
			if at <= 5 then
				helper_10830(var0)
			end
			if at <= 6 then
				helper_11388(var0, var1)
			end
			if at <= 7 then
				helper_119dc(var0)
			end
			if at <= 8 then
				helper_13e53048(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
		if at <= 10 then
			helper_13e53048(4)
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
		helper_13e53048(4)
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
	event.LoadMes(0, 5, "event/e100/e105/e105a.txt")
	event.StopBgm(0)
	helper_13e53048(4)
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
	helper_e768(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_eea4(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f6d0(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_ff38(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_10830(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_11388(var0, var1)
	if vm.skipping() then
		return skip(7)
	end
	helper_119dc(var0)
	if vm.skipping() then
		return skip(8)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_bc40()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.SetAi(1, 24)
	event.CharaActive(1, 0)
	event.CharaActive(1, 24)
	event.ResetCamera(1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_dca8(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: f32)
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
			t1, var5 = helper_2a5f7c21(arg0, var5)
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
		t0, var5 = helper_2a5f7c21(arg0, var5)
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
local function helper_e418(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: f32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_0924108c(0, -1, 8, 0, 0)
			helper_dca8(0, arg1, arg2, arg3, arg4)
		end
		helper_19a74323(0)
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
	helper_0924108c(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_dca8(0, arg1, arg2, arg3, arg4)
	if vm.skipping() then
		return skip(4)
	end
	helper_19a74323(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_13634(arg0: f32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_8b3317ed()
		end
		if at <= 3 then
			helper_13e53048(10)
		end
		if at <= 4 then
			helper_9fb4735f(1050290)
		end
		if at <= 5 then
			helper_13e53048(30)
		end
		if at <= 6 then
			helper_9fb4735f(1050291)
		end
		if at <= 7 then
			helper_db7d11d7(1)
		end
		if at <= 8 then
			helper_13e53048(16)
		end
		if at <= 9 then
			helper_9fb4735f(1050300)
		end
		if at <= 10 then
			helper_13e53048(28)
		end
		if at <= 11 then
			helper_e418(1050310, 32, arg1, 4, vm.f32(0.15))
		end
		if at <= 12 then
			helper_e418(1050320, 32, arg1, 4, vm.f32(0.15))
		end
		if at <= 13 then
			helper_e418(1050321, 32, arg1, 4, vm.f32(0.15))
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(1, 1, "目とじ")
	event.ObjsSetMotion(1, "下を見る", 2)
	event.ObjsNextMotion(1, "下を見るL")
	helper_13e53048(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050290)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, 25)
	event.SetCrossfade(0, 0, 30)
	event.SpriteSetDraw(0, 2)
	event.ObjsSetColor(2, 128.0, 128.0, 128.0, 128.0, 0)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050291)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_db7d11d7(1)
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
	helper_13e53048(16)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050300)
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
	helper_13e53048(28)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_e418(1050310, 32, arg1, 4, vm.f32(0.15))
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_e418(1050320, 32, arg1, 4, vm.f32(0.15))
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_e418(1050321, 32, arg1, 4, vm.f32(0.15))
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
local function helper_14444(arg0: any, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_9fb4735f(1050330)
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_9fb4735f(1050330)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_147ac()
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
				helper_13634(projection, var0)
			end
			if at <= 2 then
				helper_14444(projection, var0)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
		if at <= 4 then
			helper_13e53048(30)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_13e53048(30)
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
	event.LoadMes(0, 5, "event/e100/e105/e105b.txt")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_13634(projection, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_14444(projection, var0)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_15a7c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(20)
		end
		if at <= 2 then
			helper_8b3317ed()
		end
		if at <= 3 then
			helper_13e53048(15)
		end
		if at <= 4 then
			helper_9fb4735f(1050340)
		end
		if at <= 5 then
			helper_9fb4735f(1050341)
		end
		if at <= 6 then
			helper_9fb4735f(1050350)
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
	helper_13e53048(20)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(3)
	end
	helper_13e53048(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話2", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050340)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050341)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050350)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_16004(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_8b3317ed()
		end
		if at <= 3 then
			helper_9fb4735f(1050360)
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "ガッツポーズ", 2)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050360)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_1655c(arg0: any)
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8b3317ed()
		end
		if at <= 2 then
			helper_13e53048(30)
		end
		if at <= 3 then
			helper_8b3317ed()
		end
		if at <= 4 then
			helper_13e53048(30)
		end
		if at <= 5 then
			helper_9fb4735f(1050370)
		end
		if at <= 6 then
			helper_9fb4735f(1050380)
		end
		if at <= 7 then
			helper_9fb4735f(1050390)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsInit()
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	helper_8b3317ed()
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(4)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 10)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "腰に手会話", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050370)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050380)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050390)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 0)
	event.DelImg(0)
end

--- Helper function.
local function helper_16dcc(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(15)
		end
		if at <= 2 then
			helper_13e53048(14)
		end
		if at <= 3 then
			helper_9fb4735f(1050400)
		end
		if at <= 4 then
			helper_13e53048(60)
		end
		if at <= 5 then
			helper_8784(0, -1, 8, 0, 0)
		end
		if at <= 6 then
			helper_db7d11d7(1)
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
	helper_13e53048(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 3)
	event.ObjsSetMotion(1, "お金をやる", 6)
	event.ObjsNextMotion(1, "お金をやるL")
	helper_13e53048(14)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050400)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 4)
	event.ObjsSetMotion(0, "お金をもらう", 6)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "お金をもらうL")
	helper_13e53048(60)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(0, "４００ギルダを手に入れた。")
	helper_8784(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 7)
	event.ObjsSetMotion(1, "お金をやる戻り", 6)
	event.ObjsNextMotion(1, "立ち")
	helper_db7d11d7(1)
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_174c4()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_17520(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_8b3317ed()
		end
		if at <= 3 then
			helper_13e53048(10)
		end
		if at <= 4 then
			helper_9fb4735f(1050420)
		end
		if at <= 5 then
			helper_9fb4735f(1050421)
		end
		if at <= 6 then
			helper_9fb4735f(1050430)
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(3)
	end
	helper_13e53048(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "ガッツポーズ", 6)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050420)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050421)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050430)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	event.ObjsResetMotion(1)
end

--- Helper function.
local function helper_17b9c(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_db7d11d7(0)
		end
		if at <= 2 then
			helper_13e53048(15)
		end
		if at <= 3 then
			helper_9fb4735f(1050440)
		end
		if at <= 4 then
			helper_9fb4735f(1050450)
		end
		if at <= 5 then
			var1 = 0
			helper_13e53048(1)
		end
		if at <= 6 then
			var1 = var1 + 1
			helper_13e53048(70)
		end
		if at <= 7 then
			helper_13e53048(14)
		end
		if at <= 8 then
			helper_9fb4735f(1050460)
		end
		if at <= 9 then
			helper_13e53048(10)
		end
		if at <= 10 then
			helper_9fb4735f(1050470)
		end
		if at <= 11 then
			helper_13e53048(10)
		end
		if at <= 12 then
			helper_9fb4735f(1050480)
		end
		if at <= 13 then
			helper_9fb4735f(1050490)
		end
		if at <= 14 then
			helper_9fb4735f(1050491)
		end
		if at <= 15 then
			helper_9fb4735f(1050500)
		end
		if at <= 16 then
			helper_9fb4735f(1050510)
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
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "バックパック持ち")
	helper_13e53048(15)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_9fb4735f(1050440)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(1, "ガッツポーズ", 2)
	event.ObjsNextMotion(1, "立ち")
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050450)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "バックパックを置く", 2)
	event.ObjsNextMotion(0, "スターブル見L")
	var1 = 0
	while var1 < 42 do
		if var1 == 12 then
			event.SndSePlay(arg0, 5)
			event.DelReference(35)
			event.ObjsSetPos(4, 44.54, 6.47, -135.54)
		end
		helper_13e53048(1)
		if vm.skipping() then
			return skip(6)
		end
		var1 = var1 + 1
	end
	event.ObjsTexAnime(0, 1, "ためいき")
	helper_13e53048(70)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(1, "腰に手", 2)
	event.ObjsNextMotion(1, "腰に手L")
	helper_13e53048(14)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050460)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "スターブル見L")
	helper_13e53048(10)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_9fb4735f(1050470)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_13e53048(10)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050480)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050490)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050491)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 7)
	event.ObjsSetMotion(0, "ガッツポーズ", 6, -1.0, 1)
	event.ObjsNextMotion(0, "スターブル見L")
	event.SetPakuAnim(0, "わらい口パク")
	helper_9fb4735f(1050500)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "腰に手L")
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050510)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_18d28(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8b3317ed()
		end
		if at <= 2 then
			helper_13e53048(30)
		end
		if at <= 3 then
			helper_8b3317ed()
		end
		if at <= 4 then
			helper_13e53048(15)
		end
		if at <= 5 then
			helper_9fb4735f(1050520)
		end
		if at <= 6 then
			helper_8784(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	helper_8b3317ed()
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
	helper_13e53048(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(arg1, 0)
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_8b3317ed()
	if vm.skipping() then
		return skip(4)
	end
	helper_13e53048(15)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(arg0, 8)
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050520)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	var2 = event.GetMesWindowMode(0) or var2
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]メインメニューの『キャラクター』でライドポッドを\n   選択すれば、乗り込むことができるぞ。\n   また、(R)を押し込むことでもチェンジできる。"
	)
	helper_8784(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesWindowMode(0, var2)
end

--- Helper function.
local function helper_19648(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(15)
		end
		if at <= 2 then
			helper_9fb4735f(1050530)
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
	helper_13e53048(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_9fb4735f(1050530)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_19aa8(arg0: s32)
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
				helper_15a7c(var1)
			end
			if at <= 2 then
				helper_16004(var1)
			end
			if at <= 3 then
				helper_1655c(var1)
			end
			if at <= 4 then
				helper_16dcc(var1)
			end
			if at <= 5 then
				helper_174c4()
				helper_17520(var1)
			end
			if at <= 6 then
				helper_17b9c(var1)
			end
			if at <= 7 then
				helper_18d28(var1, var2)
			end
			if at <= 8 then
				helper_19648(var1)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
		if at <= 10 then
			helper_13e53048(30)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_13e53048(30)
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
	event.LoadMes(0, 5, "event/e100/e105/e105c.txt")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.InitDramaScene()
	if arg0 == 1 then
		event.ObjsResetDaPosition(0)
		helper_15a7c(var1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if arg0 == 2 then
		event.ObjsResetDaPosition(0)
		helper_16004(var1)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsResetDaPosition(0)
		helper_1655c(var1)
		if vm.skipping() then
			return skip(4)
		end
		event.ObjsResetDaPosition(0)
		helper_16dcc(var1)
		if vm.skipping() then
			return skip(5)
		end
	end
	if arg0 == 3 then
		event.ObjsResetDaPosition(0)
		helper_174c4()
	end
	if arg0 == 4 then
		event.ObjsResetDaPosition(0)
		helper_17520(var1)
		if vm.skipping() then
			return skip(6)
		end
	end
	if arg0 == 5 then
		event.StopBgm(0)
		event.ObjsResetDaPosition(0)
		helper_17b9c(var1)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsResetDaPosition(0)
		helper_18d28(var1, var2)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsResetDaPosition(0)
		helper_19648(var1)
		if vm.skipping() then
			return skip(9)
		end
	end
	return part2()
end

--- Helper function.
local function helper_8fd4(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local angle: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local angle_2: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var27 = var10
			var28 = var15
			angle = vm.f32(var28 - var27)
			var30 = var13
			var31 = var16
			angle_2 = vm.f32(var31 - var30)
			var33 = 0.0
			var34 = vm.f32(helper_d54fe372(helper_7c88d7a5(angle), helper_7c88d7a5(angle_2)) * 8.0)
			var35 = helper_36223217(0.0, angle, var33, var34)
			var35 = vm.f32(var35 + var27)
			var36 = helper_36223217(0.0, angle_2, var33, var34)
			var36 = vm.f32(var36 + var30)
			var33 = vm.f32(var33 + 1.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var10 = out2 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg1)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.GetCharaRot(arg1)
		var13 = out2 or var13
	end
	var15 = event.GetRotLookPos(var6 - var3, var8 - var5) or var15
	var16 = event.GetRotLookPos(var3 - var6, var5 - var8) or var16
	if arg2 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.SetTalkCamera(var3, var4, var5, var6, var7, var8, var15)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var21 = out5 or var21
			middle_z = out6 or middle_z
		end
		event.SetCameraPos(offset_x, offset_y, offset_z)
		event.SetCameraRef(middle_x, var21, middle_z)
		event.SetCrossfade(10)
	end
	var27 = var10
	var28 = var15
	angle = vm.f32(var28 - var27)
	angle = event.AngleLimit(angle) or angle
	var30 = var13
	var31 = var16
	angle_2 = vm.f32(var31 - var30)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg1, "歩き")
	end
	var33 = 0.0
	var34 = vm.f32(helper_d54fe372(helper_7c88d7a5(angle), helper_7c88d7a5(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_36223217(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_36223217(0.0, angle_2, var33, var34)
		var36 = vm.f32(var36 + var30)
		event.SetCharaRot(arg1, 0.0, var36, 0.0)
		var33 = vm.f32(var33 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.SetCharaRot(arg0, 0.0, var15, 0.0)
	event.SetMotion(arg0, "立ち")
	event.SetCharaRot(arg1, 0.0, var16, 0.0)
	event.SetMotion(arg1, "会話")
end

--- Helper function.
local function helper_a508(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8fd4(player_chara, arg0, arg1)
		end
		return rot_y
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_8fd4(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

--- Helper function.
local function helper_80f0(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efde54cc(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_7cbc(arg0, 0, var5)
		end
		helper_19a74323(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_efde54cc(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_7cbc(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_19a74323(arg0)
end

--- Helper function.
local function helper_9d64(arg0: any, arg1: f32)
	local rot_y: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local angle: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var10 = rot_y
			var11 = arg1
			angle = vm.f32(var11 - var10)
			var14 = 0.0
			var15 = 10.0
			var13 = helper_36223217(0.0, angle, var14, var15)
			var13 = vm.f32(var13 + var10)
			var14 = vm.f32(var14 + 1.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, arg0)
	event.EohGetPos(0)
	do
		local _, out2, _ = event.EohGetRot(0)
		rot_y = out2 or rot_y
	end
	var10 = rot_y
	var11 = arg1
	angle = vm.f32(var11 - var10)
	angle = event.AngleLimit(angle) or angle
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	var14 = 0.0
	var15 = 10.0
	while var14 <= var15 do
		var13 = helper_36223217(0.0, angle, var14, var15)
		var13 = vm.f32(var13 + var10)
		event.EohSetRot(0, 0.0, var13, 0.0)
		var14 = vm.f32(var14 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.EohSetRot(0, 0.0, arg1, 0.0)
end

--- Helper function.
local function helper_a678(arg0: any, arg1: f32, arg2: any, arg3: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9d64(arg0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 ~= 0 then
		helper_9d64(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	if arg2 ~= 0 then
		event.SetCrossfade(10)
	end
end

--- Helper function.
local function helper_a7c8(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_a508(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_80f0(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_a678(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_a508(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_80f0(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_a678(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_6cdc(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetMesStatus(arg0) or var1
	while var1 == 0 or var1 == 1 do
		if vm.wait() then
			return skip(2)
		end
		var1 = event.GetMesStatus(arg0) or var1
	end
end

--- Helper function.
local function helper_6a1c(arg0: s32)
	local var1: s32 = 0
	local get_lxf: f32 = 0
	local get_lyf: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return -1
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetMesWindowMode(arg0) or var1
	do
		local out1, out2, _, _ = event.GetApad_4()
		get_lxf = out1 or get_lxf
		get_lyf = out2 or get_lyf
	end
	if var1 == 5 then
		if get_lxf < -0.5 then
			return -1
		end
		if 0.5 < get_lxf then
			return 1
		end
	else
		if get_lyf < -0.5 then
			return -1
		end
		if 0.5 < get_lyf then
			return 1
		end
	end
	return 0
end

--- Helper function.
local function helper_6e34(arg0: s32, arg1: any, arg2: any, arg3: s32)
	local var4: s32 = 0
	local get_pad_down: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var8 = 0
				var7 = 0
				var6 = 0
				helper_6cdc(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_6a1c(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_19a74323(arg0)
			return -1
		end
		helper_19a74323(arg0)
		return arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = event.GetMesQuestionGyou(arg0) or var4
	event.SetMesDrawspeed(arg0, 0.0)
	var8 = 0
	var7 = 0
	var6 = 0
	event.SetMesCursor(arg0, -1)
	event.SetMesCursor(arg0, arg2)
	helper_6cdc(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_6a1c(arg0)
		if var6 == 0 and var7 == -1 then
			event.MesSePlay(2)
			var8 = -1
		end
		if var6 == 0 and var7 == 1 then
			event.MesSePlay(2)
			var8 = 1
		end
		var6 = var7
		pressed = event.CheckButton(0) or pressed
		pressed_2 = event.CheckButton(1) or pressed_2
		get_pad_down = event.GetPaddown() or get_pad_down
		var11 = event.GetMesWindowMode(arg0) or var11
		if var11 == 5 then
			if bit32.band(get_pad_down, 32768) ~= 0 then
				event.MesSePlay(2)
				var8 = -1
			end
			if bit32.band(get_pad_down, 8192) ~= 0 then
				event.MesSePlay(2)
				var8 = 1
			end
		else
			if bit32.band(get_pad_down, 4096) ~= 0 then
				event.MesSePlay(2)
				var8 = -1
			end
			if bit32.band(get_pad_down, 16384) ~= 0 then
				event.MesSePlay(2)
				var8 = 1
			end
		end
		if pressed_2 ~= 0 then
			event.MesSePlay(3)
			if vm.wait() then
				return skip(3)
			end
			break
		else
			if pressed ~= 0 then
				event.MesSePlay(1)
				if vm.wait() then
					return skip(4)
				end
				if arg3 == 0 then
					helper_19a74323(arg0)
					return -1
				end
			end
			if var8 == 1 then
				if arg2 < vm.wrap(vm.wrap(arg1 - 1) + var4) then
					arg2 = vm.wrap(arg2 + 1)
				else
					arg2 = vm.wrap(vm.wrap(arg1 - 1) + var4)
				end
			end
			if var8 == -1 then
				if var4 < arg2 then
					arg2 = arg2 - 1
				else
					arg2 = var4
				end
			end
			event.SetMesCursor(arg0, arg2)
			if vm.wait() then
				return skip(5)
			end
		end
	end
	helper_19a74323(arg0)
	return arg2
end

--- Helper function.
local function helper_7b4c(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
			var8 = helper_6e34(arg0, arg5, arg6, 0)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6e34(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_c0ac(arg0: s32, arg1: any)
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
				helper_13e53048(9)
			end
			if at <= 2 then
				helper_93fd01b9(0, 1)
				helper_a508(arg0, 0, 0)
			end
			if at <= 3 then
				helper_80f0(0, -1, arg0, player_chara, 0)
			end
			if at <= 4 then
				var5 = helper_7b4c(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 5 then
				helper_80f0(0, -1, arg0, player_chara, 0)
			end
			if at <= 6 then
				helper_13e53048(30)
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
			helper_a7c8(arg0, -1, 0, 0)
		end
		if at <= 19 then
			helper_a7c8(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち", 0)
	helper_13e53048(9)
	if vm.skipping() then
		return skip(2)
	end
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		helper_93fd01b9(0, 1)
		helper_a508(arg0, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "スティーブの調子はどうじゃ？")
		helper_80f0(0, -1, arg0, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "ねんりょう補給\nコアのパワーアップ")
		var5 = helper_7b4c(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var5 == 0 then
			event.SetSavedataEtc(2)
			event.MesMake_2(0, "よし、これで\n修理完了じゃ！")
			helper_80f0(0, -1, arg0, player_chara, 0)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var5 == 1 then
			event.SetFadeOut(25)
			helper_13e53048(30)
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
		event.MesMake_2(
			0,
			"こんなことであきらめるのか？\nなにごともネバーギブアップじゃ。"
		)
		helper_a7c8(arg0, -1, 0, 0)
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
		event.LoadScript("i01h01/i01h01c.stb", 500)
		return
	end
	var3 = event.GetItemNum(165) or var3
	if var3 > 0 then
		event.SetFlag(20, 1)
		if vm.wait() then
			return skip(11)
		end
		event.LoadScript("i01h01/i01h01b.stb", 520)
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
		event.LoadScript("i01h01/i01h01b.stb", 520)
		return
	end
	flag = event.GetFlag(19) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(
			0,
			"ここをでて、目の前にあるかぼちゃの\nかんばんの店がアイテム屋じゃ。<page>鉄クズ２０個、銅のかたまり２個、\nそれとぶあつい皮じゃぞ。\n早く買ってくるのじゃ。"
		)
		helper_a7c8(arg0, -1, 0, 0)
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
		event.LoadScript("i01h01/i01h01b.stb", 520)
		return
	end
	var3 = event.CheckInventItem(165) or var3
	if var3 == 1 then
		if vm.wait() then
			return skip(15)
		end
		event.LoadScript("i01h01/i01h01b.stb", 520)
		return
	end
	flag = event.GetFlag(17) or flag
	if flag == 1 then
		if vm.wait() then
			return skip(16)
		end
		event.LoadScript("i01h01/i01h01b.stb", 510)
		return
	end
	flag = event.GetFlag(105) or flag
	if flag == 0 then
		event.MesMake_2(0, "ユリス、バイトをサボるんじゃないぞ。\nわかったな！")
		helper_a7c8(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(17)
		end
		return
	end
	event.SetAi(0, 24)
	event.MesMake_2(0, "まずは自分の力で、\nやってみるのじゃ。")
	helper_a7c8(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.MesMake_2(0, "どうしても解らなければ、\nヒントをだしてやる。")
	helper_a7c8(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.MesMake_2(0, "さあ、行け！")
	helper_a7c8(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.SetAi(1, 24)
end

--- Helper function.
local function helper_d59c()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("[talk_chara]", var1, "\n")
			print("[talk_chara_id]", var1, "\n")
			helper_c0ac(var0, var1)
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
		helper_c0ac(var0, var1)
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
			event.LoadScript("i01h01/i01h01c.stb", 520)
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
	helper_be78()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bc40()
			helper_330d2062(1)
		end
	end
	helper_bdbc()
	event.SetFlag(18, 1)
	event.SetFlag(21, 1)
	helper_11fcc()
	if vm.skipping() then
		return skip(1)
	end
	helper_bc40()
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
	helper_330d2062(1)
	if vm.skipping() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.LoadScript("i01h01/i01h01.stb", -1)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bdbc()
			helper_147ac()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_bc40()
		end
	end
	function part2()
		helper_bc40()
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
		event.LoadScript("i01h01/i01h01.stb", -1)
	end
	event.SetFadeOut(10, 0.0, 0.0, 0.0)
	helper_13e53048(10)
	if vm.skipping() then
		return skip(1)
	end
	helper_bdbc()
	helper_147ac()
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
				helper_bdbc()
				helper_19aa8(5)
				if not vm.skipping() then
					return landing1()
				end
			end
			if at <= 2 then
				helper_bc40()
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_bc40()
			end
			return
		end
		if at <= 10 then
			if at <= 8 then
				helper_19aa8(2)
				if not vm.skipping() then
					return landing2()
				end
			end
			if at <= 9 then
				helper_bc40()
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_bc40()
			end
			return
		end
		if at <= 13 then
			return
		end
	end
	function part2()
		event.SetFadeIn(15)
		event.MesMake_2(0, "ユリス、バイトをサボるんじゃないぞ。\nわかったな！")
		helper_a7c8(24, -1, 0, 0)
		if vm.skipping() then
			return skip(14)
		end
		if vm.wait() then
			return skip(15)
		end
		event.LoadScript("i01h01/i01h01.stb", -1)
	end
	function landing1()
		helper_bc40()
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
		event.LoadScript("i01h01/i01h01.stb", -1)
	end
	function landing2()
		helper_bc40()
		event.SetAi(0, 24)
		event.SetCharaPos(24, 38.77, -0.02, -147.68)
		event.SetCharaRot(24, 0.0, 0.72, 0.0)
		event.SetMotion(24, "立ち")
		if vm.wait() then
			return skip(10)
		end
		event.SetAi(1, 24)
		event.LoadScript("i01h01/i01h01.stb", -1)
	end
	event.SetMotion(0, "立ち")
	event.SetFlag(21, 0)
	event.SetFadeOut(30, 0.0, 0.0, 0.0)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_bdbc()
	flag = event.GetFlag(13) or flag
	if flag == 1 then
		helper_19aa8(5)
		if vm.skipping() then
			return skip(2)
		end
		helper_bc40()
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
		event.LoadScript("i01h01/i01h01.stb", -1)
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
					helper_19aa8(4)
					if vm.skipping() then
						return skip(5)
					end
					helper_bc40()
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
					event.LoadScript("i01h01/i01h01.stb", -1)
					return
				end
			else
				event.SetFadeIn(0)
				event.SetAi(0, 24)
				event.MesMake_2(
					0,
					"何をしておる。\nアイテム屋は、うちの目の前じゃ。\n早く買ってくるのじゃ。"
				)
				helper_a7c8(24, -1, 0, 0)
				if vm.skipping() then
					return skip(7)
				end
				event.SetAi(1, 24)
				if vm.wait() then
					return skip(8)
				end
				event.LoadScript("i01h01/i01h01.stb", -1)
			end
		else
			var0 = event.CheckInventItem(165) or var0
			if var0 == 1 then
				argc_4 = event.GetInventionId(165) or argc_4
				if argc_4 ~= -1 then
					event.SetFlag(19, 1)
					event.AddMoney(400)
					helper_19aa8(2)
					if vm.skipping() then
						return skip(9)
					end
					helper_bc40()
					event.SetAi(0, 24)
					event.SetCharaPos(24, 38.77, -0.02, -147.68)
					event.SetCharaRot(24, 0.0, 0.72, 0.0)
					event.SetMotion(24, "立ち")
					if vm.wait() then
						return skip(10)
					end
					event.SetAi(1, 24)
					event.LoadScript("i01h01/i01h01.stb", -1)
					return
				else
					helper_19aa8(1)
					if vm.skipping() then
						return skip(11)
					end
					helper_bc40()
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
					event.LoadScript("i01h01/i01h01.stb", -1)
					return
				end
			else
				if vm.wait() then
					return skip(13)
				end
				event.LoadScript("i01h01/i01h01c.stb", 500)
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
	helper_19aa8(2)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("i01h01/i01h01.stb", -1)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d59c()
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	helper_d59c()
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
				helper_bdbc()
				helper_19aa8(5)
				if not vm.skipping() then
					return landing1()
				end
			end
			if at <= 2 then
				helper_bc40()
			end
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_bc40()
			end
			return
		end
		if at <= 10 then
			return
		end
		if at <= 13 then
			if at <= 11 then
				helper_bc40()
			end
			return
		end
	end
	function part2()
		argc_3 = event.GetItemNum(224) or argc_3
		argc_4 = event.GetItemNum(245) or argc_4
		argc_5 = event.GetItemNum(227) or argc_5
		if argc_3 >= 20 and argc_4 >= 1 and argc_5 >= 2 then
			helper_19aa8(4)
			if vm.skipping() then
				return skip(5)
			end
			helper_bc40()
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
			event.LoadScript("i01h01/i01h01.stb", -1)
			return
		end
		argc = event.GetInventionId(165) or argc
		if argc ~= -1 then
			helper_19aa8(2)
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
			event.LoadScript("i01h01/i01h01.stb", -1)
			return
		end
		if argc == -1 then
			helper_19aa8(1)
			if vm.skipping() then
				return skip(11)
			end
			helper_bc40()
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
			event.LoadScript("i01h01/i01h01.stb", -1)
			return
		end
		event.SetFadeIn(30)
		if vm.wait() then
			return skip(14)
		end
		event.LoadScript("i01h01/i01h01.stb", -1)
	end
	function landing1()
		helper_bc40()
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
		event.LoadScript("i01h01/i01h01.stb", -1)
	end
	event.SetMotion(0, "立ち")
	event.SetFlag(21, 0)
	event.SetFadeOut(30)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_bdbc()
	argc_2 = event.GetItemNum(165) or argc_2
	if argc_2 >= 1 then
		helper_19aa8(5)
		if vm.skipping() then
			return skip(2)
		end
		helper_bc40()
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
		event.LoadScript("i01h01/i01h01.stb", -1)
		return
	end
	return part2()
end

return script
