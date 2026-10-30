--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00ff664c = require("@lib/event/helper_00ff664c")
local helper_655d8f32 = require("@lib/event/helper_655d8f32")
local helper_9db735a8 = require("@lib/event/helper_9db735a8")

--- Helper function.
local function helper_3a2690f3()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.get_triggered_event_data_2(14) or var0
		var1 = event.get_triggered_event_data_2(13) or var1
		player_chara = event.get_player_character_slot() or player_chara
		if var0 <= 34 then
			at = 1
			helper_655d8f32(var1, player_chara)
		else
			at = 2
			helper_9db735a8()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_00ff664c()
			end
			return 0
		end
		return nil
	end)
end

return helper_3a2690f3
