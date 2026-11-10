--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_17f22f03 = require("@lib/event/helper_17f22f03")
local helper_440ab484 = require("@lib/event/helper_440ab484")
local helper_4b332c29 = require("@lib/event/helper_4b332c29")
local helper_d1564f3a = require("@lib/event/helper_d1564f3a")

--- Helper function.
local function helper_215574ee(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_4b332c29(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_17f22f03(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_d1564f3a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_440ab484(arg0, arg1)
		return
	end
end

return helper_215574ee
