--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0f30563f = require("@lib/event/helper_0f30563f")
local helper_d7aa7996 = require("@lib/event/helper_d7aa7996")
local helper_da93e75d = require("@lib/event/helper_da93e75d")
local helper_e8247f91 = require("@lib/event/helper_e8247f91")

--- Helper function.
local function helper_c155b08f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_d7aa7996(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 19) or var2
	if var2 == 0 then
		helper_0f30563f(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_da93e75d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_e8247f91(arg0, arg1)
		return
	end
end

return helper_c155b08f
