--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_4a365697 = require("@lib/event/helper_4a365697")
local helper_4f54a464 = require("@lib/event/helper_4f54a464")
local helper_7435650c = require("@lib/event/helper_7435650c")
local helper_a340178a = require("@lib/event/helper_a340178a")

--- Helper function.
local function helper_88180d1c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_7435650c(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 15) or var2
	if var2 == 0 then
		helper_a340178a(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_4a365697(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_4f54a464(arg0, arg1)
		return
	end
end

return helper_88180d1c
