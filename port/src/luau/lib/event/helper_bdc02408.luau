--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_27594e2f = require("@lib/event/helper_27594e2f")
local helper_84a40175 = require("@lib/event/helper_84a40175")
local helper_dc0e7531 = require("@lib/event/helper_dc0e7531")
local helper_e5e89598 = require("@lib/event/helper_e5e89598")
local helper_f5cace86 = require("@lib/event/helper_f5cace86")

--- Helper function.
local function helper_bdc02408(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_84a40175(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_e5e89598(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 11) or var3
	if var3 == 0 then
		helper_f5cace86(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_dc0e7531(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_27594e2f(arg0, arg1)
		return
	end
end

return helper_bdc02408
