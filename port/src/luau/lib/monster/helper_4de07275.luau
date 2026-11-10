--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_11504ed4 = require("@lib/monster/helper_11504ed4")
local helper_abe18b40 = require("@lib/monster/helper_abe18b40")

--- Helper function.
local function helper_4de07275(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, arg5: f32, arg6: f32)
	local var7: f32 = 0
	local var8: f32 = 0
	var7 = helper_abe18b40(arg0, arg1, arg2, arg5, arg6)
	if var7 < -arg3 then
		return 0
	end
	if arg3 < var7 then
		return 0
	end
	var8 = helper_11504ed4(arg0, arg1, arg5, arg6)
	if arg4 < var8 then
		return 0
	end
	return 1
end

return helper_4de07275
