--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_037cd367 = require("@lib/event/helper_037cd367")
local helper_2aec5763 = require("@lib/event/helper_2aec5763")
local helper_69cd8f6b = require("@lib/event/helper_69cd8f6b")
local helper_f569b20f = require("@lib/event/helper_f569b20f")

--- Helper function.
local function helper_464ba243(arg0: s32, arg1: s32)
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
		helper_2aec5763(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_69cd8f6b(arg0, arg1)
		return
	end
end

return helper_464ba243
