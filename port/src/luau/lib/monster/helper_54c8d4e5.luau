--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8be991f0 = require("@lib/monster/helper_8be991f0")

--- Helper function.
local function helper_54c8d4e5()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		monster.set_variable(0, 64)
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 200.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = helper_8be991f0(vm.f32(1.8), 3.0, var3, var4, 64.0, 30)
		helper_890ee63a(3.0)
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_variable(0, 16)
		monster.set_motion("立ち", -1, 0)
		helper_7ca8a12f(64.0, 45.0, 30)
	end
end

return helper_54c8d4e5
