--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0414c057 = require("@lib/event/helper_0414c057")
local helper_1e730230 = require("@lib/event/helper_1e730230")
local helper_21a4b0ab = require("@lib/event/helper_21a4b0ab")
local helper_2f98b1e7 = require("@lib/event/helper_2f98b1e7")
local helper_6052c7b4 = require("@lib/event/helper_6052c7b4")

--- Helper function.
local function helper_e37775c1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1e730230(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_21a4b0ab(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_2f98b1e7(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_6052c7b4(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_0414c057(arg0, arg1)
		return
	end
end

return helper_e37775c1
