--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_13f640f8 = require("@lib/event/helper_13f640f8")
local helper_27a942e9 = require("@lib/event/helper_27a942e9")
local helper_5f9c1e77 = require("@lib/event/helper_5f9c1e77")
local helper_78597c8d = require("@lib/event/helper_78597c8d")
local helper_95af68d6 = require("@lib/event/helper_95af68d6")

--- Helper function.
local function helper_d09a4ccd(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_27a942e9(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_78597c8d(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 3) or var3
	if var3 == 0 then
		helper_13f640f8(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_95af68d6(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_5f9c1e77(arg0, arg1)
		return
	end
end

return helper_d09a4ccd
