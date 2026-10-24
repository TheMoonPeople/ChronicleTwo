--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_3eb3c053 = require("@lib/event/helper_3eb3c053")
local helper_46b521c7 = require("@lib/event/helper_46b521c7")
local helper_54d786a9 = require("@lib/event/helper_54d786a9")
local helper_71748a06 = require("@lib/event/helper_71748a06")
local helper_b9d79bb3 = require("@lib/event/helper_b9d79bb3")

--- Helper function.
local function helper_a6f301bd(arg0: s32, arg1: s32)
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
		helper_3eb3c053(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_46b521c7(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_54d786a9(arg0, arg1)
		return
	end
end

return helper_a6f301bd
