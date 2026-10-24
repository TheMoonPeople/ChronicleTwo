--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_5f9540e0 = require("@lib/event/helper_5f9540e0")
local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_edba2b47(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_5f9540e0(arg0, arg1)
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(0, "Incredibile! Non pensavo che\nsaresti riuscito a trovarle.<page>Niente male, Max!")
	else
		event.MesMake_2(
			0,
			"Ehi! Come procede la ricerca di\nZelmite? Se c'[UNI00e8] qualcosa che\nposso fare, fammi un fischio."
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_edba2b47
