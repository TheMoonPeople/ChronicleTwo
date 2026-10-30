--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ebc6aaa = require("@lib/event/helper_0ebc6aaa")
local helper_133507f1 = require("@lib/event/helper_133507f1")
local helper_2131a017 = require("@lib/event/helper_2131a017")
local helper_22f8f92e = require("@lib/event/helper_22f8f92e")
local helper_46460742 = require("@lib/event/helper_46460742")

--- Helper function.
local function helper_24e7ae04(arg0: s32, arg1: s32)
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
		helper_46460742(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_22f8f92e(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_2131a017(arg0, arg1)
		return
	end
end

return helper_24e7ae04
