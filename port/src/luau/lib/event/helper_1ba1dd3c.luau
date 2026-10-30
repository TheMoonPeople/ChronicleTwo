--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_1b274df3 = require("@lib/event/helper_1b274df3")
local helper_58050148 = require("@lib/event/helper_58050148")
local helper_760177da = require("@lib/event/helper_760177da")
local helper_a1ca3b2f = require("@lib/event/helper_a1ca3b2f")
local helper_c49bc7ef = require("@lib/event/helper_c49bc7ef")

--- Helper function.
local function helper_1ba1dd3c(arg0: s32, arg1: s32)
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
		helper_1b274df3(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_760177da(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a1ca3b2f(arg0, arg1)
		return
	end
end

return helper_1ba1dd3c
