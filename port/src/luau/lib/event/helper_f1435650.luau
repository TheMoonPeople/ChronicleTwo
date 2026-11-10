--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_2d30df68 = require("@lib/event/helper_2d30df68")
local helper_7316cce2 = require("@lib/event/helper_7316cce2")
local helper_98368c3e = require("@lib/event/helper_98368c3e")
local helper_a05339a0 = require("@lib/event/helper_a05339a0")
local helper_bd6df3f4 = require("@lib/event/helper_bd6df3f4")

--- Helper function.
local function helper_f1435650(arg0: s32, arg1: s32)
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
		helper_7316cce2(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_bd6df3f4(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_2d30df68(arg0, arg1)
		return
	end
end

return helper_f1435650
