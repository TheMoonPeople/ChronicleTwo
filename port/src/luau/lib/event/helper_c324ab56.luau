--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_e787350a = require("@lib/event/helper_e787350a")

--- Helper function.
local function helper_c324ab56(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Cedric sagt, du w[UNI00e4]rst in\nletzter Zeit viel\nunterwegs gewesen.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Du kannst vieles gut,<page>aber andererseits bringst du\nnie etwas zu Ende.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Deshalb f[UNI00e4]llt es mir schwer,\ndich einfach ernst zu nehmen,\nwenn du mich um Hilfe bittest."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Ich hab's - stufe dieses\nTrompeten-Gewehr zu einem\nKlingel-Abzug hoch!<page>Schaffst du das?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.add_inventory_item(24)
	helper_e787350a(24, 1)
	helper_a87eb945(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Damit Gerald dich akzeptiert,\n   musst du ihm einen\n   Klingel-Abzug bringen.<page>[(!)]Du kannst seine Waffe\n   hochstufen, eine andere kaufen\n   oder eine aus dem Verlies holen."
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

return helper_c324ab56
