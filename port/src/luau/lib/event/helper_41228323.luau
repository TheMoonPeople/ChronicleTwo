--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_581eea62 = require("@lib/event/helper_581eea62")
local helper_afb222f0 = require("@lib/event/helper_afb222f0")
local helper_c19d7089 = require("@lib/event/helper_c19d7089")
local helper_c248f8d5 = require("@lib/event/helper_c248f8d5")

--- Helper function.
local function helper_41228323(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_c248f8d5(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 4) or var2
	if var2 == 0 then
		helper_581eea62(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_afb222f0(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c19d7089(arg0, arg1)
		return
	end
end

return helper_41228323
