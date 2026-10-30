--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_114f223a = require("@lib/event/helper_114f223a")
local helper_7fe034b9 = require("@lib/event/helper_7fe034b9")
local helper_8394a369 = require("@lib/event/helper_8394a369")
local helper_9286486e = require("@lib/event/helper_9286486e")
local helper_de7cafb9 = require("@lib/event/helper_de7cafb9")

--- Helper function.
local function helper_257748e5(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		helper_114f223a(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_7fe034b9(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 10) or var3
	if var3 == 0 then
		helper_de7cafb9(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_8394a369(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_9286486e(arg0, arg1)
		return
	end
end

return helper_257748e5
