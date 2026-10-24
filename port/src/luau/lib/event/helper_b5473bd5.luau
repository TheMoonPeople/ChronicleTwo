--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_b5473bd5(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, hello, young lady.\nSomething I can do for you?")
		else
			event.MesMake_2(0, "Max, don't mention that Holy Water\nto your father, you hear?")
		end
	else
		event.MesMake_2(0, "There must be so many plants out\nthere we haven't even seen yet.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_b5473bd5
