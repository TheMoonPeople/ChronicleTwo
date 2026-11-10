--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_c5602593 = require("@lib/event/helper_c5602593")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_60cf1b32(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = helper_c5602593()
	if 0 < var2 then
		event.open_message_window_2(0, "Al parecer, todav[UNI00ed]a\nte queda mucho por aprender.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Tengo depositada una gran confianza en ti,\npero me temo que por el momento\nno podr[UNI00e9] ayudarte."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Muy bien hecho.\nEspl[UNI00e9]ndido.<page>Estoy convencido de que cumplir[UNI00e1]s con creces mis expectativas.<page>[UNI00bf]Lo he prometido, no?\nTe acompa[UNI00f1]ar[UNI00e9]."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

return helper_60cf1b32
