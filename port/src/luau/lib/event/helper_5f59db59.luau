--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00ff664c = require("@lib/event/helper_00ff664c")
local helper_2847e3af = require("@lib/event/helper_2847e3af")
local helper_ee6f9901 = require("@lib/event/helper_ee6f9901")

--- Helper function.
local function helper_5f59db59()
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
			helper_2847e3af(var1, player_chara)
		else
			at = 2
			helper_ee6f9901()
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

return helper_5f59db59
