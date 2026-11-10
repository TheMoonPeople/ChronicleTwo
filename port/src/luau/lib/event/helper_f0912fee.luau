--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_f0912fee(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(0, "Je t'en prie, arr[UNI00ea]te de mettre Max\ndans des situations dangereuses.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "S'il a ne serait-ce qu'une\n[UNI00e9]gratignure, jamais je ne te\nle pardonnerai !")
	else
		event.open_message_window_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_f0912fee
