--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_4f6042d7(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"T[UNI00fa] eres la chica que\nha estado con Max [UNI00fa]ltimamente.<page>Reconozco a un buen hombre\ncuando lo veo."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Si fuera un poco m[UNI00e1]s joven,\nno lo dejar[UNI00ed]a escapar.")
	else
		event.MesMake_2(0, "Cuando te apetezca\npan, ya sabes d[UNI00f3]nde encontrarme.")
	end
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_4f6042d7
