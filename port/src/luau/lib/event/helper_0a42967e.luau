--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0fb5f826 = require("@lib/event/helper_0fb5f826")
local helper_45c03ff2 = require("@lib/event/helper_45c03ff2")
local helper_6508b1a8 = require("@lib/event/helper_6508b1a8")
local helper_b6a40bb4 = require("@lib/event/helper_b6a40bb4")

--- Helper function.
local function helper_0a42967e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_45c03ff2(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 2) or var2
	if var2 == 0 then
		helper_b6a40bb4(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_0fb5f826(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_6508b1a8(arg0, arg1)
		return
	end
end

return helper_0a42967e
