--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0c199839 = require("@lib/event/helper_0c199839")
local helper_3f0bab5f = require("@lib/event/helper_3f0bab5f")
local helper_ac01a786 = require("@lib/event/helper_ac01a786")
local helper_c2ec838a = require("@lib/event/helper_c2ec838a")
local helper_c9dfbba0 = require("@lib/event/helper_c9dfbba0")

--- Helper function.
local function helper_8b4f00dd(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_0c199839(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_3f0bab5f(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 11) or var3
	if var3 == 0 then
		helper_c9dfbba0(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_ac01a786(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_c2ec838a(arg0, arg1)
		return
	end
end

return helper_8b4f00dd
