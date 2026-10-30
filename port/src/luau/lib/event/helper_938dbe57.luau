--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1ea953bb = require("@lib/event/helper_1ea953bb")
local helper_8b4eb093 = require("@lib/event/helper_8b4eb093")
local helper_e23e77dd = require("@lib/event/helper_e23e77dd")
local helper_e480eaca = require("@lib/event/helper_e480eaca")

--- Helper function.
local function helper_938dbe57(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_8b4eb093(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 19) or var2
	if var2 == 0 then
		helper_e23e77dd(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_1ea953bb(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_e480eaca(arg0, arg1)
		return
	end
end

return helper_938dbe57
