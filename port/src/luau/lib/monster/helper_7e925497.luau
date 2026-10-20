--!strict
-- Shared monster helper used by 16 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_5af194a0 = require("@lib/monster/helper_5af194a0")

--- Helper function.
local function helper_7e925497(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32)
	for var5 = 0, arg4 - 1 do
		helper_0ba23e4e()
		if helper_5af194a0(arg0, arg1, arg2, arg3) == 1 then
			return 1
		end
	end
	return 0
end

return helper_7e925497
