--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_8788b892 = require("@lib/event/helper_8788b892")

--- Helper function.
local function helper_ff9b8cca(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			helper_8788b892(arg0, arg1)
			return
		end
		event.open_message_window_2(0, "[UNI00c9]vite les endroits\ntrop dangereux.")
	else
		event.open_message_window_2(
			0,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_ff9b8cca
