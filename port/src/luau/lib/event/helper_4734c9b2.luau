--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_acde31fa = require("@lib/event/helper_acde31fa")

--- Helper function.
local function helper_4734c9b2(arg0: s32)
	event.set_dungeon_pause_flags(8192, arg0)
	helper_acde31fa(if arg0 == 0 then 1 else 0)
	if arg0 == 0 then
		event.reset_action_character_motion(0, 4)
	end
	event.set_character_change_unmasked(2, if arg0 == 0 then 1 else 0)
	event.set_character_change_unmasked(3, if arg0 == 0 then 1 else 0)
	event.set_save_control_bits(1, arg0)
end

return helper_4734c9b2
