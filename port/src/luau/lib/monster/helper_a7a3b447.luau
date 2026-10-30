--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0fbe415e = require("@lib/monster/helper_0fbe415e")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_9662aa5e = require("@lib/monster/helper_9662aa5e")
local helper_b9b0f992 = require("@lib/monster/helper_b9b0f992")
local helper_dc78fc76 = require("@lib/monster/helper_dc78fc76")

--- Helper function.
local function helper_a7a3b447()
	local argc: s32 = 0
	argc = monster.get_random(100) or argc
	if argc < 95 then
		argc = monster.get_random(100) or argc
		if argc < 50 then
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			monster.set_motion("歩き", 0.6, 0)
			helper_b9b0f992(vm.f32(2.4), 4.0, 85.0, 75)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			helper_9662aa5e()
			monster.set_motion("立ち", -1, 0)
		end
	else
		argc = monster.get_random(100) or argc
		if argc < 10 then
			monster.set_motion("歩き", 0.6, 0)
			helper_dc78fc76(vm.f32(2.4), 4.0, 30.0, 180.0, 30.0, 85.0, 45)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			argc = monster.get_random(2) or argc
			helper_0fbe415e(argc)
		end
	end
end

return helper_a7a3b447
