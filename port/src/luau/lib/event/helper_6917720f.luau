--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_53e50eb3 = require("@lib/event/helper_53e50eb3")
local helper_57adec08 = require("@lib/event/helper_57adec08")
local helper_75e5793b = require("@lib/event/helper_75e5793b")
local helper_9e02ea7e = require("@lib/event/helper_9e02ea7e")
local helper_c107723d = require("@lib/event/helper_c107723d")

--- Helper function.
local function helper_6917720f(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		helper_53e50eb3(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_9e02ea7e(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 10) or var3
	if var3 == 0 then
		helper_57adec08(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_c107723d(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_75e5793b(arg0, arg1)
		return
	end
end

return helper_6917720f
