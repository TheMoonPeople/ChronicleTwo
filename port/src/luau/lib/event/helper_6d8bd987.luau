--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_4a962e5f = require("@lib/event/helper_4a962e5f")
local helper_506f4777 = require("@lib/event/helper_506f4777")
local helper_b5e1e8d7 = require("@lib/event/helper_b5e1e8d7")
local helper_f03205a9 = require("@lib/event/helper_f03205a9")

--- Helper function.
local function helper_6d8bd987(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_f03205a9(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_506f4777(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_4a962e5f(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b5e1e8d7(arg0, arg1)
		return
	end
end

return helper_6d8bd987
