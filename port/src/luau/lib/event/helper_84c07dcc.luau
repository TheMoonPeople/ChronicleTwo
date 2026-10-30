--!strict
-- Shared event helper used by 126 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_fb2b6b13 = require("@lib/event/helper_fb2b6b13")

--- Helper function.
local function helper_84c07dcc(arg0: s32)
	local player_chara: s32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	helper_fb2b6b13(player_chara, arg0)
	helper_0ffc2526(0, -1, arg0, player_chara, 0)
end

return helper_84c07dcc
