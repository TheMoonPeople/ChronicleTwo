--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_25d87b9c = require("@lib/event/helper_25d87b9c")
local helper_4450f84b = require("@lib/event/helper_4450f84b")
local helper_52d5eea9 = require("@lib/event/helper_52d5eea9")
local helper_696154d3 = require("@lib/event/helper_696154d3")
local helper_83ddcd67 = require("@lib/event/helper_83ddcd67")

--- Helper function.
local function helper_371a0749(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		helper_83ddcd67(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_4450f84b(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 10) or var3
	if var3 == 0 then
		helper_696154d3(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_25d87b9c(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_52d5eea9(arg0, arg1)
		return
	end
end

return helper_371a0749
