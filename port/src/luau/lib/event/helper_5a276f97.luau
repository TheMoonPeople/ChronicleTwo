--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2b24dc49 = require("@lib/event/helper_2b24dc49")
local helper_4accba9b = require("@lib/event/helper_4accba9b")
local helper_61c47bc9 = require("@lib/event/helper_61c47bc9")
local helper_d925bdb3 = require("@lib/event/helper_d925bdb3")
local helper_eb39d2ba = require("@lib/event/helper_eb39d2ba")

--- Helper function.
local function helper_5a276f97(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_2b24dc49(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_eb39d2ba(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_61c47bc9(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_4accba9b(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_d925bdb3(arg0, arg1)
		return
	end
end

return helper_5a276f97
