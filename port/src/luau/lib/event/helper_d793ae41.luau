--!strict
-- Shared event helper used by 545 scripts, translated by tools/luau/stb2luau.

local helper_76929aca = require("@lib/event/helper_76929aca")
local helper_9a29103b = require("@lib/event/helper_9a29103b")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")

--- Helper function.
local function helper_d793ae41(arg0: any, arg1: any, arg2: any, arg3: s32)
	local var6: s32 = 0
	local var7: s32 = 0
	var7 = 0
	var6 = 0
	helper_9a29103b(arg0)
	var7 = helper_76929aca(arg0)
	local _ = var6 == 0
	local _ = var6 == 0
	var6 = var7
	helper_d16eef1e(arg0)
	return -1
end

return helper_d793ae41
