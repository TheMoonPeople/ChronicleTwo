--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_54f42506 = require("@lib/event/helper_54f42506")
local helper_7b884571 = require("@lib/event/helper_7b884571")
local helper_ce1a3d98 = require("@lib/event/helper_ce1a3d98")
local helper_e7e22de9 = require("@lib/event/helper_e7e22de9")

--- Helper function.
local function helper_aa26cbbb(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_e7e22de9(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_7b884571(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_ce1a3d98(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_54f42506(arg0, arg1)
		return
	end
end

return helper_aa26cbbb
