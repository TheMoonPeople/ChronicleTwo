--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_69ae6360 = require("@lib/event/helper_69ae6360")
local helper_ed829512 = require("@lib/event/helper_ed829512")

--- Helper function.
local function helper_a97facd3(arg0: s32, arg1: s32)
	local player_chara: s32 = 0
	player_chara = event.GetControlChrid() or player_chara
	helper_69ae6360(player_chara, arg0, arg1)
	event.SetCrossfade(10)
	helper_ed829512(0, arg1, arg0, player_chara, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCrossfade(10)
end

return helper_a97facd3
