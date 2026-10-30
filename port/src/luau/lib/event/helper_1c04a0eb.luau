--!strict
-- Shared event helper used by 285 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_5d8e6e04 = require("@lib/event/helper_5d8e6e04")

--- Helper function.
local function helper_1c04a0eb(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	var4 = helper_4e93f9fc(arg0, arg2, arg3)
	player_chara = event.get_player_character_slot() or player_chara
	helper_0ffc2526(0, arg1, arg0, player_chara, 0)
	helper_5d8e6e04(arg0, var4, arg2, arg3)
end

return helper_1c04a0eb
