--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_21912dd8(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Je ne suis pas tr[UNI00e8]s en forme.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Le Dr Dell est venu me voir\nmais selon lui tout va bien.<page>Je me demande ce que j'ai ?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_21912dd8
