--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_34eff2da = require("@lib/event/helper_34eff2da")
local helper_60f2e189 = require("@lib/event/helper_60f2e189")
local helper_69cdd66c = require("@lib/event/helper_69cdd66c")
local helper_883d6941 = require("@lib/event/helper_883d6941")

--- Helper function.
local function helper_d5e8455a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_883d6941(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_69cdd66c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_34eff2da(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_60f2e189(arg0, arg1)
		return
	end
end

return helper_d5e8455a
