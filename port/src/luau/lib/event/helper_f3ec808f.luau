--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_063baf57 = require("@lib/event/helper_063baf57")
local helper_3b507125 = require("@lib/event/helper_3b507125")
local helper_aedd1ee8 = require("@lib/event/helper_aedd1ee8")
local helper_b968c13a = require("@lib/event/helper_b968c13a")

--- Helper function.
local function helper_f3ec808f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3b507125(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_aedd1ee8(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_063baf57(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b968c13a(arg0, arg1)
		return
	end
end

return helper_f3ec808f
