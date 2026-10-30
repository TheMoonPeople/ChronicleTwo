--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")
local helper_45797ccb = require("@lib/monster/helper_45797ccb")
local helper_57bfae69 = require("@lib/monster/helper_57bfae69")
local helper_895326d8 = require("@lib/monster/helper_895326d8")
local helper_f5727415 = require("@lib/monster/helper_f5727415")

--- Helper function.
local function helper_f9be9dbe()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	monster.set_variable(0, 1)
	monster.set_motion("歩き", -1, 0)
	helper_f5727415(vm.f32(7.2000003))
	do
		local out1, out2, out3 = monster.get_target_position()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	monster.reset_motion()
	monster.set_motion("攻撃１", -1, 6)
	monster.get_target_position(var0, var1, var2)
	var6 = helper_57bfae69(var0, var1, var2, var6)
	helper_0b6e560f(var3, var4, var5, 12.0, 6.0, 5.0, 27)
	helper_895326d8()
	monster.set_motion("立ち", -1, 0)
	helper_45797ccb(9)
end

return helper_f9be9dbe
