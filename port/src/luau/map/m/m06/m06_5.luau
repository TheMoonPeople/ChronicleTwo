--!strict
-- map/m/m06/m06_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09331a29 = require("@lib/event/helper_09331a29")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_4e2ee805 = require("@lib/event/helper_4e2ee805")
local helper_50a99b66 = require("@lib/event/helper_50a99b66")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_7334e9f5 = require("@lib/event/helper_7334e9f5")
local helper_7ddc1f42 = require("@lib/event/helper_7ddc1f42")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_8d25bb56 = require("@lib/event/helper_8d25bb56")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")

--- Helper function.
local function helper_137fc()
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
		event.MesMake_2(0, "Es de mala educaci[UNI00f3]n hablarle\na alguien por la espalda.")
		helper_9e7d1511(0, -1, 5, 0, 0)
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
	helper_25abe6d2(14)
	event.SetPakuMotion(1, "会話", 0, "座り", 0)
	event.MesMake_2(0, "Qu[UNI00e9] bonito y estrellado est[UNI00e1] el cielo.")
	helper_b5a98ffa(0, -1, 9, 0, 0)
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
		event.MesMake_2(0, "Es de mala educaci[UNI00f3]n hablarle\na alguien por la espalda.")
		helper_9e7d1511(0, -1, 5, 0, 0)
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
	helper_25abe6d2(14)
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "[UNI00bf]Hab[UNI00e9]is visto pasar por aqu[UNI00ed]\na un ni[UNI00f1]o pelirrojo?")
	helper_4e2ee805(10350, 100)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "座り", 4)
	event.MesMake_2(0, "No. [UNI00bf]Tu has visto algo?")
	helper_4e2ee805(10360, 60)
	event.MesMake_2(0, "S[UNI00ed], iba hacia el Ayuntamiento.")
	helper_4e2ee805(10370, 80)
	event.StreamClose(1)
end

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	event.EohSyncObj_2(31, "街灯-14")
	event.EohSetShow(31, 0)
	event.EohSyncObj_2(31, "街灯-15")
	event.EohSetShow(31, 0)
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
end

--- Helper function.
local function helper_1129c(arg0: s32)
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
		helper_25abe6d2(var16)
		event.StreamOpen3(1, 10665)
		helper_9cbdc640(1)
		event.StreamPlay(1)
		event.MesMake_2(0, "Necesitas una entrada.\n(Abre el men[UNI00fa] con el bot[UNI00f3]n (#).)")
		helper_82705ce2(0, -1, 8, 0, 0)
		do
			local _: any
			_, var20 = helper_7ddc1f42(0, 1, var20)
		end
		helper_6992f518(0)
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
		var21 = event.GotoUseItem(353) or var21
		vm.wait(4)
		if var21 == 353 then
			flag = event.GetFlag(1) or flag
			if flag == 0 then
				event.SetFlag(1, 1)
				event.LoadScript("m06/m06b.stb", 153)
				return
			else
				helper_50a99b66()
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
				helper_25abe6d2(var16)
			end
			event.ObjsSetMotion(1, "帰ってくれ", 2)
			event.ObjsNextMotion(1, "立ち", 4)
			event.MesMake_2(0, "No puedes pasar sin entrada.")
			helper_4e2ee805(10670, 90)
			helper_0958ca60(1)
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
			helper_25abe6d2(10)
		end
		event.ObjsSetMotion(1, "立ち")
		helper_0958ca60(1)
	end
end

--- Helper function.
local function helper_15960()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local argc: s32 = 0
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
		vm.wait(1)
	end
	event.ObjsSetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	argc = event.GetItemHaveNum(353) or argc
	if argc >= 1 then
		event.MesMake_2(0, "[UNI00a1]Si no corres, se terminar[UNI00e1]\nla funci[UNI00f3]n del circo!")
	else
		event.MesMake_2(0, "No creo que el chico pelirrojo\nhaya venido por aqu[UNI00ed]...")
	end
	helper_9e7d1511(0, -1, 5, 256, 208)
end

--- Helper function.
local function helper_141d0()
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "[UNI00a1]Qu[UNI00e9] alegre es\nel circo!")
	helper_09331a29(10, 9000050)
end

--- Helper function.
local function helper_f558()
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
		event.MesMake_2(0, "Es de mala educaci[UNI00f3]n hablarle\na alguien por la espalda.")
		helper_9e7d1511(0, -1, 5, 0, 0)
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
	helper_25abe6d2(20)
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "[UNI00bf]Has visto a un chico pelirrojo?")
	helper_4e2ee805(10380, 80)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, "S[UNI00ed], ahora mismo.")
	helper_4e2ee805(10390, 100)
	helper_0958ca60(1)
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
	event.MesMake_2(0, "Pas[UNI00f3] en esa direcci[UNI00f3]n.")
	helper_4e2ee805(10400, 150)
	event.StreamClose(1)
	helper_0958ca60(1)
	var14 = event.AngleCmp(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(1, 0.0, var10, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_25abe6d2(11)
end

--- Helper function.
local function helper_14304()
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] est[UNI00e1]s haciendo?")
	helper_09331a29(11, 9000060)
end

--- Helper function.
local function helper_10674()
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
	helper_25abe6d2(20)
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.MesMake_2(0, "Eh, oye, [UNI00bf]has visto\na un chico pelirrojo?")
	helper_4e2ee805(10420, 90)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_25abe6d2(10)
	event.MesMake_2(0, "[UNI00bf]Yo? No, lo siento.")
	helper_4e2ee805(10430, 90)
	event.StreamClose(1)
	helper_0958ca60(1)
	var14 = event.AngleCmp(var10, yaw_2, 0.1) or var14
	if var14 ~= 0 then
		event.ObjsRotation(1, 0.0, var10, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_25abe6d2(11)
end

--- Helper function.
local function helper_14438()
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "[UNI00bf]Pasa algo?")
	helper_09331a29(13, 9000070)
end

--- Helper function.
local function helper_1455c()
	local flag: s32 = 0
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "[UNI00a1]Desde aqu[UNI00ed] se ve\nla luna!")
	helper_09331a29(14, 9000080)
	flag = event.GetFlag(32) or flag
	if flag == 0 then
		event.SetFlag(32, 1)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(0, "[(!)]Pulsa el bot[UNI00f3]n [r2] para cambiar\na la vista en primera persona.")
		helper_9e7d1511(0, -1, 8, 256, 208)
	end
end

--- Helper function.
local function helper_1486c()
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "[UNI00a1]Me hubiera gustado ir al circo!")
	helper_09331a29(15, 9000090)
end

--- Helper function.
local function helper_149a0()
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
	helper_25abe6d2(20)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, "[UNI00a1]Lo siento, pero tengo que ir al Ayuntamiento!")
	helper_4e2ee805(10410, 80)
	event.StreamClose(1)
	helper_0958ca60(1)
	var17 = event.AngleCmp(var10, yaw_2, 0.1) or var17
	if var17 ~= 0 then
		event.ObjsRotation(1, 0.0, var10, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_25abe6d2(11)
end

--- Helper function.
local function helper_156f8()
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "[UNI00a1]Palm Brinks es una ciudad genial!")
	helper_09331a29(17, 9000100)
end

--- Helper function.
local function helper_1582c()
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "[UNI00a1]Ya ha empezado el circo!")
	helper_09331a29(18, 9000110)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 1, which map data, a script or the engine runs by number.
function script.event_1()
	local argc: s32 = 0
	argc = event.GetItemHaveNum(353) or argc
	if argc >= 1 then
		helper_137fc()
	else
		event.SetFlag(2, 1)
		helper_e9c4()
	end
end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.Initialize()
	helper_7334e9f5()
	helper_8d25bb56()
	event_99()
	event.CheckMcLoad()
	event.SetCharaPos(0, 2100.0, 0.0, 2200.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraRef(2100.0, 30.0, 2200.0)
	event.SetCameraPos(2100.0, 30.0, 2080.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.Initialize()
	vm.wait(1)
	event.SetTime(24.0)
	event.LoadScript("m06/m06b.stb", 154)
end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	event.Initialize()
	vm.wait(1)
	event.LoadScript("m06/m06b.stb", 151)
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	event.SetCnt(5, 1)
	event.Initialize()
	vm.wait(1)
	event.LoadScript("m06/m06b.stb", 152)
end

--- Event 153, which map data, a script or the engine runs by number.
function script.event_153()
	event.Initialize()
	event.SetFadeOut(0)
	vm.wait(1)
	event.LoadScript("m06/m06b.stb", 155)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_1129c(0)
end

--- Event 510, which map data, a script or the engine runs by number.
script.event_510 = helper_15960

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "El Ayuntamiento parece cerrado.")
	helper_9e7d1511(0, -1, 5, 0, 0)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
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
	var0 = event.GetEventData_2(13) or var0
	event.GetEventData_2(14)
	if var0 == 8 then
		helper_1129c(1)
		return
	end
	argc = event.GetItemHaveNum(353) or argc
	if var0 == 10 then
		if argc >= 1 then
			helper_141d0()
		else
			event.SetFlag(3, 1)
			helper_f558()
		end
		return
	end
	if var0 == 11 then
		if argc >= 1 then
			helper_14304()
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
				vm.wait(5)
				event.LoadScript("m06/m06b.stb", 154)
			else
				helper_10674()
			end
		end
		return
	end
	if var0 == 13 then
		helper_14438()
		return
	end
	if var0 == 14 then
		helper_1455c()
		return
	end
	if var0 == 15 then
		helper_1486c()
		return
	end
	if var0 == 16 then
		helper_149a0()
		return
	end
	if var0 == 17 then
		helper_156f8()
		return
	end
	if var0 == 18 then
		helper_1582c()
		return
	end
end

--- Event 10020, which map data, a script or the engine runs by number.
function script.event_10020()
	event.Initialize()
	vm.wait(1)
	event.SetFlag(1, 0)
	event.SetFlag(2, 0)
	event.SetFlag(3, 0)
	event.AddItem(353)
	event.LoadScript("m06/m06b.stb", 152)
end

--- Event 10060, which map data, a script or the engine runs by number.
function script.event_10060()
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_25abe6d2(6)
	event.LoadScript("m06/m06b.stb", 155)
end

return script
