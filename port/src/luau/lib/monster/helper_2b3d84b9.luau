--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06e363ee = require("@lib/monster/helper_06e363ee")
local helper_0fbe415e = require("@lib/monster/helper_0fbe415e")
local helper_2aa4e058 = require("@lib/monster/helper_2aa4e058")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_9662aa5e = require("@lib/monster/helper_9662aa5e")
local helper_b9b0f992 = require("@lib/monster/helper_b9b0f992")
local helper_c3e8ae39 = require("@lib/monster/helper_c3e8ae39")

--- Helper function.
local function helper_2b3d84b9()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 65 then
		argc = monster.get_random(100) or argc
		if argc < 5 then
			monster.set_motion("歩き", 0.65, 0)
			helper_2aa4e058(4.0, 20.0, 15)
			helper_06e363ee()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(3)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			helper_9662aa5e()
			monster.set_motion("立ち", -1, 0)
			helper_c3e8ae39(3)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 80 then
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			monster.set_motion("歩き", 0.6, 0)
			helper_b9b0f992(vm.f32(2.4), 4.0, 49.0, 60)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			helper_0fbe415e(1)
		end
	end
end

return helper_2b3d84b9
