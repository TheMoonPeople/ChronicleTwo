--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_aca13662(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		event.set_character_motion(arg1, "立ち")
		event.open_message_window_2(0, "Mmh, questo albero... Non sembra\nstia bene. Devo fare qualcosa.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
	else
		event.open_message_window_2(
			0,
			"Oh, Max! Mi hai messo paura.\nStavo levando dei fastidiosi\nparassiti da quest'albero.<page>Non tutti gli alberi crescono bene\nda soli, sai. Alcuni, come questo,\nhanno bisogno di molte cure."
		)
		helper_70e4ac93(arg0, -1, 0, 0)
	end
end

return helper_aca13662
