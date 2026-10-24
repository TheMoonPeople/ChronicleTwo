--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")

--- Helper function.
local function helper_c4be310b(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "Mmh, questo albero... Non sembra\nstia bene. Devo fare qualcosa.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	else
		event.MesMake_2(
			0,
			"Oh, Max! Mi hai messo paura.\nStavo levando dei fastidiosi\nparassiti da quest'albero.<page>Non tutti gli alberi crescono bene\nda soli, sai. Alcuni, come questo,\nhanno bisogno di molte cure."
		)
		helper_899661d6(arg0, -1, 0, 0)
	end
end

return helper_c4be310b
