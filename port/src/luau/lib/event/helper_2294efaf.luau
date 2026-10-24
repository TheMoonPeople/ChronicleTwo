--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_14fcd86d = require("@lib/event/helper_14fcd86d")
local helper_7594baa6 = require("@lib/event/helper_7594baa6")
local helper_c0d37c25 = require("@lib/event/helper_c0d37c25")
local helper_dc852554 = require("@lib/event/helper_dc852554")
local helper_eb21e01b = require("@lib/event/helper_eb21e01b")

--- Helper function.
local function helper_2294efaf(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_eb21e01b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_dc852554(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_7594baa6(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_14fcd86d(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_c0d37c25(arg0, arg1)
		return
	end
end

return helper_2294efaf
