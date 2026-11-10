--!strict
-- Shared event helper used by 14 scripts, translated by tools/luau/stb2luau.

local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_26c3d54b = require("@lib/event/helper_26c3d54b")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_54207bc4 = require("@lib/event/helper_54207bc4")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")

--- Helper function.
local function helper_c930491d(arg0: s32, arg1: s32)
	local var7: s32 = 0
	print("---------------------------------------------BATTLE BGM STOP\n")
	helper_038a2e4d(30)
	helper_344d6cd8()
	helper_038a2e4d(30)
	helper_26c3d54b(arg1, -1)
	helper_038a2e4d(10)
	helper_038a2e4d(30)
	helper_038a2e4d(120)
	local _ = helper_dbff9fb6(0)
	helper_54207bc4(1)
	helper_54207bc4(4)
	helper_54207bc4(var7)
	helper_54207bc4(1)
	helper_038a2e4d(30)
	helper_038a2e4d(30)
	return 1
end

return helper_c930491d
