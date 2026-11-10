--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_75e5793b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Das Glitzern eines guten\nSchwertes ist einfach unvergleichlich.<page>Es raubt einem den Atem."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Ich verstehe nicht, wie man\nimmer nur Steine polieren kann.")
	else
		event.open_message_window_2(0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_75e5793b
