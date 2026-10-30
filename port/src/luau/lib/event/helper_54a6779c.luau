--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_072c26ee = require("@lib/event/helper_072c26ee")
local helper_07c3f444 = require("@lib/event/helper_07c3f444")
local helper_23e805af = require("@lib/event/helper_23e805af")
local helper_2afd7236 = require("@lib/event/helper_2afd7236")
local helper_3e95d96e = require("@lib/event/helper_3e95d96e")
local helper_d76e7d26 = require("@lib/event/helper_d76e7d26")
local helper_e9e764a3 = require("@lib/event/helper_e9e764a3")

--- Helper function.
local function helper_54a6779c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_07c3f444(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_d76e7d26(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 7) or var3
	if var3 == 0 then
		helper_2afd7236(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.get_save_counter(8) or var4
		if var4 == 0 then
			helper_e9e764a3(arg0, arg1)
		end
		if var4 == 1 then
			helper_072c26ee(arg0, arg1)
		end
		if var4 == 2 then
			helper_23e805af(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_3e95d96e(arg0, arg1)
		return
	end
end

return helper_54a6779c
