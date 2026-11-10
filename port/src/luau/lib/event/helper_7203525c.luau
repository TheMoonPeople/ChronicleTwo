--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_69ae6360 = require("@lib/event/helper_69ae6360")
local helper_c2ea93a9 = require("@lib/event/helper_c2ea93a9")

--- Helper function.
local function helper_7203525c(arg0: s32, arg1: s32)
	local player_chara: s32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	helper_69ae6360(player_chara, arg0, arg1)
	event.start_crossfade(10)
	helper_c2ea93a9(0, arg1, arg0, player_chara, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
	event.start_crossfade(10)
end

return helper_7203525c
