--!strict
-- Shared monster helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_b765e6cd(arg0: f32, arg1: s32)
	local var2: f32 = 0
	local _ = helper_787df986(arg0)
	for var4 = 0, arg1 - 1 do
		var2 = monster.GetTargetAngle() or var2
		monster.SetNextRot(var2, arg0)
		helper_b9fff8e1()
	end
	helper_442b9962()
	return 0
end

return helper_b765e6cd
