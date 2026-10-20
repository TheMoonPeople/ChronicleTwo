--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_6a0577b0 = require("@lib/monster/helper_6a0577b0")
local helper_708ce460 = require("@lib/monster/helper_708ce460")

--- Helper function.
local function helper_27a31f0d(arg0: f32, arg1: f32, arg2: f32, arg3: s32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var11: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	helper_708ce460(arg1)
	helper_442b9962()
	monster.GetTargetPos()
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var20 = monster.GetTargetDist() or var20
	var21 = monster.SearchArea(arg0 + arg2, 0.0) or var21
	if var21 < vm.f32(arg0 + arg2) then
		return
	end
	do
		local _, out2, _ = monster.GetRot()
		var11 = out2 or var11
	end
	var7 = vm.f32(pos_x + vm.f32(vm.sin(var11) * var20))
	var9 = vm.f32(pos_z + vm.f32(vm.cos(var11) * var20))
	monster.SetNextPos(var7, pos_y - 20.0, var9, arg0, arg2 + arg0)
	local _ = helper_6a0577b0(arg2, arg3)
	monster.ResetMove()
end

return helper_27a31f0d
