--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_15a900fb = require("@lib/event/helper_15a900fb")
local helper_2092ed65 = require("@lib/event/helper_2092ed65")
local helper_2332adc1 = require("@lib/event/helper_2332adc1")
local helper_355efb9d = require("@lib/event/helper_355efb9d")
local helper_38675376 = require("@lib/event/helper_38675376")
local helper_56c2ebd9 = require("@lib/event/helper_56c2ebd9")
local helper_b2db4ae6 = require("@lib/event/helper_b2db4ae6")

--- Helper function.
local function helper_3cd4938c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_2092ed65(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_2332adc1(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 7) or var3
	if var3 == 0 then
		helper_56c2ebd9(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.get_save_counter(8) or var4
		if var4 == 0 then
			helper_15a900fb(arg0, arg1)
		end
		if var4 == 1 then
			helper_b2db4ae6(arg0, arg1)
		end
		if var4 == 2 then
			helper_38675376(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_355efb9d(arg0, arg1)
		return
	end
end

return helper_3cd4938c
