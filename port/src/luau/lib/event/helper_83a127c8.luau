--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_83a127c8(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Wirklich? Ich soll dir helfen?<page>Dann l[UNI00f6]se mein R[UNI00e4]tsel.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Die Kerzen dieser Kirche werden \nvon einem Mechanismus gesteuert.<page>Sind sie an, so l[UNI00f6]scht er sie,\nwenn sie aus sind, entz[UNI00fc]ndet er sie.<page>Wenn sich eine Kerze [UNI00e4]ndert,\n[UNI00e4]ndern sich ihre Nachbarn mit."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Wenn du alle Kerzen l[UNI00f6]schst,\nbeweist das deine Weisheit.\nDann komme ich mit.<page>Wenn du es l[UNI00f6]st, prima! Wenn nicht,\nmusst du verstehen, dass ich\ndir nicht helfen kann."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Noch etwas Kniffliges. Versuch's\n   ein paar Mal, und merke dir,\n   was du dabei lernst."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Wenn du wieder in die Kirche\n   kommst, sind die Kerzen wieder normal.\n   Keine Angst vor Fehlversuchen!\n   Es k[UNI00f6]nnte ganz leicht sein."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

return helper_83a127c8
