--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_c5602593 = require("@lib/event/helper_c5602593")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_629cad03(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = helper_c5602593()
	if 0 < var2 then
		event.open_message_window_2(0, "It seems like you're not\nquite good enough yet.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"I have high hopes for you in the future,\nbut I'm afraid I can't cooperate\nwith you at the moment."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"You've done well.\nWonderful.<page>I'm sure you'll live\nup to my expectations.<page>I promised, didn't I?\nI'll go with you."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

return helper_629cad03
