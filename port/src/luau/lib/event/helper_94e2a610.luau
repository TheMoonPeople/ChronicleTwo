--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_44e7b6e8 = require("@lib/event/helper_44e7b6e8")
local helper_612fd391 = require("@lib/event/helper_612fd391")
local helper_9a8fd7b9 = require("@lib/event/helper_9a8fd7b9")
local helper_9a91aa45 = require("@lib/event/helper_9a91aa45")
local helper_d7600f90 = require("@lib/event/helper_d7600f90")

--- Helper function.
local function helper_94e2a610(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_44e7b6e8(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_9a91aa45(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_612fd391(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_d7600f90(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_9a8fd7b9(arg0, arg1)
		return
	end
end

return helper_94e2a610
