--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5f45f52d = require("@lib/event/helper_5f45f52d")
local helper_93c7eafc = require("@lib/event/helper_93c7eafc")
local helper_a9559abc = require("@lib/event/helper_a9559abc")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")

--- Helper function.
local function helper_83ae408e()
	local var0: s32 = 0
	local var1: f32 = 0
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 0
			var4 = helper_5f45f52d(var1, var2, var0, 180)
			var5 = vm.f32(vm.sin(var4) * var3)
			var6 = vm.f32(vm.cos(var4) * var3)
			var0 = var0 + 1
		end
		if at <= 2 then
			var7 = 42.25
			var8 = 0.0
			var9 = helper_a9559abc(vm.f32(1164.86), 0.0, 360)
			var10 = vm.f32(213.16)
			var12, var11 = helper_93c7eafc(vm.f32(vm.f32(330.93) - var10), 1.8359375, 360, var12, var11)
			var0 = 0
			var7 = vm.f32(var7 + var8)
			var8 = vm.f32(var8 + var9)
			var10 = vm.f32(var10 + var11)
			var11 = vm.f32(var11 + var12)
			var0 = var0 + 1
		end
		if at <= 3 then
			helper_bdbefa67(300)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.LoadEquip(5, 1, 4, "info", 9)
	event.LoadEquip(5, 1, 3, "info", 9)
	event.LoadEquip(5, 1, 2, "info", 9, 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.EohSetShow(5, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -15.0, 0.0, -25.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 15.0, 0.0, -25.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(1, "歩き", 4)
	event.EohResetDaPosition(1)
	event.SetTime(18.0)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetPos(-1989.26, 42.52, 580.43)
	event.CmrsSetRef(-1909.39, 98.92, 395.66)
	helper_bdbefa67(60)
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.Atan2f(79.869995, -184.76999) or var1
	var2 = event.Atan2f(379.87, -334.77) or var2
	var3 = event.DistVector2(-1909.39, 0.0, 395.66, -1989.26, 0.0, 580.43) or var3
	var0 = 0
	while var0 < 180 do
		var4 = helper_5f45f52d(var1, var2, var0, 180)
		var5 = vm.f32(vm.sin(var4) * var3)
		var6 = vm.f32(vm.cos(var4) * var3)
		event.CmrsSetRef(var5 - vm.f32(1989.26), 98.92, var6 + vm.f32(580.43))
		var0 = var0 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	event.SetTime(0.0)
	event.SetTimeStepEnable(0)
	event.ObjsSetPos(0, -15.0, 0.0, -25.0)
	event.ObjsSetPos(1, 15.0, 0.0, -25.0)
	event.ObjsMove(1, 15.0, 0.0, -225.0, 360)
	event.ObjsMove(0, -15.0, 0.0, -225.0, 360)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 18.37, 42.25)
	event.CmrsSetRef(0.0, 213.16, -316.49)
	var7 = 42.25
	var8 = 0.0
	var9 = helper_a9559abc(vm.f32(1164.86), 0.0, 360)
	var10 = vm.f32(213.16)
	var12, var11 = helper_93c7eafc(vm.f32(vm.f32(330.93) - var10), 1.8359375, 360, var12, var11)
	var0 = 0
	while var0 < 360 do
		var7 = vm.f32(var7 + var8)
		var8 = vm.f32(var8 + var9)
		event.CmrsSetPos(0.0, 18.37, var7)
		var10 = vm.f32(var10 + var11)
		var11 = vm.f32(var11 + var12)
		event.CmrsSetRef(0.0, var10, -316.49)
		var0 = var0 + 1
		if vm.wait() then
			return skip(3)
		end
	end
	helper_bdbefa67(300)
	if vm.skipping() then
		return skip(4)
	end
	event.DelExtMotion(0)
	event.DeleteChara(9)
	event.DeleteChara(13)
	event.Finish()
end

return helper_83ae408e
