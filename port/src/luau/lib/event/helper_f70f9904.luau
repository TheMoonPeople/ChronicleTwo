--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_92fabf19 = require("@lib/event/helper_92fabf19")
local helper_b777beee = require("@lib/event/helper_b777beee")
local helper_b900368e = require("@lib/event/helper_b900368e")
local helper_d527d2a9 = require("@lib/event/helper_d527d2a9")
local helper_e85f518b = require("@lib/event/helper_e85f518b")

--- Helper function.
local function helper_f70f9904(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_d527d2a9(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_e85f518b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_b777beee(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_92fabf19(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_b900368e(arg0, arg1)
		return
	end
end

return helper_f70f9904
