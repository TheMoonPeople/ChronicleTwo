--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_27254766 = require("@lib/event/helper_27254766")
local helper_444b30a8 = require("@lib/event/helper_444b30a8")
local helper_7d3112e4 = require("@lib/event/helper_7d3112e4")
local helper_86b06d47 = require("@lib/event/helper_86b06d47")
local helper_b7df95c6 = require("@lib/event/helper_b7df95c6")

--- Helper function.
local function helper_2c2672e0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_86b06d47(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_7d3112e4(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_444b30a8(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_27254766(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_b7df95c6(arg0, arg1)
		return
	end
end

return helper_2c2672e0
