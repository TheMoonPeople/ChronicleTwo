--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_54d786a9 = require("@lib/event/helper_54d786a9")
local helper_6d847ccf = require("@lib/event/helper_6d847ccf")
local helper_71748a06 = require("@lib/event/helper_71748a06")
local helper_7d58295b = require("@lib/event/helper_7d58295b")
local helper_b9d79bb3 = require("@lib/event/helper_b9d79bb3")

--- Helper function.
local function helper_f414648d(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_b9d79bb3(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_71748a06(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_6d847ccf(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_7d58295b(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_54d786a9(arg0, arg1)
		return
	end
end

return helper_f414648d
