--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ebc6aaa = require("@lib/event/helper_0ebc6aaa")
local helper_133507f1 = require("@lib/event/helper_133507f1")
local helper_2131a017 = require("@lib/event/helper_2131a017")
local helper_83e15068 = require("@lib/event/helper_83e15068")
local helper_cfe7ac7d = require("@lib/event/helper_cfe7ac7d")

--- Helper function.
local function helper_8a34efb6(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_133507f1(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_0ebc6aaa(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 11) or var3
	if var3 == 0 then
		helper_83e15068(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_cfe7ac7d(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_2131a017(arg0, arg1)
		return
	end
end

return helper_8a34efb6
