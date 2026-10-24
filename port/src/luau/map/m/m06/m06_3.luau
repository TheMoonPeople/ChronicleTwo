--!strict
-- map/m/m06/m06_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ec08062 = require("@lib/event/helper_0ec08062")
local helper_2df4089e = require("@lib/event/helper_2df4089e")
local helper_34cee31d = require("@lib/event/helper_34cee31d")
local helper_7334e9f5 = require("@lib/event/helper_7334e9f5")
local helper_7cbd640d = require("@lib/event/helper_7cbd640d")
local helper_83663e22 = require("@lib/event/helper_83663e22")
local helper_8d25bb56 = require("@lib/event/helper_8d25bb56")
local helper_8e53ce0a = require("@lib/event/helper_8e53ce0a")
local helper_957450ee = require("@lib/event/helper_957450ee")
local helper_9d160cf5 = require("@lib/event/helper_9d160cf5")
local helper_bc77b237 = require("@lib/event/helper_bc77b237")
local helper_ec947835 = require("@lib/event/helper_ec947835")
local helper_f8aba7e6 = require("@lib/event/helper_f8aba7e6")

--- Helper function.
local function helper_1379c()
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
			helper_9d160cf5(0, -1, 9, 0, 0)
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
		event.MesMake_2(0, "Man spricht Leute nicht\nvon hinten an.")
		helper_ec947835(0, -1, 5, 0, 0)
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
	helper_bc77b237(14)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuMotion(1, "会話", 0, "座り", 0)
	event.MesMake_2(0, "Was f[UNI00fc]r ein sch[UNI00f6]ner Sternenhimmel!")
	helper_9d160cf5(0, -1, 9, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuMotion()
end

--- Helper function.
local function helper_e9c4()
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
				helper_ec947835(0, -1, 5, 0, 0)
			end
			return
		end
		if at <= 3 then
			helper_957450ee(10350, 100)
		end
		if at <= 4 then
			helper_957450ee(10360, 60)
		end
		if at <= 5 then
			helper_957450ee(10370, 80)
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
		event.MesMake_2(0, "Man spricht Leute nicht\nvon hinten an.")
		helper_ec947835(0, -1, 5, 0, 0)
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
	helper_bc77b237(14)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "Ist hier ein kleiner\nrothaariger Junge vorbeigekommen?")
	helper_957450ee(10350, 100)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "座り", 4)
	event.MesMake_2(0, "N[UNI00f6]. Hast du was gesehen?")
	helper_957450ee(10360, 60)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Er ist zum Rathaus gelaufen.")
	helper_957450ee(10370, 80)
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
local function helper_1123c(arg0: s32)
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
				helper_7cbd640d(1)
			end
			if at <= 2 then
				helper_0ec08062(0, -1, 8, 0, 0)
				_, var20 = helper_83663e22(0, 1, var20)
			end
			if at <= 3 then
				helper_f8aba7e6(0)
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
			helper_957450ee(10670, 90)
		end
		if at <= 7 then
			helper_8e53ce0a(1)
		end
		if at <= 8 then
			var15 = 1
			helper_bc77b237(10)
		end
		if at <= 9 then
			helper_8e53ce0a(1)
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
		helper_bc77b237(var16)
		if vm.skipping() then
			return skip(1)
		end
		event.StreamOpen3(1, 10665)
		helper_7cbd640d(1)
		if vm.skipping() then
			return skip(2)
		end
		event.StreamPlay(1)
		event.MesMake_2(0, "Du brauchst eine Eintrittskarte.\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)")
		helper_0ec08062(0, -1, 8, 0, 0)
		_, var20 = helper_83663e22(0, 1, var20)
		if vm.skipping() then
			return skip(3)
		end
		helper_f8aba7e6(0)
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
				helper_2df4089e()
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
				helper_bc77b237(var16)
				if vm.skipping() then
					return skip(6)
				end
			end
			event.ObjsSetMotion(1, "帰ってくれ", 2)
			event.ObjsNextMotion(1, "立ち", 4)
			event.MesMake_2(0, "Ohne Karte kommst du nicht rein.")
			helper_957450ee(10670, 90)
			if vm.skipping() then
				return skip(7)
			end
			helper_8e53ce0a(1)
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
			helper_bc77b237(10)
			if vm.skipping() then
				return skip(9)
			end
		end
		event.ObjsSetMotion(1, "立ち")
		helper_8e53ce0a(1)
		if vm.skipping() then
			return skip(10)
		end
	end
end

--- Helper function.
local function helper_15890()
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
			helper_ec947835(0, -1, 5, 256, 208)
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
		event.MesMake_2(0, "Wenn du nicht schnell machst,\nist der Zirkus zu Ende!")
	else
		event.MesMake_2(0, "Ich glaube nicht, dass der Junge\nhier entlanggekommen ist ...")
	end
	helper_ec947835(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_12d8c(arg0: s32, arg1: any)
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
			helper_9d160cf5(0, -1, arg0, 0, 0)
		end
		if at <= 2 then
			helper_bc77b237(11)
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
	helper_bc77b237(20)
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuMotion(1, "会話", 0, "立ち", 0)
	helper_9d160cf5(0, -1, arg0, 0, 0)
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
	helper_bc77b237(11)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_14160()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Der Zirkus macht alles\nso lebendig!")
	helper_12d8c(10, 9000050)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_f518()
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
				helper_ec947835(0, -1, 5, 0, 0)
			end
			return
		end
		if at <= 3 then
			helper_957450ee(10380, 80)
		end
		if at <= 4 then
			helper_957450ee(10390, 100)
		end
		if at <= 5 then
			helper_8e53ce0a(1)
		end
		if at <= 6 then
			yaw_2 = vm.f32(3.14)
			helper_957450ee(10400, 150)
		end
		if at <= 7 then
			helper_8e53ce0a(1)
		end
		if at <= 8 then
			helper_bc77b237(11)
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
		event.MesMake_2(0, "Man spricht Leute nicht\nvon hinten an.")
		helper_ec947835(0, -1, 5, 0, 0)
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
	helper_bc77b237(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "Hast du einen rothaarigen\nJungen vorbeikommen gesehen?")
	helper_957450ee(10380, 80)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, "Oh ja, gerade eben.")
	helper_957450ee(10390, 100)
	if vm.skipping() then
		return skip(5)
	end
	helper_8e53ce0a(1)
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
	event.MesMake_2(0, "Er ist dort entlanggelaufen.")
	helper_957450ee(10400, 150)
	if vm.skipping() then
		return skip(7)
	end
	event.StreamClose(1)
	helper_8e53ce0a(1)
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
	helper_bc77b237(11)
	if vm.skipping() then
		return skip(9)
	end
end

--- Helper function.
local function helper_14294()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Was machst du?")
	helper_12d8c(11, 9000060)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_10614()
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
			helper_bc77b237(20)
		end
		if at <= 2 then
			helper_957450ee(10420, 90)
		end
		if at <= 3 then
			helper_bc77b237(10)
		end
		if at <= 4 then
			helper_957450ee(10430, 90)
		end
		if at <= 5 then
			helper_8e53ce0a(1)
		end
		if at <= 6 then
			helper_bc77b237(11)
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
	helper_bc77b237(20)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "Hey, hey, hast du einen\nrothaarigen Jungen gesehen?")
	helper_957450ee(10420, 90)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_bc77b237(10)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Ich? Nein, tut mir Leid.")
	helper_957450ee(10430, 90)
	if vm.skipping() then
		return skip(5)
	end
	event.StreamClose(1)
	helper_8e53ce0a(1)
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
	helper_bc77b237(11)
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_143a8()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Stimmt was nicht?")
	helper_12d8c(13, 9000070)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_144cc()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ec947835(0, -1, 8, 256, 208)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Von hier sieht man den\nMond echt toll!")
	helper_12d8c(14, 9000080)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(32) or flag
	if flag == 0 then
		event.SetFlag(32, 1)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(0, "[(!)]Dr[UNI00fc]cke [r2], um\n   in den Ego-Modus zu schalten.")
		helper_ec947835(0, -1, 8, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_147cc()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Ich h[UNI00e4]tte so gern den\nZirkus gesehen!")
	helper_12d8c(15, 9000090)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14900()
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
			helper_957450ee(10410, 80)
		end
		if at <= 2 then
			helper_8e53ce0a(1)
		end
		if at <= 3 then
			helper_bc77b237(11)
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
	helper_bc77b237(20)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, "Tut mir Leid,\nich muss zum Rathaus!")
	helper_957450ee(10410, 80)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamClose(1)
	helper_8e53ce0a(1)
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
	helper_bc77b237(11)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_15648()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Palm Brinks ist toll!")
	helper_12d8c(17, 9000100)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1576c()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Der Zirkus hat angefangen!")
	helper_12d8c(18, 9000110)
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
			helper_e9c4()
		end
	end
	argc = event.GetItemHaveNum(353) or argc
	if argc >= 1 then
		helper_1379c()
		if vm.skipping() then
			return skip(1)
		end
	else
		event.SetFlag(2, 1)
		helper_e9c4()
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
	helper_34cee31d()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1123c(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15890()
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
	event.MesMake_2(0, "Das Rathaus ist offenbar\ngeschlossen.")
	helper_ec947835(0, -1, 5, 0, 0)
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
				helper_f518()
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_10614()
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
		helper_1123c(1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	argc = event.GetItemHaveNum(353) or argc
	if var0 == 10 then
		if argc >= 1 then
			helper_14160()
			if vm.skipping() then
				return skip(2)
			end
		else
			event.SetFlag(3, 1)
			helper_f518()
			if vm.skipping() then
				return skip(3)
			end
		end
		return
	end
	if var0 == 11 then
		if argc >= 1 then
			helper_14294()
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
				helper_10614()
				if vm.skipping() then
					return skip(6)
				end
			end
		end
		return
	end
	if var0 == 13 then
		helper_143a8()
		if vm.skipping() then
			return skip(7)
		end
		return
	end
	if var0 == 14 then
		helper_144cc()
		if vm.skipping() then
			return skip(8)
		end
		return
	end
	if var0 == 15 then
		helper_147cc()
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	if var0 == 16 then
		helper_14900()
		if vm.skipping() then
			return skip(10)
		end
		return
	end
	if var0 == 17 then
		helper_15648()
		if vm.skipping() then
			return skip(11)
		end
		return
	end
	if var0 == 18 then
		helper_1576c()
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
	helper_bc77b237(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadScript("m06/m06b.stb", 155)
end

return script
