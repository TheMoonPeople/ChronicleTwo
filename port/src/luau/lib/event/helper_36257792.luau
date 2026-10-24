--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_7bc8ff5c = require("@lib/event/helper_7bc8ff5c")
local helper_b891c7b6 = require("@lib/event/helper_b891c7b6")
local helper_d56f96fa = require("@lib/event/helper_d56f96fa")
local helper_f39e9223 = require("@lib/event/helper_f39e9223")

--- Helper function.
local function helper_36257792(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_b891c7b6(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_d56f96fa(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7bc8ff5c(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f39e9223(arg0, arg1)
		return
	end
end

return helper_36257792
