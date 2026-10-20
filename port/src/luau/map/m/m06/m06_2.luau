--!strict
-- map/m/m06/m06_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ec08062 = require("@lib/event/helper_0ec08062")
local helper_2df4089e = require("@lib/event/helper_2df4089e")
local helper_34cee31d = require("@lib/event/helper_34cee31d")
local helper_5ddfd52e = require("@lib/event/helper_5ddfd52e")
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
local function helper_137ec()
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
		event.MesMake_2(0, "C'est malpoli de parler [UNI00e0]\nquelqu'un par derri[UNI00e8]re.")
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
	event.MesMake_2(0, "Quel magnifique ciel [UNI00e9]toil[UNI00e9].")
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
		event.MesMake_2(0, "C'est malpoli de parler [UNI00e0]\nquelqu'un par derri[UNI00e8]re.")
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
	event.MesMake_2(0, "Avez-vous vu un petit\nrouquin passer par ici ?")
	helper_957450ee(10350, 100)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "座り", 4)
	event.MesMake_2(0, "Non. T'as vu quelqu'un ?")
	helper_957450ee(10360, 60)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Il allait vers la Mairie.")
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
		event.MesMake_2(0, "Il faut un billet pour rentrer.\n(Pour ouvrir le menu : (#).)")
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
			event.MesMake_2(0, "On ne rentre pas sans billet.")
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
local function helper_15970()
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
		event.MesMake_2(0, "Si tu ne te d[UNI00e9]p[UNI00ea]ches pas, le\nspectacle va se terminer !")
	else
		event.MesMake_2(0, "Je ne crois pas que ce petit\nrouquin soit pass[UNI00e9] par ici...")
	end
	helper_ec947835(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_141c0()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Le cirque donne une telle vie [UNI00e0]\ntout ce qui l'entoure !")
	helper_5ddfd52e(10, 9000050)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_f528()
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
		event.MesMake_2(0, "C'est malpoli de parler [UNI00e0]\nquelqu'un par derri[UNI00e8]re.")
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
	event.MesMake_2(0, "Avez-vous vu passer un gar[UNI00e7]on roux ?")
	helper_957450ee(10380, 80)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.MesMake_2(0, "Oh, oui. [UNI00c0] l'instant.")
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
	event.MesMake_2(0, "Je suis s[UNI00fb]re qu'il se dirigeait\npar-l[UNI00e0].")
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
local function helper_14304()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Qu'est-ce que tu fais ?")
	helper_5ddfd52e(11, 9000060)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_10664()
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
	event.MesMake_2(0, "H[UNI00e9], h[UNI00e9], as-tu vu\nun petit rouquin ?")
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
	event.MesMake_2(0, "Moi ? Non, d[UNI00e9]sol[UNI00e9]e.")
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
local function helper_14428()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Quelque chose ne va pas ?")
	helper_5ddfd52e(13, 9000070)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1454c()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ec947835(0, -1, 8, 256, 208)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "D'ici, on voit vraiment bien la\nlune !")
	helper_5ddfd52e(14, 9000080)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(32) or flag
	if flag == 0 then
		event.SetFlag(32, 1)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(0, "[(!)]Pour activer la vue 1[UNI00e8]re\n   personne, appuie sur la touche [r2].")
		helper_ec947835(0, -1, 8, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_1485c()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "J'aurais tant aim[UNI00e9] voir le cirque !")
	helper_5ddfd52e(15, 9000090)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_14990()
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
	event.MesMake_2(0, "D[UNI00e9]sol[UNI00e9]e, je dois aller [UNI00e0] la Mairie !")
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
local function helper_156f8()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Palm Brinks est une ville g[UNI00e9]niale !")
	helper_5ddfd52e(17, 9000100)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1582c()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.MesMake_2(0, "Le spectacle a d[UNI00e9]j[UNI00e0] commenc[UNI00e9] !")
	helper_5ddfd52e(18, 9000110)
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
		helper_137ec()
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
	helper_1129c(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15970()
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
	event.MesMake_2(0, "La Mairie semble [UNI00ea]tre ferm[UNI00e9]e.")
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
				helper_f528()
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_10664()
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
		helper_1129c(1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	argc = event.GetItemHaveNum(353) or argc
	if var0 == 10 then
		if argc >= 1 then
			helper_141c0()
			if vm.skipping() then
				return skip(2)
			end
		else
			event.SetFlag(3, 1)
			helper_f528()
			if vm.skipping() then
				return skip(3)
			end
		end
		return
	end
	if var0 == 11 then
		if argc >= 1 then
			helper_14304()
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
				helper_10664()
				if vm.skipping() then
					return skip(6)
				end
			end
		end
		return
	end
	if var0 == 13 then
		helper_14428()
		if vm.skipping() then
			return skip(7)
		end
		return
	end
	if var0 == 14 then
		helper_1454c()
		if vm.skipping() then
			return skip(8)
		end
		return
	end
	if var0 == 15 then
		helper_1485c()
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	if var0 == 16 then
		helper_14990()
		if vm.skipping() then
			return skip(10)
		end
		return
	end
	if var0 == 17 then
		helper_156f8()
		if vm.skipping() then
			return skip(11)
		end
		return
	end
	if var0 == 18 then
		helper_1582c()
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
