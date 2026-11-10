--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_b7906db0 = require("@lib/event/helper_b7906db0")

--- Helper function.
local function helper_c248f8d5(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		helper_b7906db0(arg0, arg1)
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Has estado fuera [UNI00fa]ltimamente,\n[UNI00bf]no, Max?<page>No lo niegues.\nLo s[UNI00e9] de buena tinta."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_c248f8d5
