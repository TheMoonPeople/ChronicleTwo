--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_037cd367 = require("@lib/event/helper_037cd367")
local helper_69cd8f6b = require("@lib/event/helper_69cd8f6b")
local helper_701e3843 = require("@lib/event/helper_701e3843")
local helper_f569b20f = require("@lib/event/helper_f569b20f")

--- Helper function.
local function helper_cee50fa6(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_f569b20f(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_037cd367(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_701e3843(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_69cd8f6b(arg0, arg1)
		return
	end
end

return helper_cee50fa6
