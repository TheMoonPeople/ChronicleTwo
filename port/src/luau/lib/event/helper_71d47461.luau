--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_251c0be5 = require("@lib/event/helper_251c0be5")
local helper_3655639b = require("@lib/event/helper_3655639b")
local helper_407d0935 = require("@lib/event/helper_407d0935")
local helper_777935d5 = require("@lib/event/helper_777935d5")
local helper_a093ba27 = require("@lib/event/helper_a093ba27")

--- Helper function.
local function helper_71d47461(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_777935d5(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 ~= 2 then
		helper_3655639b(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 6) or var3
	if var3 == 0 then
		helper_a093ba27(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_407d0935(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_251c0be5(arg0, arg1)
		return
	end
end

return helper_71d47461
