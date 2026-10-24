--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0c59fe05 = require("@lib/event/helper_0c59fe05")
local helper_10625ea5 = require("@lib/event/helper_10625ea5")
local helper_52b6c564 = require("@lib/event/helper_52b6c564")
local helper_5cfb3070 = require("@lib/event/helper_5cfb3070")
local helper_5e014937 = require("@lib/event/helper_5e014937")
local helper_6b43f254 = require("@lib/event/helper_6b43f254")
local helper_7cc9b820 = require("@lib/event/helper_7cc9b820")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_c4aeb2aa = require("@lib/event/helper_c4aeb2aa")

--- Helper function.
local function helper_38d69cc1(arg0: s32, arg1: s32)
	helper_52b6c564(arg0, arg1)
	helper_6b43f254(arg0, arg1)
	helper_c4aeb2aa()
	helper_0c59fe05(arg0, arg1)
	helper_7cc9b820(arg0, arg1)
	helper_5e014937(arg0, arg1)
	helper_10625ea5(arg0, arg1)
	helper_5cfb3070(arg0, arg1)
	local _ = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
end

return helper_38d69cc1
