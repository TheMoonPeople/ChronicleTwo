--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3e764841 = require("@lib/monster/helper_3e764841")
local helper_9d1ba522 = require("@lib/monster/helper_9d1ba522")
local helper_f5727415 = require("@lib/monster/helper_f5727415")

--- Helper function.
local function helper_34e0511a()
	local argc: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	argc = monster.get_random(100) or argc
	if argc < 50 then
		argc = monster.get_random(100) or argc
		var3 = monster.get_random_whole_number(30.0) or var3
		var4 = monster.get_random_whole_number(30.0) or var4
		var4 = vm.f32(var4 + 90.0)
		if argc < 50 then
			var3 = vm.f32(-var3 - 30.0)
		else
			var3 = vm.f32(var3 + 30.0)
		end
		monster.set_motion("歩き", -1, 0)
		local _ = helper_9d1ba522(1.75, vm.f32(4.8), var3, 60.0, 1.0, 30.0, 50)
		helper_f5727415(vm.f32(4.8))
		monster.set_motion("立ち", -1, 0)
	else
		monster.set_motion("立ち", -1, 0)
		helper_3e764841(30.0, 45.0, 30)
	end
end

return helper_34e0511a
