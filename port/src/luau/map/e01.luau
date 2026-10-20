--!strict
-- map/e01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_39cc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		var0 = event.CmrsCheck() or var0
		if var0 == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_60(arg0: any)
	local get_pad_down: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	get_pad_down = event.GetPaddown() or get_pad_down
	if arg0 < 0 then
		return 1
	end
	event.CheckMes(arg0)
	var2 = event.CheckMesComplete(arg0) or var2
	var3 = event.CheckMesWait(arg0) or var3
	if bit32.band(get_pad_down, 32) ~= 0 then
		if var3 ~= 0 then
			event.MesNextpage(arg0)
		end
		if var2 ~= 0 then
			event.MesClose(arg0)
			return 1
		end
		if var3 == 0 and var2 == 0 then
			print(var3, " ", var2, "***\n")
			event.SetMesDrawspeed(arg0, 0.0)
		end
	end
	return 0
end

--- Helper function.
local function helper_2430(arg0: any)
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
			var1 = helper_60(arg0)
		end
		if at <= 2 then
			var2 = vm.i32(var2 + 1)
		end
		var2 = vm.i32(var2 + 1)
		return var2
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = 0
	while true do
		var1 = helper_60(arg0)
		if var1 ~= 0 then
			if vm.wait() then
				return skip(2)
			end
			var2 = vm.i32(var2 + 1)
			break
		else
			if vm.wait() then
				return skip(3)
			end
			var2 = vm.i32(var2 + 1)
		end
	end
	return var2
end

--- Helper function.
local function helper_28e0(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2430(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(arg0, arg1)
	event.SetMesPos(arg0, arg2)
	event.SetMesAutoset(arg0, arg3, arg4, arg3, arg4)
	local _ = helper_2430(arg0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
end

--- Helper function.
local function helper_3aec(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		var1 = event.ObjsCheck(arg0) or var1
		if var1 == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_21f0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			var2 = helper_60(arg0)
		end
		if at <= 2 then
			var3 = var3 + 1
		end
		var3 = vm.i32(var3 + 1)
		return var3
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = 0
	while var3 < arg1 do
		var2 = helper_60(arg0)
		if var2 ~= 0 then
			if vm.wait() then
				return skip(2)
			end
			var3 = var3 + 1
			break
		else
			if vm.wait() then
				return skip(3)
			end
			var3 = var3 + 1
		end
	end
	event.MesClose(0)
	return var3
end

--- Helper function.
local function helper_2730(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_21f0(arg0, arg5)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(arg0, arg1)
	event.SetMesPos(arg0, arg2)
	event.SetMesAutoset(arg0, arg3, arg4, arg3, arg4)
	local _ = helper_21f0(arg0, arg5)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
end

--- Helper function.
local function helper_39c(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg0 = vm.wrap(arg0 - 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while arg0 >= 0 do
		arg0 = arg0 - 1
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_4b0(arg0: s32)
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
local function helper_570(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_4b0(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_4b0(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_4ef0()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_28e0(0, 3010, 8, 0, 0)
		end
		if at <= 2 then
			helper_28e0(0, 3020, 8, 0, 0)
		end
		if at <= 3 then
			helper_28e0(0, 3030, 8, 0, 0)
		end
		if at <= 4 then
			helper_3aec(0)
		end
		if at <= 5 then
			helper_2730(0, 3040, 8, 0, 0, 200)
		end
		if at <= 6 then
			helper_3aec(0)
		end
		if at <= 7 then
			helper_3aec(0)
		end
		if at <= 8 then
			helper_3aec(0)
		end
		if at <= 9 then
			helper_39cc()
		end
		if at <= 10 then
			helper_39c(30)
		end
		if at <= 11 then
			helper_3aec(0)
		end
		if at <= 12 then
			helper_28e0(0, 3050, 8, 0, 0)
		end
		if at <= 13 then
			helper_28e0(0, 3080, 8, 0, 0)
		end
		if at <= 14 then
			helper_3aec(1)
		end
		if at <= 15 then
			helper_28e0(0, 3090, 8, 0, 0)
		end
		if at <= 16 then
			helper_3aec(1)
		end
		if at <= 17 then
			helper_3aec(2)
		end
		if at <= 18 then
			helper_28e0(0, 3100, 8, 0, 0)
		end
		if at <= 19 then
			helper_28e0(0, 3110, 8, 0, 0)
		end
		if at <= 20 then
			helper_28e0(0, 3120, 8, 0, 0)
		end
		if at <= 21 then
			helper_28e0(0, 3130, 8, 0, 0)
		end
		if at <= 22 then
			helper_3aec(1)
		end
		if at <= 23 then
			helper_28e0(0, 3140, 8, 0, 0)
		end
		if at <= 24 then
			helper_28e0(0, 3150, 8, 0, 0)
		end
		if at <= 25 then
			helper_39c(15)
		end
		if at <= 26 then
			helper_2730(0, 3160, 8, 0, 0, 60)
		end
		if at <= 27 then
			helper_39c(60)
		end
		if at <= 28 then
			helper_3aec(1)
		end
		if at <= 29 then
			helper_28e0(0, 3170, 8, 0, 0)
		end
		if at <= 30 then
			helper_39c(60)
		end
		if at <= 31 then
			helper_28e0(0, 3180, 8, 0, 0)
		end
		if at <= 32 then
			helper_3aec(1)
		end
		if at <= 33 then
			helper_28e0(0, 3190, 8, 0, 0)
		end
		if at <= 34 then
			helper_3aec(1)
		end
		if at <= 35 then
			helper_28e0(0, 3200, 8, 0, 0)
		end
		if at <= 36 then
			helper_39cc()
		end
		if at <= 37 then
			helper_28e0(0, 3210, 8, 0, 0)
		end
		if at <= 38 then
			helper_3aec(1)
		end
		if at <= 39 then
			helper_28e0(0, 3220, 8, 0, 0)
		end
		if at <= 40 then
			helper_28e0(0, 3230, 8, 0, 0)
		end
		if at <= 41 then
			helper_3aec(1)
		end
		if at <= 42 then
			helper_39c(30)
		end
		if at <= 43 then
			helper_28e0(0, 3240, 8, 0, 0)
		end
		if at <= 44 then
			helper_39c(60)
		end
		if at <= 45 then
			helper_28e0(0, 3250, 8, 0, 0)
		end
		if at <= 46 then
			helper_28e0(0, 3260, 8, 0, 0)
		end
		if at <= 47 then
			helper_28e0(0, 3270, 8, 0, 0)
		end
		if at <= 48 then
			helper_3aec(0)
		end
		if at <= 49 then
			helper_3aec(0)
		end
		if at <= 50 then
			helper_39c(30)
		end
		if at <= 51 then
			helper_28e0(0, 3280, 8, 0, 0)
		end
		if at <= 52 then
			helper_39c(3)
		end
		if at <= 53 then
			helper_39c(4)
		end
		if at <= 54 then
			helper_39c(5)
		end
		if at <= 55 then
			helper_39c(5)
		end
		if at <= 56 then
			helper_570(32)
		end
		if at <= 57 then
			helper_39c(25)
		end
		if at <= 58 then
			helper_39c(3)
		end
		if at <= 59 then
			helper_39c(6)
		end
		if at <= 60 then
			helper_39c(2)
		end
		if at <= 61 then
			helper_3aec(3)
		end
		if at <= 62 then
			helper_3aec(4)
		end
		if at <= 63 then
			helper_3aec(5)
		end
		if at <= 64 then
			helper_3aec(6)
		end
		if at <= 65 then
			helper_39c(30)
		end
		if at <= 66 then
			helper_28e0(0, 3290, 8, 0, 0)
		end
		if at <= 67 then
			helper_39cc()
		end
		if at <= 68 then
			helper_28e0(0, 3300, 8, 0, 0)
		end
		if at <= 69 then
			helper_39c(5)
		end
		if at <= 70 then
			helper_39c(3)
		end
		if at <= 71 then
			helper_39c(1)
		end
		if at <= 72 then
			helper_3aec(3)
		end
		if at <= 73 then
			helper_3aec(4)
		end
		if at <= 74 then
			helper_3aec(5)
		end
		if at <= 75 then
			helper_3aec(6)
		end
		if at <= 76 then
			helper_39c(20)
		end
		if at <= 77 then
			helper_39c(36)
		end
		if at <= 78 then
			helper_39c(20)
		end
		if at <= 79 then
			helper_39c(83)
		end
		if at <= 80 then
			helper_39c(42)
		end
		if at <= 81 then
			helper_3aec(4)
		end
		if at <= 82 then
			helper_39cc()
		end
		if at <= 83 then
			helper_39cc()
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.CharaActive(0, 0)
	event.ClearStack(4)
	event.AssignStack(4)
	event.ClearStack(5)
	event.AssignStack(5)
	event.LoadChara(5, "event/i03/i03h02/c01b_kihon.chr", "info", 8)
	event.LoadMotion(5, "event/i03/i03h02/p3_mints.chr", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 515.79, 133.45, -51.32)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetMotion(0, "左を向く_s", 4)
	event.LoadChara(5, "event/i03/i03h02/p3_polcurse.chr", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 403.49, 0.0, 348.3)
	event.ObjsSetRot(1, 0.0, 1.5, 0.0)
	event.ObjsSetMotion(1, "つつく_s", 4)
	event.LoadChara(5, "event/i03/i03h02/p3_need.chr", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 403.49, 0.0, 348.3)
	event.ObjsSetRot(2, 0.0, 1.5, 0.0)
	event.ObjsSetMotion(2, "つつく_s", 4)
	event.LoadChara(5, "event/i03/i03h02/p3_pierrot.chr", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.EohSetFrameShow(3, "obj10", 0)
	event.EohSetFrameShow(3, "obj11", 0)
	event.EohSetFrameShow(3, "obj6", 0)
	event.EohSetFrameShow(3, "obj4", 0)
	event.EohSetShadow(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 308.7, -100.0, 243.42)
	event.ObjsSetRot(3, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.LoadChara(5, "event/i03/i03h02/p3_pierrot.chr", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(4, 12)
	event.EohSetFrameShow(4, "obj10", 0)
	event.EohSetFrameShow(4, "obj11", 0)
	event.EohSetFrameShow(4, "obj6", 0)
	event.EohSetFrameShow(4, "obj4", 0)
	event.EohSetShadow(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 308.7, -100.0, 243.42)
	event.ObjsSetRot(4, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.LoadChara(5, "event/i03/i03h02/p3_pierrot.chr", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(5, 13)
	event.EohSetFrameShow(5, "obj10", 0)
	event.EohSetFrameShow(5, "obj11", 0)
	event.EohSetFrameShow(5, "obj6", 0)
	event.EohSetFrameShow(5, "obj4", 0)
	event.EohSetShadow(5, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 308.7, -100.0, 243.42)
	event.ObjsSetRot(5, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(5, "立ち", 4)
	event.LoadChara(5, "event/i03/i03h02/p3_pierrot.chr", "info", 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(6, 14)
	event.EohSetFrameShow(6, "obj10", 0)
	event.EohSetFrameShow(6, "obj11", 0)
	event.EohSetFrameShow(6, "obj6", 0)
	event.EohSetFrameShow(6, "obj4", 0)
	event.EohSetShadow(6, 0)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 308.7, -100.0, 243.42)
	event.ObjsSetRot(6, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(6, "立ち", 4)
	event.EohSyncObj(7, "p04_i03h02a-3")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 1.392, 0.0)
	event.EohSyncObj(8, "p04_i03h02a-3", "i03h02a_09-m")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.ObjsSetRot(8, 0.0, 0.0, 0.0)
	event.EohSyncObj(9, "p04_i03h02a-3", "i03h02a_09-m1")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.ObjsSetRot(9, 0.0, 0.0, 0.0)
	event.EohSyncObj(10, "p04_i03h02a-1")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetRot(10, 0.0, -2.118, 0.0)
	event.EohSyncObj(11, "p04_i03h02a-1", "i03h02a_09-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.ObjsSetRot(11, 0.0, 0.0, 0.0)
	event.EohSyncObj(12, "p04_i03h02a-1", "i03h02a_09-m1")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.ObjsSetRot(12, 0.0, 0.0, 0.0)
	event.EohSyncObj(13, "p04_i03h02a-4")
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.ObjsSetRot(13, 0.0, 0.592, 0.0)
	event.EohSyncObj(14, "p04_i03h02a-4", "i03h02a_09-m")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.ObjsSetRot(14, 0.0, 0.0, 0.0)
	event.EohSyncObj(15, "p04_i03h02a-4", "i03h02a_09-m1")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.ObjsSetRot(15, 0.0, 0.0, 0.0)
	event.EohSyncObj(16, "p04_i03h02a-7")
	event.ObjsInit(16)
	event.ObjsSyncObj(16, 16)
	event.EohSyncObj(17, "p04_i03h02a-7", "i03h02a_09-m")
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 17)
	event.ObjsSetRot(17, 0.0, 0.0, 0.0)
	event.EohSyncObj(18, "p04_i03h02a-7", "i03h02a_09-m1")
	event.ObjsInit(18)
	event.ObjsSyncObj(18, 18)
	event.ObjsSetRot(18, 0.0, 0.0, 0.0)
	event.EohSyncObj(19, "p04_i03h02a-5")
	event.ObjsInit(19)
	event.ObjsSyncObj(19, 19)
	event.EohSyncObj(20, "p04_i03h02a-5", "i03h02a_09-m")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ObjsSetRot(20, 0.0, 0.0, 0.0)
	event.EohSyncObj(21, "p04_i03h02a-5", "i03h02a_09-m1")
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	event.ObjsSetRot(21, 0.0, 0.0, 0.0)
	event.EohSyncObj(22, "p04_i03h02a-6")
	event.ObjsInit(22)
	event.ObjsSyncObj(22, 22)
	event.EohSyncObj(23, "p04_i03h02a-6", "i03h02a_09-m")
	event.ObjsInit(23)
	event.ObjsSyncObj(23, 23)
	event.ObjsSetRot(23, 0.0, 0.0, 0.0)
	event.EohSyncObj(24, "p04_i03h02a-6", "i03h02a_09-m1")
	event.ObjsInit(24)
	event.ObjsSyncObj(24, 24)
	event.ObjsSetRot(24, 0.0, 0.0, 0.0)
	event.EohSyncObj(25, "p04_i03h02a-2")
	event.ObjsInit(25)
	event.ObjsSyncObj(25, 25)
	event.EohSyncObj(26, "p04_i03h02a-2", "i03h02a_09-m")
	event.ObjsInit(26)
	event.ObjsSyncObj(26, 26)
	event.ObjsSetRot(26, 0.0, 0.0, 0.0)
	event.EohSyncObj(27, "p04_i03h02a-2", "i03h02a_09-m1")
	event.ObjsInit(27)
	event.ObjsSyncObj(27, 27)
	event.ObjsSetRot(27, 0.0, 0.0, 0.0)
	event.EohSyncObj(28, "p10_i03h02a-3")
	event.EohSetShow(28, 1)
	event.ObjsInit(28)
	event.ObjsSyncObj(28, 28)
	event.SetMarker(60)
	event.CmrsInit()
	event.CmrsSetPos(471.26, 147.58, -83.77)
	event.CmrsSetRef(518.02, 153.97, -45.82)
	event.CmrsFadeInit()
	event.CmrsFadeIn(120)
	helper_39cc()
	if vm.skipping() then
		return skip(1)
	end
	helper_28e0(0, 3010, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSeqMotTrg(0)
	helper_28e0(0, 3020, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSeqMotTrgWait(0)
	event.ObjsSeqMotTrg(0)
	event.ObjsMotionWait(0)
	helper_28e0(0, 3030, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_3aec(0)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(464.23, 209.09, -140.38)
	event.CmrsSetRef(528.52, 167.88, -34.23)
	event.ObjsSetMotion(0, "歩き", 4)
	helper_2730(0, 3040, 8, 0, 0, 200)
	if vm.skipping() then
		return skip(6)
	end
	helper_3aec(0)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(611.3, 208.49, 366.39)
	event.CmrsSetRef(572.65, 156.22, 246.87)
	event.ObjsSetPos(0, 576.02, 133.45, 143.2)
	event.ObjsSetRot(0, 0.0, -0.29, 0.0)
	event.ObjsSetMotion(0, "きょろきょろ歩き", 4)
	helper_3aec(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(574.34, 203.79, 190.06)
	event.CmrsSetRef(543.29, 142.99, 227.79)
	event.CmrsMove(557.65, 203.79, 250.72, 526.69, 142.99, 288.12, 180)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetPos(0, 547.89, 133.45, 215.23)
	event.ObjsSetRot(0, 0.0, -0.29, 0.0)
	event.ObjsMove(0, 534.64, 133.45, 265.0, 90)
	helper_3aec(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "立ち", 2)
	event.ObjsNextMotion(0, "のぞく_s")
	helper_39cc()
	if vm.skipping() then
		return skip(10)
	end
	helper_39c(30)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSeqMotTrgWait(0)
	event.ObjsSeqMotTrg(0)
	helper_3aec(0)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(517.75, 143.82, 286.48)
	event.CmrsSetRef(532.99, 156.31, 270.93)
	helper_28e0(0, 3050, 8, 0, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.EohSetShadow(0, 0)
	event.CmrsSetPos(318.23, 170.94, 487.51)
	event.CmrsSetRef(414.66, 165.51, 406.31)
	event.ObjsSeqMotTrg(0)
	event.CmrsSetPos(443.82, 30.29, 368.2)
	event.CmrsSetRef(405.19, 24.85, 336.85)
	event.ObjsSeqMotTrg(1)
	event.ObjsSeqMotTrg(2)
	helper_28e0(0, 3080, 8, 0, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSeqMotTrgWait(1)
	helper_3aec(1)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSeqMotTrg(1)
	event.ObjsSeqMotTrg(2)
	helper_28e0(0, 3090, 8, 0, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSeqMotTrgWait(1)
	helper_3aec(1)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSeqMotTrg(1)
	event.ObjsSeqMotTrg(2)
	event.ObjsMotionWait(2)
	helper_3aec(2)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(408.45, 24.17, 357.28)
	event.CmrsSetRef(431.13, 26.09, 350.29)
	event.ObjsSetMotion(2, "会話")
	helper_28e0(0, 3100, 8, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(382.77, 29.94, 373.27)
	event.CmrsSetRef(425.01, 23.0, 337.65)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSeqMotTrg(1)
	helper_28e0(0, 3110, 8, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "会話")
	helper_28e0(0, 3120, 8, 0, 0)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSeqMotTrg(1)
	helper_28e0(0, 3130, 8, 0, 0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsMotionWait(1)
	helper_3aec(1)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(432.14, 25.02, 368.63)
	event.CmrsSetRef(402.39, 25.98, 348.56)
	event.ObjsSetMotion(1, "鼻ぴくぴく")
	helper_28e0(0, 3140, 8, 0, 0)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(408.45, 24.17, 357.28)
	event.CmrsSetRef(431.13, 26.09, 350.29)
	event.ObjsSetMotion(2, "シメル_s")
	event.ObjsSetMotion(1, "シメル_s")
	helper_28e0(0, 3150, 8, 0, 0)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(382.77, 29.94, 373.27)
	event.CmrsSetRef(425.01, 23.0, 337.65)
	event.ObjsSeqMotTrg(1)
	event.ObjsSeqMotTrg(2)
	helper_39c(15)
	if vm.skipping() then
		return skip(26)
	end
	helper_2730(0, 3160, 8, 0, 0, 60)
	if vm.skipping() then
		return skip(27)
	end
	helper_39c(60)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(455.51, 42.59, 306.46)
	event.CmrsSetRef(415.88, 17.86, 345.25)
	event.ObjsSeqMotTrgWait(1)
	helper_3aec(1)
	if vm.skipping() then
		return skip(29)
	end
	helper_28e0(0, 3170, 8, 0, 0)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsSeqMotTrg(1)
	event.ObjsSeqMotTrg(2)
	helper_39c(60)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(504.32, 2.39, 361.02)
	event.CmrsSetRef(456.2, 16.46, 340.74)
	helper_28e0(0, 3180, 8, 0, 0)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSeqMotTrgWait(1)
	helper_3aec(1)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(1, "笑う_s")
	helper_28e0(0, 3190, 8, 0, 0)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSeqMotTrgWait(1)
	helper_3aec(1)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSeqMotTrg(1)
	helper_28e0(0, 3200, 8, 0, 0)
	if vm.skipping() then
		return skip(36)
	end
	helper_39cc()
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(412.51, 94.68, 448.16)
	event.CmrsSetRef(457.77, 16.14, 335.83)
	event.ObjsSetMotion(2, "相手を見る_s")
	helper_28e0(0, 3210, 8, 0, 0)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSeqMotTrgWait(1)
	helper_3aec(1)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSeqMotTrg(1)
	helper_28e0(0, 3220, 8, 0, 0)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetMotion(1, "気づく_s")
	helper_28e0(0, 3230, 8, 0, 0)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSeqMotTrgWait(1)
	helper_3aec(1)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetPos(28, 491.85, 57.59, 280.68)
	event.ObjsJump(28, 491.85, 1.02, 280.68, -0.4, 30)
	event.ObjsRotation(28, 1.5, 3.12, 0.35, 30)
	event.ObjsJump(28, 486.47, 3.02, 258.4, -0.3, 20)
	event.ObjsRotation(28, 0.0, 0.0, 0.0, 20)
	event.ObjsJump(28, 491.86, 3.14, 242.12, -0.25, 15)
	event.ObjsRotation(28, -1.57, 0.0, 0.0, 15)
	event.ObjsJump(28, 500.58, 3.2, 235.17, -0.15, 10)
	event.ObjsMove(28, 524.68, 3.2, 222.45, 24)
	event.ObjsRotation(28, -1.57, 0.0, -1.57, 5)
	event.ObjsRotation(28, -1.57, 0.0, 3.14, 5)
	event.ObjsRotation(28, -1.57, 0.0, 0.0, 12)
	event.ObjsRotation(28, -1.57, 0.0, -1.57, 6)
	event.ObjsRotation(28, -1.57, 0.0, 3.14, 6)
	helper_39c(30)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSeqMotTrg(1)
	event.ObjsSetMotion(2, "気づく_s")
	helper_28e0(0, 3240, 8, 0, 0)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSeqMotTrgWait(1)
	event.ObjsSeqMotTrg(1)
	helper_39c(60)
	if vm.skipping() then
		return skip(45)
	end
	event.CmrsSetPos(517.75, 143.82, 286.48)
	event.CmrsSetRef(532.99, 156.31, 270.93)
	helper_28e0(0, 3250, 8, 0, 0)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(469.26, 78.46, 302.58)
	event.CmrsSetRef(454.3, 19.03, 336.32)
	event.ObjsSetPos(1, 448.41, 0.0, 334.3)
	event.ObjsSetRot(1, 0.0, 2.65, 0.0)
	event.ObjsSetMotion(1, "命令_s", 4)
	helper_28e0(0, 3260, 8, 0, 0)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSeqMotTrg(2)
	helper_28e0(0, 3270, 8, 0, 0)
	if vm.skipping() then
		return skip(48)
	end
	event.EohSetShadow(0, 1)
	event.CmrsSetPos(503.36, 126.44, 309.75)
	event.CmrsSetRef(530.34, 150.54, 270.87)
	event.ObjsSeqMotTrg(0)
	event.ObjsMotionWait(0)
	helper_3aec(0)
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsSetPos(584.86, 197.48, 305.84)
	event.CmrsSetRef(544.65, 150.54, 250.94)
	event.ObjsSetMotion(0, "走り")
	event.ObjsSetRot(0, 0.0, 2.8, 0.0)
	event.ObjsMove(0, 570.34, 133.45, 120.98, 60)
	helper_3aec(0)
	if vm.skipping() then
		return skip(50)
	end
	event.CmrsSetPos(461.98, 29.1, 307.38)
	event.CmrsSetRef(447.72, 27.8, 336.09)
	event.CharaActive(0, 8)
	event.CharaActive(0, 10)
	helper_39c(30)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSeqMotTrg(1)
	helper_28e0(0, 3280, 8, 0, 0)
	if vm.skipping() then
		return skip(52)
	end
	event.CharaActive(11)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CmrsSetPos(425.56, 60.68, 401.69)
	event.CmrsSetRef(540.96, 27.8, 343.52)
	helper_39c(3)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsRotation(8, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(9, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(3, 595.28, -100.0, 301.83)
	event.ObjsSetRot(3, 0.0, -1.74, 0.0)
	event.ObjsPosDelay(3, 10)
	event.ObjsSetMotion(3, "ジャンプ", 6)
	event.ObjsMotionDelay(3, 10)
	event.ObjsSetMotion(3, "ジャンプ", 1)
	event.ObjsSetMotion(3, "ジャンプ", 6)
	event.ObjsMotionDelay(3, 1)
	event.ObjsNextMotion(3, "ジャンプL", 4)
	event.ObjsMotionDelay(3, 20)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsSetPos(3, 595.28, 0.0, 301.83)
	event.ObjsPosDelay(3, 4)
	event.ObjsJump(3, 552.31, 0.0, 299.96, -0.6, 30)
	helper_39c(4)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsRotation(14, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(15, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(5, 530.7, -100.0, 408.01)
	event.ObjsSetRot(5, 0.0, -2.58, 0.0)
	event.ObjsPosDelay(5, 10)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsMotionDelay(5, 10)
	event.ObjsSetMotion(5, "ジャンプ", 1)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsMotionDelay(5, 1)
	event.ObjsNextMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 20)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsSetPos(5, 530.7, 0.0, 408.01)
	event.ObjsPosDelay(5, 4)
	event.ObjsJump(5, 508.68, 0.0, 377.01, -0.6, 30)
	helper_39c(5)
	if vm.skipping() then
		return skip(55)
	end
	event.ObjsRotation(11, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(12, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(4, 576.1, -100.0, 360.47)
	event.ObjsSetRot(4, 0.0, -2.22, 0.0)
	event.ObjsPosDelay(4, 10)
	event.ObjsSetMotion(4, "ジャンプ", 6)
	event.ObjsMotionDelay(4, 10)
	event.ObjsSetMotion(4, "ジャンプ", 1)
	event.ObjsSetMotion(4, "ジャンプ", 6)
	event.ObjsMotionDelay(4, 1)
	event.ObjsNextMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsSetPos(4, 576.1, 0.0, 360.47)
	event.ObjsPosDelay(4, 4)
	event.ObjsJump(4, 545.68, 0.0, 340.87, -0.6, 30)
	helper_39c(5)
	if vm.skipping() then
		return skip(56)
	end
	event.ObjsRotation(16, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(17, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(6, 526.55, -100.0, 296.48)
	event.ObjsSetRot(6, 0.0, -2.7, 0.0)
	event.ObjsPosDelay(6, 10)
	event.ObjsSetMotion(6, "ジャンプ", 6)
	event.ObjsMotionDelay(6, 10)
	event.ObjsSetMotion(6, "ジャンプ", 1)
	event.ObjsSetMotion(6, "ジャンプ", 6)
	event.ObjsMotionDelay(6, 1)
	event.ObjsNextMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 20)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsSetPos(6, 526.55, 0.0, 296.48)
	event.ObjsPosDelay(6, 4)
	event.ObjsJump(6, 513.97, 0.0, 263.38, -0.6, 30)
	helper_570(32)
	if vm.skipping() then
		return skip(57)
	end
	helper_39c(25)
	if vm.skipping() then
		return skip(58)
	end
	event.CharaActive(14)
	event.CmrsSetPos(193.14, 35.65, 339.92)
	event.CmrsSetRef(183.37, 28.6, 246.4)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	helper_39c(3)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsRotation(20, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(21, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(4, 183.91, -100.0, 160.26)
	event.ObjsSetRot(4, 0.0, 0.88, 0.0)
	event.ObjsPosDelay(4, 10)
	event.ObjsSetMotion(4, "ジャンプ", 6)
	event.ObjsMotionDelay(4, 10)
	event.ObjsSetMotion(4, "ジャンプ", 1)
	event.ObjsSetMotion(4, "ジャンプ", 6)
	event.ObjsMotionDelay(4, 1)
	event.ObjsNextMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsSetPos(4, 183.91, 0.0, 160.26)
	event.ObjsPosDelay(4, 4)
	event.ObjsJump(4, 209.5, 0.0, 184.83, -0.6, 30)
	helper_39c(6)
	if vm.skipping() then
		return skip(60)
	end
	event.ObjsRotation(26, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(27, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(6, 137.01, -100.0, 257.9)
	event.ObjsSetRot(6, 0.0, 1.72, 0.0)
	event.ObjsPosDelay(6, 10)
	event.ObjsSetMotion(6, "ジャンプ", 6)
	event.ObjsMotionDelay(6, 10)
	event.ObjsSetMotion(6, "ジャンプ", 1)
	event.ObjsSetMotion(6, "ジャンプ", 6)
	event.ObjsMotionDelay(6, 1)
	event.ObjsNextMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 20)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsSetPos(6, 137.01, 0.0, 257.9)
	event.ObjsPosDelay(6, 4)
	event.ObjsJump(6, 177.77, 0.0, 250.28, -0.6, 30)
	helper_39c(2)
	if vm.skipping() then
		return skip(61)
	end
	event.ObjsRotation(23, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(24, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(5, 155.66, -100.0, 207.73)
	event.ObjsSetRot(5, 0.0, 1.36, 0.0)
	event.ObjsPosDelay(5, 10)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsMotionDelay(5, 10)
	event.ObjsSetMotion(5, "ジャンプ", 1)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsMotionDelay(5, 1)
	event.ObjsNextMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 20)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsSetPos(5, 155.66, 0.0, 207.73)
	event.ObjsPosDelay(5, 4)
	event.ObjsJump(5, 195.43, 0.0, 208.6, -0.6, 30)
	helper_3aec(3)
	if vm.skipping() then
		return skip(62)
	end
	helper_3aec(4)
	if vm.skipping() then
		return skip(63)
	end
	helper_3aec(5)
	if vm.skipping() then
		return skip(64)
	end
	helper_3aec(6)
	if vm.skipping() then
		return skip(65)
	end
	helper_39c(30)
	if vm.skipping() then
		return skip(66)
	end
	event.CmrsSetPos(282.78, 28.6, 141.0)
	event.CmrsSetRef(272.0, 28.6, 163.88)
	event.CmrsMove(288.14, 28.55, 129.61, 272.0, 28.6, 163.88, 240)
	event.ObjsSetPos(3, 233.22, 0.0, 166.78)
	event.ObjsSetRot(3, 0.0, 2.65, 0.0)
	event.ObjsMove(3, 252.02, 0.0, 175.63, 150)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetPos(4, 295.72, 0.0, 196.35)
	event.ObjsSetRot(4, 0.0, 2.65, 0.0)
	event.ObjsMove(4, 274.69, 0.0, 186.45, 150)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetPos(5, 220.76, 0.0, 170.66)
	event.ObjsSetRot(5, 0.0, 2.65, 0.0)
	event.ObjsPosDelay(5, 60)
	event.ObjsMove(5, 239.28, 0.0, 179.38, 100)
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsSetPos(6, 301.95, 0.0, 208.89)
	event.ObjsSetRot(6, 0.0, 2.65, 0.0)
	event.ObjsPosDelay(6, 60)
	event.ObjsMove(6, 279.8, 0.0, 197.35, 100)
	event.ObjsSetMotion(6, "立ち", 4)
	helper_28e0(0, 3290, 8, 0, 0)
	if vm.skipping() then
		return skip(67)
	end
	helper_39cc()
	if vm.skipping() then
		return skip(68)
	end
	event.ObjsSeqMotTrg(1)
	helper_28e0(0, 3300, 8, 0, 0)
	if vm.skipping() then
		return skip(69)
	end
	event.ObjsSetMotion(3, "ジャンプ", 2)
	event.ObjsPosDelay(3, 15)
	event.ObjsMove(3, 252.02, 48.0, 175.63, 10)
	helper_39c(5)
	if vm.skipping() then
		return skip(70)
	end
	event.ObjsSetMotion(6, "ジャンプ", 2)
	event.ObjsPosDelay(6, 15)
	event.ObjsMove(6, 279.8, 48.0, 197.35, 10)
	helper_39c(3)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsSetMotion(4, "ジャンプ", 2)
	event.ObjsPosDelay(4, 15)
	event.ObjsMove(4, 274.69, 48.0, 186.45, 10)
	helper_39c(1)
	if vm.skipping() then
		return skip(72)
	end
	event.ObjsSetMotion(5, "ジャンプ", 2)
	event.ObjsPosDelay(5, 15)
	event.ObjsMove(5, 239.28, 48.0, 179.38, 10)
	helper_3aec(3)
	if vm.skipping() then
		return skip(73)
	end
	helper_3aec(4)
	if vm.skipping() then
		return skip(74)
	end
	helper_3aec(5)
	if vm.skipping() then
		return skip(75)
	end
	helper_3aec(6)
	if vm.skipping() then
		return skip(76)
	end
	event.ObjsSetPos(3, 0.0, -100.0, 0.0)
	event.ObjsSetPos(4, 0.0, -100.0, 0.0)
	event.ObjsSetPos(5, 0.0, -100.0, 0.0)
	event.ObjsSetPos(6, 0.0, -100.0, 0.0)
	event.CmrsSetPos(140.19, 60.41, 354.25)
	event.CmrsSetRef(194.91, 60.23, 306.99)
	event.CmrsMove(140.19, 121.35, 354.25, 194.91, 120.79, 306.99, 400)
	event.ObjsSetRot(5, 0.0, 2.77, 0.0)
	event.ObjsSetPos(5, 268.58, 50.8, 235.01)
	event.ObjsJump(5, 305.74, 133.42, 123.7, -0.5, 30)
	event.ObjsSetMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 25)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsSetPos(5, 216.31, -100.0, 283.53)
	helper_39c(20)
	if vm.skipping() then
		return skip(77)
	end
	event.ObjsSetRot(4, 0.0, 2.29, 0.0)
	event.ObjsSetPos(4, 190.17, -7.44, 276.85)
	event.ObjsJump(4, 305.74, 133.42, 123.7, -0.5, 30)
	event.ObjsSetMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 25)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsNextMotion(4, "歩き")
	event.ObjsPosDelay(4, 20)
	event.ObjsMove(4, 335.74, 133.43, 26.77, 60)
	event.ObjsSetPos(4, 216.31, -100.0, 283.53)
	helper_39c(36)
	if vm.skipping() then
		return skip(78)
	end
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.ObjsSetPos(3, 175.87, 0.0, 291.76)
	event.ObjsRotDelay(3, 10)
	event.ObjsRotation(3, 0.0, 2.77, 0.0, 20)
	event.ObjsJump(3, 302.3, 107.18, 238.52, -0.4, 30)
	event.ObjsSetMotion(3, "ジャンプL")
	event.ObjsMotionDelay(3, 25)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsMotionDelay(3, 20)
	event.ObjsSetMotion(3, "ジャンプ", 2)
	event.ObjsNextMotion(3, "ジャンプL")
	event.ObjsPosDelay(3, 32)
	event.ObjsJump(3, 307.84, 133.43, 124.19, -0.4, 30)
	event.ObjsMotionDelay(3, 18)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsMotionDelay(3, 20)
	event.ObjsNextMotion(3, "歩き")
	event.ObjsPosDelay(3, 20)
	event.ObjsMove(3, 335.74, 133.43, 26.77, 60)
	event.ObjsSetPos(3, 335.74, -100.0, 26.77)
	helper_39c(20)
	if vm.skipping() then
		return skip(79)
	end
	event.ObjsSetRot(6, 0.0, 2.77, 0.0)
	event.ObjsRotation(6, 0.0, 2.77, 0.0, 30)
	event.ObjsSetPos(6, 198.78, 0.0, 310.27)
	event.ObjsJump(6, 305.74, 133.42, 123.7, -0.5, 30)
	event.ObjsSetMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 25)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsMotionDelay(6, 20)
	event.ObjsNextMotion(6, "歩き")
	event.ObjsPosDelay(6, 20)
	event.ObjsMove(6, 335.74, 133.43, 26.77, 60)
	event.ObjsSetPos(6, 335.74, -100.0, 26.77)
	helper_39c(83)
	if vm.skipping() then
		return skip(80)
	end
	event.ObjsSetRot(5, 0.0, 2.65, 0.0)
	event.ObjsSetPos(5, 163.89, 25.69, 333.19)
	event.ObjsRotDelay(5, 10)
	event.ObjsRotation(5, 0.0, 2.77, 0.0, 20)
	event.ObjsJump(5, 276.59, 130.67, 206.14, -0.4, 30)
	event.ObjsSetMotion(5, "ジャンプL")
	event.ObjsMotionDelay(5, 25)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsMotionDelay(5, 20)
	event.ObjsSetMotion(5, "ジャンプ", 2)
	event.ObjsNextMotion(5, "ジャンプL")
	event.ObjsPosDelay(5, 32)
	event.ObjsJump(5, 307.84, 133.43, 124.19, -0.4, 30)
	event.ObjsMotionDelay(5, 18)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsMotionDelay(5, 20)
	event.ObjsNextMotion(5, "歩き")
	event.ObjsPosDelay(5, 20)
	event.ObjsMove(5, 335.74, 133.43, 26.77, 60)
	event.ObjsSetPos(5, 335.74, -100.0, 26.77)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 300)
	event.ObjsAddPas(1, 185.76, 0.0, 338.77)
	event.ObjsAddPas(1, 201.54, 0.0, 332.64)
	event.ObjsAddPas(1, 219.03, 9.8, 323.12)
	event.ObjsAddPas(1, 239.77, 24.7, 312.35)
	event.ObjsAddPas(1, 254.18, 36.77, 304.05)
	event.ObjsAddPas(1, 265.82, 40.23, 298.34)
	event.ObjsAddPas(1, 281.1, 55.13, 282.83)
	event.ObjsAddPas(1, 294.98, 69.23, 267.69)
	event.ObjsAddPas(1, 311.07, 84.49, 250.03)
	event.ObjsAddPas(1, 326.52, 94.16, 232.61)
	event.ObjsAddPas(1, 335.01, 113.52, 211.42)
	event.ObjsAddPas(1, 343.71, 128.74, 191.54)
	event.ObjsStartPas(1)
	helper_39c(42)
	if vm.skipping() then
		return skip(81)
	end
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.ObjsSetPos(4, 221.01, 75.5, 118.44)
	event.ObjsJump(4, 271.81, 152.9, 121.85, -0.4, 30)
	event.ObjsSetMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 25)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "ジャンプ", 2)
	event.ObjsNextMotion(4, "ジャンプL")
	event.ObjsPosDelay(4, 32)
	event.ObjsJump(4, 305.74, 133.42, 123.7, -0.2, 30)
	event.ObjsRotDelay(4, 72)
	event.ObjsRotation(4, 0.0, 2.77, 0.0, 20)
	event.ObjsMotionDelay(4, 18)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsNextMotion(4, "歩き")
	event.ObjsPosDelay(4, 20)
	event.ObjsMove(4, 335.74, 133.43, 26.77, 60)
	event.ObjsSetPos(4, 335.74, -100.0, 26.77)
	helper_3aec(4)
	if vm.skipping() then
		return skip(82)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_39cc()
	if vm.skipping() then
		return skip(83)
	end
	event.DeleteChara(8)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.DeleteChara(14)
	event.CharaActive(0)
	event.CmrsFadeInit()
	event.CmrsFadeIn(1)
	helper_39cc()
	if vm.skipping() then
		return skip(84)
	end
end

--- Helper function.
local function helper_3c18()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3aec(0)
		end
		if at <= 2 then
			helper_39c(30)
		end
		if at <= 3 then
			helper_39c(30)
		end
		if at <= 4 then
			helper_39c(200)
		end
		if at <= 5 then
			helper_28e0(0, 1033, 8, 200, 200)
		end
		if at <= 6 then
			helper_39c(30)
		end
		if at <= 7 then
			helper_3aec(0)
		end
		if at <= 8 then
			helper_3aec(0)
		end
		if at <= 9 then
			helper_39c(10)
		end
		if at <= 10 then
			helper_3aec(0)
		end
		if at <= 11 then
			helper_39cc()
		end
		if at <= 12 then
			helper_28e0(0, 1034, 8, 200, 200)
		end
		if at <= 13 then
			helper_39cc()
		end
		if at <= 14 then
			helper_39cc()
		end
		if at <= 15 then
			helper_39c(30)
		end
		if at <= 16 then
			helper_39cc()
		end
		if at <= 17 then
			helper_39cc()
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.CharaActive(0, 0)
	event.ClearStack(4)
	event.AssignStack(4)
	event.ClearStack(5)
	event.AssignStack(5)
	event.LoadChara(5, "event/i03/i03h02/c01b_kihon.chr", "info", 8)
	event.LoadMotion(5, "event/i03/i03h02/p1_mints4.chr", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 7.58, 0.0, -657.06)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(0, 7.58, 0.0, -568.57, 120)
	event.SetMarker(30)
	event.CmrsInit()
	event.CmrsSetPos(6.72, 29.73, -707.96)
	event.CmrsSetRef(6.24, 8.48, -634.81)
	event.CmrsMove(6.72, 29.73, -707.96, 6.24, 37.15, -634.81, 120)
	event.CmrsFadeInit()
	event.CmrsFadeIn(60)
	helper_39cc()
	if vm.skipping() then
		return skip(1)
	end
	helper_3aec(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_39c(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-9.86, 24.33, -621.94)
	event.CmrsSetRef(5.94, 19.04, -565.46)
	helper_39c(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "見えないよ_s")
	helper_39c(200)
	if vm.skipping() then
		return skip(5)
	end
	helper_28e0(0, 1033, 8, 200, 200)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSeqMotTrg(0)
	helper_39c(30)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-83.96, 52.39, -523.46)
	event.CmrsSetRef(5.94, 19.04, -565.46)
	event.ObjsSetMotion(0, "走り")
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 90)
	event.ObjsAddPas(0, 4.63, 0.0, -567.74)
	event.ObjsAddPas(0, 70.66, 0.0, -603.85)
	event.ObjsAddPas(0, 143.43, 0.0, -630.26)
	event.ObjsAddPas(0, 222.61, 0.0, -623.81)
	event.ObjsAddPas(0, 285.65, 0.0, -599.62)
	event.ObjsStartPas(0)
	helper_3aec(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(441.17, 43.51, -515.27)
	event.CmrsSetRef(477.37, 14.66, -405.12)
	event.ObjsSetPos(0, 431.02, 0.0, -509.53)
	event.ObjsSetRot(0, 0.0, 0.36, 0.0)
	event.ObjsMove(0, 468.49, 0.0, -415.95, 40)
	event.ObjsRotDelay(0, 35)
	event.ObjsRotation(0, 0.0, 0.6, 0.0, 5)
	helper_3aec(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_39c(10)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsMove(441.17, 165.2, -515.27, 477.37, 136.35, -405.12, 160)
	event.ObjsSetMotion(0, "はしご登り", 2)
	event.ObjsMotionWait(0)
	helper_3aec(0)
	if vm.skipping() then
		return skip(11)
	end
	helper_39cc()
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(492.91, 169.38, -343.35)
	event.CmrsSetRef(431.02, 122.3, -293.19)
	event.ObjsSetPos(0, 441.37, 133.45, -339.86)
	event.ObjsSetRot(0, 0.0, 0.41, 0.0)
	event.ObjsMove(0, 459.04, 133.45, -308.23, 40)
	event.ObjsSetMotion(0, "右を向く_s", 4)
	helper_28e0(0, 1034, 8, 200, 200)
	if vm.skipping() then
		return skip(13)
	end
	helper_39cc()
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsMove(492.91, 169.38, -343.35, 431.02, 165.35, -293.19, 200)
	helper_39cc()
	if vm.skipping() then
		return skip(15)
	end
	helper_39c(30)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_39cc()
	if vm.skipping() then
		return skip(17)
	end
	event.DeleteChara(8)
	event.CharaActive(0)
	event.CmrsFadeInit()
	event.CmrsFadeIn(1)
	helper_39cc()
	if vm.skipping() then
		return skip(18)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event.SetCharaPos(0, 0.0, 0.0, -320.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_4ef0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3c18()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39c(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoOutside(-1, "m01", 123)
end

return script
