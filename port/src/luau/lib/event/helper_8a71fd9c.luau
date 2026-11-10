--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_8a71fd9c(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"あのさ、気が向いた時で\n良いから、釣りのコツってのを\n教えてくんねぇか。"
		)
	else
		event.open_message_window_2(0, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_8a71fd9c
