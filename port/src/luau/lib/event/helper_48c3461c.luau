--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_3b507125 = require("@lib/event/helper_3b507125")
local helper_a65d4301 = require("@lib/event/helper_a65d4301")
local helper_b72b838d = require("@lib/event/helper_b72b838d")
local helper_b968c13a = require("@lib/event/helper_b968c13a")

--- Helper function.
local function helper_48c3461c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3b507125(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_a65d4301(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b72b838d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b968c13a(arg0, arg1)
		return
	end
end

return helper_48c3461c
