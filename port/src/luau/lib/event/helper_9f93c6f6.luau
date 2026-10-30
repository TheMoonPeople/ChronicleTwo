--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_605fcf62 = require("@lib/event/helper_605fcf62")
local helper_ae98fc59 = require("@lib/event/helper_ae98fc59")
local helper_aef410c0 = require("@lib/event/helper_aef410c0")
local helper_ba47323d = require("@lib/event/helper_ba47323d")
local helper_fc01e6c8 = require("@lib/event/helper_fc01e6c8")

--- Helper function.
local function helper_9f93c6f6(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_aef410c0(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_605fcf62(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 3) or var3
	if var3 == 0 then
		helper_ae98fc59(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_fc01e6c8(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_ba47323d(arg0, arg1)
		return
	end
end

return helper_9f93c6f6
