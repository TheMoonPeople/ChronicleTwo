--!strict
-- Shared event helper used by 78 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")

--- Helper function.
local function helper_17b6d01b()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.set_message_window_mode(0, 4)
			at = 1
			helper_75684dd8(0, 2000, 8, 0, 0)
			return 1
		end
		var1 = event.get_equipped_item(0, 0) or var1
		if var1 ~= 9 and var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
			event.set_message_window_mode(0, 4)
			at = 2
			helper_75684dd8(0, 2001, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(var1)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			return 1
		end
		return nil
	end)
end

return helper_17b6d01b
