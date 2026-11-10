--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_58050148 = require("@lib/event/helper_58050148")
local helper_68a081db = require("@lib/event/helper_68a081db")
local helper_839276cb = require("@lib/event/helper_839276cb")
local helper_a1ca3b2f = require("@lib/event/helper_a1ca3b2f")
local helper_c49bc7ef = require("@lib/event/helper_c49bc7ef")

--- Helper function.
local function helper_1996828b(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_58050148(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_c49bc7ef(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 11) or var3
	if var3 == 0 then
		helper_839276cb(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_68a081db(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a1ca3b2f(arg0, arg1)
		return
	end
end

return helper_1996828b
