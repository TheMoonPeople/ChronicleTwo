--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_939ba8c3 = require("@lib/event/helper_939ba8c3")
local helper_b3392189 = require("@lib/event/helper_b3392189")
local helper_de2643fa = require("@lib/event/helper_de2643fa")
local helper_f7c62d57 = require("@lib/event/helper_f7c62d57")

--- Helper function.
local function helper_ec48f09e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_f7c62d57(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_939ba8c3(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_de2643fa(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b3392189(arg0, arg1)
		return
	end
end

return helper_ec48f09e
