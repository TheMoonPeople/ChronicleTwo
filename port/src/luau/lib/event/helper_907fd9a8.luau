--!strict
-- Shared event helper used by 141 scripts, translated by tools/luau/stb2luau.

local helper_39031c12 = require("@lib/event/helper_39031c12")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_d25c550f = require("@lib/event/helper_d25c550f")

--- Helper function.
local function helper_907fd9a8(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	var4 = helper_d25c550f(arg0, arg2, arg3)
	player_chara = event.GetControlChrid() or player_chara
	helper_b5a98ffa(0, arg1, arg0, player_chara, 0)
	helper_39031c12(arg0, var4, arg2, arg3)
end

return helper_907fd9a8
