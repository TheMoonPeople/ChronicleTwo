--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_10182636 = require("@lib/event/helper_10182636")
local helper_20c4b829 = require("@lib/event/helper_20c4b829")
local helper_546b409a = require("@lib/event/helper_546b409a")
local helper_78b259cd = require("@lib/event/helper_78b259cd")
local helper_e0f20121 = require("@lib/event/helper_e0f20121")

--- Helper function.
local function helper_44214ec9(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_546b409a(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_20c4b829(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_10182636(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_78b259cd(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_e0f20121(arg0, arg1)
		return
	end
end

return helper_44214ec9
