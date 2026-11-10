--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_774c1bc0 = require("@lib/event/helper_774c1bc0")
local helper_a93539f2 = require("@lib/event/helper_a93539f2")
local helper_b9cc9d32 = require("@lib/event/helper_b9cc9d32")
local helper_bdc0da5e = require("@lib/event/helper_bdc0da5e")
local helper_f37acc37 = require("@lib/event/helper_f37acc37")

--- Helper function.
local function helper_11b3915e(arg0: s32, arg1: s32)
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
		helper_f37acc37(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_774c1bc0(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a93539f2(arg0, arg1)
		return
	end
end

return helper_11b3915e
