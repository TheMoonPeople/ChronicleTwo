--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2c624011 = require("@lib/event/helper_2c624011")
local helper_74ab5554 = require("@lib/event/helper_74ab5554")
local helper_aea2bb82 = require("@lib/event/helper_aea2bb82")
local helper_fc0a7b81 = require("@lib/event/helper_fc0a7b81")

--- Helper function.
local function helper_b43d712b(arg0: f32, arg1: f32, arg2: s32, sp: number)
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
			local _ = helper_fc0a7b81(
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
			var13 = 5.0
			var13 = 30.0
			arg0 = var11
			arg1 = var13
			angle = vm.f32(arg0 - vm.f32(3.1415927))
			helper_74ab5554(arg0, arg1, arg2, sp + junk + 27)
			local _ = helper_aea2bb82(0)
			var3 = 0
			local _ = helper_aea2bb82(1)
			var3 = 1
			junk += 10
		end
		if at <= 2 then
			helper_2c624011()
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
				helper_fc0a7b81(
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
		if var13 <= 5.0 then
			var13 = 5.0
		end
		if var13 >= 30.0 then
			var13 = 30.0
		end
		arg0 = var11
		arg1 = var13
		event.SphidaCalcCarry(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)
		angle = vm.f32(arg0 - vm.f32(3.1415927))
		angle = event.AngleLimit(angle) or angle
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		helper_74ab5554(arg0, arg1, arg2, sp + junk + 19)
		if helper_aea2bb82(0) ~= 0 then
			event.SetMotion(0, "かまえ")
			var3 = 0
			break
		elseif helper_aea2bb82(1) ~= 0 then
			var3 = 1
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	helper_2c624011()
	if vm.wait() then
		return skip(3)
	end
	return var3, arg0, arg1
end

return helper_b43d712b
