--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3e77b5b1 = require("@lib/event/helper_3e77b5b1")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_b09f6907 = require("@lib/event/helper_b09f6907")

--- Helper function.
local function helper_45cad085()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_3e77b5b1(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				helper_a8b5d854(10)
			end
			return 0
		end
		if at <= 6 then
			if at <= 4 then
				helper_a8b5d854(30)
			end
			if at <= 5 then
				helper_a8b5d854(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_3e77b5b1(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_3e77b5b1(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetFadeOut(10)
		helper_a8b5d854(10)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaPos(0, 1804.36, -189.51, 1279.76)
		event.SetCharaRot(0, 0.0, -2.47, 0.0)
		event.SetCameraPos(1889.79, -158.65, 1386.92)
		event.SetCameraRef(1804.36, -159.51, 1279.76)
		event.ResetCamera(0)
		event.SetFadeIn(10)
		event.Finish()
		return 0
	end
	var1 = helper_b09f6907(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.CmrsSetPos(1776.49, -106.69, 1400.79)
		event.CmrsSetRef(1951.33, -163.61, 1351.42)
		event.ObjsSetPos(0, 1943.88, -189.72, 1357.17)
		event.ObjsSetRot(0, 0.0, 1.21, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, 1943.88, -189.72, 1357.17)
		event.ObjsAddPas(0, 2022.78, -189.88, 1386.95)
		event.ObjsAddPas(0, 2104.45, -195.47, 1399.2)
		event.ObjsAddPas(0, 2155.72, -202.4, 1401.26)
		event.ObjsStartPas(0)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, -1)
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(-2.14)) * 30.0) + var2)
		var6 = var3
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(-2.14)) * 30.0) + var4)
		event.ObjsMove(0, var5, var6, var7, 30, 1)
		event.ObjsReference(0, var5, var6, var7, 10)
		event.ObjsSetMotion(0, "歩き")
		var8 = 0
		while var8 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			var3 = vm.f32(var3 + 30.0)
			event.SetCameraRef(var2, var3, var4)
			var8 = var8 + 1
			if vm.wait() then
				return skip(7)
			end
		end
		event.EohSetFootSoundId(0, -1)
		event.ResetCamera(0)
		event.Finish()
	end
	return 0
end

return helper_45cad085
