--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_11936589 = require("@lib/event/helper_11936589")
local helper_2abe1549 = require("@lib/event/helper_2abe1549")
local helper_8ab820b1 = require("@lib/event/helper_8ab820b1")
local helper_d5f7c66b = require("@lib/event/helper_d5f7c66b")

--- Helper function.
local function helper_23f66934(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_2abe1549(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 15) or var2
	if var2 == 0 then
		helper_8ab820b1(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_11936589(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d5f7c66b(arg0, arg1)
		return
	end
end

return helper_23f66934
