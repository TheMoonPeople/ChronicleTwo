--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_03901f82 = require("@lib/event/helper_03901f82")
local helper_56a27184 = require("@lib/event/helper_56a27184")
local helper_9cc8f17c = require("@lib/event/helper_9cc8f17c")
local helper_b892f286 = require("@lib/event/helper_b892f286")

--- Helper function.
local function helper_0bb8412f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_9cc8f17c(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_b892f286(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_56a27184(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_03901f82(arg0, arg1)
		return
	end
end

return helper_0bb8412f
