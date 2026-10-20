--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_362382c7 = require("@lib/monster/helper_362382c7")
local helper_3e764841 = require("@lib/monster/helper_3e764841")
local helper_45797ccb = require("@lib/monster/helper_45797ccb")
local helper_6fca5c97 = require("@lib/monster/helper_6fca5c97")

--- Helper function.
local function helper_e31a3310()
	local var0: s32 = 0
	local var1: f32 = 0
	var1 = monster.GetRndf(360.0) or var1
	monster.SetMos("歩き", -1, 0)
	helper_362382c7(var1, vm.f32(4.8))
	monster.SetMos("立ち", -1, 0)
	helper_45797ccb(9)
	var0 = helper_3e764841(190.0, 45.0, 45)
	if var0 == 1 then
		monster.SetMos("走り", -1, 0)
		helper_6fca5c97(3.0, vm.f32(4.8), 30.0, 5.0, 0, 150)
		monster.SetMos("立ち", -1, 0)
	end
end

return helper_e31a3310
