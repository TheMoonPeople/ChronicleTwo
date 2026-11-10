--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_432717ea(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Ich hoffe, dass ich auch einmal\nauf dem Siegertreppchen stehen werde.")
	else
		event.open_message_window_2(
			0,
			"Ich w[UNI00fc]nschte nur, Fabio w[UNI00fc]rde\nsich auch f[UNI00fc]r andere Dinge\nals Angeln interessieren."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_432717ea
