--!strict
-- map/i/i01/h01/i01h01c.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_12d10110 = require("@lib/event/helper_12d10110")
local helper_4303896d = require("@lib/event/helper_4303896d")
local helper_5e67448e = require("@lib/event/helper_5e67448e")
local helper_774ccd87 = require("@lib/event/helper_774ccd87")
local helper_7baeb544 = require("@lib/event/helper_7baeb544")
local helper_c6c17732 = require("@lib/event/helper_c6c17732")
local helper_d5f09cbd = require("@lib/event/helper_d5f09cbd")
local helper_d764167e = require("@lib/event/helper_d764167e")
local helper_e42033a8 = require("@lib/event/helper_e42033a8")

--- Helper function.
local function helper_bdb4()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetAi(0, 24)
	event.CharaActive(0, 24)
end

--- Helper function.
local function helper_6cd4(arg0: s32)
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
local function helper_6a14(arg0: s32)
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
local function helper_6e2c(arg0: s32, arg1: any, arg2: any, arg3: s32)
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
				helper_6cd4(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_6a14(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_d764167e(arg0)
			return -1
		end
		helper_d764167e(arg0)
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
	helper_6cd4(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_6a14(arg0)
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
					helper_d764167e(arg0)
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
	helper_d764167e(arg0)
	return arg2
end

--- Helper function.
local function helper_7b44(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d5f09cbd(arg0, arg1, arg2, arg3, arg4)
			var8 = helper_6e2c(arg0, arg5, arg6, 0)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_d5f09cbd(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6e2c(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_d8e8(arg0: s32)
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_c6c17732()
			end
			if at <= 2 then
				helper_774ccd87(30)
			end
			if at <= 3 then
				helper_c6c17732()
			end
			if at <= 4 then
				helper_774ccd87(10)
			end
			if at <= 5 then
				helper_e42033a8(1060010)
			end
			if at <= 6 then
				var1 = helper_7b44(0, -1, 8, 0, 0, 2, 0)
			end
			if at <= 7 then
				helper_e42033a8(1060040)
			end
			if at <= 8 then
				helper_e42033a8(1060050)
			end
			if at <= 9 then
				helper_774ccd87(30)
			end
			return 1
		end
		if at <= 11 then
			helper_e42033a8(1060020)
		end
		if at <= 12 then
			helper_774ccd87(9)
		end
		if at <= 13 then
			helper_e42033a8(1060030)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	helper_c6c17732()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-26.93, 26.72, -145.82)
	event.CmrsSetRef(27.6, 22.54, -159.02)
	event.ObjsSetPos(0, 16.25, -0.02, -166.37)
	event.ObjsSetRot(0, 0.0, 1.16, 0.0)
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsSetPos(2, 38.77, -0.02, -147.68)
	event.ObjsSetRot(2, 0.0, -2.04, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_c6c17732()
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち")
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(2, "大口パク")
	helper_e42033a8(1060010)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "ＯＫ！！\nもう少し待って。")
	var1 = helper_7b44(0, -1, 8, 0, 0, 2, 0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesWindowMode(0, 7)
	event.SetMesShippo(0, 1)
	if var1 == 0 then
		helper_e42033a8(1060040)
		if vm.skipping() then
			return skip(8)
		end
		event.SndSePlay(arg0, 2)
		event.ObjsSetMotion(0, "ガッツポーズ", 6, -1.0, 1)
		event.ObjsNextMotion(0, "上見立ち", 4)
		event.ObjsSetMotion(2, "ガッツポーズ", 6)
		event.ObjsNextMotion(2, "立ち", 0)
		event.SetPakuAnim(2, "大口パク")
		helper_e42033a8(1060050)
		if vm.skipping() then
			return skip(9)
		end
		event.ResetPakuAnim()
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_774ccd87(30)
		if vm.skipping() then
			return skip(10)
		end
		return 1
	else
		event.ObjsSetMotion(0, "上見会話", 6, -1.0, 1)
		event.ObjsNextMotion(0, "上見立ち", 4)
		helper_774ccd87(9)
		if vm.skipping() then
			return skip(11)
		end
		helper_e42033a8(1060020)
		if vm.skipping() then
			return skip(12)
		end
		event.ObjsSetMotion(2, "会話2", 6)
		helper_774ccd87(9)
		if vm.skipping() then
			return skip(13)
		end
		event.SetPakuAnim(2, "大口パク")
		helper_e42033a8(1060030)
		if vm.skipping() then
			return skip(14)
		end
		event.ResetPakuAnim()
		return 0
	end
end

--- Helper function.
local function helper_e4a8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_774ccd87(30)
		end
		if at <= 2 then
			helper_774ccd87(45)
		end
		if at <= 3 then
			helper_774ccd87(45)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-98.46, 29.02, -221.77)
	event.CmrsSetRef(-133.84, 25.44, -219.86)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -143.53, -12.49, -220.28)
	event.ObjsSetRot(0, 0.0, 1.61, 0.0)
	event.ObjsSetPos(2, -79.25, -13.53, -223.34)
	event.ObjsSetRot(2, 0.0, -1.56, 0.0)
	event.ObjsSetPos(3, -143.53, -12.49, -220.28)
	event.ObjsSetRot(3, 0.0, 1.61, 0.0)
	event.ObjsResetMotion(0)
	event.ObjsResetMotion(3)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4, -1.0, 1)
	event.ObjsSetMotion(3, "立ち（スティーブ）", 4)
	event.SetFadeIn(30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_774ccd87(45)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(arg1, 6)
	event.SndSePlay(arg1, 8)
	event.EohSetFrameStatus(3, "light", arg0)
	helper_774ccd87(45)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_ea44(arg0: any)
	local projection: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_774ccd87(15)
		end
		if at <= 2 then
			helper_e42033a8(1060060)
		end
		if at <= 3 then
			helper_e42033a8(1060061)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-51.29, 55.13, -119.05)
	event.CmrsSetRef(-104.92, 14.85, -202.28)
	projection = event.GetProjection() or projection
	event.SetProjection(524.9)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -119.73, -13.05, -196.93)
	event.ObjsSetRot(0, 0.0, 1.49, 0.0)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -85.21, -13.05, -197.85)
	event.ObjsSetRot(2, 0.0, -1.68, 0.0)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -119.73, -13.05, -196.93)
	event.ObjsSetRot(3, 0.0, 1.49, 0.0)
	event.EohSetShow(11, 1)
	event.ObjsSetMotion(0, "下見立ち", 4)
	event.ObjsSetMotion(3, "下見立ち", 4)
	event.ObjsSetMotion(2, "上見立ち", 4)
	helper_774ccd87(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "上見会話", 6)
	event.ObjsNextMotion(2, "上見立ち", 0)
	event.SetPakuAnim(2, "大口パク")
	helper_e42033a8(1060060)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "大口パク")
	helper_e42033a8(1060061)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetProjection(projection)
end

--- Helper function.
local function helper_f11c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e42033a8(1060070)
		end
		if at <= 2 then
			helper_774ccd87(15)
		end
		if at <= 3 then
			helper_e42033a8(1060080)
		end
		if at <= 4 then
			helper_774ccd87(15)
		end
		if at <= 5 then
			helper_774ccd87(10)
		end
		if at <= 6 then
			helper_e42033a8(1060090)
		end
		if at <= 7 then
			helper_4303896d(0)
		end
		if at <= 8 then
			helper_4303896d(3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-93.2, 20.09, -139.75)
	event.CmrsSetRef(-109.87, 17.08, -226.98)
	event.ObjsResetMotion(1)
	event.ObjsResetMotion(3)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -119.73, -13.05, -196.93)
	event.ObjsSetRot(0, 0.0, 1.49, 0.0)
	event.ObjsResetMotion(0)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -85.21, -13.05, -197.85)
	event.ObjsSetRot(2, 0.0, -1.68, 0.0)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -119.73, -13.05, -196.93)
	event.ObjsSetRot(3, 0.0, 1.49, 0.0)
	event.ObjsResetMotion(3)
	event.EohSetShow(11, 0)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "下見立ち", 4)
	event.ObjsSetMotion(2, "上見立ち", 4)
	event.ObjsSetMotion(3, "うなづく", 6)
	event.ObjsNextMotion(3, "下見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_e42033a8(1060070)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_774ccd87(15)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(2, "上見会話2", 6)
	event.ObjsNextMotion(2, "上見立ち", 0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_e42033a8(1060080)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_774ccd87(15)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "まかせて", 6)
	event.ObjsNextMotion(0, "下見立ち", 4)
	event.ObjsSetMotion(3, "まかせて", 6)
	event.ObjsNextMotion(3, "下見立ち", 4)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_e42033a8(1060090)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_4303896d(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_4303896d(3)
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_fb2c(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_774ccd87(30)
		end
		if at <= 3 then
			helper_774ccd87(50)
		end
		if at <= 4 then
			var5 = 1.0
			var2 = vm.f32(132.00003)
			var3 = 120.0
			var4 = vm.f32(vm.fdiv(var2, var3))
			var6 = vm.f32(vm.f32(478.9) + vm.f32(var4 * var5))
		end
		var5 = vm.f32(var5 + 1.0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-120.59, 12.3, -121.56)
	event.CmrsSetRef(-121.3, 14.64, -178.67)
	event.GetProjection() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.SetProjection(478.9)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -128.93, -12.49, -206.0)
	event.ObjsSetRot(0, 0.0, 1.49, 0.0)
	event.CharaActive(1, 34)
	event.ObjsSetPos(2, -92.88, -13.05, -212.34)
	event.ObjsSetRot(2, 0.0, -1.44, 0.0)
	event.CharaActive(1, 35)
	event.ObjsSetPos(3, -128.93, -12.49, -206.0)
	event.ObjsSetRot(3, 0.0, 1.49, 0.0)
	event.EohSetShow(11, 0)
	if vm.wait() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsRotation(2, 0.0, -2.88, 0.0, 15)
	event.ObjsMotionDelay(2, 15)
	event.ObjsSetMotion(2, "上見立ち", 0)
	event.SndSePlay(arg0, 4)
	event.ObjsResetMotion(0)
	event.ObjsResetMotion(3)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(3, "歩き（スティーブ）", 4)
	event.ObjsRotation(0, 0.0, -3.11, 0.0, 30)
	event.ObjsRotation(3, 0.0, -3.11, 0.0, 30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）", 0)
	event.ObjsSetMotion(3, "立ち（スティーブ）", 0)
	event.SndSePlay(arg0, 5)
	event.ObjsRotation(12, 0.0, -1.57, 0.0, 50)
	event.ObjsRotation(13, 0.0, 1.57, 0.0, 50)
	helper_774ccd87(50)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.ObjsSetMotion(3, "歩き（スティーブ）", 4)
	event.ObjsMove(0, -125.29, -12.78, -310.13, 120)
	event.ObjsMove(3, -125.29, -12.78, -310.13, 120)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(70)
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	var5 = 1.0
	var2 = vm.f32(132.00003)
	var3 = 120.0
	var4 = vm.f32(vm.fdiv(var2, var3))
	while true do
		var6 = vm.f32(vm.f32(478.9) + vm.f32(var4 * var5))
		event.SetProjection(var6)
		if vm.wait() then
			return skip(5)
		end
		var5 = vm.f32(var5 + 1.0)
		if var5 > var3 then
			break
		end
	end
	event.SetProjection(var1)
end

--- Helper function.
local function helper_108e0()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				var0 = helper_d8e8(var2)
			end
			if at <= 2 then
				helper_e4a8(var1, var2)
			end
			if at <= 3 then
				helper_ea44(var2)
			end
			if at <= 4 then
				helper_f11c(var2)
			end
			if at <= 5 then
				helper_fb2c(var2)
			end
			if at <= 6 then
				helper_774ccd87(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		return var0
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var2, 6)
		event.SetProjection(projection)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.EohSetShow(10, 1)
		event.EohSetShow(11, 1)
		event.SetMotion(0, "立ち", 4)
		event.CharaActive(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(34)
		event.DeleteChara(35)
		if var0 ~= 1 then
			event.PlayBgm(0)
		end
		event.SetFadeIn(30)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(106, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var2 = event.SndLoadSound(1231) or var2
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
	event.LoadMotion(5, "event/e100/e106/e106_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "event/e100/e106/e106_starbre.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(1, 34)
	event.LoadChara(5, "event/e100/e106/e106_steve.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSetSoundId(3, var2)
	event.EohSyncObj(10, "p04_i01h01", "i01h01_05-m1")
	event.EohSyncObj(11, "p04_i01h01", "i01h01_05-m3")
	event.EohSyncObj(12, "p01_i01h01", "i01h01_21-m0")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(13, "p01_i01h01", "i01h01_21-m1")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.LoadMes(0, 5, "event/e100/e106/e106.txt")
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	var0 = helper_d8e8(var2)
	if vm.skipping() then
		return skip(2)
	end
	if var0 == 1 then
		event.DelExtMotion(0)
		event.LoadMotion(5, "event/e100/e106/e106_mints2.gltf", "info", 0)
		var1 = event.EohGetFrameStatus(3, "light") or var1
		event.EohSetFrameShow(3, "light", 0)
		projection = event.GetProjection() or projection
		event.InitDramaScene()
		helper_e4a8(var1, var2)
		if vm.skipping() then
			return skip(3)
		end
		helper_ea44(var2)
		if vm.skipping() then
			return skip(4)
		end
		helper_f11c(var2)
		if vm.skipping() then
			return skip(5)
		end
		event.EohSetSoundId(3, var2)
		helper_fb2c(var2)
		if vm.skipping() then
			return skip(6)
		end
	end
	event.SetFadeOut(30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_bc38()
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
local function helper_be70()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_bdb4()
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
local function helper_4b4()
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		argc_3 = event.GetNowLoopNo() or argc_3
		if argc_3 == 1 then
			event.GotoMenu(16)
			if vm.wait() then
				return skip(2)
			end
			return
		end
		if argc_3 == 2 then
			event.GotoMenu(17)
			if vm.wait() then
				return skip(3)
			end
			return
		end
	end
end

--- Helper function.
local function helper_117e0(arg0: s32)
	local var1: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4303896d(13)
		end
		if at <= 2 then
			helper_774ccd87(80)
		end
		if at <= 3 then
			helper_4303896d(0)
		end
		if at <= 4 then
			helper_4303896d(1)
		end
		if at <= 5 then
			helper_c6c17732()
		end
	end
	event.CmrsSetPos(-84.68, 6.96, -155.87)
	event.CmrsSetRef(-202.81, 27.8, -509.36)
	event.GetProjection() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.SetProjection(468.9)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -121.68, -12.53, -351.93)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -121.68, -12.53, -351.93)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetShow(10, 0)
	event.EohSetShow(11, 0)
	event.ObjsSetRot(12, 0.0, -1.57, 0.0)
	event.ObjsSetRot(13, 0.0, 1.57, 0.0)
	event.EohSetShow(14, 0)
	event.EohSetShow(15, 0)
	event.SetFadeOut(0)
	helper_4303896d(12)
	if vm.skipping() then
		return skip(1)
	end
	helper_4303896d(13)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 0)
	event.SetFadeIn(30)
	event.ObjsResetMotion(0)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsMove(0, -119.53, -12.53, -218.69, 100)
	event.ObjsMove(1, -119.53, -12.53, -218.69, 100)
	helper_774ccd87(80)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(arg0, 4)
	event.ObjsRotation(12, 0.0, 0.0, 0.0, 50)
	event.ObjsRotation(13, 0.0, 0.0, 0.0, 50)
	helper_4303896d(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(5)
	end
	helper_c6c17732()
	if vm.skipping() then
		return skip(6)
	end
	event.SetProjection(var1)
end

--- Helper function.
local function helper_12088(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_774ccd87(50)
		end
		if at <= 2 then
			helper_774ccd87(30)
		end
		if at <= 3 then
			helper_c6c17732()
		end
		if at <= 4 then
			helper_4303896d(0)
		end
		if at <= 5 then
			helper_4303896d(1)
		end
		if at <= 6 then
			helper_c6c17732()
		end
		if at <= 7 then
			helper_12d10110(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-119.36, 26.55, -129.41)
	event.CmrsSetRef(-121.06, 12.13, -226.83)
	event.ObjsSetPos(0, -119.53, -12.53, -229.18)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetPos(1, -119.53, -12.53, -229.18)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	helper_774ccd87(50)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSeStop(arg0, 0)
	event.SndSePlay(arg0, 5)
	event.ObjsResetMotion(0)
	event.ObjsResetMotion(1)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	helper_c6c17732()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-107.26, 10.75, -131.0)
	event.CmrsSetRef(-110.45, 11.92, -193.48)
	event.SetCharaPos(0, -91.97, -12.53, -211.57)
	event.SetCharaRot(0, 0.0, -2.4, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.SetCharaPos(33, -119.53, -12.53, -229.18)
	event.SetCharaRot(33, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(1)
	event.EohSetFrameShow(1, "light--c0appz0n1", 0)
	helper_4303896d(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsFadeInit()
	event.CmrsFadeIn(100, 0.0, 0.0, 0.0)
	helper_c6c17732()
	if vm.skipping() then
		return skip(7)
	end
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]ポルカスに再挑戦するなら\n   スティーブに(O)ボタンで\n   アクセスしてください。"
	)
	helper_12d10110(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetMesWindowMode(0, 7)
end

--- Helper function.
local function helper_129e4()
	local var0: s32 = 0
	local var1: s32 = 0
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_12088(var0)
			end
			if at <= 2 then
				helper_774ccd87(30)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.ObjsInit(0)
		event.ObjsInit(12)
		event.ObjsInit(13)
		event.SetFlag(56, 0)
		event.SetProjection(projection)
		event.SetCameraPos(-119.36, 26.55, -129.41)
		event.SetCameraRef(-121.06, 12.13, -226.83)
		event.SetCharaPos(0, -98.38, -12.53, -200.14)
		event.SetCharaRot(0, 0.0, -2.88, 0.0)
		event.EohSetRot(12, 0.0, 0.0, 0.0)
		event.EohSetRot(13, 0.0, 0.0, 0.0)
		if vm.wait() then
			return skip(5)
		end
		event.EohSetShow(10, 1)
		event.EohSetShow(11, 1)
		event.EohSetShow(14, 1)
		event.EohSetShow(15, 1)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(1822) or var0
	var1 = event.SndLoadSound(7, "snd2/chara/ch_040.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	projection = event.GetProjection() or projection
	event.GetCameraPos()
	event.GetCameraRef()
	event.LoadMotion(5, "event/e100/e108/e108_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 0.0, 50.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 33)
	event.CharaActive(1, 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(33, 0.0, 50.0, 0.0)
	event.SetCharaRot(33, 0.0, 0.0, 0.0)
	event.EohSetSoundId(1, var1)
	event.EohSyncObj(10, "p04_i01h01", "i01h01_05-m1")
	event.EohSyncObj(11, "p04_i01h01", "i01h01_05-m3")
	event.EohSyncObj(12, "p01_i01h01", "i01h01_21-m0")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(13, "p01_i01h01", "i01h01_21-m1")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.EohSyncObj(14, "p07_i01h01", "i01h01_08-m0")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSyncObj(15, "p07_i01h01", "i01h01_08-m1")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	helper_117e0(var0)
	if vm.skipping() then
		return skip(1)
	end
	helper_12088(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_13918(arg0: any)
	local var1: any = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_774ccd87(30)
		end
		if at <= 2 then
			helper_c6c17732()
		end
		return 1
	end
	event.CmrsSetPos(-138.16, 13.17, -131.29)
	event.CmrsSetRef(-115.98, 11.22, -208.05)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -98.38, -12.53, -200.14)
	event.ObjsSetRot(0, 0.0, -2.88, 0.0)
	event.CharaActive(1, 33)
	event.ObjsSetPos(1, -119.53, -12.53, -229.18)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(1)
	event.EohSetShow(10, 0)
	event.EohSetShow(11, 0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	var2 = event.GetMesWindowMode(0) or var2
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "よし！ポルカスに再挑戦だ。\nもう少し準備がたりない。")
	var1 = helper_7b44(0, -1, 8, 0, 0, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, var2)
	if var1 == 0 then
		event.CmrsFadeInit()
		event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
		helper_774ccd87(30)
		if vm.skipping() then
			return skip(2)
		end
		helper_c6c17732()
		if vm.skipping() then
			return skip(3)
		end
		if vm.wait() then
			return skip(4)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_13f90(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c6c17732()
		end
		if at <= 2 then
			helper_4303896d(0)
		end
		if at <= 3 then
			helper_4303896d(1)
		end
		if at <= 4 then
			helper_774ccd87(50)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-120.34, 23.49, -175.84)
	event.CmrsSetRef(-120.44, 21.93, -203.94)
	event.ObjsSetPos(0, -119.53, -12.53, -229.18)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetPos(1, -119.53, -12.53, -229.18)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.CmrsFadeInit()
	event.CmrsFadeIn(50, 0.0, 0.0, 0.0)
	helper_c6c17732()
	if vm.skipping() then
		return skip(2)
	end
	helper_4303896d(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(arg0, 1)
	helper_774ccd87(50)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_14418(arg0: s32)
	local projection: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4303896d(0)
		end
		if at <= 2 then
			helper_4303896d(1)
		end
		if at <= 3 then
			helper_4303896d(0)
		end
		if at <= 4 then
			helper_4303896d(1)
		end
		if at <= 5 then
			helper_4303896d(12)
		end
		if at <= 6 then
			helper_4303896d(13)
		end
		if at <= 7 then
			var4 = 150.0
			var5 = 1.0
			var2 = vm.f32(vm.fdiv(vm.f32(107.00003), var4))
			var3 = vm.f32(var2 * var5)
			var3 = vm.f32(vm.f32(417.9) + var3)
		end
		if at <= 8 then
			var5 = vm.f32(var5 + 1.0)
			helper_4303896d(0)
		end
		if at <= 9 then
			helper_4303896d(1)
		end
		if at <= 10 then
			helper_c6c17732()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-118.58, 15.3, -131.62)
	event.CmrsSetRef(-119.04, 14.32, -218.31)
	projection = event.GetProjection() or projection
	event.SetProjection(417.9)
	event.ObjsSetPos(0, -119.53, -12.53, -229.18)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetPos(1, -119.53, -12.53, -229.18)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.ObjsSetMotion(0, "歩き（スティーブ）")
	event.ObjsSetMotion(1, "歩き（スティーブ）")
	event.ObjsRotation(0, 0.0, 3.14, 0.0, 50)
	event.ObjsRotation(1, 0.0, 3.14, 0.0, 50)
	helper_4303896d(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）")
	event.ObjsSetMotion(1, "立ち（スティーブ）")
	helper_4303896d(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(arg0, 0)
	event.ObjsRotation(12, 0.0, -1.57, 0.0, 50)
	event.ObjsRotation(13, 0.0, 1.57, 0.0, 50)
	helper_4303896d(12)
	if vm.skipping() then
		return skip(6)
	end
	helper_4303896d(13)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsFadeInit()
	event.CmrsFadeDelay(100)
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 0)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 0)
	event.ObjsMove(0, -119.23, -12.53, -333.8, 150)
	event.ObjsMove(1, -119.23, -12.53, -333.8, 150)
	event.CmrsMove(-118.7, 15.3, -153.91, -119.04, 14.32, -218.31, 150)
	var4 = 150.0
	var5 = 1.0
	var2 = vm.f32(vm.fdiv(vm.f32(107.00003), var4))
	while true do
		var3 = vm.f32(var2 * var5)
		var3 = vm.f32(vm.f32(417.9) + var3)
		event.SetProjection(var3)
		if vm.wait() then
			return skip(8)
		end
		var5 = vm.f32(var5 + 1.0)
		if var5 > var4 then
			break
		end
	end
	helper_4303896d(0)
	if vm.skipping() then
		return skip(9)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(10)
	end
	helper_c6c17732()
	if vm.skipping() then
		return skip(11)
	end
	event.SetProjection(projection)
end

--- Helper function.
local function helper_15078()
	local var0: s32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_13f90(var0)
			end
			if at <= 2 then
				helper_14418(var0)
			end
			if at <= 3 then
				helper_774ccd87(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		return var8
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		event.EohSetShow(10, 1)
		event.EohSetShow(11, 1)
		event.GetProjection() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
		event.GetCameraPos() -- retail: argument 1 is a value where the handler writes an output; the output is discarded; argument 2 is a value where the handler writes an output; the output is discarded; argument 3 is a value where the handler writes an output; the output is discarded
		event.GetCameraRef() -- retail: argument 1 is a value where the handler writes an output; the output is discarded; argument 2 is a value where the handler writes an output; the output is discarded; argument 3 is a value where the handler writes an output; the output is discarded
		if vm.wait() then
			return skip(6)
		end
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.SetFadeIn(30)
		return var8
	end
	event.CharaActive(0, 24)
	event.SetFlag(108, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(1237)
	var0 = event.SndLoadSound(1237) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetProjection()
	event.GetCameraPos()
	event.GetCameraRef()
	event.CmrsInit()
	event.SetCameraPos(6.02, 94.24, 399.23)
	event.SetCameraRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e108/e108_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 0.0, 50.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 33)
	event.CharaActive(1, 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(33, 0.0, 50.0, 0.0)
	event.SetCharaRot(33, 0.0, 0.0, 0.0)
	event.EohSetSoundId(1, var0)
	event.EohSyncObj(10, "p04_i01h01", "i01h01_05-m1")
	event.EohSyncObj(11, "p04_i01h01", "i01h01_05-m3")
	event.EohSyncObj(12, "p01_i01h01", "i01h01_21-m0")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.ObjsSetRot(12, 0.0, 0.0, 0.0)
	event.EohSyncObj(13, "p01_i01h01", "i01h01_21-m1")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.ObjsSetRot(13, 0.0, 0.0, 0.0)
	event.EohSyncObj(14, "p07_i01h01", "i01h01_08-m0")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSyncObj(15, "p07_i01h01", "i01h01_08-m1")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	var8 = helper_13918(var0)
	if vm.skipping() then
		return skip(1)
	end
	if var8 == 1 then
		event.InitDramaScene()
		helper_13f90(var0)
		if vm.skipping() then
			return skip(2)
		end
		helper_14418(var0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetFlag(56, 1)
	else
		event.SetFlag(56, 0)
	end
	event.SetFadeOut(30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_bf4(arg0: f32, arg1: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 > arg1 then
		return arg0
	else
		return arg1
	end
end

--- Helper function.
local function helper_a10(arg0: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(-1.0 * arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 < 0 then
		return vm.f32(-1.0 * arg0)
	else
		return arg0
	end
end

--- Helper function.
local function helper_19fc(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
end

--- Helper function.
local function helper_8fcc(arg0: s32, arg1: any, arg2: any)
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
			var34 = vm.f32(helper_bf4(helper_a10(angle), helper_a10(angle_2)) * 8.0)
			var35 = helper_19fc(0.0, angle, var33, var34)
			var35 = vm.f32(var35 + var27)
			var36 = helper_19fc(0.0, angle_2, var33, var34)
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
	var34 = vm.f32(helper_bf4(helper_a10(angle), helper_a10(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_19fc(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_19fc(0.0, angle_2, var33, var34)
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
local function helper_a500(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8fcc(player_chara, arg0, arg1)
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
	helper_8fcc(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

--- Helper function.
local function helper_2bfc(arg0: any, arg1: any, arg2: any, arg3: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.SetMesPos(arg0, 0)
	event.MesMake_2(arg0, arg1)
	event.SetMesAutoset(arg0, arg2, arg3)
end

--- Helper function.
local function helper_80e8(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2bfc(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_7baeb544(arg0, 0, var5)
		end
		helper_d764167e(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_2bfc(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_7baeb544(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_d764167e(arg0)
end

--- Helper function.
local function helper_9d5c(arg0: any, arg1: f32)
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
			var13 = helper_19fc(0.0, angle, var14, var15)
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
		var13 = helper_19fc(0.0, angle, var14, var15)
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
local function helper_a670(arg0: any, arg1: f32, arg2: any, arg3: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9d5c(arg0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 ~= 0 then
		helper_9d5c(arg0, arg1)
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
local function helper_a7c0(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_a500(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_80e8(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_a670(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_a500(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_80e8(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_a670(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_c0a4(arg0: s32, arg1: any)
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
				helper_774ccd87(9)
			end
			if at <= 2 then
				helper_5e67448e(0, 1)
				helper_a500(arg0, 0, 0)
			end
			if at <= 3 then
				helper_80e8(0, -1, arg0, player_chara, 0)
			end
			if at <= 4 then
				var5 = helper_7b44(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 5 then
				helper_80e8(0, -1, arg0, player_chara, 0)
			end
			if at <= 6 then
				helper_774ccd87(30)
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
			helper_a7c0(arg0, -1, 0, 0)
		end
		if at <= 19 then
			helper_a7c0(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち", 0)
	helper_774ccd87(9)
	if vm.skipping() then
		return skip(2)
	end
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		helper_5e67448e(0, 1)
		helper_a500(arg0, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "スティーブの調子はどうじゃ？")
		helper_80e8(0, -1, arg0, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "ねんりょう補給\nコアのパワーアップ")
		var5 = helper_7b44(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var5 == 0 then
			event.SetSavedataEtc(2)
			event.MesMake_2(0, "よし、これで\n修理完了じゃ！")
			helper_80e8(0, -1, arg0, player_chara, 0)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var5 == 1 then
			event.SetFadeOut(25)
			helper_774ccd87(30)
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
		helper_a7c0(arg0, -1, 0, 0)
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
		helper_a7c0(arg0, -1, 0, 0)
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
		helper_a7c0(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(17)
		end
		return
	end
	event.SetAi(0, 24)
	event.MesMake_2(0, "まずは自分の力で、\nやってみるのじゃ。")
	helper_a7c0(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.MesMake_2(0, "どうしても解らなければ、\nヒントをだしてやる。")
	helper_a7c0(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.MesMake_2(0, "さあ、行け！")
	helper_a7c0(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.SetAi(1, 24)
end

--- Helper function.
local function helper_d594()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("[talk_chara]", var1, "\n")
			print("[talk_chara_id]", var1, "\n")
			helper_c0a4(var0, var1)
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
		helper_c0a4(var0, var1)
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

--- Program 151.
script[151] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bdb4()
			var0 = helper_108e0()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 3 then
			helper_774ccd87(30)
		end
		if at <= 4 then
			helper_bc38()
		end
	end
	function part2()
		if var0 == 1 then
			event.AddItem(135, 1)
			event.AddItem(145, 1)
			event.AddItem(155, 1)
			event.AddItem(165, 1)
			if vm.wait() then
				return skip(3)
			end
			argc = event.GetItemNum(246) or argc
			if argc == 0 then
				event.AddItem(246, 1)
			end
			event.ExtTyped(1078, "ii", 2, 1)
			event.SetCharaChangeFlag(2, 1)
			event.SetCharaChangeMask(2, 1)
			event.SetCharaChangeMask(0, 1)
			event.SetFlag(25, 1)
			event.SetFadeOut(30)
			helper_774ccd87(30)
			if vm.skipping() then
				return skip(4)
			end
			event.SetFadeIn(30)
		else
			helper_bc38()
			event.SetCharaPos(0, 16.25, -0.02, -166.37)
			event.SetCharaRot(0, 0.0, 1.16, 0.0)
			event.SetMotion(0, "立ち")
			event.SetCharaPos(24, 38.77, -0.02, -147.68)
			event.SetCharaRot(24, 0.0, -2.04, 0.0)
			event.SetMotion(24, "立ち")
			if vm.wait() then
				return skip(5)
			end
			event.LoadScript("i01h01/i01h01.stb", -1)
		end
	end
	event.SetFadeOut(10)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(1)
	end
	helper_bdb4()
	var0 = helper_108e0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_be70()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_bdb4()
				var0 = helper_108e0()
				if not vm.skipping() then
					return part2()
				end
			end
			if at <= 3 then
				helper_774ccd87(30)
			end
			if at <= 4 then
				helper_4b4()
			end
			return
		end
	end
	function part2()
		if var0 == 1 then
			argc = event.GetItemNum(246) or argc
			if argc <= 0 then
				event.AddItem(135, 1)
				event.AddItem(145, 1)
				event.AddItem(155, 1)
				event.AddItem(165, 1)
				if vm.wait() then
					return skip(3)
				end
				event.AddItem(246, 1)
			end
			event.ExtTyped(1078, "ii", 2, 1)
			event.SetCharaChangeFlag(2, 1)
			event.SetCharaChangeMask(2, 1)
			event.SetCharaChangeMask(0, 1)
			event.SetFlag(25, 1)
			event.SetFadeOut(30)
			helper_774ccd87(30)
			if vm.skipping() then
				return skip(4)
			end
			helper_4b4()
			if vm.skipping() then
				return skip(5)
			end
			event.BgmLoadCancel()
			event.GotoDng(0, 4, 520)
			if vm.wait() then
				return skip(6)
			end
			return
		else
			helper_bc38()
			event.SetCharaPos(0, 16.25, -0.02, -166.37)
			event.SetCharaRot(0, 0.0, 1.16, 0.0)
			event.SetMotion(0, "立ち")
			event.SetCharaPos(24, 38.77, -0.02, -147.68)
			event.SetCharaRot(24, 0.0, -2.04, 0.0)
			event.SetMotion(24, "立ち")
			if vm.wait() then
				return skip(7)
			end
			event.LoadScript("i01h01/i01h01.stb", -1)
		end
	end
	event.SetFadeOut(10)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(1)
	end
	helper_bdb4()
	var0 = helper_108e0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_774ccd87(30)
		end
	end
	helper_bdb4()
	event.CharaActive(0, 26)
	event.CharaActive(0, 25)
	helper_129e4()
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 25)
	event.Initialize()
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.CharaActive(1, 25)
	event.CharaActive(1, 26)
	event.SetReference(25, "back", 26)
	event.ExtTyped(1078, "ii", 2, 0)
	event.FuncPointShow("", "fc_event_e108c", 1)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.LoadScript("i01h01/i01h01.stb", -1)
end

--- Program 520.
script[520] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_bdb4()
	event.CharaActive(0, 25)
	event.CharaActive(0, 26)
	var0 = helper_15078()
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 1 then
		event.SetFlag(25, 1)
		event.ExtTyped(1078, "ii", 2, 1)
		event.BgmLoadCancel()
		event.GotoDng(0, 4, 520)
	else
		event.SetFlag(29, 1)
		event.CharaActive(1, 25)
		event.CharaActive(1, 26)
		event.FuncPointShow("", "fc_event_e108c", 1)
		if vm.wait() then
			return skip(2)
		end
		event.LoadScript("i01h01/i01h01.stb", -1)
		return
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d594()
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	helper_d594()
	if vm.skipping() then
		return skip(2)
	end
end

return script
