--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_30221b74 = require("@lib/event/helper_30221b74")
local helper_609b3991 = require("@lib/event/helper_609b3991")
local helper_72db4f95 = require("@lib/event/helper_72db4f95")
local helper_b532b164 = require("@lib/event/helper_b532b164")

--- Helper function.
local function helper_f4ac04ae(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_b532b164(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_72db4f95(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_609b3991(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_30221b74(arg0, arg1)
		return
	end
end

return helper_f4ac04ae
