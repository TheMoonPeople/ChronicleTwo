--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_236ae00f = require("@lib/event/helper_236ae00f")
local helper_72dc8676 = require("@lib/event/helper_72dc8676")
local helper_959aefb6 = require("@lib/event/helper_959aefb6")
local helper_b626d834 = require("@lib/event/helper_b626d834")
local helper_f26e00d2 = require("@lib/event/helper_f26e00d2")

--- Helper function.
local function helper_8c6d5cd5(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_72dc8676(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_236ae00f(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 6) or var3
	if var3 == 0 then
		helper_b626d834(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_f26e00d2(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_959aefb6(arg0, arg1)
		return
	end
end

return helper_8c6d5cd5
