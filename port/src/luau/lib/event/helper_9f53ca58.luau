--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ebb0be6 = require("@lib/event/helper_1ebb0be6")
local helper_25a5fe2c = require("@lib/event/helper_25a5fe2c")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_66f07360 = require("@lib/event/helper_66f07360")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_c0fce92c = require("@lib/event/helper_c0fce92c")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_e6c23a00 = require("@lib/event/helper_e6c23a00")

--- Helper function.
local function helper_9f53ca58(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	event.DngPause(23, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
		var4 = out4 or var4
	end
	event.SetWorldCoord(var1, var2, var3, var4)
	vm.wait(1)
	event.AddItem(arg0, 1)
	event.SetLoadbgFile_3(arg0, 1, "effect/itemget.gltf")
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_888ab2a3(15)
	helper_66f07360(0)
	helper_888ab2a3(5)
	helper_479dc9e9()
	event.LoadChara(5, "effect/itemget.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(1, 12)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "ゲット", 5)
	event.ObjsSetMotion(1, "ゲット", 2)
	helper_888ab2a3(5)
	var5 = helper_c0fce92c(var5)
	event.LoadItem(5, arg0, "info", 13, 1)
	event.CharaActive(1, 13)
	event.EohSyncChara(0, 13)
	var6 = helper_e6c23a00(13, arg0, var6)
	event.EohSetScale(0, var6, var6, var6)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, -5.0, 0.0)
	event.ObjsPosDelay(0, 4)
	event.ObjsJump(0, 0.0, 17.0, 0.0, -0.3, 20)
	event.ObjsJump(0, 0.0, 17.0, 0.0, -0.4, 8)
	event.ObjsJump(0, 0.0, 17.0, 0.0, -0.2, 5)
	var5 = helper_1ebb0be6(var5)
	helper_c624bc16()
	helper_25a5fe2c(arg0, 1)
	event.SetCrossfade(10)
	event.DngPause(23, 0)
	event.CharaActive(1, 0)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetTbAngle(1.0)
	event.Finish()
end

return helper_9f53ca58
