--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1a0fe848 = require("@lib/event/helper_1a0fe848")
local helper_28c2e3e3 = require("@lib/event/helper_28c2e3e3")
local helper_50fb1625 = require("@lib/event/helper_50fb1625")
local helper_d99e8cf9 = require("@lib/event/helper_d99e8cf9")
local helper_f17fdf71 = require("@lib/event/helper_f17fdf71")

--- Helper function.
local function helper_d9638962(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_f17fdf71(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_50fb1625(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1a0fe848(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_28c2e3e3(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_d99e8cf9(arg0, arg1)
		return
	end
end

return helper_d9638962
