--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_194337c1 = require("@lib/event/helper_194337c1")
local helper_5c559bd8 = require("@lib/event/helper_5c559bd8")
local helper_9ced6ae4 = require("@lib/event/helper_9ced6ae4")

--- Helper function.
local function helper_31d563c9(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local var5: s32 = 0
	var4 = helper_5c559bd8(arg0, arg2, arg3)
	helper_9ced6ae4(0, arg1, arg0, var5, 0)
	helper_194337c1(arg0, var4, arg2, arg3)
end

return helper_31d563c9
