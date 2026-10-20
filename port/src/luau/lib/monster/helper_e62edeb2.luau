--!strict
-- Shared monster helper used by 45 scripts, translated by tools/luau/stb2luau.

local helper_5743cba3 = require("@lib/monster/helper_5743cba3")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_e62edeb2(arg0: f32, arg1: f32, arg2: s32)
	for var8 = 0, arg2 - 1 do
		monster.GetRot()
		monster.GetTargetDist()
		monster.GetTargetAngle()
		helper_b9fff8e1()
		if helper_5743cba3(arg0, arg1) == 1 then
			return 1
		end
	end
	return 0
end

return helper_e62edeb2
