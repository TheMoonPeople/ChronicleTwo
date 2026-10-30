--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_3300e99f = require("@lib/event/helper_3300e99f")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_47990fb3(arg0: f32, arg1: s32)
	local var2: s32 = 0
	helper_3300e99f(arg0)
	event.set_character_motion(0, "立ち")
	var2 = event.get_sound_id(2) or var2
	if arg1 ~= 0 then
		event.play_sound_effect(var2, 92)
	else
		event.play_sound_effect(var2, 94)
	end
	event.fade_out_screen(30)
	helper_888ab2a3(30)
end

return helper_47990fb3
