--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_170466f3 = require("@lib/event/helper_170466f3")
local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_f8dd777b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_170466f3(arg0, arg1)
			return
		end
		event.MesMake_2(0, "Pero no me lleves\na ning[UNI00fa]n sitio demasiado peligroso.")
	else
		event.MesMake_2(
			0,
			"Por fin, el Ferrocarril\nBlackstone conquista el mundo.\n[UNI00a1]Qu[UNI00e9] emoci[UNI00f3]n!"
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_f8dd777b
