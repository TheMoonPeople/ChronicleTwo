--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_12b9131d = require("@lib/event/helper_12b9131d")
local helper_40e84721 = require("@lib/event/helper_40e84721")
local helper_44540785 = require("@lib/event/helper_44540785")
local helper_921485d5 = require("@lib/event/helper_921485d5")
local helper_9d86098c = require("@lib/event/helper_9d86098c")
local helper_a29b423b = require("@lib/event/helper_a29b423b")

--- Helper function.
local function helper_7a587a35()
	local var1: s32 = 0
	local var2: s32 = 0
	var2 = helper_12b9131d()
	var1 = if var2 ~= 0 then helper_a29b423b() else 0
	helper_40e84721(203, var1)
	helper_40e84721(214, var1)
	helper_40e84721(205, helper_44540785())
	var1 = if var2 ~= 0 then helper_921485d5() else 0
	helper_40e84721(206, var1)
	var1 = if var2 ~= 0 then helper_9d86098c() else 0
	helper_40e84721(213, var1)
end

return helper_7a587a35
