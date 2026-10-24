--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_42fa4e48 = require("@lib/event/helper_42fa4e48")
local helper_4c2cf027 = require("@lib/event/helper_4c2cf027")
local helper_b507dfba = require("@lib/event/helper_b507dfba")
local helper_efb3a617 = require("@lib/event/helper_efb3a617")

--- Helper function.
local function helper_183adbb5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_b507dfba(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_4c2cf027(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_42fa4e48(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_efb3a617(arg0, arg1)
		return
	end
end

return helper_183adbb5
