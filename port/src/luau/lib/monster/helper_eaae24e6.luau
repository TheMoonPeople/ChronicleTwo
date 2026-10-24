--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3e764841 = require("@lib/monster/helper_3e764841")
local helper_df9a3a05 = require("@lib/monster/helper_df9a3a05")
local helper_f5727415 = require("@lib/monster/helper_f5727415")

--- Helper function.
local function helper_eaae24e6()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.GetRnd(100) or argc
	if argc < 50 then
		argc = monster.GetRnd(100) or argc
		var3 = monster.GetRndf(30.0) or var3
		var4 = monster.GetRndf(30.0) or var4
		var4 = vm.f32(var4 + 90.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.SetMos("歩き", -1, 0)
		local _ = helper_df9a3a05(1.75, vm.f32(4.8), var3, 60.0, 1.0, 30.0, 50)
		helper_f5727415(vm.f32(4.8))
		monster.SetMos("立ち", -1, 0)
	else
		monster.SetMos("立ち", -1, 0)
		helper_3e764841(30.0, 45.0, 30)
	end
end

return helper_eaae24e6
