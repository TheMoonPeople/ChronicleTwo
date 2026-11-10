--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_36e6ff8c = require("@lib/event/helper_36e6ff8c")
local helper_629cad03 = require("@lib/event/helper_629cad03")
local helper_735d0b46 = require("@lib/event/helper_735d0b46")
local helper_c4f7210b = require("@lib/event/helper_c4f7210b")

--- Helper function.
local function helper_db6ea4f8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_c4f7210b(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_36e6ff8c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_629cad03(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_735d0b46(arg0, arg1)
		return
	end
end

return helper_db6ea4f8
