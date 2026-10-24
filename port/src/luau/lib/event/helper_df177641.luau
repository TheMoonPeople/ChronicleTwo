--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_99fbb190 = require("@lib/event/helper_99fbb190")
local helper_e0f2d78f = require("@lib/event/helper_e0f2d78f")
local helper_f96c15b3 = require("@lib/event/helper_f96c15b3")
local helper_f99cbdfa = require("@lib/event/helper_f99cbdfa")

--- Helper function.
local function helper_df177641(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_f96c15b3(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_99fbb190(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_f99cbdfa(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_e0f2d78f(arg0, arg1)
		return
	end
end

return helper_df177641
