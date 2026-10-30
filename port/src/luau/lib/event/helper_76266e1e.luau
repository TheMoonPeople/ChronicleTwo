--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_144a9aa3 = require("@lib/event/helper_144a9aa3")
local helper_3ea1fe7a = require("@lib/event/helper_3ea1fe7a")
local helper_7551f10b = require("@lib/event/helper_7551f10b")
local helper_8a71fd9c = require("@lib/event/helper_8a71fd9c")

--- Helper function.
local function helper_76266e1e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3ea1fe7a(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 15) or var2
	if var2 == 0 then
		helper_144a9aa3(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7551f10b(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_8a71fd9c(arg0, arg1)
		return
	end
end

return helper_76266e1e
