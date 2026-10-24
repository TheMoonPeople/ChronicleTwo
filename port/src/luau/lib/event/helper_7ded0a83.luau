--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_41f509bd = require("@lib/event/helper_41f509bd")
local helper_802f3357 = require("@lib/event/helper_802f3357")
local helper_9865fef1 = require("@lib/event/helper_9865fef1")
local helper_db556bd4 = require("@lib/event/helper_db556bd4")

--- Helper function.
local function helper_7ded0a83(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_9865fef1(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_41f509bd(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_db556bd4(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_802f3357(arg0, arg1)
		return
	end
end

return helper_7ded0a83
