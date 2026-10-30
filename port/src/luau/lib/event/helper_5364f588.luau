--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0c3ae00b = require("@lib/event/helper_0c3ae00b")
local helper_2af6cedf = require("@lib/event/helper_2af6cedf")
local helper_a6949455 = require("@lib/event/helper_a6949455")
local helper_ac5e5d1c = require("@lib/event/helper_ac5e5d1c")

--- Helper function.
local function helper_5364f588(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_2af6cedf(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 19) or var2
	if var2 == 0 then
		helper_ac5e5d1c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a6949455(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_0c3ae00b(arg0, arg1)
		return
	end
end

return helper_5364f588
