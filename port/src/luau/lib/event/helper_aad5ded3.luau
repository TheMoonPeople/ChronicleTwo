--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_26c38f5b = require("@lib/event/helper_26c38f5b")
local helper_35ae038b = require("@lib/event/helper_35ae038b")
local helper_afd47a37 = require("@lib/event/helper_afd47a37")
local helper_bd6ab23d = require("@lib/event/helper_bd6ab23d")
local helper_deb38ea6 = require("@lib/event/helper_deb38ea6")

--- Helper function.
local function helper_aad5ded3(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_afd47a37(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_35ae038b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_deb38ea6(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_26c38f5b(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_bd6ab23d(arg0, arg1)
		return
	end
end

return helper_aad5ded3
