--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_5743cba3 = require("@lib/monster/helper_5743cba3")
local helper_bee0409d = require("@lib/monster/helper_bee0409d")

--- Helper function.
local function helper_4d763a19(arg0: f32, arg1: f32, arg2: s32)
	for var8 = 0, arg2 - 1 do
		monster.get_rotation()
		monster.get_target_distance()
		monster.get_target_angle()
		helper_bee0409d()
		if helper_5743cba3(arg0, arg1) == 1 then
			return 1
		end
	end
	return 0
end

return helper_4d763a19
