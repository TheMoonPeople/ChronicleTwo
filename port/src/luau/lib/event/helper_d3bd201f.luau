--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_d3bd201f(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"[UNI00c4]hm, es muss ja nicht jetzt sein,\naber vielleicht verr[UNI00e4]tst du mir\neines Tages deine Angel-Tricks."
		)
	else
		event.open_message_window_2(
			0,
			"Ich bin schon ganz gespannt auf\ndie neuen Angelpl[UNI00e4]tze in der\nganzen Welt. Das wird so toll!"
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_d3bd201f
