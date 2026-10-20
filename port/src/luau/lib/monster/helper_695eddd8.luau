--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_661d392d = require("@lib/monster/helper_661d392d")
local helper_82cb5588 = require("@lib/monster/helper_82cb5588")
local helper_9ded5535 = require("@lib/monster/helper_9ded5535")

--- Helper function.
local function helper_695eddd8()
	local var0: s32 = 0
	local argc: s32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	var0 = 0
	argc = monster.GetRnd(60) or argc
	argc = vm.i32(argc + 40)
	while true do
		var2 = monster.GetTargetDist() or var2
		if (if var2 <= 80.0 then 1 else if var0 >= argc then helper_661d392d(180, 200) else 0) ~= 0 then
			helper_9ded5535()
			helper_442b9962()
			monster.ResetMove()
			return
		end
		if helper_661d392d(0, 20) ~= 0 then
			monster.SetMos("歩き", 0.55)
		elseif helper_661d392d(90, 180) ~= 0 then
			monster.SetMos("回転右", 0.55)
		else
			monster.SetMos("回転左", 0.55)
		end
		do
			local out1, out2, out3 = monster.GetRefanglePos(0.0, 3.0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		helper_82cb5588(vm.f32(0.017453292))
		monster.SetNextPos(pos_x, pos_y, pos_z, 1.6, 1.0)
		var0 = vm.i32(var0 + 1)
		vm.wait()
	end
end

return helper_695eddd8
