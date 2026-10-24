--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_a5a49840 = require("@lib/event/helper_a5a49840")
local helper_b142be72 = require("@lib/event/helper_b142be72")
local helper_d2f541ea = require("@lib/event/helper_d2f541ea")
local helper_d5827ced = require("@lib/event/helper_d5827ced")
local helper_f20dd356 = require("@lib/event/helper_f20dd356")

--- Helper function.
local function helper_8e8fb883(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_a5a49840(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_f20dd356(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_d2f541ea(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_d5827ced(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_b142be72(arg0, arg1)
		return
	end
end

return helper_8e8fb883
