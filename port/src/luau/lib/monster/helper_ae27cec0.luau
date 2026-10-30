--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6d5002db = require("@lib/monster/helper_6d5002db")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_86dc5980 = require("@lib/monster/helper_86dc5980")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")

--- Helper function.
local function helper_ae27cec0()
	local argc: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	var1 = monster.get_target_distance() or var1
	argc = monster.get_random(100) or argc
	if argc < 80 then
		argc = monster.get_random(100) or argc
		if argc < 30 then
			argc = monster.get_random(100) or argc
			if argc < 80 then
				monster.set_motion("歩き", -1, 0)
				helper_6d5002db(vm.f32(1.7), 3.0, 60.0, 60)
				monster.set_motion("立ち", -1, 0)
			else
				monster.set_motion("立ち", -1, 0)
				helper_7ca8a12f(60.0, 45.0, 75)
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var2 = -30.0
			else
				var2 = 30.0
			end
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("歩き", -1, 0)
			helper_8be991f0(vm.f32(1.7), 3.0, var2, var1, 100.0, 45)
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(60.0, 45.0, 30)
		end
	else
		monster.set_motion("歩き", -1, 0)
		helper_890ee63a(3.0)
		helper_86dc5980()
		monster.set_motion("立ち", -1, 0)
	end
end

return helper_ae27cec0
