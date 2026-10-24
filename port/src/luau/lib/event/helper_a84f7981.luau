--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_a49f11be = require("@lib/event/helper_a49f11be")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")

--- Helper function.
local function helper_a84f7981(arg0: s32)
	local player_chara: s32 = 0
	player_chara = event.GetControlChrid() or player_chara
	helper_a49f11be(player_chara, arg0)
	helper_b5a98ffa(0, -1, arg0, player_chara, 0)
end

return helper_a84f7981
