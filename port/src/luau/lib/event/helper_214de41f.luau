--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6b9da980 = require("@lib/event/helper_6b9da980")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_f7b0da40 = require("@lib/event/helper_f7b0da40")

--- Helper function.
local function helper_214de41f(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: f32, arg5: s32, arg6: s32)
	local angle: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local code: s32 = 0
	local var12: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local var15: f32 = 0
	local at: number = 0
	return vm.guard(function()
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
			if (if var12 == 0 then helper_f7b0da40(64) else 0) ~= 0 then
				event.SphidaSetSpinMarkPos(0.0, 0.0)
				event.SphidaResetPowgage()
				return 1, arg0, arg2, arg3, arg4, arg6
			end
			if helper_f7b0da40(32) ~= 0 then
				event.SphidaTriggerPowgage()
				at = 1
				vm.wait(1)
				code = event.SphidaGetPowgageCode() or code
				if var12 == 0 or code ~= -10 then
					event.SndSePlay(arg5, 0)
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
					event.EohSyncSprite(20 + var12, 10 + var12)
					event.ObjsInit(20 + var12)
					event.ObjsSyncObj(20 + var12, 20 + var12)
					event.ObjsSetScale(20 + var12, 2, 2, 2, 10)
					event.ObjsSetColor(20 + var12, 128, 128, 128, 128, 2)
					event.ObjsSetColor(20 + var12, 128, 128, 128, 0, 8)
					var12 = 1
				end
			else
				at = 2
				vm.wait(2)
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
			var15 = event.GetRand(0.2) or var15
			var15 = vm.f32(var15 - vm.f32(0.1))
			arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.4)) + var15)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
		end
		if code == 3 then
			arg0 = vm.f32(arg0 * vm.f32(0.4))
			var15 = event.GetRand(0.2) or var15
			var15 = vm.f32(var15 - vm.f32(0.1))
			arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.4)) + var15)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
		end
		if code == -2 then
			arg0 = vm.f32(arg0 * vm.f32(0.8))
			var15 = event.GetRand(0.05) or var15
			var15 = vm.f32(var15 - vm.f32(0.025))
			arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.1)) + var15)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
		end
		if code == 2 then
			arg0 = vm.f32(arg0 * vm.f32(0.8))
			var15 = event.GetRand(0.05) or var15
			var15 = vm.f32(var15 - vm.f32(0.025))
			arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.1)) + var15)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
		end
		if code == -1 then
			arg0 = vm.f32(arg0 * 1.0)
			var15 = event.GetRand(0.01) or var15
			arg2 = vm.f32(arg2 - var15)
			var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
			var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
		end
		if code == 1 then
			arg0 = vm.f32(arg0 * 1.0)
			var15 = event.GetRand(0.01) or var15
			arg2 = vm.f32(arg2 + var15)
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
		at = 3
		helper_888ab2a3(10)
		return 0, arg0, arg2, arg3, arg4, arg6
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				local _ = helper_6b9da980(32)
				local _ = var12 == 0
				var12 = 1
			end
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		if at <= 3 then
			return 0, arg0, arg2, arg3, arg4, arg6
		end
		return nil, arg0, arg2, arg3, arg4, arg6
	end)
end

return helper_214de41f
