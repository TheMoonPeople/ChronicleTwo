--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_145d92f0 = require("@lib/event/helper_145d92f0")
local helper_7871430b = require("@lib/event/helper_7871430b")
local helper_d94aa041 = require("@lib/event/helper_d94aa041")
local helper_e28b3446 = require("@lib/event/helper_e28b3446")

--- Helper function.
local function helper_82030999(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e28b3446(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_d94aa041(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7871430b(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_145d92f0(arg0, arg1)
		return
	end
end

return helper_82030999
