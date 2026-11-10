--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_53267756 = require("@lib/event/helper_53267756")
local helper_60f2e189 = require("@lib/event/helper_60f2e189")
local helper_883d6941 = require("@lib/event/helper_883d6941")
local helper_bedab64d = require("@lib/event/helper_bedab64d")

--- Helper function.
local function helper_59f2903b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_883d6941(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_53267756(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_bedab64d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_60f2e189(arg0, arg1)
		return
	end
end

return helper_59f2903b
