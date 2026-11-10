--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5fd0e50d = require("@lib/event/helper_5fd0e50d")
local helper_7d3f0be4 = require("@lib/event/helper_7d3f0be4")
local helper_b244056c = require("@lib/event/helper_b244056c")
local helper_f07bb675 = require("@lib/event/helper_f07bb675")

--- Helper function.
local function helper_1575b2d1(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_b244056c(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 2) or var2
	if var2 == 0 then
		helper_f07bb675(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7d3f0be4(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_5fd0e50d(arg0, arg1)
		return
	end
end

return helper_1575b2d1
