--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6d5002db = require("@lib/monster/helper_6d5002db")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_95b679db = require("@lib/monster/helper_95b679db")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d041fc4b = require("@lib/monster/helper_d041fc4b")

--- Helper function.
local function helper_18605be7()
	local argc: s32 = 0
	local var3: f32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 25 then
		helper_d041fc4b()
	else
		argc = monster.get_random(100) or argc
		if argc < 65 then
			monster.set_motion("歩き", -1, 0)
			helper_6d5002db(vm.f32(1.7), 3.0, 60.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var3 = -30.0
				monster.set_motion("歩き左", -1, 4)
			else
				var3 = 30.0
				monster.set_motion("歩き右", -1, 4)
			end
			for var1 = 0, 2 do
				helper_c3e8ae39(13)
				helper_95b679db(vm.f32(2.5500002), var3, 3.0, 9)
				monster.stop_moving()
				helper_c3e8ae39(3)
			end
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(60.0, 45.0, 30)
		end
	end
end

return helper_18605be7
