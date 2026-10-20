--!strict
-- dungeon/sys_script/d05.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00523c4e = require("@lib/event/helper_00523c4e")
local helper_0a1a1684 = require("@lib/event/helper_0a1a1684")
local helper_258919ac = require("@lib/event/helper_258919ac")
local helper_3566ff59 = require("@lib/event/helper_3566ff59")
local helper_38598551 = require("@lib/event/helper_38598551")
local helper_3dddb3a4 = require("@lib/event/helper_3dddb3a4")
local helper_559473ec = require("@lib/event/helper_559473ec")
local helper_69ae6360 = require("@lib/event/helper_69ae6360")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_86d71b61 = require("@lib/event/helper_86d71b61")
local helper_90139a55 = require("@lib/event/helper_90139a55")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")

--- Helper function.
local function helper_480(arg0: s32)
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
local function helper_684(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_480(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_480(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_2f50(arg0: any, arg1: s32, sp: number)
	local var2: s32 = 0
	local var3: s32 = 0
	local stream_playing: s32 = 0
	local var5: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local pressed_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		vm.stack(sp + 11)
		var3 = 1
		vm.stack(sp + 11)
		var3 = 0
		vm.stack(sp + 12)
		var3 = 0
		vm.stack(sp + 13)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 11)
	var2 = event.GetMesWindowMode(arg0) or var2
	var3 = 1
	if var2 == 7 then
		var3 = 0
	end
	if var2 == 0 then
		var3 = 0
	end
	stream_playing = event.GetMesVoice() or stream_playing
	vm.stack(sp + 11)
	var5 = event.GetMesStatus(arg0) or var5
	if var5 == 0 then
		return 0
	end
	if var5 == 1 then
		return 0
	end
	if var5 == 3 then
		if stream_playing == 0 then
			event.TrgPakuAnim(0)
			event.TrgPakuMotion(1)
		end
	end
	if var5 == 4 then
		return 0
	end
	if var5 == 5 then
		if stream_playing == 0 then
			event.TrgPakuAnim(0)
			event.TrgPakuMotion(1)
		end
	end
	vm.stack(sp + 11)
	pressed = event.CheckButton(0) or pressed
	vm.stack(sp + 11)
	pressed_2 = event.CheckButton(1) or pressed_2
	vm.stack(sp + 11)
	pressed_3 = event.CheckButton(2) or pressed_3
	if (if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then 1 else if arg1 ~= 0 then pressed_3 else 0) ~= 0 then
		if var3 ~= 0 then
			if pressed_2 ~= 0 then
				event.MesSePlay(0)
			end
			if pressed ~= 0 then
				event.MesSePlay(1)
			end
			if (if arg1 ~= 0 then pressed_3 else 0) ~= 0 then
				event.MesSePlay(0)
			end
		end
		if var5 == 5 then
			event.MesNextpage(arg0)
			if stream_playing == 0 then
				event.TrgPakuAnim(1)
				event.TrgPakuMotion(0)
			end
		end
		if var5 == 3 then
			if stream_playing == 0 then
				event.TrgPakuAnim(0)
				event.TrgPakuMotion(2)
			end
			if (if arg1 ~= 0 then pressed_3 else 0) ~= 0 then
				return 2
			else
				return 1
			end
		end
		if var5 ~= 5 and var5 ~= 3 then
			vm.stack(sp + 11)
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
local function helper_5118(arg0: s32, arg1: s32, arg2: s32, sp: number)
	local junk = 0
	local stream_playing: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var7 = 0
			argc_2 = argc
			var6 = helper_2f50(arg0, arg1, sp + junk + 13)
			arg2 = 1
			arg2 = 0
			var7 = var7 + 1
			junk += 6
		end
		var7 = vm.i32(var7 + 1)
		return var7, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	stream_playing = event.GetMesVoice() or stream_playing
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var7 = 0
	argc_2 = event.StreamGetStatus(1) or argc_2
	while true do
		if stream_playing ~= 0 then
			argc = event.StreamGetStatus(1) or argc
			if argc_2 ~= 0 and argc == 0 then
				event.TrgPakuAnim(0)
				event.TrgPakuMotion(2)
			end
			argc_2 = argc
		end
		var6 = helper_2f50(arg0, arg1, sp + junk + 9)
		if var6 ~= 0 then
			if var6 == 2 then
				arg2 = 1
			else
				arg2 = 0
			end
			var7 = vm.i32(var7 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var7 = vm.i32(var7 + 1)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	stream_playing = event.GetMesVoice() or stream_playing
	if stream_playing ~= 0 then
		event.StreamStop(1)
	end
	return var7, arg2
end

--- Helper function.
local function helper_5970(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32, sp: number)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_3566ff59(arg0)
		return arg5
	end
	local _ = helper_3dddb3a4(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_5118(arg0, 1, arg5, sp + 9)
	if vm.skipping() then
		return skip(1)
	end
	helper_3566ff59(arg0)
	return arg5
end

--- Helper function.
local function helper_191e4(arg0: f32, arg1: f32, arg2: f32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var3
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = event.AngleCmp(arg0, arg1, arg2) or var3
	return var3
end

--- Helper function.
local function helper_451ec()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_86d71b61()
		end
		if at <= 3 then
			local _ = helper_191e4(var2, 0.0, 1.0) == 0
			local _ = helper_191e4(var2, vm.f32(3.14), 1.0) == 0
			helper_0a1a1684(30)
		end
		if at <= 4 then
			local _ = helper_191e4(var2, 0.0, 1.0) == 0
			var5 = vm.f32(var5 + vm.f32(3.1415927))
			local _ = helper_191e4(var2, vm.f32(3.14), 1.0) == 0
			var5 = vm.f32(var5 - vm.f32(3.1415927))
			local _ = helper_191e4(var2, vm.f32(1.57), 1.0) == 0
			var3 = vm.f32(var3 + vm.f32(3.1415927))
			local _ = helper_191e4(var2, vm.f32(-1.57), 1.0) == 0
			var3 = vm.f32(var3 - vm.f32(3.1415927))
			helper_90139a55(1)
		end
		if at <= 5 then
			helper_90139a55(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetLoadbgFile("snd2/sp/sp_033.sound.json")
	if vm.wait() then
		return skip(2)
	end
	helper_86d71b61()
	if vm.skipping() then
		return skip(3)
	end
	var0 = event.SndLoadSound(8, "snd2/sp/sp_033.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	var1 = event.GetEventData_2(9) or var1
	var2 = vm.bits_float(event.GetEventData_2(11)) or var2
	event.EohSyncObj(0, var1, "d04w10_3-m")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if helper_191e4(var2, 0.0, 1.0) == 0 or helper_191e4(var2, vm.f32(3.14), 1.0) == 0 then
		event.EohSyncObj(1, var1, "d04w10_2-m")
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.EohSyncObj(2, var1, "d04w10_4-m")
		event.EohSetShow(2, 1)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
	else
		event.EohSyncObj(1, var1, "d04w10_5-m")
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.EohSyncObj(2, var1, "d04w10_6-m")
		event.EohSetShow(2, 1)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
	end
	event.SndSePlay(var0, 2)
	helper_0a1a1684(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 0)
	do
		local out1, out2, out3 = event.EohGetRot(1)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	if helper_191e4(var2, 0.0, 1.0) == 0 then
		var5 = vm.f32(var5 + vm.f32(3.1415927))
		var5 = event.AngleLimit(var5) or var5
	end
	if helper_191e4(var2, vm.f32(3.14), 1.0) == 0 then
		var5 = vm.f32(var5 - vm.f32(3.1415927))
		var5 = event.AngleLimit(var5) or var5
	end
	if helper_191e4(var2, vm.f32(1.57), 1.0) == 0 then
		var3 = vm.f32(var3 + vm.f32(3.1415927))
		var3 = event.AngleLimit(var3) or var3
	end
	if helper_191e4(var2, vm.f32(-1.57), 1.0) == 0 then
		var3 = vm.f32(var3 - vm.f32(3.1415927))
		var3 = event.AngleLimit(var3) or var3
	end
	event.ObjsRotation2(1, var3, var4, var5, 40, 0, 0.5)
	event.ObjsRotation2(2, var3, var4, var5, 40, 0, 0.5)
	helper_90139a55(1)
	if vm.skipping() then
		return skip(5)
	end
	do
		local out1, out2, out3 = event.EohGetPos(0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	event.ObjsMove2(0, var3, var4 + 80.0, var5, 32, 1, 0.5)
	helper_90139a55(0)
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
end

--- Helper function.
local function helper_1844c()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			helper_90139a55(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if active_chr_no == 2 then
		if vm.wait() then
			return skip(2)
		end
		event.Finish()
		return
	end
	if active_chr_no == 3 then
		if vm.wait() then
			return skip(3)
		end
		event.Finish()
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_90139a55(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_90139a55(0)
	if vm.skipping() then
		return skip(5)
	end
	event.Finish()
end

--- Helper function.
local function helper_a6b0()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		var1 = event.GetRoboMoveType() or var1
		if var1 == 1 then
			event.SetMotion(0, "立ち-足")
		end
		if var1 == 2 then
			event.SetMotion(0, "立ち-キャタピラ")
		end
	else
		event.SetMotion(0, "立ち")
	end
end

--- Helper function.
local function helper_5ad4(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, sp: number)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_3dddb3a4(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_5118(arg0, 0, var6, sp + 9)
		end
		helper_3566ff59(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_3dddb3a4(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_5118(arg0, 0, var6, sp + 9)
	if vm.skipping() then
		return skip(2)
	end
	helper_3566ff59(arg0)
end

--- Helper function.
local function helper_b508(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0, arg1, arg2, arg3
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = event.GetEventData_2(9) or var4
	event.EohSyncObj(0, var4)
	do
		local out1, out2, out3 = event.EohGetPos(0)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	arg3 = vm.bits_float(event.GetEventData_2(11)) or arg3
	return arg0, arg1, arg2, arg3
end

--- Helper function.
local function helper_47120()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local angle: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0, var1, var2, angle = helper_b508(var0, var1, var2, angle)
			angle = vm.f32(angle + vm.f32(3.1415927))
			helper_0a1a1684(10)
		end
		if at <= 2 then
			helper_0a1a1684(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0, var1, var2, angle = helper_b508(var0, var1, var2, angle)
	angle = vm.f32(angle + vm.f32(3.1415927))
	angle = event.AngleLimit(angle) or angle
	event.SetWorldCoord(var0, var1, var2, angle)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(0)
	event.CmrsInit()
	event.CmrsSetPos(56.71, 54.78, -129.16)
	event.CmrsSetRef(-1.53, 22.52, 48.82)
	event.ObjsMove(0, 0.0, 0.0, 155.0, 40)
	event.ObjsSetMotion(0, "走り", 4)
	helper_0a1a1684(10)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(30)
	helper_0a1a1684(30)
	if vm.skipping() then
		return skip(3)
	end
	event.Finish()
end

--- Helper function.
local function helper_b70c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var2 = var2 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetFloorInfo(arg0, arg1, 7) or var2
	var2 = vm.i32(var2 + 1)
	event.SetFloorInfo(arg0, arg1, 7, var2)
end

--- Program 1000.
local function program_1000()
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 3
		helper_b70c(var1, var2)
	end
	event.Initialize()
	event.SetLocalFlag(0, 0)
	event.SetLocalFlag(1, 0)
	event.SetLocalFlag(2, 0)
	event.SetLocalFlag(3, 0)
	event.SetLocalFlag(4, 0)
	event.GotoDngMap(3)
	if vm.wait() then
		return skip(1)
	end
	event.SetProjection(524.9)
	do
		local _, out2, out3, _ = event.GetMenuParam_4()
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var1 = 3
	event.DngSetStageId(var1)
	event.DngSetFloorId(var2)
	helper_b70c(var1, var2)
	event.LoadDungeonMapFile("d05b01")
end

--- Helper function.
local function helper_48914(arg0: s32, sp: number)
	local junk = 0
	local argc: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: any = 0
	local stage_id: s32 = 0
	local var8: s32 = 0
	local argc_2: s32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				var2 = 2
				junk += 2
			end
			if at <= 2 then
				helper_451ec()
				junk += 1
			end
			if at <= 3 then
				helper_1844c()
				junk += 1
			end
			if at <= 4 then
				helper_a6b0()
				helper_5ad4(0, 20, 5, 256, 208, sp + junk + 15)
				junk += 3
			end
			if at <= 5 then
				helper_5ad4(0, 21, 5, 256, 208, sp + junk + 12)
			end
			return
		end
		if at <= 8 then
			if at <= 7 then
				helper_47120()
				junk += 1
			end
			return
		end
	end
	event.SetMotion(0, "立ち")
	argc = event.GetLocalFlag(arg0) or argc
	event.DngPause(1, 1)
	if argc == 0 then
		var2 = event.GetEventData_2(6) or var2
		if var2 == 1 then
			event.Initialize()
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 1)
			var3 = helper_5970(0, 3, 5, 256, 208, var3, sp + junk + 12)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesWindowMode(0, 7)
			event.SetMesDrawspeed(0, 0)
			if var3 == 1 then
				var2 = 2
			end
			event.Finish()
		end
		if var2 == 2 then
			event.GotoUseItem(342)
			do
				local skipped = vm.wait()
				var4 = event.DeferredOutput() or var4
				if skipped then
					return skip(2)
				end
			end
			if var4 == 342 then
				event.SetLocalFlag(arg0, 1)
				helper_451ec()
				if vm.skipping() then
					return skip(3)
				end
			elseif var4 <= 0 then
				event.Finish()
			else
				helper_1844c()
				if vm.skipping() then
					return skip(4)
				end
			end
		end
	else
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.Initialize()
			helper_a6b0()
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 1)
			if active_chr_no == 2 then
				helper_5ad4(0, 20, 5, 256, 208, sp + junk + 12)
				if vm.skipping() then
					return skip(5)
				end
			else
				helper_5ad4(0, 21, 5, 256, 208, sp + junk + 12)
				if vm.skipping() then
					return skip(6)
				end
			end
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 0)
			event.DngPause(1, 0)
			event.Finish()
			return
		end
		event.SetMesQuestionGyou(0, 0)
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		var6 = helper_258919ac(0, 10, 8, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(7)
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		if var6 == 0 then
			stage_id = event.DngGetStageId() or stage_id
			var8 = event.DngGetFloorId() or var8
			argc_2 = event.GetNextFloor(var8, arg0) or argc_2
			event.DngSetFloorId(argc_2)
			event.SetFloorInfo(stage_id, var8, 5, 2)
			event.SetFloorInfo(stage_id, argc_2, 5, 1)
			helper_47120()
			if vm.skipping() then
				return skip(8)
			end
			var11 = event.GetE3Version() or var11
			if var11 == 1 then
				event.SetExitFlag(1)
				return
			else
				event.Finish()
				program_1000()
				if vm.skipping() then
					return skip(9)
				end
			end
		else
			event.Finish()
		end
	end
	event.DngPause(1, 0)
end

--- Helper function.
local function helper_4a9a0(sp: number)
	local junk = 0
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4, var5, var6, var7 = helper_b508(var4, var5, var6, var7)
			helper_0a1a1684(60)
			junk += 1
		end
		if at <= 2 then
			helper_1844c()
			junk += 1
		end
		if at <= 3 then
			helper_5ad4(0, -1, 8, 256, 208, sp + junk + 9)
			junk += 1
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.DngPause(1, 1)
	argc = event.GetLocalFlag(4) or argc
	if argc == 0 then
		var1 = event.GetEventData_2(6) or var1
		if var1 == 2 then
			event.GotoUseItem(342)
			do
				local skipped = vm.wait()
				var2 = event.DeferredOutput() or var2
				if skipped then
					return skip(1)
				end
			end
			if var2 == 362 then
				event.SetLocalFlag(4, 1)
				var3 = event.GetEventData_2(9) or var3
				event.EohSyncObj(0, var3, "star-m0")
				event.EohSetShow(0, 0)
				event.EohSyncObj(0, var3, "d02wa13-a")
				event.EohSetShow(0, 0)
				event.FuncPointShow(var3, "star", 0)
				var4, var5, var6, var7 = helper_b508(var4, var5, var6, var7)
				event.SetWorldCoord(var4, var5, var6, var7)
				event.AssignStack(5)
				event.ClearStack(5)
				event.EohSyncChara(0, 0)
				event.ObjsInit(0)
				event.ObjsSyncObj(0, 0)
				event.ObjsReference(0, 0.0, 0.0, 0.0, 0)
				event.LoadChara(5, "event/dng/key_star.gltf", "star", 12)
				event.CharaActive(12)
				event.EohSyncChara(1, 12)
				event.ObjsSyncObj(1, 1)
				event.EohSetPos(1, 0.0, 0.0, 160.0)
				event.EohSetRot(1, 0.0, 0.0, 0.0)
				event.EohSetScale(1, 20.0, 20.0, 20.0)
				event.ObjsSetScale(1, 20.0, 0.0, 20.0, 60)
				event.CmrsSetPos(-31.46, 57.29, 350.67)
				event.CmrsSetRef(4.66, 31.72, 192.41)
				event.SetCharaShow(12, 0, 1, 0.02)
				helper_0a1a1684(60)
				if vm.skipping() then
					return skip(2)
				end
				event.DeleteChara(12)
			elseif var2 <= 0 then
				event.Finish()
			else
				helper_1844c()
				if vm.skipping() then
					return skip(3)
				end
			end
		end
		if var1 == 1 then
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.MesMake_2(
				0,
				"星の不思議な力によって先へ進めない。\n（(#)ボタンでメニューを開く）"
			)
			helper_5ad4(0, -1, 8, 256, 208, sp + junk + 8)
			if vm.skipping() then
				return skip(4)
			end
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 0)
		end
	end
	event.DngPause(1, 0)
	event.Finish()
end

--- Helper function.
local function helper_c98c()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 0
		var1 = 110
		var1 = 111
		var1 = 112
		return var1
	end
	if vm.skipping() then
		return skip(1)
	end
	stage_id = event.DngGetStageId() or stage_id
	var1 = 0
	if stage_id == 0 or stage_id == 1 then
		var1 = 110
	end
	if false then
		var1 = 111
	end
	if stage_id == 2 or stage_id == 3 or stage_id == 4 or stage_id == 5 then
		var1 = 112
	end
	return var1
end

--- Helper function.
local function helper_ce20(arg0: any)
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			var2 = 0.0
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		if at <= 2 then
			var4 = helper_c98c()
			var1 = 0
			var2 = vm.f32(var2 - vm.f32(0.004))
			var1 = var1 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	var2 = 0.0
	while var1 <= 5 do
		event.SetTbAngle(var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	var4 = helper_c98c()
	var3 = event.GetSndId(3) or var3
	event.SndSePlay(var3, var4)
	var1 = 0
	while var1 <= 4 do
		event.SetTbAngle(var2)
		var2 = vm.f32(var2 - vm.f32(0.004))
		var1 = var1 + 1
		if vm.wait() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_d374(arg0: f32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			arg0 = vm.f32(0.04)
			arg0 = vm.f32(arg0 + vm.f32(0.18))
			var1 = var1 + 1
		end
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	arg0 = vm.f32(0.04)
	while var1 <= 10 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + vm.f32(0.18))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	return arg0
end

--- Helper function.
local function helper_c250(arg0: s32, arg1: s32, arg2: f32)
	local category: s32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var4 = vm.f32(var4 / 2.0)
		var4 = vm.f32(var4 / 2.0)
		var4 = vm.f32(var4 / 2.0)
		arg2 = var4
		return arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	category = event.GetItemType(arg1) or category
	var4 = event.GetAdjustPolygonScale(arg0, 6.0) or var4
	if category == 0 then
		var4 = vm.f32(var4 / 2.0)
	end
	if category == 2 then
		var4 = vm.f32(var4 / 2.0)
	end
	if category == 4 then
		var4 = vm.f32(var4 / 2.0)
	end
	arg2 = var4
	return arg2
end

--- Helper function.
local function helper_d724(arg0: f32)
	local var1: s32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			arg0 = vm.f32(arg0 + vm.f32(0.18))
			var1 = var1 + 1
		end
		if at <= 2 then
			var1 = 0
			var2 = vm.f32(0.06)
			arg0 = vm.f32(arg0 - var2)
			var2 = vm.f32(var2 - vm.f32(0.008))
			var1 = var1 + 1
		end
		if at <= 3 then
			var1 = 0
			var2 = vm.f32(0.005)
			arg0 = vm.f32(arg0 + var2)
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		if at <= 4 then
			var1 = 0
			var2 = vm.f32(0.03)
			arg0 = vm.f32(arg0 - var2)
			var2 = vm.f32(var2 - vm.f32(0.005))
			var1 = var1 + 1
		end
		if at <= 5 then
			var1 = 0
			var2 = vm.f32(0.01)
			arg0 = vm.f32(arg0 + var2)
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	while var1 < 10 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + vm.f32(0.18))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	var1 = 0
	var2 = vm.f32(0.06)
	while var1 <= 6 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 - var2)
		var2 = vm.f32(var2 - vm.f32(0.008))
		var1 = var1 + 1
		if vm.wait() then
			return skip(3)
		end
	end
	var1 = 0
	var2 = vm.f32(0.005)
	while var1 <= 8 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(4)
		end
	end
	var1 = 0
	var2 = vm.f32(0.03)
	while var1 <= 6 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 - var2)
		var2 = vm.f32(var2 - vm.f32(0.005))
		var1 = var1 + 1
		if vm.wait() then
			return skip(5)
		end
	end
	var1 = 0
	var2 = vm.f32(0.01)
	while var1 <= 4 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(6)
		end
	end
	return arg0
end

--- Helper function.
local function helper_95c4(arg0: any, arg1: s32, sp: number)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	event.SetMesWindowMode(1, 4)
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
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_5ad4(1, var2, 8, 0, 0, sp + 4)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_e218(arg0: s32, sp: number)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0a1a1684(15)
		end
		if at <= 2 then
			helper_ce20(0)
		end
		if at <= 3 then
			helper_0a1a1684(5)
		end
		if at <= 4 then
			helper_86d71b61()
		end
		if at <= 5 then
			helper_0a1a1684(5)
		end
		if at <= 6 then
			var5 = helper_d374(var5)
		end
		if at <= 7 then
			var6 = helper_c250(13, arg0, var6)
			var5 = helper_d724(var5)
		end
		if at <= 8 then
			helper_559473ec()
		end
		if at <= 9 then
			helper_95c4(arg0, 1, sp + 7)
		end
	end
	event.DngPause(23, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
		var4 = out4 or var4
	end
	event.SetWorldCoord(var1, var2, var3, var4)
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(arg0, 1)
	event.SetLoadbgFile(arg0, 1, "effect/itemget.gltf")
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_0a1a1684(15)
	if vm.skipping() then
		return skip(2)
	end
	helper_ce20(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_0a1a1684(5)
	if vm.skipping() then
		return skip(4)
	end
	helper_86d71b61()
	if vm.skipping() then
		return skip(5)
	end
	event.LoadChara(5, "effect/itemget.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(1, 12)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "ゲット", 5)
	event.ObjsSetMotion(1, "ゲット", 2)
	helper_0a1a1684(5)
	if vm.skipping() then
		return skip(6)
	end
	var5 = helper_d374(var5)
	if vm.skipping() then
		return skip(7)
	end
	event.LoadItem(5, arg0, "info", 13, 1)
	event.CharaActive(1, 13)
	event.EohSyncChara(0, 13)
	var6 = helper_c250(13, arg0, var6)
	event.EohSetScale(0, var6, var6, var6)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, -5.0, 0.0)
	event.ObjsPosDelay(0, 4)
	event.ObjsJump(0, 0.0, 17.0, 0.0, -0.3, 20)
	event.ObjsJump(0, 0.0, 17.0, 0.0, -0.4, 8)
	event.ObjsJump(0, 0.0, 17.0, 0.0, -0.2, 5)
	var5 = helper_d724(var5)
	if vm.skipping() then
		return skip(8)
	end
	helper_559473ec()
	if vm.skipping() then
		return skip(9)
	end
	helper_95c4(arg0, 1, sp + 7)
	if vm.skipping() then
		return skip(10)
	end
	event.SetCrossfade(10)
	event.DngPause(23, 0)
	event.CharaActive(1, 0)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetTbAngle(1.0)
	event.Finish()
end

--- Helper function.
local function helper_c690(arg0: s32, arg1: any, arg2: f32)
	local var4: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var4 = vm.f32(var4 * vm.f32(0.6))
		arg2 = var4
		return arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	event.GetItemType(arg1)
	var4 = event.GetAdjustPolygonScale(arg0, 8.0) or var4
	var4 = vm.f32(var4 * vm.f32(0.6))
	arg2 = var4
	return arg2
end

--- Helper function.
local function helper_efc0(arg0: any, arg1: s32, sp: number)
	local junk = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local var7: f32 = 0
	local language_code: s32 = 0
	local var9: any = 0
	local value: s32 = 0
	local var12: any = 0
	local var13: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_0a1a1684(15)
		end
		if at <= 3 then
			helper_ce20(0)
		end
		if at <= 4 then
			helper_0a1a1684(5)
		end
		if at <= 5 then
			helper_86d71b61()
		end
		if at <= 6 then
			var7 = helper_d374(var7)
		end
		if at <= 7 then
			var7 = helper_d724(var7)
		end
		if at <= 8 then
			helper_0a1a1684(10)
		end
		if at <= 9 then
			helper_0a1a1684(8)
		end
		if at <= 10 then
			helper_0a1a1684(10)
		end
		if at <= 11 then
			helper_5ad4(0, -1, 8, 256, 208, sp + junk + 16)
			junk += 1
		end
		if at <= 12 then
			local _ = helper_3dddb3a4(0, -1, 8, 0, 0)
			var9 = helper_38598551(0, 2, 0, 1)
			junk += 1
		end
		if at <= 13 then
			var12 = arg0
			arg0 = arg1
			arg1 = var12
			var13 = helper_c690(12, arg0, var13)
			var13 = helper_c690(13, arg1, var13)
			helper_0a1a1684(10)
			junk += 2
		end
		if at <= 14 then
			helper_90139a55(1)
		end
		if at <= 15 then
			helper_95c4(arg1, 1, sp + junk + 16)
			junk += 1
		end
		if at <= 16 then
			helper_95c4(arg0, 1, sp + junk + 15)
		end
		var6 = 0
		var6 = var6 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(17, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile(
		arg0,
		1,
		arg1,
		1,
		"event/tbox/p00_27a_ex.gltf",
		"event/tbox/l_box.gltf",
		"event/tbox/r_box.gltf",
		"event/tbox/p00_27a.gltf",
		"event/tbox/p00_27a_ex_l.gltf",
		"event/tbox/p00_27a_ex_r.gltf"
	)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	if vm.wait() then
		return skip(2)
	end
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_0a1a1684(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_ce20(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_0a1a1684(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_86d71b61()
	if vm.skipping() then
		return skip(6)
	end
	event.LoadChara(5, "event/tbox/p00_27a_ex.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(0, 8)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "宝箱ピエロ出現", 5)
	event.LoadChara(5, "event/tbox/p00_27a.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "出現", 5)
	var7 = helper_d374(var7)
	if vm.skipping() then
		return skip(7)
	end
	event.CharaActive(8)
	event.EohSetMotion(0, "宝箱ピエロ出現", 6)
	event.CharaActive(9)
	event.ObjsSetMotion(1, "出現", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.CmrsInit()
	event.CmrsPrdelay(4)
	event.CmrsMove2(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.CmrsMove2(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	var7 = helper_d724(var7)
	if vm.skipping() then
		return skip(8)
	end
	helper_0a1a1684(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 8)
	event.LoadChara(5, "event/tbox/p00_27a_ex_r.gltf", "info", 10)
	event.CharaActive(10)
	event.SetCharaPos(10, 0.0, 0.0, 0.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.SetMotion(10, "宝箱発生（右手）", 6)
	event.SetReference(9, "s_pre", 10)
	event.LoadChara(5, "event/tbox/p00_27a_ex_l.gltf", "info", 11)
	event.CharaActive(11)
	event.SetCharaPos(11, 0.0, 0.0, 0.0)
	event.SetCharaRot(11, 0.0, 0.0, 0.0)
	event.SetMotion(11, "宝箱出現（左手）", 6)
	event.SetReference(9, "b_pre", 11)
	event.LoadChara(5, "event/tbox/r_box.gltf", "info", 14)
	event.CharaActive(14)
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetCharaRot(14, 0.0, 0.0, 0.0)
	event.SetReference(9, "s_pre", 14)
	event.SetCharaType(14, 4)
	event.LoadChara(5, "event/tbox/l_box.gltf", "info", 15)
	event.CharaActive(15)
	event.SetCharaPos(15, 0.0, 0.0, 0.0)
	event.SetCharaRot(15, 0.0, 0.0, 0.0)
	event.SetReference(9, "b_pre", 15)
	event.SetCharaType(15, 4)
	event.SetCharaShow(14, 0)
	event.SetCharaShow(15, 0)
	helper_0a1a1684(8)
	if vm.skipping() then
		return skip(10)
	end
	event.SetCharaShow(14, 1, 1, 0.08)
	event.SetCharaShow(15, 1, 1, 0.08)
	helper_0a1a1684(10)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.MesMake_2(
			0,
			"はぁーい！やってるかーい。\nハッピーピエロのプレゼントコーナー！\nさあ、好きな方どっちか選んで！"
		)
	else
		event.MesMake_2(0, "Howdy!\nHow's it going?<page>Happy Clown's gonna give you a gift!\nHere, make your choice.")
	end
	helper_5ad4(0, -1, 8, 256, 208, sp + junk + 15)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	if language_code == 0 then
		event.MesMake_2(0, "赤い箱を選ぶ\n黄色い箱を選ぶ")
	else
		event.MesMake_2(0, "Pick the red box.\nPick the yellow box.")
	end
	local _ = helper_3dddb3a4(0, -1, 8, 0, 0)
	var9 = helper_38598551(0, 2, 0, 1)
	if vm.skipping() then
		return skip(13)
	end
	event.SetMesPos(0, 0)
	value = event.GetRandInt(100) or value
	if vm.imod(value, 2) == 0 then
		var12 = arg0
		arg0 = arg1
		arg1 = var12
	end
	event.LoadItem(5, arg0, "info", 12, 1)
	event.CharaActive(0, 12)
	event.SetCharaPos(12, 0.0, 0.0, 0.0)
	event.SetCharaRot(12, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 12)
	var13 = helper_c690(12, arg0, var13)
	event.EohSetScale(6, var13, var13, var13)
	event.LoadItem(5, arg1, "info", 13, 1)
	event.CharaActive(0, 13)
	event.SetCharaPos(13, 0.0, 0.0, 0.0)
	event.SetCharaRot(13, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 13)
	var13 = helper_c690(13, arg1, var13)
	event.EohSetScale(6, var13, var13, var13)
	event.CharaActive(1, 12)
	event.SetReference(9, "s_pre", 12)
	event.CharaActive(1, 13)
	event.SetReference(9, "b_pre", 13)
	event.ObjsSetMotion(1, "中身公開", 2)
	if var9 == 0 then
		event.ObjsNextMotion(1, "大きい宝箱", 2)
		event.ObjsNextMotion(1, "大きい宝箱L", 4)
	else
		event.ObjsNextMotion(1, "小さい宝箱", 2)
		event.ObjsNextMotion(1, "小さい宝箱L", 4)
	end
	helper_0a1a1684(10)
	if vm.skipping() then
		return skip(14)
	end
	event.SetCharaShow(14, 0, 1, 0.04)
	event.SetCharaShow(15, 0, 1, 0.04)
	helper_90139a55(1)
	if vm.skipping() then
		return skip(15)
	end
	if var9 == 0 then
		helper_95c4(arg1, 1, sp + junk + 15)
		if vm.skipping() then
			return skip(16)
		end
		event.AddItem(arg1, 1)
	else
		helper_95c4(arg0, 1, sp + junk + 15)
		if vm.skipping() then
			return skip(17)
		end
		event.AddItem(arg0, 1)
	end
	event.CharaActive(0)
	event.DngPause(17, 0)
	var6 = 0
	while var6 <= 7 do
		event.DeleteChara(8 + var6)
		var6 = var6 + 1
	end
	event.SetTbAngle(1.0)
	event.Finish()
end

--- Helper function.
local function helper_8ea8()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_3dddb3a4(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "(O)でストップ")
	helper_3dddb3a4(1, -1, 15, 0, 0)
end

--- Helper function.
local function helper_9074()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_3566ff59(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_3566ff59(1)
end

--- Helper function.
local function helper_5678(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any, sp: number)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			_, var5 = helper_5118(arg0, 0, var5, sp + 8)
		end
		helper_3566ff59(arg0)
	end
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
	_, var5 = helper_5118(arg0, 0, var5, sp + 8)
	if vm.skipping() then
		return skip(4)
	end
	helper_3566ff59(arg0)
end

--- Helper function.
local function helper_7c80(arg0: s32, arg1: s32, sp: number)
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	player_chara = event.GetControlChrid() or player_chara
	helper_69ae6360(player_chara, arg0, arg1)
	event.SetCrossfade(10)
	helper_5678(0, arg1, arg0, player_chara, 0, sp + 3)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCrossfade(10)
end

--- Helper function.
local function helper_9404(arg0: s32, sp: number)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5ad4(1, vm.i32(60 + arg0), 8, 0, 0, sp + 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	event.SetMesWindowMode(1, 4)
	helper_5ad4(1, vm.i32(60 + arg0), 8, 0, 0, sp + 1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_17438(sp: number)
	local junk = 0
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: f32 = 0
	local active_chr_no_2: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_86d71b61()
			end
			if at <= 2 then
				helper_9404(active_chr_no_2, sp + junk + 6)
			end
			if at <= 3 then
				helper_0a1a1684(30)
				junk += 2
			end
			if at <= 5 then
				helper_0a1a1684(30)
				junk += 1
			end
			return
		end
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMotion(0, "故障", 6)
		event.EsmInitialize(5)
		event.EsmLoadBase("ロボ故障")
		event.EsmInitFix(5)
	end
	var1 = event.GetEventInfoSndid(4) or var1
	event.SndSeStop(var1, 0)
	event.DngPause(17, 1)
	event.EsmCreate("ロボ故障")
	var2 = event.GetBgmNo() or var2
	var3 = vm.bits_float(event.GetMasterVol()) or var3
	event.StopBgm(0)
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json")
	helper_0a1a1684(4)
	if vm.skipping() then
		return skip(1)
	end
	helper_86d71b61()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgmPack(60)
	event.PlayBgm(0)
	active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
	helper_9404(active_chr_no_2, sp + junk + 6)
	if vm.skipping() then
		return skip(3)
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetFadeOut(30)
		helper_0a1a1684(30)
		if vm.skipping() then
			return skip(4)
		end
		event.EsmClear()
		event.MenuCharaChenge(-1)
		if vm.wait() then
			return skip(5)
		end
	else
		var5 = event.GetE3Version() or var5
		if var5 == 1 then
			event.SetFadeOut(30)
			helper_0a1a1684(30)
			if vm.skipping() then
				return skip(6)
			end
			event.SetExitFlag(1)
			return
		else
			event.DngDebugCommand(0)
		end
	end
	event.StopBgm(0)
	event.EsmClear()
	event.DngPause(17, 1)
	helper_0a1a1684(4)
	if vm.skipping() then
		return skip(7)
	end
	event.LoadBgm(var2)
	event.PlayBgm(0)
	event.SetMasterVol(var3)
	event.SndSePlay(var1, 0)
	event.DngPause(17, 0)
	event.Finish()
end

--- Helper function.
local function helper_11d88()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: s32 = 0
	local block: s32 = 0
	local language_code: s32 = 0
	local language_code_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_559473ec()
			end
			if at <= 2 then
				helper_0a1a1684(20)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var6, 0)
		event.PlayBgm(0)
		event.CmrsReleaseObj()
		event.DelExtMotion(0)
		event.DelImg(0)
		event.SetCrossfade(15)
		event.Finish()
	end
	event.Initialize()
	event.InitDramaScene()
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var3 = out2 or var3
	end
	event.SetWorldCoord(var0, var1, var2, var3)
	var6 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var6
	event.LoadMotion(5, "dungeon/chara/c01b_win.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.StopBgm(0)
	event.SndSePlay(var6, 0)
	event.ObjsSetMotion(0, "勝利のポーズ", 6)
	event.ObjsMotionDelay(0, 1)
	event.ObjsNextMotion(0, "勝利のポーズL", 4)
	event.CmrsInit()
	event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 2.8, -5.0, 70.0, "", 1)
	event.CmrsMoveAhd(-0.24, -5.0, 70.0, 120)
	event.CmrsAhdSlowing(0.9, 30)
	event.ObjsMotionWait(0)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	else
		block = event.LoadImg_4(5, "dungeon/image/senmetsu/usa/finish.img", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	end
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetScale(1, 1.0, 1.0, 0.0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_0a1a1684(90)
	if vm.skipping() then
		return skip(1)
	end
	language_code_2 = event.GetLanguage() or language_code_2
	if language_code_2 == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 154.0, 370.0, 0, 20)
	end
	helper_559473ec()
	if vm.skipping() then
		return skip(2)
	end
	helper_0a1a1684(20)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_132f8()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local block: s32 = 0
	local language_code: s32 = 0
	local language_code_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_0a1a1684(90)
			end
			if at <= 2 then
				helper_559473ec()
			end
			if at <= 3 then
				helper_0a1a1684(20)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeIn(1)
		event.SndSeStop(var6, 0)
		event.PlayBgm(0)
		event.CmrsReleaseObj()
		event.DelExtMotion(0)
		event.EohResetDaPosition(0)
		event.DelImg(0)
		event.SetCrossfade(10)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var3 = out2 or var3
	end
	event.SetWorldCoord(var0, var1, var2, var3)
	event.LoadMotion(5, "dungeon/chara/c02a_win.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	var6 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var6
	var7 = event.GetEventInfoSndid(4) or var7
	event.SndSeStop(var7, 0)
	event.StopBgm(0)
	event.SndSePlay(var6, 0)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	else
		block = event.LoadImg_4(5, "dungeon/image/senmetsu/usa/finish.img", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	end
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetMotion(0, "勝利のポーズ", 6)
	event.ObjsNextMotion(0, "勝利のポーズL", 6, 0.04)
	event.ObjsNextMotion(0, "余韻", 6)
	event.ObjsNextMotion(0, "余韻L", 4)
	event.CmrsInit()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(160)
	event.CmrsAddPas(-21.28, 37.75, 24.27, -2.96, 23.12, 7.37)
	event.CmrsAddPas(-28.52, 37.89, 34.83, -2.96, 21.14, 7.37)
	event.CmrsAddPas(-28.68, 24.7, 45.16, -2.96, 19.14, 7.37)
	event.CmrsAddPas(-22.33, 14.47, 62.16, -2.96, 17.14, 7.37)
	event.CmrsAddPas(1.46, 10.46, 71.87, -2.96, 16.14, 7.37)
	event.CmrsAddPas(30.68, 10.46, 61.53, -2.96, 15.14, 7.37)
	event.CmrsAddPas(38.91, 13.26, 35.51, 4.6, 14.7, -11.02)
	event.CmrsStartPas()
	event.CmrsMove(36.58, 13.26, 32.4, 4.6, 14.7, -11.02, 60)
	event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_0a1a1684(90)
	if vm.skipping() then
		return skip(2)
	end
	language_code_2 = event.GetLanguage() or language_code_2
	if language_code_2 == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 154.0, 370.0, 0, 20)
	end
	helper_559473ec()
	if vm.skipping() then
		return skip(3)
	end
	helper_0a1a1684(20)
	if vm.skipping() then
		return skip(4)
	end
	event.PlayBgm(0)
	event.CmrsReleaseObj()
	return part2()
end

--- Helper function.
local function helper_14d3c(arg0: s32)
	local block: s32 = 0
	local language_code: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local language_code_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_a6b0()
				helper_0a1a1684(90)
			end
			if at <= 2 then
				helper_0a1a1684(70)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCameraCtrl(1)
		event.SetFadeIn(1)
		event.SndSeStop(var3, 0)
		event.PlayBgm(0)
		event.DelImg(0)
		event.SetCrossfade(10)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	helper_a6b0()
	event.AssignStack(5)
	event.ClearStack(5)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	else
		block = event.LoadImg_4(5, "dungeon/image/senmetsu/usa/finish.img", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	end
	var3 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var3
	var4 = event.GetEventInfoSndid(4) or var4
	event.SndSeStop(var4, 0)
	event.StopBgm(0)
	event.SndSePlay(var3, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	if arg0 == 2 then
		event.SetFcameraFollowA(var5, var6 + 40.0, var7)
	else
		event.SetFcameraFollowA(var5, var6 + 20.0, var7)
	end
	event.SetCameraSpeed(16.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(10.0)
	event.SetFcameraDist(64.0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsReference(0, pos_x, pos_y, pos_z, 10)
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_0a1a1684(90)
	if vm.skipping() then
		return skip(2)
	end
	language_code_2 = event.GetLanguage() or language_code_2
	if language_code_2 == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 154.0, 370.0, 0, 20)
	end
	helper_0a1a1684(70)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_ba38(arg0: s32)
	local block: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	block = event.LoadImg_4(4, "textures/dungeon/sphida/sphida_bar.json", 0) or block
	event.SphidaSetUp(4, block, arg0)
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local out1, out2, out3 = event.SphidaGetBallPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pin_col = event.SphidaGetPinCol() or pin_col
	ball_col = event.SphidaGetBallCol() or ball_col
	event.LoadChara(4, "dungeon/sphida/bball.gltf", "info", 8)
	event.LoadChara(4, "dungeon/sphida/rball.gltf", "info", 9)
	if ball_col == 0 then
		event.CharaActive(0, 8)
		event.CharaActive(1, 9)
	else
		event.CharaActive(1, 8)
		event.CharaActive(0, 9)
	end
	if pin_col == 0 then
		event.LoadChara(4, "dungeon/sphida/rgool.gltf", "info", 10)
		event.LoadChara(4, "dungeon/sphida/rgool2.gltf", "info", 11)
	else
		event.LoadChara(4, "dungeon/sphida/bgool.gltf", "info", 10)
		event.LoadChara(4, "dungeon/sphida/bgool2.gltf", "info", 11)
	end
	event.CharaActive(10)
	event.CharaActive(11)
	event.SetCharaPos(8, pos_x, pos_y, pos_z)
	event.SetCharaPos(9, pos_x, pos_y, pos_z)
	event.SetCharaPos(10, pos_x_2, pos_y_2, pos_z_2)
	event.SetCharaPos(11, pos_x_2, pos_y_2, pos_z_2)
end

--- Helper function.
local function helper_16484(sp: number)
	local junk = 0
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	local language_code: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local part3: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_132f8()
			junk += 1
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_14d3c(active_chr_no)
			junk += 2
			if not vm.skipping() then
				return part3()
			end
		end
		if at <= 3 then
			helper_ba38(0)
			helper_5ad4(0, 2100, 8, 0, 0, sp + junk + 10)
			junk += 1
		end
		if at <= 4 then
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 10)
			junk += 1
		end
		if at <= 5 then
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 9)
		end
	end
	function part2()
		if active_chr_no == 2 or active_chr_no == 3 then
			helper_14d3c(active_chr_no)
			if vm.skipping() then
				return skip(3)
			end
		end
		return part3()
	end
	function part3()
		var1 = event.GetE3Version() or var1
		if var1 ~= 1 then
			helper_ba38(0)
			do
				local out1, out2, out3 = event.GetBeforeCameraNextPos()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.SetCameraPos(position_x, position_y, position_z)
			do
				local out1, out2, out3 = event.GetBeforeCameraNextRef()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.SetCameraRef(position_x, position_y, position_z)
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			helper_5ad4(0, 2100, 8, 0, 0, sp + junk + 9)
			if vm.skipping() then
				return skip(4)
			end
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 0)
		end
		do
			local out1, out2, out3 = event.GetBeforeCameraNextPos()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraPos(position_x_2, position_y_2, position_z_2)
		do
			local out1, out2, out3 = event.GetBeforeCameraNextRef()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraRef(position_x_2, position_y_2, position_z_2)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		language_code = event.GetLanguage() or language_code
		if language_code == 0 then
			event.MesMake_2(
				0,
				"[(!)]マップに黄色で示されるポイントがゲートです。\n   その場所で、ゲートキーを使えば次のフロアへ行けます。"
			)
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 9)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				" [(!)] The gate is the yellow point on the map.\n   Use the gate key there to go to the next floor."
			)
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 9)
			if vm.skipping() then
				return skip(6)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.Finish()
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	helper_a6b0()
	if active_chr_no == 0 then
		helper_11d88()
		if vm.skipping() then
			return skip(1)
		end
	end
	if active_chr_no == 1 then
		helper_132f8()
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Helper function.
local function helper_2b758(sp: number)
	local junk = 0
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5ad4(0, 2000, 8, 0, 0, sp + junk + 3)
				junk += 1
			end
			return 1
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.SetMesWindowMode(0, 4)
		helper_5ad4(0, 2000, 8, 0, 0, sp + junk + 2)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	var1 = event.GetEquipItemno(0, 0) or var1
	if var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
		event.SetMesWindowMode(0, 4)
		helper_5ad4(0, 2001, 8, 0, 0, sp + junk + 2)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.SetMesWindowMode(0, 1)
	event.SphidaSetCulbNo(var1)
	event.PadAutoRepeatOff()
	return 0
end

--- Helper function.
local function helper_252e4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		x = vm.f32(vm.sin(arg3) * 16.0)
		y = 10.0
		z = vm.f32(vm.cos(arg3) * 16.0)
		arg4 = vm.f32(arg3 + vm.f32(0.6))
		arg3 = vm.f32(arg3 + 0.25)
		arg4 = vm.f32(arg3 - vm.f32(0.6))
		x_2 = vm.f32(vm.sin(arg4) * 16.0)
		y_2 = 10.0
		z_2 = vm.f32(vm.cos(arg4) * 16.0)
		return -1
	end
	if vm.skipping() then
		return skip(1)
	end
	arg3 = event.AngleLimit(arg3) or arg3
	arg3 = event.AngleLimit(arg3) or arg3
	arg4 = event.AngleLimit(arg4) or arg4
	arg4 = event.AngleLimit(arg4) or arg4
	x = vm.f32(vm.sin(arg3) * 16.0)
	y = 10.0
	z = vm.f32(vm.cos(arg3) * 16.0)
	if arg4 ~= arg3 then
		if vm.f32(arg4 - arg3) > 0.0 then
			arg4 = vm.f32(arg3 + vm.f32(0.6))
		else
			arg3 = vm.f32(arg3 + 0.25)
			arg4 = vm.f32(arg3 - vm.f32(0.6))
		end
	end
	arg4 = event.AngleLimit(arg4) or arg4
	x_2 = vm.f32(vm.sin(arg4) * 16.0)
	y_2 = 10.0
	z_2 = vm.f32(vm.cos(arg4) * 16.0)
	do
		local out1, out2, out3 = event.AddVector(x, y, z, arg0, arg1, arg2)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local out1, out2, out3 = event.AddVector(x_2, y_2, z_2, arg0, arg1, arg2)
		x_2 = out1 or x_2
		y_2 = out2 or y_2
		z_2 = out3 or z_2
	end
	var11 = event.ChkIntersectionPoint_9(12, x, y, z, arg0, arg1 + 10.0, arg2, 1) or var11
	if var11 >= 0 then
		return -1
	end
	var11 = event.ChkIntersectionPoint_9(12, x_2, y_2, z_2, arg0, arg1 + 10.0, arg2, 1) or var11
	if var11 >= 0 then
		return -1
	end
	var11 = event.ChkIntersectionPoint_9(12, x, y, z, x_2, y_2, z_2, 1) or var11
	if var11 >= 0 then
		return 0
	end
	var11 = event.ChkIntersectionPoint_9(12, x, y, z, x, y - 20.0, z, 1) or var11
	if var11 < 0 then
		return 0
	end
	var11 = event.ChkIntersectionPoint_9(12, x_2, y_2, z_2, x_2, y_2 - 20.0, z_2, 1) or var11
	if var11 < 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_2cb98(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var8 = 0.0
		var9 = helper_252e4(
			arg0,
			arg1,
			arg2,
			vm.f32(arg3 + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 + var8)
		var9 = helper_252e4(
			arg0,
			arg1,
			arg2,
			vm.f32(arg3 + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 - var8)
		var8 = vm.f32(var8 + vm.f32(0.3926991))
		return arg0, arg1, arg2, arg3
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.SphidaGetBallPos()
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	arg3 = event.GetRefAngle(arg0, arg1, arg2, pos_x, pos_y, pos_z) or arg3
	var8 = 0.0
	while var8 <= vm.f32(3.1415927) do
		var9 = helper_252e4(
			arg0,
			arg1,
			arg2,
			vm.f32(arg3 + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964))
		)
		if var9 == 1 then
			arg3 = vm.f32(arg3 + var8)
			break
		else
			var9 = helper_252e4(
				arg0,
				arg1,
				arg2,
				vm.f32(arg3 + vm.f32(1.5707964)),
				vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964))
			)
			if var9 == 1 then
				arg3 = vm.f32(arg3 - var8)
				break
			else
				var8 = vm.f32(var8 + vm.f32(0.3926991))
			end
		end
	end
	event.SetCharaPos(0, arg0, arg1 - 3.0, arg2)
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "かまえ", 4)
	return arg0, arg1, arg2, arg3
end

--- Helper function.
local function helper_2e360(arg0: f32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var2 = vm.f32(var2 + 25.0)
		arg0 = vm.f32(arg0 - vm.f32(3.1415927))
		var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
		var2 = vm.f32(var2 + 5.0)
		var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraCtrl(0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var2 = vm.f32(var2 + 25.0)
	event.SetCameraRef(var1, var2, var3)
	arg0 = vm.f32(arg0 - vm.f32(3.1415927))
	arg0 = event.AngleLimit(arg0) or arg0
	var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
	var2 = vm.f32(var2 + 5.0)
	var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
	event.SetCameraPos(var1, var2, var3)
	event.SetCameraCtrl(1)
	event.CtrlcMoveRange(10.0, 40.0, 60.0, 160.0)
end

--- Helper function.
local function helper_331b0(arg0: f32, arg1: f32, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0, arg1, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = event.GetEquipItemno(0, 0) or var3
	do
		local out1, out2, out3 = event.SphidaGetCulbDef(var3)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	return arg0, arg1, arg2
end

--- Helper function.
local function helper_21780(arg0: f32, arg1: f32, arg2: s32, sp: number)
	local var3: s32 = 0
	local mini_level: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: s32 = 0
	local var30: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = 0
		var3 = var3 + 1
		var3 = 0
		vm.stack(sp + 40)
		var3 = var3 + 1
		mini_level = 0
		var6 = vm.f32(var6 + 3.0)
		var15 = vm.f32(var15 + 3.0)
		var18 = 600.0
		var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
		var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
		var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
		vm.stack(sp + 41)
		var3 = 1
		vm.stack(sp + 51)
		var18 = vm.f32(var18 - var28)
		vm.stack(sp + 46)
		var30 = vm.f32(20.0 - var28)
		vm.stack(sp + 42)
		var18 = vm.f32(var18 - var30)
		vm.stack(sp + 46)
		mini_level = mini_level + 1
		vm.stack(sp + 43)
		var3 = var3 + 1
		vm.stack(sp + 49)
		mini_level = mini_level + 1
		vm.stack(sp + 46)
		var3 = var3 + 1
		vm.stack(sp + 52)
		mini_level = mini_level + 1
		vm.stack(sp + 49)
		var3 = var3 + 1
		vm.stack(sp + 47)
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = 0
	while var3 < 48 do
		event.SpriteInit(var3)
		event.SpriteSetType(var3, 1)
		event.SpriteSetTexture(var3, "sphida_bar", arg2)
		event.SpriteSetUvsize(var3, 64, 0, 32, 32)
		event.SpriteSetPutsize(var3, 2, 2)
		event.SpriteSetColor(var3, 128, 128, 128, 128)
		event.SpriteSetDraw(var3, 0)
		var3 = var3 + 1
	end
	mini_level = event.SphidaGetMiniLevel() or mini_level
	if mini_level == 0 then
		event.SpriteSetType(31, 0)
		event.SpriteSetUvsize(31, 308, 146, 204, 30)
		event.SpriteSetDraw(31, 1)
		event.SpriteSetPutsize(31, 204, 30)
		event.SpriteSetPos(31, 120, 30)
	elseif mini_level == 2 then
		var3 = 0
		while var3 < 32 do
			event.SpriteSetColor(var3, 128, 128, 128, 32)
			var3 = var3 + 1
		end
	end
	mini_level = 0
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var6 = vm.f32(var6 + 3.0)
	var15 = vm.f32(var15 + 3.0)
	var18 = 600.0
	var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
	var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	do
		local out1, out2, out3 = event.CopyVector(var11, var12, var13)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 30.0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var3 = 1
	while true do
		do
			local out1, out2, out3 = event.AddVector(var5, var6, var7, var8, var9, var10)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		vm.stack(sp + 46)
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.ChkIntersectionPoint_15(12, var14, var15, var16, var5, var6, var7, 1)
			var19 = out1 or var19
			var20 = out2 or var20
			var21 = out3 or var21
			var22 = out4 or var22
			var23 = out5 or var23
			var24 = out6 or var24
			var29 = out7 or var29
		end
		if var29 >= 0 then
			do
				local out1, out2, out3 = event.CopyVector(-var11, -var12, -var13)
				var25 = out1 or var25
				var26 = out2 or var26
				var27 = out3 or var27
			end
			do
				local out1, out2, out3 = event.NormalVector(var25, var26, var27)
				var25 = out1 or var25
				var26 = out2 or var26
				var27 = out3 or var27
			end
			do
				local out1, out2, out3 = event.ScaleVector(var25, var26, var27, 3.0)
				var25 = out1 or var25
				var26 = out2 or var26
				var27 = out3 or var27
			end
			do
				local out1, out2, out3 = event.AddVector(var19, var20, var21, var25, var26, var27)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			var28 = event.DistVector2(var14, var15, var16, var19, var20, var21) or var28
			var18 = vm.f32(var18 - var28)
			if var18 <= 0.0 then
				break
			end
			while true do
				var28 = event.DistVector2(var14, var15, var16, var19, var20, var21) or var28
				if var28 <= 20.0 then
					var30 = vm.f32(20.0 - var28)
					var18 = vm.f32(var18 - var30)
					do
						local out1, out2, out3 = event.CopyVector(var19, var20, var21)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					break
				end
				do
					local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
					var14 = out1 or var14
					var15 = out2 or var15
					var16 = out3 or var16
				end
				event.SpriteSetPos(var3, var14, var15, var16)
				event.SpriteSetDraw(var3, 1)
				if vm.imod(var3, 6) == 0 then
					event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
					mini_level = vm.i32(mini_level + 1)
				end
				var3 = var3 + 1
				if var3 >= 31 then
					break
				end
			end
			if var3 >= 31 then
				break
			end
			do
				local out1, out2, out3 = event.CopyVector(var22, var23, var24)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			do
				local out1, out2, out3 = event.ScaleVector(var11, var12, var13, var30)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			do
				local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			event.SpriteSetPos(var3, var14, var15, var16)
			event.SpriteSetDraw(var3, 1)
			if vm.imod(var3, 6) == 0 then
				event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
				mini_level = vm.i32(mini_level + 1)
			end
			var3 = var3 + 1
			if var3 >= 31 then
				break
			end
			do
				local out1, out2, out3 = event.CopyVector(var22, var23, var24)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			do
				local out1, out2, out3 = event.ScaleVector(var11, var12, var13, 20.0)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			do
				local out1, out2, out3 = event.CopyVector(var22, var23, var24)
				var8 = out1 or var8
				var9 = out2 or var9
				var10 = out3 or var10
			end
			do
				local out1, out2, out3 = event.ScaleVector(var8, var9, var10, var18)
				var8 = out1 or var8
				var9 = out2 or var9
				var10 = out3 or var10
			end
			do
				local out1, out2, out3 = event.CopyVector(var14, var15, var16)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
		else
			while var3 < 31 do
				do
					local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
					var14 = out1 or var14
					var15 = out2 or var15
					var16 = out3 or var16
				end
				event.SpriteSetPos(var3, var14, var15, var16)
				event.SpriteSetDraw(var3, 1)
				if vm.imod(var3, 6) == 0 then
					event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
					mini_level = vm.i32(mini_level + 1)
				end
				var3 = var3 + 1
			end
			break
		end
	end
end

--- Helper function.
local function helper_2415c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = 0
	while var0 < 48 do
		event.SpriteSetDraw(var0, 0)
		var0 = var0 + 1
	end
end

--- Helper function.
local function helper_26e8c(arg0: f32, arg1: f32, arg2: s32, sp: number)
	local junk = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local angle: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 60
			var5 = 76
			local _ = helper_252e4(
				var16,
				var17,
				var18,
				vm.f32(var11 + vm.f32(1.5707964)),
				vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
			) == 1
			var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
			var14 = 0.0
			var5 = 76
			var4 = 400
			var4 = 200
			var5 = 0
			var5 = var5 - 1
			var4 = var4 - 1
			var13 = arg1
			var13 = vm.f32(var13 + var15)
			var13 = 1.0
			var13 = 15.0
			arg0 = var11
			arg1 = var13
			angle = vm.f32(arg0 - vm.f32(3.1415927))
			helper_21780(arg0, arg1, arg2, sp + junk + 27)
			local _ = helper_480(32)
			var3 = 0
			local _ = helper_480(64)
			var3 = 1
			junk += 10
		end
		if at <= 2 then
			helper_2415c()
		end
		return var3, arg0, arg1
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = 60
	var5 = 76
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	event.SetFcameraFollowFlag(1)
	event.SetCameraCtrl(1)
	event.CtrlcSetRotCancel(43)
	event.SetCameraSpeed(6.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraFollow(var6, var7 + 20.0, var8)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(100.0)
	event.CtrlcMoveRange(10.0, 30.0, 80.0, 120.0)
	while true do
		do
			local out1, out2 = event.GetApad_2()
			var14 = out1 or var14
			var15 = out2 or var15
		end
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = event.GetCharaRot(0)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		if var14 ~= 0.0 then
			if
				helper_252e4(
					var16,
					var17,
					var18,
					vm.f32(var11 + vm.f32(1.5707964)),
					vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
				) == 1
			then
				var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
			else
				var14 = 0.0
			end
		end
		event.SetCharaRot(0, var10, var11, var12)
		if var4 <= 0 then
			event.SetMotion(0, "待機")
			var5 = 76
			var4 = 400
		else
			if var14 ~= 0.0 then
				event.SetMotion(0, "かまえバタバタ")
				var4 = 200
				var5 = 0
			elseif var5 <= 0 then
				event.SetMotion(0, "かまえ")
			else
				var5 = var5 - 1
			end
			var4 = var4 - 1
		end
		var13 = arg1
		var13 = vm.f32(var13 + var15)
		if var13 <= 1.0 then
			var13 = 1.0
		end
		if var13 >= 15.0 then
			var13 = 15.0
		end
		arg0 = var11
		arg1 = var13
		event.SphidaCalcCarry(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)
		angle = vm.f32(arg0 - vm.f32(3.1415927))
		angle = event.AngleLimit(angle) or angle
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		helper_21780(arg0, arg1, arg2, sp + junk + 19)
		if helper_480(32) ~= 0 then
			event.SetMotion(0, "かまえ")
			var3 = 0
			break
		elseif helper_480(64) ~= 0 then
			var3 = 1
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	helper_2415c()
	if vm.wait() then
		return skip(3)
	end
	return var3, arg0, arg1
end

--- Helper function.
local function helper_31d20(arg0: s32, sp: number)
	local junk = 0
	local count: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5ad4(0, 2003, 8, 0, 0, sp + junk + 7)
			junk += 2
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SphidaSetStatusFlag(0)
	event.DeleteChara(12)
	event.DelExtMotion(0)
	event.SetMotion(0, "立ち", 4)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 1)
	event.SetCameraCtrl(1)
	event.DeleteSwordEffect()
	event.SetCrossfade(15)
	count = event.SphidaGetParCount() or count
	if arg0 == 0 and count <= 0 then
		do
			local out1, out2, out3 = event.GetBeforeCameraNextPos()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.SetCameraPos(position_x, position_y, position_z)
		do
			local out1, out2, out3 = event.GetBeforeCameraNextRef()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.SetCameraRef(position_x, position_y, position_z)
		event.SetMesWindowMode(0, 4)
		helper_5ad4(0, 2003, 8, 0, 0, sp + junk + 5)
		if vm.skipping() then
			return skip(2)
		end
		event.ResetCamera(1)
	end
	event.Finish()
end

--- Helper function.
local function helper_28d10(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: f32, arg5: s32, arg6: s32)
	local angle: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local code: s32 = 0
	local var12: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local value: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_480(64)
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		return 0, arg0, arg2, arg3, arg4, arg6
	end
	angle = vm.f32(arg2 - vm.f32(3.1415927))
	angle = event.AngleLimit(angle) or angle
	var12 = 0
	code = -10
	event.SphidaResetPowgage()
	event.SphidaStartPowgage()
	while code == -10 do
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		do
			local out1, out2 = event.GetApad_2()
			var8 = out1 or var8
			var9 = out2 or var9
		end
		event.SphidaSetSpinMarkPos(var8, var9)
		if vm.wait() then
			return skip(1)
		end
		if (if var12 == 0 then helper_480(64) else 0) ~= 0 then
			event.SphidaSetSpinMarkPos(0.0, 0.0)
			event.SphidaResetPowgage()
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		if helper_480(32) ~= 0 then
			event.SndSePlay(arg5, 0)
			event.SphidaTriggerPowgage()
			do
				local out1, out2 = event.SphidaGetPgCursorPos()
				x = out1 or x
				y = out2 or y
			end
			event.SpriteSetType(10 + var12, 0)
			event.SpriteSetAlphab(10 + var12, 2)
			event.SpriteSetUvsize(10 + var12, 0, 224, 32, 32)
			event.SpriteSetDraw(10 + var12, 1)
			event.SpriteSetPutsize(10 + var12, 32, 32)
			event.SpriteSetPos(10 + var12, x, y)
			event.SpriteSetScale(10 + var12, 0.2, 0.2, 0.2)
			event.EohSyncSprite(20, 10 + var12)
			event.ObjsInit(20)
			event.ObjsSyncObj(20, 20)
			event.ObjsSetScale(20, 2, 2, 2, 10)
			event.ObjsSetColor(20, 128, 128, 128, 128, 2)
			event.ObjsSetColor(20, 128, 128, 128, 0, 8)
			var12 = 1
		end
		code = event.SphidaGetPowgageCode() or code
	end
	if code == 5 then
		event.SphidaSetSpinMarkPos(0.0, 0.0)
		event.SphidaResetPowgage()
		return 1, arg0, arg2, arg3, arg4, arg6
	end
	arg0 = event.SphidaGetShotPow() or arg0
	if code == 4 then
		arg0 = vm.f32(arg0 * 0.0)
	end
	if code == -3 then
		arg0 = vm.f32(arg0 * vm.f32(0.4))
		value = event.GetRand(0.2) or value
		value = vm.f32(value - vm.f32(0.1))
		arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.4)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
	end
	if code == 3 then
		arg0 = vm.f32(arg0 * vm.f32(0.4))
		value = event.GetRand(0.2) or value
		value = vm.f32(value - vm.f32(0.1))
		arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.4)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
	end
	if code == -2 then
		arg0 = vm.f32(arg0 * vm.f32(0.8))
		value = event.GetRand(0.05) or value
		value = vm.f32(value - vm.f32(0.025))
		arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.1)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
	end
	if code == 2 then
		arg0 = vm.f32(arg0 * vm.f32(0.8))
		value = event.GetRand(0.05) or value
		value = vm.f32(value - vm.f32(0.025))
		arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.1)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
	end
	if code == -1 then
		arg0 = vm.f32(arg0 * 1.0)
		value = event.GetRand(0.01) or value
		arg2 = vm.f32(arg2 - value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
	end
	if code == 1 then
		arg0 = vm.f32(arg0 * 1.0)
		value = event.GetRand(0.01) or value
		arg2 = vm.f32(arg2 + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
	end
	if code == 0 then
		arg0 = vm.f32(arg0 * vm.f32(1.1))
		var8 = vm.f32(var8 * arg0)
		var9 = vm.f32(var9 * arg0)
	end
	arg6 = code
	arg2 = event.AngleLimit(arg2) or arg2
	arg3 = var8
	arg4 = var9
	helper_0a1a1684(10)
	if vm.skipping() then
		return skip(2)
	end
	return 0, arg0, arg2, arg3, arg4, arg6
end

--- Helper function.
local function helper_2f81c(arg0: s32)
	local count: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	count = event.SphidaGetParCount() or count
	event.SphidaSetParCount(count)
	if count <= 0 then
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SphidaSetPlayFlag(0)
		if arg0 ~= -1 then
			event.SndSePlay(arg0, 19)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_684(32)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	helper_684(32)
	if vm.skipping() then
		return skip(2)
	end
	event.Finish()
end

--- Program 300.
script[300] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48914(0, sp + 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 310.
script[310] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48914(1, sp + 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 320.
script[320] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48914(2, sp + 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 330.
script[330] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48914(3, sp + 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 340.
script[340] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_4a9a0(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
end

script[1000] = program_1000

--- Program 1100.
script[1100] = function()
	local sp: number = 0
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efc0(var2, var3, sp + 4)
		end
	end
	event.Initialize()
	event.SetCrossfade(30)
	event.CharaActive(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		var1 = event.GetRoboMoveType() or var1
		if var1 == 1 then
			event.SetMotion(0, "立ち-足")
		end
		if var1 == 2 then
			event.SetMotion(0, "立ち-キャタピラ")
		end
	end
	do
		local out1, out2 = event.GetTbItemno()
		var2 = out1 or var2
		var3 = out2 or var3
	end
	if var3 <= -1 then
		helper_e218(var2, sp + 4)
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_efc0(var2, var3, sp + 4)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 1120.
script[1120] = function()
	local sp: number = 0
	local junk = 0
	local language_code: s32 = 0
	local active_chr_no: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var12: s32 = 0
	local weight: f32 = 0
	local var15: f32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local value: s32 = 0
	local angle: f32 = 0
	local value_2: s32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
			var3 = pos_y
			var4 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
			return
		end
		if at <= 2 then
			helper_86d71b61()
		end
		if at <= 4 then
			helper_86d71b61()
		end
		if at <= 5 then
			var15 = vm.f32(var15 - vm.f32(3.1415927))
			var18 = 0
			var19 = vm.f32(0.6)
			var15 = vm.f32(var15 + var19)
			helper_8ea8()
			helper_3dddb3a4(1, -1, 15, 0, 0)
			local _ = helper_00523c4e(0)
			junk += 5
		end
		if at <= 6 then
			var18 = vm.i32(var18 + 1)
		end
		if at <= 7 then
			helper_9074()
			value = 0
			value = value + 4
			var18 = 0
			var15 = vm.f32(var15 + var19)
			junk += 1
		end
		if at <= 8 then
			var19 = vm.f32(var19 * vm.f32(0.9))
			angle = var26
			local _ = helper_191e4(var15, angle, vm.f32(0.08)) == 0
			var17 = 0
			angle = vm.f32(var26 - vm.f32(3.1415927))
			local _ = helper_191e4(var15, angle, vm.f32(0.08)) == 0
			var17 = 1
			var18 = vm.i32(var18 + 1)
			helper_0a1a1684(20)
			junk += 6
		end
		if at <= 9 then
			var30 = 2
			var30 = 4
			var26 = vm.f32(var26 + vm.f32(3.14))
			var17 = 1
			var17 = 0
			helper_0a1a1684(10)
			junk += 4
		end
		if at <= 10 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = vm.f32(var26 + vm.f32(1.57))
			var26 = vm.f32(var26 + vm.f32(1.57))
			helper_0a1a1684(20)
			junk += 1
		end
		if at <= 11 then
			local _ = helper_191e4(var15, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var31 = 1.0
			var18 = 0
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
			junk += 3
		end
		if at <= 12 then
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 35)
			junk += 1
		end
		if at <= 13 then
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 38)
			junk += 4
		end
		if at <= 14 then
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			junk += 5
		end
		if at <= 15 then
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 35)
			junk += 1
		end
		if at <= 16 then
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 49)
			junk += 15
		end
		if at <= 17 then
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 49)
			junk += 15
		end
	end
	event.Initialize()
	language_code = event.GetLanguage() or language_code
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.DngPause(1, 1)
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_a6b0()
		if language_code == 0 then
			if active_chr_no == 2 then
				event.MesMake_2(0, "ライドポッドから降りないとダメなようだ。")
			else
				event.MesMake_2(0, "モンスターに変化した状態だとダメなようだ")
			end
		elseif active_chr_no == 2 then
			event.MesMake_2(0, "Must get off the Ridepod.")
		else
			event.MesMake_2(0, "Looks like you can't do it\nas a monster.")
		end
		helper_5ad4(0, -1, 8, 0, 0, sp + junk + 34)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		do
			local out1, out2, out3 = event.RandomCircleGetPos(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.GetRefAngle(pos_x, pos_y, pos_z, var2, var3, var4) or yaw
		var2 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var3 = pos_y
		var4 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.SetCharaPos(0, var2, var3, var4)
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	do
		local out1, out2, out3 = event.RandomCircleGetPos(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.SetCameraSpeed(8.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(80.0)
	helper_a6b0()
	event.DngPause(17, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile("snd2/sp/sp_011.sound.json")
	if vm.wait() then
		return skip(2)
	end
	helper_86d71b61()
	if vm.skipping() then
		return skip(3)
	end
	var12 = event.SndLoadSound(8, "snd2/sp/sp_011.sound.json") or var12
	event.SndSePlay(var12, 0)
	event.SetLoadbgFile("event/dng/ring.gltf", "event/dng/randomcoin.gltf")
	if vm.wait() then
		return skip(4)
	end
	helper_86d71b61()
	if vm.skipping() then
		return skip(5)
	end
	weight = event.GetRndcMotNowt() or weight
	event.RandomCircleOff(-1)
	event.LoadChara(5, "event/dng/ring.gltf", "info", 12)
	event.CharaActive(1, 12)
	event.SetCharaPos(12, pos_x_2, pos_y_2, pos_z_2)
	event.SetMotion(12, "ループ", 6)
	event.CharaNormalDrive(12)
	event.SetCharaMotNowt(12, weight)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsNextMotion(4, "消滅", 6)
	event.LoadChara(5, "event/dng/randomcoin.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.SetCharaPos(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var15 = event.GetRand(6.2831855) or var15
	var15 = vm.f32(var15 - vm.f32(3.1415927))
	var15 = event.AngleLimit(var15) or var15
	event.SetCharaRot(13, 0.0, var15, 0.0)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetScale(5, 0.0, 0.0, 0.0)
	event.ObjsSetScale(5, 1.0, 1.0, 1.0, 40)
	event.ObjsMove2(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var15 = out2 or var15
		end
		var15 = vm.f32(var15 + var19)
		var15 = event.AngleLimit(var15) or var15
		event.SetCharaRot(13, 0.0, var15, 0.0)
		if var18 == 30 then
			if language_code == 0 then
				helper_8ea8()
			else
				event.SetMesWindowMode(1, 7)
				event.SetMesPreset(1, 2)
				event.MesMake_2(1, "It stops with (O) button.")
				helper_3dddb3a4(1, -1, 15, 0, 0)
			end
		end
		if (if var18 >= 30 then helper_00523c4e(0) else 0) ~= 0 then
			event.SndSeStop(var12, 0)
			event.SndSePlay(var12, 3)
			if vm.wait() then
				return skip(6)
			end
			break
		else
			var18 = vm.i32(var18 + 1)
			if vm.wait() then
				return skip(7)
			end
		end
	end
	helper_9074()
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	value = 0
	value = event.GetRandInt(10) or value
	value = vm.i32(value + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var15 = out2 or var15
		end
		var15 = vm.f32(var15 + var19)
		var15 = event.AngleLimit(var15) or var15
		event.SetCharaRot(13, 0.0, var15, 0.0)
		if vm.wait() then
			return skip(8)
		end
		if var18 >= value then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.AngleLimit(angle) or angle
			if var15 < angle and helper_191e4(var15, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.AngleLimit(angle) or angle
			if var15 < angle and helper_191e4(var15, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	helper_0a1a1684(20)
	if vm.skipping() then
		return skip(9)
	end
	value_2 = event.GetRandInt(10) or value_2
	if value_2 < 6 then
		value_2 = event.GetRandInt(10) or value_2
		if var17 == 0 then
			var30 = 2
		else
			var30 = 4
		end
		if value_2 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.AngleLimit(var26) or var26
			event.ObjsRotation(5, 0.0, var26, 0.0, 8)
			if var17 == 0 then
				var17 = 1
			else
				var17 = 0
			end
			helper_0a1a1684(10)
			if vm.skipping() then
				return skip(10)
			end
		else
			value_2 = event.GetRandInt(10) or value_2
			if value_2 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				helper_0a1a1684(20)
				if vm.skipping() then
					return skip(11)
				end
			end
		end
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var15 = out2 or var15
	end
	if helper_191e4(var15, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	var31 = 1.0
	var18 = 0
	var32 = event.GetRndCircleTrapid(var17) or var32
	if var17 == 0 then
		event.SndSePlay(var12, 1)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(12)
			end
		end
		if language_code == 0 then
			event.MesMake_2(0, "コインは天使の面をこちらに向けた。")
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 34)
			if vm.skipping() then
				return skip(13)
			end
			if var32 == 1 then
				event.MesMake_2(0, "ＡＢＳボーナス")
			end
			if var32 == 2 then
				event.MesMake_2(
					0,
					"天使は「体力」と「ステータス異常」を\n全回復してくれた。"
				)
			end
			if var32 == 3 then
				event.MesMake_2(0, "天使は「ＷＨＰ」を全回復してくれた。")
			end
			if var32 == 4 then
				event.MesMake_2(0, "天使は「宝箱」を置いていった。")
				event.PostTreasureBox(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			end
		else
			event.MesMake_2(0, "The coin flipped to the 'Angel'.")
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 34)
			if vm.skipping() then
				return skip(14)
			end
			if var32 == 1 then
				event.MesMake_2(0, "ABS bonus!")
			end
			if var32 == 2 then
				event.MesMake_2(0, "Strength & status fully\nrecovered by the Angel.")
			end
			if var32 == 3 then
				event.MesMake_2(0, "WHP fully recovered by the Angel.")
			end
			if var32 == 4 then
				event.MesMake_2(0, "Angel left a treasure box.")
				event.PostTreasureBox(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			end
		end
	else
		event.SndSePlay(var12, 2)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(15)
			end
		end
		if language_code == 0 then
			event.MesMake_2(0, "コインは悪魔の面をこちらに向けた。")
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 34)
			if vm.skipping() then
				return skip(16)
			end
			if var32 == 5 then
				if active_chr_no == 0 or active_chr_no == 2 then
					event.MesMake_2(0, "悪魔はユリスに「毒」のステータス異常をあたえた。")
				end
				if active_chr_no == 1 or active_chr_no == 3 then
					event.MesMake_2(0, "悪魔はモニカに「毒」のステータス異常をあたえた。")
				end
			end
			if var32 == 6 then
				if active_chr_no == 0 then
					event.MesMake_2(0, "悪魔はユリスの体力を半分にした。")
				end
				if active_chr_no == 1 or active_chr_no == 3 then
					event.MesMake_2(0, "悪魔はモニカの体力を半分にした。")
				end
				if active_chr_no == 2 then
					event.MesMake_2(0, "悪魔はスティーブの耐久力を半分にした。")
				end
			end
			if var32 == 8 then
				event.MesMake_2(0, "悪魔は銃の「ＷＨＰ」を半分にした。")
			end
			if var32 == 9 then
				event.MesMake_2(0, "悪魔はレンチの「ＷＨＰ」を半分にした。")
			end
			if var32 == 10 then
				event.MesMake_2(0, "悪魔は腕輪の「ＷＨＰ」を半分にした。")
			end
			if var32 == 11 then
				event.MesMake_2(0, "悪魔は剣の「ＷＨＰ」を半分にした。")
			end
			if var32 == 12 then
				event.MesMake_2(0, "悪魔は全モンスターを復活させた。")
			end
		else
			event.MesMake_2(0, "The coin flipped to 'Devil'")
			helper_5ad4(0, -1, 8, 0, 0, sp + junk + 34)
			if vm.skipping() then
				return skip(17)
			end
			if var32 == 5 then
				if active_chr_no == 0 or active_chr_no == 2 then
					event.MesMake_2(0, "Devil caused an abnormal status.")
				end
				if active_chr_no == 1 or active_chr_no == 3 then
					event.MesMake_2(0, "Devil has poisoned Maximilian.")
				end
			end
			if var32 == 6 then
				if active_chr_no == 0 then
					event.MesMake_2(0, "Devil takes half of Maximilian's health.")
				end
				if active_chr_no == 1 or active_chr_no == 3 then
					event.MesMake_2(0, "Devil takes half of Monica's health.")
				end
				if active_chr_no == 2 then
					event.MesMake_2(0, "Devil takes half of Steve's health.")
				end
			end
			if var32 == 8 then
				event.MesMake_2(0, "Devil takes half of your gun's WHP.")
			end
			if var32 == 9 then
				event.MesMake_2(0, "Devil takes half of your wrench's WHP.")
			end
			if var32 == 10 then
				event.MesMake_2(0, "Devil takes half your bracelet's WHP.")
			end
			if var32 == 11 then
				event.MesMake_2(0, "Devil takes half of your sword's WHP.")
			end
			if var32 == 12 then
				event.MesMake_2(0, "Devil resurrected all monsters.")
			end
		end
	end
	result = event.SetRndCircleStatus(var32) or result
	helper_5ad4(0, -1, 8, 0, 0, sp + junk + 34)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.BscnSetBlightRate(1.0)
	if var32 == 1 then
		event.SetPullItem(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.DngPause(17, 0)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetCrossfade(15)
	event.Finish()
end

--- Program 1130.
script[1130] = function()
	local sp: number = 0
	local junk = 0
	local active_chr_no: s32 = 0
	local language_code: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_86d71b61()
		end
		if at <= 3 then
			junk += 1
		end
		if at <= 4 then
			helper_86d71b61()
		end
		if at <= 5 then
			pos_y_2 = vm.f32(var10 + 18.0)
			var18 = vm.f32(var18 + vm.f32(2.9))
			var18 = vm.f32(var18 + vm.f32(2.4))
			var9 = vm.f32(vm.f32(vm.sin(var18) * 14.0) + pos_x_2)
			var11 = vm.f32(vm.f32(vm.cos(var18) * 14.0) + pos_z_2)
			var18 = vm.f32(var18 - vm.f32(3.1415927))
			var19 = vm.f32(vm.f32(vm.sin(var18) * 8.0) + var9)
			var20 = vm.f32(var10 + 18.0)
			var21 = vm.f32(vm.f32(vm.cos(var18) * 8.0) + var11)
			helper_0a1a1684(16)
			junk += 4
		end
		if at <= 6 then
			helper_0a1a1684(2)
		end
		if at <= 7 then
			helper_0a1a1684(10)
		end
		if at <= 8 then
			helper_0a1a1684(20)
		end
		if at <= 9 then
			helper_90139a55(0)
		end
		if at <= 10 then
			helper_95c4(358, 1, sp + junk + 22)
		end
		if at <= 11 then
			junk += 1
		end
	end
	event.Initialize()
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.DngPause(1, 1)
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_a6b0()
		language_code = event.GetLanguage() or language_code
		if language_code == 0 then
			if active_chr_no == 2 then
				event.MesMake_2(0, "ライドポッドから降りないとダメなようだ。")
			else
				event.MesMake_2(0, "モンスターに変化した状態だとダメなようだ")
			end
		elseif active_chr_no == 2 then
			event.MesMake_2(0, "Must get off the Ridepod.")
		else
			event.MesMake_2(0, "Looks like you can't do it\nas a monster.")
		end
		helper_5ad4(0, -1, 8, 0, 0, sp + junk + 22)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	if active_chr_no == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(2)
		end
		helper_86d71b61()
		if vm.skipping() then
			return skip(3)
		end
		event.LoadMotion(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.SetLoadbgFile(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(4)
		end
		helper_86d71b61()
		if vm.skipping() then
			return skip(5)
		end
		event.LoadMotion(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var5 = event.SndLoadSound(8, "snd2/sp/sp_012.sound.json") or var5
	event.DngPause(17, 1)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	event.CopyVector(var9, var10, var11)
	event.GeostoneAnimeOff()
	event.EohSyncGeostone(1)
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var10 + 18.0)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var18 = event.GetRefAngle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var18
	var18 = event.AngleLimit(var18) or var18
	if active_chr_no == 0 then
		var18 = vm.f32(var18 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var18 = vm.f32(var18 + vm.f32(2.4))
	end
	var18 = event.AngleLimit(var18) or var18
	var9 = vm.f32(vm.f32(vm.sin(var18) * 14.0) + pos_x_2)
	var11 = vm.f32(vm.f32(vm.cos(var18) * 14.0) + pos_z_2)
	event.SetCharaPos(0, var9, var10, var11)
	var18 = vm.f32(var18 - vm.f32(3.1415927))
	var18 = event.AngleLimit(var18) or var18
	event.SetCharaRot(0, 0.0, var18, 0.0)
	event.EohResetDaPosition(0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.CharaActive(0, 12)
	if active_chr_no == 0 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var9, var10 + 18.0, var11)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 6.0, 0.0)
		event.SetFcameraHeight(-14.0)
		event.SetFcameraDist(54.0)
		event.SetCharaPos(12, var9, var10 + 36.0, var11)
	end
	if active_chr_no == 1 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var9, var10 + 18.0, var11)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
		event.SetFcameraHeight(-5.0)
		event.SetFcameraDist(34.0)
		var19 = vm.f32(vm.f32(vm.sin(var18) * 8.0) + var9)
		var20 = vm.f32(var10 + 18.0)
		var21 = vm.f32(vm.f32(vm.cos(var18) * 8.0) + var11)
		event.SetCharaPos(12, var19, var20, var21)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.SetCrossfade(30)
	event.ObjsSetMotion(0, "取る", 6)
	event.ObjsNextMotion(0, "取るL", 4)
	helper_0a1a1684(16)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var5, 0)
	helper_0a1a1684(2)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.GeostoneSetReference(0, "item")
	helper_0a1a1684(10)
	if vm.skipping() then
		return skip(8)
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var18 = event.GetRefAngle(var9, var10, var11, pos_x, pos_y, pos_z) or var18
	event.SetCharaRot(12, 0.0, var18, 0.0)
	event.CharaActive(1, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetMotion(4, "発動", 6, 1.2)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "発動", 5)
	helper_0a1a1684(20)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var5, 1)
	helper_90139a55(0)
	if vm.skipping() then
		return skip(10)
	end
	helper_95c4(358, 1, sp + junk + 22)
	if vm.skipping() then
		return skip(11)
	end
	event.SetCrossfade(10)
	if active_chr_no == 1 then
		event.SetMotion(0, "取る戻り", 6)
		if vm.wait() then
			return skip(12)
		end
	end
	event.DngPause(17, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetCharaPos(0, var2, var3, var4)
	event.EohResetDaPosition(0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.GeostoneDelReference()
	event.GeostoneSetFlag(0)
	event.EohSetScale(1, 1.0, 1.0, 1.0)
	event.DelExtMotion(0)
	event.DeleteChara(12)
	event.Finish()
end

--- Program 1150.
script[1150] = function()
	local sp: number = 0
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local out1, out2 = event.GetMonsterTalkData_2()
		var0 = out1 or var0
		var1 = out2 or var1
	end
	helper_7c80(var0, vm.i32(var1 + 1000), sp + 2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1200.
script[1200] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_17438(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local sp: number = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_16484(sp + 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 3000.
script[3000] = function()
	local sp: number = 0
	local junk = 0
	local tex_bank: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local var31: s32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: f32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	local var49: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var53: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var59: any = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				local _ = helper_2b758(sp + junk + 60)
				junk += 1
			end
			return
		end
		if at <= 6 then
			if at <= 3 then
				helper_86d71b61()
			end
			if at <= 4 then
				var2, var3, var4, var6 = helper_2cb98(var2, var3, var4, var6)
				helper_2e360(var6)
				var11 = 7.0
				var12, var13, var14 = helper_331b0(var12, var13, var14)
				_, var6, var11 = helper_26e8c(var6, var11, tex_bank, sp + junk + 61)
				junk += 2
			end
			if at <= 5 then
				helper_31d20(0, sp + junk + 60)
			end
			return
		end
		if at <= 14 then
			if at <= 8 then
				var21 = 0
				helper_0a1a1684(10)
				junk += 8
			end
			if at <= 9 then
				helper_0a1a1684(25)
				junk += 1
			end
			if at <= 10 then
				helper_0a1a1684(34)
				junk += 1
			end
			if at <= 11 then
				helper_0a1a1684(39)
			end
			if at <= 12 then
				helper_0a1a1684(50)
				junk += 2
			end
			if at <= 13 then
				helper_2f81c(var1)
				helper_31d20(0, sp + junk + 60)
			end
			return
		end
		if at <= 15 then
			var44 = var44 - 1
			var46 = var46 + 1
			junk += 1
		end
		if at <= 16 then
			var46 = 0
			var46 = var46 + 1
			junk += 3
		end
		if at <= 17 then
			var46 = 0
			var46 = var46 + 1
			junk += 1
		end
		if at <= 18 then
			helper_0a1a1684(54)
		end
		if at <= 19 then
			helper_0a1a1684(30)
		end
		if at <= 20 then
			helper_90139a55(0)
		end
		if at <= 21 then
			helper_0a1a1684(90)
		end
		if at <= 23 then
			var59 = helper_258919ac(0, 2002, 8, 256, 208, 2, 0)
			junk += 1
		end
		if at <= 25 then
			var46 = 0
			var46 = var46 + 1
			var6 = vm.f32(var6 - vm.f32(3.1415927))
			var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
			var9 = vm.f32(var9 + 30.0)
			var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
			helper_90139a55(0)
			junk += 4
		end
		if at <= 26 then
			helper_0a1a1684(20)
		end
		if at <= 27 then
			helper_2f81c(-1)
			helper_2f81c(var1)
			helper_31d20(var21, sp + junk + 61)
			junk += 1
		end
	end
	if vm.wait() then
		return skip(1)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	local t0 = helper_2b758(sp + junk + 60)
	if vm.skipping() then
		junk += 1
		return skip(2)
	end
	if t0 ~= 0 then
		return
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile("dungeon/sphida/c01_golf.gltf", "dungeon/chara/c01b_miss.gltf", "dungeon/sphida/gool_end.gltf")
	if vm.wait() then
		return skip(3)
	end
	helper_86d71b61()
	if vm.skipping() then
		return skip(4)
	end
	event.LoadMotion(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.SphidaGetTexb() or tex_bank
	event.LoadChara(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.CharaActive(0, 12)
	var1 = event.SndLoadSound(5, "snd2/mon/en_900.sound.json") or var1
	event.CreateSwordEffect(5, 64, 16)
	event.SwordEffectColor(128, 128, 128, 80, 128, 128, 128, 80)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 0)
	event.SetCrossfade(15)
	event.SphidaResetPowgage()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var2, var3, var4, var6 = helper_2cb98(var2, var3, var4, var6)
	helper_2e360(var6)
	event.SphidaSetStatusFlag(1)
	var11 = 7.0
	event.SphidaCalcCarry(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12, var13, var14 = helper_331b0(var12, var13, var14)
	event.SphidaSetPowgageSafeLevel(var14)
	do
		local out1, out2, out3 = event.ZeroVector()
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	while true do
		event.SphidaSetMinimapFlag(1)
		event.SphidaSetMmLineFlag(1)
		local t1: s32
		t1, var6, var11 = helper_26e8c(var6, var11, tex_bank, sp + junk + 60)
		local t2 = t1
		if vm.skipping() then
			junk += 1
			return skip(5)
		end
		if t2 ~= 0 then
			event.SphidaSetMinimapFlag(0)
			event.SphidaSetMmLineFlag(0)
			event.SetCharaPos(0, var8, var9, var10)
			helper_31d20(0, sp + junk + 60)
			if vm.skipping() then
				return skip(6)
			end
			return
		end
		event.SphidaSetMinimapFlag(0)
		event.SphidaSetMmLineFlag(0)
		local t3: s32
		t3, var12, var6, var16, var15, var14 = helper_28d10(var12, tex_bank, var6, var16, var15, var1, var14)
		local t4 = if t3 == 0 then 1 else 0
		if vm.skipping() then
			junk += 1
			return skip(7)
		end
		if t4 ~= 0 then
			break
		else
			if vm.wait() then
				return skip(8)
			end
		end
	end
	do
		local out1, out2, out3 = event.CopyVector(var2, var3, var4)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var21 = 0
	if var14 ~= 1 and var14 ~= -1 and var14 ~= 4 then
		event.SpriteSetType(0, 1)
		event.SpriteSetDraw(0, 1)
		event.SpriteSetPutsize(0, 10.8, 11.6)
		event.SpriteSetPos(0, var2, var3 + 30.0, var4)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		if var14 == 0 then
			event.SpriteSetUvsize(0, 78, 198, 54, 58)
		end
		if var14 == 2 or var14 == -2 then
			event.SpriteSetUvsize(0, 186, 190, 70, 66)
		end
		if var14 == 3 or var14 == -3 then
			event.SpriteSetUvsize(0, 132, 198, 54, 58)
		end
		event.EohSyncSprite(18, 0)
		event.ObjsInit(18)
		event.ObjsSyncObj(18, 18)
		event.ObjsSetColor(18, 128, 128, 128, 128, 4)
		event.ObjsColorDelay(18, 20)
		event.ObjsSetColor(18, 128, 128, 128, 0, 6)
		helper_0a1a1684(10)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var12 <= vm.f32(0.3) then
		event.SetMotion(0, "小ショット", 2)
		helper_0a1a1684(25)
		if vm.skipping() then
			return skip(10)
		end
		event.SndSePlay(var1, 3)
	elseif var12 <= vm.f32(0.6) then
		event.SetMotion(0, "中ショット", 2)
		helper_0a1a1684(34)
		if vm.skipping() then
			return skip(11)
		end
		event.SndSePlay(var1, 2)
	else
		event.SetMotion(0, "大ショット", 2)
		helper_0a1a1684(39)
		if vm.skipping() then
			return skip(12)
		end
		if var14 == 0 then
			event.SndSePlay(var1, 12)
		else
			event.SndSePlay(var1, 1)
		end
	end
	if var14 == 4 then
		helper_0a1a1684(50)
		if vm.skipping() then
			return skip(13)
		end
		helper_2f81c(var1)
		event.SetCharaPos(0, var8, var9, var10)
		helper_31d20(0, sp + junk + 60)
		if vm.skipping() then
			return skip(14)
		end
		return
	end
	if var14 == 0 then
		event.SpriteSetType(1, 0)
		event.SpriteSetDraw(1, 1)
		event.SpriteSetPos(1, 256, 278)
		event.SpriteSetUvsize(1, 246, 104, 266, 42)
		event.SpriteSetPutsize(1, 266, 42)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetScale(1, 10, 10, 10)
		event.EohSyncSprite(19, 1)
		event.ObjsInit(19)
		event.ObjsSyncObj(19, 19)
		event.ObjsJump(19, 256, 138, 0, 3.6, 20)
		event.ObjsSetScale(19, 1, 1, 1, 18)
		event.ObjsSetColor(19, 128, 128, 128, 128, 12)
		event.ObjsColorDelay(19, 30)
		event.ObjsSetColor(19, 128, 128, 128, 0, 6)
	end
	var12 = helper_dff48a5c(var12)
	var22 = vm.f32(vm.sin(var6) * vm.f32(var12 * vm.cos(vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0))))
	var23 = vm.f32(var12 * vm.sin(vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)))
	var24 = vm.f32(vm.cos(var6) * vm.f32(var12 * vm.cos(vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0))))
	var16 = vm.f32(vm.f32(var16 * vm.f32(3.1415927)) / 2.0)
	var17 = vm.f32(vm.f32(vm.f32(-var24 * var13) * var15) * vm.f32(0.4))
	var15 = vm.f32(vm.f32(vm.f32(-var22 * var13) * var15) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		var26 = out1 or var26
		var27 = out2 or var27
		var28 = out3 or var28
	end
	var29 = 180.0
	var30 = -50.0
	var31 = 0
	var14 = 0
	var44 = 0
	var46 = 0
	while true do
		if var3 >= var29 then
			var22 = vm.f32(var22 * vm.f32(0.999))
			var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0098) * (var46 + 1)))
			var24 = vm.f32(var24 * vm.f32(0.999))
		else
			var43 = event.ChkIntersectionPoint_9(12, var2, var3, var4, var2, vm.f32(var3 - 3.0) - vm.f32(0.01), var4, 0)
				or var43
			if var14 == 1 and var43 >= 0 then
				var22 = vm.f32(var22 * vm.f32(0.94))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.00045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.94))
				var22 = vm.f32(var22 + var15)
				var24 = vm.f32(var24 + var17)
				var15 = vm.f32(var15 * vm.f32(0.8))
				var17 = vm.f32(var17 * vm.f32(0.8))
			else
				var22 = vm.f32(var22 * vm.f32(0.999))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.AddVector(var2, var3, var4, var22, var23, var24)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		if var16 ~= 0.0 then
			var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
			var11 = vm.f32(var11 + var16)
			var11 = event.AngleLimit(var11) or var11
			var22 = vm.f32(var22 + vm.f32(vm.f32(vm.sin(var11) / 10.0) * var13))
			var24 = vm.f32(var24 + vm.f32(vm.f32(vm.cos(var11) / 10.0) * var13))
		end
		var15 = vm.f32(var15 * vm.f32(0.994))
		var17 = vm.f32(var17 * vm.f32(0.994))
		var42 = event.DistVector(var15, 0.0, var17) or var42
		if var42 > vm.f32(0.01) then
			var25 = event.DistVector(var15, 0.0, var17) or var25
			var11 = event.GetRefAngle(var18, var19, var20, var18 + var15, var19, var20 + var17) or var11
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.SetCharaRot(8, var5, var11, var7)
			event.AddCharaRot(8, var25 * 14.0, 0.0, 0.0)
			event.SetCharaRot(9, var5, var11, var7)
			event.AddCharaRot(9, var25 * 14.0, 0.0, 0.0)
		else
			var25 = event.DistVector(var22, 0.0, var24) or var25
			var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.SetCharaRot(8, var5, var11, var7)
			event.AddCharaRot(8, var25 / 10.0, 0.0, 0.0)
			event.SetCharaRot(9, var5, var11, var7)
			event.AddCharaRot(9, var25 / 10.0, 0.0, 0.0)
		end
		var25 = event.DistVector(var22, var23, var24) or var25
		var41 = var25
		var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
		var38 = vm.f32(vm.sin(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		var40 = vm.f32(vm.cos(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		event.SwordEffectAddPoint(
			var2 - var38,
			var3,
			var4 - var40,
			vm.f32(var2 + var38) + var38,
			var3,
			vm.f32(var4 + var40) + var40
		)
		do
			local out1, out2, out3 = event.CopyVector(var22, var23, var24)
			var38 = out1 or var38
			var39 = out2 or var39
			var40 = out3 or var40
		end
		do
			local out1, out2, out3 = event.NormalVector(var38, var39, var40)
			var38 = out1 or var38
			var39 = out2 or var39
			var40 = out3 or var40
		end
		do
			local out1, out2, out3 = event.ScaleVector(var38, var39, var40, 3.0)
			var38 = out1 or var38
			var39 = out2 or var39
			var40 = out3 or var40
		end
		do
			local out1, out2 =
				event.ChkIntersectionPoint_10(0, var18, var19, var20, var2 + var38, var3 + var39, var4 + var40, 0)
			var43 = out1 or var43
			var45 = out2 or var45
		end
		if var43 >= 0 and var45 == 1 then
			if var44 <= 0 then
				event.SndSePlay(var1, 11)
				var44 = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.ChkIntersectionPoint_15(12, var18, var19, var20, var2 + var38, var3 + var39, var4 + var40, 1)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
			var35 = out4 or var35
			var36 = out5 or var36
			var37 = out6 or var37
			var43 = out7 or var43
		end
		while var43 >= 0 do
			var16 = 0.0
			if var25 > 8.0 then
				helper_79d90c82()
			end
			if var44 <= 0 then
				event.SndSePlay(var1, 6)
				var44 = 20
			end
			do
				local out1, out2, out3 = event.CopyVector(-var22, -var23, -var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.NormalVector(var22, var23, var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.ScaleVector(var22, var23, var24, 3.0)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.AddVector(var32, var33, var34, var22, var23, var24)
				var32 = out1 or var32
				var33 = out2 or var33
				var34 = out3 or var34
			end
			do
				local out1, out2, out3 = event.SubVector(var18, var19, var20, var32, var33, var34)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			var42 = event.DistVector(var18, var19, var20) or var42
			var42 = vm.f32(var41 - var42)
			if var42 <= 0.0 then
				break
			else
				var41 = var42
				var22 = vm.f32(vm.f32(var35 * var25) * vm.f32(0.9))
				var23 = vm.f32(vm.f32(var36 * var25) * vm.f32(0.58))
				var24 = vm.f32(vm.f32(var37 * var25) * vm.f32(0.9))
				if var23 < 0.0 and var36 > 0.0 then
					var22 = vm.f32(var22 + var15)
					var24 = vm.f32(var24 + var17)
					var15 = vm.f32(var15 * vm.f32(0.8))
					var17 = vm.f32(var17 * vm.f32(0.8))
				elseif
					var22 < 0.0 and var35 > 0.0
					or var22 > 0.0 and var35 < 0.0
					or var24 < 0.0 and var37 > 0.0
					or var24 > 0.0 and var37 < 0.0
				then
					var15 = 0.0
					var17 = 0.0
				end
				do
					local out1, out2, out3 = event.CopyVector(var32, var33, var34)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				do
					local out1, out2, out3 = event.CopyVector(var22, var23, var24)
					var38 = out1 or var38
					var39 = out2 or var39
					var40 = out3 or var40
				end
				do
					local out1, out2, out3 = event.NormalVector(var38, var39, var40)
					var38 = out1 or var38
					var39 = out2 or var39
					var40 = out3 or var40
				end
				do
					local out1, out2, out3 = event.ScaleVector(var38, var39, var40, 3.0)
					var38 = out1 or var38
					var39 = out2 or var39
					var40 = out3 or var40
				end
				do
					local out1, out2, out3 = event.ScaleVector(var35, var36, var37, var42)
					var35 = out1 or var35
					var36 = out2 or var36
					var37 = out3 or var37
				end
				do
					local out1, out2, out3 = event.CopyVector(var32, var33, var34)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3 = event.AddVector(var2, var3, var4, var35, var36, var37)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = event.ChkIntersectionPoint_15(
						12,
						var18,
						var19,
						var20,
						var2 + var38,
						var3 + var39,
						var4 + var40,
						1
					)
					var32 = out1 or var32
					var33 = out2 or var33
					var34 = out3 or var34
					var35 = out4 or var35
					var36 = out5 or var36
					var37 = out6 or var37
					var43 = out7 or var43
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.ChkIntersectionPoint_16(12, var2, var3, var4, var2, var3 - 3.0, var4, 1)
			var32 = out1 or var32
			var33 = out2 or var33
			var34 = out3 or var34
			var35 = out4 or var35
			var36 = out5 or var36
			var37 = out6 or var37
			var43 = out7 or var43
			var45 = out8 or var45
		end
		if var43 >= 0 then
			var16 = 0.0
			var3 = vm.f32(var33 + 3.0)
			var42 = event.DistVector(var22, 0.0, var24) or var42
			if var42 < vm.f32(2.4) or var23 >= -1.0 and var23 <= 0.0 then
				var23 = 0.0
				var14 = 1
			else
				var22 = vm.f32(var22 * vm.f32(0.9))
				var23 = -vm.f32(var23 * vm.f32(0.58))
				var24 = vm.f32(var24 * vm.f32(0.9))
				var22 = vm.f32(var22 + var15)
				var24 = vm.f32(var24 + var17)
				var15 = vm.f32(var15 * vm.f32(0.8))
				var17 = vm.f32(var17 * vm.f32(0.8))
				if var25 > 8.0 then
					helper_79d90c82()
				end
				if var44 <= 0 then
					event.SndSePlay(var1, 5)
					var44 = 20
				end
			end
			var42 = event.DistVector(var15, 0.0, var17) or var42
			if var23 == 0.0 and var25 < vm.f32(1.6) and var42 < vm.f32(0.4) then
				if not (var45 == 6) then
					break
				end
				var31 = 1
				break
			end
		end
		if var3 < -500.0 then
			var31 = 1
			break
		elseif var46 >= 300 then
			var31 = 1
			break
		else
			pin_col = event.SphidaGetPinCol() or pin_col
			ball_col = event.SphidaGetBallCol() or ball_col
			x = vm.f32(var26 - var2)
			y = vm.f32(var27 - var3)
			z = vm.f32(var28 - var4)
			var49 = event.DistVector(x, y, z) or var49
			if ball_col ~= pin_col then
				var53 = event.LinePointDist(var18, var19, var20, var2, var3, var4, var26, var27, var28) or var53
				if var53 >= 0.0 and var53 <= 30.0 then
					var21 = 1
					break
				end
				if var49 ~= 0.0 then
					if var49 <= 120.0 then
						do
							local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(vm.f32(0.6), var49))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.AddVector(var2, var3, var4, x, y, z)
							var2 = out1 or var2
							var3 = out2 or var3
							var4 = out3 or var4
						end
						do
							local out1, out2, out3 = event.AddVector(var22, var23, var24, x, y, z)
							var22 = out1 or var22
							var23 = out2 or var23
							var24 = out3 or var24
						end
					end
				else
					var21 = 1
					break
				end
			elseif var49 ~= 0.0 then
				if var49 <= 60.0 then
					do
						local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(1.0, var49))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.SubVector(var2, var3, var4, x, y, z)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3 = event.SubVector(var22, var23, var24, x, y, z)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
					end
				end
			end
			event.SetCharaPos(8, var2, var3, var4)
			event.SetCharaPos(9, var2, var3, var4)
			do
				local out1, out2, out3 = event.CopyVector(var2, var3, var4)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			if var3 <= var30 then
				event.SetFcameraFollowFlag(0)
				if var31 >= 30 then
					if var31 >= 50 then
						break
					end
				else
					event.SetCameraRef(var2, var3, var4)
				end
				var31 = var31 + 1
			elseif var46 >= 20 then
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetCameraSpeed(6.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.GetCameraPos()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				event.SetFcameraHeight(30.0)
				event.SetFcameraDist(200.0)
				yaw = event.GetRefAngle(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					pos_x,
					pos_y,
					pos_z
				) or yaw
				event.SetFcameraAngle(yaw)
				event.SetFcameraFollowA(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24
				)
				event.FcameraStep(1)
			end
			event.SphidaSetBallPos(var2, var3, var4)
			if vm.wait() then
				return skip(15)
			end
			if var44 > 0 then
				var44 = var44 - 1
			end
			var46 = var46 + 1
		end
	end
	event.SetCharaPos(8, var2, var3, var4)
	event.SetCharaPos(9, var2, var3, var4)
	if vm.wait() then
		return skip(16)
	end
	event.SphidaSetStatusFlag(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var31 == 0 then
		event.SphidaSetBallPos(var2, var3, var4)
		if var21 == 1 then
			event.CharaActive(0, 0)
			event.CharaActive(0, 8)
			event.CharaActive(0, 9)
			event.CharaActive(1, 12)
			event.SetCharaPos(12, var26, var27, var28)
			event.SetMotion(12, "発動", 6)
			event.SndSePlay(var1, 17)
			var46 = 0
			while var46 < 2 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(var26, var27, var28)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var46 = var46 + 1
				if vm.wait() then
					return skip(17)
				end
			end
			event.CharaActive(0, 10)
			do
				local out1, out2, out3 = event.SphidaGetPinPos()
				var26 = out1 or var26
				var27 = out2 or var27
				var28 = out3 or var28
			end
			var46 = 0
			while var46 < 100 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(var26, var27, var28)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var46 = var46 + 1
				if vm.wait() then
					return skip(18)
				end
			end
			event.CharaActive(0, 11)
			event.PostTreasureBox(var26, var27 - 30.0, var28, var11, 294)
			helper_0a1a1684(54)
			if vm.skipping() then
				return skip(19)
			end
			helper_0a1a1684(30)
			if vm.skipping() then
				return skip(20)
			end
			event.DeleteChara(8)
			event.DeleteChara(9)
			event.DeleteChara(10)
			event.DeleteChara(11)
			event.SphidaSetPlayFlag(0)
			var1 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var1
			event.StopBgm(0)
			event.SndSePlay(var1, 0)
			event.CharaActive(1, 0)
			event.SetFcameraFollowFlag(0)
			event.SetCameraCtrl(0)
			event.CmrsInit()
			event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.ObjsSetMotion(0, "カップインポーズ", 6)
			event.ObjsNextMotion(0, "カップインポーズL", 4)
			event.SpriteInit(0)
			event.SpriteSetType(0, 0)
			event.SpriteSetTexture(0, "sphida_bar", tex_bank)
			event.SpriteSetUvsize(0, 258, 0, 254, 54)
			event.SpriteSetPos(0, 256, 208)
			event.SpriteSetPutsize(0, 254, 54)
			event.SpriteSetColor(0, 128, 128, 128, 0)
			event.SpriteSetScale(0, 5.0, 5.0)
			event.SpriteSetDraw(0, 1)
			event.EohSyncSprite(1, 0)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.ObjsSetScale(1, 1.0, 1.0, 0.0, 60)
			event.ObjsSetColor(1, 128, 128, 128, 128, 60)
			helper_90139a55(0)
			if vm.skipping() then
				return skip(21)
			end
			helper_0a1a1684(90)
			if vm.skipping() then
				return skip(22)
			end
			if vm.wait() then
				return skip(23)
			end
			event.PlayBgm(0)
			event.SetCharaPos(0, var8, var9, var10)
			event.CmrsReleaseObj()
			event.SpriteSetDraw(0, 0)
		else
			count = event.SphidaGetParCount() or count
			if count >= 2 then
				event.SetMesWindowMode(0, 5)
				event.SetMesQuestionGyou(0, 0)
				var59 = helper_258919ac(0, 2002, 8, 256, 208, 2, 0)
				if vm.skipping() then
					return skip(24)
				end
				if vm.wait() then
					return skip(25)
				end
				if var59 == 0 then
					do
						local out1, out2, out3, out4 = event.GetPartsFuncPos(var2, var3, var4, 100.0, "point")
						var43 = out1 or var43
						var8 = out2 or var8
						var9 = out3 or var9
						var10 = out4 or var10
					end
					if var43 == 0 then
						do
							local out1, out2, out3 = event.GetPartsOrigin(var2, var3, var4, 100.0)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						do
							local out1, out2, out3, out4 = event.GetNearTboxPos(var8, var9, var10)
							var26 = out1 or var26
							var27 = out2 or var27
							var28 = out3 or var28
							var43 = out4 or var43
						end
						var46 = 0
						while var43 >= 0 do
							do
								local out1, out2, out3 = event.CopyVector(var8, var9, var10)
								var18 = out1 or var18
								var19 = out2 or var19
								var20 = out3 or var20
							end
							do
								local out1, out2, out3 = event.SubVector(var18, var19, var20, var26, var27, var28)
								var18 = out1 or var18
								var19 = out2 or var19
								var20 = out3 or var20
							end
							do
								local out1, out2, out3 = event.NormalVector(var18, var19, var20)
								var18 = out1 or var18
								var19 = out2 or var19
								var20 = out3 or var20
							end
							do
								local out1, out2, out3 = event.ScaleVector(var18, var19, var20, 32.0)
								var18 = out1 or var18
								var19 = out2 or var19
								var20 = out3 or var20
							end
							do
								local out1, out2, out3 = event.CopyVector(var26, var27, var28)
								var8 = out1 or var8
								var9 = out2 or var9
								var10 = out3 or var10
							end
							do
								local out1, out2, out3 = event.AddVector(var8, var9, var10, var18, var19, var20)
								var8 = out1 or var8
								var9 = out2 or var9
								var10 = out3 or var10
							end
							do
								local out1, out2, out3, out4 = event.GetNearTboxPos(var8, var9, var10)
								var26 = out1 or var26
								var27 = out2 or var27
								var28 = out3 or var28
								var43 = out4 or var43
							end
							var46 = var46 + 1
							if var46 > 6 then
								break
							end
						end
					end
					var6 = event.GetRefAngle(var8, var9, var10, var2, var3, var4) or var6
					event.SetCharaPos(0, var8, var9, var10)
					event.SetCharaRot(0, 0.0, var6, 0.0)
					event.SetCameraRef(var8, var9 + 30.0, var10)
					var6 = vm.f32(var6 - vm.f32(3.1415927))
					var6 = event.AngleLimit(var6) or var6
					var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
					var9 = vm.f32(var9 + 30.0)
					var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
					event.SetCameraPos(var8, var9, var10)
					event.ResetCamera(0)
				else
					event.SetCharaPos(0, var8, var9, var10)
				end
			else
				event.SetCharaPos(0, var8, var9, var10)
			end
		end
	else
		event.SndSePlay(var1, 18)
		event.SetFcameraFollowFlag(0)
		event.SetCameraCtrl(0)
		event.CmrsInit()
		event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.ObjsSetMotion(0, "だめだめ", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "sphida_bar", tex_bank)
		event.SpriteSetUvsize(0, 334, 54, 178, 34)
		event.SpriteSetPos(0, 256, -25)
		event.SpriteSetPutsize(0, 160, 50)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.5, 8)
		helper_90139a55(0)
		if vm.skipping() then
			return skip(26)
		end
		helper_0a1a1684(20)
		if vm.skipping() then
			return skip(27)
		end
		event.SpriteSetDraw(0, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.SphidaSetBallPos(var2, var3 + 3.0, var4)
		event.SetCharaPos(8, var2, var3 + 3.0, var4)
		event.SetCharaPos(9, var2, var3 + 3.0, var4)
		event.SetCharaPos(0, var8, var9, var10)
		event.CmrsReleaseObj()
	end
	if var21 == 1 then
		helper_2f81c(-1)
	else
		helper_2f81c(var1)
	end
	helper_31d20(var21, sp + junk + 60)
	if vm.skipping() then
		return skip(28)
	end
end

--- Program 3001.
script[3001] = function()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2f81c(-1)
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	var0 = helper_258919ac(0, 2004, 8, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		helper_2f81c(-1)
		event.SetCrossfade(15)
	end
end

return script
