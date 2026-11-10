--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_cedb80c8 = require("@lib/event/helper_cedb80c8")

--- Helper function.
local function helper_cb6c89f2(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Ehi Max, sei venuto a cercare me?<page>Ti stavo aspettando.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Grazie alle mura del castello,\nquesta citt[UNI00e0] [UNI00e8] abbastanza sicura.<page>[UNI00c8] giunto il momento di uscire."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] un bene che tu stia sempre\nad armeggiare con le macchine,\nma mi chiedo quanto forte tu sia."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Combattere significa velocit[UNI00e0]\ne lavoro di gambe.<page>Se sei pi[UNI00f9] lento di me,\nnon va affatto bene."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Facciamo una prova! Corri alla\nbarca sul lago e torna indietro.<page>Il mio record [UNI00e8] 2 minuti e\n1 secondo. Se non lo superi,\nnon va affatto bene."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "Che ne dici, vuoi provare?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	helper_cedb80c8(arg0, arg1)
end

return helper_cb6c89f2
