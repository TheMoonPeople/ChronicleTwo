--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_98368c3e(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Quiz[UNI00e1] s[UNI00f3]lo me pase a m[UNI00ed], pero hay\nalgo en ti que me recuerda a Elena.<page>No s[UNI00e9] qu[UNI00e9] es, pero tienes cierta cualidad\ndistinta al resto de los habitantes de la ciudad."
		)
	else
		event.open_message_window_2(
			0,
			"La Mina de Zelmite es un lugar terror[UNI00ed]fico.\nNo se puede bajar\nla guardia ni un momento."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_98368c3e
