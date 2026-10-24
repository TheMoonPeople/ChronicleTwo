--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_f6c140b6(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Por favor, deja de meter\na Max en situaciones peligrosas.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Como le hagan un ara[UNI00f1]azo,\nno te perdonar[UNI00e9] nunca.")
	else
		event.MesMake_2(0, "Rezar[UNI00e9] por ti...")
	end
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_f6c140b6
