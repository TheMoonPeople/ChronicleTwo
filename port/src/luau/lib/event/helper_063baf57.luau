--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c5602593 = require("@lib/event/helper_c5602593")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_063baf57(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = helper_c5602593()
	if 0 < var2 then
		event.open_message_window_2(0, "Sembra che tu non sia\nancora abbastanza bravo.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Nutro molte speranze per te nel\nfuturo, ma al momento, purtroppo,\nnon posso aiutarti.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Ben fatto.\nMagnifico.<page>Sono certo che\nnon mi deluderai.<page>Te lo avevo promesso, no?\nVerr[UNI00f2] con te."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

return helper_063baf57
