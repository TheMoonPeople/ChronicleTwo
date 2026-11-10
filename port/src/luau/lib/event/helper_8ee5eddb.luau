--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0c199839 = require("@lib/event/helper_0c199839")
local helper_3f0bab5f = require("@lib/event/helper_3f0bab5f")
local helper_77e68653 = require("@lib/event/helper_77e68653")
local helper_c2ec838a = require("@lib/event/helper_c2ec838a")
local helper_cdbc6007 = require("@lib/event/helper_cdbc6007")

--- Helper function.
local function helper_8ee5eddb(arg0: s32, arg1: s32)
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
		helper_cdbc6007(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_77e68653(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_c2ec838a(arg0, arg1)
		return
	end
end

return helper_8ee5eddb
