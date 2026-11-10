--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_f38eabca = require("@lib/event/helper_f38eabca")

--- Helper function.
local function helper_682fcdd4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Ah, Max ! J'ai enfin fini un\nv[UNI00ea]tement !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Je ne voulais pas que tes mat[UNI00e9]riaux\nsoient jet[UNI00e9]s, et c'est [UNI00e7]a qui\nm'a oblig[UNI00e9]e [UNI00e0] le terminer."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Je ne suis pas tr[UNI00e8]s satisfaite\nde cette tenue, mais... voudrais-tu\nla porter ?")
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
		"Ah, c'est vraiment super d'avoir\nenfin pu terminer quelque chose.<page>Je me sens beaucoup plus s[UNI00fb]re\nde moi, maintenant.<page>Je ferai de mon mieux, je\nt'en prie, emm[UNI00e8]ne-moi avec toi."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

return helper_682fcdd4
