--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_3cc46fef = require("@lib/monster/helper_3cc46fef")
local helper_6d5002db = require("@lib/monster/helper_6d5002db")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_95b679db = require("@lib/monster/helper_95b679db")

--- Helper function.
local function helper_5f5c205e()
	local argc: s32 = 0
	local var2: f32 = 0
	monster.get_target_distance()
	argc = monster.get_random(100) or argc
	if argc < 60 then
		helper_3cc46fef()
	else
		argc = monster.get_random(100) or argc
		if argc < 55 then
			monster.set_motion("歩き", -1, 0)
			helper_6d5002db(2.0, 3.0, 40.0, 90)
			monster.set_motion("立ち", -1, 0)
		else
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			argc = monster.get_random(100) or argc
			if argc < 50 then
				var2 = -30.0
				monster.set_motion("歩き左", -1, 0)
			else
				var2 = 30.0
				monster.set_motion("歩き右", -1, 0)
			end
			helper_95b679db(2.0, var2, 3.0, 60)
			monster.set_motion("歩き", -1, 0)
			helper_890ee63a(3.0)
			monster.set_motion("立ち", -1, 0)
			helper_7ca8a12f(40.0, 45.0, 30)
		end
	end
end

return helper_5f5c205e
