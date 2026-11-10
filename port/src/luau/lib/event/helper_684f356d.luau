--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_2c8ec005 = require("@lib/event/helper_2c8ec005")
local helper_38443164 = require("@lib/event/helper_38443164")
local helper_ea72e3b5 = require("@lib/event/helper_ea72e3b5")

--- Helper function.
local function helper_684f356d(arg0: any, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local var5: s32 = 0
	var4 = helper_2c8ec005(arg0, arg2, arg3)
	helper_38443164(0, arg1, arg0, var5, 0)
	helper_ea72e3b5(arg0, var4, arg2, arg3)
end

return helper_684f356d
