--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_b1ea42e8 = require("@lib/event/helper_b1ea42e8")

--- Helper function.
local function helper_58c088e0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_b1ea42e8(arg0, arg1)
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"Je n'y crois pas. Je n'ai jamais\nvraiment cru que tu les trouverais.<page>T'as fait tr[UNI00e8]s fort Max !"
		)
	else
		event.MesMake_2(
			0,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_58c088e0
