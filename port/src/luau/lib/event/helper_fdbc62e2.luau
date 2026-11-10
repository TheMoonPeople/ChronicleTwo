--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_23c18142 = require("@lib/event/helper_23c18142")
local helper_5b8375e3 = require("@lib/event/helper_5b8375e3")
local helper_6f71e775 = require("@lib/event/helper_6f71e775")
local helper_d8d03c99 = require("@lib/event/helper_d8d03c99")

--- Helper function.
local function helper_fdbc62e2(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_5b8375e3(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_6f71e775(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_23c18142(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d8d03c99(arg0, arg1)
		return
	end
end

return helper_fdbc62e2
