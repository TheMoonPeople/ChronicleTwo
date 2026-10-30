--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_72ae4557 = require("@lib/event/helper_72ae4557")
local helper_85579c12 = require("@lib/event/helper_85579c12")
local helper_97320eab = require("@lib/event/helper_97320eab")
local helper_ae4e676b = require("@lib/event/helper_ae4e676b")

--- Helper function.
local function helper_59d6deef(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_72ae4557(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 18) or var2
	if var2 == 0 then
		helper_ae4e676b(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_97320eab(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_85579c12(arg0, arg1)
		return
	end
end

return helper_59d6deef
