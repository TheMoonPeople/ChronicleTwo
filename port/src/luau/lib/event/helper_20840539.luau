--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_12d09a4c = require("@lib/event/helper_12d09a4c")
local helper_55fbea49 = require("@lib/event/helper_55fbea49")
local helper_a0cbc98b = require("@lib/event/helper_a0cbc98b")
local helper_cb9bf720 = require("@lib/event/helper_cb9bf720")
local helper_fc439d89 = require("@lib/event/helper_fc439d89")

--- Helper function.
local function helper_20840539(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_12d09a4c(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_55fbea49(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_a0cbc98b(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_fc439d89(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_cb9bf720(arg0, arg1)
		return
	end
end

return helper_20840539
