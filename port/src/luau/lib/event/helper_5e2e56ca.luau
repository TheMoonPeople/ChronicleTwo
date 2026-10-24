--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_83893273 = require("@lib/event/helper_83893273")
local helper_b776f779 = require("@lib/event/helper_b776f779")
local helper_ef7f6710 = require("@lib/event/helper_ef7f6710")
local helper_fbac1fb1 = require("@lib/event/helper_fbac1fb1")

--- Helper function.
local function helper_5e2e56ca(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_fbac1fb1(arg0, arg1, 0)
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_ef7f6710(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_83893273(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b776f779(arg0, arg1)
		return
	end
end

return helper_5e2e56ca
