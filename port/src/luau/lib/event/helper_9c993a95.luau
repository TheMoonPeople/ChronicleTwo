--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_9b24f47f = require("@lib/event/helper_9b24f47f")
local helper_a1042dd7 = require("@lib/event/helper_a1042dd7")
local helper_d96e5272 = require("@lib/event/helper_d96e5272")
local helper_f53c4f47 = require("@lib/event/helper_f53c4f47")

--- Helper function.
local function helper_9c993a95(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_9b24f47f(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_a1042dd7(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_f53c4f47(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d96e5272(arg0, arg1)
		return
	end
end

return helper_9c993a95
