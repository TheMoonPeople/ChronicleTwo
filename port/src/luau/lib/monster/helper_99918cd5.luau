--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_9df6409a = require("@lib/monster/helper_9df6409a")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_99918cd5()
	local attack: s32 = 0
	local var1: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	monster.ResetMove()
	helper_442b9962()
	monster.SetMos("攻撃２", -1, 2)
	helper_c3e8ae39(helper_9df6409a(30))
	var3 = monster.GetTargetAngle() or var3
	do
		local _, out2, _ = monster.GetRot()
		var1 = out2 or var1
	end
	var3 = vm.f32(var3 - var1)
	if var3 < 0.0 then
		var3 = -var3
	end
	var3 = vm.f32(var3 / 30.0)
	helper_82cb5588(var3)
	helper_c3e8ae39(helper_9df6409a(26))
	do
		local out1, out2, out3 = monster.GetRefanglePos(0.0, 16.0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	monster.EsmCreate_1("ヴァンガード衝撃波")
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	attack = monster.GetBaseAttack_1() or attack
	monster.EsmSetValue(-1, 0, attack)
	helper_56d63eae()
	monster.SetMos("立ち")
	helper_c3e8ae39(12)
end

return helper_99918cd5
