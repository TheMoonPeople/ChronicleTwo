--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_87cf4648 = require("@lib/event/helper_87cf4648")
local helper_9a2a4514 = require("@lib/event/helper_9a2a4514")
local helper_b3cde08e = require("@lib/event/helper_b3cde08e")
local helper_e1007dd8 = require("@lib/event/helper_e1007dd8")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")

--- Helper function.
local function helper_8721214b(arg0: s32, arg1: s32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	helper_038a2e4d(15)
	helper_87cf4648(0)
	helper_038a2e4d(5)
	helper_344d6cd8()
	helper_038a2e4d(5)
	var6 = helper_e1007dd8(var6)
	var7 = helper_b3cde08e(13, arg0, var7)
	var6 = helper_9a2a4514(var6)
	helper_344d6cd8()
	var8 = 0
	var9 = 0
	helper_5c12934f(arg0, var10)
	helper_ee1c51d0(0, -1, 8, 0, 0)
	print("CHECK_GET_ITEM_LIMIT = ", var8, "\n")
	print("CHECK_ITEM_OVER      = ", var9, "\n")
	helper_038a2e4d(10)
	helper_ee1c51d0(0, 2240, 8, 0, 0)
	helper_ee1c51d0(0, 2250, 8, 0, 0)
end

return helper_8721214b
