--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_713d6982 = require("@lib/event/helper_713d6982")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")

--- Helper function.
local function helper_b6e37bb7(arg0: s32, arg1: s32)
	local var3: s32 = 0
	var3 = 0
	local _ = helper_713d6982(arg0, 0)
	local _ = var3 < arg1
	var3 = var3 + 1
	var3 = var3 + 1
	helper_d16eef1e(arg0)
	return var3
end

return helper_b6e37bb7
