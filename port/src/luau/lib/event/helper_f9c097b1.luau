--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_31166470 = require("@lib/event/helper_31166470")
local helper_392f69da = require("@lib/event/helper_392f69da")
local helper_d4378c2a = require("@lib/event/helper_d4378c2a")
local helper_f9668fe2 = require("@lib/event/helper_f9668fe2")

--- Helper function.
local function helper_f9c097b1(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_31166470(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_f9668fe2(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_392f69da(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d4378c2a(arg0, arg1)
		return
	end
end

return helper_f9c097b1
