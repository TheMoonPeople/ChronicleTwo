--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_18e6cc41 = require("@lib/event/helper_18e6cc41")
local helper_2d30df68 = require("@lib/event/helper_2d30df68")
local helper_6c0fb2da = require("@lib/event/helper_6c0fb2da")
local helper_98368c3e = require("@lib/event/helper_98368c3e")
local helper_a05339a0 = require("@lib/event/helper_a05339a0")

--- Helper function.
local function helper_3b324a9f(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_98368c3e(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_a05339a0(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 6) or var3
	if var3 == 0 then
		helper_6c0fb2da(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_18e6cc41(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_2d30df68(arg0, arg1)
		return
	end
end

return helper_3b324a9f
