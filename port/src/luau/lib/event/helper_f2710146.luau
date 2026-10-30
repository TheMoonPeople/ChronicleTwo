--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_15f97698 = require("@lib/event/helper_15f97698")
local helper_af0de7da = require("@lib/event/helper_af0de7da")
local helper_b58308fa = require("@lib/event/helper_b58308fa")
local helper_df43b14b = require("@lib/event/helper_df43b14b")

--- Helper function.
local function helper_f2710146(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_15f97698(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_df43b14b(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_b58308fa(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_af0de7da(arg0, arg1)
		return
	end
end

return helper_f2710146
