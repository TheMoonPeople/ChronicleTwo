--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_36542265 = require("@lib/event/helper_36542265")
local helper_36c653b2 = require("@lib/event/helper_36c653b2")
local helper_a7f6c3e7 = require("@lib/event/helper_a7f6c3e7")
local helper_c701e5d2 = require("@lib/event/helper_c701e5d2")
local helper_e52c0bd6 = require("@lib/event/helper_e52c0bd6")

--- Helper function.
local function helper_186ac573(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_e52c0bd6(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_c701e5d2(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 6) or var3
	if var3 == 0 then
		helper_36542265(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_a7f6c3e7(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_36c653b2(arg0, arg1)
		return
	end
end

return helper_186ac573
