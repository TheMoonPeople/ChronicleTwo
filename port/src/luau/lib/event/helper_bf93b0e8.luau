--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_13d40adf = require("@lib/event/helper_13d40adf")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_bf93b0e8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			helper_13d40adf(arg0, arg1)
			return
		end
		event.apply_message_window_preset(0, 0)
		event.open_message_window_2(0, "Incredibile! Non pensavo che\nsaresti riuscito a trovarle.<page>Niente male, Max!")
	else
		event.open_message_window_2(
			0,
			"Ehi! Come procede la ricerca di\nZelmite? Se c'[UNI00e8] qualcosa che\nposso fare, fammi un fischio."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_bf93b0e8
