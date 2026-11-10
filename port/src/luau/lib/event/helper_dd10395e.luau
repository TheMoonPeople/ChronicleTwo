--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_7dd89eee = require("@lib/event/helper_7dd89eee")
local helper_9386e238 = require("@lib/event/helper_9386e238")
local helper_bbe8bc96 = require("@lib/event/helper_bbe8bc96")
local helper_c2fe6f84 = require("@lib/event/helper_c2fe6f84")
local helper_dce2dfeb = require("@lib/event/helper_dce2dfeb")
local helper_ec0f0f43 = require("@lib/event/helper_ec0f0f43")
local helper_f419f202 = require("@lib/event/helper_f419f202")

--- Helper function.
local function helper_dd10395e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_c2fe6f84(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_ec0f0f43(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 7) or var3
	if var3 == 0 then
		helper_dce2dfeb(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.get_save_counter(8) or var4
		if var4 == 0 then
			helper_9386e238(arg0, arg1)
		end
		if var4 == 1 then
			helper_f419f202(arg0, arg1)
		end
		if var4 == 2 then
			helper_bbe8bc96(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_7dd89eee(arg0, arg1)
		return
	end
end

return helper_dd10395e
