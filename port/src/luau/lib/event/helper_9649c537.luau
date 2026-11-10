--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_5c12934f = require("@lib/event/helper_5c12934f")
local helper_87cf4648 = require("@lib/event/helper_87cf4648")
local helper_9a2a4514 = require("@lib/event/helper_9a2a4514")
local helper_c579fd47 = require("@lib/event/helper_c579fd47")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_e1007dd8 = require("@lib/event/helper_e1007dd8")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")

--- Helper function.
local function helper_9649c537(arg0: any, arg1: any, arg2: any, arg3: any)
	local var9: s32 = 0
	local var10: f32 = 0
	local var14: s32 = 0
	local var15: f32 = 0
	local var21: s32 = 0
	helper_038a2e4d(15)
	helper_87cf4648(0)
	helper_038a2e4d(5)
	helper_344d6cd8()
	var10 = helper_e1007dd8(var10)
	var10 = helper_9a2a4514(var10)
	helper_038a2e4d(10)
	helper_038a2e4d(8)
	helper_038a2e4d(10)
	helper_ee1c51d0(0, 2230, 8, 256, 208)
	helper_ee1c51d0(0, 2231, 8, 256, 208)
	local _ = helper_f018b3c0(0, 2232, 8, 0, 0)
	local _ = helper_d793ae41(0, 2, 0, 1)
	var14 = arg0
	arg0 = arg2
	arg2 = var14
	var14 = arg1
	arg1 = arg3
	arg3 = var14
	var15 = helper_c579fd47(16, arg0, var15)
	var15 = helper_c579fd47(17, arg2, var15)
	helper_038a2e4d(10)
	helper_038a2e4d(60)
	helper_038a2e4d(6)
	helper_238b5abc(1)
	helper_5c12934f(arg2, var21)
	helper_ee1c51d0(0, -1, 8, 0, 0)
	helper_5c12934f(arg0, var21)
	helper_ee1c51d0(0, -1, 8, 0, 0)
	helper_038a2e4d(10)
	var9 = 0
	local _ = var9 <= 7
	var9 = var9 + 1
end

return helper_9649c537
