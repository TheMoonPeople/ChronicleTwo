--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0b8dabb0 = require("@lib/event/helper_0b8dabb0")
local helper_10779a34 = require("@lib/event/helper_10779a34")
local helper_236ae00f = require("@lib/event/helper_236ae00f")
local helper_72dc8676 = require("@lib/event/helper_72dc8676")
local helper_959aefb6 = require("@lib/event/helper_959aefb6")

--- Helper function.
local function helper_5bceac67(arg0: s32, arg1: s32)
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
		helper_10779a34(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_0b8dabb0(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_959aefb6(arg0, arg1)
		return
	end
end

return helper_5bceac67
