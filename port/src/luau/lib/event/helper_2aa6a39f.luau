--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_07940289 = require("@lib/event/helper_07940289")
local helper_1c48973a = require("@lib/event/helper_1c48973a")
local helper_5a890106 = require("@lib/event/helper_5a890106")
local helper_a739126c = require("@lib/event/helper_a739126c")

--- Helper function.
local function helper_2aa6a39f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_07940289(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_a739126c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_1c48973a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_5a890106(arg0, arg1)
		return
	end
end

return helper_2aa6a39f
