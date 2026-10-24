--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_8fd3f088 = require("@lib/event/helper_8fd3f088")

--- Helper function.
local function helper_2f61e008(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_8fd3f088(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "You've been going out of town recently,\nright Max?<page>Don't deny it.\nI know you have.")
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_2f61e008
