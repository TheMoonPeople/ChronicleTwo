--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_fb54e09a = require("@lib/event/helper_fb54e09a")

--- Helper function.
local function helper_ea79295f()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_2f481f12(20)
			end
			if at <= 2 then
				helper_2f481f12(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_fb54e09a(5, 75)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(1635.73, 32.56, 1292.96)
		event.CmrsSetRef(1754.78, 30.0, 1358.67)
		event.ObjsSetPos(0, 1782.12, 0.0, 1373.78)
		event.ObjsSetRot(0, 0.0, 1.0, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 50)
		event.ObjsAddPas(0, 1782.12, 0.0, 1373.78)
		event.ObjsAddPas(0, 1825.81, 0.0, 1397.9)
		event.ObjsAddPas(0, 1906.73, 0.0, 1437.54)
		event.ObjsAddPas(0, 1986.2, 0.0, 1465.28)
		event.ObjsStartPas(0)
		helper_2f481f12(20)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_2f481f12(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(vm.f32(-2.15)) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(vm.f32(-2.15)) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(4)
			end
		end
	end
	return 0
end

return helper_ea79295f
