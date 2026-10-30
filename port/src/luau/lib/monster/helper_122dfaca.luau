--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0fbe415e = require("@lib/monster/helper_0fbe415e")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")

--- Helper function.
local function helper_122dfaca()
	local argc: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(49.0, 90.0, 30)
	else
		argc = monster.get_random(100) or argc
		if argc < 50 then
			argc = monster.get_random(100) or argc
			var2 = monster.get_random_whole_number(30.0) or var2
			var3 = monster.get_random_whole_number(30.0) or var3
			var3 = vm.f32(var3 + 85.0)
			if argc < 50 then
				var2 = vm.f32(-var2 - 30.0)
			else
				var2 = vm.f32(var2 + 30.0)
			end
			monster.set_motion("歩き", 0.6, 0)
			local _ = helper_8be991f0(vm.f32(2.4), 4.0, var2, var3, 49.0, 40)
			helper_890ee63a(4.0)
		else
			monster.set_motion("歩き", 0.65, 0)
			helper_890ee63a(4.0)
			argc = monster.get_random(2) or argc
			helper_0fbe415e(argc)
		end
	end
end

return helper_122dfaca
