--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31152bd0 = require("@lib/event/helper_31152bd0")
local helper_3488ae95 = require("@lib/event/helper_3488ae95")
local helper_42250fcf = require("@lib/event/helper_42250fcf")

--- Helper function.
local function helper_09b10784()
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
			helper_31152bd0(var1, player_chara)
		else
			at = 2
			helper_42250fcf()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_3488ae95()
			end
			return 0
		end
		return nil
	end)
end

return helper_09b10784
