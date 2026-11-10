--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_9b68f08b = require("@lib/event/helper_9b68f08b")
local helper_aea17467 = require("@lib/event/helper_aea17467")
local helper_af25ac00 = require("@lib/event/helper_af25ac00")
local helper_c14c6c96 = require("@lib/event/helper_c14c6c96")

--- Helper function.
local function helper_58844b1e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_9b68f08b(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_aea17467(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_c14c6c96(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_af25ac00(arg0, arg1)
		return
	end
end

return helper_58844b1e
