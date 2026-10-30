--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_2199c477 = require("@lib/event/helper_2199c477")
local helper_6fccaf02 = require("@lib/event/helper_6fccaf02")
local helper_7f242906 = require("@lib/event/helper_7f242906")
local helper_b11b51cc = require("@lib/event/helper_b11b51cc")
local helper_fcf07cd4 = require("@lib/event/helper_fcf07cd4")

--- Helper function.
local function helper_081a0c09(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_fcf07cd4(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_b11b51cc(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 8) or var3
	if var3 == 0 then
		helper_6fccaf02(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_7f242906(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_2199c477(arg0, arg1)
		return
	end
end

return helper_081a0c09
