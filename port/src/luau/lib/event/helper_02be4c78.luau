--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")

--- Helper function.
local function helper_02be4c78()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var13: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = vm.f32(1707.99)
			var1 = vm.f32(-8.19)
			var2 = vm.f32(-424.51)
			var3 = vm.f32(-2.3561945)
			var4 = vm.f32(1682.18)
			var5 = vm.f32(29.66)
			var6 = vm.f32(-487.46)
			var7 = vm.f32(1712.17)
			var8 = vm.f32(13.54)
			var9 = vm.f32(-420.33)
			var13 = vm.f32(19.26)
			helper_b0211f82(60)
		end
		if at <= 2 then
			helper_b0211f82(210)
		end
		if at <= 3 then
			helper_b0211f82(150)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	var0 = vm.f32(1707.99)
	var1 = vm.f32(-8.19)
	var2 = vm.f32(-424.51)
	var3 = vm.f32(-2.3561945)
	event.SetMotion(0, "立ち")
	event.LoadMotion(5, "event/e400/e438/e438_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, var0, var1, var2)
	event.ObjsSetRot(0, 0.0, var3, 0.0)
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 9)
	event.LoadMotion(5, "event/e400/e438/e438_monica.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.LoadEquip(5, 1, 4, "info", 9)
	event.LoadEquip(5, 1, 3, "info", 9)
	event.LoadEquip(5, 1, 2, "info", 9, 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.EohSetShow(5, 1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, vm.f32(var0 - 10.0) + 10.0, -5.03, vm.f32(var2 + 10.0) + 10.0)
	event.ObjsSetRot(1, 0.0, -2.6, 0.0)
	event.ObjsSetMotion(1, "上見立ち", 4)
	event.EohResetDaPosition(1)
	event.LoadChara(5, "event/e400/e438/e438_paw.gltf", "info", 14)
	event.CharaActive(14)
	event.EohSyncChara(6, 14)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, vm.f32(var0 + 10.0) + 10.0, -6.28, vm.f32(var2 - 10.0) + 10.0)
	event.ObjsSetRot(6, 0.0, -2.12, 0.0)
	event.ObjsSetMotion(6, "見上げるL", 4)
	event.EohSyncObj(2, "p01_battleship")
	event.EohSetShow(2, 0)
	var4 = vm.f32(1682.18)
	var5 = vm.f32(29.66)
	var6 = vm.f32(-487.46)
	var7 = vm.f32(1712.17)
	var8 = vm.f32(13.54)
	var9 = vm.f32(-420.33)
	var13 = vm.f32(19.26)
	event.CmrsInit()
	event.CmrsSetPos(var4, var5, var6)
	event.CmrsSetRef(var7, var8, var9)
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsMoveRef(var7, var13, var9, 210)
	event.CmrsMoveAhd(1.47, -10.82, 76.77, 210)
	helper_b0211f82(210)
	if vm.skipping() then
		return skip(3)
	end
	helper_b0211f82(150)
	if vm.skipping() then
		return skip(4)
	end
	event.DelExtMotion(0)
	event.DeleteChara(9)
	event.DeleteChara(13)
	event.DeleteChara(14)
	event.EohSetShow(2, 1)
	event.Finish()
end

return helper_02be4c78
