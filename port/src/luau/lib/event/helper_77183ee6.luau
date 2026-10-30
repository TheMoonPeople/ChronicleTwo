--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_440ab484 = require("@lib/event/helper_440ab484")
local helper_4b332c29 = require("@lib/event/helper_4b332c29")
local helper_853d6dc7 = require("@lib/event/helper_853d6dc7")
local helper_f585c60b = require("@lib/event/helper_f585c60b")

--- Helper function.
local function helper_77183ee6(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_4b332c29(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_f585c60b(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_853d6dc7(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_440ab484(arg0, arg1)
		return
	end
end

return helper_77183ee6
