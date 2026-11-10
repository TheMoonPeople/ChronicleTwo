--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_f38eabca = require("@lib/event/helper_f38eabca")

--- Helper function.
local function helper_bbe8bc96(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "[UNI00a1]Ah, Max! Ya he acabado una prenda.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"No quer[UNI00ed]a dejar\nque desecharan los materiales que me trajiste\ny gracias a eso llegu[UNI00e9] hasta el final."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "No me he quedado completamente satisfecha,\n[UNI00bf]pero te lo pondr[UNI00ed]as igualmente?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	var2 = 259
	argc = event.get_item_count(258) or argc
	if argc <= 0 then
		var2 = 258
	else
		argc = event.get_item_count(260) or argc
		if argc <= 0 then
			var2 = 260
		end
	end
	event.add_inventory_item(var2)
	helper_f38eabca(var2, 1)
	helper_a87eb945(1)
	event.open_message_window_2(
		0,
		"Ah, qu[UNI00e9] bien sienta\nterminar algo.<page>Ahora siento mucha\nm[UNI00e1]s confianza.<page>Har[UNI00e9] todo lo que pueda.\nLlevadme con vosotros."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

return helper_bbe8bc96
