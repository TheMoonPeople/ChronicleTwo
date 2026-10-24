--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_be04aa4a = require("@lib/event/helper_be04aa4a")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_dbfcf131(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_be04aa4a(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"You should know the answer to that:\nN-O W-A-Y!<page>Why should I have to work for the\nsake of other people?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "There's not much in it for me, and\nit's just too scary.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "As it's you, I suppose I could\nthink about it, though.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "But then, I am the son of a salesman\nand we don't do things for free.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"You probably know that I collect coins.<page>They're the symbol of business. I really\nwant to complete my collection."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"But I just can't seem to get\nmy hands on the Dark Coin\nand the Indestructible Coin.<page>If you can help me,\nmaybe I can help you."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

return helper_dbfcf131
