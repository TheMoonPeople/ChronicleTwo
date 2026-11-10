--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0771a536 = require("@lib/event/helper_0771a536")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_5e380014(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_0771a536(arg0, arg1)
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Sei stato fuori citt[UNI00e0] ultimamente,\nvero Max?<page>Non negarlo.\nSo che [UNI00e8] cos[UNI00ec]!"
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_5e380014
