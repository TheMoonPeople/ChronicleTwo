--!strict
-- Shared event helper used by 105 scripts, translated by tools/luau/stb2luau.

local helper_955d22b3 = require("@lib/event/helper_955d22b3")
local helper_ba297414 = require("@lib/event/helper_ba297414")
local helper_be16759c = require("@lib/event/helper_be16759c")

--- Helper function.
local function helper_43e09e65(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local var5: s32 = 0
	var4 = helper_955d22b3(arg0, arg2, arg3)
	helper_be16759c(0, arg1, arg0, var5, 0)
	helper_ba297414(arg0, var4, arg2, arg3)
end

return helper_43e09e65
