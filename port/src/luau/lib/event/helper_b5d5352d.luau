--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2c717f26 = require("@lib/event/helper_2c717f26")
local helper_ccf7aeb2 = require("@lib/event/helper_ccf7aeb2")

--- Helper function.
local function helper_b5d5352d(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = event.SubVector(var4, var5, var6, var1, var2, var3)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var7 = event.Atan2f(var4, var6) or var7
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	print("angle=", string.format("%f", var7), "----------\n")
	var8 = vm.ftoi(vm.f32(var7 / vm.f32(0.19634955)))
	var8 = helper_2c717f26(var8)
	print("frame=", var8, "-------------\n")
	event.ObjsRotation(0, 0.0, var7, 0.0, var8)
	helper_ccf7aeb2(var8)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
end

return helper_b5d5352d
