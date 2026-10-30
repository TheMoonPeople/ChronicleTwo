--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_114f223a = require("@lib/event/helper_114f223a")
local helper_37eaa981 = require("@lib/event/helper_37eaa981")
local helper_7fe034b9 = require("@lib/event/helper_7fe034b9")
local helper_9286486e = require("@lib/event/helper_9286486e")
local helper_f3736ad5 = require("@lib/event/helper_f3736ad5")

--- Helper function.
local function helper_35ac2bde(arg0: s32, arg1: s32)
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
		helper_f3736ad5(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_37eaa981(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_9286486e(arg0, arg1)
		return
	end
end

return helper_35ac2bde
