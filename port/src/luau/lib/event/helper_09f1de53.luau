--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_911a6f49 = require("@lib/event/helper_911a6f49")
local helper_c3bd2b92 = require("@lib/event/helper_c3bd2b92")
local helper_f7381796 = require("@lib/event/helper_f7381796")
local helper_f8dd777b = require("@lib/event/helper_f8dd777b")

--- Helper function.
local function helper_09f1de53(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_911a6f49(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_f7381796(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_c3bd2b92(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f8dd777b(arg0, arg1)
		return
	end
end

return helper_09f1de53
