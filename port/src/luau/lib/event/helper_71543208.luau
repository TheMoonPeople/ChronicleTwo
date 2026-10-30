--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_3f04d97c = require("@lib/event/helper_3f04d97c")
local helper_6b3529e5 = require("@lib/event/helper_6b3529e5")
local helper_860bdec4 = require("@lib/event/helper_860bdec4")
local helper_fc268ead = require("@lib/event/helper_fc268ead")
local helper_ffdff728 = require("@lib/event/helper_ffdff728")

--- Helper function.
local function helper_71543208(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_860bdec4(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_6b3529e5(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 6) or var3
	if var3 == 0 then
		helper_ffdff728(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_3f04d97c(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_fc268ead(arg0, arg1)
		return
	end
end

return helper_71543208
