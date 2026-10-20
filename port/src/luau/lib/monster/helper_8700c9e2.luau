--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8700c9e2()
	local var1: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	do
		local _, out2, _ = monster.GetRot()
		var4 = out2 or var4
	end
	do
		local _, out2, _ = monster.GetRot(0)
		var1 = out2 or var1
	end
	var4 = vm.f32(var4 + var1)
	if var4 > vm.f32(3.1415927) then
		var4 = vm.f32(var4 - vm.f32(6.2831855))
	end
	if var4 < vm.f32(-3.1415927) then
		var4 = vm.f32(var4 + vm.f32(6.2831855))
	end
	do
		local out1, out2, out3 = monster.GetPos_3()
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = monster.GetTargetPos()
		var9 = out1 or var9
		var10 = out2 or var10
		var11 = out3 or var11
	end
	do
		local out1, out2, out3 = monster.SubVector(var6, var7, var8, var9, var10, var11)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	var1 = monster.Atan2f(var6, var8) or var1
	var12 = monster.GetAngleInner_3(var4, var1) or var12
	return var12
end

return helper_8700c9e2
