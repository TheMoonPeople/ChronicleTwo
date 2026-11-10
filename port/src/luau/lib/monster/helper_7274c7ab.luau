--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06e363ee = require("@lib/monster/helper_06e363ee")
local helper_0799d76b = require("@lib/monster/helper_0799d76b")
local helper_12339e1b = require("@lib/monster/helper_12339e1b")
local helper_28452e16 = require("@lib/monster/helper_28452e16")
local helper_2aa4e058 = require("@lib/monster/helper_2aa4e058")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")
local helper_9662aa5e = require("@lib/monster/helper_9662aa5e")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")
local helper_d8c5ceae = require("@lib/monster/helper_d8c5ceae")
local helper_edcb05de = require("@lib/monster/helper_edcb05de")

--- Helper function.
local function helper_7274c7ab()
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	monster.get_life_int()
	argc = monster.get_random(100) or argc
	if argc < 85 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			if argc < 30 then
				monster.set_motion("歩き", 0.65, 0)
				helper_2aa4e058(4.0, 20.0, 15)
				helper_06e363ee()
				monster.set_motion("立ち", -1, 0)
				helper_c3e8ae39(3)
			else
				argc = monster.get_random(100) or argc
				if argc < 50 then
					monster.set_motion("歩き", 0.65, 0)
					helper_890ee63a(4.0)
					helper_9662aa5e()
					monster.set_motion("立ち", -1, 0)
					helper_c3e8ae39(3)
				else
					monster.set_motion("歩き", 0.65, 0)
					helper_890ee63a(4.0)
					helper_12339e1b()
					monster.set_motion("立ち", -1, 0)
					helper_c3e8ae39(3)
				end
			end
		else
			argc = monster.get_random(100) or argc
			if argc < 60 then
				monster.set_motion("歩き", 0.65, 0)
				helper_2aa4e058(4.0, 20.0, 25)
				helper_edcb05de()
				monster.set_motion("立ち", -1, 0)
				helper_c3e8ae39(3)
			else
				monster.set_motion("歩き", 0.65, 0)
				helper_890ee63a(4.0)
				helper_0799d76b()
				monster.set_motion("立ち", -1, 0)
				helper_c3e8ae39(3)
			end
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 40 then
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			helper_d8c5ceae()
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			monster.set_motion("立ち", -1, 0)
		else
			argc = monster.get_random(100) or argc
			var3 = monster.get_random_whole_number(30.0) or var3
			var2 = monster.get_random_whole_number(10.0) or var2
			if argc < 50 then
				var3 = vm.f32(-var3 - 30.0)
			else
				var3 = vm.f32(var3 + var3)
			end
			var2 = monster.get_target_distance() or var2
			monster.set_motion("歩き", 0.65, 0)
			helper_8be991f0(vm.f32(2.4), 4.0, helper_28452e16(var3), var2, 1.0, 15)
		end
	end
end

return helper_7274c7ab
