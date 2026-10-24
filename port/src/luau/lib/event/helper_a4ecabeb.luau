--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local helper_2f8c501c = require("@lib/event/helper_2f8c501c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_54207bc4 = require("@lib/event/helper_54207bc4")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")

--- Helper function.
local function helper_a4ecabeb(arg0: s32, arg1: s32)
	local var7: s32 = 0
	print("---------------------------------------------BATTLE BGM STOP\n")
	helper_d3f20302(30)
	helper_344d6cd8()
	helper_d3f20302(30)
	helper_fbd9683d(0, 7)
	helper_2f8c501c(arg1, -1, 10)
	helper_d3f20302(10)
	helper_d3f20302(30)
	helper_d3f20302(120)
	local _ = helper_dbff9fb6(0)
	helper_54207bc4(1)
	helper_54207bc4(4)
	helper_54207bc4(var7)
	helper_54207bc4(1)
	helper_d3f20302(30)
	helper_d3f20302(30)
	return 1
end

return helper_a4ecabeb
