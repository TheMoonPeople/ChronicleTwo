--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0acb43ef = require("@lib/event/helper_0acb43ef")
local helper_0e388785 = require("@lib/event/helper_0e388785")
local helper_3e157d82 = require("@lib/event/helper_3e157d82")
local helper_637c7446 = require("@lib/event/helper_637c7446")
local helper_bab85459 = require("@lib/event/helper_bab85459")

--- Helper function.
local function helper_8fe4e906(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_bab85459(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_0acb43ef(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_3e157d82(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_0e388785(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_637c7446(arg0, arg1)
		return
	end
end

return helper_8fe4e906
