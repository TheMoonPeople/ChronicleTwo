--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_f0db3082(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Je t'en prie, arr[UNI00ea]te de mettre Max\ndans des situations dangereuses.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "S'il a ne serait-ce qu'une\n[UNI00e9]gratignure, jamais je ne te\nle pardonnerai !")
	else
		event.MesMake_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_f0db3082
