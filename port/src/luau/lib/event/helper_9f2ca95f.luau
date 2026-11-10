--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_033d0952 = require("@lib/event/helper_033d0952")
local helper_a93539f2 = require("@lib/event/helper_a93539f2")
local helper_b9cc9d32 = require("@lib/event/helper_b9cc9d32")
local helper_bdc0da5e = require("@lib/event/helper_bdc0da5e")
local helper_dd040707 = require("@lib/event/helper_dd040707")

--- Helper function.
local function helper_9f2ca95f(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_bdc0da5e(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_b9cc9d32(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 6) or var3
	if var3 == 0 then
		helper_033d0952(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_dd040707(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a93539f2(arg0, arg1)
		return
	end
end

return helper_9f2ca95f
