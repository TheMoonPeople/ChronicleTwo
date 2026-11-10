--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")

--- Helper function.
local function helper_593bce69(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 1 then
			event.open_message_window_2(0, "お嬢さん、アッシに何かご用で？")
		else
			event.open_message_window_2(0, "坊ちゃん、「聖水」のことは、\nダンナ様にはナイショですよ。")
		end
	else
		event.open_message_window_2(
			0,
			"世界にはアッシの知らない植物が\nまだまだたくさんあるんですかねぇ。"
		)
	end
	helper_1c04a0eb(arg0, -1, 0, 0)
end

return helper_593bce69
