--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_b63ef9c0(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Je n'aime pas trop voir les femmes\nmanier des [UNI00e9]p[UNI00e9]es. Pour moi, une<page>femme doit [UNI00ea]tre plus f[UNI00e9]minine.\nComme Ad[UNI00e8]le, par exemple."
		)
	else
		event.MesMake_2(0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_b63ef9c0
