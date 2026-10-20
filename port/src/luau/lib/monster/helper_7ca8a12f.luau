--!strict
-- Shared monster helper used by 31 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_5743cba3 = require("@lib/monster/helper_5743cba3")

--- Helper function.
local function helper_7ca8a12f(arg0: f32, arg1: f32, arg2: s32)
	for var8 = 0, arg2 - 1 do
		monster.GetRot()
		monster.GetTargetDist()
		monster.GetTargetAngle()
		helper_0ba23e4e()
		if helper_5743cba3(arg0, arg1) == 1 then
			return 1
		end
	end
	return 0
end

return helper_7ca8a12f
