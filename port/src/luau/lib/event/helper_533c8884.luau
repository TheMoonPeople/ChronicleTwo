--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_b507dfba = require("@lib/event/helper_b507dfba")
local helper_c05d6bc9 = require("@lib/event/helper_c05d6bc9")
local helper_efb3a617 = require("@lib/event/helper_efb3a617")
local helper_fb2fef53 = require("@lib/event/helper_fb2fef53")

--- Helper function.
local function helper_533c8884(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_b507dfba(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_fb2fef53(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_c05d6bc9(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_efb3a617(arg0, arg1)
		return
	end
end

return helper_533c8884
