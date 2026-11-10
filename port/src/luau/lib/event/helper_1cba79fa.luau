--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_5c559bd8 = require("@lib/event/helper_5c559bd8")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")

--- Helper function.
local function helper_1cba79fa(arg0: s32, arg1: any)
	local var4: s32 = 0
	helper_038a2e4d(9)
	helper_fbd9683d(0, 1)
	helper_5c559bd8(arg0, 0, 0)
	helper_249b75d1(0, -1, arg0, var4, 0)
	local _ = helper_7d54f41c(0, -1, 5, 256, 208, 2, 0)
	helper_249b75d1(0, -1, arg0, var4, 0)
	helper_038a2e4d(30)
end

return helper_1cba79fa
