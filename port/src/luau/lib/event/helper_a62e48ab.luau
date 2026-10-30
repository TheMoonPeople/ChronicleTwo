--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_903447e1 = require("@lib/event/helper_903447e1")
local helper_a8a89d7c = require("@lib/event/helper_a8a89d7c")
local helper_b79e9704 = require("@lib/event/helper_b79e9704")
local helper_e3a73191 = require("@lib/event/helper_e3a73191")
local helper_e97ba8b3 = require("@lib/event/helper_e97ba8b3")

--- Helper function.
local function helper_a62e48ab(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_a8a89d7c(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_903447e1(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 8) or var3
	if var3 == 0 then
		helper_e97ba8b3(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_e3a73191(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_b79e9704(arg0, arg1)
		return
	end
end

return helper_a62e48ab
