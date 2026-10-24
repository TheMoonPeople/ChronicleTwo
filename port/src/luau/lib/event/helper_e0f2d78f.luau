--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_907c711b = require("@lib/event/helper_907c711b")

--- Helper function.
local function helper_e0f2d78f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_907c711b(arg0, arg1)
			return
		end
		event.MesMake_2(0, "[UNI00c9]vite les endroits\ntrop dangereux.")
	else
		event.MesMake_2(
			0,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_e0f2d78f
