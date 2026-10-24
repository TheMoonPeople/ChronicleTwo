--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_38c98de1 = require("@lib/event/helper_38c98de1")
local helper_802f3357 = require("@lib/event/helper_802f3357")
local helper_9865fef1 = require("@lib/event/helper_9865fef1")
local helper_bd1c047e = require("@lib/event/helper_bd1c047e")

--- Helper function.
local function helper_952acc1e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_9865fef1(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_38c98de1(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_bd1c047e(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_802f3357(arg0, arg1)
		return
	end
end

return helper_952acc1e
