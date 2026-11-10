--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_129a468b = require("@lib/event/helper_129a468b")
local helper_276a1238 = require("@lib/event/helper_276a1238")
local helper_9132abc4 = require("@lib/event/helper_9132abc4")
local helper_a8f2da43 = require("@lib/event/helper_a8f2da43")
local helper_d84fc440 = require("@lib/event/helper_d84fc440")

--- Helper function.
local function helper_71eeeebd(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_d84fc440(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_129a468b(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 8) or var3
	if var3 == 0 then
		helper_a8f2da43(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_9132abc4(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_276a1238(arg0, arg1)
		return
	end
end

return helper_71eeeebd
