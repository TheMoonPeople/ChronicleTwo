--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_194337c1 = require("@lib/event/helper_194337c1")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_5c559bd8 = require("@lib/event/helper_5c559bd8")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")

--- Helper function.
local function helper_5d0fc1fa()
	local var0: s32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	helper_fbd9683d(0, 1)
	var9 = helper_5c559bd8(var0, 0, 0)
	helper_249b75d1(0, -1, var0, var10, 0)
	local _ = helper_7d54f41c(0, -1, 5, 256, 208, 2, 0)
	helper_249b75d1(0, -1, var0, var10, 0)
	helper_194337c1(var0, var9, 0, 0)
	return 1
end

return helper_5d0fc1fa
