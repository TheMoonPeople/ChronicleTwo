--!strict
-- map/m/m06/m06.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2eb46710 = require("@lib/event/helper_2eb46710")
local helper_40810097 = require("@lib/event/helper_40810097")
local helper_40f32ea5 = require("@lib/event/helper_40f32ea5")
local helper_468809ea = require("@lib/event/helper_468809ea")
local helper_4b0a5650 = require("@lib/event/helper_4b0a5650")
local helper_648be351 = require("@lib/event/helper_648be351")
local helper_7334e9f5 = require("@lib/event/helper_7334e9f5")
local helper_8d25bb56 = require("@lib/event/helper_8d25bb56")
local helper_b9ea6aa8 = require("@lib/event/helper_b9ea6aa8")
local helper_d3251153 = require("@lib/event/helper_d3251153")
local helper_e289b4cf = require("@lib/event/helper_e289b4cf")

--- Helper function.
local function helper_87bc(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_e289b4cf(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_40f32ea5(arg0, 0, var6)
		end
		helper_b9ea6aa8(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_e289b4cf(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_40f32ea5(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_b9ea6aa8(arg0)
end

--- Helper function.
local function helper_13428()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var14: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_4b0a5650(0, -1, 9, 0, 0)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(9)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	event.GetCharaRot(9)
	yaw = event.GetRefAngle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.GetRefAngle(var3, var4, var5, var0, var1, var2) or yaw_2
	var14 = event.AngleCmp(yaw_2, 1.94, 1.5) or var14
	if var14 ~= 0 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMotion(0, "立ち")
		event.MesMake_2(0, "後ろから話し掛けるのは、失礼だよね。")
		helper_87bc(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesShippo(0, 1)
		return
	end
	var14 = event.AngleCmp(var7, yaw, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_40810097(14)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuMotion(1, "会話", 0, "座り", 0)
	event.MesMake_2(0, "きれいな星空ね・・・")
	helper_4b0a5650(0, -1, 9, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuMotion()
end

--- Helper function.
local function helper_10fc(arg0: s32)
	local stream_open_state: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if vm.wait() then
			return skip(2)
		end
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	event.StreamStandby(arg0)
	while true do
		if vm.wait() then
			return skip(3)
		end
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
end

--- Helper function.
local function helper_e494(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10fc(1)
		end
		if at <= 2 then
			helper_e289b4cf(0, -1, 8, 0, 0)
			helper_2eb46710(0, arg1)
		end
		helper_b9ea6aa8(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_10fc(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_e289b4cf(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_2eb46710(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	helper_b9ea6aa8(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_e670()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var14: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_87bc(0, -1, 5, 0, 0)
			end
			return
		end
		if at <= 3 then
			helper_e494(10350, 80)
		end
		if at <= 4 then
			helper_e494(10360, 60)
		end
		if at <= 5 then
			helper_e494(10370, 70)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(9)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	event.GetCharaRot(9)
	yaw = event.GetRefAngle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.GetRefAngle(var3, var4, var5, var0, var1, var2) or yaw_2
	var14 = event.AngleCmp(yaw_2, 1.94, 1.5) or var14
	if var14 ~= 0 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMotion(0, "立ち")
		event.MesMake_2(0, "後ろから話し掛けるのは、失礼だよね。")
		helper_87bc(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMesShippo(0, 1)
		return
	end
	var14 = event.AngleCmp(var7, yaw, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_40810097(14)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "こっちに赤い髪の子来ませんでした？")
	helper_e494(10350, 80)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "座り", 4)
	event.MesMake_2(0, "う～ん、見たかい？")
	helper_e494(10360, 60)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "役所の方に走っていったよ。")
	helper_e494(10370, 70)
	if vm.skipping() then
		return skip(6)
	end
	event.StreamClose(1)
end

--- Program 99.
local function program_99()
	event.EohSyncObj(31, "街灯-14")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "街灯-15")
	event.EohSetShow(31, 0)
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
end

--- Helper function.
local function helper_bbc0()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_40810097(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_40810097(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_40810097(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_d1d0()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_648be351()
			end
			if at <= 2 then
				helper_d3251153(10680, 34)
			end
			if at <= 3 then
				helper_468809ea(4)
			end
			if at <= 4 then
				helper_d3251153(10690, 60)
			end
			if at <= 5 then
				helper_468809ea(0)
			end
			if at <= 6 then
				helper_d3251153(10700, 30)
			end
			if at <= 7 then
				helper_468809ea(0)
			end
			if at <= 8 then
				helper_40810097(30)
			end
			if at <= 9 then
				helper_40810097(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		if at <= 11 then
			helper_40810097(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.DelExtMotion(0)
		event.LoadMes(0, -1)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(20)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_40810097(4)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	event.SetMotion(0, "立ち")
	helper_648be351()
	if vm.skipping() then
		return skip(1)
	end
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1_5.txt")
	event.EohSyncChara(0, 8)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 2265.38, 0.0, 2231.01)
	event.ObjsSetRot(0, 0.0, -2.3, 0.0)
	event.LoadMotion(5, "event/opening/p1/p1_5_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 2244.38, 0.0, 2216.71)
	event.ObjsSetRot(4, 0.0, 1.08, 0.0)
	event.ObjsResetDaPosition(4)
	event.ObjsSetMotion(4, "旧・立ち", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.ObjsTexAnime(4, 1, "うれし口")
	event.LoadChara(5, "event/opening/p1/p1_5_ticket.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(5, 20)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 2244.38, 0.0, 2216.71)
	event.ObjsSetRot(5, 0.0, 1.08, 0.0)
	event.CmrsSetPos(2261.3, 11.72, 2146.03)
	event.CmrsSetRef(2254.85, 18.38, 2223.77)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_648be351()
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(4, "チケットを渡す", 6)
	event.ObjsNextMotion(4, "チケットを渡すL", 4)
	event.CharaActive(20)
	event.ObjsSetMotion(5, "チケットを渡す", 6)
	event.ObjsNextMotion(5, "チケットを渡すL", 4)
	event.SetPakuAnim(4, "通常口パク", "うれし口")
	helper_d3251153(10680, 34)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_468809ea(4)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "もぎり", 6)
	event.ObjsNextMotion(0, "もぎりL", 4)
	helper_d3251153(10690, 60)
	if vm.skipping() then
		return skip(5)
	end
	helper_468809ea(0)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 20)
	event.ObjsSetMotion(4, "チケットを渡す戻り", 6)
	event.ObjsNextMotion(4, "旧・立ち", 4)
	event.ObjsSetMotion(0, "もぎり戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(4, "通常口パク", "うれし口")
	helper_d3251153(10700, 30)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_468809ea(0)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(4, "歩き")
	event.ObjsMove(4, 2246.15, 0.0, 2250.53, 45)
	event.ObjsMove(4, 2245.15, 8.0, 2295.52, 45)
	event.ObjsRotation(4, 0.0, 0.0, 0.0, 10)
	helper_40810097(30)
	if vm.skipping() then
		return skip(9)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_40810097(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_10ec8(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local var20: s32 = 0
	local var21: s32 = 0
	local flag: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_10fc(1)
			end
			if at <= 2 then
				helper_e289b4cf(0, -1, 8, 0, 0)
				_, var20 = helper_40f32ea5(0, 1, var20)
			end
			if at <= 3 then
				helper_b9ea6aa8(0)
				var19 = 2
				var18 = 1
				var15 = 1
			end
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			helper_e494(10670, 60)
		end
		if at <= 7 then
			helper_468809ea(1)
		end
		if at <= 8 then
			var15 = 1
			helper_40810097(10)
		end
		if at <= 9 then
			helper_468809ea(1)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var15 = 0
	var18 = 0
	var19 = event.GetEventData_2(6) or var19
	if var19 == 1 or arg0 == 1 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local _, out2, _ = event.GetCharaRot(0)
			var5 = out2 or var5
		end
		do
			local out1, out2, out3 = event.GetCharaPos(8)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		do
			local _, out2, _ = event.GetCharaRot(8)
			var11 = out2 or var11
		end
		yaw = event.GetRefAngle(var1, var2, var3, var7, var8, var9) or yaw
		yaw_2 = event.GetRefAngle(var7, var8, var9, var1, var2, var3) or yaw_2
		var16 = 0
		var17 = event.AngleCmp(var5, yaw, 0.1) or var17
		if var17 ~= 0 then
			event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
			event.ObjsSetMotion(0, "歩き")
			event.ObjsMotionDelay(0, 10)
			var16 = 20
		end
		event.ObjsSetMotion(0, "立ち")
		var17 = event.AngleCmp(var11, yaw_2, 0.1) or var17
		if var17 ~= 0 then
			event.ObjsRotation(1, 0.0, yaw_2, 0.0, 10)
			event.ObjsSetMotion(1, "歩き")
			event.ObjsMotionDelay(1, 10)
			var16 = 20
		end
		event.ObjsSetMotion(1, "立ち")
		helper_40810097(var16)
		if vm.skipping() then
			return skip(1)
		end
		event.StreamOpen3(1, 10665)
		helper_10fc(1)
		if vm.skipping() then
			return skip(2)
		end
		event.StreamPlay(1)
		event.MesMake_2(
			0,
			"会場に入るにはチケットが必要だよ。\n（(#)ボタンでメニューを開く）"
		)
		helper_e289b4cf(0, -1, 8, 0, 0)
		_, var20 = helper_40f32ea5(0, 1, var20)
		if vm.skipping() then
			return skip(3)
		end
		helper_b9ea6aa8(0)
		event.SetMesPos(0, 0)
		event.StreamClose(1)
		if var20 == 1 then
			var19 = 2
		else
			event.StreamClose(1)
		end
		var18 = 1
		var15 = 1
	end
	if var19 == 2 then
		event.GotoUseItem(353)
		do
			local skipped = vm.wait()
			var21 = event.DeferredOutput() or var21
			if skipped then
				return skip(4)
			end
		end
		if var21 == 353 then
			flag = event.GetFlag(1) or flag
			if flag == 0 then
				event.SetFlag(1, 1)
				event.LoadScript("m06/m06b.stb", 153)
				return
			else
				helper_d1d0()
				if vm.skipping() then
					return skip(5)
				end
				event.BgmLoadCancel()
				event.SoundLoadCancel()
				event.SubItem(382)
				event.AddItem(387)
				event.SetCharaEquip(0, 387)
				event.GotoDng(0, 21, 1010)
				return
			end
		elseif var21 <= 0 then
		else
			if var18 ~= 1 then
				event.EohSyncChara(0, 0)
				event.ObjsInit(0)
				event.ObjsSyncObj(0, 0)
				event.EohSyncChara(1, 8)
				event.ObjsInit(1)
				event.ObjsSyncObj(1, 1)
				do
					local out1, out2, out3 = event.GetCharaPos(0)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				do
					local _, out2, _ = event.GetCharaRot(0)
					var5 = out2 or var5
				end
				do
					local out1, out2, out3 = event.GetCharaPos(8)
					var7 = out1 or var7
					var8 = out2 or var8
					var9 = out3 or var9
				end
				do
					local _, out2, _ = event.GetCharaRot(8)
					var11 = out2 or var11
				end
				yaw = event.GetRefAngle(var1, var2, var3, var7, var8, var9) or yaw
				yaw_2 = event.GetRefAngle(var7, var8, var9, var1, var2, var3) or yaw_2
				var16 = 0
				var17 = event.AngleCmp(var5, yaw, 0.1) or var17
				if var17 ~= 0 then
					event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
					event.ObjsSetMotion(0, "歩き")
					event.ObjsMotionDelay(0, 10)
					var16 = 20
				end
				event.ObjsSetMotion(0, "立ち")
				var17 = event.AngleCmp(var11, yaw_2, 0.1) or var17
				if var17 ~= 0 then
					event.ObjsRotation(1, 0.0, yaw_2, 0.0, 10)
					event.ObjsSetMotion(1, "歩き")
					event.ObjsMotionDelay(1, 10)
					var16 = 20
				end
				event.ObjsSetMotion(1, "立ち")
				helper_40810097(var16)
				if vm.skipping() then
					return skip(6)
				end
			end
			event.ObjsSetMotion(1, "帰ってくれ", 2)
			event.ObjsNextMotion(1, "立ち", 4)
			event.MesMake_2(0, "チケットがないなら、帰ってくれ。")
			helper_e494(10670, 60)
			if vm.skipping() then
				return skip(7)
			end
			helper_468809ea(1)
			if vm.skipping() then
				return skip(8)
			end
			event.StreamClose(1)
			var15 = 1
		end
	end
	if var15 ~= 0 then
		var17 = event.AngleCmp(var11, yaw_2, 0.1) or var17
		if var17 ~= 0 then
			event.ObjsRotation(1, 0.0, var11, 0.0, 10)
			event.ObjsSetMotion(1, "歩き")
			event.ObjsMotionDelay(1, 10)
			helper_40810097(10)
			if vm.skipping() then
				return skip(9)
			end
		end
		event.ObjsSetMotion(1, "立ち")
		helper_468809ea(1)
		if vm.skipping() then
			return skip(10)
		end
	end
end

--- Helper function.
local function helper_154fc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_87bc(0, -1, 5, 256, 208)
		end
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var3 = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + var0)
	var4 = var1
	var5 = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + var2)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsMove(0, var3, var4, var5, 30, 1)
	event.ObjsReference(0, var3, var4, var5, 10)
	event.ObjsSetMotion(0, "歩き")
	var6 = 0
	while var6 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var6 = var6 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	event.ObjsSetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	argc = event.GetItemHaveNum(353) or argc
	if argc >= 1 then
		event.MesMake_2(0, "早く行かないとサーカス終わっちゃうよ。")
	else
		event.MesMake_2(0, "さっきの赤い髪の子\nこっちには来てないと思うんだけどなぁ。")
	end
	helper_87bc(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_12a18(arg0: s32, arg1: any)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var12: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var16: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4b0a5650(0, -1, arg0, 0, 0)
		end
		if at <= 2 then
			helper_40810097(11)
		end
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, arg0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var9 = out2 or var9
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var12 = out2 or var12
	end
	yaw = event.GetRefAngle(var2, var3, var4, var5, var6, var7) or yaw
	yaw_2 = event.GetRefAngle(var5, var6, var7, var2, var3, var4) or yaw_2
	var16 = event.AngleCmp(var9, yaw, 0.1) or var16
	if var16 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	var16 = event.AngleCmp(var12, yaw_2, 0.1) or var16
	if var16 ~= 0 then
		event.ObjsRotation(1, 0.0, yaw_2, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_40810097(20)
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuMotion(1, "会話", 0, "立ち", 0)
	helper_4b0a5650(0, -1, arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	var16 = event.AngleCmp(var12, yaw_2, 0.1) or var16
	if var16 ~= 0 then
		event.ObjsRotation(1, 0.0, var12, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_40810097(11)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_13dcc()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "サーカスがある日はにぎやかでいいわね。")
	helper_12a18(10, 9000050)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_f1a4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var14: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_87bc(0, -1, 5, 0, 0)
			end
			return
		end
		if at <= 3 then
			helper_e494(10380, 70)
		end
		if at <= 4 then
			helper_e494(10390, 100)
		end
		if at <= 5 then
			helper_468809ea(1)
		end
		if at <= 6 then
			yaw_2 = vm.f32(3.14)
			helper_e494(10400, 150)
		end
		if at <= 7 then
			helper_468809ea(1)
		end
		if at <= 8 then
			helper_40810097(11)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 10)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(10)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(10)
		var10 = out2 or var10
	end
	yaw = event.GetRefAngle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.GetRefAngle(var3, var4, var5, var0, var1, var2) or yaw_2
	var14 = event.AngleCmp(yaw_2, 3.14, 1.5) or var14
	if var14 ~= 0 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMotion(0, "立ち")
		event.MesMake_2(0, "後ろから話し掛けるのは、失礼だよね。")
		helper_87bc(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMesShippo(0, 1)
		return
	end
	var14 = event.AngleCmp(var7, yaw, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	var14 = event.AngleCmp(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(1, 0.0, yaw_2, 0.0, 16)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 16)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_40810097(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "赤い髪の子は見かけませんでしたか？")
	helper_e494(10380, 70)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, "う～ん、どうだったかしら・・・")
	helper_e494(10390, 100)
	if vm.skipping() then
		return skip(5)
	end
	helper_468809ea(1)
	if vm.skipping() then
		return skip(6)
	end
	var14 = event.AngleCmp(3.14, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(1, 0.0, 3.14, 0.0, 16)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 16)
		yaw_2 = vm.f32(3.14)
	else
		event.ObjsMotionDelay(1, 16)
	end
	event.ObjsSetMotion(1, "あっちの方に", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, "確か、向こうのほうへ向かって\n行ったような気がするわ・・・")
	helper_e494(10400, 150)
	if vm.skipping() then
		return skip(7)
	end
	event.StreamClose(1)
	helper_468809ea(1)
	if vm.skipping() then
		return skip(8)
	end
	var14 = event.AngleCmp(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(1, 0.0, var10, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_40810097(11)
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_13f00()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "お兄ちゃんは、なにしてるの？")
	helper_12a18(11, 9000060)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_102b0()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var14: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40810097(20)
		end
		if at <= 2 then
			helper_e494(10420, 90)
		end
		if at <= 3 then
			helper_40810097(10)
		end
		if at <= 4 then
			helper_e494(10430, 60)
		end
		if at <= 5 then
			helper_468809ea(1)
		end
		if at <= 6 then
			helper_40810097(11)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 11)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(11)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(11)
		var10 = out2 or var10
	end
	yaw = event.GetRefAngle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.GetRefAngle(var3, var4, var5, var0, var1, var2) or yaw_2
	var14 = event.AngleCmp(var7, yaw, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	var14 = event.AngleCmp(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(1, 0.0, yaw_2, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_40810097(20)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "ね、ね、君、赤い髪の子見なかった？")
	helper_e494(10420, 90)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_40810097(10)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "わたし、知らない・・・")
	helper_e494(10430, 60)
	if vm.skipping() then
		return skip(5)
	end
	event.StreamClose(1)
	helper_468809ea(1)
	if vm.skipping() then
		return skip(6)
	end
	var14 = event.AngleCmp(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(1, 0.0, var10, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_40810097(11)
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_14024()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "どうかしたかい？")
	helper_12a18(13, 9000070)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14148()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_87bc(0, -1, 8, 256, 208)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "ここからだと、お月様がよく見えるわ。")
	helper_12a18(14, 9000080)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(32) or flag
	if flag == 0 then
		event.SetFlag(32, 1)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(0, "[(!)][r2]ボタンで主人公視点。")
		helper_87bc(0, -1, 8, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_14428()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "ボクもサーカス見たかったなぁ。")
	helper_12a18(15, 9000090)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1454c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var17: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e494(10410, 80)
		end
		if at <= 2 then
			helper_468809ea(1)
		end
		if at <= 3 then
			helper_40810097(11)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 16)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var7 = out2 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(16)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(16)
		var10 = out2 or var10
	end
	var12 = vm.f32(vm.f32(vm.sin(2.5) * 140) + var0)
	var13 = vm.f32(var1 + 10.0)
	var14 = vm.f32(vm.f32(vm.cos(2.5) * 140) + var2)
	event.CmrsInit()
	event.CmrsMove2(var12, var13, var14, var0, var1 + 50.0, var2, 14, 2, 1.0)
	yaw = event.GetRefAngle(var0, var1, var2, var3, var4, var5) or yaw
	yaw_2 = event.GetRefAngle(var3, var4, var5, var0, var1, var2) or yaw_2
	var17 = event.AngleCmp(var7, yaw, 0.1) or var17
	if var17 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	var17 = event.AngleCmp(var10, yaw_2, 0.1) or var17
	if var17 ~= 0 then
		event.ObjsRotation(1, 0.0, yaw_2, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_40810097(20)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, "役所に用があったのにどうしましょう・・・")
	helper_e494(10410, 80)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamClose(1)
	helper_468809ea(1)
	if vm.skipping() then
		return skip(3)
	end
	var17 = event.AngleCmp(var10, yaw_2, 0.1) or var17
	if var17 ~= 0 then
		event.ObjsRotation(1, 0.0, var10, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_40810097(11)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_152a4()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "パームブリンクスっていい町だよな。")
	helper_12a18(17, 9000100)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_153d8()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "サーカスは、もう始まってるよ。")
	helper_12a18(18, 9000110)
	if vm.skipping() then
		return skip(1)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 1.
script[1] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e670()
		end
	end
	argc = event.GetItemHaveNum(353) or argc
	if argc >= 1 then
		helper_13428()
		if vm.skipping() then
			return skip(1)
		end
	else
		event.SetFlag(2, 1)
		helper_e670()
		if vm.skipping() then
			return skip(2)
		end
	end
end

script[99] = program_99

--- Program 100.
script[100] = function()
	event.Initialize()
	helper_7334e9f5()
	helper_8d25bb56()
	program_99()
	event.CheckMcLoad()
	event.SetCharaPos(0, 2100.0, 0.0, 2200.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraRef(2100.0, 30.0, 2200.0)
	event.SetCameraPos(2100.0, 30.0, 2080.0)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetTime(24.0)
	event.LoadScript("m06/m06b.stb", 154)
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("m06/m06b.stb", 151)
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(5, 1)
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("m06/m06b.stb", 152)
end

--- Program 153.
script[153] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("m06/m06b.stb", 155)
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_bbc0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10ec8(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_154fc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "役所は閉まっているようだ。")
	helper_87bc(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_f1a4()
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_102b0()
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
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
	end
	var0 = event.GetEventData_2(13) or var0
	event.GetEventData_2(14)
	if var0 == 8 then
		helper_10ec8(1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	argc = event.GetItemHaveNum(353) or argc
	if var0 == 10 then
		if argc >= 1 then
			helper_13dcc()
			if vm.skipping() then
				return skip(2)
			end
		else
			event.SetFlag(3, 1)
			helper_f1a4()
			if vm.skipping() then
				return skip(3)
			end
		end
		return
	end
	if var0 == 11 then
		if argc >= 1 then
			helper_13f00()
			if vm.skipping() then
				return skip(4)
			end
		else
			flag = event.GetFlag(2) or flag
			flag_2 = event.GetFlag(3) or flag_2
			if flag == 1 and flag_2 == 1 then
				do
					local out1, out2, out3 = event.GetBeforeCameraPos()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				do
					local out1, out2, out3 = event.GetBeforeCameraRef()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				event.SetCameraPos(pos_x, pos_y, pos_z)
				event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
				event.Initialize()
				if vm.wait() then
					return skip(5)
				end
				event.LoadScript("m06/m06b.stb", 154)
			else
				helper_102b0()
				if vm.skipping() then
					return skip(6)
				end
			end
		end
		return
	end
	if var0 == 13 then
		helper_14024()
		if vm.skipping() then
			return skip(7)
		end
		return
	end
	if var0 == 14 then
		helper_14148()
		if vm.skipping() then
			return skip(8)
		end
		return
	end
	if var0 == 15 then
		helper_14428()
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	if var0 == 16 then
		helper_1454c()
		if vm.skipping() then
			return skip(10)
		end
		return
	end
	if var0 == 17 then
		helper_152a4()
		if vm.skipping() then
			return skip(11)
		end
		return
	end
	if var0 == 18 then
		helper_153d8()
		if vm.skipping() then
			return skip(12)
		end
		return
	end
end

--- Program 10020.
script[10020] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetFlag(1, 0)
	event.SetFlag(2, 0)
	event.SetFlag(3, 0)
	event.AddItem(353)
	event.LoadScript("m06/m06b.stb", 152)
end

--- Program 10060.
script[10060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_40810097(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadScript("m06/m06b.stb", 155)
end

return script
