--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_48852a90 = require("@lib/monster/helper_48852a90")
local helper_56d63eae = require("@lib/monster/helper_56d63eae")

--- Helper function.
local function helper_1ae935f0(arg0: f32, arg1: f32, arg2: f32, arg3: any)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local chara_type: s32 = 0
	local attack: s32 = 0
	monster.ResetMotion()
	monster.SetMos("攻撃２", -1, 6)
	helper_48852a90(10.0, vm.f32(0.538), vm.f32(0.01))
	do
		local out1, out2, out3 = monster.GetFramePos("dcol2")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	chara_type = monster.GetUserid() or chara_type
	attack = monster.GetBaseAttack_1() or attack
	monster.EsmCreate_1("毒液2L")
	monster.EsmSetTargetId(-1, chara_type)
	monster.EsmSetVect1(-1, pos_x, pos_y, pos_z)
	monster.EsmSetVect2(-1, arg0, arg1, arg2)
	monster.EsmSetValue(-1, 0, attack)
	helper_56d63eae()
end

return helper_1ae935f0
