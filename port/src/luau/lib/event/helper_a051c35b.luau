--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_123e3342 = require("@lib/event/helper_123e3342")
local helper_88ce71c3 = require("@lib/event/helper_88ce71c3")
local helper_b89e8852 = require("@lib/event/helper_b89e8852")
local helper_bad9e90b = require("@lib/event/helper_bad9e90b")

--- Helper function.
local function helper_a051c35b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_123e3342(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_88ce71c3(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b89e8852(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_bad9e90b(arg0, arg1)
		return
	end
end

return helper_a051c35b
