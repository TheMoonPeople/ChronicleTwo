--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_373f3341 = require("@lib/event/helper_373f3341")
local helper_3f87abde = require("@lib/event/helper_3f87abde")
local helper_ac42b22a = require("@lib/event/helper_ac42b22a")
local helper_d69072ba = require("@lib/event/helper_d69072ba")
local helper_f8cc13e1 = require("@lib/event/helper_f8cc13e1")

--- Helper function.
local function helper_6fd9406e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_d69072ba(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_373f3341(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_f8cc13e1(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_3f87abde(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_ac42b22a(arg0, arg1)
		return
	end
end

return helper_6fd9406e
