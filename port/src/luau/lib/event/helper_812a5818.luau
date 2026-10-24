--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_6cb58f13 = require("@lib/event/helper_6cb58f13")
local helper_a6df1a40 = require("@lib/event/helper_a6df1a40")
local helper_c98423d6 = require("@lib/event/helper_c98423d6")
local helper_ff85d01a = require("@lib/event/helper_ff85d01a")

--- Helper function.
local function helper_812a5818(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_ff85d01a(arg0, arg1, 0)
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_a6df1a40(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_6cb58f13(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c98423d6(arg0, arg1)
		return
	end
end

return helper_812a5818
