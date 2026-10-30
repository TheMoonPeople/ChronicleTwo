--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0054e98d = require("@lib/event/helper_0054e98d")
local helper_4076b655 = require("@lib/event/helper_4076b655")
local helper_b4ff0625 = require("@lib/event/helper_b4ff0625")
local helper_be247bf9 = require("@lib/event/helper_be247bf9")
local helper_c79026b6 = require("@lib/event/helper_c79026b6")
local helper_cd8697c1 = require("@lib/event/helper_cd8697c1")
local helper_f3cbc5b6 = require("@lib/event/helper_f3cbc5b6")

--- Helper function.
local function helper_a4d8dd70(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_0054e98d(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_c79026b6(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 7) or var3
	if var3 == 0 then
		helper_4076b655(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.get_save_counter(8) or var4
		if var4 == 0 then
			helper_cd8697c1(arg0, arg1)
		end
		if var4 == 1 then
			helper_b4ff0625(arg0, arg1)
		end
		if var4 == 2 then
			helper_f3cbc5b6(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_be247bf9(arg0, arg1)
		return
	end
end

return helper_a4d8dd70
