--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_f4171acf = require("@lib/event/helper_f4171acf")

--- Helper function.
local function helper_76c5a354()
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b0211f82(150)
		end
	end
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetMotion(0, "立ち")
	event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 663.45, 0.0, 1290.77)
	event.ObjsSetRot(0, 0.0, 2.3561945, 0.0)
	event.ObjsSetMotion(0, "走り", 4)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.LoadEquip(5, 1, 4, "info", 9)
	event.LoadEquip(5, 1, 3, "info", 9)
	event.LoadEquip(5, 1, 2, "info", 9, 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.EohSetShow(5, 1)
	event.EohResetDaPosition(1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 699.23, 0.0, 1268.37)
	event.ObjsSetRot(1, 0.0, 2.3561945, 0.0)
	event.ObjsSetMotion(1, "走り", 4)
	event.LoadChara(5, "event/e400/e438/e438_paw.gltf", "info", 14)
	event.CharaActive(14)
	event.EohSyncChara(6, 14)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 699.23, 0.0, 1268.37)
	event.ObjsSetRot(6, 0.0, 2.3561945, 0.0)
	event.ObjsSetMotion(6, "走り", 4)
	event.EohSyncObj(2, "p01_battleship")
	event.EohGetPos(2)
	event.EohSetPos(2, -6000.0, 1600.0, -8000.0)
	event.EohSetRot(2, 0.0, 2.3561945, 0.0)
	event.CmrsSetPos(575.95, 61.55, 1603.27)
	event.CmrsSetRef(463.45, 40.0, 1490.77)
	event.CmrsMove(950.95, 61.55, 1228.27, 838.45, 40.0, 1115.77, 113)
	event.ObjsSetPos(0, 463.45, 0.0, 1510.77)
	event.ObjsMove(0, 1963.45, 0.0, 10.77002, 450)
	event.ObjsSetPos(1, 483.45, 0.0, 1470.77)
	event.ObjsMove(1, 1953.45, 0.0, 0.77001953, 450)
	event.ObjsSetPos(6, 453.45, 0.0, 1500.77)
	event.ObjsMove(6, 1923.45, 0.0, 30.77002, 450)
	var3 = vm.f32(-2786.55)
	var4 = vm.f32(-786.55005)
	var5 = vm.f32(-1259.23)
	var6 = vm.f32(-3259.23)
	var12 = 0
	while var12 < 450 do
		if var12 == 113 then
			event.CmrsMove(2075.95, 6.11, 103.27002, 1963.45, 50.0, -9.22998, 337)
		end
		var7 = helper_f4171acf(var3, var4, var12, 450)
		var9 = helper_f4171acf(var5, var6, var12, 450)
		if var12 < 225 then
			var8 = helper_f4171acf(1400.0, 1000.0, var12, 225)
		else
			var8 = helper_f4171acf(1000.0, 1400.0, var12 - 225, 225)
		end
		if var12 < 150 then
			var10 = helper_f4171acf(-0.25, 0.25, var12, 150)
			var11 = 0.0
		else
			var10 = helper_f4171acf(0.25, -0.25, var12 - 150, 300)
			var11 = 0.0
		end
		event.EohSetPos(2, var7, var8, var9)
		event.EohSetRot(2, var10, 2.3561945, var11)
		var12 = var12 + 1
		if vm.wait() then
			return skip(1)
		end
	end
	helper_b0211f82(150)
	if vm.skipping() then
		return skip(2)
	end
	event.DelExtMotion(0)
	event.DeleteChara(9)
	event.DeleteChara(13)
	event.DeleteChara(14)
	event.Finish()
end

return helper_76c5a354
