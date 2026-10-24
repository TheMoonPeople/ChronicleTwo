--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2c3e3cfd = require("@lib/event/helper_2c3e3cfd")
local helper_7f61e824 = require("@lib/event/helper_7f61e824")
local helper_aeacec7e = require("@lib/event/helper_aeacec7e")
local helper_b02b3614 = require("@lib/event/helper_b02b3614")
local helper_fd6b1ed5 = require("@lib/event/helper_fd6b1ed5")

--- Helper function.
local function helper_f7f87dc4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_2c3e3cfd(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_b02b3614(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_7f61e824(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_aeacec7e(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_fd6b1ed5(arg0, arg1)
		return
	end
end

return helper_f7f87dc4
