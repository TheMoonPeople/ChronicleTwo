--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125e5305 = require("@lib/monster/helper_125e5305")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_68e24e97 = require("@lib/monster/helper_68e24e97")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_c8f4a8bd(arg0: f32)
	local pos_y: f32 = 0
	local pos_x_2: f32 = 0
	local var6: f32 = 0
	local pos_z_2: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	monster.SetAttrib(32, 1)
	var8 = monster.GetTargetDist() or var8
	do
		local out1, _, out3 = monster.GetTargetRot()
		pos_x_2 = out1 or pos_x_2
		pos_z_2 = out3 or pos_z_2
	end
	var10 = monster.GetRndf(10.0) or var10
	var8 = vm.f32(var8 + vm.f32(30.0 + var10))
	monster.ResetMotion()
	monster.SetMos("ステップ後", -1, 6)
	pos_x_2, var6, pos_z_2 = helper_125e5305(0.0, var8, pos_x_2, var6, pos_z_2)
	helper_c3e8ae39(4)
	do
		local _, out2, _ = monster.GetPos_3()
		pos_y = out2 or pos_y
	end
	helper_68e24e97(pos_x_2, pos_y, pos_z_2, arg0, vm.f32(arg0 + 1.0), 25.0, 10)
	monster.SetAttrib(32, 0)
	helper_56d63eae()
	monster.ResetMove()
end

return helper_c8f4a8bd
