--!strict
-- Shared event helper used by 100 scripts, translated by tools/luau/stb2luau.

local helper_ab0a8186 = require("@lib/event/helper_ab0a8186")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_899661d6(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	var4 = helper_c8484b43(arg0, arg2, arg3)
	player_chara = event.GetControlChrid() or player_chara
	helper_b5a98ffa(0, arg1, arg0, player_chara, 0)
	helper_ab0a8186(arg0, var4, arg2, arg3)
end

return helper_899661d6
