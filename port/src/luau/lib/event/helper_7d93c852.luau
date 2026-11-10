--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_1cb15a17 = require("@lib/event/helper_1cb15a17")
local helper_1cdf1bb4 = require("@lib/event/helper_1cdf1bb4")
local helper_7f1b43ad = require("@lib/event/helper_7f1b43ad")
local helper_ab39c9ae = require("@lib/event/helper_ab39c9ae")

--- Helper function.
local function helper_7d93c852(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_ab39c9ae(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_1cb15a17(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7f1b43ad(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_1cdf1bb4(arg0, arg1)
		return
	end
end

return helper_7d93c852
