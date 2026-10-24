--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_661b6d54 = require("@lib/event/helper_661b6d54")
local helper_911a6f49 = require("@lib/event/helper_911a6f49")
local helper_e1971448 = require("@lib/event/helper_e1971448")
local helper_f8dd777b = require("@lib/event/helper_f8dd777b")

--- Helper function.
local function helper_0b064184(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_911a6f49(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_661b6d54(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_e1971448(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f8dd777b(arg0, arg1)
		return
	end
end

return helper_0b064184
