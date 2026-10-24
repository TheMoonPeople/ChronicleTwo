--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1df9d08a = require("@lib/event/helper_1df9d08a")
local helper_ccf7aeb2 = require("@lib/event/helper_ccf7aeb2")

--- Helper function.
local function helper_4a47348c()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ccf7aeb2(60)
			end
			return 1
		end
		var4 = var4 + 1
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	var0 = helper_1df9d08a(1, -1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.CmrsInit()
		event.CmrsSetPos(-2144.16, 79.66, 654.8)
		event.CmrsSetRef(-2382.06, 11.3, 623.75)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -2363.64, 0.4, 625.83)
		event.ObjsSetRot(0, 0.0, -1.52, 0.0)
		event.ObjsSetMotion(0, "走り", 4)
		event.ObjsMove(0, -2489.67, 0.4, 624.1, 60)
		event.CmrsMove2(-2144.16, 79.66, 654.8, -2388.46, 36.03, 632.32, 48, 60, 2.5)
		event.CmrsFadeInit()
		event.CmrsFadeDelay(30)
		event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
		helper_ccf7aeb2(60)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var1 = vm.f32(var1 + vm.f32(30.0 * vm.sin(vm.f32(1.59))))
	var3 = vm.f32(var3 + vm.f32(30.0 * vm.cos(vm.f32(1.59))))
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 1.59, 0.0, 15)
	event.ObjsMove(0, var1, var2, var3, 45)
	var4 = 0
	while var4 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.CmrsSetRef(var1, var2 + 30.0, var3)
		if vm.wait() then
			return skip(3)
		end
		var4 = var4 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	return 0
end

return helper_4a47348c
