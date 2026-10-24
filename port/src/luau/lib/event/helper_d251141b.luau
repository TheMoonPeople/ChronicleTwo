--!strict
-- Shared event helper used by 100 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_fb2b6b13 = require("@lib/event/helper_fb2b6b13")

--- Helper function.
local function helper_d251141b(arg0: s32)
	local player_chara: s32 = 0
	player_chara = event.GetControlChrid() or player_chara
	helper_fb2b6b13(player_chara, arg0)
	helper_b5a98ffa(0, -1, arg0, player_chara, 0)
end

return helper_d251141b
