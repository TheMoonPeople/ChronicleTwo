--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_65df8bdc = require("@lib/monster/helper_65df8bdc")
local helper_7ca8a12f = require("@lib/monster/helper_7ca8a12f")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")

--- Helper function.
local function helper_f7a409dc()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		var3 = monster.GetRndf(30.0) or var3
		var4 = monster.GetRndf(30.0) or var4
		var4 = vm.f32(var4 + 120.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.SetMos("歩き", -1, 0)
		helper_65df8bdc(2.0, vm.f32(4.8), var3, var4, 35.0, 25.0, 60)
		helper_890ee63a(vm.f32(4.8))
	else
		monster.SetMos("立ち", -1, 0)
		helper_7ca8a12f(35.0, 45.0, 30)
	end
end

return helper_f7a409dc
