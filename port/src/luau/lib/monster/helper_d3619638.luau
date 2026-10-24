--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27517b94 = require("@lib/monster/helper_27517b94")
local helper_45797ccb = require("@lib/monster/helper_45797ccb")
local helper_7c9e9468 = require("@lib/monster/helper_7c9e9468")
local helper_aa0677dc = require("@lib/monster/helper_aa0677dc")
local helper_c09d91a7 = require("@lib/monster/helper_c09d91a7")
local helper_df9a3a05 = require("@lib/monster/helper_df9a3a05")
local helper_f5727415 = require("@lib/monster/helper_f5727415")

--- Helper function.
local function helper_d3619638()
	local argc: s32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	monster.GetMonsterLife()
	argc = monster.GetRnd(100) or argc
	if argc < 65 then
		monster.SetMos("歩き", -1, 0)
		helper_c09d91a7(1.75, vm.f32(4.8), 30.0, 30.0, 60)
		helper_27517b94()
		monster.SetMos("立ち", -1, 0)
	else
		argc = monster.GetRnd(100) or argc
		if argc < 15 then
			argc = monster.GetRnd(100) or argc
			var4 = monster.GetRndf(60.0) or var4
			if argc < 50 then
				var4 = vm.f32(-var4 - 30.0)
			else
				var4 = vm.f32(var4 + 30.0)
			end
			monster.SetMos("歩き", -1, 0)
			helper_df9a3a05(1.75, vm.f32(4.8), var4, 60.0, 1.0, 30.0, 50)
			helper_f5727415(vm.f32(4.8))
			monster.SetMos("立ち", -1, 0)
			helper_45797ccb(9)
		else
			monster.SetMos("歩き", -1, 0)
			helper_f5727415(vm.f32(4.8))
			argc = monster.GetRnd(100) or argc
			if argc < 67 then
				argc = monster.GetRnd(100) or argc
				if argc < 50 then
					var5 = 1
					monster.SetMos("ステップ右", -1, 0)
				else
					var5 = 0
					monster.SetMos("ステップ左", -1, 0)
				end
				helper_aa0677dc(1.75, 30.0, 30.0, var5, 60)
				monster.SetMos("立ち", -1, 0)
			else
				helper_7c9e9468(1.75, 30.0, 30.0, 60)
				monster.SetMos("立ち", -1, 0)
			end
		end
	end
end

return helper_d3619638
